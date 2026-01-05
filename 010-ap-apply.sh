#!/bin/bash
help_ap(){
    echo "Func: ap_add_f (\$ns, \$file) | Act: [kubectl] apply -n '\$ns' -f '\$file' | Desc: Applies YAML file"
    echo "Func: ap_add_env (\$ns, \$env_file, \$template) | Act: [envsubst] < \$template | [kubectl] apply -n '\$ns' | Desc: Applies YAML with env expansion"
    echo "Func: ap_del_f (\$ns, \$file) | Act: [kubectl] delete -n '\$ns' -f '\$file' | Desc: Deletes resources from YAML file"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== ap_add_f(ns, file) =====
#- kubectl apply -n "$ns" -f "$file"
ap_add_f(){ $K8S apply -n "$1" -f "$2"; }

# ===== ap_add_env(ns, env_file, template) =====
#- envsubst < template | kubectl apply
ap_add_env(){
    local ns="$1"; local env="$2"; local tmp="$3"
    local gen="${tmp%.*}-generated.${tmp##*.}"
    source "$env" && envsubst < "$tmp" > "$gen" && ap_add_f "$ns" "$gen" && rm "$gen"
}

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== ap_del_f(ns, file) =====
#- kubectl delete -n "$ns" -f "$file"
ap_del_f() { $K8S delete -n "$1" -f "$2"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
ap_put() { ap_add_f "$@"; }
ap_put_by_env() { ap_add_env "$@"; }
ap_del_by_file() { ap_del_f "$@"; }