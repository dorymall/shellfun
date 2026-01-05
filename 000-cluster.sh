#!/bin/bash

help_cluster(){
    echo "Func: cluster_ctx () | Act: [kubectl] config current-context | Desc: Gets current cluster context"
    echo "Func: cluster_ver () | Act: [kubectl] version --short | Desc: Gets cluster version"
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== cluster_ctx() ===== 
#- kubectl config current-context
cluster_ctx() { $K8S config current-context; }

# ===== cluster_ver() =====
#- kubectl version
cluster_ver() { $K8S version; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
bk_get_context() { cluster_ctx "$@"; }
bk_get_version() { cluster_ver "$@"; }
