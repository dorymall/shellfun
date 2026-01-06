#!/bin/bash
help_hpa(){
    add_log_help "=== help_hpa ==="
    # --- HPA OPERATIONS (hpa_*) ---
    add_log_help "Func: hpa_add_f [hpaaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies HPA YAML file"
    add_log_help "Func: hpa_add_basic [hpaadd] (\$ns, \$name, \$dp, \$min, \$max, [\$cpu]) | Act: [kubectl] autoscale deployment | Desc: Creates basic HPA"
    add_log_help "Func: hpa_ls [hpals] (\$ns, [\$args...]) | Act: [kubectl] get hpa | Desc: Lists HPAs"
    add_log_help "Func: hpa_ls_all [hpalsall] ([\$args...]) | Act: [kubectl] get hpa --all-namespaces | Desc: Lists HPAs in all namespaces"
    add_log_help "Func: hpa_get_info [hpainfo] (\$ns, \$name) | Act: [kubectl] get hpa -o wide | Desc: Gets wide HPA info"
    add_log_help "Func: hpa_get_status [hpastatus] (\$ns, \$name) | Act: [jsonpath] .status | Desc: Gets HPA status"
    add_log_help "Func: hpa_get_metrics [hpamtr] (\$ns, \$name) | Act: [jsonpath] currentMetrics | Desc: Gets average utilization metrics"
    add_log_help "Func: hpa_get_events [hpaevents] (\$ns, \$name) | Act: [kubectl] get events | Desc: Gets events for HPA"
    add_log_help "Func: hpa_desc [hpadesc] (\$ns, \$name) | Act: [kubectl] describe hpa | Desc: Describes HPA"
    add_log_help "Func: hpa_get [hpaget] (\$ns, \$name) | Act: [kubectl] get hpa -o yaml | Desc: Gets HPA YAML"
    add_log_help "Func: hpa_upd_cpu [hpaupdcpu] (\$ns, \$name, \$cpu) | Act: [kubectl] patch hpa | Desc: Updates target CPU utilization"
    add_log_help "Func: hpa_upd_limits [hpaupdlimits] (\$ns, \$name, \$min, \$max) | Act: [kubectl] patch hpa | Desc: Updates HPA min/max replicas"
    add_log_help "Func: hpa_del [hpadel] (\$ns, \$name) | Act: [kubectl] delete hpa | Desc: Deletes HPA"
    add_log_help "Func: hpa_exists [hpaexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if HPA exists"
    add_log_help "Func: hpa_watch [hpawatch] (\$ns, [\$name]) | Act: [kubectl] get hpa --watch | Desc: Watches HPAs"
    add_log_help "Func: hpa_valid [hpavalid] (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if HPA YAML is valid"
    add_log_help "Func: hpa_test_load [hpaload] (\$ns, \$name, [\$dur]) | Act: [kubectl] run load-test | Desc: Stress tests HPA using busybox loop"
    add_log_help "Func: hpa_backup [hpabak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups HPA to YAML file"
    add_log_help "Func: hpa_restore [hparestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores HPA from file"
    
    # --- VPA OPERATIONS (vpa_*) ---
    add_log_help "Func: vpa_add_f [vpaaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies VPA YAML file"
    add_log_help "Func: vpa_add_basic [vpaadd] (\$ns, \$name, \$kind, \$target, \$mode) | Act: [cat] and [kubectl] apply | Desc: Creates basic VPA"
    add_log_help "Func: vpa_ls [vpals] (\$ns, [\$args...]) | Act: [kubectl] get vpa | Desc: Lists VPAs"
    add_log_help "Func: vpa_ls_all [vpalsall] ([\$args...]) | Act: [kubectl] get vpa --all-namespaces | Desc: Lists VPAs in all namespaces"
    add_log_help "Func: vpa_get_info [vpainfo] (\$ns, \$name) | Act: [kubectl] get vpa -o wide | Desc: Gets wide VPA info"
    add_log_help "Func: vpa_get_recs [vparecs] (\$ns, \$name) | Act: [jsonpath] .status.recommendation | Desc: Gets VPA recommendations"
    add_log_help "Func: vpa_desc [vpadesc] (\$ns, \$name) | Act: [kubectl] describe vpa | Desc: Describes VPA"
    add_log_help "Func: vpa_get [vpaget] (\$ns, \$name) | Act: [kubectl] get vpa -o yaml | Desc: Gets VPA YAML"
    add_log_help "Func: vpa_upd_mode [vpaupdmode] (\$ns, \$name, \$mode) | Act: [kubectl] patch vpa | Desc: Updates VPA updateMode"
    add_log_help "Func: vpa_del [vpadel] (\$ns, \$name) | Act: [kubectl] delete vpa | Desc: Deletes VPA"
    add_log_help "Func: vpa_exists [vpaexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if VPA exists"
    add_log_help "Func: vpa_backup [vpabak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups VPA to YAML file"
    
    # --- CLUSTER AUTOSCALER OPERATIONS (ca_*) ---
    add_log_help "Func: ca_add_basic [caadd] (\$min, \$max, [\$group]) | Act: Manual setup recommended | Desc: Guidance for Cluster Autoscaler"
    add_log_help "Func: ca_get_status [castatus] () | Act: [kubectl] get configmap | Desc: Gets cluster-autoscaler-status info"
    add_log_help "Func: ca_get_config [caconfig] (\$ns, \$cm) | Act: [kubectl] get configmap -o yaml | Desc: Gets CA configuration"
    
    # --- NODE STATS OPERATIONS (nodes_*) ---
    add_log_help "Func: nodes_get_count [ndcount] () | Act: [wc] -l | Desc: Counts nodes in cluster"
    add_log_help "Func: nodes_get_metrics [ndmetrics] () | Act: [kubectl] top nodes | Desc: Shows node resource usage"
}
# === HPA OPERATIONS (hpa_*) ===
hpa_add_f() { 
    add_log "=== Func: hpa_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
hpaaddf() { hpa_add_f "$@"; }
hpa_add_basic() { 
    add_log "=== Func: hpa_add_basic ==="
    $K8S autoscale deployment "$3" -n "$1" --name="$2" --min="$4" --max="$5" --cpu-percent="${6:-50}" | add_log; 
}
hpaadd() { hpa_add_basic "$@"; }
hpa_ls() { 
    add_log "=== Func: hpa_ls ==="
    $K8S get hpa -n "$1" "${@:2}" | add_log; 
}
hpals() { hpa_ls "$@"; }
hpa_ls_all() { 
    add_log "=== Func: hpa_ls_all ==="
    $K8S get hpa --all-namespaces "$@" | add_log; 
}
hpalsall() { hpa_ls_all "$@"; }
hpa_get_info() { 
    add_log "=== Func: hpa_get_info ==="
    $K8S get hpa "$2" -n "$1" -o wide | add_log; 
}
hpainfo() { hpa_get_info "$@"; }
hpa_get_status() { 
    add_log "=== Func: hpa_get_status ==="
    $K8S get hpa "$2" -n "$1" -o jsonpath='{.status}' | add_log; 
}
hpastatus() { hpa_get_status "$@"; }
hpa_get_metrics() { 
    add_log "=== Func: hpa_get_metrics ==="
    $K8S get hpa "$2" -n "$1" -o custom-columns=NAME:.metadata.name,TARGETS:.status.currentMetrics[*].resource.current.averageUtilization | add_log; 
}
hpamtr() { hpa_get_metrics "$@"; }
hpa_get_events() { 
    add_log "=== Func: hpa_get_events ==="
    $K8S get events -n "$1" --field-selector involvedObject.name="$2" | add_log; 
}
hpaevents() { hpa_get_events "$@"; }
hpa_desc() { 
    add_log "=== Func: hpa_desc ==="
    $K8S describe hpa "$2" -n "$1" | add_log; 
}
hpadesc() { hpa_desc "$@"; }
hpa_get() { 
    add_log "=== Func: hpa_get ==="
    $K8S get hpa "$2" -n "$1" -o yaml | add_log; 
}
hpaget() { hpa_get "$@"; }
hpa_upd_cpu() { 
    add_log "=== Func: hpa_upd_cpu ==="
    $K8S patch hpa "$2" -n "$1" -p "{\"spec\":{\"targetCPUUtilizationPercentage\":$3}}" | add_log; 
}
hpaupdcpu() { hpa_upd_cpu "$@"; }
hpa_upd_limits() { 
    add_log "=== Func: hpa_upd_limits ==="
    $K8S patch hpa "$2" -n "$1" -p "{\"spec\":{\"minReplicas\":$3,\"maxReplicas\":$4}}" | add_log; 
}
hpaupdlimits() { hpa_upd_limits "$@"; }
hpa_del() { 
    add_log "=== Func: hpa_del ==="
    $K8S delete hpa "$2" -n "$1" | add_log; 
}
hpadel() { hpa_del "$@"; }
hpa_exists() { 
    add_log "=== Func: hpa_exists ==="
    if $K8S get hpa "$2" -n "$1" &>/dev/null; then add_log "HPA $2 exists in namespace $1"; return 0; else add_log "HPA $2 does NOT exist in namespace $1"; return 1; fi
}
hpaexists() { hpa_exists "$@"; }
hpa_watch() { 
    add_log "=== Func: hpa_watch ==="
    if [ -n "$2" ]; then $K8S get hpa "$2" -n "$1" --watch | add_log; else $K8S get hpa -n "$1" --watch | add_log; fi
}
hpawatch() { hpa_watch "$@"; }
hpa_valid() { 
    add_log "=== Func: hpa_valid ==="
    $K8S get hpa "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f - | add_log; 
}
hpavalid() { hpa_valid "$@"; }
hpa_test_load() { 
    add_log "=== Func: hpa_test_load ==="
    $K8S run load-test --rm -it --image=busybox -n "$1" -- /bin/sh -c "while true; do wget -q -O- http://$2; done" | add_log; 
}
hpaload() { hpa_test_load "$@"; }
hpa_backup() { 
    add_log "=== Func: hpa_backup ==="
    $K8S get hpa "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
hpabak() { hpa_backup "$@"; }
hpa_restore() { 
    add_log "=== Func: hpa_restore ==="
    $K8S apply -f "$1" | add_log; 
}
hparestore() { hpa_restore "$@"; }
# === VPA OPERATIONS (vpa_*) ===
vpa_add_f() { 
    add_log "=== Func: vpa_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
vpaaddf() { vpa_add_f "$@"; }
vpa_add_basic() {
    add_log "=== Func: vpa_add_basic ==="
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata: { name: "$2", namespace: "$1" }
spec:
  targetRef: { apiVersion: "apps/v1", kind: "$3", name: "$4" }
  updatePolicy: { updateMode: "${5:-Auto}" }
EOF
}
vpaadd() { vpa_add_basic "$@"; }
vpa_ls() { 
    add_log "=== Func: vpa_ls ==="
    $K8S get vpa -n "$1" "${@:2}" | add_log; 
}
vpals() { vpa_ls "$@"; }
vpa_ls_all() { 
    add_log "=== Func: vpa_ls_all ==="
    $K8S get vpa --all-namespaces "$@" | add_log; 
}
vpalsall() { vpa_ls_all "$@"; }
vpa_get_info() { 
    add_log "=== Func: vpa_get_info ==="
    $K8S get vpa "$2" -n "$1" -o wide | add_log; 
}
vpainfo() { vpa_get_info "$@"; }
vpa_get_recs() { 
    add_log "=== Func: vpa_get_recs ==="
    $K8S get vpa "$2" -n "$1" -o jsonpath='{.status.recommendation}' | add_log; 
}
vparecs() { vpa_get_recs "$@"; }
vpa_desc() { 
    add_log "=== Func: vpa_desc ==="
    $K8S describe vpa "$2" -n "$1" | add_log; 
}
vpadesc() { vpa_desc "$@"; }
vpa_get() { 
    add_log "=== Func: vpa_get ==="
    $K8S get vpa "$2" -n "$1" -o yaml | add_log; 
}
vpaget() { vpa_get "$@"; }
vpa_upd_mode() { 
    add_log "=== Func: vpa_upd_mode ==="
    $K8S patch vpa "$2" -n "$1" -p "{\"spec\":{\"updatePolicy\":{\"updateMode\":\"$3\"}}}" | add_log; 
}
vpaupdmode() { vpa_upd_mode "$@"; }
vpa_del() { 
    add_log "=== Func: vpa_del ==="
    $K8S delete vpa "$2" -n "$1" | add_log; 
}
vpadel() { vpa_del "$@"; }
vpa_exists() { 
    add_log "=== Func: vpa_exists ==="
    if $K8S get vpa "$2" -n "$1" &>/dev/null; then add_log "VPA $2 exists in namespace $1"; return 0; else add_log "VPA $2 does NOT exist in namespace $1"; return 1; fi
}
vpaexists() { vpa_exists "$@"; }
vpa_backup() { 
    add_log "=== Func: vpa_backup ==="
    $K8S get vpa "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
vpabak() { vpa_backup "$@"; }
# === CLUSTER AUTOSCALER OPERATIONS (ca_*) ===
ca_add_basic() { 
    add_log "=== Func: ca_add_basic ==="
    add_log "ClusterAutoscaler setup usually manual or via cloud provider specific commands"; 
}
caadd() { ca_add_basic "$@"; }
ca_get_status() { 
    add_log "=== Func: ca_get_status ==="
    $K8S get configmap cluster-autoscaler-status -n kube-system -o yaml | add_log; 
}
castatus() { ca_get_status "$@"; }
ca_get_config() { 
    add_log "=== Func: ca_get_config ==="
    $K8S get configmap "$2" -n "$1" -o yaml | add_log; 
}
caconfig() { ca_get_config "$@"; }
# === NODE STATS OPERATIONS (nodes_*) ===
nodes_get_count() { 
    add_log "=== Func: nodes_get_count ==="
    $K8S get nodes --no-headers | wc -l | add_log; 
}
ndcount() { nodes_get_count "$@"; }
nodes_get_metrics() { 
    add_log "=== Func: nodes_get_metrics ==="
    $K8S top nodes | add_log; 
}
ndmetrics() { nodes_get_metrics "$@"; }
