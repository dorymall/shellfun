#!/bin/bash
help_np(){
    add_log_help "=== help_np ==="
    add_log_help "Func: np_add_f [npaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies YAML file"
    add_log_help "Func: np_add_basic [npadd] (\$ns, \$name, \$sel, [\$types]) | Act: [kubectl] create netpol | Desc: Creates basic network policy with pod selector"
    add_log_help "Func: np_add_deny_all [npdenyall] (\$ns, \$name) | Act: [kubectl] create netpol | Desc: Creates default deny-all policy"
    add_log_help "Func: np_add_allow_all [npallowall] (\$ns, \$name) | Act: [kubectl] create netpol | Desc: Creates default allow-all policy"
    add_log_help "Func: np_clone [npclone] (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones network policy"
    add_log_help "Func: np_ls [npls] (\$ns, [\$args...]) | Act: [kubectl] get netpol | Desc: Lists network policies"
    add_log_help "Func: np_ls_all [nplsall] ([\$args...]) | Act: [kubectl] get netpol --all-namespaces | Desc: Lists netpols in all namespaces"
    add_log_help "Func: np_ls_pods [nppods] (\$ns, \$name) | Act: [kubectl] get pods -l | Desc: Lists pods matching policy selector"
    add_log_help "Func: np_get_status [npstatus] (\$ns, \$name) | Act: [jsonpath] .status | Desc: Gets policy status"
    add_log_help "Func: np_get_selector [npselector] (\$ns, \$name) | Act: [jsonpath] .spec.podSelector | Desc: Gets formatted pod selector string"
    add_log_help "Func: np_get_types [nptypes] (\$ns, \$name) | Act: [jsonpath] .spec.policyTypes | Desc: Gets policyTypes (Ingress, Egress)"
    add_log_help "Func: np_get_ingress [nping] (\$ns, \$name) | Act: [jsonpath] .spec.ingress | Desc: Gets ingress rules section"
    add_log_help "Func: np_get_egress [npegr] (\$ns, \$name) | Act: [jsonpath] .spec.egress | Desc: Gets egress rules section"
    add_log_help "Func: np_get_events [npevents] (\$ns, \$name) | Act: [kubectl] get events -l | Desc: Gets events for policy"
    add_log_help "Func: np_count [npcount] (\$ns) | Act: [wc] -l | Desc: Counts network policies in namespace"
    add_log_help "Func: np_desc [npdesc] (\$ns, \$name) | Act: [kubectl] describe netpol | Desc: Describes network policy"
    add_log_help "Func: np_get [npget] (\$ns, \$name) | Act: [kubectl] get netpol -o yaml | Desc: Gets network policy YAML"
    add_log_help "Func: np_upd_selector [npupdselector] (\$ns, \$name, \$sel) | Act: [kubectl] patch netpol | Desc: Updates pod selector"
    add_log_help "Func: np_upd_label [nplabel] (\$ns, \$name, \$key, \$val) | Act: [kubectl] label netpol | Desc: Adds/updates policy label"
    add_log_help "Func: np_upd_unlabel [npunlabel] (\$ns, \$name, \$key) | Act: [kubectl] label netpol (remove) | Desc: Removes label from policy"
    add_log_help "Func: np_upd_annotate [npannotate] (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate netpol | Desc: Adds/updates annotation"
    add_log_help "Func: np_del [npdel] (\$ns, \$name) | Act: [kubectl] delete netpol | Desc: Deletes network policy"
    add_log_help "Func: np_exists [npexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if network policy exists"
    add_log_help "Func: np_watch [npwatch] (\$ns, [\$name]) | Act: [kubectl] get netpol --watch | Desc: Watches network policies"
    add_log_help "Func: np_valid [npvalid] (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if policy YAML is valid"
    add_log_help "Func: np_audit [npaudit] (\$ns) | Act: [kubectl] get netpol and analyze | Desc: Audits network policies in namespace"
    add_log_help "Func: np_backup [npbak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups network policy to YAML file"
    add_log_help "Func: np_restore [nprestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores network policy from file"
}
# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================
np_add_f() { 
    add_log "=== Func: np_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
npaddf() { np_add_f "$@"; }
np_add_basic() {
    add_log "=== Func: np_add_basic ==="
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: { name: "$2", namespace: "$1" }
spec:
  podSelector: { matchLabels: $3 }
  policyTypes: [ "${4:-Ingress}" ]
EOF
}
npadd() { np_add_basic "$@"; }
np_add_deny_all() {
    add_log "=== Func: np_add_deny_all ==="
    cat <<EOF | $K8S apply -f - | add_log
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: { name: "${2:-deny-all}", namespace: "$1" }
spec:
  podSelector: {}
  policyTypes: [ Ingress, Egress ]
EOF
}
npdenyall() { np_add_deny_all "$@"; }
np_add_allow_all() {
    add_log "=== Func: np_add_allow_all ==="
    cat <<EOF | $K8S apply -f - | add_log
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
npallowall() { np_add_allow_all "$@"; }
np_clone() {
    add_log "=== Func: np_clone ==="
    local tn="${4:-$2}"
    $K8S get netpol "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f - | add_log
}
npclone() { np_clone "$@"; }
# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================
np_ls() { 
    add_log "=== Func: np_ls ==="
    $K8S get netpol -n "$1" "${@:2}" | add_log; 
}
npls() { np_ls "$@"; }
np_ls_all() { 
    add_log "=== Func: np_ls_all ==="
    $K8S get netpol --all-namespaces "$@" | add_log; 
}
nplsall() { np_ls_all "$@"; }
np_ls_pods() {
    add_log "=== Func: np_ls_pods ==="
    local sel=$(np_get_selector "$1" "$2")
    if [ -n "$sel" ]; then
        $K8S get pods -n "$1" -l "$sel" | add_log
    else
        add_log "Broad policy (matches all pods)"
    fi
}
nppods() { np_ls_pods "$@"; }
np_get_status() { 
    add_log "=== Func: np_get_status ==="
    $K8S get netpol "$2" -n "$1" -o jsonpath='{.status}' | add_log; 
}
npstatus() { np_get_status "$@"; }
np_get_selector() { 
    add_log "=== Func: np_get_selector ==="
    $K8S get netpol "$2" -n "$1" -o jsonpath='{.spec.podSelector.matchLabels}' | jq -r 'to_entries | map("\(.key)=\(.value)") | join(",")' | add_log; 
}
npselector() { np_get_selector "$@"; }
np_get_types() { 
    add_log "=== Func: np_get_types ==="
    $K8S get netpol "$2" -n "$1" -o jsonpath='{.spec.policyTypes}' | add_log; 
}
nptypes() { np_get_types "$@"; }
np_get_ingress() { 
    add_log "=== Func: np_get_ingress ==="
    $K8S get netpol "$2" -n "$1" -o jsonpath='{.spec.ingress}' | add_log; 
}
nping() { np_get_ingress "$@"; }
np_get_egress() { 
    add_log "=== Func: np_get_egress ==="
    $K8S get netpol "$2" -n "$1" -o jsonpath='{.spec.egress}' | add_log; 
}
npegr() { np_get_egress "$@"; }
np_get_events() { 
    add_log "=== Func: np_get_events ==="
    $K8S get events -n "$1" --field-selector involvedObject.name="$2" | add_log; 
}
npevents() { np_get_events "$@"; }
np_count() { 
    add_log "=== Func: np_count ==="
    $K8S get netpol -n "$1" --no-headers | wc -l | add_log; 
}
npcount() { np_count "$@"; }
np_desc() { 
    add_log "=== Func: np_desc ==="
    $K8S describe netpol "$2" -n "$1" | add_log; 
}
npdesc() { np_desc "$@"; }
np_get() { 
    add_log "=== Func: np_get ==="
    $K8S get netpol "$2" -n "$1" -o yaml | add_log; 
}
npget() { np_get "$@"; }
# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================
np_upd_selector() { 
    add_log "=== Func: np_upd_selector ==="
    $K8S patch netpol "$2" -n "$1" -p "{\"spec\":{\"podSelector\":{\"matchLabels\":$3}}}" | add_log; 
}
npupdselector() { np_upd_selector "$@"; }
np_upd_label() { 
    add_log "=== Func: np_upd_label ==="
    $K8S label netpol "$2" "$3"="$4" -n "$1" | add_log; 
}
nplabel() { np_upd_label "$@"; }
np_upd_unlabel() { 
    add_log "=== Func: np_upd_unlabel ==="
    $K8S label netpol "$2" "$3-" -n "$1" | add_log; 
}
npunlabel() { np_upd_unlabel "$@"; }
np_upd_annotate() { 
    add_log "=== Func: np_upd_annotate ==="
    $K8S annotate netpol "$2" "$3"="$4" -n "$1" | add_log; 
}
npannotate() { np_upd_annotate "$@"; }
# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================
np_del() { 
    add_log "=== Func: np_del ==="
    $K8S delete netpol "$2" -n "$1" | add_log; 
}
npdel() { np_del "$@"; }
# =============================================================================
# ✅ EXISTS OPERATIONS
# =============================================================================
np_exists() { 
    add_log "=== Func: np_exists ==="
    if $K8S get netpol "$2" -n "$1" &>/dev/null; then
        add_log "NetworkPolicy $2 exists in namespace $1"; return 0
    else
        add_log "NetworkPolicy $2 does NOT exist in namespace $1"; return 1
    fi
}
npexists() { np_exists "$@"; }
# =============================================================================
# 🛠️ MISC OPERATIONS
# =============================================================================
np_watch() { 
    add_log "=== Func: np_watch ==="
    if [ -n "$2" ]; then $K8S get netpol "$2" -n "$1" --watch | add_log; else $K8S get netpol -n "$1" --watch | add_log; fi
}
npwatch() { np_watch "$@"; }
np_valid() { 
    add_log "=== Func: np_valid ==="
    $K8S get netpol "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f - | add_log; 
}
npvalid() { np_valid "$@"; }
np_audit() { 
    add_log "=== Func: np_audit ==="
    add_log "Auditing NetworkPolicies in $1..."
    $K8S get netpol -n "$1" -o wide | add_log; 
}
npaudit() { np_audit "$@"; }
np_backup() { 
    add_log "=== Func: np_backup ==="
    $K8S get netpol "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
npbak() { np_backup "$@"; }
np_restore() { 
    add_log "=== Func: np_restore ==="
    $K8S apply -f "$1" | add_log; 
}
nprestore() { np_restore "$@"; }