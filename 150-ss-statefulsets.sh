#!/bin/bash
help_ss(){
    echo "Func: ss_add_f (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Applies StatefulSet YAML file"
    echo "Func: ss_add_basic (\$ns, \$name, \$image, \$replicas, \$service) | Act: [cat] and [kubectl] apply | Desc: Creates basic StatefulSet"
    echo "Func: ss_add_storage (\$ns, \$name, \$image, \$reps, \$svc, \$size, [\$sc]) | Act: [cat] and [kubectl] apply | Desc: Creates SS with volumeClaimTemplates"
    echo "Func: ss_add_svc (\$ns, \$svc, \$sts, \$port, \$tport) | Act: [kubectl] create service | Desc: Creates headless service for StatefulSet"
    echo "Func: ss_gen_template (\$file, \$name, \$image, [\$ns]) | Act: [cat] > file | Desc: Generates SS and service YAML"
    echo "Func: ss_clone (\$src_ns, \$target_ns, \$sts, [\$name]) | Act: [sed] and [kubectl] apply | Desc: Clones StatefulSet"
    echo "Func: ss_ls (\$ns, [\$args...]) | Act: [kubectl] get ss | Desc: Lists StatefulSets"
    echo "Func: ss_ls_all ([\$args...]) | Act: [kubectl] get ss --all-namespaces | Desc: Lists StatefulSets in all namespaces"
    echo "Func: ss_ls_label (\$ns, \$selector) | Act: [kubectl] get ss -l | Desc: Lists StatefulSets filtered by label"
    echo "Func: ss_ls_image (\$ns, \$pattern) | Act: [jq] filter by image | Desc: Finds StatefulSets using specific image"
    echo "Func: ss_desc (\$ns, \$name) | Act: [kubectl] describe ss | Desc: Describes StatefulSet"
    echo "Func: ss_get (\$ns, \$name, [\$out]) | Act: [kubectl] get ss -o | Desc: Gets StatefulSet definition (yaml by default)"
    echo "Func: ss_get_info (\$ns, \$name) | Act: [kubectl] get ss -o wide | Desc: Gets wide StatefulSet info and pod list"
    echo "Func: ss_get_status (\$ns, \$name) | Act: [jsonpath] .status | Desc: Shows Ready/Current/Updated replicas"
    echo "Func: ss_get_pods (\$ns, \$name) | Act: [kubectl] get pods -l | Desc: Lists pods managed by StatefulSet"
    echo "Func: ss_get_replicas (\$ns, \$name) | Act: [jsonpath] .spec.replicas | Desc: Gets configured replicas"
    echo "Func: ss_get_rollout_status (\$ns, \$name) | Act: [kubectl] rollout status | Desc: Shows rollout status"
    echo "Func: ss_get_rollout_history (\$ns, \$name) | Act: [kubectl] rollout history | Desc: Shows rollout history"
    echo "Func: ss_get_pvcs (\$ns, \$name) | Act: [kubectl] get pvc -l | Desc: Lists PVCs related to this StatefulSet"
    echo "Func: ss_get_svc (\$ns, \$name) | Act: [jsonpath] .spec.serviceName | Desc: Gets related headless service"
    echo "Func: ss_get_dns (\$ns, \$name) | Act: Show DNS list | Desc: Shows internal DNS names for StatefulSet pods"
    echo "Func: ss_get_events (\$ns, \$name) | Act: [kubectl] get events | Desc: Gets events for StatefulSet"
    echo "Func: ss_get_metrics (\$ns, \$name) | Act: [kubectl] top pods | Desc: Shows resource usage for SS pods"
    echo "Func: ss_count (\$ns) | Act: [wc] -l | Desc: Counts StatefulSets in namespace"
    echo "Func: ss_diff (\$ns1, \$sts1, \$ns2, \$sts2) | Act: [kubectl] get -o json | [diff] | Desc: Diffs two SS definitions"
    echo "Func: ss_upd_image (\$ns, \$name, \$container, \$image) | Act: [kubectl] set image | Desc: Updates StatefulSet image"
    echo "Func: ss_upd_env (\$ns, \$name, \$container, \$name, \$value) | Act: [kubectl] set env | Desc: Updates env variable in SS"
    echo "Func: ss_upd_scale (\$ns, \$name, \$replicas) | Act: [kubectl] scale ss | Desc: Scales StatefulSet replicas"
    echo "Func: ss_upd_scale_up (\$ns, \$name, [\$inc]) | Act: [kubectl] scale +1 | Desc: Increments replicas"
    echo "Func: ss_upd_scale_down (\$ns, \$name, [\$dec]) | Act: [kubectl] scale -1 | Desc: Decrements replicas"
    echo "Func: ss_upd_scale_zero (\$ns, \$name) | Act: [kubectl] scale --replicas=0 | Desc: Scales StatefulSet to zero"
    echo "Func: ss_upd_strategy (\$ns, \$name, \$type) | Act: [kubectl] patch strategy | Desc: Updates updateStrategy"
    echo "Func: ss_upd_storage (\$ns, \$name, \$size) | Act: [kubectl] patch volumeClaimTemplates | Desc: Updates storage size requirement"
    echo "Func: ss_upd_label (\$ns, \$name, \$key, \$value) | Act: [kubectl] label ss | Desc: Adds/updates label"
    echo "Func: ss_upd_unlabel (\$ns, \$name, \$key) | Act: [kubectl] label ss (remove) | Desc: Removes label"
    echo "Func: ss_upd_annotate (\$ns, \$name, \$key, \$value) | Act: [kubectl] annotate ss | Desc: Adds/updates annotation"
    echo "Func: ss_restart (\$ns, \$name) | Act: [kubectl] rollout restart | Desc: Restarts StatefulSet"
    echo "Func: ss_rollback (\$ns, \$name, [\$rev]) | Act: [kubectl] rollout undo | Desc: Rolls back StatefulSet"
    echo "Func: ss_patch (\$ns, \$name, \$patch_json) | Act: [kubectl] patch ss | Desc: Applies arbitrary JSON patch"
    echo "Func: ss_del (\$ns, \$name, [\$delete_pvcs]) | Act: [kubectl] delete ss | Desc: Deletes SS and optionally PVCs"
    echo "Func: ss_del_force (\$ns, \$name) | Act: [kubectl] delete --force | Desc: Force deletes StatefulSet"
    echo "Func: ss_del_pvcs (\$ns, \$name) | Act: [kubectl] delete pvc -l | Desc: Deletes PVCs by SS label"
    echo "Func: ss_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if StatefulSet exists"
    echo "Func: ss_watch (\$ns, [\$name]) | Act: [kubectl] get ss --watch | Desc: Watches StatefulSets"
    echo "Func: ss_watch_rollout (\$ns, \$name) | Act: [kubectl] rollout status -w | Desc: Watches rollout progress"
    echo "Func: ss_wait_ready (\$ns, \$name, [\$timeout]) | Act: Poll [kubectl] status | Desc: Waits for all replicas to be ready"
    echo "Func: ss_wait_del (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait for deletion | Desc: Waits for StatefulSet deletion"
    echo "Func: ss_wait_rollout (\$ns, \$name, [\$timeout]) | Act: [kubectl] rollout status | Desc: Waits for rollout finishing"
    echo "Func: ss_valid (\$ns, \$name) | Act: [kubectl] get | Desc: Validates StatefulSet configuration existence"
    echo "Func: ss_check_ordering (\$ns, \$name) | Act: [kubectl] get pods sorted | Desc: Lists pods sorted by creation time"
    echo "Func: ss_test_conn (\$ns, \$name, [\$port]) | Act: [wget] from temp pod | Desc: Tests connection to SS pods"
    echo "Func: ss_test_persistence (\$ns, \$name) | Act: Write/Read check | Desc: Tests file persistence in /data"
    echo "Func: ss_backup (\$ns, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups StatefulSet to YAML file"
    echo "Func: ss_backup_pvcs (\$ns, \$name, \$dir) | Act: [kubectl] get pvc -o yaml > dir | Desc: Backups related PVCs to directory"
    echo "Func: ss_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores StatefulSet from file"
    echo "Func: ss_migrate_storage (\$ns, \$name, \$sc) | Act: [kubectl] patch storageClassName | Desc: Patches storage class in SS template"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== ss_add_f(ns, file) =====
ss_add_f() { $K8S apply -f "$2" -n "$1"; }

# ===== ss_add_basic(ns, name, image, replicas, service) =====
ss_add_basic() {
    local ns="$1"; local name="$2"; local img="$3"; local reps="$4"; local svc="$5"
    cat <<EOF | $K8S apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata: { name: "$name", namespace: "$ns" }
spec:
  serviceName: "$svc"
  replicas: $reps
  selector: { matchLabels: { app: "$name" } }
  template:
    metadata: { labels: { app: "$name" } }
    spec:
      containers: [ { name: "$name", image: "$img", ports: [ { containerPort: 80 } ] } ]
EOF
}

# ===== ss_add_storage(ns, name, image, reps, svc, size, [sc]) =====
ss_add_storage() {
    local ns="$1"; local name="$2"; local img="$3"; local reps="$4"; local svc="$5"; local size="$6"; local sc="$7"
    local sc_spec=""; [ -n "$sc" ] && sc_spec="storageClassName: $sc"
    cat <<EOF | $K8S apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata: { name: "$name", namespace: "$ns" }
spec:
  serviceName: "$svc"
  replicas: $reps
  selector: { matchLabels: { app: "$name" } }
  template:
    metadata: { labels: { app: "$name" } }
    spec:
      containers: [ { name: "$name", image: "$img", ports: [ { containerPort: 80 } ], volumeMounts: [ { name: data, mountPath: /data } ] } ]
  volumeClaimTemplates:
  - metadata: { name: data }
    spec: { accessModes: [ ReadWriteOnce ], resources: { requests: { storage: "$size" } }, $sc_spec }
EOF
}

# ===== ss_add_svc(ns, svc, sts, port, tport) =====
ss_add_svc() {
    local ns="$1"; local svc="$2"; local sts="$3"; local port="$4"; local tport="$5"
    cat <<EOF | $K8S apply -f -
apiVersion: v1
kind: Service
metadata: { name: "$svc", namespace: "$ns" }
spec: { clusterIP: None, selector: { app: "$sts" }, ports: [ { name: http, port: $port, targetPort: $tport } ] }
EOF
}

# ===== ss_gen_template(file, name, image, [ns]) =====
ss_gen_template() {
    local f="$1"; local n="$2"; local i="$3"; local ns="${4:-default}"
    cat > "$f" <<EOF
apiVersion: apps/v1
kind: StatefulSet
metadata: { name: "$n", namespace: "$ns", labels: { app: "$n" } }
spec:
  serviceName: "$n-headless"
  replicas: 3
  selector: { matchLabels: { app: "$n" } }
  template:
    metadata: { labels: { app: "$n" } }
    spec:
      containers:
      - name: "$n", image: "$i", ports: [ { containerPort: 80, name: http } ], volumeMounts: [ { name: data, mountPath: /data } ]
  volumeClaimTemplates:
  - metadata: { name: data }
    spec: { accessModes: [ ReadWriteOnce ], storageClassName: standard, resources: { requests: { storage: 10Gi } } }
---
apiVersion: v1
kind: Service
metadata: { name: "$n-headless", namespace: "$ns" }
spec: { clusterIP: None, selector: { app: "$n" }, ports: [ { name: http, port: 80, targetPort: 80 } ] }
EOF
}

# ===== ss_clone(src_ns, target_ns, sts, [name]) =====
ss_clone() {
    local sns="$1"; local tns="$2"; local sts="$3"; local nname="${4:-$sts}"
    $K8S get sts "$sts" -n "$sns" -o yaml | sed "s/name: $sts/name: $nname/g; s/namespace: $sns/namespace: $tns/g" | $K8S apply -f -
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== ss_ls(ns, [args...]) =====
ss_ls() { $K8S get ss -n "$1" "${@:2}"; }

# ===== ss_ls_all([args...]) =====
ss_ls_all() { $K8S get ss --all-namespaces "$@"; }

# ===== ss_ls_label(ns, selector) =====
ss_ls_label() { $K8S get ss -n "$1" -l "$2" -o wide; }

# ===== ss_ls_image(ns, pattern) =====
ss_ls_image() {
    for sts in $($K8S get ss -n "$1" -o name); do
        local n=$(echo "$sts" | cut -d/ -f2)
        local i=$($K8S get ss "$n" -n "$1" -o jsonpath='{.spec.template.spec.containers[*].image}')
        echo "$i" | grep -q "$2" && echo "✅ $n: $i"
    done
}

# ===== ss_desc(ns, name) =====
ss_desc() { $K8S describe ss "$2" -n "$1"; }

# ===== ss_get(ns, name, [out]) =====
ss_get() { [ -n "$3" ] && $K8S get ss "$2" -n "$1" -o yaml > "$3" || $K8S get ss "$2" -n "$1" -o yaml; }

# ===== ss_get_info(ns, name) =====
ss_get_info() {
    $K8S get ss "$2" -n "$1" -o custom-columns=NAME:.metadata.name,READY:.status.readyReplicas,REPS:.spec.replicas,SVC:.spec.serviceName
    echo "📦 Pods:"
    $K8S get pods -n "$1" -l app="$2" --no-headers | awk '{print "  " $1 ": " $3}'
}

# ===== ss_get_status(ns, name) =====
ss_get_status() {
    $K8S get ss "$2" -n "$1" -o custom-columns=NAME:.metadata.name,READY:.status.readyReplicas,CUR:.status.currentReplicas,UPD:.status.updatedReplicas,TOTAL:.spec.replicas
}

# ===== ss_get_pods(ns, name) =====
ss_get_pods() {
    local sel=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.selector.matchLabels}' | jq -r 'to_entries|map("\(.key)=\(.value)")|join(",")')
    $K8S get pods -n "$1" -l "$sel"
}

# ===== ss_get_replicas(ns, name) =====
ss_get_replicas() { $K8S get ss "$2" -n "$1" -o jsonpath='{.spec.replicas}'; }

# ===== ss_get_rollout_status(ns, name) =====
ss_get_rollout_status() { $K8S rollout status ss/"$2" -n "$1"; }

# ===== ss_get_rollout_history(ns, name) =====
ss_get_rollout_history() { $K8S rollout history ss/"$2" -n "$1"; }

# ===== ss_get_pvcs(ns, name) =====
ss_get_pvcs() {
    local templates=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.volumeClaimTemplates[*].metadata.name}')
    for t in $templates; do $K8S get pvc -n "$1" | grep "$t-$2"; done
}

