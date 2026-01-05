#!/bin/bash
help_ds(){
    echo "Func: ds_add_f (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Applies DaemonSet YAML file"
    echo "Func: ds_add_basic (\$ns, \$name, \$image) | Act: [cat] and [kubectl] apply | Desc: Creates basic DaemonSet"
    echo "Func: ds_ls (\$ns, [\$args...]) | Act: [kubectl] get ds | Desc: Lists DaemonSets"
    echo "Func: ds_ls_all ([\$args...]) | Act: [kubectl] get ds --all-namespaces | Desc: Lists DaemonSets in all namespaces"
    echo "Func: ds_ls_label (\$ns, \$selector) | Act: [kubectl] get ds -l | Desc: Lists DaemonSets filtered by label"
    echo "Func: ds_ls_image (\$ns, \$pattern) | Act: [jq] filter by image | Desc: Finds DaemonSets using specific image"
    echo "Func: ds_desc (\$ns, \$name) | Act: [kubectl] describe ds | Desc: Describes DaemonSet"
    echo "Func: ds_get (\$ns, \$name, [\$out]) | Act: [kubectl] get ds -o | Desc: Gets DaemonSet definition (yaml by default)"
    echo "Func: ds_get_info (\$ns, \$name) | Act: [kubectl] get ds -o wide | Desc: Gets wide DaemonSet info"
    echo "Func: ds_get_status (\$ns, \$name) | Act: [jsonpath] .status | Desc: Shows Desired vs Ready status"
    echo "Func: ds_get_pods (\$ns, \$name) | Act: [kubectl] get pods -l | Desc: Lists pods managed by DaemonSet"
    echo "Func: ds_get_rollout_status (\$ns, \$name) | Act: [kubectl] rollout status | Desc: Shows rollout status"
    echo "Func: ds_get_rollout_history (\$ns, \$name) | Act: [kubectl] rollout history | Desc: Shows rollout history"
    echo "Func: ds_get_events (\$ns, \$name) | Act: [kubectl] get events | Desc: Gets events for DaemonSet"
    echo "Func: ds_count (\$ns) | Act: [wc] -l | Desc: Counts DaemonSets in namespace"
    echo "Func: ds_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if DaemonSet exists"
    echo "Func: ds_upd_image (\$ns, \$name, \$container, \$image) | Act: [kubectl] set image | Desc: Updates DaemonSet image"
    echo "Func: ds_upd_scale (\$ns, \$name, \$max_unavailable) | Act: [kubectl] patch strategy | Desc: Updates update strategy"
    echo "Func: ds_restart (\$ns, \$name) | Act: [kubectl] rollout restart | Desc: Restarts DaemonSet"
    echo "Func: ds_pause (\$ns, \$name) | Act: [kubectl] annotate paused=true | Desc: Pauses DaemonSet"
    echo "Func: ds_resume (\$ns, \$name) | Act: [kubectl] annotate (remove) | Desc: Resumes DaemonSet"
    echo "Func: ds_rollback (\$ns, \$name, [\$revision]) | Act: [kubectl] rollout undo | Desc: Rolls back DaemonSet"
    echo "Func: ds_del (\$ns, \$name) | Act: [kubectl] delete ds | Desc: Deletes DaemonSet"
    echo "Func: ds_del_cascade (\$ns, \$name) | Act: [kubectl] delete --cascade=foreground | Desc: Deletes with foreground cascade"
    echo "Func: ds_watch (\$ns, \$name, [\$interval]) | Act: [watch] kubectl get ds | Desc: Watches DaemonSet status"
    echo "Func: ds_watch_rollout (\$ns, \$name) | Act: [kubectl] rollout status -w | Desc: Watches rollout progress"
    echo "Func: ds_wait_ready (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait loop | Desc: Waits for all nodes to be ready"
    echo "Func: ds_wait_del (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait for deletion | Desc: Waits for DaemonSet deletion"
    echo "Func: ds_backup (\$ns, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups DaemonSet to YAML file"
    echo "Func: ds_clone (\$source_ns, \$target_ns, \$name, [\$new_name]) | Act: [jq] and [kubectl] apply | Desc: Clones DaemonSet using jq"
    echo "Func: ds_diff (\$ns1, \$ds1, \$ns2, \$ds2) | Act: [kubectl] get -o json | [diff] | Desc: Diffs two DaemonSet definitions"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== ds_add_f(ns, file) =====
ds_add_f() { $K8S apply -n "$1" -f "$2"; }

# ===== ds_add_basic(ns, name, image) =====
ds_add_basic() {
    local ns="$1"; local name="$2"; local img="$3"
    cat <<EOF | $K8S apply -n "$ns" -f -
apiVersion: apps/v1
kind: DaemonSet
metadata: { name: "$name", namespace: "$ns" }
spec:
  selector: { matchLabels: { app: "$name" } }
  template:
    metadata: { labels: { app: "$name" } }
    spec:
      containers: [ { name: "$name", image: "$img" } ]
EOF
}

# ===== ds_clone(source_ns, target_ns, name, [new_name]) =====
ds_clone() {
    local sns="$1"; local tns="$2"; local name="$3"; local nname="${4:-$3}"
    $K8S get ds "$name" -n "$sns" -o json | \
    jq "del(.metadata.resourceVersion, .metadata.uid, .metadata.creationTimestamp, .status) | .metadata.namespace = \"$tns\" | .metadata.name = \"$nname\"" | \
    $K8S apply -f -
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== ds_ls(ns, [args...]) =====
ds_ls() { $K8S get ds -n "$1" "${@:2}"; }

# ===== ds_ls_all([args...]) =====
ds_ls_all() { $K8S get ds --all-namespaces "$@"; }

# ===== ds_ls_label(ns, selector) =====
ds_ls_label() { $K8S get ds -n "$1" -l "$2"; }

# ===== ds_ls_image(ns, pattern) =====
ds_ls_image() {
    $K8S get ds -n "$1" -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.template.spec.containers[*].image}{"\n"}{end}' | grep "$2"
}

# ===== ds_desc(ns, name) =====
ds_desc() { $K8S describe ds "$2" -n "$1"; }

# ===== ds_get(ns, name, [out]) =====
ds_get() { [ -n "$3" ] && $K8S get ds "$2" -n "$1" -o yaml > "$3" || $K8S get ds "$2" -n "$1" -o yaml; }

# ===== ds_get_info(ns, name) =====
ds_get_info() {
    $K8S get ds "$2" -n "$1" -o custom-columns=NAME:.metadata.name,DESIRED:.status.desiredNumberScheduled,READY:.status.numberReady,NODE-SEL:.spec.template.spec.nodeSelector
}

# ===== ds_get_status(ns, name) =====
ds_get_status() {
    local d=$($K8S get ds "$2" -n "$1" -o jsonpath='{.status.desiredNumberScheduled}')
    local r=$($K8S get ds "$2" -n "$1" -o jsonpath='{.status.numberReady}')
    echo "DaemonSet $2: Desired=$d, Ready=$r"
}

# ===== ds_get_pods(ns, name) =====
ds_get_pods() {
    local sel=$($K8S get ds "$2" -n "$1" -o jsonpath='{.spec.selector.matchLabels}' | jq -r 'to_entries|map("\(.key)=\(.value)")|join(",")')
    $K8S get pods -n "$1" -l "$sel" -o wide
}

# ===== ds_get_rollout_status(ns, name) =====
ds_get_rollout_status() { $K8S rollout status ds/"$2" -n "$1"; }

# ===== ds_get_rollout_history(ns, name) =====
ds_get_rollout_history() { $K8S rollout history ds/"$2" -n "$1"; }

# ===== ds_get_events(ns, name) =====
ds_get_events() { $K8S get events -n "$1" --field-selector involvedObject.name="$2" --sort-by='.lastTimestamp'; }

# ===== ds_count(ns) =====
ds_count() {
    local c=$($K8S get ds -n "$1" --no-headers | wc -l)
    echo "Total DaemonSets in $1: $c"
}

# ===== ds_diff(ns1, ds1, ns2, ds2) =====
ds_diff() {
    diff <($K8S get ds "$2" -n "$1" -o yaml) <($K8S get ds "$4" -n "$3" -o yaml)
}

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== ds_upd_image(ns, name, container, image) =====
ds_upd_image() { $K8S set image ds/"$2" -n "$1" "$3"="$4"; }

# ===== ds_upd_scale(ns, name, max_unavailable) =====
ds_upd_scale() {
    $K8S patch ds "$2" -n "$1" --type merge -p "{\"spec\":{\"updateStrategy\":{\"rollingUpdate\":{\"maxUnavailable\":\"$3\"}}}}"
}

# ===== ds_restart(ns, name) =====
ds_restart() { $K8S rollout restart ds/"$2" -n "$1"; }

# ===== ds_pause(ns, name) =====
ds_pause() { $K8S annotate ds "$2" -n "$1" "daemonset.paused=true" --overwrite; }

# ===== ds_resume(ns, name) =====
ds_resume() { $K8S annotate ds "$2" -n "$1" "daemonset.paused-" 2>/dev/null; }

# ===== ds_rollback(ns, name, [revision]) =====
ds_rollback() { $K8S rollout undo ds/"$2" -n "$1" ${3:+--to-revision=$3}; }

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== ds_del(ns, name) =====
ds_del() { $K8S delete ds "$2" -n "$1"; }

# ===== ds_del_cascade(ns, name) =====
ds_del_cascade() { $K8S delete ds "$2" -n "$1" --cascade=foreground; }

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== ds_exists(ns, name) =====
ds_exists() { $K8S get ds "$2" -n "$1" &>/dev/null; }

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== ds_watch(ns, name, [interval]) =====
ds_watch() { watch -n "${3:-5}" "$K8S get ds $2 -n $1 -o wide"; }

# ===== ds_watch_rollout(ns, name) =====
ds_watch_rollout() { $K8S rollout status ds/"$2" -n "$1" -w; }

# ===== ds_wait_ready(ns, name, [timeout]) =====
ds_wait_ready() {
    local t="${3:-300}"
    echo "Wait up to ${t}s for ds/$2 to be ready..."
    timeout "$t" bash -c "until $K8S get ds $2 -n $1 -o jsonpath='{.status.numberReady}' | grep -q '^$($K8S get ds $2 -n $1 -o jsonpath='{.status.desiredNumberScheduled}')$'; do sleep 2; done"
}

# ===== ds_wait_del(ns, name, [timeout]) =====
ds_wait_del() { $K8S wait --for=delete ds/"$2" -n "$1" --timeout="${3:-300}s"; }

# ===== ds_backup(ns, name, file) =====
ds_backup() { $K8S get ds "$2" -n "$1" -o yaml > "$3"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
create_daemonset() { ds_add_basic "$@"; }
create_daemonset_from_file() { ds_add_f "$@"; }
create_daemonset_from_yaml() { ds_add_f "$@"; }
delete_daemonset() { ds_del "$@"; }
delete_daemonset_cascade() { ds_del_cascade "$@"; }
daemonsets() { ds_ls "$@"; }
list_daemonsets() { ds_ls "$@"; }
list_all_daemonsets() { ds_ls_all "$@"; }
daemonset_exists() { ds_exists "$@"; }
describe_daemonset() { ds_desc "$@"; }
get_daemonset_yaml() { ds_get "$@"; }
get_daemonset_status() { ds_get_status "$@"; }
get_daemonset_image() { $K8S get ds "$2" -n "$1" -o jsonpath='{.spec.template.spec.containers[*].image}'; }
get_daemonset_pods() { ds_get_pods "$@"; }
list_daemonset_pods() { ds_get_pods "$@"; }
update_daemonset_image() { ds_upd_image "$@"; }
rollout_restart_daemonset() { ds_restart "$@"; }
restart_daemonset() { ds_restart "$@"; }
pause_daemonset() { ds_pause "$@"; }
resume_daemonset() { ds_resume "$@"; }
rollback_daemonset() { ds_rollback "$@"; }
get_daemonset_rollout_status() { ds_get_rollout_status "$@"; }
get_daemonset_rollout_history() { ds_get_rollout_history "$@"; }
watch_daemonset_rollout() { ds_watch_rollout "$@"; }
wait_for_daemonset_ready() { ds_wait_ready "$@"; }
wait_for_daemonset_deleted() { ds_wait_del "$@"; }
watch_daemonset() { ds_watch "$@"; }
backup_daemonset() { ds_backup "$@"; }
copy_daemonset() { ds_clone "$@"; }
find_daemonsets_by_label() { ds_ls_label "$@"; }
find_daemonsets_with_image() { ds_ls_image "$@"; }
compare_daemonsets() { ds_diff "$@"; }
get_daemonset_events() { ds_get_events "$@"; }
count_daemonsets() { ds_count "$@"; }
scale_daemonset() { ds_upd_scale "$@"; }
