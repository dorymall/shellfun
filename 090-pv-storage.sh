#!/bin/bash
help_pv(){
    # --- PVC OPERATIONS ---
    echo "Func: pvc_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies PVC YAML file"
    echo "Func: pvc_add_basic (\$ns, \$name, \$size, [\$mode], [\$sc]) | Act: [kubectl] create pvc | Desc: Creates basic PVC"
    echo "Func: pvc_clone (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones PVC to new namespace/name"
    echo "Func: pvc_ls (\$ns, [\$args...]) | Act: [kubectl] get pvc | Desc: Lists PVCs"
    echo "Func: pvc_ls_all ([\$args...]) | Act: [kubectl] get pvc --all-namespaces | Desc: Lists PVCs in all namespaces"
    echo "Func: pvc_ls_unbound (\$ns) | Act: [grep] non-Bound | Desc: Lists PVCs not in Bound state"
    echo "Func: pvc_get_status (\$ns, \$name) | Act: [jsonpath] .status.phase | Desc: Gets PVC phase"
    echo "Func: pvc_get_cap (\$ns, \$name) | Act: [jsonpath] .status.capacity | Desc: Gets PVC capacity"
    echo "Func: pvc_get_modes (\$ns, \$name) | Act: [jsonpath] .spec.accessModes | Desc: Gets PVC accessModes"
    echo "Func: pvc_get_sc (\$ns, \$name) | Act: [jsonpath] .spec.storageClassName | Desc: Gets PVC storageClassName"
    echo "Func: pvc_get_pv (\$ns, \$name) | Act: [jsonpath] .spec.volumeName | Desc: Gets bound PV name"
    echo "Func: pvc_ls_pods (\$ns, \$name) | Act: [jq] cross-reference | Desc: Finds pods using this PVC"
    echo "Func: pvc_desc (\$ns, \$name) | Act: [kubectl] describe pvc | Desc: Describes PVC"
    echo "Func: pvc_get (\$ns, \$name) | Act: [kubectl] get pvc -o yaml | Desc: Gets PVC YAML"
    echo "Func: pvc_upd_sc (\$ns, \$name, \$sc) | Act: [kubectl] patch storageClassName | Desc: Updates PVC storageClassName"
    echo "Func: pvc_upd_size (\$ns, \$name, \$size) | Act: [kubectl] patch size | Desc: Updates PVC requested storage size"
    echo "Func: pvc_upd_annotate (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate pvc | Desc: Adds/updates PVC annotation"
    echo "Func: pvc_del (\$ns, \$name) | Act: [kubectl] delete pvc | Desc: Deletes PVC"
    echo "Func: pvc_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if PVC exists"
    echo "Func: pvc_watch (\$ns, [\$name]) | Act: [kubectl] get pvc --watch | Desc: Watches PVCs"
    echo "Func: pvc_wait_bound (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait --for=condition=bound | Desc: Waits for PVC to be bound"
    echo "Func: pvc_valid (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if PVC YAML is valid"
    echo "Func: pvc_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups PVC to YAML file"
    echo "Func: pvc_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores PVC from file"

    # --- PV OPERATIONS ---
    echo "Func: pv_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies PV YAML file"
    echo "Func: pv_add_hostpath (\$name, \$size, \$path, [\$mode]) | Act: [cat] and [kubectl] apply | Desc: Creates hostPath PV"
    echo "Func: pv_add_nfs (\$name, \$size, \$srv, \$path, [\$mode]) | Act: [cat] and [kubectl] apply | Desc: Creates NFS PV"
    echo "Func: pv_ls ([\$args...]) | Act: [kubectl] get pv | Desc: Lists PVs"
    echo "Func: pv_ls_avail () | Act: [grep] Available | Desc: Lists Available PVs"
    echo "Func: pv_ls_bound () | Act: [grep] Bound | Desc: Lists Bound PVs"
    echo "Func: pv_ls_released () | Act: [grep] Released | Desc: Lists Released PVs"
    echo "Func: pv_get_status (\$name) | Act: [jsonpath] .status.phase | Desc: Gets PV phase"
    echo "Func: pv_get_cap (\$name) | Act: [jsonpath] .spec.capacity | Desc: Gets PV capacity"
    echo "Func: pv_get_modes (\$name) | Act: [jsonpath] .spec.accessModes | Desc: Gets PV accessModes"
    echo "Func: pv_get_reclaim (\$name) | Act: [jsonpath] .spec.persistentVolumeReclaimPolicy | Desc: Gets PV reclaim policy"
    echo "Func: pv_get_sc (\$name) | Act: [jsonpath] .spec.storageClassName | Desc: Gets PV storageClassName"
    echo "Func: pv_get_claim (\$name) | Act: [jsonpath] .spec.claimRef.name | Desc: Gets PV claim reference"
    echo "Func: pv_desc (\$name) | Act: [kubectl] describe pv | Desc: Describes PV"
    echo "Func: pv_get (\$name) | Act: [kubectl] get pv -o yaml | Desc: Gets PV YAML"
    echo "Func: pv_upd_reclaim (\$name, \$policy) | Act: [kubectl] patch reclaimPolicy | Desc: Updates PV reclaim policy"
    echo "Func: pv_del (\$name) | Act: [kubectl] delete pv | Desc: Deletes PV"
    echo "Func: pv_exists (\$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if PV exists"
    echo "Func: pv_watch ([\$name]) | Act: [kubectl] get pv --watch | Desc: Watches PVs"
    echo "Func: pv_wait_bound (\$name, [\$timeout]) | Act: [kubectl] wait --for=condition=bound | Desc: Waits for PV to be bound"
    echo "Func: pv_valid (\$name) | Act: [kubectl] apply --dry-run | Desc: Checks if PV YAML is valid"
    echo "Func: pv_backup (\$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups PV to YAML file"

    # --- STORAGECLASS OPERATIONS ---
    echo "Func: sc_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies SC YAML file"
    echo "Func: sc_add_basic (\$name, \$prov, [\$params]) | Act: [kubectl] create storageclass | Desc: Creates basic StorageClass"
    echo "Func: sc_ls ([\$args...]) | Act: [kubectl] get sc | Desc: Lists StorageClasses"
    echo "Func: sc_get_def () | Act: [jq] check annotation | Desc: Gets default StorageClass"
    echo "Func: sc_get_provisioner (\$name) | Act: [jsonpath] .provisioner | Desc: Gets SC provisioner"
    echo "Func: sc_get_params (\$name) | Act: [jsonpath] .parameters | Desc: Gets SC parameters"
    echo "Func: sc_ls_pvcs (\$name) | Act: [jq] cross-reference | Desc: Lists PVCs using this StorageClass"
    echo "Func: sc_desc (\$name) | Act: [kubectl] describe sc | Desc: Describes StorageClass"
    echo "Func: sc_get (\$name) | Act: [kubectl] get sc -o yaml | Desc: Gets StorageClass YAML"
    echo "Func: sc_upd_def (\$name) | Act: [kubectl] annotate sc | Desc: Sets StorageClass as default"
    echo "Func: sc_upd_annotate (\$name, \$key, \$val) | Act: [kubectl] annotate sc | Desc: Adds/updates SC annotation"
    echo "Func: sc_del (\$name) | Act: [kubectl] delete sc | Desc: Deletes StorageClass"
    echo "Func: sc_exists (\$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if StorageClass exists"
    echo "Func: sc_valid (\$name) | Act: [kubectl] apply --dry-run | Desc: Checks if SC YAML is valid"
    echo "Func: sc_backup (\$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups StorageClass to YAML file"

    # --- VOLUMESNAPSHOTCLASS OPERATIONS ---
    echo "Func: snc_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies SNC YAML file"
    echo "Func: snc_add_basic (\$name, \$driver, [\$policy]) | Act: [cat] and [kubectl] apply | Desc: Creates VolumeSnapshotClass"
    echo "Func: snc_ls ([\$args...]) | Act: [kubectl] get volumesnapshotclass | Desc: Lists VolumeSnapshotClasses"
    echo "Func: snc_get_def () | Act: [jq] check annotation | Desc: Gets default VolumeSnapshotClass"
    echo "Func: snc_desc (\$name) | Act: [kubectl] describe volumesnapshotclass | Desc: Describes VolumeSnapshotClass"
    echo "Func: snc_get (\$name) | Act: [kubectl] get volumesnapshotclass -o yaml | Desc: Gets VolumeSnapshotClass YAML"
    echo "Func: snc_del (\$name) | Act: [kubectl] delete volumesnapshotclass | Desc: Deletes VolumeSnapshotClass"

    # --- VOLUMESNAPSHOT OPERATIONS ---
    echo "Func: snap_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies Snapshot YAML file"
    echo "Func: snap_add_basic (\$ns, \$name, \$pvc, [\$class]) | Act: [cat] and [kubectl] apply | Desc: Creates VolumeSnapshot"
    echo "Func: snap_ls (\$ns, [\$args...]) | Act: [kubectl] get volumesnapshot | Desc: Lists VolumeSnapshots"
    echo "Func: snap_ls_all ([\$args...]) | Act: [kubectl] get volumesnapshots --all-namespaces | Desc: Lists VolumeSnapshots in all namespaces"
    echo "Func: snap_get_status (\$ns, \$name) | Act: [jsonpath] .status.readyToUse | Desc: Gets VolumeSnapshot ready status"
    echo "Func: snap_desc (\$ns, \$name) | Act: [kubectl] describe volumesnapshot | Desc: Describes VolumeSnapshot"
    echo "Func: snap_get (\$ns, \$name) | Act: [kubectl] get volumesnapshot -o yaml | Desc: Gets VolumeSnapshot YAML"
    echo "Func: snap_del (\$ns, \$name) | Act: [kubectl] delete volumesnapshot | Desc: Deletes VolumeSnapshot"
    echo "Func: snap_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if VolumeSnapshot exists"
    echo "Func: snap_wait_ready (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait --for=condition=ReadyToUse | Desc: Waits for VolumeSnapshot to be ready"
}

