#!/bin/bash
help_pd(){
    echo "Func: pd_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    echo "Func: pd_add_basic (\$ns, \$name, \$image, [\$args...]) | Act: [kubectl] run pod | Desc: Runs basic pod"
    echo "Func: pd_gen_template (\$name, \$image, [\$ns]) | Act: [cat] > file | Desc: Generates pod YAML template"
    echo "Func: pd_ls (\$ns, [\$args...]) | Act: [kubectl] get pods | Desc: Lists pods"
    echo "Func: pd_ls_all ([\$args...]) | Act: [kubectl] get pods --all-namespaces | Desc: Lists pods in all namespaces"
    echo "Func: pd_ls_by_phase (\$ns, \$phase) | Act: [kubectl] get pods --field-selector | Desc: Lists pods filtered by phase"
    echo "Func: pd_ls_unhealthy (\$ns) | Act: [grep] non-Running | Desc: Lists non-Running/Completed pods"
    echo "Func: pd_ls_label (\$ns, \$selector) | Act: [kubectl] get pods -l | Desc: Lists pods filtered by label"
    echo "Func: pd_count (\$ns) | Act: [wc] -l | Desc: Counts pods in namespace"
    echo "Func: pd_get_first (\$ns, \$selector) | Act: [kubectl] get pods -l | Desc: Gets first pod name matching selector"
    echo "Func: pd_get_info (\$ns, \$pod) | Act: [kubectl] get pod -o wide | Desc: Gets wide pod info"
    echo "Func: pd_desc (\$ns, \$pod) | Act: [kubectl] describe pod | Desc: Describes pod"
    echo "Func: pd_get (\$ns, \$pod) | Act: [kubectl] get pod -o yaml | Desc: Gets pod YAML"
    echo "Func: pd_get_status (\$ns, \$pod) | Act: [jsonpath] .status.phase | Desc: Gets pod execution phase"
    echo "Func: pd_get_metrics (\$ns, \$pod) | Act: [kubectl] top pod | Desc: Shows pod resource metrics"
    echo "Func: pd_get_logs (\$ns, \$pod, [\$args...]) | Act: [kubectl] logs | Desc: Gets pod logs"
    echo "Func: pd_get_logs_c (\$ns, \$pod, \$container, [\$args...]) | Act: [kubectl] logs -c | Desc: Gets logs for specific container"
    echo "Func: pd_get_logs_f (\$ns, \$pod, [\$container]) | Act: [kubectl] logs -f | Desc: Streams pod logs"
    echo "Func: pd_get_logs_p (\$ns, \$pod, [\$container]) | Act: [kubectl] logs -p | Desc: Gets logs for previous pod instance"
    echo "Func: pd_debug (\$ns, \$pod) | Act: [kubectl] debug | Desc: Starts ephemeral debug container"
    echo "Func: pd_exec (\$ns, \$pod, \$cmd, [\$args...]) | Act: [kubectl] exec | Desc: Executes command in pod"
    echo "Func: pd_exec_c (\$ns, \$pod, \$container, \$cmd, [\$args...]) | Act: [kubectl] exec -c | Desc: Executes command in specific container"
    echo "Func: pd_shell (\$ns, \$pod, [\$container], [\$cmd...]) | Act: [kubectl] exec -it | Desc: Starts interactive shell in pod"
    echo "Func: pd_pf (\$ns, \$pod, \$lport, \$pport, [\$bg]) | Act: [kubectl] port-forward | Desc: Forwards local port to pod port"
    echo "Func: pd_cp (\$ns, \$pod, \$src, \$dst, [\$c]) | Act: [kubectl] cp to pod | Desc: Copies file from local to pod"
    echo "Func: pd_cp_from (\$ns, \$pod, \$src, \$dst, [\$c]) | Act: [kubectl] cp from pod | Desc: Copies file from pod to local"
    echo "Func: pd_upd_label (\$ns, \$pod, \$key, \$val) | Act: [kubectl] label pod | Desc: Adds/updates pod label"
    echo "Func: pd_upd_unlabel (\$ns, \$pod, \$key) | Act: [kubectl] label pod (remove) | Desc: Removes label from pod"
    echo "Func: pd_upd_annotate (\$ns, \$pod, \$key, \$val) | Act: [kubectl] annotate pod | Desc: Adds/updates annotation"
    echo "Func: pd_restart (\$ns, \$pod) | Act: [kubectl] delete pod | Desc: Restarts pod by forcing recreation"
    echo "Func: pd_del (\$ns, \$pod, [\$force]) | Act: [kubectl] delete pod | Desc: Deletes pod"
    echo "Func: pd_del_label (\$ns, \$selector, [\$force]) | Act: [kubectl] delete pods -l | Desc: Deletes pods by label selector"
    echo "Func: pd_exists (\$ns, \$pod) | Act: [kubectl] get &>/dev/null | Desc: Checks if pod exists"
    echo "Func: pd_watch (\$ns, \$pod, [\$int]) | Act: [watch] [kubectl] get pod | Desc: Watches pod status"
    echo "Func: pd_wait_ready (\$ns, \$pod, [\$timeout]) | Act: [kubectl] wait --for=condition=ready | Desc: Waits for pod to be ready"
    echo "Func: pd_wait_del (\$ns, \$pod, [\$timeout]) | Act: [kubectl] wait --for=delete | Desc: Waits for pod deletion"
    echo "Func: pd_valid (\$ns, \$pod) | Act: [kubectl] apply --dry-run | Desc: Checks if pod YAML is valid"
    echo "Func: pd_test_conn (\$ns, \$pod, \$target, [\$port]) | Act: [wget] from pod | Desc: Tests connection from pod"
    echo "Func: pd_backup (\$ns, \$pod, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups pod to YAML file"
    echo "Func: pd_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores pod from file"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== pd_add_f(file) =====
pd_add_f() { $K8S apply -f "$1"; }

# ===== pd_add_basic(ns, name, image, [args...]) =====
pd_add_basic() { $K8S run "$2" --image="$3" -n "$1" "${@:4}"; }

# ===== pd_gen_template(name, image, [ns]) =====
pd_gen_template() {
    local n="$1"; local i="$2"; local ns="${3:-default}"
    cat <<EOF
apiVersion: v1
kind: Pod
metadata: { name: "$n", namespace: "$ns", labels: { app: "$n" } }
spec:
  containers: [ { name: "$n", image: "$i", ports: [ { containerPort: 80 } ] } ]
EOF
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== pd_ls(ns, [args...]) =====
pd_ls() { $K8S get pods -n "$1" "${@:2}"; }

# ===== pd_ls_all([args...]) =====
pd_ls_all() { $K8S get pods --all-namespaces "$@"; }

# ===== pd_ls_by_phase(ns, phase) =====
pd_ls_by_phase() { $K8S get pods -n "$1" --field-selector status.phase="$2"; }

# ===== pd_ls_unhealthy(ns) =====
pd_ls_unhealthy() { $K8S get pods -n "$1" --no-headers | grep -vE "Running|Completed"; }

# ===== pd_ls_label(ns, selector) =====
pd_ls_label() { $K8S get pods -n "$1" -l "$2"; }

# ===== pd_count(ns) =====
pd_count() { $K8S get pods -n "$1" --no-headers | wc -l; }

# ===== pd_get_first(ns, selector) =====
pd_get_first() { $K8S get pods -n "$1" -l "$2" -o jsonpath='{.items[0].metadata.name}'; }

# ===== pd_get_info(ns, pod) =====
pd_get_info() {
    $K8S get pod "$2" -n "$1" -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,IP:.status.podIP,NODE:.spec.nodeName,AGE:.metadata.creationTimestamp
}

# ===== pd_desc(ns, pod) =====
pd_desc() { $K8S describe pod "$2" -n "$1"; }

# ===== pd_get(ns, pod) =====
pd_get() { $K8S get pod "$2" -n "$1" -o yaml; }

# ===== pd_get_status(ns, pod) =====
pd_get_status() { $K8S get pod "$2" -n "$1" -o jsonpath='{.status.phase}'; }

# ===== pd_get_metrics(ns, pod) =====
pd_get_metrics() { $K8S top pod "$2" -n "$1"; }

# ===== pd_get_logs(ns, pod, [args...]) =====
pd_get_logs() { $K8S logs "$2" -n "$1" "${@:3}"; }

# ===== pd_get_logs_c(ns, pod, container, [args...]) =====
pd_get_logs_c() { $K8S logs "$2" -c "$3" -n "$1" "${@:4}"; }

# ===== pd_get_logs_f(ns, pod, [container]) =====
pd_get_logs_f() { $K8S logs "$2" -n "$1" ${3:+-c $3} -f; }

# ===== pd_get_logs_p(ns, pod, [container]) =====
pd_get_logs_p() { $K8S logs "$2" -n "$1" ${3:+-c $3} -p; }

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== pd_upd_label(ns, pod, key, val) =====
pd_upd_label() { $K8S label pod "$2" "$3"="$4" -n "$1"; }

# ===== pd_upd_unlabel(ns, pod, key) =====
pd_upd_unlabel() { $K8S label pod "$2" "$3-" -n "$1"; }

# ===== pd_upd_annotate(ns, pod, key, val) =====
pd_upd_annotate() { $K8S annotate pod "$2" "$3"="$4" -n "$1"; }

# ===== pd_restart(ns, pod) =====
pd_restart() { $K8S delete pod "$2" -n "$1"; }

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== pd_del(ns, pod, [force]) =====
pd_del() {
    [ "$3" == "true" ] && $K8S delete pod "$2" -n "$1" --force --grace-period=0 || $K8S delete pod "$2" -n "$1"
}

# ===== pd_del_label(ns, selector, [force]) =====
pd_del_label() {
    [ "$3" == "true" ] && $K8S delete pods -n "$1" -l "$2" --force --grace-period=0 || $K8S delete pods -n "$1" -l "$2"
}

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== pd_exists(ns, pod) =====
pd_exists() { $K8S get pod "$2" -n "$1" &>/dev/null; }

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== pd_debug(ns, pod) =====
pd_debug() { $K8S debug "$2" -n "$1" --image=busybox -it -- /bin/sh; }

# ===== pd_exec(ns, pod, cmd, [args...]) =====
pd_exec() { $K8S exec "$2" -n "$1" -- "$3" "${@:4}"; }

# ===== pd_exec_c(ns, pod, container, cmd, [args...]) =====
pd_exec_c() { $K8S exec "$2" -c "$3" -n "$1" -- "$4" "${@:5}"; }

# ===== pd_shell(ns, pod, [container], [cmd...]) =====
pd_shell() {
    local c="$3"; local cmd="${4:-/bin/sh}"
    $K8S exec -it "$2" -n "$1" ${c:+-c $c} -- $cmd
}

# ===== pd_pf(ns, pod, lport, pport, [bg]) =====
pd_pf() {
    if [ "$5" == "true" ]; then
        $K8S port-forward "$2" -n "$1" "$3:$4" &
    else
        $K8S port-forward "$2" -n "$1" "$3:$4"
    fi
}

# ===== pd_cp(ns, pod, src, dst, [c]) =====
pd_cp() { $K8S cp "$3" "$1/$2:$4" ${5:+-c $5}; }

# ===== pd_cp_from(ns, pod, src, dst, [c]) =====
pd_cp_from() { $K8S cp "$1/$2:$3" "$4" ${5:+-c $5}; }

# ===== pd_watch(ns, pod, [int]) =====
pd_watch() { watch -n "${3:-2}" "$K8S get pod $2 -n $1"; }

# ===== pd_wait_ready(ns, pod, [timeout]) =====
pd_wait_ready() { $K8S wait --for=condition=ready pod/"$2" -n "$1" --timeout="${3:-300}s"; }

# ===== pd_wait_del(ns, pod, [timeout]) =====
pd_wait_del() { $K8S wait --for=delete pod/"$2" -n "$1" --timeout="${3:-300}s"; }

# ===== pd_valid(ns, pod) =====
pd_valid() { $K8S get pod "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== pd_test_conn(ns, pod, target, [port]) =====
pd_exec "$1" "$2" wget -qO- --timeout=2 "$3:${4:-80}"

# ===== pd_backup(ns, pod, [file]) =====
pd_backup() { $K8S get pod "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# ===== pd_restore(file) =====
pd_restore() { $K8S apply -f "$1"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
pd_add() { pd_add_basic "$@"; }
pd_add_by_file() { pd_add_f "$@"; }
pd_cp_to() { pd_cp "$@"; }
pd_ls_phase() { pd_ls_by_phase "$@"; }
pd_ls_bad() { pd_ls_unhealthy "$@"; }
pd_find_by_lbl() { pd_ls_label "$@"; }
pd_logs() { pd_get_logs "$@"; }
pd_logs_container() { pd_get_logs_c "$@"; }
pd_logs_follow() { pd_get_logs_f "$@"; }
pd_logs_prev() { pd_get_logs_p "$@"; }
pd_probes() { $K8S get pod "$2" -n "$1" -o jsonpath='{.spec.containers[*].readinessProbe}'; }
pd_validate() { pd_valid "$@"; }
pd_connect() { pd_shell "$@"; }
pd_lbl() { pd_upd_label "$@"; }
pd_unlbl() { pd_upd_unlabel "$@"; }
delete_pod() { pd_del "$@"; }
list_pods() { pd_ls "$@"; }
describe_pod() { pd_desc "$@"; }
pod_logs() { pd_get_logs "$@"; }
pod_exec() { pd_exec "$@"; }
pod_shell() { pd_shell "$@"; }
port_forward_pod() { pd_pf "$@"; }
copy_to_pod() { pd_cp "$@"; }
copy_from_pod() { pd_cp_from "$@"; }
wait_for_pod_ready() { pd_wait_ready "$@"; }
wait_for_pod_deleted() { pd_wait_del "$@"; }
backup_pod() { pd_backup "$@"; }
generate_pod_template() { pd_gen_template "$@"; }
