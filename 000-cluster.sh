#!/bin/bash

help_cluster(){
    add_log_help "=== help_cluster ==="
    add_log_help "Func: cluster_context [clstctx] () | Act: [kubectl] config current-context | Desc: Gets current cluster context"
    add_log_help "Func: cluster_version [clstver] () | Act: [kubectl] version --short | Desc: Gets cluster version"
    add_log_help ""
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== cluster_ctx() ===== 
cluster_context() { 
    add_log "=== Func: cluster_context ==="
    $K8S config current-context | add_log 
}
# Short name of cluster_context
clstctx() { cluster_context "$@"; }

# ===== cluster_ver() =====

cluster_version() { 
    add_log "=== Func: cluster_version ==="
    $K8S version | add_log; 
}
# Short name of cluster_version
clstver() { cluster_version "$@"; }
