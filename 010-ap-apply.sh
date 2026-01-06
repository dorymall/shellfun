#!/bin/bash
help_ap(){
    add_log_help "=== help_ap ==="
    add_log_help "Func: ap_add_f [apapply] (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    add_log_help "Func: ap_add_env [apapplyenv] (\$ns, \$env_file, \$template) | Act: [envsubst] and [kubectl] apply | Desc: Applies YAML with env expansion"
    add_log_help "Func: ap_del_f [apdelete] (\$ns, \$file) | Act: [kubectl] delete -f | Desc: Deletes resources from YAML file"
}
# === CREATE / PUT OPERATIONS ===
ap_add_f(){ 
    add_log "=== Func: ap_add_f ==="
    $K8S apply -n "$1" -f "$2" | add_log; 
}
apapply() { ap_add_f "$@"; }
ap_add_env(){
    add_log "=== Func: ap_add_env ==="
    local ns="$1"; local env="$2"; local tmp="$3"
    local gen="${tmp%.*}-generated.${tmp##*.}"
    add_log "Generating and applying $gen from $tmp with env $env..."
    (source "$env" && envsubst < "$tmp" > "$gen" && ap_add_f "$ns" "$gen" && rm "$gen") | add_log
}
apapplyenv() { ap_add_env "$@"; }
# === DELETE OPERATIONS ===
ap_del_f() { 
    add_log "=== Func: ap_del_f ==="
    $K8S delete -n "$1" -f "$2" | add_log; 
}
apdelete() { ap_del_f "$@"; }
