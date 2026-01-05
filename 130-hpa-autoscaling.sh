#!/bin/bash
help_hpa(){
    # --- HPA OPERATIONS (hpa_*) ---
    echo "Func: hpa_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies HPA YAML file"
    echo "Func: hpa_add_basic (\$ns, \$name, \$dp, \$min, \$max, [\$cpu]) | Act: [kubectl] autoscale deployment | Desc: Creates basic HPA"
    echo "Func: hpa_ls (\$ns, [\$args...]) | Act: [kubectl] get hpa | Desc: Lists HPAs"
    echo "Func: hpa_ls_all ([\$args...]) | Act: [kubectl] get hpa --all-namespaces | Desc: Lists HPAs in all namespaces"
    echo "Func: hpa_get_info (\$ns, \$name) | Act: [kubectl] get hpa -o wide | Desc: Gets wide HPA info"
    echo "Func: hpa_get_status (\$ns, \$name) | Act: [jsonpath] .status | Desc: Gets HPA status"
    echo "Func: hpa_get_metrics (\$ns, \$name) | Act: [jsonpath] currentMetrics | Desc: Gets average utilization metrics"
    echo "Func: hpa_get_events (\$ns, \$name) | Act: [kubectl] get events | Desc: Gets events for HPA"
    echo "Func: hpa_desc (\$ns, \$name) | Act: [kubectl] describe hpa | Desc: Describes HPA"
    echo "Func: hpa_get (\$ns, \$name) | Act: [kubectl] get hpa -o yaml | Desc: Gets HPA YAML"
    echo "Func: hpa_upd_cpu (\$ns, \$name, \$cpu) | Act: [kubectl] patch hpa | Desc: Updates target CPU utilization"
    echo "Func: hpa_upd_limits (\$ns, \$name, \$min, \$max) | Act: [kubectl] patch hpa | Desc: Updates HPA min/max replicas"
    echo "Func: hpa_del (\$ns, \$name) | Act: [kubectl] delete hpa | Desc: Deletes HPA"
    echo "Func: hpa_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if HPA exists"
    echo "Func: hpa_watch (\$ns, [\$name]) | Act: [kubectl] get hpa --watch | Desc: Watches HPAs"
    echo "Func: hpa_valid (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if HPA YAML is valid"
    echo "Func: hpa_test_load (\$ns, \$name, [\$dur]) | Act: [kubectl] run load-test | Desc: Stress tests HPA using busybox loop"
    echo "Func: hpa_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups HPA to YAML file"
    echo "Func: hpa_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores HPA from file"
    
    # --- VPA OPERATIONS (vpa_*) ---
    echo "Func: vpa_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies VPA YAML file"
    echo "Func: vpa_add_basic (\$ns, \$name, \$kind, \$target, \$mode) | Act: [cat] and [kubectl] apply | Desc: Creates basic VPA"
    echo "Func: vpa_ls (\$ns, [\$args...]) | Act: [kubectl] get vpa | Desc: Lists VPAs"
    echo "Func: vpa_ls_all ([\$args...]) | Act: [kubectl] get vpa --all-namespaces | Desc: Lists VPAs in all namespaces"
    echo "Func: vpa_get_info (\$ns, \$name) | Act: [kubectl] get vpa -o wide | Desc: Gets wide VPA info"
    echo "Func: vpa_get_recs (\$ns, \$name) | Act: [jsonpath] .status.recommendation | Desc: Gets VPA recommendations"
    echo "Func: vpa_desc (\$ns, \$name) | Act: [kubectl] describe vpa | Desc: Describes VPA"
    echo "Func: vpa_get (\$ns, \$name) | Act: [kubectl] get vpa -o yaml | Desc: Gets VPA YAML"
    echo "Func: vpa_upd_mode (\$ns, \$name, \$mode) | Act: [kubectl] patch vpa | Desc: Updates VPA updateMode"
    echo "Func: vpa_del (\$ns, \$name) | Act: [kubectl] delete vpa | Desc: Deletes VPA"
    echo "Func: vpa_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if VPA exists"
    echo "Func: vpa_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups VPA to YAML file"
    
    # --- CLUSTER AUTOSCALER OPERATIONS (ca_*) ---
    echo "Func: ca_add_basic (\$min, \$max, [\$group]) | Act: Manual setup recommended | Desc: Guidance for Cluster Autoscaler"
    echo "Func: ca_get_status () | Act: [kubectl] get configmap | Desc: Gets cluster-autoscaler-status info"
    echo "Func: ca_get_config (\$ns, \$cm) | Act: [kubectl] get configmap -o yaml | Desc: Gets CA configuration"
    
    # --- NODE STATS OPERATIONS (nodes_*) ---
    echo "Func: nodes_get_count () | Act: [wc] -l | Desc: Counts nodes in cluster"
    echo "Func: nodes_get_metrics () | Act: [kubectl] top nodes | Desc: Shows node resource usage"
}

