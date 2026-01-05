#!/bin/bash
help_rb(){
    # --- ROLE OPERATIONS (ro_*) ---
    echo "Func: ro_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies Role YAML file"
    echo "Func: ro_add_basic (\$ns, \$name, \$res, \$verbs) | Act: [kubectl] create role | Desc: Creates basic Role"
    echo "Func: ro_ls (\$ns, [\$args...]) | Act: [kubectl] get roles | Desc: Lists Roles"
    echo "Func: ro_ls_all ([\$args...]) | Act: [kubectl] get roles --all-namespaces | Desc: Lists Roles in all namespaces"
    echo "Func: ro_get_perms (\$ns, \$name) | Act: [jsonpath] .rules | Desc: Gets rules section from Role"
    echo "Func: ro_desc (\$ns, \$name) | Act: [kubectl] describe role | Desc: Describes Role"
    echo "Func: ro_get (\$ns, \$name) | Act: [kubectl] get role -o yaml | Desc: Gets Role YAML"
    echo "Func: ro_upd_perms (\$ns, \$name, \$res, \$verbs) | Act: [kubectl] patch role | Desc: Updates Role rules"
    echo "Func: ro_upd_label (\$ns, \$name, \$key, \$val) | Act: [kubectl] label role | Desc: Adds/updates Role label"
    echo "Func: ro_del (\$ns, \$name) | Act: [kubectl] delete role | Desc: Deletes Role"
    echo "Func: ro_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if Role exists"
    echo "Func: ro_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups Role to YAML file"
    
    # --- ROLEBINDING OPERATIONS (rb_*) ---
    echo "Func: rb_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies RoleBinding YAML file"
    echo "Func: rb_add_basic (\$ns, \$name, \$role, \$type, \$sub) | Act: [kubectl] create rolebinding | Desc: Creates basic RoleBinding"
    echo "Func: rb_add_user (\$ns, \$name, \$role, \$user) | Act: [kubectl] create rolebinding | Desc: Binds Role to specific user"
    echo "Func: rb_add_sa (\$ns, \$name, \$role, \$sa, [\$sans]) | Act: [kubectl] create rolebinding | Desc: Binds Role to ServiceAccount"
    echo "Func: rb_clone (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones RoleBinding"
    echo "Func: rb_ls (\$ns, [\$args...]) | Act: [kubectl] get rolebindings | Desc: Lists RoleBindings"
    echo "Func: rb_ls_all ([\$args...]) | Act: [kubectl] get rolebindings --all-namespaces | Desc: Lists RoleBindings in all namespaces"
    echo "Func: rb_get_subjects (\$ns, \$name) | Act: [jsonpath] .subjects | Desc: Lists subjects in RoleBinding"
    echo "Func: rb_desc (\$ns, \$name) | Act: [kubectl] describe rolebinding | Desc: Describes RoleBinding"
    echo "Func: rb_get (\$ns, \$name) | Act: [kubectl] get rolebinding -o yaml | Desc: Gets RoleBinding YAML"
    echo "Func: rb_upd_label (\$ns, \$name, \$key, \$val) | Act: [kubectl] label rolebinding | Desc: Adds/updates label"
    echo "Func: rb_del (\$ns, \$name) | Act: [kubectl] delete rolebinding | Desc: Deletes RoleBinding"
    echo "Func: rb_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if RoleBinding exists"
    echo "Func: rb_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups RoleBinding to YAML file"
    
    # --- CLUSTERROLE OPERATIONS (cr_*) ---
    echo "Func: cr_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies ClusterRole YAML file"
    echo "Func: cr_add_basic (\$name, \$res, \$verbs) | Act: [kubectl] create clusterrole | Desc: Creates basic ClusterRole"
    echo "Func: cr_ls ([\$args...]) | Act: [kubectl] get clusterroles | Desc: Lists ClusterRoles"
    echo "Func: cr_get_perms (\$name) | Act: [jsonpath] .rules | Desc: Gets rules from ClusterRole"
    echo "Func: cr_desc (\$name) | Act: [kubectl] describe clusterrole | Desc: Describes ClusterRole"
    echo "Func: cr_get (\$name) | Act: [kubectl] get clusterrole -o yaml | Desc: Gets ClusterRole YAML"
    echo "Func: cr_upd_label (\$name, \$key, \$val) | Act: [kubectl] label clusterrole | Desc: Adds/updates label"
    echo "Func: cr_del (\$name) | Act: [kubectl] delete clusterrole | Desc: Deletes ClusterRole"
    echo "Func: cr_exists (\$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if ClusterRole exists"
    
    # --- CLUSTERROLEBINDING OPERATIONS (cb_*) ---
    echo "Func: cb_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies ClusterRoleBinding YAML file"
    echo "Func: cb_add_basic (\$name, \$role, \$type, \$sub) | Act: [kubectl] create clusterrolebinding | Desc: Creates basic ClusterRoleBinding"
    echo "Func: cb_add_sa (\$name, \$role, \$sa, \$sans) | Act: [kubectl] create clusterrolebinding | Desc: Binds ClusterRole to ServiceAccount"
    echo "Func: cb_ls ([\$args...]) | Act: [kubectl] get clusterrolebindings | Desc: Lists ClusterRoleBindings"
    echo "Func: cb_desc (\$name) | Act: [kubectl] describe clusterrolebinding | Desc: Describes ClusterRoleBinding"
    echo "Func: cb_get (\$name) | Act: [kubectl] get clusterrolebinding -o yaml | Desc: Gets ClusterRoleBinding YAML"
    echo "Func: cb_upd_label (\$name, \$key, \$val) | Act: [kubectl] label clusterrolebinding | Desc: Adds/updates label"
    echo "Func: cb_del (\$name) | Act: [kubectl] delete clusterrolebinding | Desc: Deletes ClusterRoleBinding"
    echo "Func: cb_exists (\$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if ClusterRoleBinding exists"
    
    # --- SERVICEACCOUNT OPERATIONS (sa_*) ---
    echo "Func: sa_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies SA YAML file"
    echo "Func: sa_add_basic (\$ns, \$name) | Act: [kubectl] create serviceaccount | Desc: Creates basic ServiceAccount"
    echo "Func: sa_ls (\$ns, [\$args...]) | Act: [kubectl] get sa | Desc: Lists ServiceAccounts"
    echo "Func: sa_ls_all ([\$args...]) | Act: [kubectl] get sa --all-namespaces | Desc: Lists SAs in all namespaces"
    echo "Func: sa_get_token (\$ns, \$name) | Act: [kubectl] create token | Desc: Generates token for ServiceAccount"
    echo "Func: sa_desc (\$ns, \$name) | Act: [kubectl] describe sa | Desc: Describes ServiceAccount"
    echo "Func: sa_get (\$ns, \$name) | Act: [kubectl] get sa -o yaml | Desc: Gets ServiceAccount YAML"
    echo "Func: sa_upd_label (\$ns, \$name, \$key, \$val) | Act: [kubectl] label sa | Desc: Adds/updates label"
    echo "Func: sa_del (\$ns, \$name) | Act: [kubectl] delete sa | Desc: Deletes ServiceAccount"
    echo "Func: sa_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if ServiceAccount exists"
    echo "Func: sa_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups SA to YAML file"
    
    # --- GLOBAL RBAC OPERATIONS (rbac_*) ---
    echo "Func: rbac_can (\$verb, \$res, [\$ns]) | Act: [kubectl] auth can-i | Desc: Checks current user permissions"
    echo "Func: rbac_can_user (\$user, \$verb, \$res, [\$ns]) | Act: [kubectl] auth can-i --as | Desc: Checks permissions for specific user"
    echo "Func: rbac_can_sa (\$ns, \$sa, \$verb, \$res) | Act: [kubectl] auth can-i --as SA | Desc: Checks permissions for ServiceAccount"
    echo "Func: rbac_audit (\$ns) | Act: [kubectl] get bindings wide | Desc: Audits RBAC bindings in namespace"
    echo "Func: rbac_valid (\$ns) | Act: [kubectl] auth can-i list pods | Desc: Tests basic connectivity/auth"
    echo "Func: rbac_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores RBAC resource from file"
}