# ===== ss_get_svc(ns, name) =====
ss_get_svc() {
    local s=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.serviceName}')
    [ -n "$s" ] && $K8S get svc "$s" -n "$1" || echo "No service found"
}

# ===== ss_get_dns(ns, name) =====
ss_get_dns() {
    local s=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.serviceName}')
    local r=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.replicas}')
    for ((i=0; i<r; i++)); do echo "  $2-$i.$s.$1.svc.cluster.local"; done
}

# ===== ss_get_events(ns, name) =====
ss_get_events() { $K8S get events -n "$1" --field-selector involvedObject.name="$2" --sort-by='.lastTimestamp'; }

# ===== ss_get_metrics(ns, name) =====
ss_get_metrics() { $K8S top pods -n "$1" -l app="$2"; }

# ===== ss_count(ns) =====
ss_count() {
    local t=$($K8S get ss -n "$1" --no-headers | wc -l)
    local r=$($K8S get ss -n "$1" --no-headers | awk '$2 == $3 && $3 > 0' | wc -l)
    echo "StatefulSets in $1: Total=$t, Ready=$r"
}

# ===== ss_diff(ns1, sts1, ns2, sts2) =====
ss_diff() {
    diff <($K8S get ss "$2" -n "$1" -o yaml) <($K8S get ss "$4" -n "$3" -o yaml)
}

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== ss_upd_image(ns, name, container, image) =====
ss_upd_image() { $K8S set image ss/"$2" "$3"="$4" -n "$1"; }

