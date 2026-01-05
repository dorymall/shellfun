help_ns(){
    echo "Func: ns_add (\$ns) | Act: [kubectl] create namespace | Desc: Creates namespace"
    echo "Func: ns_put (\$ns) | Act: [kubectl] create namespace | Desc: Creates namespace if not exists"
    echo "Func: ns_ls ([\$args...]) | Act: [kubectl] get namespaces | Desc: Lists namespaces"
    echo "Func: ns ([\$args...]) | Act: [kubectl] get namespaces | Desc: Lists namespaces (short alias)"
    echo "Func: ns_desc (\$ns) | Act: [kubectl] describe namespace | Desc: Describes namespace"
    echo "Func: ns_get (\$ns) | Act: [kubectl] get namespace -o yaml | Desc: Gets namespace YAML"
    echo "Func: ns_get_json (\$ns) | Act: [kubectl] get namespace -o json | Desc: Gets namespace JSON"
    echo "Func: ns_get_count (\$ns) | Act: [kubectl] get counts | Desc: Gets resource counts in namespace"
    echo "Func: ns_get_all (\$ns) | Act: [kubectl] get all -n '\$ns' | Desc: Gets all resources in namespace"
    echo "Func: ns_get_current () | Act: [kubectl] config view | Desc: Gets current namespace"
    echo "Func: ns_set_ctx (\$ns) | Act: [kubectl] config set-context | Desc: Sets current namespace"
    echo "Func: ns_del (\$ns) | Act: [kubectl] delete namespace | Desc: Deletes namespace"
    echo "Func: ns_clear (\$ns) | Act: [kubectl] delete all -n '\$ns' | Desc: Deletes all resources in namespace"
    echo "Func: ns_exists (\$ns) | Act: [kubectl] get &>/dev/null | Desc: Checks if namespace exists"
    echo "Func: ns_watch (\$ns) | Act: [watch] kubectl get all | Desc: Watches all resources in namespace"
}



# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== ns_add(namespace) =====
#- kubectl create namespace "$ns"
ns_add() {
    local ns="$1"
    if [ -z "$ns" ]; then
        echo "Usage: ns_add <namespace>"
        return 1
    fi
    $K8S create namespace "$ns"
}

