#!/bin/bash
help_ds(){
    add_log_help "=== help_ds ==="
    add_log_help "Func: ds_add_f [dsaddf] (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Applies DaemonSet YAML file"
    add_log_help "Func: ds_add_basic [dsadd] (\$ns, \$name, \$image) | Act: [cat] and [kubectl] apply | Desc: Creates basic DaemonSet"
    add_log_help "Func: ds_ls [dsls] (\$ns, [\$args...]) | Act: [kubectl] get ds | Desc: Lists DaemonSets"
    add_log_help "Func: ds_ls_all [dslsall] ([\$args...]) | Act: [kubectl] get ds --all-namespaces | Desc: Lists DaemonSets in all namespaces"
    add_log_help "Func: ds_ls_label [dslslabel] (\$ns, \$selector) | Act: [kubectl] get ds -l | Desc: Lists DaemonSets filtered by label"
    add_log_help "Func: ds_ls_image [dslsimage] (\$ns, \$pattern) | Act: [jq] filter by image | Desc: Finds DaemonSets using specific image"
    add_log_help "Func: ds_desc [dsdesc] (\$ns, \$name) | Act: [kubectl] describe ds | Desc: Describes DaemonSet"
    add_log_help "Func: ds_get [dsget] (\$ns, \$name, [\$out]) | Act: [kubectl] get ds -o | Desc: Gets DaemonSet definition (yaml by default)"
    add_log_help "Func: ds_get_info [dsinfo] (\$ns, \$name) | Act: [kubectl] get ds -o wide | Desc: Gets wide DaemonSet info"
    add_log_help "Func: ds_get_status [dsstatus] (\$ns, \$name) | Act: [jsonpath] .status | Desc: Shows Desired vs Ready status"
    add_log_help "Func: ds_get_pods [dspods] (\$ns, \$name) | Act: [kubectl] get pods -l | Desc: Lists pods managed by DaemonSet"
    add_log_help "Func: ds_get_rollout_status [dsrollout] (\$ns, \$name) | Act: [kubectl] rollout status | Desc: Shows rollout status"
    add_log_help "Func: ds_get_rollout_history [dsrollouthistory] (\$ns, \$name) | Act: [kubectl] rollout history | Desc: Shows rollout history"
    add_log_help "Func: ds_get_events [dsevents] (\$ns, \$name) | Act: [kubectl] get events | Desc: Gets events for DaemonSet"
    add_log_help "Func: ds_count [dscount] (\$ns) | Act: [wc] -l | Desc: Counts DaemonSets in namespace"
    add_log_help "Func: ds_exists [dsexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if DaemonSet exists"
    add_log_help "Func: ds_upd_image [dsupdimage] (\$ns, \$name, \$container, \$image) | Act: [kubectl] set image | Desc: Updates DaemonSet image"
    add_log_help "Func: ds_upd_scale [dsupdscale] (\$ns, \$name, \$max_unavailable) | Act: [kubectl] patch strategy | Desc: Updates update strategy"
    add_log_help "Func: ds_restart [dsrestart] (\$ns, \$name) | Act: [kubectl] rollout restart | Desc: Restarts DaemonSet"
    add_log_help "Func: ds_pause [dspause] (\$ns, \$name) | Act: [kubectl] annotate paused=true | Desc: Pauses DaemonSet"
    add_log_help "Func: ds_resume [dsresume] (\$ns, \$name) | Act: [kubectl] annotate (remove) | Desc: Resumes DaemonSet"
    add_log_help "Func: ds_rollback [dsrollback] (\$ns, \$name, [\$revision]) | Act: [kubectl] rollout undo | Desc: Rolls back DaemonSet"
    add_log_help "Func: ds_del [dsdel] (\$ns, \$name) | Act: [kubectl] delete ds | Desc: Deletes DaemonSet"
    add_log_help "Func: ds_del_cascade [dsdelc] (\$ns, \$name) | Act: [kubectl] delete --cascade=foreground | Desc: Deletes with foreground cascade"
    add_log_help "Func: ds_watch [dswatch] (\$ns, \$name, [\$interval]) | Act: [watch] kubectl get ds | Desc: Watches DaemonSet status"
    add_log_help "Func: ds_watch_rollout [dswatchrollout] (\$ns, \$name) | Act: [kubectl] rollout status -w | Desc: Watches rollout progress"
    add_log_help "Func: ds_wait_ready [dswaitready] (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait loop | Desc: Waits for all nodes to be ready"
    add_log_help "Func: ds_wait_del [dswaitdel] (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait for deletion | Desc: Waits for DaemonSet deletion"
    add_log_help "Func: ds_backup [dsbak] (\$ns, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups DaemonSet to YAML file"
    add_log_help "Func: ds_clone [dsclone] (\$source_ns, \$target_ns, \$name, [\$new_name]) | Act: [jq] and [kubectl] apply | Desc: Clones DaemonSet using jq"
    add_log_help "Func: ds_diff [dsdiff] (\$ns1, \$ds1, \$ns2, \$ds2) | Act: [kubectl] get -o json | [diff] | Desc: Diffs two DaemonSet definitions"
}
# === CREATE / PUT OPERATIONS ===
ds_add_f() { 
    add_log "=== Func: ds_add_f ==="
    $K8S apply -n "$1" -f "$2" | add_log; 
}
dsaddf() { ds_add_f "$@"; }
ds_add_basic() {
    add_log "=== Func: ds_add_basic ==="
    local ns="$1"; local name="$2"; local img="$3"
    cat <<EOF | $K8S apply -n "$ns" -f - | add_log
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
dsadd() { ds_add_basic "$@"; }
ds_clone() {
    add_log "=== Func: ds_clone ==="
    local sns="$1"; local tns="$2"; local name="$3"; local nname="${4:-$3}"
    $K8S get ds "$name" -n "$sns" -o json | jq "del(.metadata.resourceVersion, .metadata.uid, .metadata.creationTimestamp, .status) | .metadata.namespace = \"$tns\" | .metadata.name = \"$nname\"" | $K8S apply -f - | add_log
}
dsclone() { ds_clone "$@"; }
# === READ / DESCRIBE / LS / GET OPERATIONS ===
ds_ls() { 
    add_log "=== Func: ds_ls ==="
    $K8S get ds -n "$1" "${@:2}" | add_log; 
}
dsls() { ds_ls "$@"; }
ds_ls_all() { 
    add_log "=== Func: ds_ls_all ==="
    $K8S get ds --all-namespaces "$@" | add_log; 
}
dslsall() { ds_ls_all "$@"; }
ds_ls_label() { 
    add_log "=== Func: ds_ls_label ==="
    $K8S get ds -n "$1" -l "$2" | add_log; 
}
dslslabel() { ds_ls_label "$@"; }
ds_ls_image() {
    add_log "=== Func: ds_ls_image ==="
    $K8S get ds -n "$1" -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.template.spec.containers[*].image}{"\n"}{end}' | grep "$2" | add_log
}
dslsimage() { ds_ls_image "$@"; }
ds_desc() { 
    add_log "=== Func: ds_desc ==="
    $K8S describe ds "$2" -n "$1" | add_log; 
}
dsdesc() { ds_desc "$@"; }
ds_get() { 
    add_log "=== Func: ds_get ==="
    if [ -n "$3" ]; then $K8S get ds "$2" -n "$1" -o yaml > "$3" && add_log "DS YAML saved to $3"; else $K8S get ds "$2" -n "$1" -o yaml | add_log; fi
}
dsget() { ds_get "$@"; }
ds_get_info() {
    add_log "=== Func: ds_get_info ==="
    $K8S get ds "$2" -n "$1" -o custom-columns=NAME:.metadata.name,DESIRED:.status.desiredNumberScheduled,READY:.status.numberReady,NODE-SEL:.spec.template.spec.nodeSelector | add_log
}
dsinfo() { ds_get_info "$@"; }
ds_get_status() {
    add_log "=== Func: ds_get_status ==="
    local d=$($K8S get ds "$2" -n "$1" -o jsonpath='{.status.desiredNumberScheduled}')
    local r=$($K8S get ds "$2" -n "$1" -o jsonpath='{.status.numberReady}')
    add_log "DaemonSet $2: Desired=$d, Ready=$r"
}
dsstatus() { ds_get_status "$@"; }
ds_get_pods() {
    add_log "=== Func: ds_get_pods ==="
    local sel=$($K8S get ds "$2" -n "$1" -o jsonpath='{.spec.selector.matchLabels}' | jq -r 'to_entries|map("\(.key)=\(.value)")|join(",")')
    $K8S get pods -n "$1" -l "$sel" -o wide | add_log
}
dspods() { ds_get_pods "$@"; }
ds_get_rollout_status() { 
    add_log "=== Func: ds_get_rollout_status ==="
    $K8S rollout status ds/"$2" -n "$1" | add_log; 
}
dsrollout() { ds_get_rollout_status "$@"; }
ds_get_rollout_history() { 
    add_log "=== Func: ds_get_rollout_history ==="
    $K8S rollout history ds/"$2" -n "$1" | add_log; 
}
dsrollouthistory() { ds_get_rollout_history "$@"; }
ds_get_events() { 
    add_log "=== Func: ds_get_events ==="
    $K8S get events -n "$1" --field-selector involvedObject.name="$2" --sort-by='.lastTimestamp' | add_log; 
}
dsevents() { ds_get_events "$@"; }
ds_count() {
    add_log "=== Func: ds_count ==="
    local c=$($K8S get ds -n "$1" --no-headers | wc -l)
    add_log "Total DaemonSets in $1: $c"
}
dscount() { ds_count "$@"; }
ds_diff() {
    add_log "=== Func: ds_diff ==="
    diff <($K8S get ds "$2" -n "$1" -o yaml) <($K8S get ds "$4" -n "$3" -o yaml) | add_log
}
dsdiff() { ds_diff "$@"; }
# === UPDATE OPERATIONS ===
ds_upd_image() { 
    add_log "=== Func: ds_upd_image ==="
    $K8S set image ds/"$2" -n "$1" "$3"="$4" | add_log; 
}
dsupdimage() { ds_upd_image "$@"; }
ds_upd_scale() {
    add_log "=== Func: ds_upd_scale ==="
    $K8S patch ds "$2" -n "$1" --type merge -p "{\"spec\":{\"updateStrategy\":{\"rollingUpdate\":{\"maxUnavailable\":\"$3\"}}}}" | add_log
}
dsupdscale() { ds_upd_scale "$@"; }
ds_restart() { 
    add_log "=== Func: ds_restart ==="
    $K8S rollout restart ds/"$2" -n "$1" | add_log; 
}
dsrestart() { ds_restart "$@"; }
ds_pause() { 
    add_log "=== Func: ds_pause ==="
    $K8S annotate ds "$2" -n "$1" "daemonset.paused=true" --overwrite | add_log; 
}
dspause() { ds_pause "$@"; }
ds_resume() { 
    add_log "=== Func: ds_resume ==="
    $K8S annotate ds "$2" -n "$1" "daemonset.paused-" 2>/dev/null | add_log; 
}
dsresume() { ds_resume "$@"; }
ds_rollback() { 
    add_log "=== Func: ds_rollback ==="
    $K8S rollout undo ds/"$2" -n "$1" ${3:+--to-revision=$3} | add_log; 
}
dsrollback() { ds_rollback "$@"; }
# === DELETE OPERATIONS ===
ds_del() { 
    add_log "=== Func: ds_del ==="
    $K8S delete ds "$2" -n "$1" | add_log; 
}
dsdel() { ds_del "$@"; }
ds_del_cascade() { 
    add_log "=== Func: ds_del_cascade ==="
    $K8S delete ds "$2" -n "$1" --cascade=foreground | add_log; 
}
dsdelc() { ds_del_cascade "$@"; }
# === EXISTS OPERATIONS ===
ds_exists() { 
    add_log "=== Func: ds_exists ==="
    if $K8S get ds "$2" -n "$1" &>/dev/null; then add_log "DaemonSet $2 exists in namespace $1"; return 0; else add_log "DaemonSet $2 does NOT exist in namespace $1"; return 1; fi
}
dsexists() { ds_exists "$@"; }
# === MISC OPERATIONS ===
ds_watch() { 
    add_log "=== Func: ds_watch ==="
    watch -n "${3:-5}" "$K8S get ds $2 -n $1 -o wide" | add_log; 
}
dswatch() { ds_watch "$@"; }
ds_watch_rollout() { 
    add_log "=== Func: ds_watch_rollout ==="
    $K8S rollout status ds/"$2" -n "$1" -w | add_log; 
}
dswatchrollout() { ds_watch_rollout "$@"; }
ds_wait_ready() {
    add_log "=== Func: ds_wait_ready ==="
    local t="${3:-300}"
    add_log "Wait up to ${t}s for ds/$2 to be ready..."
    timeout "$t" bash -c "until $K8S get ds $2 -n $1 -o jsonpath='{.status.numberReady}' | grep -q '^$($K8S get ds $2 -n $1 -o jsonpath='{.status.desiredNumberScheduled}')$'; do sleep 2; done" | add_log
}
dswaitready() { ds_wait_ready "$@"; }
ds_wait_del() { 
    add_log "=== Func: ds_wait_del ==="
    $K8S wait --for=delete ds/"$2" -n "$1" --timeout="${3:-300}s" | add_log; 
}
dswaitdel() { ds_wait_del "$@"; }
ds_backup() { 
    add_log "=== Func: ds_backup ==="
    $K8S get ds "$2" -n "$1" -o yaml > "$3" && add_log "Backup saved to $3"; 
}
dsbak() { ds_backup "$@"; }
