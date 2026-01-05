#!/bin/bash
help_cr(){
    # --- CRD OPERATIONS (crd_*) ---
    echo "Func: crd_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies CRD YAML file"
    echo "Func: crd_ls ([\$args...]) | Act: [kubectl] get crd | Desc: Lists CRDs"
    echo "Func: crd_desc (\$name) | Act: [kubectl] describe crd | Desc: Describes CRD"
    echo "Func: crd_get_info (\$name) | Act: [kubectl] get crd -o wide | Desc: Gets wide CRD info"
    echo "Func: crd_get_versions (\$name) | Act: [jsonpath] .spec.versions | Desc: Lists served/storage versions"
    echo "Func: crd_get_schema (\$name) | Act: [jq] filter openAPIV3Schema | Desc: Gets CRD schema"
    echo "Func: crd_get_shortnames (\$name) | Act: [jsonpath] .spec.names.shortNames | Desc: Lists shortNames"
    echo "Func: crd_count () | Act: [wc] -l | Desc: Counts total CRDs"
    echo "Func: crd_upd_patch (\$name, \$patch, [\$type]) | Act: [kubectl] patch crd | Desc: Patches CRD definition"
    echo "Func: crd_upd_replace (\$name, \$yaml) | Act: [kubectl] replace crd | Desc: Replaces CRD definition"
    echo "Func: crd_upd_preserve_unknown (\$name, \$mode) | Act: [kubectl] patch preserveUnknownFields | Desc: Updates field preservation mode"
    echo "Func: crd_upd_conversion (\$name, \$strategy) | Act: [kubectl] patch conversion | Desc: Updates conversion strategy"
    echo "Func: crd_del (\$name, [\$cascade]) | Act: [kubectl] delete crd | Desc: Deletes CRD"
    echo "Func: crd_exists (\$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if CRD exists"
    echo "Func: crd_wait_established (\$name, [\$timeout]) | Act: [kubectl] wait --for=condition=Established | Desc: Waits for CRD to be ready"
    
    # --- CUSTOM RESOURCE OPERATIONS (cr_*) ---
    echo "Func: cr_add_f (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Applies Custom Resource from file"
    echo "Func: cr_gen_template (\$file, \$api, \$kind, \$ns, \$name) | Act: [cat] > file | Desc: Generates Custom Resource template"
    echo "Func: cr_clone (\$src_ns, \$target_ns, \$grp, \$ver, \$res, \$name, [\$new_name]) | Act: [jq] and [kubectl] apply | Desc: Clones Custom Resource"
    echo "Func: cr_migrate_ns (\$src_ns, \$target_ns, \$grp, \$ver, \$res, \$name) | Act: [sed] and [kubectl] apply | Desc: Moves CR between namespaces"
    echo "Func: cr_ls (\$ns, \$grp, \$ver, \$res, [\$args...]) | Act: [kubectl] get custom-resource | Desc: Lists custom resources"
    echo "Func: cr_ls_all (\$grp, \$ver, \$res, [\$args...]) | Act: [kubectl] get custom-resource --all-namespaces | Desc: Lists CRs in all namespaces"
    echo "Func: cr_ls_label (\$ns, \$grp, \$ver, \$res, \$selector) | Act: [kubectl] get -l | Desc: Lists CRs filtered by label"
    echo "Func: cr_get (\$ns, \$grp, \$ver, \$res, \$name) | Act: [kubectl] get -o yaml | Desc: Gets CR YAML"
    echo "Func: cr_get_spec (\$ns, \$grp, \$ver, \$res, \$name) | Act: [jsonpath] .spec | Desc: Gets CR spec"
    echo "Func: cr_get_status (\$ns, \$grp, \$ver, \$res, \$name) | Act: [jsonpath] .status | Desc: Gets CR status"
    echo "Func: cr_get_conditions (\$ns, \$grp, \$ver, \$res, \$name) | Act: [jsonpath] .status.conditions | Desc: Lists status conditions"
    echo "Func: cr_get_events (\$ns, \$name, \$kind) | Act: [kubectl] get events --field-selector | Desc: Gets events for specific CR"
    echo "Func: cr_count (\$ns, \$grp, \$ver, \$res) | Act: [wc] -l | Desc: Counts CRs in namespace"
    echo "Func: cr_diff (\$ns, \$grp, \$ver, \$res, \$name, \$ref_file) | Act: [diff] CR vs local file | Desc: Diffs CR against local file"
    echo "Func: cr_compare (\$ns, \$grp, \$ver, \$res, \$name_a, \$name_b) | Act: [diff] two CRs | Desc: Diffs two CR instances"
    echo "Func: cr_export (\$ns, \$grp, \$ver, \$res, \$file) | Act: [kubectl] get -o yaml > file | Desc: Saves CR list to YAML file"
    echo "Func: cr_upd_patch (\$ns, \$grp, \$ver, \$res, \$name, \$patch, [\$type]) | Act: [kubectl] patch CR | Desc: Patches custom resource"
    echo "Func: cr_upd_replace (\$ns, \$yaml) | Act: [kubectl] replace CR | Desc: Replaces custom resource"
    echo "Func: cr_upd_field (\$ns, \$grp, \$ver, \$res, \$name, \$pointer, \$value) | Act: [kubectl] patch JSON op | Desc: Updates specific field"
    echo "Func: cr_upd_clear_finalizers (\$ns, \$grp, \$ver, \$res, \$name) | Act: [kubectl] patch (remove finalizers) | Desc: Removes all finalizers"
    echo "Func: cr_upd_scrub_status (\$ns, \$grp, \$ver, \$res, \$name) | Act: [kubectl] patch (null status) | Desc: Nullifies status subresource"
    echo "Func: cr_del (\$ns, \$grp, \$ver, \$res, \$name, [\$grace]) | Act: [kubectl] delete custom-resource | Desc: Deletes custom resource"
    echo "Func: cr_del_force (\$ns, \$grp, \$ver, \$res, \$name) | Act: [kubectl] delete --force | Desc: Force deletes custom resource"
    echo "Func: cr_exists (\$ns, \$grp, \$ver, \$res, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if CR exists"
    echo "Func: cr_watch (\$ns, \$grp, \$ver, \$res, \$name, [\$timeout]) | Act: [kubectl] get --watch | Desc: Watches custom resource"
    echo "Func: cr_wait_cond (\$ns, \$grp, \$ver, \$res, \$name, \$path, \$exp, [\$timeout]) | Act: Poll [jsonpath] | Desc: Waits for field match"
    echo "Func: cr_valid (\$ns, \$grp, \$ver, \$res, \$name, \$crd) | Act: [kubectl] apply --dry-run | Desc: Server apply validation"
    echo "Func: cr_backup (\$ns, \$grp, \$ver, \$res, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups specific CR to YAML"
    echo "Func: cr_restore (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Restores CR from backup"
    
    # --- HELPER OPERATIONS ---
    echo "Func: api_resources ([\$group]) | Act: [kubectl] api-resources | Desc: Lists available API resources"
    echo "Func: api_versions () | Act: [kubectl] api-versions | Desc: Lists available API versions"
    echo "Func: build_gvr (\$grp, \$ver, \$res) | Act: Helper to build GVR string | Desc: Formats Group/Version/Resource string"
}

