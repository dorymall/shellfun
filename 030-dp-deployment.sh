#!/bin/bash
help_dp(){
    echo "Func: dp_add_f (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    echo "Func: dp_add_basic (\$ns, \$name, \$image, [\$reps]) | Act: [kubectl] create deployment | Desc: Creates basic deployment"
    echo "Func: dp_add_svc (\$ns, \$name, \$image, \$reps, \$port, [\$labels]) | Act: [kubectl] create deployment and expose | Desc: Adds deployment and service"
    echo "Func: dp_add_hpa (\$ns, \$name, \$min, \$max, \$cpu) | Act: [kubectl] autoscale deployment | Desc: Adds HPA to deployment"
    echo "Func: dp_clone (\$ns, \$src, \$new, [\$img]) | Act: [sed] and [kubectl] apply | Desc: Clones deployment to new name/image"
    echo "Func: dp_gen_template (\$file, \$name, \$image, [\$ns]) | Act: [cat] > file | Desc: Generates deployment YAML template"
    echo "Func: dp_ls (\$ns, [\$args...]) | Act: [kubectl] get deployments | Desc: Lists deployments"
    echo "Func: dp_ls_all ([\$args...]) | Act: [kubectl] get deployments --all-namespaces | Desc: Lists deployments in all namespaces"
    echo "Func: dp_desc (\$ns, \$name) | Act: [kubectl] describe deployment | Desc: Describes deployment"
    echo "Func: dp_get (\$ns, \$name) | Act: [kubectl] get deployment -o yaml | Desc: Gets deployment YAML"
    echo "Func: dp_get_info (\$ns, \$name) | Act: [kubectl] get deployment -o wide | Desc: Gets wide deployment info"
    echo "Func: dp_get_status (\$ns, \$name) | Act: [kubectl] rollout status | Desc: Gets rollout status"
    echo "Func: dp_get_pods (\$ns, \$name) | Act: [kubectl] get pods -l | Desc: Lists pods for deployment"
    echo "Func: dp_get_replicas (\$ns, \$name) | Act: [jsonpath] spec.replicas | Desc: Shows desired replicas count"
    echo "Func: dp_get_rollout_status (\$ns, \$name) | Act: Alias for dp_get_status | Desc: Gets rollout status"
    echo "Func: dp_get_rollout_history (\$ns, \$name) | Act: [kubectl] rollout history | Desc: Shows rollout revision history"
    echo "Func: dp_get_events (\$ns, \$name) | Act: [kubectl] get events -l | Desc: Gets events for deployment"
    echo "Func: dp_get_metrics (\$ns, \$name) | Act: [kubectl] top pods -l | Desc: Shows pod metrics for deployment"
    echo "Func: dp_count (\$ns) | Act: [wc] -l | Desc: Counts deployments in namespace"
    echo "Func: dp_diff (\$ns1, \$dp1, \$ns2, \$dp2) | Act: [diff] YAML | Desc: Diffs two deployments"
    echo "Func: dp_ls_image (\$ns, \$pattern) | Act: [grep] images | Desc: Lists deployments and their images"
    echo "Func: dp_upd_image (\$ns, \$name, \$container, \$image) | Act: [kubectl] set image | Desc: Updates deployment image"
    echo "Func: dp_upd_env (\$ns, \$name, \$key, \$val) | Act: [kubectl] set env | Desc: Updates/adds env variable"
    echo "Func: dp_upd_scale (\$ns, \$name, \$replicas) | Act: [kubectl] scale | Desc: Scales deployment replicas"
    echo "Func: dp_upd_scale_up (\$ns, \$name, [\$inc]) | Act: [kubectl] scale (increment) | Desc: Increments replica count"
    echo "Func: dp_upd_scale_down (\$ns, \$name, [\$dec]) | Act: [kubectl] scale (decrement) | Desc: Decrements replica count"
    echo "Func: dp_upd_scale_zero (\$ns, \$name) | Act: [kubectl] scale --replicas=0 | Desc: Scales deployment to zero"
    echo "Func: dp_upd_strategy (\$ns, \$name, \$type) | Act: [kubectl] patch strategy | Desc: Updates deployment strategy"
    echo "Func: dp_upd_label (\$ns, \$name, \$key, \$val) | Act: [kubectl] label deployment | Desc: Updates/adds label"
    echo "Func: dp_upd_unlabel (\$ns, \$name, \$key) | Act: [kubectl] label deployment (remove) | Desc: Removes label"
    echo "Func: dp_upd_annotate (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate deployment | Desc: Updates/adds annotation"
    echo "Func: dp_restart (\$ns, \$name) | Act: [kubectl] rollout restart | Desc: Restarts deployment pods"
    echo "Func: dp_rollback (\$ns, \$name, [\$rev]) | Act: [kubectl] rollout undo | Desc: Rolls back to previous/specific version"
    echo "Func: dp_patch (\$ns, \$name, \$patch_json) | Act: [kubectl] patch deployment | Desc: Applies arbitrary JSON patch"
    echo "Func: dp_pause (\$ns, \$name) | Act: [kubectl] rollout pause | Desc: Pauses deployment rollout"
    echo "Func: dp_resume (\$ns, \$name) | Act: [kubectl] rollout resume | Desc: Resumes deployment rollout"
    echo "Func: dp_del (\$ns, \$name) | Act: [kubectl] delete deployment | Desc: Deletes deployment"
    echo "Func: dp_del_force (\$ns, \$name) | Act: [kubectl] delete --force | Desc: Forcefully deletes deployment"
    echo "Func: dp_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if deployment exists"
    echo "Func: dp_watch (\$ns, [\$name]) | Act: [kubectl] get --watch | Desc: Watches deployments"
    echo "Func: dp_watch_rollout (\$ns, \$name) | Act: [kubectl] rollout status --watch | Desc: Watches rollout progress"
    echo "Func: dp_wait_ready (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait --for=condition=available | Desc: Waits for deployment to be ready"
    echo "Func: dp_wait_del (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait --for=delete | Desc: Waits for deployment deletion"
    echo "Func: dp_wait_rollout (\$ns, \$name, [\$timeout]) | Act: [kubectl] rollout status --timeout | Desc: Waits for rollout with timeout"
    echo "Func: dp_valid (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if deployment YAML is valid"
    echo "Func: dp_test_conn (\$ns, \$name, [\$port]) | Act: [wget] from pod | Desc: Tests connection to deployment"
    echo "Func: dp_backup (\$ns, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups deployment to YAML file"
    echo "Func: dp_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores deployment from file"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== dp_add_f(ns, file) =====
dp_add_f() { $K8S apply -n "$1" -f "$2"; }

# ===== dp_add_basic(ns, name, image, [reps]) =====
dp_add_basic() { $K8S create deployment "$2" --image="$3" -n "$1" --replicas="${4:-1}"; }

# ===== dp_add_svc(ns, name, image, reps, port, [labels]) =====
dp_add_svc() {
    local ns="$1"; local n="$2"; local img="$3"; local r="$4"; local p="$5"; local l="$6"
    dp_add_basic "$ns" "$n" "$img" "$r"
    $K8S expose deployment "$n" -n "$ns" --port="$p" --target-port="$p" --type=ClusterIP ${l:+--labels=$l}
}

# ===== dp_add_hpa(ns, name, min, max, cpu) =====
dp_add_hpa() { $K8S autoscale deployment "$2" -n "$1" --min="$3" --max="$4" --cpu-percent="$5"; }

# ===== dp_clone(ns, src, new, [img]) =====
dp_clone() {
    local ns="$1"; local src="$2"; local new="$3"; local img="$4"
    $K8S get deployment "$src" -n "$ns" -o yaml | \
    sed "s/name: $src/name: $new/g" | \
    ${img:+sed "s|image: .*|image: $img|g" |} \
    $K8S apply -f -
}

# ===== dp_gen_template(file, name, image, [ns]) =====
dp_gen_template() {
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
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== dp_ls(ns, [args...]) =====
dp_ls() { $K8S get deployments -n "$1" "${@:2}"; }

# ===== dp_ls_all([args...]) =====
dp_ls_all() { $K8S get deployments --all-namespaces "$@"; }

# ===== dp_desc(ns, name) =====
dp_desc() { $K8S describe deployment "$2" -n "$1"; }

# ===== dp_get(ns, name) =====
dp_get() { $K8S get deployment "$2" -n "$1" -o yaml; }

# ===== dp_get_info(ns, name) =====
dp_get_info() {
    $K8S get deployment "$2" -n "$1" -o custom-columns=NAME:.metadata.name,READY:.status.readyReplicas,UP-TO-DATE:.status.updatedReplicas,AVAILABLE:.status.availableReplicas,AGE:.metadata.creationTimestamp
}

# ===== dp_get_status(ns, name) =====
dp_get_status() { $K8S rollout status deployment/"$2" -n "$1"; }

# ===== dp_get_pods(ns, name) =====
dp_get_pods() { $K8S get pods -n "$1" -l app="$2"; }

# ===== dp_get_replicas(ns, name) =====
dp_get_replicas() { $K8S get deployment "$2" -n "$1" -o jsonpath='{.spec.replicas}'; }

# ===== dp_get_rollout_status(ns, name) =====
dp_get_rollout_status() { $K8S rollout status deployment/"$2" -n "$1"; }

# ===== dp_get_rollout_history(ns, name) =====
dp_get_rollout_history() { $K8S rollout history deployment/"$2" -n "$1"; }

# ===== dp_get_events(ns, name) =====
dp_get_events() { $K8S get events -n "$1" --field-selector involvedObject.name="$2"; }

# ===== dp_get_metrics(ns, name) =====
dp_get_metrics() { $K8S top pod -n "$1" -l app="$2"; }

# ===== dp_count(ns) =====
dp_count() { $K8S get deployments -n "$1" --no-headers | wc -l; }

# ===== dp_diff(ns1, dp1, ns2, dp2) =====
dp_diff() { diff <($K8S get dp "$2" -n "$1" -o yaml) <($K8S get dp "$4" -n "$3" -o yaml); }

# ===== dp_ls_image(ns, pattern) =====
dp_ls_image() {
    $K8S get deployments -n "$1" -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.template.spec.containers[*].image}{"\n"}{end}' | grep "$2"
}

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== dp_upd_image(ns, name, container, image) =====
dp_upd_image() { $K8S set image deployment/"$2" "$3"="$4" -n "$1"; }

# ===== dp_upd_env(ns, name, key, val) =====
dp_upd_env() { $K8S set env deployment/"$2" "$3"="$4" -n "$1"; }

# ===== dp_upd_scale(ns, name, replicas) =====
dp_upd_scale() { $K8S scale deployment "$2" --replicas="$3" -n "$1"; }

# ===== dp_upd_scale_up(ns, name, [inc]) =====
dp_upd_scale_up() {
    local cur=$(dp_get_replicas "$1" "$2")
    dp_upd_scale "$1" "$2" $((cur + ${3:-1}))
}

# ===== dp_upd_scale_down(ns, name, [dec]) =====
dp_upd_scale_down() {
    local cur=$(dp_get_replicas "$1" "$2")
    local new=$((cur - ${3:-1}))
    dp_upd_scale "$1" "$2" $((new < 0 ? 0 : new))
}

# ===== dp_upd_scale_zero(ns, name) =====
dp_upd_scale_zero() { dp_upd_scale "$1" "$2" 0; }

# ===== dp_upd_strategy(ns, name, type) =====
dp_upd_strategy() { $K8S patch deployment "$2" -n "$1" -p "{\"spec\":{\"strategy\":{\"type\":\"$3\"}}}"; }

# ===== dp_upd_label(ns, name, key, val) =====
dp_upd_label() { $K8S label deployment "$2" "$3"="$4" -n "$1"; }

# ===== dp_upd_unlabel(ns, name, key) =====
dp_upd_unlabel() { $K8S label deployment "$2" "$3-" -n "$1"; }

# ===== dp_upd_annotate(ns, name, key, val) =====
dp_upd_annotate() { $K8S annotate deployment "$2" "$3"="$4" -n "$1"; }

# ===== dp_restart(ns, name) =====
dp_restart() { $K8S rollout restart deployment/"$2" -n "$1"; }

# ===== dp_rollback(ns, name, [rev]) =====
dp_rollback() { $K8S rollout undo deployment/"$2" -n "$1" ${3:+--to-revision=$3}; }

# ===== dp_patch(ns, name, patch_json) =====
dp_patch() { $K8S patch deployment "$2" -n "$1" --type merge -p "$3"; }

# ===== dp_pause(ns, name) =====
dp_pause() { $K8S rollout pause deployment/"$2" -n "$1"; }

# ===== dp_resume(ns, name) =====
dp_resume() { $K8S rollout resume deployment/"$2" -n "$1"; }

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== dp_del(ns, name) =====
dp_del() { $K8S delete deployment "$2" -n "$1"; }

# ===== dp_del_force(ns, name) =====
dp_del_force() { $K8S delete deployment "$2" -n "$1" --force --grace-period=0; }

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== dp_exists(ns, name) =====
dp_exists() { $K8S get deployment "$2" -n "$1" &>/dev/null; }

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== dp_watch(ns, [name]) =====
dp_watch() { [ -n "$2" ] && $K8S get deployment "$2" -n "$1" --watch || $K8S get deployment -n "$1" --watch; }

# ===== dp_watch_rollout(ns, name) =====
dp_watch_rollout() { $K8S rollout status deployment/"$2" -n "$1" --watch=true; }

# ===== dp_wait_ready(ns, name, [timeout]) =====
dp_wait_ready() { $K8S wait --for=condition=available deployment/"$2" -n "$1" --timeout="${3:-300}s"; }

# ===== dp_wait_del(ns, name, [timeout]) =====
dp_wait_del() { $K8S wait --for=delete deployment/"$2" -n "$1" --timeout="${3:-300}s"; }

# ===== dp_wait_rollout(ns, name, [timeout]) =====
dp_wait_rollout() { timeout "${3:-600}" $K8S rollout status deployment/"$2" -n "$1"; }

# ===== dp_valid(ns, name) =====
dp_valid() { $K8S get deployment "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== dp_test_conn(ns, name, [port]) =====
dp_test_conn() {
    local p=$($K8S get pods -n "$1" -l app="$2" -o name | head -1)
    $K8S exec "$p" -n "$1" -- wget -qO- --timeout=2 localhost:${3:-80}
}

# ===== dp_backup(ns, name, file) =====
dp_backup() { $K8S get deployment "$2" -n "$1" -o yaml > "$3"; }

# ===== dp_restore(file) =====
dp_restore() { $K8S apply -f "$1"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
dp_add() { dp_add_basic "$@"; }
dp_add_by_file() { dp_add_f "$@"; }
dp_add_adv() { dp_add_svc "$@"; }
dp_put() { dp_add_basic "$@"; }
dp_ls_pods() { dp_get_pods "$@"; }
dp_get_img() { $K8S get deployment "$2" -n "$1" -o jsonpath="{.spec.template.spec.containers[${3:-0}].image}"; }
dp_get_lbls() { $K8S get deployment "$2" -n "$1" -o jsonpath='{.metadata.labels}'; }
dp_get_spec() { $K8S get deployment "$2" -n "$1" -o jsonpath='{.spec}'; }
dp_get_json() { $K8S get deployment "$2" -n "$1" -o json; }
dp_rollout_status() { dp_get_rollout_status "$@"; }
dp_rollout_history() { dp_get_rollout_history "$@"; }
dp_health_check() { dp_valid "$@"; }
dp_events() { dp_get_events "$@"; }
dp_scale() { dp_upd_scale "$@"; }
dp_scale_up() { dp_upd_scale_up "$@"; }
dp_scale_down() { dp_upd_scale_down "$@"; }
dp_scale_zero() { dp_upd_scale_zero "$@"; }
dp_atsc() { dp_add_hpa "$@"; }
dp_upd_img() { dp_upd_image "$@"; }
dp_set_env() { dp_upd_env "$@"; }
dp_rollout_pause() { dp_pause "$@"; }
dp_rollout_resume() { dp_resume "$@"; }
dp_cp() {
    local sns="$1"; local tns="$2"; local dp="$3"; local nname="${4:-$dp}"
    $K8S get deployment "$dp" -n "$sns" -o yaml | sed "s/name: $dp/name: $nname/g; s/namespace: $sns/namespace: $tns/g" | $K8S apply -f -
}
dp_stats() { dp_get_info "$@"; }
dp_find_by_img() { dp_ls_image "$@"; }
compare_deployments() { dp_diff "$@"; }
dp_compare() { dp_diff "$@"; }
dp_rollout_watch() { dp_watch_rollout "$@"; }
create_deployment() { dp_add_basic "$@"; }
delete_deployment() { dp_del "$@"; }
list_deployments() { dp_ls "$@"; }
deployment_exists() { dp_exists "$@"; }
describe_deployment() { dp_desc "$@"; }
get_deployment_yaml() { dp_get "$@"; }
scale_deployment() { dp_upd_scale "$@"; }
update_deployment_image() { dp_upd_image "$@"; }
restart_deployment() { dp_restart "$@"; }
rollback_deployment() { dp_rollback "$@"; }
pause_deployment() { dp_pause "$@"; }
resume_deployment() { dp_resume "$@"; }
watch_deployment() { dp_watch "$@"; }
backup_deployment() { dp_backup "$@"; }
restore_deployment() { dp_restore "$@"; }
generate_deployment_template() { dp_gen_template "$@"; }