# ===== ss_upd_env(ns, name, container, name, value) =====
ss_upd_env() { $K8S set env ss/"$2" "$4"="$5" -c "$3" -n "$1"; }

# ===== ss_upd_scale(ns, name, replicas) =====
ss_upd_scale() { $K8S scale ss "$2" --replicas="$3" -n "$1"; }

# ===== ss_upd_scale_up(ns, name, [inc]) =====
ss_upd_scale_up() {
    local cur=$(ss_get_replicas "$1" "$2")
    ss_upd_scale "$1" "$2" $((cur + ${3:-1}))
}

# ===== ss_upd_scale_down(ns, name, [dec]) =====
ss_upd_scale_down() {
    local cur=$(ss_get_replicas "$1" "$2")
    local new=$((cur - ${3:-1}))
    ss_upd_scale "$1" "$2" $((new < 0 ? 0 : new))
}

# ===== ss_upd_scale_zero(ns, name) =====
ss_upd_scale_zero() { ss_upd_scale "$1" "$2" 0; }

# ===== ss_upd_strategy(ns, name, type) =====
ss_upd_strategy() { $K8S patch ss "$2" -n "$1" -p "{\"spec\":{\"updateStrategy\":{\"type\":\"$3\"}}}"; }

# ===== ss_upd_storage(ns, name, size) =====
ss_upd_storage() {
    $K8S patch ss "$2" -n "$1" --type=merge -p "{\"spec\":{\"volumeClaimTemplates\":[{\"spec\":{\"resources\":{\"requests\":{\"storage\":\"$3\"}}}}]}}"
}

