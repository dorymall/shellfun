#!/bin/bash
help_np(){
    echo "Func: np_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    echo "Func: np_add_basic (\$ns, \$name, \$sel, [\$types]) | Act: [kubectl] create netpol | Desc: Creates basic network policy with pod selector"
    echo "Func: np_add_deny_all (\$ns, \$name) | Act: [kubectl] create netpol | Desc: Creates default deny-all policy"
    echo "Func: np_add_allow_all (\$ns, \$name) | Act: [kubectl] create netpol | Desc: Creates default allow-all policy"
    echo "Func: np_clone (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones network policy"
    echo "Func: np_ls (\$ns, [\$args...]) | Act: [kubectl] get netpol | Desc: Lists network policies"
    echo "Func: np_ls_all ([\$args...]) | Act: [kubectl] get netpol --all-namespaces | Desc: Lists netpols in all namespaces"
    echo "Func: np_ls_pods (\$ns, \$name) | Act: [kubectl] get pods -l | Desc: Lists pods matching policy selector"
    echo "Func: np_get_status (\$ns, \$name) | Act: [jsonpath] .status | Desc: Gets policy status"
    echo "Func: np_get_selector (\$ns, \$name) | Act: [jsonpath] .spec.podSelector | Desc: Gets formatted pod selector string"
    echo "Func: np_get_types (\$ns, \$name) | Act: [jsonpath] .spec.policyTypes | Desc: Gets policyTypes (Ingress, Egress)"
    echo "Func: np_get_ingress (\$ns, \$name) | Act: [jsonpath] .spec.ingress | Desc: Gets ingress rules section"
    echo "Func: np_get_egress (\$ns, \$name) | Act: [jsonpath] .spec.egress | Desc: Gets egress rules section"
    echo "Func: np_get_events (\$ns, \$name) | Act: [kubectl] get events -l | Desc: Gets events for policy"
    echo "Func: np_count (\$ns) | Act: [wc] -l | Desc: Counts network policies in namespace"
    echo "Func: np_desc (\$ns, \$name) | Act: [kubectl] describe netpol | Desc: Describes network policy"
    echo "Func: np_get (\$ns, \$name) | Act: [kubectl] get netpol -o yaml | Desc: Gets network policy YAML"
    echo "Func: np_upd_selector (\$ns, \$name, \$sel) | Act: [kubectl] patch netpol | Desc: Updates pod selector"
    echo "Func: np_upd_label (\$ns, \$name, \$key, \$val) | Act: [kubectl] label netpol | Desc: Adds/updates policy label"
    echo "Func: np_upd_unlabel (\$ns, \$name, \$key) | Act: [kubectl] label netpol (remove) | Desc: Removes label from policy"
    echo "Func: np_upd_annotate (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate netpol | Desc: Adds/updates annotation"
    echo "Func: np_del (\$ns, \$name) | Act: [kubectl] delete netpol | Desc: Deletes network policy"
    echo "Func: np_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if network policy exists"
    echo "Func: np_watch (\$ns, [\$name]) | Act: [kubectl] get netpol --watch | Desc: Watches network policies"
    echo "Func: np_valid (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if policy YAML is valid"
    echo "Func: np_audit (\$ns) | Act: [kubectl] get netpol and analyze | Desc: Audits network policies in namespace"
    echo "Func: np_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups network policy to YAML file"
    echo "Func: np_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores network policy from file"
}

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== np_add_f(file) =====
np_add_f() { $K8S apply -f "$1"; }

# ===== np_add_basic(ns, name, sel, [types]) =====
np_add_basic() {
    cat <<EOF | $K8S apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: { name: "$2", namespace: "$1" }
spec:
  podSelector: { matchLabels: $3 }
  policyTypes: [ "${4:-Ingress}" ]
EOF
}

# ===== np_add_deny_all(ns, name) =====
np_add_deny_all() {
    cat <<EOF | $K8S apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: { name: "${2:-deny-all}", namespace: "$1" }
spec:
  podSelector: {}
  policyTypes: [ Ingress, Egress ]
EOF
}

# ===== np_add_allow_all(ns, name) =====
np_add_allow_all() {
    cat <<EOF | $K8S apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: { name: "${2:-allow-all}", namespace: "$1" }
spec:
  podSelector: {}
  ingress: [ {} ]
  egress: [ {} ]
  policyTypes: [ Ingress, Egress ]
EOF
}