# =============================================================================
# 🔐 ROLE OPERATIONS (ro_*)
# =============================================================================

# ===== ro_add_f(file) =====
ro_add_f() { $K8S apply -f "$1"; }

# ===== ro_add_basic(ns, name, res, verbs) =====
ro_add_basic() { $K8S create role "$2" -n "$1" --resource="$3" --verb="$4"; }

# ===== ro_ls(ns, [args...]) =====
ro_ls() { $K8S get roles -n "$1" "${@:2}"; }

# ===== ro_ls_all([args...]) =====
ro_ls_all() { $K8S get roles --all-namespaces "$@"; }

# ===== ro_get_perms(ns, name) =====
ro_get_perms() { $K8S get role "$2" -n "$1" -o jsonpath='{.rules}'; }

# ===== ro_desc(ns, name) =====
ro_desc() { $K8S describe role "$2" -n "$1"; }

# ===== ro_get(ns, name) =====
ro_get() { $K8S get role "$2" -n "$1" -o yaml; }

# ===== ro_upd_perms(ns, name, res, verbs) =====
ro_upd_perms() { $K8S patch role "$2" -n "$1" -p "{\"rules\":[{\"apiGroups\":[\"\"],\"resources\":[\"$3\"],\"verbs\":[\"$4\"]}]}"; }