# ===== ss_upd_label(ns, name, key, value) =====
ss_upd_label() { $K8S label ss "$2" "$3"="$4" -n "$1"; }

# ===== ss_upd_unlabel(ns, name, key) =====
ss_upd_unlabel() { $K8S label ss "$2" "$3-" -n "$1"; }

# ===== ss_upd_annotate(ns, name, key, value) =====
ss_upd_annotate() { $K8S annotate ss "$2" "$3"="$4" -n "$1"; }

# ===== ss_restart(ns, name) =====
ss_restart() { $K8S rollout restart ss/"$2" -n "$1"; }

# ===== ss_rollback(ns, name, [rev]) =====
ss_rollback() { $K8S rollout undo ss/"$2" -n "$1" ${3:+--to-revision=$3}; }

# ===== ss_patch(ns, name, patch_json) =====
ss_patch() { $K8S patch ss "$2" -n "$1" --type merge -p "$3"; }

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== ss_del(ns, name, [delete_pvcs]) =====
ss_del() {
    $K8S delete ss "$2" -n "$1"
    [ "$3" == "true" ] && ss_del_pvcs "$1" "$2"
}

# ===== ss_del_force(ns, name) =====
ss_del_force() { $K8S delete ss "$2" -n "$1" --force --grace-period=0; }

