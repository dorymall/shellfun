#!/bin/bash
help_rq(){
    # --- RESOURCEQUOTA OPERATIONS (rq_*) ---
    echo "Func: rq_add (\$ns, \$name, \$cpu, \$mem, \$pods, [\$svcs], [\$cms], [\$pvcs]) | Act: [kubectl] create resourcequota | Desc: Creates ResourceQuota"
    echo "Func: rq_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies ResourceQuota YAML file"
    echo "Func: rq_gen_template (\$file, \$name, \$ns, \$cpu, \$mem, \$pods) | Act: [cat] > file | Desc: Generates ResourceQuota template"
    echo "Func: rq_ls (\$ns, [\$args...]) | Act: [kubectl] get resourcequota | Desc: Lists ResourceQuotas"
    echo "Func: rq_ls_all ([\$args...]) | Act: [kubectl] get resourcequota --all-namespaces | Desc: Lists RQs in all namespaces"
    echo "Func: rq_desc (\$ns, \$name) | Act: [kubectl] describe resourcequota | Desc: Describes ResourceQuota"
    echo "Func: rq_get_info (\$ns, \$name) | Act: [kubectl] get resourcequota -o wide | Desc: Gets wide RQ info (Hard vs Used)"
    echo "Func: rq_get_usage (\$ns, \$name) | Act: [jq] filter status.used | Desc: Gets detailed usage via jq"
    echo "Func: rq_del (\$ns, \$name) | Act: [kubectl] delete resourcequota | Desc: Deletes ResourceQuota"
    echo "Func: rq_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if RQ exists"
    echo "Func: rq_watch (\$ns, \$name, [\$interval]) | Act: [watch] kubectl get resourcequota | Desc: Watches ResourceQuota"
    echo "Func: rq_analyze_pressure (\$ns, \$name) | Act: [jq] and [awk] analyze ratio | Desc: Analyzes quota usage ratio"
    echo "Func: rq_backup (\$ns, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups ResourceQuota to YAML file"
    
    # --- LIMITRANGE OPERATIONS (lr_*) ---
    echo "Func: lr_add (\$ns, \$name, \$type, \$def_cpu, \$def_mem, \$req_cpu, \$req_mem) | Act: [kubectl] create limitrange | Desc: Creates LimitRange"
    echo "Func: lr_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies LimitRange YAML file"
    echo "Func: lr_gen_template (\$file, \$name, \$ns, \$type, \$dcpu, \$dmem, \$rcpu, \$rmem) | Act: [cat] > file | Desc: Generates LimitRange template"
    echo "Func: lr_ls (\$ns, [\$args...]) | Act: [kubectl] get limitrange | Desc: Lists LimitRanges"
    echo "Func: lr_ls_all ([\$args...]) | Act: [kubectl] get limitrange --all-namespaces | Desc: Lists LRs in all namespaces"
    echo "Func: lr_desc (\$ns, \$name) | Act: [kubectl] describe limitrange | Desc: Describes LimitRange"
    echo "Func: lr_get_info (\$ns, \$name) | Act: [kubectl] get and [grep] | Desc: Gets LR basic info"
    echo "Func: lr_del (\$ns, \$name) | Act: [kubectl] delete limitrange | Desc: Deletes LimitRange"
    echo "Func: lr_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if LR exists"
    echo "Func: lr_backup (\$ns, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups LimitRange to YAML file"
    
    # --- PRIORITYCLASS OPERATIONS (pc_*) ---
    echo "Func: pc_add (\$name, \$value, [\$desc]) | Act: [kubectl] create priorityclass | Desc: Creates PriorityClass"
    echo "Func: pc_ls () | Act: [kubectl] get priorityclass | Desc: Lists PriorityClasses"
    echo "Func: pc_desc (\$name) | Act: [kubectl] describe priorityclass | Desc: Describes PriorityClass"
    echo "Func: pc_del (\$name) | Act: [kubectl] delete priorityclass | Desc: Deletes PriorityClass"
    
    # --- RESOURCE MANAGEMENT & MONITORING (rm_*) ---
    echo "Func: rm_ls_overcommitted (\$ns) | Act: [jq] filter limits/requests ratio | Desc: Finds pods where ratio >= 2"
    echo "Func: rm_ls_exceeding (\$ns, \$cpu_m, \$mem_mib) | Act: [kubectl] top and [awk] | Desc: Finds pods exceeding usage threshold"
    echo "Func: rm_sum_ns (\$ns) | Act: [jq] summarize specs | Desc: Summarizes pod resource specs in namespace"
    
    # --- NODE & CLUSTER CAPACITY (nodes_*) ---
    echo "Func: nodes_sum_allocatable () | Act: [jsonpath] and [jq] | Desc: Lists node capacity in cluster"
    echo "Func: nodes_top () | Act: [kubectl] top nodes | Desc: Shows node resource usage"
    echo "Func: cluster_sum_capacity () | Act: Sum node capacities | Desc: Computes total cluster CPU/Mem capacity"
    
    # --- MISC / PATCH OPERATIONS ---
    echo "Func: dp_upd_resources (\$ns, \$deploy, \$container, \$cpu_req, \$cpu_lim, \$mem_req, \$mem_lim) | Act: [kubectl] set resources | Desc: Patches deployment resources"
    echo "Func: pd_upd_resources (\$ns, \$pod, \$cont, \$cr, \$cl, \$mr, \$ml) | Act: (Warning: not supported) | Desc: Explains pod resource limitation"
    echo "Func: burn_pod_add (\$ns, \$name, \$cpu_m, \$mem_mib, \$dur) | Act: [kubectl] run stress | Desc: Creates stress-test pod (CPU/Mem burn)"
    echo "Func: burn_pod_del (\$ns, \$name) | Act: [kubectl] delete pod | Desc: Deletes stress pod"
    echo "Func: wait_for_pod_resources (\$ns, \$pod, [\$timeout]) | Act: Loop [kubectl] top | Desc: Waits for metrics-server to see pod metrics"
}

