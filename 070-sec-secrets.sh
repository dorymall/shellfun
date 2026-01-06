#!/bin/bash
help_sec(){
    add_log_help "=== help_sec ==="
    add_log_help "Func: sec_add_f [secaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    add_log_help "Func: sec_add_basic [secadd] (\$ns, \$name, \$key, \$val) | Act: [kubectl] create secret generic --from-literal | Desc: Creates generic secret from literal"
    add_log_help "Func: sec_add_env [secaddenv] (\$ns, \$name, \$env_file) | Act: [kubectl] create secret generic --from-env-file | Desc: Creates generic secret from env file"
    add_log_help "Func: sec_add_tls [secaddtls] (\$ns, \$name, \$cert, \$key) | Act: [kubectl] create secret tls | Desc: Creates TLS secret"
    add_log_help "Func: sec_add_docker [secadddkr] (\$ns, \$name, \$srv, \$user, \$pass, [\$email]) | Act: [kubectl] create secret docker-registry | Desc: Creates Docker registry secret"
    add_log_help "Func: sec_clone [secclone] (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones secret to new namespace/name"
    add_log_help "Func: sec_gen [secgen] (\$name, \$type, [\$ns]) | Act: [cat] > file | Desc: Generates secret YAML template"
    add_log_help "Func: sec_ls [secls] (\$ns, [\$args...]) | Act: [kubectl] get secrets | Desc: Lists secrets"
    add_log_help "Func: sec_ls_all [seclsall] ([\$args...]) | Act: [kubectl] get secrets --all-namespaces | Desc: Lists secrets in all namespaces"
    add_log_help "Func: sec_ls_by_type [seclstype] (\$ns, \$type) | Act: [kubectl] get secrets --field-selector | Desc: Lists secrets filtered by type"
    add_log_help "Func: sec_ls_label [seclslabel] (\$ns, \$selector) | Act: [kubectl] get secrets -l | Desc: Lists secrets filtered by label"
    add_log_help "Func: sec_count [seccount] (\$ns) | Act: [wc] -l | Desc: Counts secrets in namespace"
    add_log_help "Func: sec_get_info [secinfo] (\$ns, \$name) | Act: [kubectl] get secret -o wide | Desc: Gets wide secret info"
    add_log_help "Func: sec_get_type [sectype] (\$ns, \$name) | Act: [jsonpath] .type | Desc: Gets secret type"
    add_log_help "Func: sec_get_data [secdata] (\$ns, \$name) | Act: [jsonpath] .data | Desc: Gets raw secret data"
    add_log_help "Func: sec_get_val [secgetval] (\$ns, \$name, \$key) | Act: [base64] decode | Desc: Gets decoded value for specific key"
    add_log_help "Func: sec_ls_keys [seckeys] (\$ns, \$name) | Act: [jq] list keys | Desc: Lists all keys in secret"
    add_log_help "Func: sec_desc [secdesc] (\$ns, \$name) | Act: [kubectl] describe secret | Desc: Describes secret"
    add_log_help "Func: sec_get [secget] (\$ns, \$name) | Act: [kubectl] get secret -o yaml | Desc: Gets secret YAML"
    add_log_help "Func: sec_upd [secupd] (\$ns, \$name, \$key, \$val) | Act: [kubectl] patch secret | Desc: Updates secret value (handles base64)"
    add_log_help "Func: sec_upd_label [seclabel] (\$ns, \$name, \$key, \$val) | Act: [kubectl] label secret | Desc: Adds/updates secret label"
    add_log_help "Func: sec_upd_unlabel [secunlabel] (\$ns, \$name, \$key) | Act: [kubectl] label secret (remove) | Desc: Removes label from secret"
    add_log_help "Func: sec_upd_annotate [secannotate] (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate secret | Desc: Adds/updates annotation"
    add_log_help "Func: sec_del_val [secdelval] (\$ns, \$name, \$key) | Act: [kubectl] patch to remove key | Desc: Deletes specific key from secret"
    add_log_help "Func: sec_del [secdel] (\$ns, \$name) | Act: [kubectl] delete secret | Desc: Deletes secret"
    add_log_help "Func: sec_exists [secexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if secret exists"
    add_log_help "Func: sec_watch [secwatch] (\$ns, [\$name]) | Act: [kubectl] get secret --watch | Desc: Watches secrets"
    add_log_help "Func: sec_valid [secvalid] (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if secret YAML is valid"
    add_log_help "Func: sec_check_tls [sectls] (\$ns, \$name) | Act: [openssl] x509 | Desc: Decodes and shows TLS cert info"
    add_log_help "Func: sec_check_docker [secdocker] (\$ns, \$name) | Act: [jq] format config | Desc: Decodes and formats Docker registry config"
    add_log_help "Func: sec_backup [secbak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups secret to YAML file"
    add_log_help "Func: sec_restore [secrestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores secret from file"
}
# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================
sec_add_f() { 
    add_log "=== Func: sec_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
secaddf() { sec_add_f "$@"; }
sec_add_basic() { 
    add_log "=== Func: sec_add_basic ==="
    $K8S create secret generic "$2" --from-literal="$3=$4" -n "$1" | add_log; 
}
secadd() { sec_add_basic "$@"; }
sec_add_env() { 
    add_log "=== Func: sec_add_env ==="
    $K8S create secret generic "$2" --from-env-file="$3" -n "$1" | add_log; 
}
secaddenv() { sec_add_env "$@"; }
sec_add_tls() { 
    add_log "=== Func: sec_add_tls ==="
    $K8S create secret tls "$2" --cert="$3" --key="$4" -n "$1" | add_log; 
}
secaddtls() { sec_add_tls "$@"; }
sec_add_docker() {
    add_log "=== Func: sec_add_docker ==="
    $K8S create secret docker-registry "$2" --docker-server="$3" --docker-username="$4" --docker-password="$5" --docker-email="${6:-test@test.com}" -n "$1" | add_log
}
secadddkr() { sec_add_docker "$@"; }
sec_clone() {
    add_log "=== Func: sec_clone ==="
    local tn="${4:-$2}"
    $K8S get secret "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f - | add_log
}
secclone() { sec_clone "$@"; }
sec_gen() {
    add_log "=== Func: sec_gen ==="
    cat <<EOF
apiVersion: v1
kind: Secret
metadata: { name: "$1", namespace: "${3:-default}" }
type: ${2:-Opaque}
data: {}
EOF
}
secgen() { sec_gen "$@"; }
# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================
sec_ls() { 
    add_log "=== Func: sec_ls ==="
    $K8S get secrets -n "$1" "${@:2}" | add_log; 
}
secls() { sec_ls "$@"; }
sec_ls_all() { 
    add_log "=== Func: sec_ls_all ==="
    $K8S get secrets --all-namespaces "$@" | add_log; 
}
seclsall() { sec_ls_all "$@"; }
sec_ls_by_type() { 
    add_log "=== Func: sec_ls_by_type ==="
    $K8S get secrets -n "$1" --field-selector type="$2" | add_log; 
}
seclstype() { sec_ls_by_type "$@"; }
sec_ls_label() { 
    add_log "=== Func: sec_ls_label ==="
    $K8S get secrets -n "$1" -l "$2" | add_log; 
}
seclslabel() { sec_ls_label "$@"; }
sec_count() { 
    add_log "=== Func: sec_count ==="
    $K8S get secrets -n "$1" --no-headers | wc -l | add_log; 
}
seccount() { sec_count "$@"; }
sec_get_info() { 
    add_log "=== Func: sec_get_info ==="
    $K8S get secret "$2" -n "$1" -o wide | add_log; 
}
secinfo() { sec_get_info "$@"; }
sec_get_type() { 
    add_log "=== Func: sec_get_type ==="
    $K8S get secret "$2" -n "$1" -o jsonpath='{.type}' | add_log; 
}
sectype() { sec_get_type "$@"; }
sec_get_data() { 
    add_log "=== Func: sec_get_data ==="
    $K8S get secret "$2" -n "$1" -o jsonpath='{.data}' | add_log; 
}
secdata() { sec_get_data "$@"; }
sec_get_val() { 
    add_log "=== Func: sec_get_val ==="
    $K8S get secret "$2" -n "$1" -o jsonpath="{.data.$3}" | base64 -d | add_log; 
}
secgetval() { sec_get_val "$@"; }
sec_ls_keys() { 
    add_log "=== Func: sec_ls_keys ==="
    $K8S get secret "$2" -n "$1" -o jsonpath='{.data}' | jq -r 'keys[]' | add_log; 
}
seckeys() { sec_ls_keys "$@"; }
sec_desc() { 
    add_log "=== Func: sec_desc ==="
    $K8S describe secret "$2" -n "$1" | add_log; 
}
secdesc() { sec_desc "$@"; }
sec_get() { 
    add_log "=== Func: sec_get ==="
    $K8S get secret "$2" -n "$1" -o yaml | add_log; 
}
secget() { sec_get "$@"; }
# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================
sec_upd() {
    add_log "=== Func: sec_upd ==="
    local b64=$(echo -n "$4" | base64)
    $K8S patch secret "$2" -n "$1" -p "{\"data\":{\"$3\":\"$b64\"}}" | add_log
}
secupd() { sec_upd "$@"; }
sec_upd_label() { 
    add_log "=== Func: sec_upd_label ==="
    $K8S label secret "$2" "$3"="$4" -n "$1" | add_log; 
}
seclabel() { sec_upd_label "$@"; }
sec_upd_unlabel() { 
    add_log "=== Func: sec_upd_unlabel ==="
    $K8S label secret "$2" "$3-" -n "$1" | add_log; 
}
secunlabel() { sec_upd_unlabel "$@"; }
sec_upd_annotate() { 
    add_log "=== Func: sec_upd_annotate ==="
    $K8S annotate secret "$2" "$3"="$4" -n "$1" | add_log; 
}
secannotate() { sec_upd_annotate "$@"; }
# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================
sec_del_val() { 
    add_log "=== Func: sec_del_val ==="
    $K8S patch secret "$2" -n "$1" --type json -p="[{\"op\": \"remove\", \"path\": \"/data/$3\"}]" | add_log; 
}
secdelval() { sec_del_val "$@"; }
sec_del() { 
    add_log "=== Func: sec_del ==="
    $K8S delete secret "$2" -n "$1" | add_log; 
}
secdel() { sec_del "$@"; }
# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================
sec_exists() { 
    add_log "=== Func: sec_exists ==="
    if $K8S get secret "$2" -n "$1" &>/dev/null; then
        add_log "Secret $2 exists in namespace $1"
        return 0
    else
        add_log "Secret $2 does NOT exist in namespace $1"
        return 1
    fi
}
secexists() { sec_exists "$@"; }
# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================
sec_watch() { 
    add_log "=== Func: sec_watch ==="
    if [ -n "$2" ]; then
        $K8S get secret "$2" -n "$1" --watch | add_log
    else
        $K8S get secrets -n "$1" --watch | add_log
    fi
}
secwatch() { sec_watch "$@"; }
sec_valid() { 
    add_log "=== Func: sec_valid ==="
    $K8S get secret "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f - | add_log; 
}
secvalid() { sec_valid "$@"; }
sec_check_tls() { 
    add_log "=== Func: sec_check_tls ==="
    sec_get_val "$1" "$2" "tls.crt" | openssl x509 -noout -text | add_log; 
}
sectls() { sec_check_tls "$@"; }
sec_check_docker() { 
    add_log "=== Func: sec_check_docker ==="
    sec_get_val "$1" "$2" ".dockerconfigjson" | jq . | add_log; 
}
secdocker() { sec_check_docker "$@"; }
sec_backup() { 
    add_log "=== Func: sec_backup ==="
    $K8S get secret "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
secbak() { sec_backup "$@"; }
sec_restore() { 
    add_log "=== Func: sec_restore ==="
    $K8S apply -f "$1" | add_log; 
}
secrestore() { sec_restore "$@"; }