# =============================================================================
# 📦 PVC OPERATIONS (pvc_*)
# =============================================================================

# ===== pvc_add_f(file) =====
pvc_add_f() { $K8S apply -f "$1"; }

# ===== pvc_add_basic(ns, name, size, [mode], [sc]) =====
pvc_add_basic() {
    $K8S create pvc "$2" -n "$1" --storage-class="${5:-standard}" --access-modes="${4:-ReadWriteOnce}" --request="storage=$3"
}

# ===== pvc_clone(sns, name, tns, [tname]) =====
pvc_clone() {
    local tn="${4:-$2}"
    $K8S get pvc "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f -
}

# ===== pvc_ls(ns, [args...]) =====
pvc_ls() { $K8S get pvc -n "$1" "${@:2}"; }

# ===== pvc_ls_all([args...]) =====
pvc_ls_all() { $K8S get pvc --all-namespaces "$@"; }

# ===== pvc_ls_unbound(ns) =====
pvc_ls_unbound() { $K8S get pvc -n "$1" | grep -v "Bound"; }

# ===== pvc_get_status(ns, name) =====
pvc_get_status() { $K8S get pvc "$2" -n "$1" -o jsonpath='{.status.phase}'; }

# ===== pvc_get_cap(ns, name) =====
pvc_get_cap() { $K8S get pvc "$2" -n "$1" -o jsonpath='{.status.capacity.storage}'; }

