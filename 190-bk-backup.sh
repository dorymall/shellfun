#!/bin/bash
help_bk(){
    echo "Func: bk_res (\$ns, \$kind, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups specific resource to YAML file"
    echo "Func: bk_res_cluster (\$kind, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups cluster-wide resource to YAML file"
    echo "Func: bk_all_kind (\$ns, \$kind, \$dir) | Act: [kubectl] get and loop | Desc: Backups all resources of a kind in namespace"
    echo "Func: bk_all_cluster_kind (\$kind, \$dir) | Act: [kubectl] get and loop | Desc: Backups all cluster resources of a kind"
    echo "Func: bk_ns (\$ns, \$dir) | Act: Loop multiple bk_all_kind | Desc: Backups multiple common resource kinds for a namespace"
    echo "Func: bk_ns_subset (\$ns, \$dir, \$kinds_csv) | Act: Loop specific kinds | Desc: Backups selected types for a namespace"
    echo "Func: bk_pack (\$dir, \$tar_file) | Act: [tar] czf | Desc: Compresses backup directory into archive"
    echo "Func: bk_unpack (\$archive, \$target) | Act: [tar] xzf | Desc: Decompresses backup archive"
    echo "Func: bk_encrypt (\$in, \$out, \$pass) | Act: [openssl] aes-256-cbc | Desc: Encrypts file using AES-256-CBC"
    echo "Func: bk_decrypt (\$in, \$out, \$pass) | Act: [openssl] -d aes-256-cbc | Desc: Decrypts file using AES-256-CBC"
    echo "Func: bk_ls_dir (\$dir) | Act: [ls] and [wc] | Desc: Summarizes backup directory contents"
    echo "Func: bk_diff (\$a, \$b) | Act: [diff] | Desc: Diffs two backup (YAML) files"
    echo "Func: bk_sum_file (\$file) | Act: [sha256sum] | Desc: Generates SHA256 checksum for backup"
    echo "Func: bk_verify_file (\$file) | Act: [kubectl] apply --dry-run | Desc: Verifies if backup YAML is valid for apply"
    echo "Func: bk_verify_sum (\$file, \$expected) | Act: [sha256sum] check | Desc: Verifies file integrity using checksum"
    echo "Func: bk_restore_file (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Restores resource from backup file to namespace"
    echo "Func: bk_restore_cluster (\$file) | Act: [kubectl] apply -f | Desc: Restores cluster-wide resource from backup"
    echo "Func: bk_restore_dir (\$ns, \$dir) | Act: Loop [kubectl] apply | Desc: Restores all YAML files in directory to namespace"
    echo "Func: bk_restore_cluster_dir (\$dir) | Act: Loop [kubectl] apply | Desc: Restores all cluster-wide YAMLs in directory"
    echo "Func: bk_sim_res (\$ns, \$kind, \$name) | Act: [kubectl] get -o yaml | Desc: Shows resource YAML without saving"
    echo "Func: bk_sim_res_file (\$file) | Act: [kubectl] apply --dry-run=server | Desc: Simulates restore from file"
    echo "Func: snap_add (\$ns, \$pvc, \$snap, \$snapclass) | Act: [cat] and [kubectl] apply | Desc: Creates VolumeSnapshot"
    echo "Func: snap_del (\$ns, \$snap) | Act: [kubectl] delete volumesnapshot | Desc: Deletes VolumeSnapshot"
    echo "Func: snap_wait (\$ns, \$snap, [\$timeout]) | Act: [kubectl] wait loop | Desc: Waits for VolumeSnapshot to be readyToUse"
    echo "Func: snap_backup (\$ns, \$snap, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups VolumeSnapshot to YAML file"
    echo "Func: bk_gen_cron (\$file, \$ns, \$cronjob, \$schedule, \$target_ns, \$kinds_csv, \$out_dir) | Act: [cat] > file | Desc: Generates backup CronJob template"
    echo "Func: bk_gen_multi_cron (\$file, \$cronjob, \$schedule, \$namespaces_csv, \$kinds_csv, \$out_dir, \$ns) | Act: [cat] > file | Desc: Generates multi-namespace backup CronJob template"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== snap_add(ns, pvc, snap, snapclass) =====
snap_add() {
    local ns="$1"; local pvc="$2"; local snap="$3"; local sc="$4"
    cat <<EOF | $K8S apply -f -
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata: { name: "$snap", namespace: "$ns" }
spec: { volumeSnapshotClassName: "$sc", source: { persistentVolumeClaimName: "$pvc" } }
EOF
}

# ===== bk_gen_cron(file, ns, cronjob, schedule, target_ns, kinds_csv, out_dir) =====
bk_gen_cron() {
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
}

# ===== bk_gen_multi_cron(file, cronjob, schedule, namespaces_csv, kinds_csv, out_dir, ns) =====
bk_gen_multi_cron() {
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
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== bk_ls_dir(dir) =====
bk_ls_dir() {
    [ -d "$1" ] || return 1
    echo "📊 Backup directory $1 summary:"
    ls -1 "$1"/*.yaml 2>/dev/null | awk -F/ '{print $NF}' | awk -F'-' '{print $1}' | sort | uniq -c | awk '{printf "  %s: %s files\n", $2, $1}'
}

# ===== bk_diff(a, b) =====
bk_diff() { diff -u "$1" "$2"; }

# ===== bk_sum_file(file) =====
bk_sum_file() { sha256sum "$1" | awk '{print $1}'; }

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== bk_encrypt(in, out, pass) =====
bk_encrypt() { openssl enc -aes-256-cbc -pbkdf2 -salt -in "$1" -out "$2" -pass pass:"$3"; }

# ===== bk_decrypt(in, out, pass) =====
bk_decrypt() { openssl enc -d -aes-256-cbc -pbkdf2 -in "$1" -out "$2" -pass pass:"$3"; }

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== snap_del(ns, snap) =====
snap_del() { $K8S delete volumesnapshot "$2" -n "$1"; }

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== bk_verify_file(file) =====
bk_verify_file() { $K8S apply --dry-run=client -f "$1" &>/dev/null; }

# ===== bk_verify_sum(file, expected) =====
bk_verify_sum() {
    local actual=$(bk_sum_file "$1")
    [ "$actual" = "$2" ] && echo "✅ Correct" || echo "❌ Mismatch: $actual"
}

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== bk_res(ns, kind, name, file) =====
bk_res() { $K8S get "$2" "$3" -n "$1" -o yaml > "$4"; }

# ===== bk_res_cluster(kind, name, file) =====
bk_res_cluster() { $K8S get "$1" "$2" -o yaml > "$3"; }

# ===== bk_all_kind(ns, kind, dir) =====
bk_all_kind() {
    mkdir -p "$3"
    local items=$($K8S get "$2" -n "$1" --no-headers 2>/dev/null | awk '{print $1}')
    for i in $items; do local out="$3/$2-$i.yaml"; $K8S get "$2" "$i" -n "$1" -o yaml > "$out" 2>/dev/null; done
}

# ===== bk_all_cluster_kind(kind, dir) =====
bk_all_cluster_kind() {
    mkdir -p "$2"
    local items=$($K8S get "$1" --no-headers 2>/dev/null | awk '{print $1}')
    for i in $items; do local out="$2/$1-$i.yaml"; $K8S get "$1" "$i" -o yaml > "$out" 2>/dev/null; done
}

# ===== bk_ns(ns, dir) =====
bk_ns() {
    local kinds="deploy svc cm secret ing sts ds jb cj pvc np rq lr hpa vpa"
    for k in $kinds; do bk_all_kind "$1" "$k" "$2"; done
}

# ===== bk_ns_subset(ns, dir, kinds) =====
bk_ns_subset() {
    IFS=',' read -r -a karr <<< "$3"
    for k in "${karr[@]}"; do bk_all_kind "$1" "$k" "$2"; done
}

# ===== bk_restore_file(ns, file) =====
bk_restore_file() { $K8S apply -n "$1" -f "$2"; }

# ===== bk_restore_cluster(file) =====
bk_restore_cluster() { $K8S apply -f "$1"; }

# ===== bk_restore_dir(ns, dir) =====
bk_restore_dir() { for f in "$2"/*.yaml; do [ -f "$f" ] && $K8S apply -n "$1" -f "$f" || true; done; }

# ===== bk_restore_cluster_dir(dir) =====
bk_restore_cluster_dir() { for f in "$1"/*.yaml; do [ -f "$f" ] && $K8S apply -f "$f" || true; done; }

# ===== bk_pack(dir, tar) =====
bk_pack() { tar -czf "$2" -C "$1" .; }

# ===== bk_unpack(archive, target) =====
bk_unpack() { mkdir -p "$2" && tar -xzf "$1" -C "$2"; }

# ===== bk_sim_res(ns, kind, name) =====
bk_sim_res() { $K8S get "$2" "$3" -n "$1" -o yaml; }

# ===== bk_sim_res_file(file) =====
bk_sim_res_file() { $K8S apply --dry-run=client -f "$1"; }

# ===== snap_wait(ns, snap, [timeout]) =====
snap_wait() {
    local t="${3:-300}"
    timeout "$t" bash -c "until $K8S get volumesnapshot $2 -n $1 -o jsonpath='{.status.readyToUse}' | grep -q 'true'; do sleep 2; done"
}

# ===== snap_backup(ns, snap, file) =====
snap_backup() { $K8S get volumesnapshot "$2" -n "$1" -o yaml > "$3"; }

# Specific backups
bk_dp() { bk_res "$1" deployment "$2" "$3"; }
bk_sv() { bk_res "$1" service "$2" "$3"; }
bk_cm() { bk_res "$1" configmap "$2" "$3"; }
bk_sec() {
    bk_res "$1" secret "$2" "$3"
    [ "$4" == "decode" ] && $K8S get secret "$2" -n "$1" -o json | jq -r '.data | to_entries[] | "# \(.key)=\(.value|@base64d)"' >> "$3"
}
bk_ing() { bk_res "$1" ingress "$2" "$3"; }
bk_sts() { bk_res "$1" statefulset "$2" "$3"; }
bk_ds() { bk_res "$1" daemonset "$2" "$3"; }
bk_jb() { bk_res "$1" job "$2" "$3"; }
bk_cj() { bk_res "$1" cronjob "$2" "$3"; }
bk_pvc() { bk_res "$1" pvc "$2" "$3"; }
bk_np() { bk_res "$1" networkpolicy "$2" "$3"; }
bk_rq() { bk_res "$1" resourcequota "$2" "$3"; }
bk_lr() { bk_res "$1" limitrange "$2" "$3"; }
bk_hpa() { bk_res "$1" hpa "$2" "$3"; }
bk_vpa() { bk_res "$1" vpa "$2" "$3"; }
bk_node() { bk_res_cluster node "$1" "$2"; }
bk_crd() { bk_res_cluster crd "$1" "$2"; }
bk_sc() { bk_res_cluster storageclass "$1" "$2"; }
bk_cr() { bk_res_cluster clusterrole "$1" "$2"; }
bk_cb() { bk_res_cluster clusterrolebinding "$1" "$2"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
ensure_directory() { [ -d "$1" ] || mkdir -p "$1"; }
timestamp() { date -u +"%Y%m%dT%H%M%SZ"; }
sanitize_name() { echo "$1" | tr -c 'a-zA-Z0-9._-\n' '_'; }
backup_resource() { bk_res "$@"; }
backup_cluster_resource() { bk_res_cluster "$@"; }
backup_all_of_kind() { bk_all_kind "$@"; }
backup_all_cluster_kind() { bk_all_cluster_kind "$@"; }
backup_namespace() { bk_ns "$@"; }
backup_namespace_subset() { bk_ns_subset "$@"; }
verify_backup_file() { bk_verify_file "$@"; }
summarize_backup_directory() { bk_ls_dir "$@"; }
diff_backup_files() { bk_diff "$@"; }
restore_resource_from_file() { bk_restore_file "$@"; }
restore_cluster_resource_from_file() { bk_restore_cluster "$@"; }
restore_directory() { bk_restore_dir "$@"; }
restore_cluster_directory() { bk_restore_cluster_dir "$@"; }
package_backup_directory() { bk_pack "$@"; }
extract_backup_archive() { bk_unpack "$@"; }
encrypt_backup() { bk_encrypt "$@"; }
decrypt_backup() { bk_decrypt "$@"; }
checksum_file() { bk_sum_file "$@"; }
verify_checksum() { bk_verify_sum "$@"; }
simulate_backup_resource() { bk_sim_res "$@"; }
simulate_restore_file() { bk_sim_res_file "$@"; }
backup_deployment() { bk_dp "$@"; }
backup_service() { bk_sv "$@"; }
backup_configmap() { bk_cm "$@"; }
backup_secret() { bk_sec "$@"; }
backup_ingress() { bk_ing "$@"; }
backup_statefulset() { bk_sts "$@"; }
backup_daemonset() { bk_ds "$@"; }
backup_job() { bk_jb "$@"; }
backup_cronjob() { bk_cj "$@"; }
backup_pvc() { bk_pvc "$@"; }
backup_network_policy() { bk_np "$@"; }
backup_resource_quota() { bk_rq "$@"; }
backup_limit_range() { bk_lr "$@"; }
backup_hpa() { bk_hpa "$@"; }
backup_vpa() { bk_vpa "$@"; }
backup_node() { bk_node "$@"; }
backup_crd() { bk_crd "$@"; }
backup_storage_class() { bk_sc "$@"; }
backup_cluster_role() { bk_cr "$@"; }
backup_cluster_role_binding() { bk_cb "$@"; }
create_volume_snapshot() { snap_add "$@"; }
delete_volume_snapshot() { snap_del "$@"; }
wait_for_volume_snapshot_ready() { snap_wait "$@"; }
backup_volume_snapshot() { snap_backup "$@"; }
generate_backup_cronjob() { bk_gen_cron "$@"; }
generate_multi_namespace_backup_cronjob() { bk_gen_multi_cron "$@"; }
