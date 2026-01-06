#!/bin/bash
help_rq(){
    add_log_help "=== help_rq ==="
    # --- RESOURCEQUOTA OPERATIONS (rq_*) ---
    add_log_help "Func: rq_add [rqadd] (\$ns, \$name, \$cpu, \$mem, \$pods, [\$svcs], [\$cms], [\$pvcs]) | Act: [kubectl] create resourcequota | Desc: Creates ResourceQuota"
    add_log_help "Func: rq_add_f [rqaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies ResourceQuota YAML file"
    add_log_help "Func: rq_gen_template [rqgentemplate] (\$file, \$name, \$ns, \$cpu, \$mem, \$pods) | Act: [cat] > file | Desc: Generates ResourceQuota template"
    add_log_help "Func: rq_ls [rqls] (\$ns, [\$args...]) | Act: [kubectl] get resourcequota | Desc: Lists ResourceQuotas"
    add_log_help "Func: rq_ls_all [rqlsall] ([\$args...]) | Act: [kubectl] get resourcequota --all-namespaces | Desc: Lists RQs in all namespaces"
    add_log_help "Func: rq_desc [rqdesc] (\$ns, \$name) | Act: [kubectl] describe resourcequota | Desc: Describes ResourceQuota"
    add_log_help "Func: rq_get_info [rqinfo] (\$ns, \$name) | Act: [kubectl] get resourcequota -o wide | Desc: Gets wide RQ info (Hard vs Used)"
    add_log_help "Func: rq_get_usage [rqusage] (\$ns, \$name) | Act: [jq] filter status.used | Desc: Gets detailed usage via jq"
    add_log_help "Func: rq_del [rqdel] (\$ns, \$name) | Act: [kubectl] delete resourcequota | Desc: Deletes ResourceQuota"
    add_log_help "Func: rq_exists [rqexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if RQ exists"
    add_log_help "Func: rq_watch [rqwatch] (\$ns, \$name, [\$interval]) | Act: [watch] kubectl get resourcequota | Desc: Watches ResourceQuota"
    add_log_help "Func: rq_analyze_pressure [rqanalyze] (\$ns, \$name) | Act: [jq] and [awk] analyze ratio | Desc: Analyzes quota usage ratio"
    add_log_help "Func: rq_backup [rqbak] (\$ns, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups ResourceQuota to YAML file"
    
    # --- LIMITRANGE OPERATIONS (lr_*) ---
    add_log_help "Func: lr_add [lradd] (\$ns, \$name, \$type, \$def_cpu, \$def_mem, \$req_cpu, \$req_mem) | Act: [kubectl] create limitrange | Desc: Creates LimitRange"
    add_log_help "Func: lr_add_f [lraddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies LimitRange YAML file"
    add_log_help "Func: lr_gen_template [lrgentemplate] (\$file, \$name, \$ns, \$type, \$dcpu, \$dmem, \$rcpu, \$rmem) | Act: [cat] > file | Desc: Generates LimitRange template"
    add_log_help "Func: lr_ls [lrls] (\$ns, [\$args...]) | Act: [kubectl] get limitrange | Desc: Lists LimitRanges"
    add_log_help "Func: lr_ls_all [lrlsall] ([\$args...]) | Act: [kubectl] get limitrange --all-namespaces | Desc: Lists LRs in all namespaces"
    add_log_help "Func: lr_desc [lrdesc] (\$ns, \$name) | Act: [kubectl] describe limitrange | Desc: Describes LimitRange"
    add_log_help "Func: lr_get_info [lrinfo] (\$ns, \$name) | Act: [kubectl] get and [grep] | Desc: Gets LR basic info"
    add_log_help "Func: lr_del [lrdel] (\$ns, \$name) | Act: [kubectl] delete limitrange | Desc: Deletes LimitRange"
    add_log_help "Func: lr_exists [lrexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if LR exists"
    add_log_help "Func: lr_backup [lrbak] (\$ns, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups LimitRange to YAML file"
    
    # --- PRIORITYCLASS OPERATIONS (pc_*) ---
    add_log_help "Func: pc_add [pcadd] (\$name, \$value, [\$desc]) | Act: [kubectl] create priorityclass | Desc: Creates PriorityClass"
    add_log_help "Func: pc_ls [pcls] () | Act: [kubectl] get priorityclass | Desc: Lists PriorityClasses"
    add_log_help "Func: pc_desc [pcdesc] (\$name) | Act: [kubectl] describe priorityclass | Desc: Describes PriorityClass"
    add_log_help "Func: pc_del [pcdel] (\$name) | Act: [kubectl] delete priorityclass | Desc: Deletes PriorityClass"
    
    # --- RESOURCE MANAGEMENT & MONITORING (rm_*) ---
    add_log_help "Func: rm_ls_overcommitted [rmovercommitted] (\$ns) | Act: [jq] filter limits/requests ratio | Desc: Finds pods where ratio >= 2"
    add_log_help "Func: rm_ls_exceeding [rmexceeding] (\$ns, \$cpu_m, \$mem_mib) | Act: [kubectl] top and [awk] | Desc: Finds pods exceeding usage threshold"
    add_log_help "Func: rm_sum_ns [rmsummary] (\$ns) | Act: [jq] summarize specs | Desc: Summarizes pod resource specs in namespace"
    
    # --- NODE & CLUSTER CAPACITY (nodes_*) ---
    add_log_help "Func: nodes_sum_allocatable [ndsumallocatable] () | Act: [jsonpath] and [jq] | Desc: Lists node capacity in cluster"
    add_log_help "Func: nodes_top [ndtopmetrics] () | Act: [kubectl] top nodes | Desc: Shows node resource usage"
    add_log_help "Func: cluster_sum_capacity [clcapacity] () | Act: Sum node capacities | Desc: Computes total cluster CPU/Mem capacity"
    
    # --- MISC / PATCH OPERATIONS ---
    add_log_help "Func: dp_upd_resources [dpupdresources] (\$ns, \$deploy, \$container, \$cpu_req, \$cpu_lim, \$mem_req, \$mem_lim) | Act: [kubectl] set resources | Desc: Patches deployment resources"
    add_log_help "Func: pd_upd_resources [pdupdresources] (\$ns, \$pod, \$cont, \$cr, \$cl, \$mr, \$ml) | Act: (Warning: not supported) | Desc: Explains pod resource limitation"
    add_log_help "Func: burn_pod_add [burnpod] (\$ns, \$name, \$cpu_m, \$mem_mib, \$dur) | Act: [kubectl] run stress | Desc: Creates stress-test pod (CPU/Mem burn)"
    add_log_help "Func: burn_pod_del [burndel] (\$ns, \$name) | Act: [kubectl] delete pod | Desc: Deletes stress pod"
    add_log_help "Func: wait_for_pod_resources [pdwaitresources] (\$ns, \$pod, [\$timeout]) | Act: Loop [kubectl] top | Desc: Waits for metrics-server to see pod metrics"
}
# === RESOURCEQUOTA OPERATIONS (rq_*) ===
rq_add() {
    add_log "=== Func: rq_add ==="
    local ns="$1"; local n="$2"; local c="$3"; local m="$4"; local p="$5"; local s="$6"; local cm="$7"; local pvc="$8"
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: v1
kind: ResourceQuota
metadata: { name: "$n", namespace: "$ns" }
spec:
  hard:
    cpu: "$c"
    memory: "$m"
    pods: "$p"
    ${s:+services: "$s"}
    ${cm:+configmaps: "$cm"}
    ${pvc:+persistentvolumeclaims: "$pvc"}
EOF
}
rqadd() { rq_add "$@"; }
rq_add_f() { 
    add_log "=== Func: rq_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
rqaddf() { rq_add_f "$@"; }
rq_gen_template() {
    add_log "=== Func: rq_gen_template ==="
    cat > "$1" <<EOF
apiVersion: v1
kind: ResourceQuota
metadata: { name: "$2", namespace: "$3" }
spec: { hard: { cpu: "$4", memory: "$5", pods: "$6" } }
EOF
    add_log "Template saved to $1"
}
rqgentemplate() { rq_gen_template "$@"; }
rq_ls() { 
    add_log "=== Func: rq_ls ==="
    $K8S get resourcequota -n "$1" "${@:2}" | add_log; 
}
rqls() { rq_ls "$@"; }
rq_ls_all() { 
    add_log "=== Func: rq_ls_all ==="
    $K8S get resourcequota --all-namespaces "$@" | add_log; 
}
rqlsall() { rq_ls_all "$@"; }
rq_desc() { 
    add_log "=== Func: rq_desc ==="
    $K8S describe resourcequota "$2" -n "$1" | add_log; 
}
rqdesc() { rq_desc "$@"; }
rq_get_info() { 
    add_log "=== Func: rq_get_info ==="
    $K8S get resourcequota "$2" -n "$1" -o custom-columns=NAME:.metadata.name,HARD:.spec.hard,USED:.status.used | add_log; 
}
rqinfo() { rq_get_info "$@"; }
rq_get_usage() { 
    add_log "=== Func: rq_get_usage ==="
    $K8S get resourcequota "$2" -n "$1" -o json | jq -r '.status.used as $u | .spec.hard | to_entries[] | "  \(.key): used=\($u[.key]//"0") / hard=\(.value)"' | add_log; 
}
rqusage() { rq_get_usage "$@"; }
rq_del() { 
    add_log "=== Func: rq_del ==="
    $K8S delete resourcequota "$2" -n "$1" | add_log; 
}
rqdel() { rq_del "$@"; }
rq_exists() { 
    add_log "=== Func: rq_exists ==="
    if $K8S get resourcequota "$2" -n "$1" &>/dev/null; then add_log "ResourceQuota $2 exists in namespace $1"; return 0; else add_log "ResourceQuota $2 does NOT exist in namespace $1"; return 1; fi
}
rqexists() { rq_exists "$@"; }
rq_watch() { 
    add_log "=== Func: rq_watch ==="
    watch -n "${3:-5}" "$K8S get resourcequota $2 -n $1" | add_log; 
}
rqwatch() { rq_watch "$@"; }
rq_analyze_pressure() {
    add_log "=== Func: rq_analyze_pressure ==="
    $K8S get resourcequota "$2" -n "$1" -o json | jq -r '.status.used as $u | .spec.hard | to_entries[] | "\(.key): \($u[.key]//"0")/\(.value)"' | add_log
}
rqanalyze() { rq_analyze_pressure "$@"; }
rq_backup() { 
    add_log "=== Func: rq_backup ==="
    $K8S get resourcequota "$2" -n "$1" -o yaml > "$3" && add_log "Backup saved to $3"; 
}
rqbak() { rq_backup "$@"; }
# === LIMITRANGE OPERATIONS (lr_*) ===
lr_add() {
    add_log "=== Func: lr_add ==="
    local ns="$1"; local n="$2"; local t="$3"; local dc="$4"; local dm="$5"; local rc="$6"; local rm="$7"
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: v1
kind: LimitRange
metadata: { name: "$n", namespace: "$ns" }
spec:
  limits:
  - type: "$t"
    default: { cpu: "$dc", memory: "$dm" }
    defaultRequest: { cpu: "$rc", memory: "$rm" }
EOF
}
lradd() { lr_add "$@"; }
lr_add_f() { 
    add_log "=== Func: lr_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
lraddf() { lr_add_f "$@"; }
lr_gen_template() {
    add_log "=== Func: lr_gen_template ==="
    cat > "$1" <<EOF
apiVersion: v1
kind: LimitRange
metadata: { name: "$2", namespace: "$3" }
spec:
  limits:
  - type: "$4"
    default: { cpu: "$5", memory: "$6" }
    defaultRequest: { cpu: "$7", memory: "$8" }
EOF
    add_log "Template saved to $1"
}
lrgentemplate() { lr_gen_template "$@"; }
lr_ls() { 
    add_log "=== Func: lr_ls ==="
    $K8S get limitrange -n "$1" "${@:2}" | add_log; 
}
lrls() { lr_ls "$@"; }
lr_ls_all() { 
    add_log "=== Func: lr_ls_all ==="
    $K8S get limitrange --all-namespaces "$@" | add_log; 
}
lrlsall() { lr_ls_all "$@"; }
lr_desc() { 
    add_log "=== Func: lr_desc ==="
    $K8S describe limitrange "$2" -n "$1" | add_log; 
}
lrdesc() { lr_desc "$@"; }
lr_get_info() { 
    add_log "=== Func: lr_get_info ==="
    $K8S get limitrange "$2" -n "$1" -o yaml | grep -E "default:|defaultRequest:" | add_log; 
}
lrinfo() { lr_get_info "$@"; }
lr_del() { 
    add_log "=== Func: lr_del ==="
    $K8S delete limitrange "$2" -n "$1" | add_log; 
}
lrdel() { lr_del "$@"; }
lr_exists() { 
    add_log "=== Func: lr_exists ==="
    if $K8S get limitrange "$2" -n "$1" &>/dev/null; then add_log "LimitRange $2 exists in namespace $1"; return 0; else add_log "LimitRange $2 does NOT exist in namespace $1"; return 1; fi
}
lrexists() { lr_exists "$@"; }
lr_backup() { 
    add_log "=== Func: lr_backup ==="
    $K8S get limitrange "$2" -n "$1" -o yaml > "$3" && add_log "Backup saved to $3"; 
}
lrbak() { lr_backup "$@"; }
# === PRIORITYCLASS OPERATIONS (pc_*) ===
pc_add() {
    add_log "=== Func: pc_add ==="
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata: { name: "$1" }
value: $2
globalDefault: false
description: "${3:-Priority class $1}"
EOF
}
pcadd() { pc_add "$@"; }
pc_ls() { 
    add_log "=== Func: pc_ls ==="
    $K8S get priorityclass "$@" | add_log; 
}
pcls() { pc_ls "$@"; }
pc_desc() { 
    add_log "=== Func: pc_desc ==="
    $K8S describe priorityclass "$1" | add_log; 
}
pcdesc() { pc_desc "$@"; }
pc_del() { 
    add_log "=== Func: pc_del ==="
    $K8S delete priorityclass "$1" | add_log; 
}
pcdel() { pc_del "$@"; }
# === RESOURCE MANAGEMENT & MONITORING (rm_*) ===
rm_ls_overcommitted() {
    add_log "=== Func: rm_ls_overcommitted ==="
    $K8S get pods -n "$1" -o json | jq -r '.items[] | select(.spec.containers[].resources.limits.cpu and .spec.containers[].resources.requests.cpu) | select((.spec.containers[].resources.limits.cpu|tonumber) >= 2*(.spec.containers[].resources.requests.cpu|tonumber)) | .metadata.name' | add_log
}
rmovercommitted() { rm_ls_overcommitted "$@"; }
rm_ls_exceeding() {
    add_log "=== Func: rm_ls_exceeding ==="
    $K8S top pod -n "$1" --no-headers | awk -v c="$2" -v m="$3" '{gsub("m","",$2); gsub("Mi","",$3); if($2>c || $3>m) print $1}' | add_log
}
rmexceeding() { rm_ls_exceeding "$@"; }
rm_sum_ns() {
    add_log "=== Func: rm_sum_ns ==="
    $K8S get pods -n "$1" -o json | jq -r '.items[] | "Pod: \(.metadata.name)\n  Req: \(.spec.containers[].resources.requests)\n  Lim: \(.spec.containers[].resources.limits)"' | add_log
}
rmsummary() { rm_sum_ns "$@"; }
# === NODE & CLUSTER CAPACITY (nodes_*) ===
nodes_sum_allocatable() {
    add_log "=== Func: nodes_sum_allocatable ==="
    $K8S get nodes -o json | jq -r '.items[] | "\(.metadata.name): CPU=\(.status.allocatable.cpu) MEM=\(.status.allocatable.memory)"' | add_log
}
ndsumallocatable() { nodes_sum_allocatable "$@"; }
nodes_top() { 
    add_log "=== Func: nodes_top ==="
    $K8S top nodes | add_log; 
}
ndtopmetrics() { nodes_top "$@"; }
cluster_sum_capacity() {
    add_log "=== Func: cluster_sum_capacity ==="
    local c=$($K8S get nodes -o json | jq -r '[.items[].status.allocatable.cpu] | map(sub("m";"")|tonumber) | add')
    local m=$($K8S get nodes -o json | jq -r '[.items[].status.allocatable.memory] | map(sub("Ki";"")|tonumber) | add')
    add_log "Cluster Capacity: CPU=${c}m, MEM=${m}Ki"
}
clcapacity() { cluster_sum_capacity "$@"; }
# === MISC / PATCH OPERATIONS ===
dp_upd_resources() {
    add_log "=== Func: dp_upd_resources ==="
    $K8S patch deployment "$2" -n "$1" --type=merge -p "{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"$3\",\"resources\":{\"requests\":{\"cpu\":\"$4\",\"memory\":\"$6\"},\"limits\":{\"cpu\":\"$5\",\"memory\":\"$7\"}}}]}}}}" | add_log
}
dpupdresources() { dp_upd_resources "$@"; }
pd_upd_resources() { 
    add_log "=== Func: pd_upd_resources ==="
    add_log "⚠️ Direct pod resource update not supported. Update controller instead."; 
}
pdupdresources() { pd_upd_resources "$@"; }
burn_pod_add() {
    add_log "=== Func: burn_pod_add ==="
    local ns="$1"; local n="$2"; local c="$3"; local m="$4"; local d="$5"
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: v1
kind: Pod
metadata: { name: "$n", namespace: "$ns" }
spec:
  restartPolicy: Never
  containers:
  - name: burn, image: busybox, resources: { requests: { cpu: "${c}m", memory: "${m}Mi" }, limits: { cpu: "${c}m", memory: "${m}Mi" } }
    command: ["/bin/sh","-c"]
    args: ["end=\$((\$(date +%s)+$d)); while [ \$(date +%s) -lt \$end ]; do dd if=/dev/zero of=/dev/null bs=1M count=10 2>/dev/null; done"]
EOF
}
burnpod() { burn_pod_add "$@"; }
burn_pod_del() { 
    add_log "=== Func: burn_pod_del ==="
    $K8S delete pod "$2" -n "$1" --ignore-not-found | add_log; 
}
burndel() { burn_pod_del "$@"; }
wait_for_pod_resources() {
    add_log "=== Func: wait_for_pod_resources ==="
    local t="${3:-120}"
    timeout "$t" bash -c "until $K8S top pod $2 -n $1 &>/dev/null; do sleep 5; done" | add_log
}
pdwaitresources() { wait_for_pod_resources "$@"; }
