#!/bin/bash
help_bk(){
    add_log_help "=== help_bk ==="
    add_log_help "Func: bk_res [bkresource] (\$ns, \$kind, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups specific resource to YAML file"
    add_log_help "Func: bk_res_cluster [bkresourcecluster] (\$kind, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups cluster-wide resource to YAML file"
    add_log_help "Func: bk_all_kind [bkallkind] (\$ns, \$kind, \$dir) | Act: [kubectl] get and loop | Desc: Backups all resources of a kind in namespace"
    add_log_help "Func: bk_all_cluster_kind [bkallclusterkind] (\$kind, \$dir) | Act: [kubectl] get and loop | Desc: Backups all cluster resources of a kind"
    add_log_help "Func: bk_ns [bkns] (\$ns, \$dir) | Act: Loop multiple bk_all_kind | Desc: Backups multiple common resource kinds for a namespace"
    add_log_help "Func: bk_ns_subset [bknssubset] (\$ns, \$dir, \$kinds_csv) | Act: Loop specific kinds | Desc: Backups selected types for a namespace"
    add_log_help "Func: bk_pack [bkpack] (\$dir, \$tar_file) | Act: [tar] czf | Desc: Compresses backup directory into archive"
    add_log_help "Func: bk_unpack [bkunpack] (\$archive, \$target) | Act: [tar] xzf | Desc: Decompress backup archive"
    add_log_help "Func: bk_encrypt [bkencrypt] (\$in, \$out, \$pass) | Act: [openssl] aes-256-cbc | Desc: Encrypts file using AES-256-CBC"
    add_log_help "Func: bk_decrypt [bkdecrypt] (\$in, \$out, \$pass) | Act: [openssl] -d aes-256-cbc | Desc: Decrypts file using AES-256-CBC"
    add_log_help "Func: bk_ls_dir [bklsdir] (\$dir) | Act: [ls] and [wc] | Desc: Summarizes backup directory contents"
    add_log_help "Func: bk_diff [bkdiff] (\$a, \$b) | Act: [diff] | Desc: Diffs two backup (YAML) files"
    add_log_help "Func: bk_sum_file [bksum] (\$file) | Act: [sha256sum] | Desc: Generates SHA256 checksum for backup"
    add_log_help "Func: bk_verify_file [bkverifyfile] (\$file) | Act: [kubectl] apply --dry-run | Desc: Verifies if backup YAML is valid for apply"
    add_log_help "Func: bk_verify_sum [bkverifysum] (\$file, \$expected) | Act: [sha256sum] check | Desc: Verifies file integrity using checksum"
    add_log_help "Func: bk_restore_file [bkrestorefile] (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Restores resource from backup file to namespace"
    add_log_help "Func: bk_restore_cluster [bkrestorecluster] (\$file) | Act: [kubectl] apply -f | Desc: Restores cluster-wide resource from backup"
    add_log_help "Func: bk_restore_dir [bkrestoredir] (\$ns, \$dir) | Act: Loop [kubectl] apply | Desc: Restores all YAML files in directory to namespace"
    add_log_help "Func: bk_restore_cluster_dir [bkrestoreclusterdir] (\$dir) | Act: Loop [kubectl] apply | Desc: Restores all cluster-wide YAMLs in directory"
    add_log_help "Func: bk_sim_res [bksim] (\$ns, \$kind, \$name) | Act: [kubectl] get -o yaml | Desc: Shows resource YAML without saving"
    add_log_help "Func: bk_sim_res_file [bksimfile] (\$file) | Act: [kubectl] apply --dry-run=server | Desc: Simulates restore from file"
    add_log_help "Func: snap_add [snapadd] (\$ns, \$pvc, \$snap, \$snapclass) | Act: [cat] and [kubectl] apply | Desc: Creates VolumeSnapshot"
    add_log_help "Func: snap_del [snapdel] (\$ns, \$snap) | Act: [kubectl] delete volumesnapshot | Desc: Deletes VolumeSnapshot"
    add_log_help "Func: snap_wait [snapwatch] (\$ns, \$snap, [\$timeout]) | Act: [kubectl] wait loop | Desc: Waits for VolumeSnapshot to be readyToUse"
    add_log_help "Func: snap_backup [snapbak] (\$ns, \$snap, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups VolumeSnapshot to YAML file"
    add_log_help "Func: bk_gen_cron [bkcronjob] (\$file, \$ns, \$cronjob, \$schedule, \$target_ns, \$kinds_csv, \$out_dir) | Act: [cat] > file | Desc: Generates backup CronJob template"
    add_log_help "Func: bk_gen_multi_cron [bkmulticronjob] (\$file, \$cronjob, \$schedule, \$namespaces_csv, \$kinds_csv, \$out_dir, \$ns) | Act: [cat] > file | Desc: Generates multi-namespace backup CronJob template"
}
# === CREATE / PUT OPERATIONS ===
snap_add() {
    add_log "=== Func: snap_add ==="
    local ns="$1"; local pvc="$2"; local snap="$3"; local sc="$4"
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata: { name: "$snap", namespace: "$ns" }
spec: { volumeSnapshotClassName: "$sc", source: { persistentVolumeClaimName: "$pvc" } }
EOF
}
snapadd() { snap_add "$@"; }
bk_gen_cron() {
    add_log "=== Func: bk_gen_cron ==="
    local f="$1"; local ns="$2"; local cj="$3"; local sch="$4"; local tns="$5"; local k="$6"; local out="$7"
    cat > "$f" <<EOF
apiVersion: batch/v1
kind: CronJob
metadata: { name: "$cj", namespace: "$ns" }
spec:
  schedule: "$sch"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: backup, image: bitnami/kubectl:latest, command: ["/bin/sh","-c"], args: ["mkdir -p $out && for k in \$(echo $k | tr ',' ' '); do kubectl get \$k -n $tns -o yaml > $out/\$k-\$(date +%s).yaml || true; done"]
EOF
    add_log "CronJob template saved to $f"
}
bkcronjob() { bk_gen_cron "$@"; }
bk_gen_multi_cron() {
    add_log "=== Func: bk_gen_multi_cron ==="
    local f="$1"; local cj="$2"; local sch="$3"; local nss="$4"; local k="$5"; local out="$6"; local ns="$7"
    cat > "$f" <<EOF
apiVersion: batch/v1
kind: CronJob
metadata: { name: "$cj", namespace: "$ns" }
spec:
  schedule: "$sch"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: backup, image: bitnami/kubectl:latest, command: ["/bin/sh","-c"], args: ["mkdir -p $out; for n in \$(echo $nss | tr ',' ' '); do for k in \$(echo $k | tr ',' ' '); do kubectl get \$k -n \$n -o yaml > $out/\$n-\$k-\$(date +%s).yaml || true; done; done"]
EOF
    add_log "Multi-namespace CronJob template saved to $f"
}
bkmulticronjob() { bk_gen_multi_cron "$@"; }
# === READ / DESCRIBE / LS / GET OPERATIONS ===
bk_ls_dir() {
    add_log "=== Func: bk_ls_dir ==="
    [ -d "$1" ] || { add_log "Directory $1 not found"; return 1; }
    add_log "📊 Backup directory $1 summary:"
    ls -1 "$1"/*.yaml 2>/dev/null | awk -F/ '{print $NF}' | awk -F'-' '{print $1}' | sort | uniq -c | awk '{printf "  %s: %s files\n", $2, $1}' | add_log
}
bklsdir() { bk_ls_dir "$@"; }
bk_diff() { 
    add_log "=== Func: bk_diff ==="
    diff -u "$1" "$2" | add_log; 
}
bkdiff() { bk_diff "$@"; }
bk_sum_file() { 
    add_log "=== Func: bk_sum_file ==="
    sha256sum "$1" | awk '{print $1}' | add_log; 
}
bksum() { bk_sum_file "$@"; }
# === UPDATE OPERATIONS ===
bk_encrypt() { 
    add_log "=== Func: bk_encrypt ==="
    openssl enc -aes-256-cbc -pbkdf2 -salt -in "$1" -out "$2" -pass pass:"$3" && add_log "Encrypted $1 to $2"; 
}
bkencrypt() { bk_encrypt "$@"; }
bk_decrypt() { 
    add_log "=== Func: bk_decrypt ==="
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$1" -out "$2" -pass pass:"$3" && add_log "Decrypted $1 to $2"; 
}
bkdecrypt() { bk_decrypt "$@"; }
# === DELETE OPERATIONS ===
snap_del() { 
    add_log "=== Func: snap_del ==="
    $K8S delete volumesnapshot "$2" -n "$1" | add_log; 
}
snapdel() { snap_del "$@"; }
# === EXISTS OPERATIONS ===
bk_verify_file() { 
    add_log "=== Func: bk_verify_file ==="
    if $K8S apply --dry-run=client -f "$1" &>/dev/null; then add_log "✅ $1 is valid"; return 0; else add_log "❌ $1 is NOT valid"; return 1; fi
}
bkverifyfile() { bk_verify_file "$@"; }
bk_verify_sum() {
    add_log "=== Func: bk_verify_sum ==="
    local actual=$(sha256sum "$1" | awk '{print $1}')
    if [ "$actual" = "$2" ]; then add_log "✅ Correct"; return 0; else add_log "❌ Mismatch: actual=$actual expected=$2"; return 1; fi
}
bkverifysum() { bk_verify_sum "$@"; }
# === MISC OPERATIONS ===
bk_res() { 
    add_log "=== Func: bk_res ==="
    $K8S get "$2" "$3" -n "$1" -o yaml > "$4" && add_log "Saved $2/$3 to $4"; 
}
bkresource() { bk_res "$@"; }
bk_res_cluster() { 
    add_log "=== Func: bk_res_cluster ==="
    $K8S get "$1" "$2" -o yaml > "$3" && add_log "Saved cluster-resource $1/$2 to $3"; 
}
bkresourcecluster() { bk_res_cluster "$@"; }
bk_all_kind() {
    add_log "=== Func: bk_all_kind ==="
    mkdir -p "$3"
    local items=$($K8S get "$2" -n "$1" --no-headers 2>/dev/null | awk '{print $1}')
    for i in $items; do local out="$3/$2-$i.yaml"; $K8S get "$2" "$i" -n "$1" -o yaml > "$out" 2>/dev/null && add_log "Saved $2/$i"; done
}
bkallkind() { bk_all_kind "$@"; }
bk_all_cluster_kind() {
    add_log "=== Func: bk_all_cluster_kind ==="
    mkdir -p "$2"
    local items=$($K8S get "$1" --no-headers 2>/dev/null | awk '{print $1}')
    for i in $items; do local out="$2/$1-$i.yaml"; $K8S get "$1" "$i" -o yaml > "$out" 2>/dev/null && add_log "Saved cluster-resource $1/$i"; done
}
bkallclusterkind() { bk_all_cluster_kind "$@"; }
bk_ns() {
    add_log "=== Func: bk_ns ==="
    local kinds="deploy svc cm secret ing sts ds jb cj pvc np rq lr hpa vpa"
    for k in $kinds; do bk_all_kind "$1" "$k" "$2"; done
}
bkns() { bk_ns "$@"; }
bk_ns_subset() {
    add_log "=== Func: bk_ns_subset ==="
    IFS=',' read -r -a karr <<< "$3"; for k in "${karr[@]}"; do bk_all_kind "$1" "$k" "$2"; done
}
bknssubset() { bk_ns_subset "$@"; }
bk_restore_file() { 
    add_log "=== Func: bk_restore_file ==="
    $K8S apply -n "$1" -f "$2" | add_log; 
}
bkrestorefile() { bk_restore_file "$@"; }
bk_restore_cluster() { 
    add_log "=== Func: bk_restore_cluster ==="
    $K8S apply -f "$1" | add_log; 
}
bkrestorecluster() { bk_restore_cluster "$@"; }
bk_restore_dir() { 
    add_log "=== Func: bk_restore_dir ==="
    for f in "$2"/*.yaml; do [ -f "$f" ] && add_log "Restoring $f" && $K8S apply -n "$1" -f "$f" | add_log || true; done
}
bkrestoredir() { bk_restore_dir "$@"; }
bk_restore_cluster_dir() { 
    add_log "=== Func: bk_restore_cluster_dir ==="
    for f in "$1"/*.yaml; do [ -f "$f" ] && add_log "Restoring cluster-resource $f" && $K8S apply -f "$f" | add_log || true; done
}
bkrestoreclusterdir() { bk_restore_cluster_dir "$@"; }
bk_pack() { 
    add_log "=== Func: bk_pack ==="
    tar -czf "$2" -C "$1" . && add_log "Packed $1 into $2"; 
}
bkpack() { bk_pack "$@"; }
bk_unpack() { 
    add_log "=== Func: bk_unpack ==="
    mkdir -p "$2" && tar -xzf "$1" -C "$2" && add_log "Unpacked $1 to $2"; 
}
bkunpack() { bk_unpack "$@"; }
bk_sim_res() { 
    add_log "=== Func: bk_sim_res ==="
    $K8S get "$2" "$3" -n "$1" -o yaml | add_log; 
}
bksim() { bk_sim_res "$@"; }
bk_sim_res_file() { 
    add_log "=== Func: bk_sim_res_file ==="
    $K8S apply --dry-run=client -f "$1" | add_log; 
}
bksimfile() { bk_sim_res_file "$@"; }
snap_wait() {
    add_log "=== Func: snap_wait ==="
    local t="${3:-300}"
    add_log "Wait up to ${t}s for snap/$2 ready..."
    timeout "$t" bash -c "until $K8S get volumesnapshot $2 -n $1 -o jsonpath='{.status.readyToUse}' | grep -q 'true'; do sleep 2; done" | add_log
}
snapwatch() { snap_wait "$@"; }
snap_backup() { 
    add_log "=== Func: snap_backup ==="
    $K8S get volumesnapshot "$2" -n "$1" -o yaml > "$3" && add_log "Saved VolumeSnapshot $2 to $3"; 
}
snapbak() { snap_backup "$@"; }
bk_dp() { bk_res "$1" deployment "$2" "$3"; }
bkdp() { bk_dp "$@"; }
bk_sv() { bk_res "$1" service "$2" "$3"; }
bksv() { bk_sv "$@"; }
bk_cm() { bk_res "$1" configmap "$2" "$3"; }
bkcm() { bk_cm "$@"; }
bk_sec() {
    add_log "=== Func: bk_sec ==="
    bk_res "$1" secret "$2" "$3"
    if [ "$4" == "decode" ]; then $K8S get secret "$2" -n "$1" -o json | jq -r '.data | to_entries[] | "# \(.key)=\(.value|@base64d)"' >> "$3"; add_log "Decoded data appended to $3"; fi
}
bksec() { bk_sec "$@"; }
bk_ing() { bk_res "$1" ingress "$2" "$3"; }
bking() { bk_ing "$@"; }
bk_sts() { bk_res "$1" statefulset "$2" "$3"; }
bksts() { bk_sts "$@"; }
bk_ds() { bk_res "$1" daemonset "$2" "$3"; }
bkds() { bk_ds "$@"; }
bk_jb() { bk_res "$1" job "$2" "$3"; }
bkjb() { bk_jb "$@"; }
bk_cj() { bk_res "$1" cronjob "$2" "$3"; }
bkcj() { bk_cj "$@"; }
bk_pvc() { bk_res "$1" pvc "$2" "$3"; }
bkpvc() { bk_pvc "$@"; }
bk_np() { bk_res "$1" networkpolicy "$2" "$3"; }
bknp() { bk_np "$@"; }
bk_rq() { bk_res "$1" resourcequota "$2" "$3"; }
bkrq() { bk_rq "$@"; }
bk_lr() { bk_res "$1" limitrange "$2" "$3"; }
bklr() { bk_lr "$@"; }
bk_hpa() { bk_res "$1" hpa "$2" "$3"; }
bkhpa() { bk_hpa "$@"; }
bk_vpa() { bk_res "$1" vpa "$2" "$3"; }
bkvpa() { bk_vpa "$@"; }
bk_node() { bk_res_cluster node "$1" "$2"; }
bknode() { bk_node "$@"; }
bk_crd() { bk_res_cluster crd "$1" "$2"; }
bkcrd() { bk_crd "$@"; }
bk_sc() { bk_res_cluster storageclass "$1" "$2"; }
bksc() { bk_sc "$@"; }
bk_cr() { bk_res_cluster clusterrole "$1" "$2"; }
bkclusterrole() { bk_cr "$@"; }
bk_cb() { bk_res_cluster clusterrolebinding "$1" "$2"; }
bkclusterrolebinding() { bk_cb "$@"; }
