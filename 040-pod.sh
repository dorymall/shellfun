#!/bin/bash
help_pd(){
    add_log_help "=== help_pd ==="
    add_log_help "Func: pd_add_f [pdaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    add_log_help "Func: pd_add_basic [pdrun] (\$ns, \$name, \$image, [\$args...]) | Act: [kubectl] run pod | Desc: Runs basic pod"
    add_log_help "Func: pd_gen_template [pdgen] (\$name, \$image, [\$ns]) | Act: [cat] > file | Desc: Generates pod YAML template"
    add_log_help "Func: pd_ls [pdls] (\$ns, [\$args...]) | Act: [kubectl] get pods | Desc: Lists pods"
    add_log_help "Func: pd_ls_all [pdlsall] ([\$args...]) | Act: [kubectl] get pods --all-namespaces | Desc: Lists pods in all namespaces"
    add_log_help "Func: pd_ls_by_phase [pdlsphase] (\$ns, \$phase) | Act: [kubectl] get pods --field-selector | Desc: Lists pods filtered by phase"
    add_log_help "Func: pd_ls_unhealthy [pdlsunhealthy] (\$ns) | Act: [grep] non-Running | Desc: Lists non-Running/Completed pods"
    add_log_help "Func: pd_ls_label [pdlslabel] (\$ns, \$selector) | Act: [kubectl] get pods -l | Desc: Lists pods filtered by label"
    add_log_help "Func: pd_count [pdcount] (\$ns) | Act: [wc] -l | Desc: Counts pods in namespace"
    add_log_help "Func: pd_get_first [pdget1] (\$ns, \$selector) | Act: [kubectl] get pods -l | Desc: Gets first pod name matching selector"
    add_log_help "Func: pd_get_info [pdinfo] (\$ns, \$pod) | Act: [kubectl] get pod -o wide | Desc: Gets wide pod info"
    add_log_help "Func: pd_desc [pddesc] (\$ns, \$pod) | Act: [kubectl] describe pod | Desc: Describes pod"
    add_log_help "Func: pd_get [pdget] (\$ns, \$pod) | Act: [kubectl] get pod -o yaml | Desc: Gets pod YAML"
    add_log_help "Func: pd_get_status [pdstatus] (\$ns, \$pod) | Act: [jsonpath] .status.phase | Desc: Gets pod execution phase"
    add_log_help "Func: pd_get_metrics [pdtop] (\$ns, \$pod) | Act: [kubectl] top pod | Desc: Shows pod resource metrics"
    add_log_help "Func: pd_get_logs [pdlogs] (\$ns, \$pod, [\$args...]) | Act: [kubectl] logs | Desc: Gets pod logs"
    add_log_help "Func: pd_get_logs_c [pdlogsc] (\$ns, \$pod, \$container, [\$args...]) | Act: [kubectl] logs -c | Desc: Gets logs for specific container"
    add_log_help "Func: pd_get_logs_f [pdlogsf] (\$ns, \$pod, [\$container]) | Act: [kubectl] logs -f | Desc: Streams pod logs"
    add_log_help "Func: pd_get_logs_p [pdlogsp] (\$ns, \$pod, [\$container]) | Act: [kubectl] logs -p | Desc: Gets logs for previous pod instance"
    add_log_help "Func: pd_debug [pddebug] (\$ns, \$pod) | Act: [kubectl] debug | Desc: Starts ephemeral debug container"
    add_log_help "Func: pd_exec [pdexec] (\$ns, \$pod, \$cmd, [\$args...]) | Act: [kubectl] exec | Desc: Executes command in pod"
    add_log_help "Func: pd_exec_c [pdexecc] (\$ns, \$pod, \$container, \$cmd, [\$args...]) | Act: [kubectl] exec -c | Desc: Executes command in specific container"
    add_log_help "Func: pd_shell [pdshell] (\$ns, \$pod, [\$container], [\$cmd...]) | Act: [kubectl] exec -it | Desc: Starts interactive shell in pod"
    add_log_help "Func: pd_pf [pdportf] (\$ns, \$pod, \$lport, \$pport, [\$bg]) | Act: [kubectl] port-forward | Desc: Forwards local port to pod port"
    add_log_help "Func: pd_cp [pdcp] (\$ns, \$pod, \$src, \$dst, [\$c]) | Act: [kubectl] cp to pod | Desc: Copies file from local to pod"
    add_log_help "Func: pd_cp_from [pdcpfrom] (\$ns, \$pod, \$src, \$dst, [\$c]) | Act: [kubectl] cp from pod | Desc: Copies file from pod to local"
    add_log_help "Func: pd_upd_label [pdlabel] (\$ns, \$pod, \$key, \$val) | Act: [kubectl] label pod | Desc: Adds/updates pod label"
    add_log_help "Func: pd_upd_unlabel [pdunlabel] (\$ns, \$pod, \$key) | Act: [kubectl] label pod (remove) | Desc: Removes label from pod"
    add_log_help "Func: pd_upd_annotate [pdannotate] (\$ns, \$pod, \$key, \$val) | Act: [kubectl] annotate pod | Desc: Adds/updates annotation"
    add_log_help "Func: pd_restart [pdrestart] (\$ns, \$pod) | Act: [kubectl] delete pod | Desc: Restarts pod by forcing recreation"
    add_log_help "Func: pd_del [pddel] (\$ns, \$pod, [\$force]) | Act: [kubectl] delete pod | Desc: Deletes pod"
    add_log_help "Func: pd_del_label [pddellabel] (\$ns, \$selector, [\$force]) | Act: [kubectl] delete pods -l | Desc: Deletes pods by label selector"
    add_log_help "Func: pd_exists [pdexists] (\$ns, \$pod) | Act: [kubectl] get &>/dev/null | Desc: Checks if pod exists"
    add_log_help "Func: pd_watch [pdwatch] (\$ns, \$pod, [\$int]) | Act: [watch] [kubectl] get pod | Desc: Watches pod status"
    add_log_help "Func: pd_wait_ready [pdwait] (\$ns, \$pod, [\$timeout]) | Act: [kubectl] wait --for=condition=ready | Desc: Waits for pod to be ready"
    add_log_help "Func: pd_wait_del [pdwaitdel] (\$ns, \$pod, [\$timeout]) | Act: [kubectl] wait --for=delete | Desc: Waits for pod deletion"
    add_log_help "Func: pd_valid [pdvalid] (\$ns, \$pod) | Act: [kubectl] apply --dry-run | Desc: Checks if pod YAML is valid"
    add_log_help "Func: pd_test_conn [pdtest] (\$ns, \$pod, \$target, [\$port]) | Act: [wget] from pod | Desc: Tests connection from pod"
    add_log_help "Func: pd_backup [pdbak] (\$ns, \$pod, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups pod to YAML file"
    add_log_help "Func: pd_restore [pdrestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores pod from file"
}
# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================
pd_add_f() { 
    add_log "=== Func: pd_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
pdaddf() { pd_add_f "$@"; }
pd_add_basic() { 
    add_log "=== Func: pd_add_basic ==="
    $K8S run "$2" --image="$3" -n "$1" "${@:4}" | add_log; 
}
pdrun() { pd_add_basic "$@"; }
pd_gen_template() {
    add_log "=== Func: pd_gen_template ==="
    local n="$1"; local i="$2"; local ns="${3:-default}"
    cat <<EOF
apiVersion: v1
kind: Pod
metadata: { name: "$n", namespace: "$ns", labels: { app: "$n" } }
spec:
  containers: [ { name: "$n", image: "$i", ports: [ { containerPort: 80 } ] } ]
EOF
    add_log "Template displayed for $n"
}
pdgen() { pd_gen_template "$@"; }
# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================
pd_ls() { 
    add_log "=== Func: pd_ls ==="
    $K8S get pods -n "$1" "${@:2}" | add_log; 
}
pdls() { pd_ls "$@"; }
pd_ls_all() { 
    add_log "=== Func: pd_ls_all ==="
    $K8S get pods --all-namespaces "$@" | add_log; 
}
pdlsall() { pd_ls_all "$@"; }
pd_ls_by_phase() { 
    add_log "=== Func: pd_ls_by_phase ==="
    $K8S get pods -n "$1" --field-selector status.phase="$2" | add_log; 
}
pdlsphase() { pd_ls_by_phase "$@"; }
pd_ls_unhealthy() { 
    add_log "=== Func: pd_ls_unhealthy ==="
    $K8S get pods -n "$1" --no-headers | grep -vE "Running|Completed" | add_log; 
}
pdlsunhealthy() { pd_ls_unhealthy "$@"; }
pd_ls_label() { 
    add_log "=== Func: pd_ls_label ==="
    $K8S get pods -n "$1" -l "$2" | add_log; 
}
pdlslabel() { pd_ls_label "$@"; }
pd_count() { 
    add_log "=== Func: pd_count ==="
    $K8S get pods -n "$1" --no-headers | wc -l | add_log; 
}
pdcount() { pd_count "$@"; }
pd_get_first() { 
    add_log "=== Func: pd_get_first ==="
    $K8S get pods -n "$1" -l "$2" -o jsonpath='{.items[0].metadata.name}' | add_log; 
}
pdget1() { pd_get_first "$@"; }
pd_get_info() {
    add_log "=== Func: pd_get_info ==="
    $K8S get pod "$2" -n "$1" -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,IP:.status.podIP,NODE:.spec.nodeName,AGE:.metadata.creationTimestamp | add_log
}
pdinfo() { pd_get_info "$@"; }
pd_desc() { 
    add_log "=== Func: pd_desc ==="
    $K8S describe pod "$2" -n "$1" | add_log; 
}
pddesc() { pd_desc "$@"; }
pd_get() { 
    add_log "=== Func: pd_get ==="
    $K8S get pod "$2" -n "$1" -o yaml | add_log; 
}
pdget() { pd_get "$@"; }
pd_get_status() { 
    add_log "=== Func: pd_get_status ==="
    $K8S get pod "$2" -n "$1" -o jsonpath='{.status.phase}' | add_log; 
}
pdstatus() { pd_get_status "$@"; }
pd_get_metrics() { 
    add_log "=== Func: pd_get_metrics ==="
    $K8S top pod "$2" -n "$1" | add_log; 
}
pdtop() { pd_get_metrics "$@"; }
pd_get_logs() { 
    add_log "=== Func: pd_get_logs ==="
    $K8S logs "$2" -n "$1" "${@:3}" | add_log; 
}
pdlogs() { pd_get_logs "$@"; }
pd_get_logs_c() { 
    add_log "=== Func: pd_get_logs_c ==="
    $K8S logs "$2" -c "$3" -n "$1" "${@:4}" | add_log; 
}
pdlogsc() { pd_get_logs_c "$@"; }
pd_get_logs_f() { 
    add_log "=== Func: pd_get_logs_f ==="
    $K8S logs "$2" -n "$1" ${3:+-c $3} -f | add_log; 
}
pdlogsf() { pd_get_logs_f "$@"; }
pd_get_logs_p() { 
    add_log "=== Func: pd_get_logs_p ==="
    $K8S logs "$2" -n "$1" ${3:+-c $3} -p | add_log; 
}
pdlogsp() { pd_get_logs_p "$@"; }
# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================
pd_upd_label() { 
    add_log "=== Func: pd_upd_label ==="
    $K8S label pod "$2" "$3"="$4" -n "$1" | add_log; 
}
pdlabel() { pd_upd_label "$@"; }
pd_upd_unlabel() { 
    add_log "=== Func: pd_upd_unlabel ==="
    $K8S label pod "$2" "$3-" -n "$1" | add_log; 
}
pdunlabel() { pd_upd_unlabel "$@"; }
pd_upd_annotate() { 
    add_log "=== Func: pd_upd_annotate ==="
    $K8S annotate pod "$2" "$3"="$4" -n "$1" | add_log; 
}
pdannotate() { pd_upd_annotate "$@"; }
pd_restart() { 
    add_log "=== Func: pd_restart ==="
    $K8S delete pod "$2" -n "$1" | add_log; 
}
pdrestart() { pd_restart "$@"; }
# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================
pd_del() {
    add_log "=== Func: pd_del ==="
    if [ "$3" == "true" ]; then $K8S delete pod "$2" -n "$1" --force --grace-period=0 | add_log; else $K8S delete pod "$2" -n "$1" | add_log; fi
}
pddel() { pd_del "$@"; }
pd_del_label() {
    add_log "=== Func: pd_del_label ==="
    if [ "$3" == "true" ]; then $K8S delete pods -n "$1" -l "$2" --force --grace-period=0 | add_log; else $K8S delete pods -n "$1" -l "$2" | add_log; fi
}
pddellabel() { pd_del_label "$@"; }
# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================
pd_exists() { 
    add_log "=== Func: pd_exists ==="
    if $K8S get pod "$2" -n "$1" &>/dev/null; then
        add_log "Pod $2 exists in namespace $1"
        return 0
    else
        add_log "Pod $2 does NOT exist in namespace $1"
        return 1
    fi
}
pdexists() { pd_exists "$@"; }
# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================
pd_debug() { 
    add_log "=== Func: pd_debug ==="
    $K8S debug "$2" -n "$1" --image=busybox -it -- /bin/sh | add_log; 
}
pddebug() { pd_debug "$@"; }
pd_exec() { 
    add_log "=== Func: pd_exec ==="
    $K8S exec "$2" -n "$1" -- "$3" "${@:4}" | add_log; 
}
pdexec() { pd_exec "$@"; }
pd_exec_c() { 
    add_log "=== Func: pd_exec_c ==="
    $K8S exec "$2" -c "$3" -n "$1" -- "$4" "${@:5}" | add_log; 
}
pdexecc() { pd_exec_c "$@"; }
pd_shell() {
    add_log "=== Func: pd_shell ==="
    local c="$3"; local cmd="${4:-/bin/sh}"
    $K8S exec -it "$2" -n "$1" ${c:+-c $c} -- $cmd | add_log
}
pdshell() { pd_shell "$@"; }
pd_pf() {
    add_log "=== Func: pd_pf ==="
    if [ "$5" == "true" ]; then
        $K8S port-forward "$2" -n "$1" "$3:$4" &
        add_log "Port-forwarding $3:$4 in background"
    else
        $K8S port-forward "$2" -n "$1" "$3:$4" | add_log
    fi
}
pdportf() { pd_pf "$@"; }
pd_cp() { 
    add_log "=== Func: pd_cp ==="
    $K8S cp "$3" "$1/$2:$4" ${5:+-c $5} | add_log; 
}
pdcp() { pd_cp "$@"; }
pd_cp_from() { 
    add_log "=== Func: pd_cp_from ==="
    $K8S cp "$1/$2:$3" "$4" ${5:+-c $5} | add_log; 
}
pdcpfrom() { pd_cp_from "$@"; }
pd_watch() { 
    add_log "=== Func: pd_watch ==="
    watch -n "${3:-2}" "$K8S get pod $2 -n $1" | add_log; 
}
pdwatch() { pd_watch "$@"; }
pd_wait_ready() { 
    add_log "=== Func: pd_wait_ready ==="
    $K8S wait --for=condition=ready pod/"$2" -n "$1" --timeout="${3:-300}s" | add_log; 
}
pdwait() { pd_wait_ready "$@"; }
pd_wait_del() { 
    add_log "=== Func: pd_wait_del ==="
    $K8S wait --for=delete pod/"$2" -n "$1" --timeout="${3:-300}s" | add_log; 
}
pdwaitdel() { pd_wait_del "$@"; }
pd_valid() { 
    add_log "=== Func: pd_valid ==="
    $K8S get pod "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f - | add_log; 
}
pdvalid() { pd_valid "$@"; }
pd_test_conn() {
    add_log "=== Func: pd_test_conn ==="
    pd_exec "$1" "$2" wget -qO- --timeout=2 "$3:${4:-80}"
}
pdtest() { pd_test_conn "$@"; }
pd_backup() { 
    add_log "=== Func: pd_backup ==="
    $K8S get pod "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
pdbak() { pd_backup "$@"; }
pd_restore() { 
    add_log "=== Func: pd_restore ==="
    $K8S apply -f "$1" | add_log; 
}
pdrestore() { pd_restore "$@"; }