# =============================================================================
# 📜 CRD OPERATIONS (crd_*)
# =============================================================================

# ===== crd_add_f(file) =====
crd_add_f() { $K8S apply -f "$1"; }

# ===== crd_ls([args...]) =====
crd_ls() { $K8S get crd "$@"; }

# ===== crd_desc(name) =====
crd_desc() { $K8S describe crd "$1"; }

# ===== crd_get_info(name) =====
crd_get_info() { $K8S get crd "$1" -o custom-columns=NAME:.metadata.name,GROUP:.spec.group,VERSIONS:.spec.versions[*].name; }

# ===== crd_get_versions(name) =====
crd_get_versions() { $K8S get crd "$1" -o jsonpath='{range .spec.versions[*]}Version: {.name} (served={.served}, storage={.storage}){"\n"}{end}'; }

# ===== crd_get_schema(name) =====
crd_get_schema() { $K8S get crd "$1" -o jsonpath='{.spec.versions[?(@.storage==true)].schema.openAPIV3Schema}' | jq '.'; }

# ===== crd_get_shortnames(name) =====
crd_get_shortnames() { $K8S get crd "$1" -o jsonpath='{.spec.names.shortNames}'; }

# ===== crd_count() =====
crd_count() { $K8S get crd --no-headers | wc -l; }