# ===== ss_del_pvcs(ns, name) =====
ss_del_pvcs() { $K8S delete pvc -n "$1" -l app="$2"; }

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== ss_exists(ns, name) =====
ss_exists() { $K8S get ss "$2" -n "$1" &>/dev/null; }

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== ss_watch(ns, [name]) =====
ss_watch() { [ -n "$2" ] && $K8S get ss "$2" -n "$1" --watch || $K8S get ss -n "$1" --watch; }

# ===== ss_watch_rollout(ns, name) =====
ss_watch_rollout() { $K8S rollout status ss/"$2" -n "$1" --watch=true; }

# ===== ss_wait_ready(ns, name, [timeout]) =====
ss_wait_ready() { $K8S wait --for=jsonpath='{.status.readyReplicas}'='{.status.replicas}' ss/"$2" -n "$1" --timeout="${3:-300}s"; }

# ===== ss_wait_del(ns, name, [timeout]) =====
ss_wait_del() { $K8S wait --for=delete ss/"$2" -n "$1" --timeout="${3:-300}s"; }

# ===== ss_wait_rollout(ns, name, [timeout]) =====
ss_wait_rollout() { timeout "${3:-600}" $K8S rollout status ss/"$2" -n "$1"; }

# ===== ss_valid(ns, name) =====
ss_valid() {
    ss_exists "$1" "$2" || return 1
    local s=$(ss_get_svc "$1" "$2")
    echo "Validating SS $2... Service: ${s:-Missing}"
}

# ===== ss_check_ordering(ns, name) =====
ss_check_ordering() { $K8S get pods -n "$1" -l app="$2" --sort-by=.metadata.creationTimestamp -o wide; }

# ===== ss_test_conn(ns, name, [port]) =====
ss_test_conn() {
    for p in $($K8S get pods -n "$1" -l app="$2" -o name); do
        local ip=$($K8S get "$p" -n "$1" -o jsonpath='{.status.podIP}')
        $K8S run test-$RANDOM --rm -i --image=busybox -n "$1" -- wget -qO- --timeout=2 $ip:${3:-80} || echo "Fail: $p"
    done
}

