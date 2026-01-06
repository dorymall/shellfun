#!/bin/bash
help_dp(){
    add_log_help "=== help_dp ==="
    add_log_help "Func: dp_add_f [dpaddf] (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    add_log_help "Func: dp_add_basic [dpadd] (\$ns, \$name, \$image, [\$reps]) | Act: [kubectl] create deployment | Desc: Creates basic deployment"
    add_log_help "Func: dp_add_svc [dpaddsvc] (\$ns, \$name, \$image, \$reps, \$port, [\$labels]) | Act: [kubectl] create deployment and expose | Desc: Adds deployment and service"
    add_log_help "Func: dp_add_hpa [dpaddhpa] (\$ns, \$name, \$min, \$max, \$cpu) | Act: [kubectl] autoscale deployment | Desc: Adds HPA to deployment"
    add_log_help "Func: dp_clone [dpclone] (\$ns, \$src, \$new, [\$img]) | Act: [sed] and [kubectl] apply | Desc: Clones deployment to new name/image"
    add_log_help "Func: dp_gen_template [dpgen] (\$file, \$name, \$image, [\$ns]) | Act: [cat] > file | Desc: Generates deployment YAML template"
    add_log_help "Func: dp_ls [dpls] (\$ns, [\$args...]) | Act: [kubectl] get deployments | Desc: Lists deployments"
    add_log_help "Func: dp_ls_all [dplsall] ([\$args...]) | Act: [kubectl] get deployments --all-namespaces | Desc: Lists deployments in all namespaces"
    add_log_help "Func: dp_desc [dpdesc] (\$ns, \$name) | Act: [kubectl] describe deployment | Desc: Describes deployment"
    add_log_help "Func: dp_get [dpget] (\$ns, \$name) | Act: [kubectl] get deployment -o yaml | Desc: Gets deployment YAML"
    add_log_help "Func: dp_get_info [dpinfo] (\$ns, \$name) | Act: [kubectl] get deployment -o wide | Desc: Gets wide deployment info"
    add_log_help "Func: dp_get_status [dpstatus] (\$ns, \$name) | Act: [kubectl] rollout status | Desc: Gets rollout status"
    add_log_help "Func: dp_get_pods [dppods] (\$ns, \$name) | Act: [kubectl] get pods -l | Desc: Lists pods for deployment"
    add_log_help "Func: dp_get_replicas [dpreps] (\$ns, \$name) | Act: [jsonpath] spec.replicas | Desc: Shows desired replicas count"
    add_log_help "Func: dp_get_rollout_history [dphistory] (\$ns, \$name) | Act: [kubectl] rollout history | Desc: Shows rollout revision history"
    add_log_help "Func: dp_get_events [dpevents] (\$ns, \$name) | Act: [kubectl] get events -l | Desc: Gets events for deployment"
    add_log_help "Func: dp_get_metrics [dptop] (\$ns, \$name) | Act: [kubectl] top pods -l | Desc: Shows pod metrics for deployment"
    add_log_help "Func: dp_count [dpcount] (\$ns) | Act: [wc] -l | Desc: Counts deployments in namespace"
    add_log_help "Func: dp_diff [dpdiff] (\$ns1, \$dp1, \$ns2, \$dp2) | Act: [diff] YAML | Desc: Diffs two deployments"
    add_log_help "Func: dp_ls_image [dpimgls] (\$ns, \$pattern) | Act: [grep] images | Desc: Lists deployments and their images"
    add_log_help "Func: dp_upd_image [dpimage] (\$ns, \$name, \$container, \$image) | Act: [kubectl] set image | Desc: Updates deployment image"
    add_log_help "Func: dp_upd_env [dpenv] (\$ns, \$name, \$key, \$val) | Act: [kubectl] set env | Desc: Updates/adds env variable"
    add_log_help "Func: dp_upd_scale [dpscale] (\$ns, \$name, \$replicas) | Act: [kubectl] scale | Desc: Scales deployment replicas"
    add_log_help "Func: dp_upd_scale_up [dpscaleup] (\$ns, \$name, [\$inc]) | Act: [kubectl] scale (increment) | Desc: Increments replica count"
    add_log_help "Func: dp_upd_scale_down [dpscaledown] (\$ns, \$name, [\$dec]) | Act: [kubectl] scale (decrement) | Desc: Decrements replica count"
    add_log_help "Func: dp_upd_scale_zero [dpscalezero] (\$ns, \$name) | Act: [kubectl] scale --replicas=0 | Desc: Scales deployment to zero"
    add_log_help "Func: dp_upd_strategy [dpstrategy] (\$ns, \$name, \$type) | Act: [kubectl] patch strategy | Desc: Updates deployment strategy"
    add_log_help "Func: dp_upd_label [dplabel] (\$ns, \$name, \$key, \$val) | Act: [kubectl] label deployment | Desc: Updates/adds label"
    add_log_help "Func: dp_upd_unlabel [dpunlabel] (\$ns, \$name, \$key) | Act: [kubectl] label deployment (remove) | Desc: Removes label"
    add_log_help "Func: dp_upd_annotate [dpannotate] (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate deployment | Desc: Updates/adds annotation"
    add_log_help "Func: dp_restart [dprestart] (\$ns, \$name) | Act: [kubectl] rollout restart | Desc: Restarts deployment pods"
    add_log_help "Func: dp_rollback [dprollback] (\$ns, \$name, [\$rev]) | Act: [kubectl] rollout undo | Desc: Rolls back to previous/specific version"
    add_log_help "Func: dp_patch [dppatch] (\$ns, \$name, \$patch_json) | Act: [kubectl] patch deployment | Desc: Applies arbitrary JSON patch"
    add_log_help "Func: dp_pause [dppause] (\$ns, \$name) | Act: [kubectl] rollout pause | Desc: Pauses deployment rollout"
    add_log_help "Func: dp_resume [dpresume] (\$ns, \$name) | Act: [kubectl] rollout resume | Desc: Resumes deployment rollout"
    add_log_help "Func: dp_del [dpdel] (\$ns, \$name) | Act: [kubectl] delete deployment | Desc: Deletes deployment"
    add_log_help "Func: dp_del_force [dpdelforce] (\$ns, \$name) | Act: [kubectl] delete --force | Desc: Forcefully deletes deployment"
    add_log_help "Func: dp_exists [dpexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if deployment exists"
    add_log_help "Func: dp_watch [dpwatch] (\$ns, [\$name]) | Act: [kubectl] get --watch | Desc: Watches deployments"
    add_log_help "Func: dp_watch_rollout [dpwatchroll] (\$ns, \$name) | Act: [kubectl] rollout status --watch | Desc: Watches rollout progress"
    add_log_help "Func: dp_wait_ready [dpwait] (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait --for=condition=available | Desc: Waits for deployment to be ready"
    add_log_help "Func: dp_wait_del [dpwaitdel] (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait --for=delete | Desc: Waits for deployment deletion"
    add_log_help "Func: dp_wait_rollout [dpwaitroll] (\$ns, \$name, [\$timeout]) | Act: [kubectl] rollout status --timeout | Desc: Waits for rollout with timeout"
    add_log_help "Func: dp_valid [dpvalid] (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if deployment YAML is valid"
    add_log_help "Func: dp_test_conn [dptest] (\$ns, \$name, [\$port]) | Act: [wget] from pod | Desc: Tests connection to deployment"
    add_log_help "Func: dp_backup [dpbak] (\$ns, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups deployment to YAML file"
    add_log_help "Func: dp_restore [dprestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores deployment from file"
}
# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================
dp_add_f() { 
    add_log "=== Func: dp_add_f ==="
    $K8S apply -n "$1" -f "$2" | add_log; 
}
dpaddf() { dp_add_f "$@"; }
dp_add_basic() { 
    add_log "=== Func: dp_add_basic ==="
    $K8S create deployment "$2" --image="$3" -n "$1" --replicas="${4:-1}" | add_log; 
}
dpadd() { dp_add_basic "$@"; }
dp_add_svc() {
    add_log "=== Func: dp_add_svc ==="
    local ns="$1"; local n="$2"; local img="$3"; local r="$4"; local p="$5"; local l="$6"
    dp_add_basic "$ns" "$n" "$img" "$r"
    $K8S expose deployment "$n" -n "$ns" --port="$p" --target-port="$p" --type=ClusterIP ${l:+--labels=$l} | add_log
}
dpaddsvc() { dp_add_svc "$@"; }
dp_add_hpa() { 
    add_log "=== Func: dp_add_hpa ==="
    $K8S autoscale deployment "$2" -n "$1" --min="$3" --max="$4" --cpu-percent="$5" | add_log; 
}
dpaddhpa() { dp_add_hpa "$@"; }
dp_clone() {
    add_log "=== Func: dp_clone ==="
    local ns="$1"; local src="$2"; local new="$3"; local img="$4"
    $K8S get deployment "$src" -n "$ns" -o yaml | sed "s/name: $src/name: $new/g" | ${img:+sed "s|image: .*|image: $img|g" |} $K8S apply -f - | add_log
}
dpclone() { dp_clone "$@"; }
dp_gen_template() {
    add_log "=== Func: dp_gen_template ==="
    local f="$1"; local n="$2"; local i="$3"; local ns="${4:-default}"
    cat > "$f" <<EOF
apiVersion: apps/v1
kind: Deployment
metadata: { name: "$n", namespace: "$ns", labels: { app: "$n" } }
spec:
  replicas: 3
  selector: { matchLabels: { app: "$n" } }
  template:
    metadata: { labels: { app: "$n" } }
    spec:
      containers: [ { name: "$n", image: "$i", ports: [ { containerPort: 80 } ] } ]
EOF
    add_log "Template generated at $f"
}
dpgen() { dp_gen_template "$@"; }
# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================
dp_ls() { 
    add_log "=== Func: dp_ls ==="
    $K8S get deployments -n "$1" "${@:2}" | add_log; 
}
dpls() { dp_ls "$@"; }
dp_ls_all() { 
    add_log "=== Func: dp_ls_all ==="
    $K8S get deployments --all-namespaces "$@" | add_log; 
}
dplsall() { dp_ls_all "$@"; }
dp_desc() { 
    add_log "=== Func: dp_desc ==="
    $K8S describe deployment "$2" -n "$1" | add_log; 
}
dpdesc() { dp_desc "$@"; }
dp_get() { 
    add_log "=== Func: dp_get ==="
    $K8S get deployment "$2" -n "$1" -o yaml | add_log; 
}
dpget() { dp_get "$@"; }
dp_get_info() {
    add_log "=== Func: dp_get_info ==="
    $K8S get deployment "$2" -n "$1" -o custom-columns=NAME:.metadata.name,READY:.status.readyReplicas,UP-TO-DATE:.status.updatedReplicas,AVAILABLE:.status.availableReplicas,AGE:.metadata.creationTimestamp | add_log
}
dpinfo() { dp_get_info "$@"; }
dp_get_status() { 
    add_log "=== Func: dp_get_status ==="
    $K8S rollout status deployment/"$2" -n "$1" | add_log; 
}
dpstatus() { dp_get_status "$@"; }
dp_get_pods() { 
    add_log "=== Func: dp_get_pods ==="
    $K8S get pods -n "$1" -l app="$2" | add_log; 
}
dppods() { dp_get_pods "$@"; }
dp_get_replicas() { 
    add_log "=== Func: dp_get_replicas ==="
    $K8S get deployment "$2" -n "$1" -o jsonpath='{.spec.replicas}' | add_log; 
}
dpreps() { dp_get_replicas "$@"; }
dp_get_rollout_history() { 
    add_log "=== Func: dp_get_rollout_history ==="
    $K8S rollout history deployment/"$2" -n "$1" | add_log; 
}
dphistory() { dp_get_rollout_history "$@"; }
dp_get_events() { 
    add_log "=== Func: dp_get_events ==="
    $K8S get events -n "$1" --field-selector involvedObject.name="$2" | add_log; 
}
dpevents() { dp_get_events "$@"; }
dp_get_metrics() { 
    add_log "=== Func: dp_get_metrics ==="
    $K8S top pod -n "$1" -l app="$2" | add_log; 
}
dptop() { dp_get_metrics "$@"; }
dp_count() { 
    add_log "=== Func: dp_count ==="
    $K8S get deployments -n "$1" --no-headers | wc -l | add_log; 
}
dpcount() { dp_count "$@"; }
dp_diff() { 
    add_log "=== Func: dp_diff ==="
    diff <($K8S get dp "$2" -n "$1" -o yaml) <($K8S get dp "$4" -n "$3" -o yaml) | add_log; 
}
dpdiff() { dp_diff "$@"; }
dp_ls_image() {
    add_log "=== Func: dp_ls_image ==="
    $K8S get deployments -n "$1" -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.template.spec.containers[*].image}{"\n"}{end}' | grep "$2" | add_log
}
dpimgls() { dp_ls_image "$@"; }
# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================
dp_upd_image() { 
    add_log "=== Func: dp_upd_image ==="
    $K8S set image deployment/"$2" "$3"="$4" -n "$1" | add_log; 
}
dpimage() { dp_upd_image "$@"; }
dp_upd_env() { 
    add_log "=== Func: dp_upd_env ==="
    $K8S set env deployment/"$2" "$3"="$4" -n "$1" | add_log; 
}
dpenv() { dp_upd_env "$@"; }
dp_upd_scale() { 
    add_log "=== Func: dp_upd_scale ==="
    $K8S scale deployment "$2" --replicas="$3" -n "$1" | add_log; 
}
dpscale() { dp_upd_scale "$@"; }
dp_upd_scale_up() {
    add_log "=== Func: dp_upd_scale_up ==="
    local cur=$(dp_get_replicas "$1" "$2")
    dp_upd_scale "$1" "$2" $((cur + ${3:-1}))
}
dpscaleup() { dp_upd_scale_up "$@"; }
dp_upd_scale_down() {
    add_log "=== Func: dp_upd_scale_down ==="
    local cur=$(dp_get_replicas "$1" "$2")
    local new=$((cur - ${3:-1}))
    dp_upd_scale "$1" "$2" $((new < 0 ? 0 : new))
}
dpscaledown() { dp_upd_scale_down "$@"; }
dp_upd_scale_zero() { 
    add_log "=== Func: dp_upd_scale_zero ==="
    dp_upd_scale "$1" "$2" 0; 
}
dpscalezero() { dp_upd_scale_zero "$@"; }
dp_upd_strategy() { 
    add_log "=== Func: dp_upd_strategy ==="
    $K8S patch deployment "$2" -n "$1" -p "{\"spec\":{\"strategy\":{\"type\":\"$3\"}}}" | add_log; 
}
dpstrategy() { dp_upd_strategy "$@"; }
dp_upd_label() { 
    add_log "=== Func: dp_upd_label ==="
    $K8S label deployment "$2" "$3"="$4" -n "$1" | add_log; 
}
dplabel() { dp_upd_label "$@"; }
dp_upd_unlabel() { 
    add_log "=== Func: dp_upd_unlabel ==="
    $K8S label deployment "$2" "$3-" -n "$1" | add_log; 
}
dpunlabel() { dp_upd_unlabel "$@"; }
dp_upd_annotate() { 
    add_log "=== Func: dp_upd_annotate ==="
    $K8S annotate deployment "$2" "$3"="$4" -n "$1" | add_log; 
}
dpannotate() { dp_upd_annotate "$@"; }
dp_restart() { 
    add_log "=== Func: dp_restart ==="
    $K8S rollout restart deployment/"$2" -n "$1" | add_log; 
}
dprestart() { dp_restart "$@"; }
dp_rollback() { 
    add_log "=== Func: dp_rollback ==="
    $K8S rollout undo deployment/"$2" -n "$1" ${3:+--to-revision=$3} | add_log; 
}
dprollback() { dp_rollback "$@"; }
dp_patch() { 
    add_log "=== Func: dp_patch ==="
    $K8S patch deployment "$2" -n "$1" --type merge -p "$3" | add_log; 
}
dppatch() { dp_patch "$@"; }
dp_pause() { 
    add_log "=== Func: dp_pause ==="
    $K8S rollout pause deployment/"$2" -n "$1" | add_log; 
}
dppause() { dp_pause "$@"; }
dp_resume() { 
    add_log "=== Func: dp_resume ==="
    $K8S rollout resume deployment/"$2" -n "$1" | add_log; 
}
dpresume() { dp_resume "$@"; }
# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================
dp_del() { 
    add_log "=== Func: dp_del ==="
    $K8S delete deployment "$2" -n "$1" | add_log; 
}
dpdel() { dp_del "$@"; }
dp_del_force() { 
    add_log "=== Func: dp_del_force ==="
    $K8S delete deployment "$2" -n "$1" --force --grace-period=0 | add_log; 
}
dpdelforce() { dp_del_force "$@"; }
# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================
dp_exists() { 
    add_log "=== Func: dp_exists ==="
    if $K8S get deployment "$2" -n "$1" &>/dev/null; then
        add_log "Deployment $2 exists in namespace $1"
        return 0
    else
        add_log "Deployment $2 does NOT exist in namespace $1"
        return 1
    fi
}
dpexists() { dp_exists "$@"; }
# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================
dp_watch() { 
    add_log "=== Func: dp_watch ==="
    if [ -n "$2" ]; then
        $K8S get deployment "$2" -n "$1" --watch | add_log
    else
        $K8S get deployment -n "$1" --watch | add_log
    fi
}
dpwatch() { dp_watch "$@"; }
dp_watch_rollout() { 
    add_log "=== Func: dp_watch_rollout ==="
    $K8S rollout status deployment/"$2" -n "$1" --watch=true | add_log; 
}
dpwatchroll() { dp_watch_rollout "$@"; }
dp_wait_ready() { 
    add_log "=== Func: dp_wait_ready ==="
    $K8S wait --for=condition=available deployment/"$2" -n "$1" --timeout="${3:-300}s" | add_log; 
}
dpwait() { dp_wait_ready "$@"; }
dp_wait_del() { 
    add_log "=== Func: dp_wait_del ==="
    $K8S wait --for=delete deployment/"$2" -n "$1" --timeout="${3:-300}s" | add_log; 
}
dpwaitdel() { dp_wait_del "$@"; }
dp_wait_rollout() { 
    add_log "=== Func: dp_wait_rollout ==="
    timeout "${3:-600}" $K8S rollout status deployment/"$2" -n "$1" | add_log; 
}
dpwaitroll() { dp_wait_rollout "$@"; }
dp_valid() { 
    add_log "=== Func: dp_valid ==="
    $K8S get deployment "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f - | add_log; 
}
dpvalid() { dp_valid "$@"; }
dp_test_conn() {
    add_log "=== Func: dp_test_conn ==="
    local p=$($K8S get pods -n "$1" -l app="$2" -o name | head -1)
    $K8S exec "$p" -n "$1" -- wget -qO- --timeout=2 localhost:${3:-80} | add_log
}
dptest() { dp_test_conn "$@"; }
dp_backup() { 
    add_log "=== Func: dp_backup ==="
    $K8S get deployment "$2" -n "$1" -o yaml > "$3" && add_log "Backup saved to $3"; 
}
dpbak() { dp_backup "$@"; }
dp_restore() { 
    add_log "=== Func: dp_restore ==="
    $K8S apply -f "$1" | add_log; 
}
dprestore() { dp_restore "$@"; }