# ===== pvc_get_modes(ns, name) =====
pvc_get_modes() { $K8S get pvc "$2" -n "$1" -o jsonpath='{.spec.accessModes}'; }

# ===== pvc_get_sc(ns, name) =====
pvc_get_sc() { $K8S get pvc "$2" -n "$1" -o jsonpath='{.spec.storageClassName}'; }

# ===== pvc_get_pv(ns, name) =====
pvc_get_pv() { $K8S get pvc "$2" -n "$1" -o jsonpath='{.spec.volumeName}'; }

# ===== pvc_ls_pods(ns, name) =====
pvc_ls_pods() {
    $K8S get pods -n "$1" -o json | jq -r ".items[] | select(.spec.volumes[].persistentVolumeClaim.claimName == \"$2\") | .metadata.name"
}

# ===== pvc_desc(ns, name) =====
pvc_desc() { $K8S describe pvc "$2" -n "$1"; }

# ===== pvc_get(ns, name) =====
pvc_get() { $K8S get pvc "$2" -n "$1" -o yaml; }

# ===== pvc_upd_sc(ns, name, sc) =====
pvc_upd_sc() { $K8S patch pvc "$2" -n "$1" -p "{\"spec\":{\"storageClassName\":\"$3\"}}"; }

# ===== pvc_upd_size(ns, name, size) =====
pvc_upd_size() { $K8S patch pvc "$2" -n "$1" -p "{\"spec\":{\"resources\":{\"requests\":{\"storage\":\"$3\"}}}}"; }

