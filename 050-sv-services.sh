#!/bin/bash
help_sv(){
    echo "Func: sv_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    echo "Func: sv_add_basic (\$ns, \$name, \$port, \$tport, [\$sel]) | Act: [kubectl] create service clusterip | Desc: Creates ClusterIP service"
    echo "Func: sv_add_headless (\$ns, \$name, \$port, \$tport, [\$sel]) | Act: [kubectl] create headless service | Desc: Creates Headless service"
    echo "Func: sv_add_nodeport (\$ns, \$name, \$port, \$tport, [\$nport], [\$sel]) | Act: [kubectl] create service nodeport | Desc: Creates NodePort service"
    echo "Func: sv_add_lb (\$ns, \$name, \$port, \$tport, [\$sel]) | Act: [kubectl] create service loadbalancer | Desc: Creates LoadBalancer service"
    echo "Func: sv_add_expose (\$ns, \$dp, \$port, [\$tport], [\$type], [\$name]) | Act: [kubectl] expose deployment | Desc: Exposes deployment as service"
    echo "Func: sv_clone (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones service to new namespace/name"
    echo "Func: sv_gen_template (\$name, \$type, \$port, [\$tport], [\$file]) | Act: [cat] > file | Desc: Generates service YAML template"
    echo "Func: sv_ls (\$ns, [\$args...]) | Act: [kubectl] get services | Desc: Lists services"
    echo "Func: sv_ls_all ([\$args...]) | Act: [kubectl] get services --all-namespaces | Desc: Lists services in all namespaces"
    echo "Func: sv_ls_by_type (\$ns, \$type) | Act: [kubectl] get services --field-selector | Desc: Lists services filtered by type"
    echo "Func: sv_ls_unhealthy (\$ns) | Act: [grep] empty subsets | Desc: Lists services without active endpoints"
    echo "Func: sv_ls_label (\$ns, \$selector) | Act: [kubectl] get services -l | Desc: Lists services filtered by label"
    echo "Func: sv_count (\$ns) | Act: [wc] -l | Desc: Counts services in namespace"
    echo "Func: sv_get_info (\$ns, \$name) | Act: [kubectl] get service -o wide | Desc: Gets wide service info"
    echo "Func: sv_get_ep (\$ns, \$name) | Act: [kubectl] get endpoints | Desc: Lists endpoints for service"
    echo "Func: sv_get_dns (\$ns, \$name) | Act: Show DNS name | Desc: Shows internal cluster DNS name for service"
    echo "Func: sv_get_url (\$ns, \$name) | Act: [jsonpath] status.loadBalancer | Desc: Gets LoadBalancer IP or hostname"
    echo "Func: sv_desc (\$ns, \$name) | Act: [kubectl] describe service | Desc: Describes service"
    echo "Func: sv_get (\$ns, \$name) | Act: [kubectl] get service -o yaml | Desc: Gets service YAML"
    echo "Func: sv_get_status (\$ns, \$name) | Act: [jsonpath] .status | Desc: Gets service status"
    echo "Func: sv_upd_port (\$ns, \$name, \$port, \$tport) | Act: [kubectl] patch service | Desc: Updates service ports"
    echo "Func: sv_upd_selector (\$ns, \$name, \$key, \$val) | Act: [kubectl] patch selector | Desc: Updates service pod selector"
    echo "Func: sv_upd_label (\$ns, \$name, \$key, \$val) | Act: [kubectl] label service | Desc: Adds/updates service label"
    echo "Func: sv_upd_unlabel (\$ns, \$name, \$key) | Act: [kubectl] label service (remove) | Desc: Removes label from service"
    echo "Func: sv_upd_annotate (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate service | Desc: Adds/updates annotation"
    echo "Func: sv_del (\$ns, \$name) | Act: [kubectl] delete service | Desc: Deletes service"
    echo "Func: sv_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if service exists"
    echo "Func: sv_watch (\$ns, [\$name]) | Act: [kubectl] get service --watch | Desc: Watches services"
    echo "Func: sv_wait_ready (\$ns, \$name, [\$timeout]) | Act: Poll [kubectl] get endpoints | Desc: Waits for service endpoints to be ready"
    echo "Func: sv_wait_ext_ip (\$ns, \$name, [\$timeout]) | Act: Poll LoadBalancer IP | Desc: Waits for external LoadBalancer IP"
    echo "Func: sv_valid (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if service YAML is valid"
    echo "Func: sv_test_conn (\$ns, \$name, [\$port]) | Act: [wget] from pod | Desc: Tests connection to service"
    echo "Func: sv_test_lb (\$ns, \$name, [\$reqs]) | Act: [curl] external URL | Desc: Tests LoadBalancer accessibility"
    echo "Func: sv_pf (\$ns, \$name, \$lport, \$sport, [\$bg]) | Act: [kubectl] port-forward | Desc: Forwards local port to service port"
    echo "Func: sv_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups service to YAML file"
    echo "Func: sv_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores service from file"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== sv_add_f(file) =====
sv_add_f() { $K8S apply -f "$1"; }

# ===== sv_add_basic(ns, name, port, tport, [sel]) =====
sv_add_basic() {
    $K8S create service clusterip "$2" -n "$1" --tcp="$3:$4"
    [ -n "$5" ] && $K8S patch svc "$2" -n "$1" -p "{\"spec\":{\"selector\":{$5}}}"
}

# ===== sv_add_headless(ns, name, port, tport, [sel]) =====
sv_add_headless() {
    $K8S create service clusterip "$2" -n "$1" --tcp="$3:$4" --clusterip="None"
    [ -n "$5" ] && $K8S patch svc "$2" -n "$1" -p "{\"spec\":{\"selector\":{$5}}}"
}

# ===== sv_add_nodeport(ns, name, port, tport, [nport], [sel]) =====
sv_add_nodeport() {
    $K8S create service nodeport "$2" -n "$1" --tcp="$3:$4" ${5:+--node-port=$5}
    [ -n "$6" ] && $K8S patch svc "$2" -n "$1" -p "{\"spec\":{\"selector\":{$6}}}"
}

# ===== sv_add_lb(ns, name, port, tport, [sel]) =====
sv_add_lb() {
    $K8S create service loadbalancer "$2" -n "$1" --tcp="$3:$4"
    [ -n "$5" ] && $K8S patch svc "$2" -n "$1" -p "{\"spec\":{\"selector\":{$5}}}"
}

# ===== sv_add_expose(ns, dp, port, [tport], [type], [name]) =====
sv_add_expose() {
    $K8S expose deployment "$2" -n "$1" --port="$3" --target-port="${4:-$3}" --type="${5:-ClusterIP}" ${6:+--name=$6}
}

# ===== sv_clone(sns, name, tns, [tname]) =====
sv_clone() {
    local tn="${4:-$2}"
    $K8S get svc "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f -
}

# ===== sv_gen_template(name, type, port, [tport], [file]) =====
sv_gen_template() {
    local f="${5:-/dev/stdout}"
    cat > "$f" <<EOF
apiVersion: v1
kind: Service
metadata: { name: "$1" }
spec:
  type: $2
  ports: [ { port: $3, targetPort: ${4:-$3} } ]
  selector: { app: "$1" }
EOF
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== sv_ls(ns, [args...]) =====
sv_ls() { $K8S get services -n "$1" "${@:2}"; }

# ===== sv_ls_all([args...]) =====
sv_ls_all() { $K8S get services --all-namespaces "$@"; }

# ===== sv_ls_by_type(ns, type) =====
sv_ls_by_type() { $K8S get svc -n "$1" --field-selector spec.type="$2"; }

# ===== sv_ls_unhealthy(ns) =====
sv_ls_unhealthy() {
    for s in $($K8S get svc -n "$1" -o name); do
        $K8S get endpoints "$s" -n "$1" -o jsonpath='{.subsets}' | grep -q 'addresses' || echo "Unhealthy: $s"
    done
}

# ===== sv_ls_label(ns, selector) =====
sv_ls_label() { $K8S get svc -n "$1" -l "$2"; }

# ===== sv_count(ns) =====
sv_count() { $K8S get svc -n "$1" --no-headers | wc -l; }

# ===== sv_get_info(ns, name) =====
sv_get_info() { $K8S get svc "$2" -n "$1" -o wide; }

# ===== sv_get_ep(ns, name) =====
sv_get_ep() { $K8S get endpoints "$2" -n "$1"; }

# ===== sv_get_dns(ns, name) =====
sv_get_dns() { echo "$2.$1.svc.cluster.local"; }

# ===== sv_get_url(ns, name) =====
sv_get_url() {
    local ip=$($K8S get svc "$2" -n "$1" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    [ -n "$ip" ] && echo "http://$ip" || echo "Pending or non-LB"
}

# ===== sv_desc(ns, name) =====
sv_desc() { $K8S describe svc "$2" -n "$1"; }

# ===== sv_get(ns, name) =====
sv_get() { $K8S get svc "$2" -n "$1" -o yaml; }

# ===== sv_get_status(ns, name) =====
sv_get_status() { $K8S get svc "$2" -n "$1" -o jsonpath='{.status}'; }

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== sv_upd_port(ns, name, port, tport) =====
sv_upd_port() { $K8S patch svc "$2" -n "$1" --type merge -p "{\"spec\":{\"ports\":[{\"port\":$3,\"targetPort\":$4}]}}"; }

# ===== sv_upd_selector(ns, name, key, val) =====
sv_upd_selector() { $K8S patch svc "$2" -n "$1" --type merge -p "{\"spec\":{\"selector\":{\"$3\":\"$4\"}}}"; }

# ===== sv_upd_label(ns, name, key, val) =====
sv_upd_label() { $K8S label svc "$2" "$3"="$4" -n "$1"; }

# ===== sv_upd_unlabel(ns, name, key) =====
sv_upd_unlabel() { $K8S label svc "$2" "$3-" -n "$1"; }

# ===== sv_upd_annotate(ns, name, key, val) =====
sv_upd_annotate() { $K8S annotate svc "$2" "$3"="$4" -n "$1"; }

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== sv_del(ns, name) =====
sv_del() { $K8S delete svc "$2" -n "$1"; }

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== sv_exists(ns, name) =====
sv_exists() { $K8S get svc "$2" -n "$1" &>/dev/null; }

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== sv_watch(ns, [name]) =====
sv_watch() { [ -n "$2" ] && $K8S get svc "$2" -n "$1" --watch || $K8S get svc -n "$1" --watch; }

# ===== sv_wait_ready(ns, name, [timeout]) =====
sv_wait_ready() {
    timeout "${3:-300}" bash -c "until $K8S get endpoints $2 -n $1 -o jsonpath='{.subsets[0].addresses[0].ip}' &>/dev/null; do sleep 2; done"
}

# ===== sv_wait_ext_ip(ns, name, [timeout]) =====
sv_wait_ext_ip() {
    timeout "${3:-300}" bash -c "until $K8S get svc $2 -n $1 -o jsonpath='{.status.loadBalancer.ingress[0].ip}' &>/dev/null; do sleep 2; done"
}

# ===== sv_valid(ns, name) =====
sv_valid() { $K8S get svc "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== sv_test_conn(ns, name, [port]) =====
sv_test_conn() { $K8S run test-$(date +%s) --rm -it --image=busybox -n "$1" -- wget -qO- --timeout=2 "$2:${3:-80}"; }

# ===== sv_test_lb(ns, name, [reqs]) =====
sv_test_lb() {
    local url=$(sv_get_url "$1" "$2")
    for ((i=0; i<${3:-5}; i++)); do curl -s "$url"; done
}

# ===== sv_pf(ns, name, lport, sport, [bg]) =====
sv_pf() {
    if [ "$5" == "true" ]; then
        $K8S port-forward svc/"$2" -n "$1" "$3:$4" &
    else
        $K8S port-forward svc/"$2" -n "$1" "$3:$4"
    fi
}

# ===== sv_backup(ns, name, [file]) =====
sv_backup() { $K8S get svc "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# ===== sv_restore(file) =====
sv_restore() { $K8S apply -f "$1"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
sv_add_clusterip() { sv_add_basic "$@"; }
sv_add_by_file() { sv_add_f "$@"; }
sv_expose_dp() { sv_add_expose "$@"; }
sv_ls_type() { sv_ls_by_type "$@"; }
sv_ls_dead() { sv_ls_unhealthy "$@"; }
sv_find_by_lbl() { sv_ls_label "$@"; }
sv_get_endpoints() { sv_get_ep "$@"; }
sv_validate() { sv_valid "$@"; }
sv_lbl() { sv_upd_label "$@"; }
sv_unlbl() { sv_upd_unlabel "$@"; }
sv_test() { sv_test_conn "$@"; }
sv_annotate() { sv_upd_annotate "$@"; }
create_service() { sv_add_basic "$@"; }
delete_service() { sv_del "$@"; }
list_services() { sv_ls "$@"; }
service_exists() { sv_exists "$@"; }
describe_service() { sv_desc "$@"; }
get_service_yaml() { sv_get "$@"; }
watch_service() { sv_watch "$@"; }
backup_service() { sv_backup "$@"; }
generate_service_template() { sv_gen_template "$@"; }
