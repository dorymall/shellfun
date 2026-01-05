#!/bin/bash
help_ing(){
    echo "Func: ing_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    echo "Func: ing_add_basic (\$ns, \$name, \$svc, \$port, [\$host]) | Act: [kubectl] create ingress | Desc: Creates basic ingress"
    echo "Func: ing_add_tls (\$ns, \$name, \$svc, \$port, \$host, \$secret) | Act: [kubectl] create and patch ingress | Desc: Creates ingress with TLS"
    echo "Func: ing_clone (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones ingress to new namespace/name"
    echo "Func: ing_gen (\$name, [\$ns]) | Act: [cat] > file | Desc: Generates ingress YAML template"
    echo "Func: ing_ls (\$ns, [\$args...]) | Act: [kubectl] get ingress | Desc: Lists ingresses"
    echo "Func: ing_ls_all ([\$args...]) | Act: [kubectl] get ingress --all-namespaces | Desc: Lists ingresses in all namespaces"
    echo "Func: ing_ls_rules (\$ns, \$name) | Act: [jq] list rules | Desc: Lists hosts, paths, and backends"
    echo "Func: ing_ls_host (\$ns, \$pattern) | Act: [jq] filter by host | Desc: Finds ingresses matching host pattern"
    echo "Func: ing_ls_svc (\$ns, \$svc) | Act: [jq] filter by service | Desc: Finds ingresses using specific service"
    echo "Func: ing_get_status (\$ns, \$name) | Act: [jsonpath] .status.loadBalancer | Desc: Gets LoadBalancer IP"
    echo "Func: ing_get_info (\$ns, \$name) | Act: [kubectl] get ingress -o wide | Desc: Gets wide ingress info"
    echo "Func: ing_get_hosts (\$ns, \$name) | Act: [jq] list hosts | Desc: Lists all hosts in rules"
    echo "Func: ing_get_paths (\$ns, \$name) | Act: [jq] list paths | Desc: Lists all paths in rules"
    echo "Func: ing_get_backends (\$ns, \$name) | Act: [jq] list backends | Desc: Lists all backend services"
    echo "Func: ing_get_tls (\$ns, \$name) | Act: [jsonpath] .spec.tls | Desc: Shows TLS configuration"
    echo "Func: ing_get_class (\$ns, \$name) | Act: [jsonpath] .spec.ingressClassName | Desc: Shows ingressClassName"
    echo "Func: ing_get_events (\$ns, \$name) | Act: [kubectl] get events -l | Desc: Gets events for ingress"
    echo "Func: ing_desc (\$ns, \$name) | Act: [kubectl] describe ingress | Desc: Describes ingress"
    echo "Func: ing_get (\$ns, \$name) | Act: [kubectl] get ingress -o yaml | Desc: Gets ingress YAML"
    echo "Func: ing_upd_rule (\$ns, \$name, \$host, \$path, \$svc, \$port) | Act: [kubectl] patch rules | Desc: Adds/Updates ingress rule"
    echo "Func: ing_upd_backend (\$ns, \$name, \$path, \$svc, \$port) | Act: [kubectl] patch backend | Desc: Updates backend for specific path"
    echo "Func: ing_upd_tls (\$ns, \$name, \$host, \$secret) | Act: [kubectl] patch TLS | Desc: Adds/Updates TLS configuration"
    echo "Func: ing_upd_class (\$ns, \$name, \$class) | Act: [kubectl] patch ingressClassName | Desc: Updates ingressClassName"
    echo "Func: ing_upd_annotate (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate ingress | Desc: Adds/updates annotation"
    echo "Func: ing_upd_unannotate (\$ns, \$name, \$key) | Act: [kubectl] annotate ingress (remove) | Desc: Removes annotation"
    echo "Func: ing_patch (\$ns, \$name, \$json) | Act: [kubectl] patch ingress | Desc: Applies arbitrary JSON patch"
    echo "Func: ing_del_rule (\$ns, \$name, \$host, [\$path]) | Act: Manual edit recommended | Desc: Guidance for deleting rules"
    echo "Func: ing_del_tls (\$ns, \$name, [\$host]) | Act: [kubectl] patch to remove TLS | Desc: Removes TLS section"
    echo "Func: ing_del (\$ns, \$name) | Act: [kubectl] delete ingress | Desc: Deletes ingress"
    echo "Func: ing_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if ingress exists"
    echo "Func: ing_watch (\$ns, [\$name]) | Act: [kubectl] get ingress --watch | Desc: Watches ingresses"
    echo "Func: ing_valid (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if ingress YAML is valid"
    echo "Func: ing_test_conn (\$ns, \$name) | Act: [curl] ingress host | Desc: Tests connection to ingress"
    echo "Func: ing_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups ingress to YAML file"
    echo "Func: ing_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores ingress from file"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== ing_add_f(file) =====
ing_add_f() { $K8S apply -f "$1"; }

# ===== ing_add_basic(ns, name, svc, port, [host]) =====
ing_add_basic() {
    $K8S create ingress "$2" -n "$1" --rule="${4:+/$4=}$3:$4"
}

# ===== ing_add_tls(ns, name, svc, port, host, secret) =====
ing_add_tls() {
    ing_add_basic "$1" "$2" "$3" "$4" "$5"
    $K8S patch ingress "$2" -n "$1" -p "{\"spec\":{\"tls\":[{\"hosts\":[\"$5\"],\"secretName\":\"$6\"}]}}"
}

# ===== ing_clone(sns, name, tns, [tname]) =====
ing_clone() {
    local tn="${4:-$2}"
    $K8S get ingress "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f -
}

# ===== ing_gen(name, [ns]) =====
ing_gen() {
    cat <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata: { name: "$1", namespace: "${2:-default}" }
spec:
  rules: [ { host: "$1.example.com", http: { paths: [ { path: "/", pathType: Prefix, backend: { service: { name: "$1", port: { number: 80 } } } } ] } } ]
EOF
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== ing_ls(ns, [args...]) =====
ing_ls() { $K8S get ingress -n "$1" "${@:2}"; }

# ===== ing_ls_all([args...]) =====
ing_ls_all() { $K8S get ingress --all-namespaces "$@"; }

# ===== ing_ls_rules(ns, name) =====
ing_ls_rules() { $K8S get ingress "$2" -n "$1" -o custom-columns=HOST:.spec.rules[*].host,PATH:.spec.rules[*].http.paths[*].path,SVC:.spec.rules[*].http.paths[*].backend.service.name; }

# ===== ing_ls_host(ns, pattern) =====
ing_ls_host() { $K8S get ingress -n "$1" -o json | jq -r ".items[] | select(.spec.rules[].host | contains(\"$2\")) | .metadata.name"; }

# ===== ing_ls_svc(ns, svc) =====
ing_ls_svc() { $K8S get ingress -n "$1" -o json | jq -r ".items[] | select(.spec.rules[].http.paths[].backend.service.name == \"$2\") | .metadata.name"; }

# ===== ing_get_status(ns, name) =====
ing_get_status() { $K8S get ingress "$2" -n "$1" -o jsonpath='{.status.loadBalancer.ingress[*].ip}'; }

# ===== ing_get_info(ns, name) =====
ing_get_info() { $K8S get ingress "$2" -n "$1" -o wide; }

# ===== ing_get_hosts(ns, name) =====
ing_get_hosts() { $K8S get ingress "$2" -n "$1" -o jsonpath='{.spec.rules[*].host}'; }

# ===== ing_get_paths(ns, name) =====
ing_get_paths() { $K8S get ingress "$2" -n "$1" -o jsonpath='{.spec.rules[*].http.paths[*].path}'; }

# ===== ing_get_backends(ns, name) =====
ing_get_backends() { $K8S get ingress "$2" -n "$1" -o jsonpath='{.spec.rules[*].http.paths[*].backend.service.name}'; }

# ===== ing_get_tls(ns, name) =====
ing_get_tls() { $K8S get ingress "$2" -n "$1" -o jsonpath='{.spec.tls}'; }

# ===== ing_get_class(ns, name) =====
ing_get_class() { $K8S get ingress "$2" -n "$1" -o jsonpath='{.spec.ingressClassName}'; }

# ===== ing_get_events(ns, name) =====
ing_get_events() { $K8S get events -n "$1" --field-selector involvedObject.name="$2"; }

# ===== ing_desc(ns, name) =====
ing_desc() { $K8S describe ingress "$2" -n "$1"; }

# ===== ing_get(ns, name) =====
ing_get() { $K8S get ingress "$2" -n "$1" -o yaml; }

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== ing_upd_rule(ns, name, host, path, svc, port) =====
ing_upd_rule() {
    local p="{\"spec\":{\"rules\":[{\"host\":\"$3\",\"http\":{\"paths\":[{\"path\":\"$4\",\"pathType\":\"Prefix\",\"backend\":{\"service\":{\"name\":\"$5\",\"port\":{\"number\":$6}}}}]}}]}}"
    $K8S patch ingress "$2" -n "$1" -p "$p"
}

# ===== ing_upd_backend(ns, name, path, svc, port) =====
ing_upd_backend() { ing_upd_rule "$1" "$2" "" "$3" "$4" "$5"; }

# ===== ing_upd_tls(ns, name, host, secret) =====
ing_upd_tls() {
    $K8S patch ingress "$2" -n "$1" -p "{\"spec\":{\"tls\":[{\"hosts\":[\"$3\"],\"secretName\":\"$4\"}]}}"
}

# ===== ing_upd_class(ns, name, class) =====
ing_upd_class() { $K8S patch ingress "$2" -n "$1" -p "{\"spec\":{\"ingressClassName\":\"$3\"}}"; }

# ===== ing_upd_annotate(ns, name, key, val) =====
ing_upd_annotate() { $K8S annotate ingress "$2" "$3"="$4" -n "$1"; }

# ===== ing_upd_unannotate(ns, name, key) =====
ing_upd_unannotate() { $K8S annotate ingress "$2" "$3-" -n "$1"; }

# ===== ing_patch(ns, name, json) =====
ing_patch() { $K8S patch ingress "$2" -n "$1" --type merge -p "$3"; }

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== ing_del_rule(ns, name, host, [path]) =====
ing_del_rule() { echo "Manual edit required for rule deletion"; }

# ===== ing_del_tls(ns, name, [host]) =====
ing_del_tls() { $K8S patch ingress "$2" -n "$1" --type json -p='[{"op": "remove", "path": "/spec/tls"}]'; }

# ===== ing_del(ns, name) =====
ing_del() { $K8S delete ingress "$2" -n "$1"; }

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== ing_exists(ns, name) =====
ing_exists() { $K8S get ingress "$2" -n "$1" &>/dev/null; }

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== ing_watch(ns, [name]) =====
ing_watch() { [ -n "$2" ] && $K8S get ingress "$2" -n "$1" --watch || $K8S get ingress -n "$1" --watch; }

# ===== ing_valid(ns, name) =====
ing_valid() { $K8S get ingress "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== ing_test_conn(ns, name) =====
ing_test_conn() {
    local ip=$(ing_get_status "$1" "$2")
    [ -n "$ip" ] && curl -v "http://$ip" || echo "No IP yet"
}

# ===== ing_backup(ns, name, [file]) =====
ing_backup() { $K8S get ingress "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# ===== ing_restore(file) =====
ing_restore() { $K8S apply -f "$1"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
ing_add() { ing_add_basic "$@"; }
ing_status() { ing_get_status "$@"; }
ing_get_ann() { ing_get_annotate "$@"; }
ing_annotate() { ing_upd_annotate "$@"; }
ing_unannotate() { ing_upd_unannotate "$@"; }
ing_check() { ing_valid "$@"; }
ing_events() { ing_get_events "$@"; }
ing_test() { ing_test_conn "$@"; }
ing_patch_tls() { ing_upd_tls "$@"; }
ing_del_f() { ing_del "$@"; }
create_ingress() { ing_add_basic "$@"; }
delete_ingress() { ing_del "$@"; }
list_ingresses() { ing_ls "$@"; }
ingress_exists() { ing_exists "$@"; }
describe_ingress() { ing_desc "$@"; }
get_ingress_yaml() { ing_get "$@"; }
watch_ingress() { ing_watch "$@"; }
backup_ingress() { ing_backup "$@"; }
generate_ingress_template() { ing_gen "$@"; }