# =============================================================================
# ⚖️ RESOURCEQUOTA OPERATIONS (rq_*)
# =============================================================================

# ===== rq_add(ns, name, cpu, mem, pods, [svcs], [cms], [pvcs]) =====
rq_add() {
    local ns="$1"; local n="$2"; local c="$3"; local m="$4"; local p="$5"; local s="$6"; local cm="$7"; local pvc="$8"
    cat <<EOF | $K8S apply -f -
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

# ===== rq_add_f(file) =====
rq_add_f() { $K8S apply -f "$1"; }

# ===== rq_gen_template(file, name, ns, cpu, mem, pods) =====
rq_gen_template() {
    cat > "$1" <<EOF
apiVersion: v1
kind: ResourceQuota
metadata: { name: "$2", namespace: "$3" }
spec: { hard: { cpu: "$4", memory: "$5", pods: "$6" } }
EOF
}

# ===== rq_ls(ns, [args...]) =====
rq_ls() { $K8S get resourcequota -n "$1" "${@:2}"; }

# ===== rq_ls_all([args...]) =====
rq_ls_all() { $K8S get resourcequota --all-namespaces "$@"; }

# ===== rq_desc(ns, name) =====
rq_desc() { $K8S describe resourcequota "$2" -n "$1"; }

# ===== rq_get_info(ns, name) =====
rq_get_info() { $K8S get resourcequota "$2" -n "$1" -o custom-columns=NAME:.metadata.name,HARD:.spec.hard,USED:.status.used; }

# ===== rq_get_usage(ns, name) =====
rq_get_usage() { $K8S get resourcequota "$2" -n "$1" -o json | jq -r '.status.used as $u | .spec.hard | to_entries[] | "  \(.key): used=\($u[.key]//"0") / hard=\(.value)"'; }

# ===== rq_del(ns, name) =====
rq_del() { $K8S delete resourcequota "$2" -n "$1"; }

# ===== rq_exists(ns, name) =====
rq_exists() { $K8S get resourcequota "$2" -n "$1" &>/dev/null; }

# ===== rq_watch(ns, name, [interval]) =====
rq_watch() { watch -n "${3:-5}" "$K8S get resourcequota $2 -n $1"; }

# ===== rq_analyze_pressure(ns, name) =====
rq_analyze_pressure() {
    $K8S get resourcequota "$2" -n "$1" -o json | jq -r '.status.used as $u | .spec.hard | to_entries[] | "\(.key): \($u[.key]//"0")/\(.value)"'
}

# ===== rq_backup(ns, name, file) =====
rq_backup() { $K8S get resourcequota "$2" -n "$1" -o yaml > "$3"; }

# =============================================================================
# 📏 LIMITRANGE OPERATIONS (lr_*)
# =============================================================================

# ===== lr_add(ns, name, type, dcpu, dmem, rcpu, rmem) =====
lr_add() {
    local ns="$1"; local n="$2"; local t="$3"; local dc="$4"; local dm="$5"; local rc="$6"; local rm="$7"
    cat <<EOF | $K8S apply -f -
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

# ===== lr_add_f(file) =====
lr_add_f() { $K8S apply -f "$1"; }

# ===== lr_gen_template(file, name, ns, type, dcpu, dmem, rcpu, rmem) =====
lr_gen_template() {
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
}

# ===== lr_ls(ns, [args...]) =====
lr_ls() { $K8S get limitrange -n "$1" "${@:2}"; }

# ===== lr_ls_all([args...]) =====
lr_ls_all() { $K8S get limitrange --all-namespaces "$@"; }

# ===== lr_desc(ns, name) =====
lr_desc() { $K8S describe limitrange "$2" -n "$1"; }

# ===== lr_get_info(ns, name) =====
lr_get_info() { $K8S get limitrange "$2" -n "$1" -o yaml | grep -E "default:|defaultRequest:"; }

# ===== lr_del(ns, name) =====
lr_del() { $K8S delete limitrange "$2" -n "$1"; }

# ===== lr_exists(ns, name) =====
lr_exists() { $K8S get limitrange "$2" -n "$1" &>/dev/null; }

# ===== lr_backup(ns, name, file) =====
lr_backup() { $K8S get limitrange "$2" -n "$1" -o yaml > "$3"; }

# =============================================================================
# 🔝 PRIORITYCLASS OPERATIONS (pc_*)
# =============================================================================

# ===== pc_add(name, value, [desc]) =====
pc_add() {
    cat <<EOF | $K8S apply -f -
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata: { name: "$1" }
value: $2
globalDefault: false
description: "${3:-Priority class $1}"
EOF
}

# ===== pc_ls() =====
pc_ls() { $K8S get priorityclass "$@"; }

# ===== pc_desc(name) =====
pc_desc() { $K8S describe priorityclass "$1"; }

# ===== pc_del(name) =====
pc_del() { $K8S delete priorityclass "$1"; }

# =============================================================================
# 🔍 RESOURCE MANAGEMENT & MONITORING (rm_*)
# =============================================================================

# ===== rm_ls_overcommitted(ns) =====
rm_ls_overcommitted() {
    $K8S get pods -n "$1" -o json | jq -r '.items[] | select(.spec.containers[].resources.limits.cpu and .spec.containers[].resources.requests.cpu) | select((.spec.containers[].resources.limits.cpu|tonumber) >= 2*(.spec.containers[].resources.requests.cpu|tonumber)) | .metadata.name'
}

# ===== rm_ls_exceeding(ns, cpu_m, mem_mib) =====
rm_ls_exceeding() {
    $K8S top pod -n "$1" --no-headers | awk -v c="$2" -v m="$3" '{gsub("m","",$2); gsub("Mi","",$3); if($2>c || $3>m) print $1}'
}

# ===== rm_sum_ns(ns) =====
rm_sum_ns() {
    $K8S get pods -n "$1" -o json | jq -r '.items[] | "Pod: \(.metadata.name)\n  Req: \(.spec.containers[].resources.requests)\n  Lim: \(.spec.containers[].resources.limits)"'
}

# =============================================================================
# 📊 NODE & CLUSTER CAPACITY (nodes_*)
# =============================================================================

# ===== nodes_sum_allocatable() =====
nodes_sum_allocatable() {
    $K8S get nodes -o json | jq -r '.items[] | "\(.metadata.name): CPU=\(.status.allocatable.cpu) MEM=\(.status.allocatable.memory)"'
}

# ===== nodes_top() =====
nodes_top() { $K8S top nodes; }

# ===== cluster_sum_capacity() =====
cluster_sum_capacity() {
    local c=$($K8S get nodes -o json | jq -r '[.items[].status.allocatable.cpu] | map(sub("m";"")|tonumber) | add')
    local m=$($K8S get nodes -o json | jq -r '[.items[].status.allocatable.memory] | map(sub("Ki";"")|tonumber) | add')
    echo "Cluster Capacity: CPU=${c}m, MEM=${m}Ki"
}

# =============================================================================
# 🛠️ MISC / PATCH OPERATIONS
# =============================================================================

# ===== dp_upd_resources(ns, deploy, container, cpu_req, cpu_lim, mem_req, mem_lim) =====
dp_upd_resources() {
    $K8S patch deployment "$2" -n "$1" --type=merge -p "{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"$3\",\"resources\":{\"requests\":{\"cpu\":\"$4\",\"memory\":\"$6\"},\"limits\":{\"cpu\":\"$5\",\"memory\":\"$7\"}}}]}}}}"
}

# ===== pd_upd_resources(ns, pod, cont, cr, cl, mr, ml) =====
pd_upd_resources() { echo "⚠️ Direct pod resource update not supported. Update controller instead."; }

# ===== burn_pod_add(ns, name, cpu_m, mem_mib, dur) =====
burn_pod_add() {
    local ns="$1"; local n="$2"; local c="$3"; local m="$4"; local d="$5"
    cat <<EOF | $K8S apply -f -
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

# ===== burn_pod_del(ns, name) =====
burn_pod_del() { $K8S delete pod "$2" -n "$1" --ignore-not-found; }

# ===== wait_for_pod_resources(ns, pod, [timeout]) =====
wait_for_pod_resources() {
    local t="${3:-120}"
    timeout "$t" bash -c "until $K8S top pod $2 -n $1 &>/dev/null; do sleep 5; done"
}

# ========== BACKWARD COMPATIBILITY ALIASES ==========
get_namespace_resource_quota() { rq_ls "$1"; }
list_all_resource_quotas() { rq_ls_all "$@"; }
resource_quotas() { rq_ls "$@"; }
create_resource_quota() { rq_add "$@"; }
create_resource_quota_from_file() { rq_add_f "$@"; }
create_resource_quota_from_yaml() { rq_add_f "$@"; }
delete_resource_quota() { rq_del "$@"; }
resource_quota_exists() { rq_exists "$@"; }
get_resource_quota_info() { rq_get_info "$@"; }
resource_quota_usage() { rq_get_usage "$@"; }
describe_resource_quota() { rq_desc "$@"; }
watch_resource_quota() { rq_watch "$@"; }
analyze_quota_pressure() { rq_analyze_pressure "$@"; }
backup_resource_quota() { rq_backup "$@"; }
generate_resource_quota_template() { rq_gen_template "$@"; }
get_namespace_limit_range() { lr_ls "$1"; }
list_all_limit_ranges() { lr_ls_all "$@"; }
limit_ranges() { lr_ls "$@"; }
create_limit_range() { lr_add "$@"; }
create_limit_range_from_file() { lr_add_f "$@"; }
create_limit_range_from_yaml() { lr_add_f "$@"; }
delete_limit_range() { lr_del "$@"; }
limit_range_exists() { lr_exists "$@"; }
get_limit_range_info() { lr_get_info "$@"; }
describe_limit_range() { lr_desc "$@"; }
backup_limit_range() { lr_backup "$@"; }
generate_limit_range_template() { lr_gen_template "$@"; }
create_priority_class() { pc_add "$@"; }
delete_priority_class() { pc_del "$@"; }
list_priority_classes() { pc_ls "$@"; }
describe_priority_class() { pc_desc "$@"; }
create_resource_burn_pod() { burn_pod_add "$@"; }
cleanup_stress_pod() { burn_pod_del "$@"; }
list_overcommitted_pods() { rm_ls_overcommitted "$@"; }
find_pods_exceeding_threshold() { rm_ls_exceeding "$@"; }
summarize_namespace_resources() { rm_sum_ns "$@"; }
update_deployment_resources() { dp_upd_resources "$@"; }
patch_container_resources() { pd_upd_resources "$@"; }
compute_cluster_capacity() { cluster_sum_capacity "$@"; }
summarize_node_allocatable() { nodes_sum_allocatable "$@"; }
list_top_nodes() { nodes_top "$@"; }