# ===== crd_upd_patch(name, patch, [type]) =====
crd_upd_patch() { $K8S patch crd "$1" --type="${3:-merge}" -p "$2"; }

# ===== crd_upd_replace(name, yaml) =====
crd_upd_replace() { $K8S replace crd "$1" -f "$2"; }

# ===== crd_upd_preserve_unknown(name, mode) =====
crd_upd_preserve_unknown() { $K8S patch crd "$1" --type=merge -p "{\"spec\":{\"preserveUnknownFields\":$2}}"; }

# ===== crd_upd_conversion(name, strategy) =====
crd_upd_conversion() { $K8S patch crd "$1" --type=merge -p "{\"spec\":{\"conversion\":{\"strategy\":\"$2\"}}}"; }

# ===== crd_del(name, [cascade]) =====
crd_del() { $K8S delete crd "$1" ${2:+--cascade=$2}; }

# ===== crd_exists(name) =====
crd_exists() { $K8S get crd "$1" &>/dev/null; }

# ===== crd_wait_established(name, [timeout]) =====
crd_wait_established() {
    local t="${2:-60}"
    echo "Waiting up to ${t}s for crd/$1 Established..."
    timeout "$t" bash -c "until $K8S get crd $1 -o jsonpath='{.status.conditions[?(@.type==\"Established\")].status}' | grep -q 'True'; do sleep 2; done"
}

# =============================================================================
# 🧩 CUSTOM RESOURCE OPERATIONS (cr_*)
# =============================================================================

# ===== cr_add_f(ns, file) =====
cr_add_f() { $K8S apply -n "$1" -f "$2"; }