# =============================================================================
# 🚀 HPA OPERATIONS (hpa_*)
# =============================================================================

# ===== hpa_add_f(file) =====
hpa_add_f() { $K8S apply -f "$1"; }

# ===== hpa_add_basic(ns, name, dp, min, max, [cpu]) =====
hpa_add_basic() { $K8S autoscale deployment "$3" -n "$1" --name="$2" --min="$4" --max="$5" --cpu-percent="${6:-50}"; }

# ===== hpa_ls(ns, [args...]) =====
hpa_ls() { $K8S get hpa -n "$1" "${@:2}"; }

# ===== hpa_ls_all([args...]) =====
hpa_ls_all() { $K8S get hpa --all-namespaces "$@"; }

# ===== hpa_get_info(ns, name) =====
hpa_get_info() { $K8S get hpa "$2" -n "$1" -o wide; }

# ===== hpa_get_status(ns, name) =====
hpa_get_status() { $K8S get hpa "$2" -n "$1" -o jsonpath='{.status}'; }

# ===== hpa_get_metrics(ns, name) =====
hpa_get_metrics() { $K8S get hpa "$2" -n "$1" -o custom-columns=NAME:.metadata.name,TARGETS:.status.currentMetrics[*].resource.current.averageUtilization; }

# ===== hpa_get_events(ns, name) =====
hpa_get_events() { $K8S get events -n "$1" --field-selector involvedObject.name="$2"; }

# ===== hpa_desc(ns, name) =====
hpa_desc() { $K8S describe hpa "$2" -n "$1"; }

# ===== hpa_get(ns, name) =====
hpa_get() { $K8S get hpa "$2" -n "$1" -o yaml; }

# ===== hpa_upd_cpu(ns, name, cpu) =====
hpa_upd_cpu() { $K8S patch hpa "$2" -n "$1" -p "{\"spec\":{\"targetCPUUtilizationPercentage\":$3}}"; }

# ===== hpa_upd_limits(ns, name, min, max) =====
hpa_upd_limits() { $K8S patch hpa "$2" -n "$1" -p "{\"spec\":{\"minReplicas\":$3,\"maxReplicas\":$4}}"; }

# ===== hpa_del(ns, name) =====
hpa_del() { $K8S delete hpa "$2" -n "$1"; }

# ===== hpa_exists(ns, name) =====
hpa_exists() { $K8S get hpa "$2" -n "$1" &>/dev/null; }

# ===== hpa_watch(ns, [name]) =====
hpa_watch() { [ -n "$2" ] && $K8S get hpa "$2" -n "$1" --watch || $K8S get hpa -n "$1" --watch; }

