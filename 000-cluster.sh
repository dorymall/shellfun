#!/bin/bash

help_cluster(){
    add_log "Func: cluster_ctx () | Act: [kubectl] config current-context | Desc: Gets current cluster context"
    add_log "Func: cluster_ver () | Act: [kubectl] version --short | Desc: Gets cluster version"
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== cluster_ctx() ===== 
#- kubectl config current-context
cluster_ctx() { $K8S config current-context | add_log }

# ===== cluster_ver() =====
#- kubectl version
cluster_ver() { $K8S version | add_log; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
bk_get_context() { cluster_ctx "$@" | add_log; }
bk_get_version() { cluster_ver "$@" | add_log; }