# ===== ss_test_persistence(ns, name) =====
ss_test_persistence() {
    local p=$($K8S get pods -n "$1" -l app="$2" -o jsonpath='{.items[0].metadata.name}')
    $K8S exec "$p" -n "$1" -- sh -c "echo persist > /data/test.txt && cat /data/test.txt"
}

# ===== ss_backup(ns, name, file) =====
ss_backup() { $K8S get ss "$2" -n "$1" -o yaml > "$3"; }

# ===== ss_backup_pvcs(ns, name, dir) =====
ss_backup_pvcs() {
    mkdir -p "$3"
    for p in $($K8S get pvc -n "$1" -o name | grep "$2"); do $K8S get "$p" -n "$1" -o yaml > "$3/$(basename $p).yaml"; done
}

# ===== ss_restore(file) =====
ss_restore() { $K8S apply -f "$1"; }

# ===== ss_migrate_storage(ns, name, sc) =====
ss_migrate_storage() {
    $K8S patch ss "$2" -n "$1" --type='merge' -p="{\"spec\":{\"volumeClaimTemplates\":[{\"spec\":{\"storageClassName\":\"$3\"}}]}}"
}

# ========== BACKWARD COMPATIBILITY ALIASES ==========
create_statefulset() { ss_add_basic "$@"; }
create_statefulset_from_file() { ss_add_f "$@"; }
delete_statefulset() { ss_del "$@"; }
delete_statefulset_cascade() { ss_del "$@"; } # Cascade handled by default or caller
list_statefulsets() { ss_ls "$@"; }
statefulsets() { ss_ls "$@"; }
list_all_statefulsets() { ss_ls_all "$@"; }
statefulset_exists() { ss_exists "$@"; }
describe_statefulset() { ss_desc "$@"; }
get_statefulset_yaml() { ss_get "$@"; }
get_statefulset_json() { $K8S get ss "$2" -n "$1" -o json; }
get_statefulset_status() { ss_get_status "$@"; }
get_statefulset_image() { $K8S get ss "$2" -n "$1" -o jsonpath='{.spec.template.spec.containers[*].image}'; }
get_statefulset_replicas() { ss_get_replicas "$@"; }
list_statefulset_pods() { ss_get_pods "$@"; }
scale_statefulset() { ss_upd_scale "$@"; }
scale_statefulset_up() { ss_upd_scale_up "$@"; }
scale_statefulset_down() { ss_upd_scale_down "$@"; }
update_statefulset_image() { ss_upd_image "$@"; }
patch_statefulset() { ss_patch "$@"; }
rollback_statefulset() { ss_rollback "$@"; }
restart_statefulset() { ss_restart "$@"; }
get_statefulset_rollout_status() { ss_get_rollout_status "$@"; }
get_statefulset_rollout_history() { ss_get_rollout_history "$@"; }
watch_statefulset_rollout() { ss_watch_rollout "$@"; }
get_statefulset_pvc_names() { ss_get_pvcs "$@"; }
expand_statefulset_storage() { ss_upd_storage "$@"; }
backup_statefulset_pvcs() { ss_backup_pvcs "$@"; }
create_statefulset_service() { ss_add_svc "$@"; }
get_statefulset_service() { ss_get_svc "$@"; }
test_statefulset_connectivity() { ss_test_conn "$@"; }
get_statefulset_dns_names() { ss_get_dns "$@"; }
wait_for_statefulset_ready() { ss_wait_ready "$@"; }
wait_for_statefulset_deleted() { ss_wait_del "$@"; }
wait_for_statefulset_rollout() { ss_wait_rollout "$@"; }
label_statefulset() { ss_upd_label "$@"; }
unlabel_statefulset() { ss_upd_unlabel "$@"; }
annotate_statefulset() { ss_upd_annotate "$@"; }
validate_statefulset_config() { ss_valid "$@"; }
check_statefulset_ordering() { ss_check_ordering "$@"; }
test_statefulset_persistence() { ss_test_persistence "$@"; }
clone_statefulset() { ss_clone "$@"; }
backup_statefulset() { ss_backup "$@"; }
restore_statefulset() { ss_restore "$@"; }
generate_statefulset_template() { ss_gen_template "$@"; }
get_statefulset_metrics() { ss_get_metrics "$@"; }
find_statefulsets_with_image() { ss_ls_image "$@"; }
compare_statefulsets() { ss_diff "$@"; }
migrate_statefulset_storage() { ss_migrate_storage "$@"; }