# ===== hpa_valid(ns, name) =====
hpa_valid() { $K8S get hpa "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== hpa_test_load(ns, name, [dur]) =====
hpa_test_load() { $K8S run load-test --rm -it --image=busybox -n "$1" -- /bin/sh -c "while true; do wget -q -O- http://$2; done"; }

# ===== hpa_backup(ns, name, [file]) =====
hpa_backup() { $K8S get hpa "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# ===== hpa_restore(file) =====
hpa_restore() { $K8S apply -f "$1"; }

# =============================================================================
# 📏 VPA OPERATIONS (vpa_*)
# =============================================================================

# ===== vpa_add_f(file) =====
vpa_add_f() { $K8S apply -f "$1"; }

# ===== vpa_add_basic(ns, name, kind, target, mode) =====
vpa_add_basic() {
    cat <<EOF | $K8S apply -f -
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata: { name: "$2", namespace: "$1" }
spec:
  targetRef: { apiVersion: "apps/v1", kind: "$3", name: "$4" }
  updatePolicy: { updateMode: "${5:-Auto}" }
EOF
}

# ===== vpa_ls(ns, [args...]) =====
vpa_ls() { $K8S get vpa -n "$1" "${@:2}"; }

# ===== vpa_ls_all([args...]) =====
vpa_ls_all() { $K8S get vpa --all-namespaces "$@"; }

# ===== vpa_get_info(ns, name) =====
vpa_get_info() { $K8S get vpa "$2" -n "$1" -o wide; }

# ===== vpa_get_recs(ns, name) =====
vpa_get_recs() { $K8S get vpa "$2" -n "$1" -o jsonpath='{.status.recommendation}'; }

# ===== vpa_desc(ns, name) =====
vpa_desc() { $K8S describe vpa "$2" -n "$1"; }

# ===== vpa_get(ns, name) =====
vpa_get() { $K8S get vpa "$2" -n "$1" -o yaml; }

# ===== vpa_upd_mode(ns, name, mode) =====
vpa_upd_mode() { $K8S patch vpa "$2" -n "$1" -p "{\"spec\":{\"updatePolicy\":{\"updateMode\":\"$3\"}}}"; }

# ===== vpa_del(ns, name) =====
vpa_del() { $K8S delete vpa "$2" -n "$1"; }

# ===== vpa_exists(ns, name) =====
vpa_exists() { $K8S get vpa "$2" -n "$1" &>/dev/null; }

# ===== vpa_backup(ns, name, [file]) =====
vpa_backup() { $K8S get vpa "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# =============================================================================
# 🧱 CLUSTER AUTOSCALER OPERATIONS (ca_*)
# =============================================================================

# ===== ca_add_basic(min, max, [group]) =====
ca_add_basic() { echo "ClusterAutoscaler setup usually manual or via cloud provider specific commands"; }

# ===== ca_get_status() =====
ca_get_status() { $K8S get configmap cluster-autoscaler-status -n kube-system -o yaml; }

# ===== ca_get_config(ns, cm) =====
ca_get_config() { $K8S get configmap "$2" -n "$1" -o yaml; }

# =============================================================================
# 📊 NODE STATS OPERATIONS (nodes_*)
# =============================================================================

# ===== nodes_get_count() =====
nodes_get_count() { $K8S get nodes --no-headers | wc -l; }

# ===== nodes_get_metrics() =====
nodes_get_metrics() { $K8S top nodes; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
hpa_add() { hpa_add_basic "$@"; }
vpa_add() { vpa_add_basic "$@"; }
hpa_stress_pod() { hpa_test_load "$@"; }
hpa_add_stress_pod() { hpa_test_load "$@"; }
hpa_info() { hpa_get_info "$@"; }
hpa_view() { hpa_get_status "$@"; }
hpa_metrics() { hpa_get_metrics "$@"; }
hpa_events() { hpa_get_events "$@"; }
vpa_info() { vpa_get_info "$@"; }
ca_add() { ca_add_basic "$@"; }
ca_view() { ca_get_status "$@"; }
nodes_count() { nodes_get_count "$@"; }
nodes_top() { nodes_get_metrics "$@"; }
as_report() { echo "Autoscaling report for $1..."; hpa_ls "$1"; vpa_ls "$1"; }
mt_check() { echo "Metrics server check..."; $K8S get deployments metrics-server -n kube-system; }
create_hpa() { hpa_add_basic "$@"; }
delete_hpa() { hpa_del "$@"; }
list_hpas() { hpa_ls "$@"; }
# hpa_exists() { hpa_exists "$@"; } # Match existing alias pattern
backup_hpa() { hpa_backup "$@"; }
create_vpa() { vpa_add_basic "$@"; }
delete_vpa() { vpa_del "$@"; }
list_vpas() { vpa_ls "$@"; }
# vpa_exists() { vpa_exists "$@"; }
backup_vpa() { vpa_backup "$@"; }
