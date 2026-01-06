#!/bin/bash
help_cm(){
    add_log_help "=== help_cm ==="
    add_log_help "Func: cm_add [cmadd] (\$ns, \$name, \$key, \$val) | Act: [kubectl] create configmap --from-literal | Desc: Creates configmap from literal"
    add_log_help "Func: cm_add_f [cmaddf] (\$ns, \$name, \$file, [\$key]) | Act: [kubectl] create configmap --from-file | Desc: Creates configmap from file"
    add_log_help "Func: cm_add_d [cmaddd] (\$ns, \$name, \$dir) | Act: [kubectl] create configmap --from-file dir | Desc: Creates configmap from directory"
    add_log_help "Func: cm_add_env [cmaddenv] (\$ns, \$name, \$env_file) | Act: [kubectl] create configmap --from-env-file | Desc: Creates configmap from env file"
    add_log_help "Func: cm_put [cmput] (\$ns, \$name, \$key, \$val) | Act: [kubectl] delete and create ConfigMap | Desc: Creates or replaces configmap from literal"
    add_log_help "Func: cm_put_f [cmputf] (\$ns, \$name, \$file, [\$key]) | Act: [kubectl] delete and create ConfigMap | Desc: Creates or replaces configmap from file"
    add_log_help "Func: cm_ls [cmlist] (\$ns, [\$args...]) | Act: [kubectl] get configmaps | Desc: Lists configmaps"
    add_log_help "Func: cm_ls_all [cmlsall] ([\$args...]) | Act: [kubectl] get configmaps --all-namespaces | Desc: Lists configmaps in all namespaces"
    add_log_help "Func: cm_desc [cmdesc] (\$ns, \$name) | Act: [kubectl] describe configmap | Desc: Describes configmap"
    add_log_help "Func: cm_get [cmget] (\$ns, \$name) | Act: [kubectl] get configmap -o yaml | Desc: Gets configmap YAML"
    add_log_help "Func: cm_get_json [cmjson] (\$ns, \$name) | Act: [kubectl] get configmap -o json | Desc: Gets configmap JSON"
    add_log_help "Func: cm_get_data [cmdata] (\$ns, \$name) | Act: [kubectl] get configmap -o jsonpath='{.data}' | Desc: Gets configmap raw data"
    add_log_help "Func: cm_get_key [cmkey] (\$ns, \$name, \$key) | Act: [kubectl] get configmap -o jsonpath='{.data.key}' | Desc: Gets specific key value"
    add_log_help "Func: cm_ls_keys [cmkeys] (\$ns, \$name) | Act: [jq] list keys | Desc: Lists keys in configmap"
    add_log_help "Func: cm_upd [cmupdate] (\$ns, \$name, \$key, \$val) | Act: [kubectl] patch configmap | Desc: Updates key/value pair"
    add_log_help "Func: cm_upd_f [cmupdatefile] (\$ns, \$name, \$file, [\$key]) | Act: [kubectl] patch configmap | Desc: Updates key from file content"
    add_log_help "Func: cm_cp [cmcopy] (\$sns, \$tns, \$name, [\$new]) | Act: [kubectl] pipe between namespaces | Desc: Copies configmap between namespaces"
    add_log_help "Func: cm_restore [cmrestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores configmap from file"
    add_log_help "Func: cm_del [cmdelete] (\$ns, \$name) | Act: [kubectl] delete configmap | Desc: Deletes configmap"
    add_log_help "Func: cm_del_key [cmdeletekey] (\$ns, \$name, \$key) | Act: [kubectl] patch to remove key | Desc: Deletes key from configmap"
    add_log_help "Func: cm_exists [cmexists] (\$ns, \$name) | Act: [kubectl] get configmap &>/dev/null | Desc: Checks if configmap exists"
    add_log_help "Func: cm_watch [cmwatch] (\$ns, [\$name]) | Act: [kubectl] get configmap --watch | Desc: Watches configmap"
    add_log_help "Func: cm_stats [cmstats] (\$ns, \$name) | Act: [jq] analyze data | Desc: Shows key count and total size"
    add_log_help "Func: cm_find_key [cmfind] (\$ns, \$key) | Act: [kubectl] get and [grep] | Desc: Searches for key in all configmaps"
    add_log_help "Func: cm_compare [cmcompare] (\$ns1, \$cm1, \$ns2, \$cm2) | Act: [diff] binary data | Desc: Diffs two configmaps"
    add_log_help "Func: cm_backup [cmbak] (\$ns, \$name, \$file) | Act: [kubectl] get configmap -o yaml > file | Desc: Backups configmap to YAML file"
}
# === CREATE / PUT OPERATIONS ===
cm_add() { 
    add_log "=== Func: cm_add ==="
    $K8S create configmap "$2" --from-literal="$3=$4" -n "$1" | add_log; 
}
cmadd() { cm_add "$@"; }
cm_add_f() {
    add_log "=== Func: cm_add_f ==="
    local k="${4:+$4=}$3"
    $K8S create configmap "$2" --from-file="$k" -n "$1" | add_log
}
cmaddf() { cm_add_f "$@"; }
cm_add_d() { 
    add_log "=== Func: cm_add_d ==="
    $K8S create configmap "$2" --from-file="$3" -n "$1" | add_log; 
}
cmaddd() { cm_add_d "$@"; }
cm_add_env() { 
    add_log "=== Func: cm_add_env ==="
    $K8S create configmap "$2" --from-env-file="$3" -n "$1" | add_log; 
}
cmaddenv() { cm_add_env "$@"; }
cm_put() {
    add_log "=== Func: cm_put ==="
    $K8S delete configmap "$2" -n "$1" 2>/dev/null | add_log
    cm_add "$@"
}
cmput() { cm_put "$@"; }
cm_put_f() {
    add_log "=== Func: cm_put_f ==="
    $K8S delete configmap "$2" -n "$1" 2>/dev/null | add_log
    cm_add_f "$@"
}
cmputf() { cm_put_f "$@"; }
# === READ / DESCRIBE / LS / GET OPERATIONS ===
cm_ls() { 
    add_log "=== Func: cm_ls ==="
    $K8S get configmaps -n "$1" "${@:2}" | add_log; 
}
cmlist() { cm_ls "$@"; }
cm_ls_all() { 
    add_log "=== Func: cm_ls_all ==="
    $K8S get configmaps --all-namespaces "$@" | add_log; 
}
cmlsall() { cm_ls_all "$@"; }
cm_desc() { 
    add_log "=== Func: cm_desc ==="
    $K8S describe configmap "$2" -n "$1" | add_log; 
}
cmdesc() { cm_desc "$@"; }
cm_get() { 
    add_log "=== Func: cm_get ==="
    $K8S get configmap "$2" -n "$1" -o yaml | add_log; 
}
cmget() { cm_get "$@"; }
cm_get_json() { 
    add_log "=== Func: cm_get_json ==="
    $K8S get configmap "$2" -n "$1" -o json | add_log; 
}
cmjson() { cm_get_json "$@"; }
cm_get_data() { 
    add_log "=== Func: cm_get_data ==="
    $K8S get configmap "$2" -n "$1" -o jsonpath='{.data}' | add_log; 
}
cmdata() { cm_get_data "$@"; }
cm_get_key() { 
    add_log "=== Func: cm_get_key ==="
    $K8S get configmap "$2" -n "$1" -o jsonpath="{.data.$3}" | add_log; 
}
cmkey() { cm_get_key "$@"; }
cm_ls_keys() { 
    add_log "=== Func: cm_ls_keys ==="
    $K8S get configmap "$2" -n "$1" -o jsonpath='{.data}' | jq -r 'keys[]' | add_log; 
}
cmkeys() { cm_ls_keys "$@"; }
cm_stats() {
    add_log "=== Func: cm_stats ==="
    local d=$($K8S get configmap "$2" -n "$1" -o jsonpath='{.data}')
    add_log "Keys: $(echo "$d" | jq 'length')"; add_log "Size: $(echo "$d" | wc -c) bytes"
}
cmstats() { cm_stats "$@"; }
cm_find_key() {
    add_log "=== Func: cm_find_key ==="
    for cm in $($K8S get cm -n "$1" -o name); do $K8S get "$cm" -n "$1" -o jsonpath="{.data.$2}" &>/dev/null && add_log "Found in $cm"; done
}
cmfind() { cm_find_key "$@"; }
cm_compare() { 
    add_log "=== Func: cm_compare ==="
    diff <($K8S get cm "$2" -n "$1" -o yaml) <($K8S get cm "$4" -n "$3" -o yaml) | add_log; 
}
cmcompare() { cm_compare "$@"; }
# === UPDATE OPERATIONS ===
cm_upd() { 
    add_log "=== Func: cm_upd ==="
    $K8S patch configmap "$2" -n "$1" --type merge -p "{\"data\":{\"$3\":\"$4\"}}" | add_log; 
}
cmupdate() { cm_upd "$@"; }
cm_upd_f() {
    add_log "=== Func: cm_upd_f ==="
    local k=${4:-$(basename "$3")}; local v=$(cat "$3" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g'); cm_upd "$1" "$2" "$k" "$v"
}
cmupdatefile() { cm_upd_f "$@"; }
cm_cp() {
    add_log "=== Func: cm_cp ==="
    local tn="${4:-$3}"; $K8S get cm "$3" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $2/; s/name: $3/name: $tn/" | $K8S apply -f - | add_log
}
cmcopy() { cm_cp "$@"; }
cm_restore() { 
    add_log "=== Func: cm_restore ==="
    $K8S apply -f "$1" | add_log; 
}
cmrestore() { cm_restore "$@"; }
cm_backup() { 
    add_log "=== Func: cm_backup ==="
    $K8S get cm "$2" -n "$1" -o yaml > "$3" && add_log "Backup saved to $3"; 
}
cmbak() { cm_backup "$@"; }
# === DELETE OPERATIONS ===
cm_del() { 
    add_log "=== Func: cm_del ==="
    $K8S delete configmap "$2" -n "$1" | add_log; 
}
cmdelete() { cm_del "$@"; }
cm_del_key() { 
    add_log "=== Func: cm_del_key ==="
    $K8S patch configmap "$2" -n "$1" --type json -p="[{\"op\": \"remove\", \"path\": \"/data/$3\"}]" | add_log; 
}
cmdeletekey() { cm_del_key "$@"; }
# === EXISTS OPERATIONS ===
cm_exists() { 
    add_log "=== Func: cm_exists ==="
    if $K8S get configmap "$2" -n "$1" &>/dev/null; then add_log "ConfigMap $2 exists in namespace $1"; return 0; else add_log "ConfigMap $2 NOT found in namespace $1"; return 1; fi
}
cmexists() { cm_exists "$@"; }
# === MISC OPERATIONS ===
cm_watch() { 
    add_log "=== Func: cm_watch ==="
    if [ -n "$2" ]; then $K8S get cm "$2" -n "$1" --watch | add_log; else $K8S get cm -n "$1" --watch | add_log; fi
}
cmwatch() { cm_watch "$@"; }
