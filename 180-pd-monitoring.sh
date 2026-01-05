#!/bin/bash
help_mon(){
    # --- CLUSTER PRE-FLIGHT / STATUS (cluster_*) ---
    echo "Func: cluster_get_version () | Act: [kubectl] version | Desc: Gets short cluster version"
    echo "Func: cluster_ls_nodes ([\$args...]) | Act: [kubectl] get nodes | Desc: Lists nodes with optional arguments"
    echo "Func: cluster_sum_capacity () | Act: [jsonpath] and [jq] | Desc: Shows node capacities and versions"
    
    # --- NODE MONITORING (nodes_*) ---
    echo "Func: nodes_get_status (\$node) | Act: [kubectl] describe node | Desc: Describes specific node"
    
    # --- NAMESPACE MONITORING (ns_*) ---
    echo "Func: ns_get_summary (\$ns) | Act: Summarize all resources | Desc: Gets summary for all resources in namespace"
    echo "Func: ns_get_usage (\$ns) | Act: [kubectl] top pod | Desc: Shows resource usage in namespace"
    echo "Func: ns_get_events (\$ns, [\$field_selector]) | Act: [kubectl] get events | Desc: Lists namespace events"
    echo "Func: ns_get_warnings (\$ns, [\$since]) | Act: [kubectl] get events (Warning) | Desc: Lists namespace warning events"
    
    # --- CONTROLLER HEALTH (dp_*, ss_*, ds_*) ---
    echo "Func: dp_get_status (\$ns, \$deployment) | Act: [jsonpath] .status | Desc: Shows deployment replicas health"
    echo "Func: ss_get_status (\$ns, \$sts) | Act: [jsonpath] .status | Desc: Shows statefulset replicas health"
    echo "Func: ds_get_status (\$ns, \$ds) | Act: [jsonpath] .status | Desc: Shows daemonset replicas health"
    
    # --- POD MONITORING (pd_*) ---
    echo "Func: pd_get_metrics (\$ns) | Act: [kubectl] top pod | Desc: Shows resource usage for pods in namespace"
    echo "Func: pd_get_metrics_label (\$ns, \$selector) | Act: [kubectl] top pod -l | Desc: Shows metrics for pods matching label"
    echo "Func: pd_get_logs_label (\$ns, \$selector, [\$tail]) | Act: [kubectl] logs -l | Desc: Tails logs for pods matching label"
    echo "Func: pd_ls_failing (\$ns) | Act: [grep] failing status | Desc: Finds pods with CrashLoopBackOff/Error/Failed"
    echo "Func: pd_ls_slow (\$ns, [\$threshold]) | Act: [awk] filter by age | Desc: Finds pods not Running for too long"
    echo "Func: pd_ls_high_restarts (\$ns, [\$min]) | Act: [awk] filter by restarts | Desc: Finds pods with high restart count"
    echo "Func: pd_ls_no_readiness (\$ns) | Act: [jq] filter probes | Desc: Finds pods without readiness probes"
    echo "Func: pd_ls_no_liveness (\$ns) | Act: [jq] filter probes | Desc: Finds pods without liveness probes"
    echo "Func: pd_ls_image (\$ns, \$pattern) | Act: [kubectl] get pods -o wide | Desc: Finds pods using specific image"
}

# =============================================================================
# 🌍 CLUSTER PRE-FLIGHT / STATUS (cluster_*)
# =============================================================================

# ===== cluster_get_version() =====
cluster_get_version() { $K8S version --short; }