# ===== np_clone(sns, name, tns, [tname]) =====
np_clone() {
    local tn="${4:-$2}"
    $K8S get netpol "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f -
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== np_ls(ns, [args...]) =====
np_ls() { $K8S get netpol -n "$1" "${@:2}"; }

# ===== np_ls_all([args...]) =====
np_ls_all() { $K8S get netpol --all-namespaces "$@"; }

# ===== np_ls_pods(ns, name) =====
np_ls_pods() {
    local sel=$(np_get_selector "$1" "$2")
    [ -n "$sel" ] && $K8S get pods -n "$1" -l "$sel" || echo "Broad policy (matches all pods)"
}

# ===== np_get_status(ns, name) =====
np_get_status() { $K8S get netpol "$2" -n "$1" -o jsonpath='{.status}'; }

# ===== np_get_selector(ns, name) =====
np_get_selector() { $K8S get netpol "$2" -n "$1" -o jsonpath='{.spec.podSelector.matchLabels}' | jq -r 'to_entries | map("\(.key)=\(.value)") | join(",")'; }

# ===== np_get_types(ns, name) =====
np_get_types() { $K8S get netpol "$2" -n "$1" -o jsonpath='{.spec.policyTypes}'; }

# ===== np_get_ingress(ns, name) =====
np_get_ingress() { $K8S get netpol "$2" -n "$1" -o jsonpath='{.spec.ingress}'; }

# ===== np_get_egress(ns, name) =====
np_get_egress() { $K8S get netpol "$2" -n "$1" -o jsonpath='{.spec.egress}'; }

# ===== np_get_events(ns, name) =====
np_get_events() { $K8S get events -n "$1" --field-selector involvedObject.name="$2"; }

# ===== np_count(ns) =====
np_count() { $K8S get netpol -n "$1" --no-headers | wc -l; }

# ===== np_desc(ns, name) =====
np_desc() { $K8S describe netpol "$2" -n "$1"; }

# ===== np_get(ns, name) =====
np_get() { $K8S get netpol "$2" -n "$1" -o yaml; }

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== np_upd_selector(ns, name, sel) =====
np_upd_selector() { $K8S patch netpol "$2" -n "$1" -p "{\"spec\":{\"podSelector\":{\"matchLabels\":$3}}}"; }

# ===== np_upd_label(ns, name, key, val) =====
np_upd_label() { $K8S label netpol "$2" "$3"="$4" -n "$1"; }

# ===== np_upd_unlabel(ns, name, key) =====
np_upd_unlabel() { $K8S label netpol "$2" "$3-" -n "$1"; }

# ===== np_upd_annotate(ns, name, key, val) =====
np_upd_annotate() { $K8S annotate netpol "$2" "$3"="$4" -n "$1"; }

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== np_del(ns, name) =====
np_del() { $K8S delete netpol "$2" -n "$1"; }

# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================

# ===== np_exists(ns, name) =====
np_exists() { $K8S get netpol "$2" -n "$1" &>/dev/null; }

# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================

# ===== np_watch(ns, [name]) =====
np_watch() { [ -n "$2" ] && $K8S get netpol "$2" -n "$1" --watch || $K8S get netpol -n "$1" --watch; }

# ===== np_valid(ns, name) =====
np_valid() { $K8S get netpol "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== np_audit(ns) =====
np_audit() { echo "Auditing NetworkPolicies in $1..."; $K8S get netpol -n "$1" -o wide; }

# ===== np_backup(ns, name, [file]) =====
np_backup() { $K8S get netpol "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# ===== np_restore(file) =====
np_restore() { $K8S apply -f "$1"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
np_add() { np_add_basic "$@"; }
np_deny_all() { np_add_deny_all "$@"; }
np_allow_all() { np_add_allow_all "$@"; }
np_status() { np_get_status "$@"; }
np_get_sel() { np_get_selector "$@"; }
np_pods() { np_ls_pods "$@"; }
np_upd_sel() { np_upd_selector "$@"; }
np_check() { np_valid "$@"; }
np_del_f() { np_del "$@"; }
np_lbl() { np_upd_label "$@"; }
np_unlbl() { np_upd_unlabel "$@"; }
np_annotate() { np_upd_annotate "$@"; }
create_network_policy() { np_add_basic "$@"; }
delete_network_policy() { np_del "$@"; }
list_network_policies() { np_ls "$@"; }
network_policy_exists() { np_exists "$@"; }
describe_network_policy() { np_desc "$@"; }
get_network_policy_yaml() { np_get "$@"; }
watch_network_policy() { np_watch "$@"; }
backup_network_policy() { np_backup "$@"; }