# ===== cr_gen_template(file, api, kind, ns, name) =====
cr_gen_template() {
    cat > "$1" <<EOF
apiVersion: $2
kind: $3
metadata: { name: "$5", namespace: "$4" }
spec: { # TODO: spec }
EOF
}

# ===== cr_clone(src_ns, target_ns, grp, ver, res, name, [new_name]) =====
cr_clone() {
    local sns="$1"; local tns="$2"; local g="$3"; local v="$4"; local r="$5"; local n="$6"; local nname="${7:-$n}"
    $K8S get "$r.$g/$v" "$n" -n "$sns" -o json | \
    jq "del(.metadata.uid, .metadata.resourceVersion, .metadata.creationTimestamp, .status) | .metadata.namespace = \"$tns\" | .metadata.name = \"$nname\"" | \
    $K8S apply -n "$tns" -f -
}

# ===== cr_migrate_ns(src_ns, target_ns, grp, ver, res, name) =====
cr_migrate_ns() {
    cr_clone "$1" "$2" "$3" "$4" "$5" "$6" && cr_del "$1" "$3" "$4" "$5" "$6"
}

# ===== cr_ls(ns, grp, ver, res, [args...]) =====
cr_ls() { $K8S get "$4.$2/$3" -n "$1" "${@:5}"; }

# ===== cr_ls_all(grp, ver, res, [args...]) =====
cr_ls_all() { $K8S get "$3.$1/$2" --all-namespaces "${@:4}"; }

# ===== cr_ls_label(ns, grp, ver, res, selector) =====
cr_ls_label() { $K8S get "$4.$2/$3" -n "$1" -l "$5" -o wide; }

# ===== cr_get(ns, grp, ver, res, name) =====
cr_get() { $K8S get "$4.$2/$3" "$5" -n "$1" -o yaml; }

# ===== cr_get_spec(ns, grp, ver, res, name) =====
cr_get_spec() { $K8S get "$4.$2/$3" "$5" -n "$1" -o jsonpath='{.spec}' | jq '.'; }

# ===== cr_get_status(ns, grp, ver, res, name) =====
cr_get_status() { $K8S get "$4.$2/$3" "$5" -n "$1" -o jsonpath='{.status}' | jq '.'; }

# ===== cr_get_conditions(ns, grp, ver, res, name) =====
cr_get_conditions() { $K8S get "$4.$2/$3" "$5" -n "$1" -o jsonpath='{range .status.conditions[*]}Type: {.type}, Status: {.status}{"\n"}{end}'; }

# ===== cr_get_events(ns, name, kind) =====
cr_get_events() { $K8S get events -n "$1" --field-selector "involvedObject.name=$2,involvedObject.kind=$3" --sort-by='.lastTimestamp'; }

# ===== cr_count(ns, grp, ver, res) =====
cr_count() { $K8S get "$4.$2/$3" -n "$1" --no-headers | wc -l; }

# ===== cr_diff(ns, grp, ver, res, name, ref_file) =====
cr_diff() { diff -u "$6" <($K8S get "$4.$2/$3" "$5" -n "$1" -o yaml); }

# ===== cr_compare(ns, grp, ver, res, name_a, name_b) =====
cr_compare() {
    diff -u <($K8S get "$4.$2/$3" "$5" -n "$1" -o yaml) <($K8S get "$4.$2/$3" "$6" -n "$1" -o yaml)
}

# ===== cr_export(ns, grp, ver, res, file) =====
cr_export() { $K8S get "$4.$2/$3" -n "$1" -o yaml > "$5"; }

# ===== cr_upd_patch(ns, grp, ver, res, name, patch, [type]) =====
cr_upd_patch() { $K8S patch "$4.$2/$3" "$5" -n "$1" --type="${7:-merge}" -p "$6"; }

# ===== cr_upd_replace(ns, yaml) =====
cr_upd_replace() { $K8S replace -n "$1" -f "$2"; }

# ===== cr_upd_field(ns, grp, ver, res, name, pointer, value) =====
cr_upd_field() { $K8S patch "$4.$2/$3" "$5" -n "$1" --type=json -p "[{\"op\":\"replace\",\"path\":\"$6\",\"value\":$7}]"; }

# ===== cr_upd_clear_finalizers(ns, grp, ver, res, name) =====
cr_upd_clear_finalizers() { $K8S patch "$4.$2/$3" "$5" -n "$1" --type=merge -p '{"metadata":{"finalizers":[]}}'; }

# ===== cr_upd_scrub_status(ns, grp, ver, res, name) =====
cr_upd_scrub_status() { $K8S patch "$4.$2/$3" "$5" -n "$1" --type=merge -p '{"status":null}' --subresource=status; }

# ===== cr_del(ns, grp, ver, res, name, [grace]) =====
cr_del() { $K8S delete "$4.$2/$3" "$5" -n "$1" ${6:+--grace-period=$6}; }

# ===== cr_del_force(ns, grp, ver, res, name) =====
cr_del_force() { $K8S delete "$4.$2/$3" "$5" -n "$1" --grace-period=0 --force; }

# ===== cr_exists(ns, grp, ver, res, name) =====
cr_exists() { $K8S get "$4.$2/$3" "$5" -n "$1" &>/dev/null; }

# ===== cr_watch(ns, grp, ver, res, name, [timeout]) =====
cr_watch() { $K8S get "$4.$2/$3" "$5" -n "$1" -w ${6:+--request-timeout=${6}s}; }

# ===== cr_wait_cond(ns, grp, ver, res, name, path, exp, [timeout]) =====
cr_wait_cond() {
    local t="${8:-120}"
    echo "Wait up to ${t}s for cr/$5 $6 == $7..."
    timeout "$t" bash -c "until $K8S get $4.$2/$3 $5 -n $1 -o jsonpath='$6' | grep -q '^$7$'; do sleep 3; done"
}

# ===== cr_valid(ns, grp, ver, res, name, crd) =====
cr_valid() { $K8S get "$4.$2/$3" "$5" -n "$1" -o yaml | $K8S apply --dry-run=server -n "$1" -f -; }

# ===== cr_backup(ns, grp, ver, res, name, file) =====
cr_backup() { $K8S get "$4.$2/$3" "$5" -n "$1" -o yaml > "$6"; }

# ===== cr_restore(ns, file) =====
cr_restore() { $K8S apply -n "$1" -f "$2"; }

# =============================================================================
# 🛠️ HELPER OPERATIONS
# =============================================================================

# ===== api_resources([group]) =====
api_resources() { $K8S api-resources ${1:+--api-group=$1}; }

# ===== api_versions() =====
api_versions() { $K8S api-versions; }

# ===== build_gvr(grp, ver, res) =====
build_gvr() { echo "$3.$1/$2"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
crds() { crd_ls "$@"; }
count_crds() { crd_count "$@"; }
get_crd_info() { crd_get_info "$@"; }
get_crd_versions() { crd_get_versions "$@"; }
get_crd_schema() { crd_get_schema "$@"; }
get_crd_shortnames() { crd_get_shortnames "$@"; }
get_crd_yaml() { $K8S get crd "$1" -o yaml; }
create_crd_from_file() { crd_add_f "$@"; }
create_crd_from_yaml() { crd_add_f "$@"; }
delete_crd() { crd_del "$@"; }
describe_crd() { crd_desc "$@"; }
patch_crd() { crd_upd_patch "$@"; }
replace_crd() { crd_upd_replace "$@"; }
wait_for_crd_established() { crd_wait_established "$@"; }
toggle_crd_preserve_unknown_fields() { crd_upd_preserve_unknown "$@"; }
set_crd_conversion_strategy() { crd_upd_conversion "$@"; }
custom_resources() { cr_ls "$@"; }
list_crs() { cr_ls "$@"; }
list_custom_resources_all_namespaces() { cr_ls_all "$@"; }
find_custom_resources_by_label() { cr_ls_label "$@"; }
get_custom_resource() { cr_get "$@"; }
get_cr_yaml() { cr_get "$@"; }
custom_resource_exists() { cr_exists "$@"; }
get_custom_resource_spec() { cr_get_spec "$@"; }
create_cr_from_file() { cr_add_f "$@"; }
apply_custom_resource_from_file() { cr_add_f "$@"; }
apply_custom_resource_from_yaml() { cr_add_f "$@"; }
delete_cr() { cr_del "$@"; }
delete_custom_resource() { cr_del "$@"; }
patch_cr() { cr_upd_patch "$@"; }
patch_custom_resource() { cr_upd_patch "$@"; }
replace_custom_resource() { cr_upd_replace "$@"; }
wait_for_custom_resource_condition() { cr_wait_cond "$@"; }
set_custom_resource_field() { cr_upd_field "$@"; }
remove_custom_resource_finalizers() { cr_upd_clear_finalizers "$@"; }
get_custom_resource_status() { cr_get_status "$@"; }
get_custom_resource_conditions() { cr_get_conditions "$@"; }
watch_crs() { cr_watch "$@"; }
watch_custom_resource() { cr_watch "$@"; }
get_custom_resource_events() { cr_get_events "$@"; }
diff_custom_resource() { cr_diff "$@"; }
export_custom_resources() { cr_export "$@"; }
backup_crs() { cr_export "$@"; }
backup_custom_resource() { cr_backup "$@"; }
restore_custom_resource_from_backup() { cr_restore "$@"; }
restore_crs() { cr_restore "$1" "$2"; }
clone_custom_resource() { cr_clone "$@"; }
compare_custom_resources() { cr_compare "$@"; }
get_cr_manifest_template() { cr_gen_template "$@"; }
validate_custom_resource_against_crd() { cr_valid "$@"; }
force_delete_custom_resource() { cr_del_force "$@"; }
scrub_custom_resource_status() { cr_upd_scrub_status "$@"; }
migrate_custom_resource_namespace() { cr_migrate_ns "$@"; }
get_api_resources() { api_resources "$@"; }
get_api_versions() { api_versions "$@"; }