# ===== ro_upd_label(ns, name, key, val) =====
ro_upd_label() { $K8S label role "$2" "$3"="$4" -n "$1"; }

# ===== ro_del(ns, name) =====
ro_del() { $K8S delete role "$2" -n "$1"; }

# ===== ro_exists(ns, name) =====
ro_exists() { $K8S get role "$2" -n "$1" &>/dev/null; }

# ===== ro_backup(ns, name, [file]) =====
ro_backup() { $K8S get role "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# =============================================================================
# ⛓️ ROLEBINDING OPERATIONS (rb_*)
# =============================================================================

# ===== rb_add_f(file) =====
rb_add_f() { $K8S apply -f "$1"; }

# ===== rb_add_basic(ns, name, role, type, sub) =====
rb_add_basic() { $K8S create rolebinding "$2" -n "$1" --role="$3" --${4,,}="$5"; }

# ===== rb_add_user(ns, name, role, user) =====
rb_add_user() { rb_add_basic "$1" "$2" "$3" "user" "$4"; }

# ===== rb_add_sa(ns, name, role, sa, [sans]) =====
rb_add_sa() {
    local sn="${5:-$1}"
    $K8S create rolebinding "$2" -n "$1" --role="$3" --serviceaccount="$sn:$4"
}

# ===== rb_clone(sns, name, tns, [tname]) =====
rb_clone() {
    local tn="${4:-$2}"
    $K8S get rolebinding "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f -
}

# ===== rb_ls(ns, [args...]) =====
rb_ls() { $K8S get rolebindings -n "$1" "${@:2}"; }

# ===== rb_ls_all([args...]) =====
rb_ls_all() { $K8S get rolebindings --all-namespaces "$@"; }

# ===== rb_get_subjects(ns, name) =====
rb_get_subjects() { $K8S get rolebinding "$2" -n "$1" -o jsonpath='{.subjects}'; }

# ===== rb_desc(ns, name) =====
rb_desc() { $K8S describe rolebinding "$2" -n "$1"; }

# ===== rb_get(ns, name) =====
rb_get() { $K8S get rolebinding "$2" -n "$1" -o yaml; }

# ===== rb_upd_label(ns, name, key, val) =====
rb_upd_label() { $K8S label rolebinding "$2" "$3"="$4" -n "$1"; }

# ===== rb_del(ns, name) =====
rb_del() { $K8S delete rolebinding "$2" -n "$1"; }

# ===== rb_exists(ns, name) =====
rb_exists() { $K8S get rolebinding "$2" -n "$1" &>/dev/null; }

# ===== rb_backup(ns, name, [file]) =====
rb_backup() { $K8S get rolebinding "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# =============================================================================
# 🌍 CLUSTERROLE OPERATIONS (cr_*)
# =============================================================================

# ===== cr_add_f(file) =====
cr_add_f() { $K8S apply -f "$1"; }

# ===== cr_add_basic(name, res, verbs) =====
cr_add_basic() { $K8S create clusterrole "$1" --resource="$2" --verb="$3"; }

# ===== cr_ls([args...]) =====
cr_ls() { $K8S get clusterroles "$@"; }

# ===== cr_get_perms(name) =====
cr_get_perms() { $K8S get clusterrole "$1" -o jsonpath='{.rules}'; }

# ===== cr_desc(name) =====
cr_desc() { $K8S describe clusterrole "$1"; }

# ===== cr_get(name) =====
cr_get() { $K8S get clusterrole "$1" -o yaml; }

# ===== cr_upd_label(name, key, val) =====
cr_upd_label() { $K8S label clusterrole "$1" "$2"="$3"; }

# ===== cr_del(name) =====
cr_del() { $K8S delete clusterrole "$1"; }

# ===== cr_exists(name) =====
cr_exists() { $K8S get clusterrole "$1" &>/dev/null; }

# =============================================================================
# � CLUSTERROLEBINDING OPERATIONS (cb_*)
# =============================================================================

# ===== cb_add_f(file) =====
cb_add_f() { $K8S apply -f "$1"; }

# ===== cb_add_basic(name, role, type, sub) =====
cb_add_basic() { $K8S create clusterrolebinding "$1" --clusterrole="$2" --${3,,}="$4"; }

# ===== cb_add_sa(name, role, sa, sans) =====
cb_add_sa() { $K8S create clusterrolebinding "$1" --clusterrole="$2" --serviceaccount="$4:$3"; }

# ===== cb_ls([args...]) =====
cb_ls() { $K8S get clusterrolebindings "$@"; }

# ===== cb_desc(name) =====
cb_desc() { $K8S describe clusterrolebinding "$1"; }

# ===== cb_get(name) =====
cb_get() { $K8S get clusterrolebinding "$1" -o yaml; }

# ===== cb_upd_label(name, key, val) =====
cb_upd_label() { $K8S label clusterrolebinding "$1" "$2"="$3"; }

# ===== cb_del(name) =====
cb_del() { $K8S delete clusterrolebinding "$1"; }

# ===== cb_exists(name) =====
cb_exists() { $K8S get clusterrolebinding "$1" &>/dev/null; }

# =============================================================================
# � SERVICEACCOUNT OPERATIONS (sa_*)
# =============================================================================

# ===== sa_add_f(file) =====
sa_add_f() { $K8S apply -f "$1"; }

# ===== sa_add_basic(ns, name) =====
sa_add_basic() { $K8S create serviceaccount "$2" -n "$1"; }

# ===== sa_ls(ns, [args...]) =====
sa_ls() { $K8S get sa -n "$1" "${@:2}"; }

# ===== sa_ls_all([args...]) =====
sa_ls_all() { $K8S get sa --all-namespaces "$@"; }

# ===== sa_get_token(ns, name) =====
sa_get_token() { $K8S create token "$2" -n "$1"; }

# ===== sa_desc(ns, name) =====
sa_desc() { $K8S describe sa "$2" -n "$1"; }

# ===== sa_get(ns, name) =====
sa_get() { $K8S get sa "$2" -n "$1" -o yaml; }

# ===== sa_upd_label(ns, name, key, val) =====
sa_upd_label() { $K8S label sa "$2" "$3"="$4" -n "$1"; }

# ===== sa_del(ns, name) =====
sa_del() { $K8S delete sa "$2" -n "$1"; }

# ===== sa_exists(ns, name) =====
sa_exists() { $K8S get sa "$2" -n "$1" &>/dev/null; }

# ===== sa_backup(ns, name, [file]) =====
sa_backup() { $K8S get sa "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# =============================================================================
# �️ GLOBAL RBAC OPERATIONS (rbac_*)
# =============================================================================

# ===== rbac_can(verb, res, [ns]) =====
rbac_can() { $K8S auth can-i "$1" "$2" ${3:+-n $3}; }

# ===== rbac_can_user(user, verb, res, [ns]) =====
rbac_can_user() { $K8S auth can-i "$2" "$3" --as="$1" ${4:+-n $4}; }

# ===== rbac_can_sa(ns, sa, verb, res) =====
rbac_can_sa() { $K8S auth can-i "$3" "$4" --as=system:serviceaccount:"$1":"$2" -n "$1"; }

# ===== rbac_audit(ns) =====
rbac_audit() { echo "RBAC Audit for $1..."; $K8S get rolebindings,clusterrolebindings -n "$1" -o wide; }

# ===== rbac_valid(ns) =====
rbac_valid() { $K8S auth can-i list pods -n "$1"; }

# ===== rbac_restore(file) =====
rbac_restore() { $K8S apply -f "$1"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
ro_add() { ro_add_basic "$@"; }
rb_add() { rb_add_basic "$@"; }
cr_add() { cr_add_basic "$@"; }
cb_add() { cb_add_basic "$@"; }
cb_add_sa() { cb_add_sa "$@"; }
sa_add() { sa_add_basic "$@"; }
ro_restore() { rbac_restore "$@"; }
ro_get_json() { $K8S get role "$2" -n "$1" -o json; }
rb_get_subs() { rb_get_subjects "$@"; }
rbac_check_secure() { rbac_audit "$@"; }
ro_lbl() { ro_upd_label "$@"; }
rb_lbl() { rb_upd_label "$@"; }
cr_lbl() { cr_upd_label "$@"; }
cb_lbl() { cb_upd_label "$@"; }
sa_lbl() { sa_upd_label "$@"; }
create_role() { ro_add_basic "$@"; }
delete_role() { ro_del "$@"; }
list_roles() { ro_ls "$@"; }
# role_exists() { ro_exists "$@"; } # Match existing alias pattern
create_role_binding() { rb_add_basic "$@"; }
delete_role_binding() { rb_del "$@"; }
list_role_bindings() { rb_ls "$@"; }
# role_binding_exists() { rb_exists "$@"; }
create_service_account() { sa_add_basic "$@"; }
delete_service_account() { sa_del "$@"; }
list_service_accounts() { sa_ls "$@"; }
# service_account_exists() { sa_exists "$@"; }
describe_role() { ro_desc "$@"; }
describe_role_binding() { rb_desc "$@"; }
describe_cluster_role() { cr_desc "$@"; }
describe_cluster_role_binding() { cb_desc "$@"; }
describe_service_account() { sa_desc "$@"; }