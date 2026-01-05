#!/bin/bash
help_sec(){
    echo "Func: sec_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    echo "Func: sec_add_basic (\$ns, \$name, \$key, \$val) | Act: [kubectl] create secret generic --from-literal | Desc: Creates generic secret from literal"
    echo "Func: sec_add_env (\$ns, \$name, \$env_file) | Act: [kubectl] create secret generic --from-env-file | Desc: Creates generic secret from env file"
    echo "Func: sec_add_tls (\$ns, \$name, \$cert, \$key) | Act: [kubectl] create secret tls | Desc: Creates TLS secret"
    echo "Func: sec_add_docker (\$ns, \$name, \$srv, \$user, \$pass, [\$email]) | Act: [kubectl] create secret docker-registry | Desc: Creates Docker registry secret"
    echo "Func: sec_clone (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones secret to new namespace/name"
    echo "Func: sec_gen (\$name, \$type, [\$ns]) | Act: [cat] > file | Desc: Generates secret YAML template"
    echo "Func: sec_ls (\$ns, [\$args...]) | Act: [kubectl] get secrets | Desc: Lists secrets"
    echo "Func: sec_ls_all ([\$args...]) | Act: [kubectl] get secrets --all-namespaces | Desc: Lists secrets in all namespaces"
    echo "Func: sec_ls_by_type (\$ns, \$type) | Act: [kubectl] get secrets --field-selector | Desc: Lists secrets filtered by type"
    echo "Func: sec_ls_label (\$ns, \$selector) | Act: [kubectl] get secrets -l | Desc: Lists secrets filtered by label"
    echo "Func: sec_count (\$ns) | Act: [wc] -l | Desc: Counts secrets in namespace"
    echo "Func: sec_get_info (\$ns, \$name) | Act: [kubectl] get secret -o wide | Desc: Gets wide secret info"
    echo "Func: sec_get_type (\$ns, \$name) | Act: [jsonpath] .type | Desc: Gets secret type"
    echo "Func: sec_get_data (\$ns, \$name) | Act: [jsonpath] .data | Desc: Gets raw secret data"
    echo "Func: sec_get_val (\$ns, \$name, \$key) | Act: [base64] decode | Desc: Gets decoded value for specific key"
    echo "Func: sec_ls_keys (\$ns, \$name) | Act: [jq] list keys | Desc: Lists all keys in secret"
    echo "Func: sec_desc (\$ns, \$name) | Act: [kubectl] describe secret | Desc: Describes secret"
    echo "Func: sec_get (\$ns, \$name) | Act: [kubectl] get secret -o yaml | Desc: Gets secret YAML"
    echo "Func: sec_upd (\$ns, \$name, \$key, \$val) | Act: [kubectl] patch secret | Desc: Updates secret value (handles base64)"
    echo "Func: sec_upd_label (\$ns, \$name, \$key, \$val) | Act: [kubectl] label secret | Desc: Adds/updates secret label"
    echo "Func: sec_upd_unlabel (\$ns, \$name, \$key) | Act: [kubectl] label secret (remove) | Desc: Removes label from secret"
    echo "Func: sec_upd_annotate (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate secret | Desc: Adds/updates annotation"
    echo "Func: sec_del_val (\$ns, \$name, \$key) | Act: [kubectl] patch to remove key | Desc: Deletes specific key from secret"
    echo "Func: sec_del (\$ns, \$name) | Act: [kubectl] delete secret | Desc: Deletes secret"
    echo "Func: sec_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if secret exists"
    echo "Func: sec_watch (\$ns, [\$name]) | Act: [kubectl] get secret --watch | Desc: Watches secrets"
    echo "Func: sec_valid (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if secret YAML is valid"
    echo "Func: sec_check_tls (\$ns, \$name) | Act: [openssl] x509 | Desc: Decodes and shows TLS cert info"
    echo "Func: sec_check_docker (\$ns, \$name) | Act: [jq] format config | Desc: Decodes and formats Docker registry config"
    echo "Func: sec_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups secret to YAML file"
    echo "Func: sec_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores secret from file"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== sec_add_f(file) =====
sec_add_f() { $K8S apply -f "$1"; }

# ===== sec_add_basic(ns, name, key, val) =====
sec_add_basic() { $K8S create secret generic "$2" --from-literal="$3=$4" -n "$1"; }

# ===== sec_add_env(ns, name, env_file) =====
sec_add_env() { $K8S create secret generic "$2" --from-env-file="$3" -n "$1"; }

# ===== sec_add_tls(ns, name, cert, key) =====
sec_add_tls() { $K8S create secret tls "$2" --cert="$3" --key="$4" -n "$1"; }

# ===== sec_add_docker(ns, name, srv, user, pass, [email]) =====
sec_add_docker() {
    $K8S create secret docker-registry "$2" --docker-server="$3" --docker-username="$4" --docker-password="$5" --docker-email="${6:-test@test.com}" -n "$1"
}

# ===== sec_clone(sns, name, tns, [tname]) =====
sec_clone() {
    local tn="${4:-$2}"
    $K8S get secret "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f -
}

# ===== sec_gen(name, type, [ns]) =====
sec_gen() {
    cat <<EOF
apiVersion: v1
kind: Secret
metadata: { name: "$1", namespace: "${3:-default}" }
type: ${2:-Opaque}
data: {}
EOF
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== sec_ls(ns, [args...]) =====
sec_ls() { $K8S get secrets -n "$1" "${@:2}"; }

# ===== sec_ls_all([args...]) =====
sec_ls_all() { $K8S get secrets --all-namespaces "$@"; }

# ===== sec_ls_by_type(ns, type) =====
sec_ls_by_type() { $K8S get secrets -n "$1" --field-selector type="$2"; }

# ===== sec_ls_label(ns, selector) =====
sec_ls_label() { $K8S get secrets -n "$1" -l "$2"; }

# ===== sec_count(ns) =====
sec_count() { $K8S get secrets -n "$1" --no-headers | wc -l; }

# ===== sec_get_info(ns, name) =====
sec_get_info() { $K8S get secret "$2" -n "$1" -o wide; }

# ===== sec_get_type(ns, name) =====
sec_get_type() { $K8S get secret "$2" -n "$1" -o jsonpath='{.type}'; }

# ===== sec_get_data(ns, name) =====
sec_get_data() { $K8S get secret "$2" -n "$1" -o jsonpath='{.data}'; }

# ===== sec_get_val(ns, name, key) =====
sec_get_val() { $K8S get secret "$2" -n "$1" -o jsonpath="{.data.$3}" | base64 -d; }

# ===== sec_ls_keys(ns, name) =====
sec_ls_keys() { $K8S get secret "$2" -n "$1" -o jsonpath='{.data}' | jq -r 'keys[]'; }

# ===== sec_desc(ns, name) =====
sec_desc() { $K8S describe secret "$2" -n "$1"; }

# ===== sec_get(ns, name) =====
sec_get() { $K8S get secret "$2" -n "$1" -o yaml; }

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== sec_upd(ns, name, key, val) =====
sec_upd() {
    local b64=$(echo -n "$4" | base64)
    $K8S patch secret "$2" -n "$1" -p "{\"data\":{\"$3\":\"$b64\"}}"
}

# ===== sec_upd_label(ns, name, key, val) =====
sec_upd_label() { $K8S label secret "$2" "$3"="$4" -n "$1"; }

# ===== sec_upd_unlabel(ns, name, key) =====
sec_upd_unlabel() { $K8S label secret "$2" "$3-" -n "$1"; }

# ===== sec_upd_annotate(ns, name, key, val) =====
sec_upd_annotate() { $K8S annotate secret "$2" "$3"="$4" -n "$1"; }

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== sec_del_val(ns, name, key) =====
sec_del_val() { $K8S patch secret "$2" -n "$1" --type json -p="[{\"op\": \"remove\", \"path\": \"/data/$3\"}]"; }

# ===== sec_del(ns, name) =====
sec_del() { $K8S delete secret "$2" -n "$1"; }

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== sec_exists(ns, name) =====
sec_exists() { $K8S get secret "$2" -n "$1" &>/dev/null; }

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== sec_watch(ns, [name]) =====
sec_watch() { [ -n "$2" ] && $K8S get secret "$2" -n "$1" --watch || $K8S get secrets -n "$1" --watch; }

# ===== sec_valid(ns, name) =====
sec_valid() { $K8S get secret "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== sec_check_tls(ns, name) =====
sec_check_tls() { sec_get_val "$1" "$2" "tls.crt" | openssl x509 -noout -text; }

# ===== sec_check_docker(ns, name) =====
sec_check_docker() { sec_get_val "$1" "$2" ".dockerconfigjson" | jq .; }

# ===== sec_backup(ns, name, [file]) =====
sec_backup() { $K8S get secret "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# ===== sec_restore(file) =====
sec_restore() { $K8S apply -f "$1"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
sec_add_generic() { sec_add_basic "$@"; }
sec_add_by_file() { sec_add_f "$@"; }
sec_add_by_env() { sec_add_env "$@"; }
sec_ls_type() { sec_ls_by_type "$@"; }
sec_find_by_lbl() { sec_ls_label "$@"; }
sec_get_key() { sec_get_val "$@"; }
sec_get_raw() { sec_get "$@"; }
sec_get_json() { $K8S get secret "$2" -n "$1" -o json; }
sec_validate() { sec_valid "$@"; }
sec_patch() { sec_upd "$@"; }
sec_upd_key() { sec_upd "$@"; }
sec_lbl() { sec_upd_label "$@"; }
sec_unlbl() { sec_upd_unlabel "$@"; }
sec_annotate() { sec_upd_annotate "$@"; }
create_secret() { sec_add_basic "$@"; }
delete_secret() { sec_del "$@"; }
list_secrets() { sec_ls "$@"; }
secret_exists() { sec_exists "$@"; }
describe_secret() { sec_desc "$@"; }
get_secret_yaml() { sec_get "$@"; }
watch_secret() { sec_watch "$@"; }
backup_secret() { sec_backup "$@"; }
generate_secret_template() { sec_gen "$@"; }
