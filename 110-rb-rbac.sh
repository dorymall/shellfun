#!/bin/bash
help_rb(){
    add_log_help "=== help_rb ==="
    # --- ROLE OPERATIONS (ro_*) ---
    add_log_help "Func: ro_add_f [roaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies Role YAML file"
    add_log_help "Func: ro_add_basic [roadd] (\$ns, \$name, \$res, \$verbs) | Act: [kubectl] create role | Desc: Creates basic Role"
    add_log_help "Func: ro_ls [rols] (\$ns, [\$args...]) | Act: [kubectl] get roles | Desc: Lists Roles"
    add_log_help "Func: ro_ls_all [rolsall] ([\$args...]) | Act: [kubectl] get roles --all-namespaces | Desc: Lists Roles in all namespaces"
    add_log_help "Func: ro_get_perms [roperms] (\$ns, \$name) | Act: [jsonpath] .rules | Desc: Gets rules section from Role"
    add_log_help "Func: ro_desc [rodesc] (\$ns, \$name) | Act: [kubectl] describe role | Desc: Describes Role"
    add_log_help "Func: ro_get [roget] (\$ns, \$name) | Act: [kubectl] get role -o yaml | Desc: Gets Role YAML"
    add_log_help "Func: ro_upd_perms [roupdperms] (\$ns, \$name, \$res, \$verbs) | Act: [kubectl] patch role | Desc: Updates Role rules"
    add_log_help "Func: ro_upd_label [rolabel] (\$ns, \$name, \$key, \$val) | Act: [kubectl] label role | Desc: Adds/updates Role label"
    add_log_help "Func: ro_del [rodel] (\$ns, \$name) | Act: [kubectl] delete role | Desc: Deletes Role"
    add_log_help "Func: ro_exists [roexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if Role exists"
    add_log_help "Func: ro_backup [robak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups Role to YAML file"
    
    # --- ROLEBINDING OPERATIONS (rb_*) ---
    add_log_help "Func: rb_add_f [rbaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies RoleBinding YAML file"
    add_log_help "Func: rb_add_basic [rbadd] (\$ns, \$name, \$role, \$type, \$sub) | Act: [kubectl] create rolebinding | Desc: Creates basic RoleBinding"
    add_log_help "Func: rb_add_user [rbadduser] (\$ns, \$name, \$role, \$user) | Act: [kubectl] create rolebinding | Desc: Binds Role to specific user"
    add_log_help "Func: rb_add_sa [rbaddsa] (\$ns, \$name, \$role, \$sa, [\$sans]) | Act: [kubectl] create rolebinding | Desc: Binds Role to ServiceAccount"
    add_log_help "Func: rb_clone [rbclone] (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones RoleBinding"
    add_log_help "Func: rb_ls [rbls] (\$ns, [\$args...]) | Act: [kubectl] get rolebindings | Desc: Lists RoleBindings"
    add_log_help "Func: rb_ls_all [rblsall] ([\$args...]) | Act: [kubectl] get rolebindings --all-namespaces | Desc: Lists RoleBindings in all namespaces"
    add_log_help "Func: rb_get_subjects [rbsubjects] (\$ns, \$name) | Act: [jsonpath] .subjects | Desc: Lists subjects in RoleBinding"
    add_log_help "Func: rb_desc [rbdesc] (\$ns, \$name) | Act: [kubectl] describe rolebinding | Desc: Describes RoleBinding"
    add_log_help "Func: rb_get [rbget] (\$ns, \$name) | Act: [kubectl] get rolebinding -o yaml | Desc: Gets RoleBinding YAML"
    add_log_help "Func: rb_upd_label [rblabel] (\$ns, \$name, \$key, \$val) | Act: [kubectl] label rolebinding | Desc: Adds/updates label"
    add_log_help "Func: rb_del [rbdel] (\$ns, \$name) | Act: [kubectl] delete rolebinding | Desc: Deletes RoleBinding"
    add_log_help "Func: rb_exists [rbexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if RoleBinding exists"
    add_log_help "Func: rb_backup [rbbak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups RoleBinding to YAML file"
    
    # --- CLUSTERROLE OPERATIONS (cr_*) ---
    add_log_help "Func: cr_add_f [craddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies ClusterRole YAML file"
    add_log_help "Func: cr_add_basic [cradd] (\$name, \$res, \$verbs) | Act: [kubectl] create clusterrole | Desc: Creates basic ClusterRole"
    add_log_help "Func: cr_ls [crls] ([\$args...]) | Act: [kubectl] get clusterroles | Desc: Lists ClusterRoles"
    add_log_help "Func: cr_get_perms [crperms] (\$name) | Act: [jsonpath] .rules | Desc: Gets rules from ClusterRole"
    add_log_help "Func: cr_desc [crdesc] (\$name) | Act: [kubectl] describe clusterrole | Desc: Describes ClusterRole"
    add_log_help "Func: cr_get [crget] (\$name) | Act: [kubectl] get clusterrole -o yaml | Desc: Gets ClusterRole YAML"
    add_log_help "Func: cr_upd_label [crlabel] (\$name, \$key, \$val) | Act: [kubectl] label clusterrole | Desc: Adds/updates label"
    add_log_help "Func: cr_del [crdel] (\$name) | Act: [kubectl] delete clusterrole | Desc: Deletes ClusterRole"
    add_log_help "Func: cr_exists [crexists] (\$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if ClusterRole exists"
    
    # --- CLUSTERROLEBINDING OPERATIONS (cb_*) ---
    add_log_help "Func: cb_add_f [cbaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies ClusterRoleBinding YAML file"
    add_log_help "Func: cb_add_basic [cbadd] (\$name, \$role, \$type, \$sub) | Act: [kubectl] create clusterrolebinding | Desc: Creates basic ClusterRoleBinding"
    add_log_help "Func: cb_add_sa [cbaddsa] (\$name, \$role, \$sa, \$sans) | Act: [kubectl] create clusterrolebinding | Desc: Binds ClusterRole to ServiceAccount"
    add_log_help "Func: cb_ls [cbls] ([\$args...]) | Act: [kubectl] get clusterrolebindings | Desc: Lists ClusterRoleBindings"
    add_log_help "Func: cb_desc [cbdesc] (\$name) | Act: [kubectl] describe clusterrolebinding | Desc: Describes ClusterRoleBinding"
    add_log_help "Func: cb_get [cbget] (\$name) | Act: [kubectl] get clusterrolebinding -o yaml | Desc: Gets ClusterRoleBinding YAML"
    add_log_help "Func: cb_upd_label [cblabel] (\$name, \$key, \$val) | Act: [kubectl] label clusterrolebinding | Desc: Adds/updates label"
    add_log_help "Func: cb_del [cbdel] (\$name) | Act: [kubectl] delete clusterrolebinding | Desc: Deletes ClusterRoleBinding"
    add_log_help "Func: cb_exists [cbexists] (\$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if ClusterRoleBinding exists"
    
    # --- SERVICEACCOUNT OPERATIONS (sa_*) ---
    add_log_help "Func: sa_add_f [saaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies SA YAML file"
    add_log_help "Func: sa_add_basic [saadd] (\$ns, \$name) | Act: [kubectl] create serviceaccount | Desc: Creates basic ServiceAccount"
    add_log_help "Func: sa_ls [sals] (\$ns, [\$args...]) | Act: [kubectl] get sa | Desc: Lists ServiceAccounts"
    add_log_help "Func: sa_ls_all [salsall] ([\$args...]) | Act: [kubectl] get sa --all-namespaces | Desc: Lists SAs in all namespaces"
    add_log_help "Func: sa_get_token [satoken] (\$ns, \$name) | Act: [kubectl] create token | Desc: Generates token for ServiceAccount"
    add_log_help "Func: sa_desc [sadesc] (\$ns, \$name) | Act: [kubectl] describe sa | Desc: Describes ServiceAccount"
    add_log_help "Func: sa_get [saget] (\$ns, \$name) | Act: [kubectl] get sa -o yaml | Desc: Gets ServiceAccount YAML"
    add_log_help "Func: sa_upd_label [salabel] (\$ns, \$name, \$key, \$val) | Act: [kubectl] label sa | Desc: Adds/updates label"
    add_log_help "Func: sa_del [sadel] (\$ns, \$name) | Act: [kubectl] delete sa | Desc: Deletes ServiceAccount"
    add_log_help "Func: sa_exists [saexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if ServiceAccount exists"
    add_log_help "Func: sa_backup [sabak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups SA to YAML file"
    
    # --- GLOBAL RBAC OPERATIONS (rbac_*) ---
    add_log_help "Func: rbac_can [rbcan] (\$verb, \$res, [\$ns]) | Act: [kubectl] auth can-i | Desc: Checks current user permissions"
    add_log_help "Func: rbac_can_user [rbcanuser] (\$user, \$verb, \$res, [\$ns]) | Act: [kubectl] auth can-i --as | Desc: Checks permissions for specific user"
    add_log_help "Func: rbac_can_sa [rbcansa] (\$ns, \$sa, \$verb, \$res) | Act: [kubectl] auth can-i --as SA | Desc: Checks permissions for ServiceAccount"
    add_log_help "Func: rbac_audit [rbaudit] (\$ns) | Act: [kubectl] get bindings wide | Desc: Audits RBAC bindings in namespace"
    add_log_help "Func: rbac_valid [rbvalid] (\$ns) | Act: [kubectl] auth can-i list pods | Desc: Tests basic connectivity/auth"
    add_log_help "Func: rbac_restore [rbrestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores RBAC resource from file"
}
# === ROLE OPERATIONS (ro_*) ===
ro_add_f() { 
    add_log "=== Func: ro_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
roaddf() { ro_add_f "$@"; }
ro_add_basic() { 
    add_log "=== Func: ro_add_basic ==="
    $K8S create role "$2" -n "$1" --resource="$3" --verb="$4" | add_log; 
}
roadd() { ro_add_basic "$@"; }
ro_ls() { 
    add_log "=== Func: ro_ls ==="
    $K8S get roles -n "$1" "${@:2}" | add_log; 
}
rols() { ro_ls "$@"; }
ro_ls_all() { 
    add_log "=== Func: ro_ls_all ==="
    $K8S get roles --all-namespaces "$@" | add_log; 
}
rolsall() { ro_ls_all "$@"; }
ro_get_perms() { 
    add_log "=== Func: ro_get_perms ==="
    $K8S get role "$2" -n "$1" -o jsonpath='{.rules}' | add_log; 
}
roperms() { ro_get_perms "$@"; }
ro_desc() { 
    add_log "=== Func: ro_desc ==="
    $K8S describe role "$2" -n "$1" | add_log; 
}
rodesc() { ro_desc "$@"; }
ro_get() { 
    add_log "=== Func: ro_get ==="
    $K8S get role "$2" -n "$1" -o yaml | add_log; 
}
roget() { ro_get "$@"; }
ro_upd_perms() { 
    add_log "=== Func: ro_upd_perms ==="
    $K8S patch role "$2" -n "$1" -p "{\"rules\":[{\"apiGroups\":[\"\"],\"resources\":[\"$3\"],\"verbs\":[\"$4\"]}]}" | add_log; 
}
roupdperms() { ro_upd_perms "$@"; }
ro_upd_label() { 
    add_log "=== Func: ro_upd_label ==="
    $K8S label role "$2" "$3"="$4" -n "$1" | add_log; 
}
rolabel() { ro_upd_label "$@"; }
ro_del() { 
    add_log "=== Func: ro_del ==="
    $K8S delete role "$2" -n "$1" | add_log; 
}
rodel() { ro_del "$@"; }
ro_exists() { 
    add_log "=== Func: ro_exists ==="
    if $K8S get role "$2" -n "$1" &>/dev/null; then add_log "Role $2 exists in namespace $1"; return 0; else add_log "Role $2 does NOT exist in namespace $1"; return 1; fi
}
roexists() { ro_exists "$@"; }
ro_backup() { 
    add_log "=== Func: ro_backup ==="
    $K8S get role "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
robak() { ro_backup "$@"; }
# === ROLEBINDING OPERATIONS (rb_*) ===
rb_add_f() { 
    add_log "=== Func: rb_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
rbaddf() { rb_add_f "$@"; }
rb_add_basic() { 
    add_log "=== Func: rb_add_basic ==="
    $K8S create rolebinding "$2" -n "$1" --role="$3" --${4,,}="$5" | add_log; 
}
rbadd() { rb_add_basic "$@"; }
rb_add_user() { 
    add_log "=== Func: rb_add_user ==="
    rb_add_basic "$1" "$2" "$3" "user" "$4"; 
}
rbadduser() { rb_add_user "$@"; }
rb_add_sa() {
    add_log "=== Func: rb_add_sa ==="
    local sn="${5:-$1}"
    $K8S create rolebinding "$2" -n "$1" --role="$3" --serviceaccount="$sn:$4" | add_log
}
rbaddsa() { rb_add_sa "$@"; }
rb_clone() {
    add_log "=== Func: rb_clone ==="
    local tn="${4:-$2}"
    $K8S get rolebinding "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f - | add_log
}
rbclone() { rb_clone "$@"; }
rb_ls() { 
    add_log "=== Func: rb_ls ==="
    $K8S get rolebindings -n "$1" "${@:2}" | add_log; 
}
rbls() { rb_ls "$@"; }
rb_ls_all() { 
    add_log "=== Func: rb_ls_all ==="
    $K8S get rolebindings --all-namespaces "$@" | add_log; 
}
rblsall() { rb_ls_all "$@"; }
rb_get_subjects() { 
    add_log "=== Func: rb_get_subjects ==="
    $K8S get rolebinding "$2" -n "$1" -o jsonpath='{.subjects}' | add_log; 
}
rbsubjects() { rb_get_subjects "$@"; }
rb_desc() { 
    add_log "=== Func: rb_desc ==="
    $K8S describe rolebinding "$2" -n "$1" | add_log; 
}
rbdesc() { rb_desc "$@"; }
rb_get() { 
    add_log "=== Func: rb_get ==="
    $K8S get rolebinding "$2" -n "$1" -o yaml | add_log; 
}
rbget() { rb_get "$@"; }
rb_upd_label() { 
    add_log "=== Func: rb_upd_label ==="
    $K8S label rolebinding "$2" "$3"="$4" -n "$1" | add_log; 
}
rblabel() { rb_upd_label "$@"; }
rb_del() { 
    add_log "=== Func: rb_del ==="
    $K8S delete rolebinding "$2" -n "$1" | add_log; 
}
rbdel() { rb_del "$@"; }
rb_exists() { 
    add_log "=== Func: rb_exists ==="
    if $K8S get rolebinding "$2" -n "$1" &>/dev/null; then add_log "RoleBinding $2 exists in namespace $1"; return 0; else add_log "RoleBinding $2 does NOT exist in namespace $1"; return 1; fi
}
rbexists() { rb_exists "$@"; }
rb_backup() { 
    add_log "=== Func: rb_backup ==="
    $K8S get rolebinding "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
rbbak() { rb_backup "$@"; }
# === CLUSTERROLE OPERATIONS (cr_*) ===
cr_add_f() { 
    add_log "=== Func: cr_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
craddf() { cr_add_f "$@"; }
cr_add_basic() { 
    add_log "=== Func: cr_add_basic ==="
    $K8S create clusterrole "$1" --resource="$2" --verb="$3" | add_log; 
}
cradd() { cr_add_basic "$@"; }
cr_ls() { 
    add_log "=== Func: cr_ls ==="
    $K8S get clusterroles "$@" | add_log; 
}
crls() { cr_ls "$@"; }
cr_get_perms() { 
    add_log "=== Func: cr_get_perms ==="
    $K8S get clusterrole "$1" -o jsonpath='{.rules}' | add_log; 
}
crperms() { cr_get_perms "$@"; }
cr_desc() { 
    add_log "=== Func: cr_desc ==="
    $K8S describe clusterrole "$1" | add_log; 
}
crdesc() { cr_desc "$@"; }
cr_get() { 
    add_log "=== Func: cr_get ==="
    $K8S get clusterrole "$1" -o yaml | add_log; 
}
crget() { cr_get "$@"; }
cr_upd_label() { 
    add_log "=== Func: cr_upd_label ==="
    $K8S label clusterrole "$1" "$2"="$3" | add_log; 
}
crlabel() { cr_upd_label "$@"; }
cr_del() { 
    add_log "=== Func: cr_del ==="
    $K8S delete clusterrole "$1" | add_log; 
}
crdel() { cr_del "$@"; }
cr_exists() { 
    add_log "=== Func: cr_exists ==="
    if $K8S get clusterrole "$1" &>/dev/null; then add_log "ClusterRole $1 exists"; return 0; else add_log "ClusterRole $1 does NOT exist"; return 1; fi
}
crexists() { cr_exists "$@"; }
# === CLUSTERROLEBINDING OPERATIONS (cb_*) ===
cb_add_f() { 
    add_log "=== Func: cb_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
cbaddf() { cb_add_f "$@"; }
cb_add_basic() { 
    add_log "=== Func: cb_add_basic ==="
    $K8S create clusterrolebinding "$1" --clusterrole="$2" --${3,,}="$4" | add_log; 
}
cbadd() { cb_add_basic "$@"; }
cb_add_sa() { 
    add_log "=== Func: cb_add_sa ==="
    $K8S create clusterrolebinding "$1" --clusterrole="$2" --serviceaccount="$4:$3" | add_log; 
}
cbaddsa() { cb_add_sa "$@"; }
cb_ls() { 
    add_log "=== Func: cb_ls ==="
    $K8S get clusterrolebindings "$@" | add_log; 
}
cbls() { cb_ls "$@"; }
cb_desc() { 
    add_log "=== Func: cb_desc ==="
    $K8S describe clusterrolebinding "$1" | add_log; 
}
cbdesc() { cb_desc "$@"; }
cb_get() { 
    add_log "=== Func: cb_get ==="
    $K8S get clusterrolebinding "$1" -o yaml | add_log; 
}
cbget() { cb_get "$@"; }
cb_upd_label() { 
    add_log "=== Func: cb_upd_label ==="
    $K8S label clusterrolebinding "$1" "$2"="$3" | add_log; 
}
cblabel() { cb_upd_label "$@"; }
cb_del() { 
    add_log "=== Func: cb_del ==="
    $K8S delete clusterrolebinding "$1" | add_log; 
}
cbdel() { cb_del "$@"; }
cb_exists() { 
    add_log "=== Func: cb_exists ==="
    if $K8S get clusterrolebinding "$1" &>/dev/null; then add_log "ClusterRoleBinding $1 exists"; return 0; else add_log "ClusterRoleBinding $1 does NOT exist"; return 1; fi
}
cbexists() { cb_exists "$@"; }
# === SERVICEACCOUNT OPERATIONS (sa_*) ===
sa_add_f() { 
    add_log "=== Func: sa_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
saaddf() { sa_add_f "$@"; }
sa_add_basic() { 
    add_log "=== Func: sa_add_basic ==="
    $K8S create serviceaccount "$2" -n "$1" | add_log; 
}
saadd() { sa_add_basic "$@"; }
sa_ls() { 
    add_log "=== Func: sa_ls ==="
    $K8S get sa -n "$1" "${@:2}" | add_log; 
}
sals() { sa_ls "$@"; }
sa_ls_all() { 
    add_log "=== Func: sa_ls_all ==="
    $K8S get sa --all-namespaces "$@" | add_log; 
}
salsall() { sa_ls_all "$@"; }
sa_get_token() { 
    add_log "=== Func: sa_get_token ==="
    $K8S create token "$2" -n "$1" | add_log; 
}
satoken() { sa_get_token "$@"; }
sa_desc() { 
    add_log "=== Func: sa_desc ==="
    $K8S describe sa "$2" -n "$1" | add_log; 
}
sadesc() { sa_desc "$@"; }
sa_get() { 
    add_log "=== Func: sa_get ==="
    $K8S get sa "$2" -n "$1" -o yaml | add_log; 
}
saget() { sa_get "$@"; }
sa_upd_label() { 
    add_log "=== Func: sa_upd_label ==="
    $K8S label sa "$2" "$3"="$4" -n "$1" | add_log; 
}
salabel() { sa_upd_label "$@"; }
sa_del() { 
    add_log "=== Func: sa_del ==="
    $K8S delete sa "$2" -n "$1" | add_log; 
}
sadel() { sa_del "$@"; }
sa_exists() { 
    add_log "=== Func: sa_exists ==="
    if $K8S get sa "$2" -n "$1" &>/dev/null; then add_log "ServiceAccount $2 exists in namespace $1"; return 0; else add_log "ServiceAccount $2 does NOT exist in namespace $1"; return 1; fi
}
saexists() { sa_exists "$@"; }
sa_backup() { 
    add_log "=== Func: sa_backup ==="
    $K8S get sa "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
sabak() { sa_backup "$@"; }
# === GLOBAL RBAC OPERATIONS (rbac_*) ===
rbac_can() { 
    add_log "=== Func: rbac_can ==="
    $K8S auth can-i "$1" "$2" ${3:+-n $3} | add_log; 
}
rbcan() { rbac_can "$@"; }
rbac_can_user() { 
    add_log "=== Func: rbac_can_user ==="
    $K8S auth can-i "$2" "$3" --as="$1" ${4:+-n $4} | add_log; 
}
rbcanuser() { rbac_can_user "$@"; }
rbac_can_sa() { 
    add_log "=== Func: rbac_can_sa ==="
    $K8S auth can-i "$3" "$4" --as=system:serviceaccount:"$1":"$2" -n "$1" | add_log; 
}
rbcansa() { rbac_can_sa "$@"; }
rbac_audit() { 
    add_log "=== Func: rbac_audit ==="
    add_log "RBAC Audit for $1..."
    $K8S get rolebindings,clusterrolebindings -n "$1" -o wide | add_log; 
}
rbaudit() { rbac_audit "$@"; }
rbac_valid() { 
    add_log "=== Func: rbac_valid ==="
    $K8S auth can-i list pods -n "$1" | add_log; 
}
rbvalid() { rbac_valid "$@"; }
rbac_restore() { 
    add_log "=== Func: rbac_restore ==="
    $K8S apply -f "$1" | add_log; 
}
rbrestore() { rbac_restore "$@"; }