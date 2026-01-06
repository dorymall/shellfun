#!/bin/bash
help_ss(){
    add_log_help "=== help_ss ==="
    add_log_help "Func: ss_add_f [ssaddf] (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Applies StatefulSet YAML file"
    add_log_help "Func: ss_add_basic [ssadd] (\$ns, \$name, \$image, \$replicas, \$service) | Act: [cat] and [kubectl] apply | Desc: Creates basic StatefulSet"
    add_log_help "Func: ss_add_storage [ssaddstorage] (\$ns, \$name, \$image, \$reps, \$svc, \$size, [\$sc]) | Act: [cat] and [kubectl] apply | Desc: Creates SS with volumeClaimTemplates"
    add_log_help "Func: ss_add_svc [ssaddsvc] (\$ns, \$svc, \$sts, \$port, \$tport) | Act: [kubectl] create service | Desc: Creates headless service for StatefulSet"
    add_log_help "Func: ss_gen_template [ssgentemplate] (\$file, \$name, \$image, [\$ns]) | Act: [cat] > file | Desc: Generates SS and service YAML"
    add_log_help "Func: ss_clone [ssclone] (\$src_ns, \$target_ns, \$sts, [\$name]) | Act: [sed] and [kubectl] apply | Desc: Clones StatefulSet"
    add_log_help "Func: ss_ls [ssls] (\$ns, [\$args...]) | Act: [kubectl] get ss | Desc: Lists StatefulSets"
    add_log_help "Func: ss_ls_all [sslsall] ([\$args...]) | Act: [kubectl] get ss --all-namespaces | Desc: Lists StatefulSets in all namespaces"
    add_log_help "Func: ss_ls_label [sslslabel] (\$ns, \$selector) | Act: [kubectl] get ss -l | Desc: Lists StatefulSets filtered by label"
    add_log_help "Func: ss_ls_image [sslsimage] (\$ns, \$pattern) | Act: [jq] filter by image | Desc: Finds StatefulSets using specific image"
    add_log_help "Func: ss_desc [ssdesc] (\$ns, \$name) | Act: [kubectl] describe ss | Desc: Describes StatefulSet"
    add_log_help "Func: ss_get [ssget] (\$ns, \$name, [\$out]) | Act: [kubectl] get ss -o | Desc: Gets StatefulSet definition (yaml by default)"
    add_log_help "Func: ss_get_info [ssinfo] (\$ns, \$name) | Act: [kubectl] get ss -o wide | Desc: Gets wide StatefulSet info and pod list"
    add_log_help "Func: ss_get_status [ssstatus] (\$ns, \$name) | Act: [jsonpath] .status | Desc: Shows Ready/Current/Updated replicas"
    add_log_help "Func: ss_get_pods [sspods] (\$ns, \$name) | Act: [kubectl] get pods -l | Desc: Lists pods managed by StatefulSet"
    add_log_help "Func: ss_get_replicas [ssreplicas] (\$ns, \$name) | Act: [jsonpath] .spec.replicas | Desc: Gets configured replicas"
    add_log_help "Func: ss_get_rollout_status [ssrollout] (\$ns, \$name) | Act: [kubectl] rollout status | Desc: Shows rollout status"
    add_log_help "Func: ss_get_rollout_history [ssrollouthistory] (\$ns, \$name) | Act: [kubectl] rollout history | Desc: Shows rollout history"
    add_log_help "Func: ss_get_pvcs [sspvcs] (\$ns, \$name) | Act: [kubectl] get pvc -l | Desc: Lists PVCs related to this StatefulSet"
    add_log_help "Func: ss_get_svc [sssvc] (\$ns, \$name) | Act: [jsonpath] .spec.serviceName | Desc: Gets related headless service"
    add_log_help "Func: ss_get_dns [ssdns] (\$ns, \$name) | Act: Show DNS list | Desc: Shows internal DNS names for StatefulSet pods"
    add_log_help "Func: ss_get_events [ssevents] (\$ns, \$name) | Act: [kubectl] get events | Desc: Gets events for StatefulSet"
    add_log_help "Func: ss_get_metrics [ssmetrics] (\$ns, \$name) | Act: [kubectl] top pods | Desc: Shows resource usage for SS pods"
    add_log_help "Func: ss_count [sscount] (\$ns) | Act: [wc] -l | Desc: Counts StatefulSets in namespace"
    add_log_help "Func: ss_diff [ssdiff] (\$ns1, \$sts1, \$ns2, \$sts2) | Act: [kubectl] get -o json | [diff] | Desc: Diffs two SS definitions"
    add_log_help "Func: ss_upd_image [ssupdimage] (\$ns, \$name, \$container, \$image) | Act: [kubectl] set image | Desc: Updates StatefulSet image"
    add_log_help "Func: ss_upd_env [ssupdenv] (\$ns, \$name, \$container, \$name, \$value) | Act: [kubectl] set env | Desc: Updates env variable in SS"
    add_log_help "Func: ss_upd_scale [ssupdscale] (\$ns, \$name, \$replicas) | Act: [kubectl] scale ss | Desc: Scales StatefulSet replicas"
    add_log_help "Func: ss_upd_scale_up [ssupdscaleup] (\$ns, \$name, [\$inc]) | Act: [kubectl] scale +1 | Desc: Increments replicas"
    add_log_help "Func: ss_upd_scale_down [ssupdscaledown] (\$ns, \$name, [\$dec]) | Act: [kubectl] scale -1 | Desc: Decrements replicas"
    add_log_help "Func: ss_upd_scale_zero [ssupdscalezero] (\$ns, \$name) | Act: [kubectl] scale --replicas=0 | Desc: Scales StatefulSet to zero"
    add_log_help "Func: ss_upd_strategy [ssupdstrategy] (\$ns, \$name, \$type) | Act: [kubectl] patch strategy | Desc: Updates updateStrategy"
    add_log_help "Func: ss_upd_storage [ssupdstorage] (\$ns, \$name, \$size) | Act: [kubectl] patch volumeClaimTemplates | Desc: Updates storage size requirement"
    add_log_help "Func: ss_upd_label [sslabel] (\$ns, \$name, \$key, \$value) | Act: [kubectl] label ss | Desc: Adds/updates label"
    add_log_help "Func: ss_upd_unlabel [ssunlabel] (\$ns, \$name, \$key) | Act: [kubectl] label ss (remove) | Desc: Removes label"
    add_log_help "Func: ss_upd_annotate [ssannotate] (\$ns, \$name, \$key, \$value) | Act: [kubectl] annotate ss | Desc: Adds/updates annotation"
    add_log_help "Func: ss_restart [ssrestart] (\$ns, \$name) | Act: [kubectl] rollout restart | Desc: Restarts StatefulSet"
    add_log_help "Func: ss_rollback [ssrollback] (\$ns, \$name, [\$rev]) | Act: [kubectl] rollout undo | Desc: Rolls back StatefulSet"
    add_log_help "Func: ss_patch [sspatch] (\$ns, \$name, \$patch_json) | Act: [kubectl] patch ss | Desc: Applies arbitrary JSON patch"
    add_log_help "Func: ss_del [ssdel] (\$ns, \$name, [\$delete_pvcs]) | Act: [kubectl] delete ss | Desc: Deletes SS and optionally PVCs"
    add_log_help "Func: ss_del_force [ssdelforce] (\$ns, \$name) | Act: [kubectl] delete --force | Desc: Force deletes StatefulSet"
    add_log_help "Func: ss_del_pvcs [ssdelpvc] (\$ns, \$name) | Act: [kubectl] delete pvc -l | Desc: Deletes PVCs by SS label"
    add_log_help "Func: ss_exists [ssexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if StatefulSet exists"
    add_log_help "Func: ss_watch [sswatch] (\$ns, [\$name]) | Act: [kubectl] get ss --watch | Desc: Watches StatefulSets"
    add_log_help "Func: ss_watch_rollout [sswatchrollout] (\$ns, \$name) | Act: [kubectl] rollout status -w | Desc: Watches rollout progress"
    add_log_help "Func: ss_wait_ready [sswaitready] (\$ns, \$name, [\$timeout]) | Act: Poll [kubectl] status | Desc: Waits for all replicas to be ready"
    add_log_help "Func: ss_wait_del [sswaitdel] (\$ns, \$name, [\$timeout]) | Act: [kubectl] wait for deletion | Desc: Waits for StatefulSet deletion"
    add_log_help "Func: ss_wait_rollout [sswaitrollout] (\$ns, \$name, [\$timeout]) | Act: [kubectl] rollout status | Desc: Waits for rollout finishing"
    add_log_help "Func: ss_valid [ssvalid] (\$ns, \$name) | Act: [kubectl] get | Desc: Validates StatefulSet configuration existence"
    add_log_help "Func: ss_check_ordering [ssorder] (\$ns, \$name) | Act: [kubectl] get pods sorted | Desc: Lists pods sorted by creation time"
    add_log_help "Func: ss_test_conn [sstest] (\$ns, \$name, [\$port]) | Act: [wget] from temp pod | Desc: Tests connection to SS pods"
    add_log_help "Func: ss_test_persistence [sspersist] (\$ns, \$name) | Act: Write/Read check | Desc: Tests file persistence in /data"
    add_log_help "Func: ss_backup [ssbak] (\$ns, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups StatefulSet to YAML file"
    add_log_help "Func: ss_backup_pvcs [ssbakpvc] (\$ns, \$name, \$dir) | Act: [kubectl] get pvc -o yaml > dir | Desc: Backups related PVCs to directory"
    add_log_help "Func: ss_restore [ssrestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores StatefulSet from file"
    add_log_help "Func: ss_migrate_storage [ssmigrate] (\$ns, \$name, \$sc) | Act: [kubectl] patch storageClassName | Desc: Patches storage class in SS template"
}
# === CREATE / PUT OPERATIONS ===
ss_add_f() { 
    add_log "=== Func: ss_add_f ==="
    $K8S apply -f "$2" -n "$1" | add_log; 
}
ssaddf() { ss_add_f "$@"; }
ss_add_basic() {
    add_log "=== Func: ss_add_basic ==="
    local ns="$1"; local name="$2"; local img="$3"; local reps="$4"; local svc="$5"
    cat <<EOF | $K8S apply -f - | add_log
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
ssadd() { ss_add_basic "$@"; }
ss_add_storage() {
    add_log "=== Func: ss_add_storage ==="
    local ns="$1"; local name="$2"; local img="$3"; local reps="$4"; local svc="$5"; local size="$6"; local sc="$7"
    local sc_spec=""; [ -n "$sc" ] && sc_spec="storageClassName: $sc"
    cat <<EOF | $K8S apply -f - | add_log
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
ssaddstorage() { ss_add_storage "$@"; }
ss_add_svc() {
    add_log "=== Func: ss_add_svc ==="
    local ns="$1"; local svc="$2"; local sts="$3"; local port="$4"; local tport="$5"
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: v1
kind: Service
metadata: { name: "$svc", namespace: "$ns" }
spec: { clusterIP: None, selector: { app: "$sts" }, ports: [ { name: http, port: $port, targetPort: $tport } ] }
EOF
}
ssaddsvc() { ss_add_svc "$@"; }
ss_gen_template() {
    add_log "=== Func: ss_gen_template ==="
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
    add_log "Template saved to $f"
}
ssgentemplate() { ss_gen_template "$@"; }
ss_clone() {
    add_log "=== Func: ss_clone ==="
    local sns="$1"; local tns="$2"; local sts="$3"; local nname="${4:-$sts}"
    $K8S get sts "$sts" -n "$sns" -o yaml | sed "s/name: $sts/name: $nname/g; s/namespace: $sns/namespace: $tns/g" | $K8S apply -f - | add_log
}
ssclone() { ss_clone "$@"; }
# === READ / DESCRIBE / LS / GET OPERATIONS ===
ss_ls() { 
    add_log "=== Func: ss_ls ==="
    $K8S get ss -n "$1" "${@:2}" | add_log; 
}
ssls() { ss_ls "$@"; }
ss_ls_all() { 
    add_log "=== Func: ss_ls_all ==="
    $K8S get ss --all-namespaces "$@" | add_log; 
}
sslsall() { ss_ls_all "$@"; }
ss_ls_label() { 
    add_log "=== Func: ss_ls_label ==="
    $K8S get ss -n "$1" -l "$2" -o wide | add_log; 
}
sslslabel() { ss_ls_label "$@"; }
ss_ls_image() {
    add_log "=== Func: ss_ls_image ==="
    for sts in $($K8S get ss -n "$1" -o name); do
        local n=$(echo "$sts" | cut -d/ -f2)
        local i=$($K8S get ss "$n" -n "$1" -o jsonpath='{.spec.template.spec.containers[*].image}')
        echo "$i" | grep -q "$2" && add_log "✅ $n: $i"
    done
}
sslsimage() { ss_ls_image "$@"; }
ss_desc() { 
    add_log "=== Func: ss_desc ==="
    $K8S describe ss "$2" -n "$1" | add_log; 
}
ssdesc() { ss_desc "$@"; }
ss_get() { 
    add_log "=== Func: ss_get ==="
    if [ -n "$3" ]; then $K8S get ss "$2" -n "$1" -o yaml > "$3" && add_log "SS YAML saved to $3"; else $K8S get ss "$2" -n "$1" -o yaml | add_log; fi
}
ssget() { ss_get "$@"; }
ss_get_info() {
    add_log "=== Func: ss_get_info ==="
    $K8S get ss "$2" -n "$1" -o custom-columns=NAME:.metadata.name,READY:.status.readyReplicas,REPS:.spec.replicas,SVC:.spec.serviceName | add_log
    add_log "📦 Pods:"
    $K8S get pods -n "$1" -l app="$2" --no-headers | awk '{print "  " $1 ": " $3}' | add_log
}
ssinfo() { ss_get_info "$@"; }
ss_get_status() {
    add_log "=== Func: ss_get_status ==="
    $K8S get ss "$2" -n "$1" -o custom-columns=NAME:.metadata.name,READY:.status.readyReplicas,CUR:.status.currentReplicas,UPD:.status.updatedReplicas,TOTAL:.spec.replicas | add_log
}
ssstatus() { ss_get_status "$@"; }
ss_get_pods() {
    add_log "=== Func: ss_get_pods ==="
    local sel=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.selector.matchLabels}' | jq -r 'to_entries|map("\(.key)=\(.value)")|join(",")')
    $K8S get pods -n "$1" -l "$sel" | add_log
}
sspods() { ss_get_pods "$@"; }
ss_get_replicas() { 
    add_log "=== Func: ss_get_replicas ==="
    $K8S get ss "$2" -n "$1" -o jsonpath='{.spec.replicas}' | add_log; 
}
ssreplicas() { ss_get_replicas "$@"; }
ss_get_rollout_status() { 
    add_log "=== Func: ss_get_rollout_status ==="
    $K8S rollout status ss/"$2" -n "$1" | add_log; 
}
ssrollout() { ss_get_rollout_status "$@"; }
ss_get_rollout_history() { 
    add_log "=== Func: ss_get_rollout_history ==="
    $K8S rollout history ss/"$2" -n "$1" | add_log; 
}
ssrollouthistory() { ss_get_rollout_history "$@"; }
ss_get_pvcs() {
    add_log "=== Func: ss_get_pvcs ==="
    local templates=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.volumeClaimTemplates[*].metadata.name}')
    for t in $templates; do $K8S get pvc -n "$1" | grep "$t-$2" | add_log; done
}
sspvcs() { ss_get_pvcs "$@"; }
ss_get_svc() {
    add_log "=== Func: ss_get_svc ==="
    local s=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.serviceName}')
    if [ -n "$s" ]; then $K8S get svc "$s" -n "$1" | add_log; else add_log "No service found"; fi
}
sssvc() { ss_get_svc "$@"; }
ss_get_dns() {
    add_log "=== Func: ss_get_dns ==="
    local s=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.serviceName}')
    local r=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.replicas}')
    for ((i=0; i<r; i++)); do add_log "  $2-$i.$s.$1.svc.cluster.local"; done
}
ssdns() { ss_get_dns "$@"; }
ss_get_events() { 
    add_log "=== Func: ss_get_events ==="
    $K8S get events -n "$1" --field-selector involvedObject.name="$2" --sort-by='.lastTimestamp' | add_log; 
}
ssevents() { ss_get_events "$@"; }
ss_get_metrics() { 
    add_log "=== Func: ss_get_metrics ==="
    $K8S top pods -n "$1" -l app="$2" | add_log; 
}
ssmetrics() { ss_get_metrics "$@"; }
ss_count() {
    add_log "=== Func: ss_count ==="
    local t=$($K8S get ss -n "$1" --no-headers | wc -l)
    local r=$($K8S get ss -n "$1" --no-headers | awk '$2 == $3 && $3 > 0' | wc -l)
    add_log "StatefulSets in $1: Total=$t, Ready=$r"
}
sscount() { ss_count "$@"; }
ss_diff() {
    add_log "=== Func: ss_diff ==="
    diff <($K8S get ss "$2" -n "$1" -o yaml) <($K8S get ss "$4" -n "$3" -o yaml) | add_log
}
ssdiff() { ss_diff "$@"; }
# === UPDATE OPERATIONS ===
ss_upd_image() { 
    add_log "=== Func: ss_upd_image ==="
    $K8S set image ss/"$2" "$3"="$4" -n "$1" | add_log; 
}
ssupdimage() { ss_upd_image "$@"; }
ss_upd_env() { 
    add_log "=== Func: ss_upd_env ==="
    $K8S set env ss/"$2" "$4"="$5" -c "$3" -n "$1" | add_log; 
}
ssupdenv() { ss_upd_env "$@"; }
ss_upd_scale() { 
    add_log "=== Func: ss_upd_scale ==="
    $K8S scale ss "$2" --replicas="$3" -n "$1" | add_log; 
}
ssupdscale() { ss_upd_scale "$@"; }
ss_upd_scale_up() {
    add_log "=== Func: ss_upd_scale_up ==="
    local cur=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.replicas}')
    ss_upd_scale "$1" "$2" $((cur + ${3:-1}))
}
ssupdscaleup() { ss_upd_scale_up "$@"; }
ss_upd_scale_down() {
    add_log "=== Func: ss_upd_scale_down ==="
    local cur=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.replicas}')
    local new=$((cur - ${3:-1}))
    ss_upd_scale "$1" "$2" $((new < 0 ? 0 : new))
}
ssupdscaledown() { ss_upd_scale_down "$@"; }
ss_upd_scale_zero() { 
    add_log "=== Func: ss_upd_scale_zero ==="
    ss_upd_scale "$1" "$2" 0; 
}
ssupdscalezero() { ss_upd_scale_zero "$@"; }
ss_upd_strategy() { 
    add_log "=== Func: ss_upd_strategy ==="
    $K8S patch ss "$2" -n "$1" -p "{\"spec\":{\"updateStrategy\":{\"type\":\"$3\"}}}" | add_log; 
}
ssupdstrategy() { ss_upd_strategy "$@"; }
ss_upd_storage() {
    add_log "=== Func: ss_upd_storage ==="
    $K8S patch ss "$2" -n "$1" --type=merge -p "{\"spec\":{\"volumeClaimTemplates\":[{\"spec\":{\"resources\":{\"requests\":{\"storage\":\"$3\"}}}}]}}" | add_log
}
ssupdstorage() { ss_upd_storage "$@"; }
ss_upd_label() { 
    add_log "=== Func: ss_upd_label ==="
    $K8S label ss "$2" "$3"="$4" -n "$1" | add_log; 
}
sslabel() { ss_upd_label "$@"; }
ss_upd_unlabel() { 
    add_log "=== Func: ss_upd_unlabel ==="
    $K8S label ss "$2" "$3-" -n "$1" | add_log; 
}
ssunlabel() { ss_upd_unlabel "$@"; }
ss_upd_annotate() { 
    add_log "=== Func: ss_upd_annotate ==="
    $K8S annotate ss "$2" "$3"="$4" -n "$1" | add_log; 
}
ssannotate() { ss_upd_annotate "$@"; }
ss_restart() { 
    add_log "=== Func: ss_restart ==="
    $K8S rollout restart ss/"$2" -n "$1" | add_log; 
}
ssrestart() { ss_restart "$@"; }
ss_rollback() { 
    add_log "=== Func: ss_rollback ==="
    $K8S rollout undo ss/"$2" -n "$1" ${3:+--to-revision=$3} | add_log; 
}
ssrollback() { ss_rollback "$@"; }
ss_patch() { 
    add_log "=== Func: ss_patch ==="
    $K8S patch ss "$2" -n "$1" --type merge -p "$3" | add_log; 
}
sspatch() { ss_patch "$@"; }
# === DELETE OPERATIONS ===
ss_del() {
    add_log "=== Func: ss_del ==="
    $K8S delete ss "$2" -n "$1" | add_log
    [ "$3" == "true" ] && ss_del_pvcs "$1" "$2"
}
ssdel() { ss_del "$@"; }
ss_del_force() { 
    add_log "=== Func: ss_del_force ==="
    $K8S delete ss "$2" -n "$1" --force --grace-period=0 | add_log; 
}
ssdelforce() { ss_del_force "$@"; }
ss_del_pvcs() { 
    add_log "=== Func: ss_del_pvcs ==="
    $K8S delete pvc -n "$1" -l app="$2" | add_log; 
}
ssdelpvc() { ss_del_pvcs "$@"; }
# === EXISTS OPERATIONS ===
ss_exists() { 
    add_log "=== Func: ss_exists ==="
    if $K8S get ss "$2" -n "$1" &>/dev/null; then add_log "StatefulSet $2 exists in namespace $1"; return 0; else add_log "StatefulSet $2 does NOT exist in namespace $1"; return 1; fi
}
ssexists() { ss_exists "$@"; }
# === MISC OPERATIONS ===
ss_watch() { 
    add_log "=== Func: ss_watch ==="
    if [ -n "$2" ]; then $K8S get ss "$2" -n "$1" --watch | add_log; else $K8S get ss -n "$1" --watch | add_log; fi
}
sswatch() { ss_watch "$@"; }
ss_watch_rollout() { 
    add_log "=== Func: ss_watch_rollout ==="
    $K8S rollout status ss/"$2" -n "$1" --watch=true | add_log; 
}
sswatchrollout() { ss_watch_rollout "$@"; }
ss_wait_ready() { 
    add_log "=== Func: ss_wait_ready ==="
    $K8S wait --for=jsonpath='{.status.readyReplicas}'='{.status.replicas}' ss/"$2" -n "$1" --timeout="${3:-300}s" | add_log; 
}
sswaitready() { ss_wait_ready "$@"; }
ss_wait_del() { 
    add_log "=== Func: ss_wait_del ==="
    $K8S wait --for=delete ss/"$2" -n "$1" --timeout="${3:-300}s" | add_log; 
}
sswaitdel() { ss_wait_del "$@"; }
ss_wait_rollout() { 
    add_log "=== Func: ss_wait_rollout ==="
    timeout "${3:-600}" $K8S rollout status ss/"$2" -n "$1" | add_log; 
}
sswaitrollout() { ss_wait_rollout "$@"; }
ss_valid() {
    add_log "=== Func: ss_valid ==="
    ss_exists "$1" "$2" || return 1
    local s=$($K8S get ss "$2" -n "$1" -o jsonpath='{.spec.serviceName}')
    add_log "Validating SS $2... Service: ${s:-Missing}"
}
ssvalid() { ss_valid "$@"; }
ss_check_ordering() { 
    add_log "=== Func: ss_check_ordering ==="
    $K8S get pods -n "$1" -l app="$2" --sort-by=.metadata.creationTimestamp -o wide | add_log; 
}
ssorder() { ss_check_ordering "$@"; }
ss_test_conn() {
    add_log "=== Func: ss_test_conn ==="
    for p in $($K8S get pods -n "$1" -l app="$2" -o name); do
        local ip=$($K8S get "$p" -n "$1" -o jsonpath='{.status.podIP}')
        $K8S run test-$RANDOM --rm -i --image=busybox -n "$1" -- wget -qO- --timeout=2 $ip:${3:-80} | add_log || add_log "Fail: $p"
    done
}
sstest() { ss_test_conn "$@"; }
ss_test_persistence() {
    add_log "=== Func: ss_test_persistence ==="
    local p=$($K8S get pods -n "$1" -l app="$2" -o jsonpath='{.items[0].metadata.name}')
    $K8S exec "$p" -n "$1" -- sh -c "echo persist > /data/test.txt && cat /data/test.txt" | add_log
}
sspersist() { ss_test_persistence "$@"; }
ss_backup() { 
    add_log "=== Func: ss_backup ==="
    $K8S get ss "$2" -n "$1" -o yaml > "$3" && add_log "Backup saved to $3"; 
}
ssbak() { ss_backup "$@"; }
ss_backup_pvcs() {
    add_log "=== Func: ss_backup_pvcs ==="
    mkdir -p "$3"
    for p in $($K8S get pvc -n "$1" -o name | grep "$2"); do $K8S get "$p" -n "$1" -o yaml > "$3/$(basename $p).yaml"; done
    add_log "PVC backups saved to $3"
}
ssbakpvc() { ss_backup_pvcs "$@"; }
ss_restore() { 
    add_log "=== Func: ss_restore ==="
    $K8S apply -f "$1" | add_log; 
}
ssrestore() { ss_restore "$@"; }
ss_migrate_storage() {
    add_log "=== Func: ss_migrate_storage ==="
    $K8S patch ss "$2" -n "$1" --type='merge' -p="{\"spec\":{\"volumeClaimTemplates\":[{\"spec\":{\"storageClassName\":\"$3\"}}]}}" | add_log
}
ssmigrate() { ss_migrate_storage "$@"; }
