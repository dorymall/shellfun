#!/bin/bash
help_pv(){
    add_log_help "=== help_pv ==="
    # --- PVC OPERATIONS ---
    add_log_help "Func: pvc_add_f [pvcaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies PVC YAML file"
    add_log_help "Func: pvc_add_basic [pvcadd] (\$ns, \$name, \$size, [\$mode], [\$sc]) | Act: [kubectl] create pvc | Desc: Creates basic PVC"
    add_log_help "Func: pvc_clone [pvcclone] (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones PVC to new namespace/name"
    add_log_help "Func: pvc_ls [pvclist] (\$ns, [\$args...]) | Act: [kubectl] get pvc | Desc: Lists PVCs"
    add_log_help "Func: pvc_ls_all [pvclsall] ([\$args...]) | Act: [kubectl] get pvc --all-namespaces | Desc: Lists PVCs in all namespaces"
    add_log_help "Func: pvc_ls_unbound [pvclsunbound] (\$ns) | Act: [grep] non-Bound | Desc: Lists PVCs not in Bound state"
    add_log_help "Func: pvc_get_status [pvcstatus] (\$ns, \$name) | Act: [jsonpath] .status.phase | Desc: Gets PVC phase"
    add_log_help "Func: pvc_get_cap [pvccapacity] (\$ns, \$name) | Act: [jsonpath] .status.capacity | Desc: Gets PVC capacity"
    add_log_help "Func: pvc_get_modes [pvcmodes] (\$ns, \$name) | Act: [jsonpath] .spec.accessModes | Desc: Gets PVC accessModes"
    add_log_help "Func: pvc_get_sc [pvcsc] (\$ns, \$name) | Act: [jsonpath] .spec.storageClassName | Desc: Gets PVC storageClassName"
    add_log_help "Func: pvc_get_pv [pvcpv] (\$ns, \$name) | Act: [jsonpath] .spec.volumeName | Desc: Gets bound PV name"
    add_log_help "Func: pvc_ls_pods [pvcpods] (\$ns, \$name) | Act: [jq] cross-reference | Desc: Finds pods using this PVC"
    add_log_help "Func: pvc_desc [pvcdesc] (\$ns, \$name) | Act: [kubectl] describe pvc | Desc: Describes PVC"
    add_log_help "Func: pvc_get [pvcget] (\$ns, \$name) | Act: [kubectl] get pvc -o yaml | Desc: Gets PVC YAML"
    add_log_help "Func: pvc_upd_sc [pvcupdateclass] (\$ns, \$name, \$sc) | Act: [kubectl] patch storageClassName | Desc: Updates PVC storageClassName"
    add_log_help "Func: pvc_upd_size [pvcupdatesize] (\$ns, \$name, \$size) | Act: [kubectl] patch size | Desc: Updates PVC requested storage size"
    add_log_help "Func: pvc_upd_annotate [pvcannotate] (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate pvc | Desc: Adds/updates PVC annotation"
    add_log_help "Func: pvc_del [pvcdelete] (\$ns, \$name) | Act: [kubectl] delete pvc | Desc: Deletes PVC"
    add_log_help "Func: pvc_exists [pvcexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if PVC exists"
    add_log_help "Func: pvc_watch [pvcwatch] (\$ns, [\$name]) | Act: [kubectl] get pvc --watch | Desc: Watches PVCs"
    add_log_help "Func: pvc_wait_bound [pvcwait] (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait --for=condition=bound | Desc: Waits for PVC to be bound"
    add_log_help "Func: pvc_valid [pvcvalid] (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if PVC YAML is valid"
    add_log_help "Func: pvc_backup [pvcbak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups PVC to YAML file"
    add_log_help "Func: pvc_restore [pvcrestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores PVC from file"
    # --- PV OPERATIONS ---
    add_log_help "Func: pv_add_f [pvaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies PV YAML file"
    add_log_help "Func: pv_add_hostpath [pvaddhostpath] (\$name, \$size, \$path, [\$mode]) | Act: [cat] and [kubectl] apply | Desc: Creates hostPath PV"
    add_log_help "Func: pv_add_nfs [pvaddnfs] (\$name, \$size, \$srv, \$path, [\$mode]) | Act: [cat] and [kubectl] apply | Desc: Creates NFS PV"
    add_log_help "Func: pv_ls [pvlist] ([\$args...]) | Act: [kubectl] get pv | Desc: Lists PVs"
    add_log_help "Func: pv_ls_avail [pvlsavailable] () | Act: [grep] Available | Desc: Lists Available PVs"
    add_log_help "Func: pv_ls_bound [pvlsbound] () | Act: [grep] Bound | Desc: Lists Bound PVs"
    add_log_help "Func: pv_ls_released [pvlsreleased] () | Act: [grep] Released | Desc: Lists Released PVs"
    add_log_help "Func: pv_get_status [pvstatus] (\$name) | Act: [jsonpath] .status.phase | Desc: Gets PV phase"
    add_log_help "Func: pv_get_cap [pvcapacity] (\$name) | Act: [jsonpath] .spec.capacity | Desc: Gets PV capacity"
    add_log_help "Func: pv_get_modes [pvmodes] (\$name) | Act: [jsonpath] .spec.accessModes | Desc: Gets PV accessModes"
    add_log_help "Func: pv_get_reclaim [pvreclaim] (\$name) | Act: [jsonpath] .spec.persistentVolumeReclaimPolicy | Desc: Gets PV reclaim policy"
    add_log_help "Func: pv_get_sc [pvsc] (\$name) | Act: [jsonpath] .spec.storageClassName | Desc: Gets PV storageClassName"
    add_log_help "Func: pv_get_claim [pvclaim] (\$name) | Act: [jsonpath] .spec.claimRef.name | Desc: Gets PV claim reference"
    add_log_help "Func: pv_desc [pvdesc] (\$name) | Act: [kubectl] describe pv | Desc: Describes PV"
    add_log_help "Func: pv_get [pvget] (\$name) | Act: [kubectl] get pv -o yaml | Desc: Gets PV YAML"
    add_log_help "Func: pv_upd_reclaim [pvupdatereclaim] (\$name, \$policy) | Act: [kubectl] patch reclaimPolicy | Desc: Updates PV reclaim policy"
    add_log_help "Func: pv_del [pvdelete] (\$name) | Act: [kubectl] delete pv | Desc: Deletes PV"
    add_log_help "Func: pv_exists [pvexists] (\$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if PV exists"
    add_log_help "Func: pv_watch [pvwatch] ([\$name]) | Act: [kubectl] get pv --watch | Desc: Watches PVs"
    add_log_help "Func: pv_wait_bound [pvwaitready] (\$name, [\$timeout]) | Act: [kubectl] wait --for=condition=bound | Desc: Waits for PV to be bound"
    add_log_help "Func: pv_valid [pvvalid] (\$name) | Act: [kubectl] apply --dry-run | Desc: Checks if PV YAML is valid"
    add_log_help "Func: pv_backup [pvbak] (\$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups PV to YAML file"
    add_log_help "Func: pv_restore [pvrestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores PV from file"
    # --- STORAGE CLASS OPERATIONS ---
    add_log_help "Func: sc_add_f [scaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies SC YAML file"
    add_log_help "Func: sc_add_basic [sccreate] (\$name, \$prov, [\$reclaim], [\$mode]) | Act: [cat] and [kubectl] apply | Desc: Creates StorageClass"
    add_log_help "Func: sc_ls [sclist] ([\$args...]) | Act: [kubectl] get sc | Desc: Lists StorageClasses"
    add_log_help "Func: sc_desc [scdesc] (\$name) | Act: [kubectl] describe sc | Desc: Describes StorageClass"
    add_log_help "Func: sc_get [scget] (\$name) | Act: [kubectl] get sc -o yaml | Desc: Gets StorageClass YAML"
    add_log_help "Func: sc_set_default [scsetdefault] (\$name) | Act: [kubectl] patch sc | Desc: Sets SC as cluster default"
    add_log_help "Func: sc_del [scdelete] (\$name) | Act: [kubectl] delete sc | Desc: Deletes StorageClass"
}
# === PVC OPERATIONS ===
pvc_add_f() { 
    add_log "=== Func: pvc_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
pvcaddf() { pvc_add_f "$@"; }
pvc_add_basic() {
    add_log "=== Func: pvc_add_basic ==="
    local ns="$1"; local n="$2"; local s="$3"; local m="${4:-ReadWriteOnce}"; local sc="$5"
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: v1
kind: PersistentVolumeClaim
metadata: { name: "$n", namespace: "$ns" }
spec: { accessModes: ["$m"], resources: { requests: { storage: "$s" } } ${sc:+, storageClassName: "$sc"} }
EOF
}
pvcadd() { pvc_add_basic "$@"; }
pvc_clone() {
    add_log "=== Func: pvc_clone ==="
    local sns="$1"; local n="$2"; local tns="$3"; local tn="${4:-$n}"
    $K8S get pvc "$n" -n "$sns" -o yaml | sed "s/namespace: $sns/namespace: $tns/; s/name: $n/name: $tn/" | $K8S apply -f - | add_log
}
pvcclone() { pvc_clone "$@"; }
pvc_ls() { 
    add_log "=== Func: pvc_ls ==="
    $K8S get pvc -n "$1" "${@:2}" | add_log; 
}
pvclist() { pvc_ls "$@"; }
pvc_ls_all() { 
    add_log "=== Func: pvc_ls_all ==="
    $K8S get pvc --all-namespaces "$@" | add_log; 
}
pvclsall() { pvc_ls_all "$@"; }
pvc_ls_unbound() { 
    add_log "=== Func: pvc_ls_unbound ==="
    $K8S get pvc -n "$1" | grep -v "Bound" | add_log; 
}
pvclsunbound() { pvc_ls_unbound "$@"; }
pvc_get_status() { 
    add_log "=== Func: pvc_get_status ==="
    $K8S get pvc "$2" -n "$1" -o jsonpath='{.status.phase}' | add_log; 
}
pvcstatus() { pvc_get_status "$@"; }
pvc_get_cap() { 
    add_log "=== Func: pvc_get_cap ==="
    $K8S get pvc "$2" -n "$1" -o jsonpath='{.status.capacity.storage}' | add_log; 
}
pvccapacity() { pvc_get_cap "$@"; }
pvc_get_modes() { 
    add_log "=== Func: pvc_get_modes ==="
    $K8S get pvc "$2" -n "$1" -o jsonpath='{.spec.accessModes[*] }' | add_log; 
}
pvcmodes() { pvc_get_modes "$@"; }
pvc_get_sc() { 
    add_log "=== Func: pvc_get_sc ==="
    $K8S get pvc "$2" -n "$1" -o jsonpath='{.spec.storageClassName}' | add_log; 
}
pvcsc() { pvc_get_sc "$@"; }
pvc_get_pv() { 
    add_log "=== Func: pvc_get_pv ==="
    $K8S get pvc "$2" -n "$1" -o jsonpath='{.spec.volumeName}' | add_log; 
}
pvcpv() { pvc_get_pv "$@"; }
pvc_ls_pods() {
    add_log "=== Func: pvc_ls_pods ==="
    $K8S get pods -n "$1" -o json | jq -r ".items[] | select(.spec.volumes[].persistentVolumeClaim.claimName == \"$2\") | .metadata.name" | add_log
}
pvcpods() { pvc_ls_pods "$@"; }
pvc_desc() { 
    add_log "=== Func: pvc_desc ==="
    $K8S describe pvc "$2" -n "$1" | add_log; 
}
pvcdesc() { pvc_desc "$@"; }
pvc_get() { 
    add_log "=== Func: pvc_get ==="
    $K8S get pvc "$2" -n "$1" -o yaml | add_log; 
}
pvcget() { pvc_get "$@"; }
pvc_upd_sc() { 
    add_log "=== Func: pvc_upd_sc ==="
    $K8S patch pvc "$2" -n "$1" -p "{\"spec\":{\"storageClassName\":\"$3\"}}" | add_log; 
}
pvcupdateclass() { pvc_upd_sc "$@"; }
pvc_upd_size() { 
    add_log "=== Func: pvc_upd_size ==="
    $K8S patch pvc "$2" -n "$1" -p "{\"spec\":{\"resources\":{\"requests\":{\"storage\":\"$3\"}}}}" | add_log; 
}
pvcupdatesize() { pvc_upd_size "$@"; }
pvc_upd_annotate() { 
    add_log "=== Func: pvc_upd_annotate ==="
    $K8S annotate pvc "$2" -n "$1" "$3=$4" --overwrite | add_log; 
}
pvcannotate() { pvc_upd_annotate "$@"; }
pvc_del() { 
    add_log "=== Func: pvc_del ==="
    $K8S delete pvc "$2" -n "$1" | add_log; 
}
pvcdelete() { pvc_del "$@"; }
pvc_exists() { 
    add_log "=== Func: pvc_exists ==="
    if $K8S get pvc "$2" -n "$1" &>/dev/null; then add_log "PVC $2 exists in namespace $1"; return 0; else add_log "PVC $2 NO found in namespace $1"; return 1; fi
}
pvcexists() { pvc_exists "$@"; }
pvc_watch() { 
    add_log "=== Func: pvc_watch ==="
    if [ -n "$2" ]; then $K8S get pvc "$2" -n "$1" --watch | add_log; else $K8S get pvc -n "$1" --watch | add_log; fi
}
pvcwatch() { pvc_watch "$@"; }
pvc_wait_bound() { 
    add_log "=== Func: pvc_wait_bound ==="
    $K8S wait --for=condition=bound pvc/"$2" -n "$1" --timeout="${3:-300}s" | add_log; 
}
pvcwait() { pvc_wait_bound "$@"; }
pvc_valid() { 
    add_log "=== Func: pvc_valid ==="
    $K8S get pvc "$2" -n "$1" -o yaml | $K8S apply --dry-run=server -f - | add_log; 
}
pvcvalid() { pvc_valid "$@"; }
pvc_backup() { 
    add_log "=== Func: pvc_backup ==="
    local f="${3:-$2-backup.yaml}"; $K8S get pvc "$2" -n "$1" -o yaml > "$f" && add_log "Saved to $f"; 
}
pvcbak() { pvc_backup "$@"; }
pvc_restore() { 
    add_log "=== Func: pvc_restore ==="
    $K8S apply -f "$1" | add_log; 
}
pvcrestore() { pvc_restore "$@"; }
# === PV OPERATIONS ===
pv_add_f() { 
    add_log "=== Func: pv_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
pvaddf() { pv_add_f "$@"; }
pv_add_hostpath() {
    add_log "=== Func: pv_add_hostpath ==="
    local n="$1"; local s="$2"; local p="$3"; local m="${4:-ReadWriteOnce}"
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: v1
kind: PersistentVolume
metadata: { name: "$n" }
spec: { capacity: { storage: "$s" }, accessModes: ["$m"], hostPath: { path: "$p" } }
EOF
}
pvaddhostpath() { pv_add_hostpath "$@"; }
pv_add_nfs() {
    add_log "=== Func: pv_add_nfs ==="
    local n="$1"; local s="$2"; local srv="$3"; local p="$4"; local m="${5:-ReadWriteOnce}"
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: v1
kind: PersistentVolume
metadata: { name: "$n" }
spec: { capacity: { storage: "$s" }, accessModes: ["$m"], nfs: { server: "$srv", path: "$p" } }
EOF
}
pvaddnfs() { pv_add_nfs "$@"; }
pv_ls() { 
    add_log "=== Func: pv_ls ==="
    $K8S get pv "$@" | add_log; 
}
pvlist() { pv_ls "$@"; }
pv_ls_avail() { 
    add_log "=== Func: pv_ls_avail ==="
    $K8S get pv | grep "Available" | add_log; 
}
pvlsavailable() { pv_ls_avail "$@"; }
pv_ls_bound() { 
    add_log "=== Func: pv_ls_bound ==="
    $K8S get pv | grep "Bound" | add_log; 
}
pvlsbound() { pv_ls_bound "$@"; }
pv_ls_released() { 
    add_log "=== Func: pv_ls_released ==="
    $K8S get pv | grep "Released" | add_log; 
}
pvlsreleased() { pv_ls_released "$@"; }
pv_get_status() { 
    add_log "=== Func: pv_get_status ==="
    $K8S get pv "$1" -o jsonpath='{.status.phase}' | add_log; 
}
pvstatus() { pv_get_status "$@"; }
pv_get_cap() { 
    add_log "=== Func: pv_get_cap ==="
    $K8S get pv "$1" -o jsonpath='{.spec.capacity.storage}' | add_log; 
}
pvcapacity() { pv_get_cap "$@"; }
pv_get_modes() { 
    add_log "=== Func: pv_get_modes ==="
    $K8S get pv "$1" -o jsonpath='{.spec.accessModes[*] }' | add_log; 
}
pvmodes() { pv_get_modes "$@"; }
pv_get_reclaim() { 
    add_log "=== Func: pv_get_reclaim ==="
    $K8S get pv "$1" -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' | add_log; 
}
pvreclaim() { pv_get_reclaim "$@"; }
pv_get_sc() { 
    add_log "=== Func: pv_get_sc ==="
    $K8S get pv "$1" -o jsonpath='{.spec.storageClassName}' | add_log; 
}
pvsc() { pv_get_sc "$@"; }
pv_get_claim() { 
    add_log "=== Func: pv_get_claim ==="
    $K8S get pv "$1" -o jsonpath='{.spec.claimRef.name}' | add_log; 
}
pvclaim() { pv_get_claim "$@"; }
pv_desc() { 
    add_log "=== Func: pv_desc ==="
    $K8S describe pv "$1" | add_log; 
}
pvdesc() { pv_desc "$@"; }
pv_get() { 
    add_log "=== Func: pv_get ==="
    $K8S get pv "$1" -o yaml | add_log; 
}
pvget() { pv_get "$@"; }
pv_upd_reclaim() { 
    add_log "=== Func: pv_upd_reclaim ==="
    $K8S patch pv "$1" -p "{\"spec\":{\"persistentVolumeReclaimPolicy\":\"$2\"}}" | add_log; 
}
pvupdatereclaim() { pv_upd_reclaim "$@"; }
pv_del() { 
    add_log "=== Func: pv_del ==="
    $K8S delete pv "$1" | add_log; 
}
pvdelete() { pv_del "$@"; }
pv_exists() { 
    add_log "=== Func: pv_exists ==="
    if $K8S get pv "$1" &>/dev/null; then add_log "PV $1 exists"; return 0; else add_log "PV $1 NOT found"; return 1; fi
}
pvexists() { pv_exists "$@"; }
pv_watch() { 
    add_log "=== Func: pv_watch ==="
    if [ -n "$1" ]; then $K8S get pv "$1" --watch | add_log; else $K8S get pv --watch | add_log; fi
}
pvwatch() { pv_watch "$@"; }
pv_wait_bound() { 
    add_log "=== Func: pv_wait_bound ==="
    $K8S wait --for=condition=bound pv/"$1" --timeout="${2:-300}s" | add_log; 
}
pvwaitready() { pv_wait_bound "$@"; }
pv_valid() { 
    add_log "=== Func: pv_valid ==="
    $K8S get pv "$1" -o yaml | $K8S apply --dry-run=server -f - | add_log; 
}
pvvalid() { pv_valid "$@"; }
pv_backup() { 
    add_log "=== Func: pv_backup ==="
    local f="${2:-$1-backup.yaml}"; $K8S get pv "$1" -o yaml > "$f" && add_log "Saved to $f"; 
}
pvbak() { pv_backup "$@"; }
pv_restore() { 
    add_log "=== Func: pv_restore ==="
    $K8S apply -f "$1" | add_log; 
}
pvrestore() { pv_restore "$@"; }
# === STORAGE CLASS OPERATIONS ===
sc_add_f() { 
    add_log "=== Func: sc_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
scaddf() { sc_add_f "$@"; }
sc_add_basic() {
    add_log "=== Func: sc_add_basic ==="
    local n="$1"; local p="$2"; local r="${3:-Delete}"; local m="${4:-Immediate}"
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata: { name: "$n" }
provisioner: "$p"
reclaimPolicy: "$r"
volumeBindingMode: "$m"
EOF
}
sccreate() { sc_add_basic "$@"; }
sc_ls() { 
    add_log "=== Func: sc_ls ==="
    $K8S get sc "$@" | add_log; 
}
sclist() { sc_ls "$@"; }
sc_desc() { 
    add_log "=== Func: sc_desc ==="
    $K8S describe sc "$1" | add_log; 
}
scdesc() { sc_desc "$@"; }
sc_get() { 
    add_log "=== Func: sc_get ==="
    $K8S get sc "$1" -o yaml | add_log; 
}
scget() { sc_get "$@"; }
sc_set_default() { 
    add_log "=== Func: sc_set_default ==="
    $K8S patch storageclass "$1" -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}' | add_log; 
}
scsetdefault() { sc_set_default "$@"; }
sc_del() { 
    add_log "=== Func: sc_del ==="
    $K8S delete sc "$1" | add_log; 
}
scdelete() { sc_del "$@"; }