# ===== pvc_upd_annotate(ns, name, key, val) =====
pvc_upd_annotate() { $K8S annotate pvc "$2" -n "$1" "$3"="$4"; }

# ===== pvc_del(ns, name) =====
pvc_del() { $K8S delete pvc "$2" -n "$1"; }

# ===== pvc_exists(ns, name) =====
pvc_exists() { $K8S get pvc "$2" -n "$1" &>/dev/null; }

# ===== pvc_watch(ns, [name]) =====
pvc_watch() { [ -n "$2" ] && $K8S get pvc "$2" -n "$1" --watch || $K8S get pvc -n "$1" --watch; }

# ===== pvc_wait_bound(ns, name, [timeout]) =====
pvc_wait_bound() { $K8S wait --for=condition=bound pvc/"$2" -n "$1" --timeout="${3:-300}s" || timeout "${3:-300}" bash -c "until $K8S get pvc $2 -n $1 -o jsonpath='{.status.phase}' | grep -q 'Bound'; do sleep 2; done"; }

# ===== pvc_valid(ns, name) =====
pvc_valid() { $K8S get pvc "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== pvc_backup(ns, name, [file]) =====
pvc_backup() { $K8S get pvc "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# ===== pvc_restore(file) =====
pvc_restore() { $K8S apply -f "$1"; }

# =============================================================================
# 💾 PV OPERATIONS (pv_*)
# =============================================================================

# ===== pv_add_f(file) =====
pv_add_f() { $K8S apply -f "$1"; }

# ===== pv_add_hostpath(name, size, path, [mode]) =====
pv_add_hostpath() {
    cat <<EOF | $K8S apply -f -
apiVersion: v1
kind: PersistentVolume
metadata: { name: "$1" }
spec:
  capacity: { storage: "$2" }
  accessModes: [ "${4:-ReadWriteOnce}" ]
  hostPath: { path: "$3" }
EOF
}

# ===== pv_add_nfs(name, size, srv, path, [mode]) =====
pv_add_nfs() {
    cat <<EOF | $K8S apply -f -
apiVersion: v1
kind: PersistentVolume
metadata: { name: "$1" }
spec:
  capacity: { storage: "$2" }
  accessModes: [ "${5:-ReadWriteOnce}" ]
  nfs: { server: "$3", path: "$4" }
EOF
}

# ===== pv_ls([args...]) =====
pv_ls() { $K8S get pv "$@"; }

# ===== pv_ls_avail() =====
pv_ls_avail() { $K8S get pv | grep "Available"; }

# ===== pv_ls_bound() =====
pv_ls_bound() { $K8S get pv | grep "Bound"; }

# ===== pv_ls_released() =====
pv_ls_released() { $K8S get pv | grep "Released"; }

# ===== pv_get_status(name) =====
pv_get_status() { $K8S get pv "$1" -o jsonpath='{.status.phase}'; }

# ===== pv_get_cap(name) =====
pv_get_cap() { $K8S get pv "$1" -o jsonpath='{.spec.capacity.storage}'; }

# ===== pv_get_modes(name) =====
pv_get_modes() { $K8S get pv "$1" -o jsonpath='{.spec.accessModes}'; }

# ===== pv_get_reclaim(name) =====
pv_get_reclaim() { $K8S get pv "$1" -o jsonpath='{.spec.persistentVolumeReclaimPolicy}'; }

# ===== pv_get_sc(name) =====
pv_get_sc() { $K8S get pv "$1" -o jsonpath='{.spec.storageClassName}'; }

# ===== pv_get_claim(name) =====
pv_get_claim() { $K8S get pv "$1" -o jsonpath='{.spec.claimRef.name}'; }

# ===== pv_desc(name) =====
pv_desc() { $K8S describe pv "$1"; }

# ===== pv_get(name) =====
pv_get() { $K8S get pv "$1" -o yaml; }

# ===== pv_upd_reclaim(name, policy) =====
pv_upd_reclaim() { $K8S patch pv "$1" -p "{\"spec\":{\"persistentVolumeReclaimPolicy\":\"$2\"}}"; }

# ===== pv_del(name) =====
pv_del() { $K8S delete pv "$1"; }

# ===== pv_exists(name) =====
pv_exists() { $K8S get pv "$1" &>/dev/null; }

# ===== pv_watch([name]) =====
pv_watch() { [ -n "$1" ] && $K8S get pv "$1" --watch || $K8S get pv --watch; }

# ===== pv_wait_bound(name, [timeout]) =====
pv_wait_bound() { timeout "${2:-300}" bash -c "until $K8S get pv $1 -o jsonpath='{.status.phase}' | grep -q 'Bound'; do sleep 2; done"; }

# ===== pv_valid(name) =====
pv_valid() { $K8S get pv "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== pv_backup(name, [file]) =====
pv_backup() { $K8S get pv "$1" -o yaml > "${2:-$1.yaml}"; }

# =============================================================================
# 🏢 STORAGECLASS OPERATIONS (sc_*)
# =============================================================================

# ===== sc_add_f(file) =====
sc_add_f() { $K8S apply -f "$1"; }

# ===== sc_add_basic(name, prov, [params]) =====
sc_add_basic() {
    $K8S create storageclass "$1" --provisioner="$2" ${3:+--parameters=$3}
}

# ===== sc_ls([args...]) =====
sc_ls() { $K8S get sc "$@"; }

# ===== sc_get_def() =====
sc_get_def() { $K8S get sc -o json | jq -r '.items[] | select(.metadata.annotations["storageclass.kubernetes.io/is-default-class"] == "true") | .metadata.name'; }

# ===== sc_get_provisioner(name) =====
sc_get_provisioner() { $K8S get sc "$1" -o jsonpath='{.provisioner}'; }

# ===== sc_get_params(name) =====
sc_get_params() { $K8S get sc "$1" -o jsonpath='{.parameters}'; }

# ===== sc_ls_pvcs(name) =====
sc_ls_pvcs() { $K8S get pvc --all-namespaces -o json | jq -r ".items[] | select(.spec.storageClassName == \"$1\") | .metadata.name"; }

# ===== sc_desc(name) =====
sc_desc() { $K8S describe sc "$1"; }

# ===== sc_get(name) =====
sc_get() { $K8S get sc "$1" -o yaml; }

# ===== sc_upd_def(name) =====
sc_upd_def() {
    local old=$(sc_get_def)
    [ -n "$old" ] && $K8S annotate sc "$old" storageclass.kubernetes.io/is-default-class-
    $K8S annotate sc "$1" storageclass.kubernetes.io/is-default-class="true"
}

# ===== sc_upd_annotate(name, key, val) =====
sc_upd_annotate() { $K8S annotate sc "$1" "$2"="$3"; }

# ===== sc_del(name) =====
sc_del() { $K8S delete sc "$1"; }

# ===== sc_exists(name) =====
sc_exists() { $K8S get sc "$1" &>/dev/null; }

# ===== sc_valid(name) =====
sc_valid() { $K8S get sc "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== sc_backup(name, [file]) =====
sc_backup() { $K8S get sc "$1" -o yaml > "${2:-$1.yaml}"; }

# =============================================================================
# � VOLUMESNAPSHOTCLASS OPERATIONS (snc_*)
# =============================================================================

# ===== snc_add_f(file) =====
snc_add_f() { $K8S apply -f "$1"; }

# ===== snc_add_basic(name, driver, [policy]) =====
snc_add_basic() {
    cat <<EOF | $K8S apply -f -
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata: { name: "$1" }
driver: "$2"
deletionPolicy: "${3:-Delete}"
EOF
}

# ===== snc_ls([args...]) =====
snc_ls() { $K8S get volumesnapshotclass "$@"; }

# ===== snc_get_def() =====
snc_get_def() { $K8S get volumesnapshotclass -o json | jq -r '.items[] | select(.metadata.annotations["snapshot.storage.kubernetes.io/is-default-class"] == "true") | .metadata.name'; }

# ===== snc_desc(name) =====
snc_desc() { $K8S describe volumesnapshotclass "$1"; }

# ===== snc_get(name) =====
snc_get() { $K8S get volumesnapshotclass "$1" -o yaml; }

# ===== snc_del(name) =====
snc_del() { $K8S delete volumesnapshotclass "$1"; }

# =============================================================================
# 🎞️ VOLUMESNAPSHOT OPERATIONS (snap_*)
# =============================================================================

# ===== snap_add_f(file) =====
snap_add_f() { $K8S apply -f "$1"; }

# ===== snap_add_basic(ns, name, pvc, [class]) =====
snap_add_basic() {
    cat <<EOF | $K8S apply -f -
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata: { name: "$2", namespace: "$1" }
spec:
  volumeSnapshotClassName: "${4:-csi-hostpath-snapclass}"
  source: { persistentVolumeClaimName: "$3" }
EOF
}

# ===== snap_ls(ns, [args...]) =====
snap_ls() { $K8S get volumesnapshot -n "$1" "${@:2}"; }

# ===== snap_ls_all([args...]) =====
snap_ls_all() { $K8S get volumesnapshot --all-namespaces "$@"; }

# ===== snap_get_status(ns, name) =====
snap_get_status() { $K8S get volumesnapshot "$2" -n "$1" -o jsonpath='{.status.readyToUse}'; }

# ===== snap_desc(ns, name) =====
snap_desc() { $K8S describe volumesnapshot "$2" -n "$1"; }

# ===== snap_get(ns, name) =====
snap_get() { $K8S get volumesnapshot "$2" -n "$1" -o yaml; }

# ===== snap_del(ns, name) =====
snap_del() { $K8S delete volumesnapshot "$2" -n "$1"; }

# ===== snap_exists(ns, name) =====
snap_exists() { $K8S get volumesnapshot "$2" -n "$1" &>/dev/null; }

# ===== snap_wait_ready(ns, name, [timeout]) =====
snap_wait_ready() { timeout "${3:-300}" bash -c "until $K8S get volumesnapshot $2 -n $1 -o jsonpath='{.status.readyToUse}' | grep -q 'true'; do sleep 2; done"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
pvc_add() { pvc_add_basic "$@"; }
pv_add_hp() { pv_add_hostpath "$@"; }
pv_add_nfs() { pv_add_nfs "$@"; }
sc_add() { sc_add_basic "$@"; }
snap_add() { snap_add_basic "$@"; }
snc_add() { snc_add_basic "$@"; }
pvc_status() { pvc_get_status "$@"; }
pvc_used_pods() { pvc_ls_pods "$@"; }
pv_status() { pv_get_status "$@"; }
sc_get_default() { sc_get_def "$@"; }
sc_get_prov() { sc_get_provisioner "$@"; }
sc_used_pvcs() { sc_ls_pvcs "$@"; }
snap_status() { snap_get_status "$@"; }
snc_get_default() { snc_get_def "$@"; }
pvc_validate() { pvc_valid "$@"; }
pv_validate() { pv_valid "$@"; }
sc_validate() { sc_valid "$@"; }
create_pvc() { pvc_add_basic "$@"; }
delete_pvc() { pvc_del "$@"; }
list_pvcs() { pvc_ls "$@"; }
# pvc_exists() { pvc_exists "$@"; } # Already defined
describe_pvc() { pvc_desc "$@"; }
get_pvc_yaml() { pvc_get "$@"; }
watch_pvc() { pvc_watch "$@"; }
backup_pvc() { pvc_backup "$@"; }
restore_pvc() { pvc_restore "$@"; }
create_pv() { pv_add_hostpath "$@"; }
delete_pv() { pv_del "$@"; }
list_pvs() { pv_ls "$@"; }
# pv_exists() { pv_exists "$@"; } # Already defined
describe_pv() { pv_desc "$@"; }
get_pv_yaml() { pv_get "$@"; }
watch_pv() { pv_watch "$@"; }
backup_pv() { pv_backup "$@"; }
create_sc() { sc_add_basic "$@"; }
delete_sc() { sc_del "$@"; }
list_scs() { sc_ls "$@"; }
# sc_exists() { sc_exists "$@"; } # Already defined
describe_sc() { sc_desc "$@"; }
get_sc_yaml() { sc_get "$@"; }
backup_sc() { sc_backup "$@"; }