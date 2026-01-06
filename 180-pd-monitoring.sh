#!/bin/bash
help_mon(){
    add_log_help "=== help_mon ==="
    # --- CLUSTER PRE-FLIGHT / STATUS (cluster_*) ---
    add_log_help "Func: cluster_get_version [clversion] () | Act: [kubectl] version | Desc: Gets short cluster version"
    add_log_help "Func: cluster_ls_nodes [clnodes] ([\$args...]) | Act: [kubectl] get nodes | Desc: Lists nodes with optional arguments"
    add_log_help "Func: cluster_sum_capacity [clcapacity] () | Act: [jsonpath] and [jq] | Desc: Shows node capacities and versions"
    
    # --- NODE MONITORING (nodes_*) ---
    add_log_help "Func: nodes_get_status [ndstatus] (\$node) | Act: [kubectl] describe node | Desc: Describes specific node"
    
    # --- NAMESPACE MONITORING (ns_*) ---
    add_log_help "Func: ns_get_summary [nssummary] (\$ns) | Act: Summarize all resources | Desc: Gets summary for all resources in namespace"
    add_log_help "Func: ns_get_usage [nsusage] (\$ns) | Act: [kubectl] top pod | Desc: Shows resource usage in namespace"
    add_log_help "Func: ns_get_events [nsevents] (\$ns, [\$field_selector]) | Act: [kubectl] get events | Desc: Lists namespace events"
    add_log_help "Func: ns_get_warnings [nswarnings] (\$ns, [\$since]) | Act: [kubectl] get events (Warning) | Desc: Lists namespace warning events"
    
    # --- CONTROLLER HEALTH (dp_*, ss_*, ds_*) ---
    add_log_help "Func: dp_get_status [dpstatus] (\$ns, \$deployment) | Act: [jsonpath] .status | Desc: Shows deployment replicas health"
    add_log_help "Func: ss_get_status [ssstatus] (\$ns, \$sts) | Act: [jsonpath] .status | Desc: Shows statefulset replicas health"
    add_log_help "Func: ds_get_status [dsstatus] (\$ns, \$ds) | Act: [jsonpath] .status | Desc: Shows daemonset replicas health"
    
    # --- POD MONITORING (pd_*) ---
    add_log_help "Func: pd_get_metrics [pdmetrics] (\$ns) | Act: [kubectl] top pod | Desc: Shows resource usage for pods in namespace"
    add_log_help "Func: pd_get_metrics_label [pdmetricslabel] (\$ns, \$selector) | Act: [kubectl] top pod -l | Desc: Shows metrics for pods matching label"
    add_log_help "Func: pd_get_logs_label [pdlogslabel] (\$ns, \$selector, [\$tail]) | Act: [kubectl] logs -l | Desc: Tails logs for pods matching label"
    add_log_help "Func: pd_ls_failing [pdfailing] (\$ns) | Act: [grep] failing status | Desc: Finds pods with CrashLoopBackOff/Error/Failed"
    add_log_help "Func: pd_ls_slow [pdslow] (\$ns, [\$threshold]) | Act: [awk] filter by age | Desc: Finds pods not Running for too long"
    add_log_help "Func: pd_ls_high_restarts [pdhighrestart] (\$ns, [\$min]) | Act: [awk] filter by restarts | Desc: Finds pods with high restart count"
    add_log_help "Func: pd_ls_no_readiness [pdnoreadiness] (\$ns) | Act: [jq] filter probes | Desc: Finds pods without readiness probes"
    add_log_help "Func: pd_ls_no_liveness [pdnoliveness] (\$ns) | Act: [jq] filter probes | Desc: Finds pods without liveness probes"
    add_log_help "Func: pd_ls_image [pdlsimage] (\$ns, \$pattern) | Act: [kubectl] get pods -o wide | Desc: Finds pods using specific image"
}
# === CLUSTER PRE-FLIGHT / STATUS (cluster_*) ===
cluster_get_version() { 
    add_log "=== Func: cluster_get_version ==="
    $K8S version --short | add_log; 
}
clversion() { cluster_get_version "$@"; }
cluster_ls_nodes() {
    add_log "=== Func: cluster_ls_nodes ==="
    if [ $# -eq 0 ]; then add_log "📋 Nodes:"; $K8S get nodes -o wide | add_log; else $K8S get nodes "$@"; fi
}
clnodes() { cluster_ls_nodes "$@"; }
cluster_sum_capacity() {
    add_log "=== Func: cluster_sum_capacity ==="
    $K8S get nodes -o custom-columns=NAME:.metadata.name,CPU:.status.capacity.cpu,MEM:.status.capacity.memory,CPU_ALLOC:.status.allocatable.cpu,MEM_ALLOC:.status.allocatable.memory,VER:.status.nodeInfo.kubeletVersion | add_log
}
clcapacity() { cluster_sum_capacity "$@"; }
# === NODE MONITORING (nodes_*) ===
nodes_get_status() { 
    add_log "=== Func: nodes_get_status ==="
    $K8S describe node "$1" | add_log; 
}
ndstatus() { nodes_get_status "$@"; }
# === NAMESPACE MONITORING (ns_*) ===
ns_get_summary() {
    add_log "=== Func: ns_get_summary ==="
    add_log "📂 Namespace $1 Summary:"
    $K8S get all -n "$1" | add_log
    add_log "🧩 ConfigMaps & Secrets:"
    $K8S get cm,secret -n "$1" 2>/dev/null | add_log
}
nssummary() { ns_get_summary "$@"; }
ns_get_usage() { 
    add_log "=== Func: ns_get_usage ==="
    $K8S top pod -n "$1" 2>/dev/null | add_log; 
}
nsusage() { ns_get_usage "$@"; }
ns_get_events() {
    add_log "=== Func: ns_get_events ==="
    if [ -n "$2" ]; then $K8S get events -n "$1" --field-selector "$2" --sort-by=.lastTimestamp | add_log; else $K8S get events -n "$1" --sort-by=.lastTimestamp | add_log; fi
}
nsevents() { ns_get_events "$@"; }
ns_get_warnings() { 
    add_log "=== Func: ns_get_warnings ==="
    $K8S get events -n "$1" --field-selector type=Warning --sort-by=.lastTimestamp | add_log; 
}
nswarnings() { ns_get_warnings "$@"; }
# === CONTROLLER HEALTH (dp_*, ss_*, ds_*) ===
dp_get_status() { 
    add_log "=== Func: dp_get_status ==="
    $K8S get deployment "$2" -n "$1" -o custom-columns=NAME:.metadata.name,DES:.spec.replicas,UPD:.status.updatedReplicas,RDY:.status.readyReplicas,AVAIL:.status.availableReplicas | add_log; 
}
dpstatus() { dp_get_status "$@"; }
ss_get_status() { 
    add_log "=== Func: ss_get_status ==="
    $K8S get sts "$2" -n "$1" -o custom-columns=NAME:.metadata.name,DES:.spec.replicas,RDY:.status.readyReplicas,CUR:.status.currentReplicas,UPD:.status.updatedReplicas | add_log; 
}
ssstatus() { ss_get_status "$@"; }
ds_get_status() { 
    add_log "=== Func: ds_get_status ==="
    $K8S get ds "$2" -n "$1" -o custom-columns=NAME:.metadata.name,DES:.status.desiredNumberScheduled,CUR:.status.currentNumberScheduled,RDY:.status.numberReady,AVAIL:.status.numberAvailable | add_log; 
}
dsstatus() { ds_get_status "$@"; }
# === POD MONITORING (pd_*) ===
pd_get_metrics() { 
    add_log "=== Func: pd_get_metrics ==="
    $K8S top pod -n "$1" 2>/dev/null | add_log; 
}
pdmetrics() { pd_get_metrics "$@"; }
pd_get_metrics_label() { 
    add_log "=== Func: pd_get_metrics_label ==="
    $K8S top pod -n "$1" -l "$2" 2>/dev/null | add_log; 
}
pdmetricslabel() { pd_get_metrics_label "$@"; }
pd_get_logs_label() {
    add_log "=== Func: pd_get_logs_label ==="
    local opt="${3:+--tail=$3}"
    for p in $($K8S get pods -n "$1" -l "$2" -o name); do add_log "--- $(basename $p) ---"; $K8S logs "$p" -n "$1" $opt | add_log || true; done
}
pdlogslabel() { pd_get_logs_label "$@"; }
pd_ls_failing() { 
    add_log "=== Func: pd_ls_failing ==="
    $K8S get pods -n "$1" --no-headers | grep -E "CrashLoopBackOff|Error|Failed" | add_log || true; 
}
pdfailing() { pd_ls_failing "$@"; }
pd_ls_slow() {
    add_log "=== Func: pd_ls_slow ==="
    local t="${2:-300}"
    $K8S get pods -n "$1" --no-headers | awk -v th="$t" '{age=$5; unit=substr(age,length(age)); val=substr(age,1,length(age)-1); secs=(unit=="m")?val*60:(unit=="h")?val*3600:(unit=="d")?val*86400:val; if($3!="Running" && secs>th) print $1 "\t" $3 "\t" age;}' | add_log
}
pdslow() { pd_ls_slow "$@"; }
pd_ls_high_restarts() {
    add_log "=== Func: pd_ls_high_restarts ==="
    local th="${2:-3}"
    $K8S get pods -n "$1" -o jsonpath='{range .items[*]}{.metadata.name} {range .status.containerStatuses[*]}{.restartCount}{" "}{end}{"\n"}{end}' | awk -v t="$th" '{r=0; for(i=2;i<=NF;i++) r+=$i; if(r>=t) print $1 "\t" r}' | add_log
}
pdhighrestart() { pd_ls_high_restarts "$@"; }
pd_ls_no_readiness() { 
    add_log "=== Func: pd_ls_no_readiness ==="
    $K8S get pods -n "$1" -o json | jq -r '.items[] | select(all(.spec.containers[]?; has("readinessProbe") | not)) | .metadata.name' | add_log; 
}
pdnoreadiness() { pd_ls_no_readiness "$@"; }
pd_ls_no_liveness() { 
    add_log "=== Func: pd_ls_no_liveness ==="
    $K8S get pods -n "$1" -o json | jq -r '.items[] | select(all(.spec.containers[]?; has("livenessProbe") | not)) | .metadata.name' | add_log; 
}
pdnoliveness() { pd_ls_no_liveness "$@"; }
pd_ls_image() {
    add_log "=== Func: pd_ls_image ==="
    $K8S get pods -n "$1" -o jsonpath='{range .items[*]}{.metadata.name} {range .spec.containers[*]}{.image}{" "}{end}{"\n"}{end}' | awk -v pat="$2" '{for(i=2;i<=NF;i++) if(index($i,pat)>0) {print $1; break}}' | add_log
}
pdlsimage() { pd_ls_image "$@"; }
