#!/bin/bash
help_ing(){
    add_log_help "=== help_ing ==="
    add_log_help "Func: ing_add_f [ingaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    add_log_help "Func: ing_add_basic [ingadd] (\$ns, \$name, \$svc, \$port, [\$host]) | Act: [kubectl] create ingress | Desc: Creates basic ingress"
    add_log_help "Func: ing_add_tls [ingaddtls] (\$ns, \$name, \$svc, \$port, \$host, \$secret) | Act: [kubectl] create and patch ingress | Desc: Creates ingress with TLS"
    add_log_help "Func: ing_clone [ingclone] (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones ingress to new namespace/name"
    add_log_help "Func: ing_gen [inggen] (\$name, [\$ns]) | Act: [cat] > file | Desc: Generates ingress YAML template"
    add_log_help "Func: ing_ls [ingls] (\$ns, [\$args...]) | Act: [kubectl] get ingress | Desc: Lists ingresses"
    add_log_help "Func: ing_ls_all [inglsall] ([\$args...]) | Act: [kubectl] get ingress --all-namespaces | Desc: Lists ingresses in all namespaces"
    add_log_help "Func: ing_ls_rules [inglsrules] (\$ns, \$name) | Act: [jq] list rules | Desc: Lists hosts, paths, and backends"
    add_log_help "Func: ing_ls_host [inglshost] (\$ns, \$pattern) | Act: [jq] filter by host | Desc: Finds ingresses matching host pattern"
    add_log_help "Func: ing_ls_svc [inglssvc] (\$ns, \$svc) | Act: [jq] filter by service | Desc: Finds ingresses using specific service"
    add_log_help "Func: ing_get_status [ingstatus] (\$ns, \$name) | Act: [jsonpath] .status.loadBalancer | Desc: Gets LoadBalancer IP"
    add_log_help "Func: ing_get_info [inginfo] (\$ns, \$name) | Act: [kubectl] get ingress -o wide | Desc: Gets wide ingress info"
    add_log_help "Func: ing_get_hosts [inghosts] (\$ns, \$name) | Act: [jq] list hosts | Desc: Lists all hosts in rules"
    add_log_help "Func: ing_get_paths [ingpaths] (\$ns, \$name) | Act: [jq] list paths | Desc: Lists all paths in rules"
    add_log_help "Func: ing_get_backends [ingbackends] (\$ns, \$name) | Act: [jq] list backends | Desc: Lists all backend services"
    add_log_help "Func: ing_get_tls [ingtls] (\$ns, \$name) | Act: [jsonpath] .spec.tls | Desc: Shows TLS configuration"
    add_log_help "Func: ing_get_class [ingclass] (\$ns, \$name) | Act: [jsonpath] .spec.ingressClassName | Desc: Shows ingressClassName"
    add_log_help "Func: ing_get_events [ingevents] (\$ns, \$name) | Act: [kubectl] get events -l | Desc: Gets events for ingress"
    add_log_help "Func: ing_desc [ingdesc] (\$ns, \$name) | Act: [kubectl] describe ingress | Desc: Describes ingress"
    add_log_help "Func: ing_get [ingget] (\$ns, \$name) | Act: [kubectl] get ingress -o yaml | Desc: Gets ingress YAML"
    add_log_help "Func: ing_upd_rule [ingupdrule] (\$ns, \$name, \$host, \$path, \$svc, \$port) | Act: [kubectl] patch rules | Desc: Adds/Updates ingress rule"
    add_log_help "Func: ing_upd_backend [ingupdbackend] (\$ns, \$name, \$path, \$svc, \$port) | Act: [kubectl] patch backend | Desc: Updates backend for specific path"
    add_log_help "Func: ing_upd_tls [ingupdtls] (\$ns, \$name, \$host, \$secret) | Act: [kubectl] patch TLS | Desc: Adds/Updates TLS configuration"
    add_log_help "Func: ing_upd_class [ingupdclass] (\$ns, \$name, \$class) | Act: [kubectl] patch ingressClassName | Desc: Updates ingressClassName"
    add_log_help "Func: ing_upd_annotate [ingannotate] (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate ingress | Desc: Adds/updates annotation"
    add_log_help "Func: ing_upd_unannotate [ingunannotate] (\$ns, \$name, \$key) | Act: [kubectl] annotate ingress (remove) | Desc: Removes annotation"
    add_log_help "Func: ing_patch [ingpatch] (\$ns, \$name, \$json) | Act: [kubectl] patch ingress | Desc: Applies arbitrary JSON patch"
    add_log_help "Func: ing_del_rule [ingdelrule] (\$ns, \$name, \$host, [\$path]) | Act: Manual edit recommended | Desc: Guidance for deleting rules"
    add_log_help "Func: ing_del_tls [ingdeltls] (\$ns, \$name, [\$host]) | Act: [kubectl] patch to remove TLS | Desc: Removes TLS section"
    add_log_help "Func: ing_del [ingdel] (\$ns, \$name) | Act: [kubectl] delete ingress | Desc: Deletes ingress"
    add_log_help "Func: ing_exists [ingexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if ingress exists"
    add_log_help "Func: ing_watch [ingwatch] (\$ns, [\$name]) | Act: [kubectl] get ingress --watch | Desc: Watches ingresses"
    add_log_help "Func: ing_valid [ingvalid] (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if ingress YAML is valid"
    add_log_help "Func: ing_test_conn [ingtest] (\$ns, \$name) | Act: [curl] ingress host | Desc: Tests connection to ingress"
    add_log_help "Func: ing_backup [ingbak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups ingress to YAML file"
    add_log_help "Func: ing_restore [ingrestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores ingress from file"
}
# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================
ing_add_f() { 
    add_log "=== Func: ing_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
ingaddf() { ing_add_f "$@"; }
ing_add_basic() {
    add_log "=== Func: ing_add_basic ==="
    $K8S create ingress "$2" -n "$1" --rule="${4:+/$4=}$3:$4" | add_log
}
ingadd() { ing_add_basic "$@"; }
ing_add_tls() {
    add_log "=== Func: ing_add_tls ==="
    ingadd "$1" "$2" "$3" "$4" "$5"
    $K8S patch ingress "$2" -n "$1" -p "{\"spec\":{\"tls\":[{\"hosts\":[\"$5\"],\"secretName\":\"$6\"}]}}" | add_log
}
ingaddtls() { ing_add_tls "$@"; }
ing_clone() {
    add_log "=== Func: ing_clone ==="
    local tn="${4:-$2}"
    $K8S get ingress "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f - | add_log
}
ingclone() { ing_clone "$@"; }
ing_gen() {
    add_log "=== Func: ing_gen ==="
    cat <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata: { name: "$1", namespace: "${2:-default}" }
spec:
  rules: [ { host: "$1.example.com", http: { paths: [ { path: "/", pathType: Prefix, backend: { service: { name: "$1", port: { number: 80 } } } } ] } } ]
EOF
}
inggen() { ing_gen "$@"; }
# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================
ing_ls() { 
    add_log "=== Func: ing_ls ==="
    $K8S get ingress -n "$1" "${@:2}" | add_log; 
}
ingls() { ing_ls "$@"; }
ing_ls_all() { 
    add_log "=== Func: ing_ls_all ==="
    $K8S get ingress --all-namespaces "$@" | add_log; 
}
inglsall() { ing_ls_all "$@"; }
ing_ls_rules() { 
    add_log "=== Func: ing_ls_rules ==="
    $K8S get ingress "$2" -n "$1" -o custom-columns=HOST:.spec.rules[*].host,PATH:.spec.rules[*].http.paths[*].path,SVC:.spec.rules[*].http.paths[*].backend.service.name | add_log; 
}
inglsrules() { ing_ls_rules "$@"; }
ing_ls_host() { 
    add_log "=== Func: ing_ls_host ==="
    $K8S get ingress -n "$1" -o json | jq -r ".items[] | select(.spec.rules[].host | contains(\"$2\")) | .metadata.name" | add_log; 
}
inglshost() { ing_ls_host "$@"; }
ing_ls_svc() { 
    add_log "=== Func: ing_ls_svc ==="
    $K8S get ingress -n "$1" -o json | jq -r ".items[] | select(.spec.rules[].http.paths[].backend.service.name == \"$2\") | .metadata.name" | add_log; 
}
inglssvc() { ing_ls_svc "$@"; }
ing_get_status() { 
    add_log "=== Func: ing_get_status ==="
    $K8S get ingress "$2" -n "$1" -o jsonpath='{.status.loadBalancer.ingress[*].ip}' | add_log; 
}
ingstatus() { ing_get_status "$@"; }
ing_get_info() { 
    add_log "=== Func: ing_get_info ==="
    $K8S get ingress "$2" -n "$1" -o wide | add_log; 
}
inginfo() { ing_get_info "$@"; }
ing_get_hosts() { 
    add_log "=== Func: ing_get_hosts ==="
    $K8S get ingress "$2" -n "$1" -o jsonpath='{.spec.rules[*].host}' | add_log; 
}
inghosts() { ing_get_hosts "$@"; }
ing_get_paths() { 
    add_log "=== Func: ing_get_paths ==="
    $K8S get ingress "$2" -n "$1" -o jsonpath='{.spec.rules[*].http.paths[*].path}' | add_log; 
}
ingpaths() { ing_get_paths "$@"; }
ing_get_backends() { 
    add_log "=== Func: ing_get_backends ==="
    $K8S get ingress "$2" -n "$1" -o jsonpath='{.spec.rules[*].http.paths[*].backend.service.name}' | add_log; 
}
ingbackends() { ing_get_backends "$@"; }
ing_get_tls() { 
    add_log "=== Func: ing_get_tls ==="
    $K8S get ingress "$2" -n "$1" -o jsonpath='{.spec.tls}' | add_log; 
}
ingtls() { ing_get_tls "$@"; }
ing_get_class() { 
    add_log "=== Func: ing_get_class ==="
    $K8S get ingress "$2" -n "$1" -o jsonpath='{.spec.ingressClassName}' | add_log; 
}
ingclass() { ing_get_class "$@"; }
ing_get_events() { 
    add_log "=== Func: ing_get_events ==="
    $K8S get events -n "$1" --field-selector involvedObject.name="$2" | add_log; 
}
ingevents() { ing_get_events "$@"; }
ing_desc() { 
    add_log "=== Func: ing_desc ==="
    $K8S describe ingress "$2" -n "$1" | add_log; 
}
ingdesc() { ing_desc "$@"; }
ing_get() { 
    add_log "=== Func: ing_get ==="
    $K8S get ingress "$2" -n "$1" -o yaml | add_log; 
}
ingget() { ing_get "$@"; }
# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================
ing_upd_rule() {
    add_log "=== Func: ing_upd_rule ==="
    local p="{\"spec\":{\"rules\":[{\"host\":\"$3\",\"http\":{\"paths\":[{\"path\":\"$4\",\"pathType\":\"Prefix\",\"backend\":{\"service\":{\"name\":\"$5\",\"port\":{\"number\":$6}}}}]}}]}}"
    $K8S patch ingress "$2" -n "$1" -p "$p" | add_log
}
ingupdrule() { ing_upd_rule "$@"; }
ing_upd_backend() { 
    add_log "=== Func: ing_upd_backend ==="
    ingupdrule "$1" "$2" "" "$3" "$4" "$5"; 
}
ingupdbackend() { ing_upd_backend "$@"; }
ing_upd_tls() {
    add_log "=== Func: ing_upd_tls ==="
    $K8S patch ingress "$2" -n "$1" -p "{\"spec\":{\"tls\":[{\"hosts\":[\"$3\"],\"secretName\":\"$4\"}]}}" | add_log
}
ingupdtls() { ing_upd_tls "$@"; }
ing_upd_class() { 
    add_log "=== Func: ing_upd_class ==="
    $K8S patch ingress "$2" -n "$1" -p "{\"spec\":{\"ingressClassName\":\"$3\"}}" | add_log; 
}
ingupdclass() { ing_upd_class "$@"; }
ing_upd_annotate() { 
    add_log "=== Func: ing_upd_annotate ==="
    $K8S annotate ingress "$2" "$3"="$4" -n "$1" | add_log; 
}
ingannotate() { ing_upd_annotate "$@"; }
ing_upd_unannotate() { 
    add_log "=== Func: ing_upd_unannotate ==="
    $K8S annotate ingress "$2" "$3-" -n "$1" | add_log; 
}
ingunannotate() { ing_upd_unannotate "$@"; }
ing_patch() { 
    add_log "=== Func: ing_patch ==="
    $K8S patch ingress "$2" -n "$1" --type merge -p "$3" | add_log; 
}
ingpatch() { ing_patch "$@"; }
# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================
ing_del_rule() { 
    add_log "=== Func: ing_del_rule ==="
    add_log "Manual edit required for rule deletion"; 
}
ingdelrule() { ing_del_rule "$@"; }
ing_del_tls() { 
    add_log "=== Func: ing_del_tls ==="
    $K8S patch ingress "$2" -n "$1" --type json -p='[{"op": "remove", "path": "/spec/tls"}]' | add_log; 
}
ingdeltls() { ing_del_tls "$@"; }
ing_del() { 
    add_log "=== Func: ing_del ==="
    $K8S delete ingress "$2" -n "$1" | add_log; 
}
ingdel() { ing_del "$@"; }
# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================
ing_exists() { 
    add_log "=== Func: ing_exists ==="
    if $K8S get ingress "$2" -n "$1" &>/dev/null; then
        add_log "Ingress $2 exists in namespace $1"
        return 0
    else
        add_log "Ingress $2 does NOT exist in namespace $1"
        return 1
    fi
}
ingexists() { ing_exists "$@"; }
# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================
ing_watch() { 
    add_log "=== Func: ing_watch ==="
    if [ -n "$2" ]; then
        $K8S get ingress "$2" -n "$1" --watch | add_log
    else
        $K8S get ingress -n "$1" --watch | add_log
    fi
}
ingwatch() { ing_watch "$@"; }
ing_valid() { 
    add_log "=== Func: ing_valid ==="
    $K8S get ingress "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f - | add_log; 
}
ingvalid() { ing_valid "$@"; }
ing_test_conn() {
    add_log "=== Func: ing_test_conn ==="
    local ip=$(ing_get_status "$1" "$2")
    [ -n "$ip" ] && curl -v "http://$ip" | add_log || add_log "No IP yet"
}
ingtest() { ing_test_conn "$@"; }
ing_backup() { 
    add_log "=== Func: ing_backup ==="
    $K8S get ingress "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
ingbak() { ing_backup "$@"; }
ing_restore() { 
    add_log "=== Func: ing_restore ==="
    $K8S apply -f "$1" | add_log; 
}
ingrestore() { ing_restore "$@"; }
