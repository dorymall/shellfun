#!/bin/bash
help_cm(){
    echo "Func: cm_add (\$ns, \$name, \$key, \$val) | Act: [kubectl] create configmap --from-literal | Desc: Creates configmap from literal"
    echo "Func: cm_add_f (\$ns, \$name, \$file, [\$key]) | Act: [kubectl] create configmap --from-file | Desc: Creates configmap from file"
    echo "Func: cm_add_d (\$ns, \$name, \$dir) | Act: [kubectl] create configmap --from-file dir | Desc: Creates configmap from directory"
    echo "Func: cm_add_env (\$ns, \$name, \$env_file) | Act: [kubectl] create configmap --from-env-file | Desc: Creates configmap from env file"
    echo "Func: cm_put (\$ns, \$name, \$key, \$val) | Act: [kubectl] delete and create ConfigMap | Desc: Creates or replaces configmap from literal"
    echo "Func: cm_put_f (\$ns, \$name, \$file, [\$key]) | Act: [kubectl] delete and create ConfigMap | Desc: Creates or replaces configmap from file"
    echo "Func: cm_ls (\$ns, [\$args...]) | Act: [kubectl] get configmaps | Desc: Lists configmaps"
    echo "Func: cm_ls_all ([\$args...]) | Act: [kubectl] get configmaps --all-namespaces | Desc: Lists configmaps in all namespaces"
    echo "Func: cm_desc (\$ns, \$name) | Act: [kubectl] describe configmap | Desc: Describes configmap"
    echo "Func: cm_get (\$ns, \$name) | Act: [kubectl] get configmap -o yaml | Desc: Gets configmap YAML"
    echo "Func: cm_get_json (\$ns, \$name) | Act: [kubectl] get configmap -o json | Desc: Gets configmap JSON"
    echo "Func: cm_get_data (\$ns, \$name) | Act: [kubectl] get configmap -o jsonpath='{.data}' | Desc: Gets configmap raw data"
    echo "Func: cm_get_key (\$ns, \$name, \$key) | Act: [kubectl] get configmap -o jsonpath='{.data.key}' | Desc: Gets specific key value"
    echo "Func: cm_ls_keys (\$ns, \$name) | Act: [jq] list keys | Desc: Lists keys in configmap"
    echo "Func: cm_upd (\$ns, \$name, \$key, \$val) | Act: [kubectl] patch configmap | Desc: Updates key/value pair"
    echo "Func: cm_upd_f (\$ns, \$name, \$file, [\$key]) | Act: [kubectl] patch configmap | Desc: Updates key from file content"
    echo "Func: cm_cp (\$sns, \$tns, \$name, [\$new]) | Act: [kubectl] pipe between namespaces | Desc: Copies configmap between namespaces"
    echo "Func: cm_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores configmap from file"
    echo "Func: cm_del (\$ns, \$name) | Act: [kubectl] delete configmap | Desc: Deletes configmap"
    echo "Func: cm_del_key (\$ns, \$name, \$key) | Act: [kubectl] patch to remove key | Desc: Deletes key from configmap"
    echo "Func: cm_exists (\$ns, \$name) | Act: [kubectl] get configmap &>/dev/null | Desc: Checks if configmap exists"
    echo "Func: cm_watch (\$ns, [\$name]) | Act: [kubectl] get configmap --watch | Desc: Watches configmap"
    echo "Func: cm_stats (\$ns, \$name) | Act: [jq] analyze data | Desc: Shows key count and total size"
    echo "Func: cm_find_key (\$ns, \$key) | Act: [kubectl] get and [grep] | Desc: Searches for key in all configmaps"
    echo "Func: cm_compare (\$ns1, \$cm1, \$ns2, \$cm2) | Act: [diff] binary data | Desc: Diffs two configmaps"
    echo "Func: cm_backup (\$ns, \$name, \$file) | Act: [kubectl] get configmap -o yaml > file | Desc: Backups configmap to YAML file"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== cm_add(ns, name, key, val) =====
cm_add() { $K8S create configmap "$2" --from-literal="$3=$4" -n "$1"; }

# ===== cm_add_f(ns, name, file, [key]) =====
cm_add_f() {
    local k="${4:+$4=}$3"
    $K8S create configmap "$2" --from-file="$k" -n "$1"
}

# ===== cm_add_d(ns, name, dir) =====
cm_add_d() { $K8S create configmap "$2" --from-file="$3" -n "$1"; }

# ===== cm_add_env(ns, name, env_file) =====
cm_add_env() { $K8S create configmap "$2" --from-env-file="$3" -n "$1"; }

# ===== cm_put(ns, name, key, val) =====
cm_put() {
    $K8S delete configmap "$2" -n "$1" 2>/dev/null
    cm_add "$@"
}

# ===== cm_put_f(ns, name, file, [key]) =====
cm_put_f() {
    $K8S delete configmap "$2" -n "$1" 2>/dev/null
    cm_add_f "$@"
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== cm_ls(ns, [args...]) =====
cm_ls() { $K8S get configmaps -n "$1" "${@:2}"; }

# ===== cm_ls_all([args...]) =====
cm_ls_all() { $K8S get configmaps --all-namespaces "$@"; }

# ===== cm_desc(ns, name) =====
cm_desc() { $K8S describe configmap "$2" -n "$1"; }

# ===== cm_get(ns, name) =====
cm_get() { $K8S get configmap "$2" -n "$1" -o yaml; }

# ===== cm_get_json(ns, name) =====
cm_get_json() { $K8S get configmap "$2" -n "$1" -o json; }

# ===== cm_get_data(ns, name) =====
cm_get_data() { $K8S get configmap "$2" -n "$1" -o jsonpath='{.data}'; }

# ===== cm_get_key(ns, name, key) =====
cm_get_key() { $K8S get configmap "$2" -n "$1" -o jsonpath="{.data.$3}"; }

# ===== cm_ls_keys(ns, name) =====
cm_ls_keys() { $K8S get configmap "$2" -n "$1" -o jsonpath='{.data}' | jq -r 'keys[]'; }

# ===== cm_stats(ns, name) =====
cm_stats() {
    local d=$($K8S get configmap "$2" -n "$1" -o jsonpath='{.data}')
    echo "Keys: $(echo "$d" | jq 'length')"
    echo "Size: $(echo "$d" | wc -c) bytes"
}

# ===== cm_find_key(ns, key) =====
cm_find_key() {
    for cm in $($K8S get cm -n "$1" -o name); do
        $K8S get "$cm" -n "$1" -o jsonpath="{.data.$2}" &>/dev/null && echo "Found in $cm"
    done
}

# ===== cm_compare(ns1, cm1, ns2, cm2) =====
cm_compare() { diff <($K8S get cm "$2" -n "$1" -o yaml) <($K8S get cm "$4" -n "$3" -o yaml); }

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== cm_upd(ns, name, key, val) =====
cm_upd() { $K8S patch configmap "$2" -n "$1" --type merge -p "{\"data\":{\"$3\":\"$4\"}}"; }

# ===== cm_upd_f(ns, name, file, [key]) =====
cm_upd_f() {
    local k=${4:-$(basename "$3")}
    local v=$(cat "$3" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
    cm_upd "$1" "$2" "$k" "$v"
}

# ===== cm_cp(sns, tns, name, [new]) =====
cm_cp() {
    local tn="${4:-$3}"
    $K8S get cm "$3" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $2/; s/name: $3/name: $tn/" | $K8S apply -f -
}

# ===== cm_restore(file) =====
cm_restore() { $K8S apply -f "$1"; }

# ===== cm_backup(ns, name, file) =====
cm_backup() { $K8S get cm "$2" -n "$1" -o yaml > "$3"; }

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== cm_del(ns, name) =====
cm_del() { $K8S delete configmap "$2" -n "$1"; }

# ===== cm_del_key(ns, name, key) =====
cm_del_key() { $K8S patch configmap "$2" -n "$1" --type json -p="[{\"op\": \"remove\", \"path\": \"/data/$3\"}]"; }

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== cm_exists(ns, name) =====
cm_exists() { $K8S get configmap "$2" -n "$1" &>/dev/null; }

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== cm_watch(ns, [name]) =====
cm_watch() { [ -n "$2" ] && $K8S get cm "$2" -n "$1" --watch || $K8S get cm -n "$1" --watch; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
cm_add_by_file() { cm_add_f "$@"; }
cm_add_by_dir() { cm_add_d "$@"; }
cm_add_by_env() { cm_add_env "$@"; }
cm_put_by_file() { cm_put_f "$@"; }
cm_put_by_literal() { cm_upd "$@"; }
cm_patch() { cm_upd "$@"; }
cm_find_by_key() { cm_find_key "$@"; }