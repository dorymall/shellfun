#!/bin/bash
help_sv(){
    add_log_help "=== help_sv ==="
    add_log_help "Func: sv_add_f [svaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    add_log_help "Func: sv_add_basic [svadd] (\$ns, \$name, \$port, \$tport, [\$sel]) | Act: [kubectl] create service clusterip | Desc: Creates ClusterIP service"
    add_log_help "Func: sv_add_headless [svheadless] (\$ns, \$name, \$port, \$tport, [\$sel]) | Act: [kubectl] create headless service | Desc: Creates Headless service"
    add_log_help "Func: sv_add_nodeport [svnodeport] (\$ns, \$name, \$port, \$tport, [\$nport], [\$sel]) | Act: [kubectl] create service nodeport | Desc: Creates NodePort service"
    add_log_help "Func: sv_add_lb [svlb] (\$ns, \$name, \$port, \$tport, [\$sel]) | Act: [kubectl] create service loadbalancer | Desc: Creates LoadBalancer service"
    add_log_help "Func: sv_add_expose [svexpose] (\$ns, \$dp, \$port, [\$tport], [\$type], [\$name]) | Act: [kubectl] expose deployment | Desc: Exposes deployment as service"
    add_log_help "Func: sv_clone [svclone] (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones service to new namespace/name"
    add_log_help "Func: sv_gen_template [svgen] (\$name, \$type, \$port, [\$tport], [\$file]) | Act: [cat] > file | Desc: Generates service YAML template"
    add_log_help "Func: sv_ls [svls] (\$ns, [\$args...]) | Act: [kubectl] get services | Desc: Lists services"
    add_log_help "Func: sv_ls_all [svlsall] ([\$args...]) | Act: [kubectl] get services --all-namespaces | Desc: Lists services in all namespaces"
    add_log_help "Func: sv_ls_by_type [svlstype] (\$ns, \$type) | Act: [kubectl] get services --field-selector | Desc: Lists services filtered by type"
    add_log_help "Func: sv_ls_unhealthy [svlsunhealthy] (\$ns) | Act: [grep] empty subsets | Desc: Lists services without active endpoints"
    add_log_help "Func: sv_ls_label [svlslabel] (\$ns, \$selector) | Act: [kubectl] get services -l | Desc: Lists services filtered by label"
    add_log_help "Func: sv_count [svcount] (\$ns) | Act: [wc] -l | Desc: Counts services in namespace"
    add_log_help "Func: sv_get_info [svinfo] (\$ns, \$name) | Act: [kubectl] get service -o wide | Desc: Gets wide service info"
    add_log_help "Func: sv_get_ep [svendpoints] (\$ns, \$name) | Act: [kubectl] get endpoints | Desc: Lists endpoints for service"
    add_log_help "Func: sv_get_dns [svdns] (\$ns, \$name) | Act: Show DNS name | Desc: Shows internal cluster DNS name for service"
    add_log_help "Func: sv_get_url [svurl] (\$ns, \$name) | Act: [jsonpath] status.loadBalancer | Desc: Gets LoadBalancer IP or hostname"
    add_log_help "Func: sv_desc [svdesc] (\$ns, \$name) | Act: [kubectl] describe service | Desc: Describes service"
    add_log_help "Func: sv_get [svget] (\$ns, \$name) | Act: [kubectl] get service -o yaml | Desc: Gets service YAML"
    add_log_help "Func: sv_get_status [svstatus] (\$ns, \$name) | Act: [jsonpath] .status | Desc: Gets service status"
    add_log_help "Func: sv_upd_port [svuport] (\$ns, \$name, \$port, \$tport) | Act: [kubectl] patch service | Desc: Updates service ports"
    add_log_help "Func: sv_upd_selector [svuselector] (\$ns, \$name, \$key, \$val) | Act: [kubectl] patch selector | Desc: Updates service pod selector"
    add_log_help "Func: sv_upd_label [svlabel] (\$ns, \$name, \$key, \$val) | Act: [kubectl] label service | Desc: Adds/updates service label"
    add_log_help "Func: sv_upd_unlabel [svunlabel] (\$ns, \$name, \$key) | Act: [kubectl] label service (remove) | Desc: Removes label from service"
    add_log_help "Func: sv_upd_annotate [svannotate] (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate service | Desc: Adds/updates annotation"
    add_log_help "Func: sv_del [svdel] (\$ns, \$name) | Act: [kubectl] delete service | Desc: Deletes service"
    add_log_help "Func: sv_exists [svexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if service exists"
    add_log_help "Func: sv_watch [svwatch] (\$ns, [\$name]) | Act: [kubectl] get service --watch | Desc: Watches services"
    add_log_help "Func: sv_wait_ready [svwaitready] (\$ns, \$name, [\$timeout]) | Act: Poll [kubectl] get endpoints | Desc: Waits for service endpoints to be ready"
    add_log_help "Func: sv_wait_ext_ip [svwaitip] (\$ns, \$name, [\$timeout]) | Act: Poll LoadBalancer IP | Desc: Waits for external LoadBalancer IP"
    add_log_help "Func: sv_valid [svvalid] (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if service YAML is valid"
    add_log_help "Func: sv_test_conn [svtest] (\$ns, \$name, [\$port]) | Act: [wget] from pod | Desc: Tests connection to service"
    add_log_help "Func: sv_test_lb [svtestlb] (\$ns, \$name, [\$reqs]) | Act: [curl] external URL | Desc: Tests LoadBalancer accessibility"
    add_log_help "Func: sv_pf [svportf] (\$ns, \$name, \$lport, \$sport, [\$bg]) | Act: [kubectl] port-forward | Desc: Forwards local port to service port"
    add_log_help "Func: sv_backup [svbak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups service to YAML file"
    add_log_help "Func: sv_restore [svrestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores service from file"
}
# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================
sv_add_f() { 
    add_log "=== Func: sv_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
svaddf() { sv_add_f "$@"; }
sv_add_basic() {
    add_log "=== Func: sv_add_basic ==="
    $K8S create service clusterip "$2" -n "$1" --tcp="$3:$4" | add_log
    [ -n "$5" ] && $K8S patch svc "$2" -n "$1" -p "{\"spec\":{\"selector\":{$5}}}" | add_log
}
svadd() { sv_add_basic "$@"; }
sv_add_headless() {
    add_log "=== Func: sv_add_headless ==="
    $K8S create service clusterip "$2" -n "$1" --tcp="$3:$4" --clusterip="None" | add_log
    [ -n "$5" ] && $K8S patch svc "$2" -n "$1" -p "{\"spec\":{\"selector\":{$5}}}" | add_log
}
svheadless() { sv_add_headless "$@"; }
sv_add_nodeport() {
    add_log "=== Func: sv_add_nodeport ==="
    $K8S create service nodeport "$2" -n "$1" --tcp="$3:$4" ${5:+--node-port=$5} | add_log
    [ -n "$6" ] && $K8S patch svc "$2" -n "$1" -p "{\"spec\":{\"selector\":{$6}}}" | add_log
}
svnodeport() { sv_add_nodeport "$@"; }
sv_add_lb() {
    add_log "=== Func: sv_add_lb ==="
    $K8S create service loadbalancer "$2" -n "$1" --tcp="$3:$4" | add_log
    [ -n "$5" ] && $K8S patch svc "$2" -n "$1" -p "{\"spec\":{\"selector\":{$5}}}" | add_log
}
svlb() { sv_add_lb "$@"; }
sv_add_expose() {
    add_log "=== Func: sv_add_expose ==="
    $K8S expose deployment "$2" -n "$1" --port="$3" --target-port="${4:-$3}" --type="${5:-ClusterIP}" ${6:+--name=$6} | add_log
}
svexpose() { sv_add_expose "$@"; }
sv_clone() {
    add_log "=== Func: sv_clone ==="
    local tn="${4:-$2}"
    $K8S get svc "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f - | add_log
}
svclone() { sv_clone "$@"; }
sv_gen_template() {
    add_log "=== Func: sv_gen_template ==="
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
    [ "$f" != "/dev/stdout" ] && add_log "Template saved to $f"
}
svgen() { sv_gen_template "$@"; }
# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================
sv_ls() { 
    add_log "=== Func: sv_ls ==="
    $K8S get services -n "$1" "${@:2}" | add_log; 
}
svls() { sv_ls "$@"; }
sv_ls_all() { 
    add_log "=== Func: sv_ls_all ==="
    $K8S get services --all-namespaces "$@" | add_log; 
}
svlsall() { sv_ls_all "$@"; }
sv_ls_by_type() { 
    add_log "=== Func: sv_ls_by_type ==="
    $K8S get svc -n "$1" --field-selector spec.type="$2" | add_log; 
}
svlstype() { sv_ls_by_type "$@"; }
sv_ls_unhealthy() {
    add_log "=== Func: sv_ls_unhealthy ==="
    for s in $($K8S get svc -n "$1" -o name); do
        $K8S get endpoints "$s" -n "$1" -o jsonpath='{.subsets}' | grep -q 'addresses' || add_log "Unhealthy: $s"
    done
}
svlsunhealthy() { sv_ls_unhealthy "$@"; }
sv_ls_label() { 
    add_log "=== Func: sv_ls_label ==="
    $K8S get svc -n "$1" -l "$2" | add_log; 
}
svlslabel() { sv_ls_label "$@"; }
sv_count() { 
    add_log "=== Func: sv_count ==="
    $K8S get svc -n "$1" --no-headers | wc -l | add_log; 
}
svcount() { sv_count "$@"; }
sv_get_info() { 
    add_log "=== Func: sv_get_info ==="
    $K8S get svc "$2" -n "$1" -o wide | add_log; 
}
svinfo() { sv_get_info "$@"; }
sv_get_ep() { 
    add_log "=== Func: sv_get_ep ==="
    $K8S get endpoints "$2" -n "$1" | add_log; 
}
svendpoints() { sv_get_ep "$@"; }
sv_get_dns() { 
    add_log "=== Func: sv_get_dns ==="
    echo "$2.$1.svc.cluster.local" | add_log; 
}
svdns() { sv_get_dns "$@"; }
sv_get_url() {
    add_log "=== Func: sv_get_url ==="
    local ip=$($K8S get svc "$2" -n "$1" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    [ -n "$ip" ] && echo "http://$ip" | add_log || echo "Pending or non-LB" | add_log
}
svurl() { sv_get_url "$@"; }
sv_desc() { 
    add_log "=== Func: sv_desc ==="
    $K8S describe svc "$2" -n "$1" | add_log; 
}
svdesc() { sv_desc "$@"; }
sv_get() { 
    add_log "=== Func: sv_get ==="
    $K8S get svc "$2" -n "$1" -o yaml | add_log; 
}
svget() { sv_get "$@"; }
sv_get_status() { 
    add_log "=== Func: sv_get_status ==="
    $K8S get svc "$2" -n "$1" -o jsonpath='{.status}' | add_log; 
}
svstatus() { sv_get_status "$@"; }
# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================
sv_upd_port() { 
    add_log "=== Func: sv_upd_port ==="
    $K8S patch svc "$2" -n "$1" --type merge -p "{\"spec\":{\"ports\":[{\"port\":$3,\"targetPort\":$4}]}}" | add_log; 
}
svuport() { sv_upd_port "$@"; }
sv_upd_selector() { 
    add_log "=== Func: sv_upd_selector ==="
    $K8S patch svc "$2" -n "$1" --type merge -p "{\"spec\":{\"selector\":{\"$3\":\"$4\"}}}" | add_log; 
}
svuselector() { sv_upd_selector "$@"; }
sv_upd_label() { 
    add_log "=== Func: sv_upd_label ==="
    $K8S label svc "$2" "$3"="$4" -n "$1" | add_log; 
}
svlabel() { sv_upd_label "$@"; }
sv_upd_unlabel() { 
    add_log "=== Func: sv_upd_unlabel ==="
    $K8S label svc "$2" "$3-" -n "$1" | add_log; 
}
svunlabel() { sv_upd_unlabel "$@"; }
sv_upd_annotate() { 
    add_log "=== Func: sv_upd_annotate ==="
    $K8S annotate svc "$2" "$3"="$4" -n "$1" | add_log; 
}
svannotate() { sv_upd_annotate "$@"; }
# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================
sv_del() { 
    add_log "=== Func: sv_del ==="
    $K8S delete svc "$2" -n "$1" | add_log; 
}
svdel() { sv_del "$@"; }
# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================
sv_exists() { 
    add_log "=== Func: sv_exists ==="
    if $K8S get svc "$2" -n "$1" &>/dev/null; then
        add_log "Service $2 exists in namespace $1"
        return 0
    else
        add_log "Service $2 does NOT exist in namespace $1"
        return 1
    fi
}
svexists() { sv_exists "$@"; }
# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================
sv_watch() { 
    add_log "=== Func: sv_watch ==="
    if [ -n "$2" ]; then
        $K8S get svc "$2" -n "$1" --watch | add_log
    else
        $K8S get svc -n "$1" --watch | add_log
    fi
}
svwatch() { sv_watch "$@"; }
sv_wait_ready() {
    add_log "=== Func: sv_wait_ready ==="
    timeout "${3:-300}" bash -c "until $K8S get endpoints $2 -n $1 -o jsonpath='{.subsets[0].addresses[0].ip}' &>/dev/null; do sleep 2; done" | add_log
}
svwaitready() { sv_wait_ready "$@"; }
sv_wait_ext_ip() {
    add_log "=== Func: sv_wait_ext_ip ==="
    timeout "${3:-300}" bash -c "until $K8S get svc $2 -n $1 -o jsonpath='{.status.loadBalancer.ingress[0].ip}' &>/dev/null; do sleep 2; done" | add_log
}
svwaitip() { sv_wait_ext_ip "$@"; }
sv_valid() { 
    add_log "=== Func: sv_valid ==="
    $K8S get svc "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f - | add_log; 
}
svvalid() { sv_valid "$@"; }
sv_test_conn() { 
    add_log "=== Func: sv_test_conn ==="
    $K8S run test-$(date +%s) --rm -it --image=busybox -n "$1" -- wget -qO- --timeout=2 "$2:${3:-80}" | add_log; 
}
svtest() { sv_test_conn "$@"; }
sv_test_lb() {
    add_log "=== Func: sv_test_lb ==="
    local url=$(sv_get_url "$1" "$2")
    for ((i=0; i<${3:-5}; i++)); do curl -s "$url" | add_log; done
}
svtestlb() { sv_test_lb "$@"; }
sv_pf() {
    add_log "=== Func: sv_pf ==="
    if [ "$5" == "true" ]; then
        $K8S port-forward svc/"$2" -n "$1" "$3:$4" &
        add_log "Port-forwarding in background"
    else
        $K8S port-forward svc/"$2" -n "$1" "$3:$4" | add_log
    fi
}
svportf() { sv_pf "$@"; }
sv_backup() { 
    add_log "=== Func: sv_backup ==="
    $K8S get svc "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
svbak() { sv_backup "$@"; }
sv_restore() { 
    add_log "=== Func: sv_restore ==="
    $K8S apply -f "$1" | add_log; 
}
svrestore() { sv_restore "$@"; }