# ===== cluster_ls_nodes([args...]) =====
cluster_ls_nodes() {
    [ $# -eq 0 ] && echo "📋 Nodes:" && $K8S get nodes -o wide || $K8S get nodes "$@";
}

# ===== cluster_sum_capacity() =====
cluster_sum_capacity() {
    $K8S get nodes -o custom-columns=NAME:.metadata.name,CPU:.status.capacity.cpu,MEM:.status.capacity.memory,CPU_ALLOC:.status.allocatable.cpu,MEM_ALLOC:.status.allocatable.memory,VER:.status.nodeInfo.kubeletVersion
}

# =============================================================================
# 🖥️ NODE MONITORING (nodes_*)
# =============================================================================

# ===== nodes_get_status(node) =====
nodes_get_status() { $K8S describe node "$1"; }

# =============================================================================
# 📂 NAMESPACE MONITORING (ns_*)
# =============================================================================

# ===== ns_get_summary(ns) =====
ns_get_summary() {
    echo "📂 Namespace $1 Summary:"
    $K8S get all -n "$1"
    echo "🧩 ConfigMaps & Secrets:"
    $K8S get cm,secret -n "$1" 2>/dev/null
}

# ===== ns_get_usage(ns) =====
ns_get_usage() { $K8S top pod -n "$1" 2>/dev/null; }

# ===== ns_get_events(ns, [field_selector]) =====
ns_get_events() {
    [ -n "$2" ] && $K8S get events -n "$1" --field-selector "$2" --sort-by=.lastTimestamp || $K8S get events -n "$1" --sort-by=.lastTimestamp
}

# ===== ns_get_warnings(ns, [since]) =====
ns_get_warnings() { $K8S get events -n "$1" --field-selector type=Warning --sort-by=.lastTimestamp; }

# =============================================================================
# 🛠️ CONTROLLER HEALTH (dp_*, ss_*, ds_*)
# =============================================================================

# ===== dp_get_status(ns, deployment) =====
dp_get_status() { $K8S get deployment "$2" -n "$1" -o custom-columns=NAME:.metadata.name,DES:.spec.replicas,UPD:.status.updatedReplicas,RDY:.status.readyReplicas,AVAIL:.status.availableReplicas; }

# ===== ss_get_status(ns, sts) =====
ss_get_status() { $K8S get sts "$2" -n "$1" -o custom-columns=NAME:.metadata.name,DES:.spec.replicas,RDY:.status.readyReplicas,CUR:.status.currentReplicas,UPD:.status.updatedReplicas; }

# ===== ds_get_status(ns, ds) =====
ds_get_status() { $K8S get ds "$2" -n "$1" -o custom-columns=NAME:.metadata.name,DES:.status.desiredNumberScheduled,CUR:.status.currentNumberScheduled,RDY:.status.numberReady,AVAIL:.status.numberAvailable; }

# =============================================================================
# 🩺 POD MONITORING (pd_*)
# =============================================================================

# ===== pd_get_metrics(ns) =====
pd_get_metrics() { $K8S top pod -n "$1" 2>/dev/null; }

# ===== pd_get_metrics_label(ns, selector) =====
pd_get_metrics_label() { $K8S top pod -n "$1" -l "$2" 2>/dev/null; }

# ===== pd_get_logs_label(ns, selector, [tail]) =====
pd_get_logs_label() {
    local opt="${3:+--tail=$3}"
    for p in $($K8S get pods -n "$1" -l "$2" -o name); do echo "--- $(basename $p) ---"; $K8S logs "$p" -n "$1" $opt || true; done
}

# ===== pd_ls_failing(ns) =====
pd_ls_failing() { $K8S get pods -n "$1" --no-headers | grep -E "CrashLoopBackOff|Error|Failed" || true; }

# ===== pd_ls_slow(ns, [threshold]) =====
pd_ls_slow() {
    local t="${2:-300}"
    $K8S get pods -n "$1" --no-headers | awk -v th="$t" '{
        age=$5; unit=substr(age,length(age)); val=substr(age,1,length(age)-1);
        secs=(unit=="m")?val*60:(unit=="h")?val*3600:(unit=="d")?val*86400:val;
        if($3!="Running" && secs>th) print $1 "\t" $3 "\t" age;
    }'
}

# ===== pd_ls_high_restarts(ns, [min]) =====
pd_ls_high_restarts() {
    local th="${2:-3}"
    $K8S get pods -n "$1" -o jsonpath='{range .items[*]}{.metadata.name} {range .status.containerStatuses[*]}{.restartCount}{" "}{end}{"\n"}{end}' | awk -v t="$th" '{r=0; for(i=2;i<=NF;i++) r+=$i; if(r>=t) print $1 "\t" r}'
}

# ===== pd_ls_no_readiness(ns) =====
pd_ls_no_readiness() { $K8S get pods -n "$1" -o json | jq -r '.items[] | select(all(.spec.containers[]?; has("readinessProbe") | not)) | .metadata.name'; }

# ===== pd_ls_no_liveness(ns) =====
pd_ls_no_liveness() { $K8S get pods -n "$1" -o json | jq -r '.items[] | select(all(.spec.containers[]?; has("livenessProbe") | not)) | .metadata.name'; }

# ===== pd_ls_image(ns, pattern) =====
pd_ls_image() {
    $K8S get pods -n "$1" -o jsonpath='{range .items[*]}{.metadata.name} {range .spec.containers[*]}{.image}{" "}{end}{"\n"}{end}' | awk -v pat="$2" '{for(i=2;i<=NF;i++) if(index($i,pat)>0) {print $1; break}}'
}

# ========== BACKWARD COMPATIBILITY ALIASES ==========
get_cluster_version() { cluster_get_version "$@"; }
get_cluster_nodes() { cluster_ls_nodes "$@"; }
get_node_status() { nodes_get_status "$@"; }
summarize_cluster_capacity() { cluster_sum_capacity "$@"; }
get_namespace_summary() { ns_get_summary "$@"; }
get_namespace_resource_usage() { ns_get_usage "$@"; }
get_namespace_events() { ns_get_events "$@"; }
get_recent_warnings() { ns_get_warnings "$@"; }
get_pod_metrics_in_namespace() { pd_get_metrics "$@"; }
get_pod_metrics_by_selector() { pd_get_metrics_label "$@"; }
get_deployment_status() { dp_get_status "$@"; }
get_statefulset_status() { ss_get_status "$@"; }
get_daemonset_status_brief() { ds_get_status "$@"; }
get_namespace_logs_by_selector() { pd_get_logs_label "$@"; }
get_failing_pods() { pd_ls_failing "$@"; }
get_slow_starting_pods() { pd_ls_slow "$@"; }
get_pods_with_high_restarts() { pd_ls_high_restarts "$@"; }
get_pods_without_readiness_probe() { pd_ls_no_readiness "$@"; }
get_pods_without_liveness_probe() { pd_ls_no_liveness "$@"; }
get_pods_using_image() { pd_ls_image "$@"; }