# ===== ns_put(namespace) =====
#- kubectl create namespace if not exists
ns_put() {
    local ns="$1"
    if [ -z "$ns" ]; then
        echo "Usage: ns_put <namespace>"
        return 1
    fi
    
    if ! ns_exists "$ns" &>/dev/null; then
        echo "Creating namespace '$ns'..."
        ns_add "$ns"
    else
        echo "Namespace '$ns' already exists"
    fi
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== ns_ls(args) =====
#- kubectl get namespaces
ns_ls() {
    echo "Available namespaces:"
    $K8S get namespaces "$@"
}

# ===== ns(args) =====
#- kubectl get namespaces (short alias)
ns() {
    ns_ls "$@"
}

# ===== ns_desc(namespace) =====
#- kubectl describe namespace "$ns"
ns_desc() {
    local ns="$1"
    if [ -z "$ns" ]; then
        echo "Usage: ns_desc <namespace>"
        return 1
    fi
    $K8S describe namespace "$ns"
}

# ===== ns_get(namespace) =====
#- kubectl get namespace "$ns" -o yaml
ns_get() {
    local ns="$1"
    if [ -z "$ns" ]; then
        echo "Usage: ns_get <namespace>"
        return 1
    fi
    $K8S get namespace "$ns" -o yaml
}

# ===== ns_get_json(namespace) =====
#- kubectl get namespace "$ns" -o json
ns_get_json() {
    local ns="$1"
    if [ -z "$ns" ]; then
        echo "Usage: ns_get_json <namespace>"
        return 1
    fi
    $K8S get namespace "$ns" -o json
}

# ===== ns_get_count(namespace) =====
#- kubectl get [resources] counts
ns_get_count() {
    local ns="$1"
    if [ -z "$ns" ]; then echo "Usage: ns_get_count <namespace>"; return 1; fi
    echo "Resource count in namespace '$ns':"
    echo "Pods: $($K8S get pods -n "$ns" --no-headers 2>/dev/null | wc -l)"
    echo "Services: $($K8S get services -n "$ns" --no-headers 2>/dev/null | wc -l)"
    echo "Deployments: $($K8S get deployments -n "$ns" --no-headers 2>/dev/null | wc -l)"
    echo "ConfigMaps: $($K8S get configmaps -n "$ns" --no-headers 2>/dev/null | wc -l)"
    echo "Secrets: $($K8S get secrets -n "$ns" --no-headers 2>/dev/null | wc -l)"
}

# ===== ns_get_all(namespace) =====
#- kubectl get all -n "$ns"
ns_get_all() {
    local ns="$1"
    if [ -z "$ns" ]; then echo "Usage: ns_get_all <namespace>"; return 1; fi
    echo "All resources in namespace '$ns':"
    $K8S get all -n "$ns"
}

# ===== ns_get_current() =====
#- kubectl config view ... jsonpath='{..namespace}'
ns_get_current() {
    local current_ns=$($K8S config view --minify -o jsonpath='{..namespace}')
    if [ -z "$current_ns" ]; then
        echo "default"
    else
        echo "$current_ns"
    fi
}

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== ns_set_ctx(namespace) =====
#- kubectl config set-context --current --namespace="$ns"
ns_set_ctx() {
    local ns="$1"
    if [ -z "$ns" ]; then echo "Usage: ns_set_ctx <namespace>"; return 1; fi
    $K8S config set-context --current --namespace="$ns"
    echo "Default namespace set to '$ns'"
}

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== ns_del(namespace) =====
#- kubectl delete namespace "$ns"
ns_del() {
    local ns="$1"
    if [ -z "$ns" ]; then
        echo "Usage: ns_del <namespace>"
        return 1
    fi
    echo "WARNING: This will delete the entire namespace '$ns' and all resources in it!"
    read -p "Are you sure? (y/N): " confirm
    if [[ $confirm == [yY] ]]; then
        $K8S delete namespace "$ns"
    else
        echo "Operation cancelled."
        return 1
    fi
}

# ===== ns_clear(namespace) =====
#- kubectl delete all --all -n "$ns"
ns_clear() {
    local ns="$1"
    if [ -z "$ns" ]; then
        echo "Usage: ns_clear <namespace>"
        return 1
    fi
    echo "Clearing all resources in namespace '$ns'..."
    $K8S delete all --all -n "$ns"
}

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== ns_exists(namespace) =====
#- kubectl get namespace "$ns"
ns_exists() {
    local ns="$1"
    if [ -z "$ns" ]; then
        echo "Usage: ns_exists <namespace>"
        return 1
    fi
    
    if $K8S get namespace "$ns" &>/dev/null; then
        echo "Namespace '$ns' exists"
        return 0
    else
        echo "Namespace '$ns' does not exist"
        return 1
    fi
}

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== ns_watch(namespace) =====
#- watch loop with kubectl get all
ns_watch() {
    local ns="$1"
    if [ -z "$ns" ]; then
        echo "Usage: ns_watch <namespace>"
        return 1
    fi
    
    if command -v watch >/dev/null 2>&1; then
        watch -n 2 "$K8S get all -n $ns"
    else
        echo "Watching resources in namespace '$ns' (Ctrl+C to stop)..."
        while true; do
            clear
            echo "Kubernetes Resource Watch | Namespace: $ns | Time: $(date +%H:%M:%S)"
            echo "----------------------------------------------------------------------"
            $K8S get all -n "$ns"
            echo "----------------------------------------------------------------------"
            echo "Press Ctrl+C to stop"
            sleep 2
        done
    fi
}
# ========== BACKWARD COMPATIBILITY ALIASES ==========
ns_resource_count() { ns_get_count "$@"; }
ns_get_resources() { ns_get_all "$@"; }
ns_set_context() { ns_set_ctx "$@"; }
