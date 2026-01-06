#!/bin/bash
help_ns(){
    add_log_help "=== help_ns ==="
    add_log_help "Func: ns_add [nscreate] (\$ns) | Act: [kubectl] create namespace | Desc: Creates namespace"
    add_log_help "Func: ns_put [nsensure] (\$ns) | Act: [kubectl] create namespace | Desc: Creates namespace if not exists"
    add_log_help "Func: ns_ls [nslist] ([\$args...]) | Act: [kubectl] get namespaces | Desc: Lists namespaces"
    add_log_help "Func: ns_desc [nsdesc] (\$ns) | Act: [kubectl] describe namespace | Desc: Describes namespace"
    add_log_help "Func: ns_get [nsget] (\$ns) | Act: [kubectl] get namespace -o yaml | Desc: Gets namespace YAML"
    add_log_help "Func: ns_get_json [nsjson] (\$ns) | Act: [kubectl] get namespace -o json | Desc: Gets namespace JSON"
    add_log_help "Func: ns_get_count [nscount] (\$ns) | Act: [kubectl] get counts | Desc: Gets resource counts in namespace"
    add_log_help "Func: ns_get_all [nsgetall] (\$ns) | Act: [kubectl] get all -n '\$ns' | Desc: Gets all resources in namespace"
    add_log_help "Func: ns_get_current [nscurrent] () | Act: [kubectl] config view | Desc: Gets current namespace"
    add_log_help "Func: ns_set_ctx [nscontext] (\$ns) | Act: [kubectl] config set-context | Desc: Sets current namespace"
    add_log_help "Func: ns_del [nsdelete] (\$ns) | Act: [kubectl] delete namespace | Desc: Deletes namespace"
    add_log_help "Func: ns_clear [nsclear] (\$ns) | Act: [kubectl] delete all -n '\$ns' | Desc: Deletes all resources in namespace"
    add_log_help "Func: ns_exists [nsexists] (\$ns) | Act: [kubectl] get &>/dev/null | Desc: Checks if namespace exists"
    add_log_help "Func: ns_watch [nswatch] (\$ns) | Act: [watch] kubectl get all | Desc: Watches all resources in namespace"
}
# === CREATE / PUT OPERATIONS ===
ns_add() {
    add_log "=== Func: ns_add ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_add <namespace>"; return 1; fi
    $K8S create namespace "$ns" | add_log
}
nscreate() { ns_add "$@"; }
ns_put() {
    add_log "=== Func: ns_put ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_put <namespace>"; return 1; fi
    if ! ns_exists "$ns" &>/dev/null; then add_log "Creating namespace '$ns'..."; ns_add "$ns"; else add_log "Namespace '$ns' already exists"; fi
}
nsensure() { ns_put "$@"; }
# === READ / DESCRIBE / LS / GET OPERATIONS ===
ns_ls() {
    add_log "=== Func: ns_ls ==="
    add_log "Available namespaces:"
    $K8S get namespaces "$@" | add_log
}
nslist() { ns_ls "$@"; }
ns_desc() {
    add_log "=== Func: ns_desc ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_desc <namespace>"; return 1; fi
    $K8S describe namespace "$ns" | add_log
}
nsdesc() { ns_desc "$@"; }
ns_get() {
    add_log "=== Func: ns_get ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_get <namespace>"; return 1; fi
    $K8S get namespace "$ns" -o yaml | add_log
}
nsget() { ns_get "$@"; }
ns_get_json() {
    add_log "=== Func: ns_get_json ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_get_json <namespace>"; return 1; fi
    $K8S get namespace "$ns" -o json | add_log
}
nsjson() { ns_get_json "$@"; }
ns_get_count() {
    add_log "=== Func: ns_get_count ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_get_count <namespace>"; return 1; fi
    add_log "Resource count in namespace '$ns':"
    add_log "Pods: $($K8S get pods -n "$ns" --no-headers 2>/dev/null | wc -l)"
    add_log "Services: $($K8S get services -n "$ns" --no-headers 2>/dev/null | wc -l)"
    add_log "Deployments: $($K8S get deployments -n "$ns" --no-headers 2>/dev/null | wc -l)"
    add_log "ConfigMaps: $($K8S get configmaps -n "$ns" --no-headers 2>/dev/null | wc -l)"
    add_log "Secrets: $($K8S get secrets -n "$ns" --no-headers 2>/dev/null | wc -l)"
}
nscount() { ns_get_count "$@"; }
ns_get_all() {
    add_log "=== Func: ns_get_all ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_get_all <namespace>"; return 1; fi
    add_log "All resources in namespace '$ns':"
    $K8S get all -n "$ns" | add_log
}
nsgetall() { ns_get_all "$@"; }
ns_get_current() {
    add_log "=== Func: ns_get_current ==="
    local current_ns=$($K8S config view --minify -o jsonpath='{..namespace}')
    if [ -z "$current_ns" ]; then add_log "default"; else add_log "$current_ns"; fi
}
nscurrent() { ns_get_current "$@"; }
# === UPDATE OPERATIONS ===
ns_set_ctx() {
    add_log "=== Func: ns_set_ctx ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_set_ctx <namespace>"; return 1; fi
    $K8S config set-context --current --namespace="$ns" | add_log
    add_log "Default namespace set to '$ns'"
}
nscontext() { ns_set_ctx "$@"; }
# === DELETE OPERATIONS ===
ns_del() {
    add_log "=== Func: ns_del ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_del <namespace>"; return 1; fi
    add_log "WARNING: This will delete the entire namespace '$ns' and all resources in it!"
    read -p "Are you sure? (y/N): " confirm
    if [[ $confirm == [yY] ]]; then $K8S delete namespace "$ns" | add_log; else add_log "Operation cancelled."; return 1; fi
}
ns_delete() { ns_del "$@"; }
ns_clear() {
    add_log "=== Func: ns_clear ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_clear <namespace>"; return 1; fi
    add_log "Clearing all resources in namespace '$ns'..."
    $K8S delete all --all -n "$ns" | add_log
}
nsclear() { ns_clear "$@"; }
# === EXISTS OPERATIONS ===
ns_exists() {
    add_log "=== Func: ns_exists ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_exists <namespace>"; return 1; fi
    if $K8S get namespace "$ns" &>/dev/null; then add_log "Namespace '$ns' exists"; return 0; else add_log "Namespace '$ns' does not exist"; return 1; fi
}
nsexists() { ns_exists "$@"; }
# === MISC OPERATIONS ===
ns_watch() {
    add_log "=== Func: ns_watch ==="
    local ns="$1"
    if [ -z "$ns" ]; then add_log "Usage: ns_watch <namespace>"; return 1; fi
    if command -v watch >/dev/null 2>&1; then watch -n 2 "$K8S get all -n $ns"; else
        add_log "Watching resources in namespace '$ns' (Ctrl+C to stop)..."
        while true; do clear; add_log "Kubernetes Resource Watch | Namespace: $ns | Time: $(date +%H:%M:%S)"; $K8S get all -n "$ns" | add_log; sleep 2; done
    fi
}
nswatch() { ns_watch "$@"; }
