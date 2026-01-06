#!/bin/bash
help_cr(){
    add_log_help "=== help_cr ==="
    # --- CRD OPERATIONS (crd_*) ---
    add_log_help "Func: crd_add_f [crdaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies CRD YAML file"
    add_log_help "Func: crd_ls [crdls] ([\$args...]) | Act: [kubectl] get crd | Desc: Lists CRDs"
    add_log_help "Func: crd_desc [crddesc] (\$name) | Act: [kubectl] describe crd | Desc: Describes CRD"
    add_log_help "Func: crd_get_info [crdinfo] (\$name) | Act: [kubectl] get crd -o wide | Desc: Gets wide CRD info"
    add_log_help "Func: crd_get_versions [crdvers] (\$name) | Act: [jsonpath] .spec.versions | Desc: Lists served/storage versions"
    add_log_help "Func: crd_get_schema [crdschema] (\$name) | Act: [jq] filter openAPIV3Schema | Desc: Gets CRD schema"
    add_log_help "Func: crd_get_shortnames [crdshortnames] (\$name) | Act: [jsonpath] .spec.names.shortNames | Desc: Lists shortNames"
    add_log_help "Func: crd_count [crdcount] () | Act: [wc] -l | Desc: Counts total CRDs"
    add_log_help "Func: crd_upd_patch [crdpatch] (\$name, \$patch, [\$type]) | Act: [kubectl] patch crd | Desc: Patches CRD definition"
    add_log_help "Func: crd_upd_replace [crdreplace] (\$name, \$yaml) | Act: [kubectl] replace crd | Desc: Replaces CRD definition"
    add_log_help "Func: crd_upd_preserve_unknown [crdunknown] (\$name, \$mode) | Act: [kubectl] patch preserveUnknownFields | Desc: Updates field preservation mode"
    add_log_help "Func: crd_upd_conversion [crdconversion] (\$name, \$strategy) | Act: [kubectl] patch conversion | Desc: Updates conversion strategy"
    add_log_help "Func: crd_del [crddel] (\$name, [\$cascade]) | Act: [kubectl] delete crd | Desc: Deletes CRD"
    add_log_help "Func: crd_exists [crdexists] (\$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if CRD exists"
    add_log_help "Func: crd_wait_established [crdwait] (\$name, [\$timeout]) | Act: [kubectl] wait --for=condition=Established | Desc: Waits for CRD to be ready"
    
    # --- CUSTOM RESOURCE OPERATIONS (cr_*) ---
    add_log_help "Func: cr_add_f [craddf] (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Applies Custom Resource from file"
    add_log_help "Func: cr_gen_template [crgentemplate] (\$file, \$api, \$kind, \$ns, \$name) | Act: [cat] > file | Desc: Generates Custom Resource template"
    add_log_help "Func: cr_clone [crclone] (\$src_ns, \$target_ns, \$grp, \$ver, \$res, \$name, [\$new_name]) | Act: [jq] and [kubectl] apply | Desc: Clones Custom Resource"
    add_log_help "Func: cr_migrate_ns [crmigrate] (\$src_ns, \$target_ns, \$grp, \$ver, \$res, \$name) | Act: [sed] and [kubectl] apply | Desc: Moves CR between namespaces"
    add_log_help "Func: cr_ls [crls] (\$ns, \$grp, \$ver, \$res, [\$args...]) | Act: [kubectl] get custom-resource | Desc: Lists custom resources"
    add_log_help "Func: cr_ls_all [crlsall] (\$grp, \$ver, \$res, [\$args...]) | Act: [kubectl] get custom-resource --all-namespaces | Desc: Lists CRs in all namespaces"
    add_log_help "Func: cr_ls_label [crlslabel] (\$ns, \$grp, \$ver, \$res, \$selector) | Act: [kubectl] get -l | Desc: Lists CRs filtered by label"
    add_log_help "Func: cr_get [crget] (\$ns, \$grp, \$ver, \$res, \$name) | Act: [kubectl] get -o yaml | Desc: Gets CR YAML"
    add_log_help "Func: cr_get_spec [crspec] (\$ns, \$grp, \$ver, \$res, \$name) | Act: [jsonpath] .spec | Desc: Gets CR spec"
    add_log_help "Func: cr_get_status [crstatus] (\$ns, \$grp, \$ver, \$res, \$name) | Act: [jsonpath] .status | Desc: Gets CR status"
    add_log_help "Func: cr_get_conditions [crconditions] (\$ns, \$grp, \$ver, \$res, \$name) | Act: [jsonpath] .status.conditions | Desc: Lists status conditions"
    add_log_help "Func: cr_get_events [crevents] (\$ns, \$name, \$kind) | Act: [kubectl] get events --field-selector | Desc: Gets events for specific CR"
    add_log_help "Func: cr_count [crcount] (\$ns, \$grp, \$ver, \$res) | Act: [wc] -l | Desc: Counts CRs in namespace"
    add_log_help "Func: cr_diff [crdiff] (\$ns, \$grp, \$ver, \$res, \$name, \$ref_file) | Act: [diff] CR vs local file | Desc: Diffs CR against local file"
    add_log_help "Func: cr_compare [crcompare] (\$ns, \$grp, \$ver, \$res, \$name_a, \$name_b) | Act: [diff] two CRs | Desc: Diffs two CRs"
    add_log_help "Func: cr_export [crexport] (\$ns, \$grp, \$ver, \$res, \$file) | Act: [kubectl] get -o yaml > file | Desc: Saves CR list to YAML file"
    add_log_help "Func: cr_upd_patch [crpatch] (\$ns, \$grp, \$ver, \$res, \$name, \$patch, [\$type]) | Act: [kubectl] patch CR | Desc: Patches custom resource"
    add_log_help "Func: cr_upd_replace [crreplace] (\$ns, \$yaml) | Act: [kubectl] replace CR | Desc: Replaces custom resource"
    add_log_help "Func: cr_upd_field [crfield] (\$ns, \$grp, \$ver, \$res, \$name, \$pointer, \$value) | Act: [kubectl] patch JSON op | Desc: Updates specific field"
    add_log_help "Func: cr_upd_clear_finalizers [crcleanfinalizers] (\$ns, \$grp, \$ver, \$res, \$name) | Act: [kubectl] patch (remove finalizers) | Desc: Removes all finalizers"
    add_log_help "Func: cr_upd_scrub_status [crscrub] (\$ns, \$grp, \$ver, \$res, \$name) | Act: [kubectl] patch (null status) | Desc: Nullifies status subresource"
    add_log_help "Func: cr_del [crdel] (\$ns, \$grp, \$ver, \$res, \$name, [\$grace]) | Act: [kubectl] delete custom-resource | Desc: Deletes custom resource"
    add_log_help "Func: cr_del_force [crdelforce] (\$ns, \$grp, \$ver, \$res, \$name) | Act: [kubectl] delete --force | Desc: Force deletes custom resource"
    add_log_help "Func: cr_exists [crexists] (\$ns, \$grp, \$ver, \$res, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if CR exists"
    add_log_help "Func: cr_watch [crwatch] (\$ns, \$grp, \$ver, \$res, \$name, [\$timeout]) | Act: [kubectl] get --watch | Desc: Watches custom resource"
    add_log_help "Func: cr_wait_cond [crwait] (\$ns, \$grp, \$ver, \$res, \$name, \$path, \$exp, [\$timeout]) | Act: Poll [jsonpath] | Desc: Waits for field match"
    add_log_help "Func: cr_valid [crvalid] (\$ns, \$grp, \$ver, \$res, \$name, \$crd) | Act: [kubectl] apply --dry-run | Desc: Server apply validation"
    add_log_help "Func: cr_backup [crbak] (\$ns, \$grp, \$ver, \$res, \$name, \$file) | Act: [kubectl] get -o yaml > file | Desc: Backups specific CR to YAML"
    add_log_help "Func: cr_restore [crrestore] (\$ns, \$file) | Act: [kubectl] apply -f | Desc: Restores CR from backup"
    
    # --- HELPER OPERATIONS ---
    add_log_help "Func: api_resources [apiresources] ([\$group]) | Act: [kubectl] api-resources | Desc: Lists available API resources"
    add_log_help "Func: api_versions [apiversions] () | Act: [kubectl] api-versions | Desc: Lists available API versions"
    add_log_help "Func: build_gvr [buildgvr] (\$grp, \$ver, \$res) | Act: Helper to build GVR string | Desc: Formats Group/Version/Resource string"
}
# === CRD OPERATIONS (crd_*) ===
crd_add_f() { 
    add_log "=== Func: crd_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
crdaddf() { crd_add_f "$@"; }
crd_ls() { 
    add_log "=== Func: crd_ls ==="
    $K8S get crd "$@" | add_log; 
}
crdls() { crd_ls "$@"; }
crd_desc() { 
    add_log "=== Func: crd_desc ==="
    $K8S describe crd "$1" | add_log; 
}
crddesc() { crd_desc "$@"; }
crd_get_info() { 
    add_log "=== Func: crd_get_info ==="
    $K8S get crd "$1" -o custom-columns=NAME:.metadata.name,GROUP:.spec.group,VERSIONS:.spec.versions[*].name | add_log; 
}
crdinfo() { crd_get_info "$@"; }
crd_get_versions() { 
    add_log "=== Func: crd_get_versions ==="
    $K8S get crd "$1" -o jsonpath='{range .spec.versions[*]}Version: {.name} (served={.served}, storage={.storage}){"\n"}{end}' | add_log; 
}
crdvers() { crd_get_versions "$@"; }
crd_get_schema() { 
    add_log "=== Func: crd_get_schema ==="
    $K8S get crd "$1" -o jsonpath='{.spec.versions[?(@.storage==true)].schema.openAPIV3Schema}' | jq '.' | add_log; 
}
crdschema() { crd_get_schema "$@"; }
crd_get_shortnames() { 
    add_log "=== Func: crd_get_shortnames ==="
    $K8S get crd "$1" -o jsonpath='{.spec.names.shortNames}' | add_log; 
}
crdshortnames() { crd_get_shortnames "$@"; }
crd_count() { 
    add_log "=== Func: crd_count ==="
    $K8S get crd --no-headers | wc -l | add_log; 
}
crdcount() { crd_count "$@"; }
crd_upd_patch() { 
    add_log "=== Func: crd_upd_patch ==="
    $K8S patch crd "$1" --type="${3:-merge}" -p "$2" | add_log; 
}
crdpatch() { crd_upd_patch "$@"; }
crd_upd_replace() { 
    add_log "=== Func: crd_upd_replace ==="
    $K8S replace crd "$1" -f "$2" | add_log; 
}
crdreplace() { crd_upd_replace "$@"; }
crd_upd_preserve_unknown() { 
    add_log "=== Func: crd_upd_preserve_unknown ==="
    $K8S patch crd "$1" --type=merge -p "{\"spec\":{\"preserveUnknownFields\":$2}}" | add_log; 
}
crdunknown() { crd_upd_preserve_unknown "$@"; }
crd_upd_conversion() { 
    add_log "=== Func: crd_upd_conversion ==="
    $K8S patch crd "$1" --type=merge -p "{\"spec\":{\"conversion\":{\"strategy\":\"$2\"}}}" | add_log; 
}
crdconversion() { crd_upd_conversion "$@"; }
crd_del() { 
    add_log "=== Func: crd_del ==="
    $K8S delete crd "$1" ${2:+--cascade=$2} | add_log; 
}
crddel() { crd_del "$@"; }
crd_exists() { 
    add_log "=== Func: crd_exists ==="
    if $K8S get crd "$1" &>/dev/null; then add_log "CRD $1 exists"; return 0; else add_log "CRD $1 does NOT exist"; return 1; fi
}
crdexists() { crd_exists "$@"; }
crd_wait_established() {
    add_log "=== Func: crd_wait_established ==="
    local t="${2:-60}"
    add_log "Waiting up to ${t}s for crd/$1 Established..."
    timeout "$t" bash -c "until $K8S get crd $1 -o jsonpath='{.status.conditions[?(@.type==\"Established\")].status}' | grep -q 'True'; do sleep 2; done" | add_log
}
crdwait() { crd_wait_established "$@"; }
# === CUSTOM RESOURCE OPERATIONS (cr_*) ===
cr_add_f() { 
    add_log "=== Func: cr_add_f ==="
    $K8S apply -n "$1" -f "$2" | add_log; 
}
craddf() { cr_add_f "$@"; }
cr_gen_template() {
    add_log "=== Func: cr_gen_template ==="
    cat > "$1" <<EOF
apiVersion: $2
kind: $3
metadata: { name: "$5", namespace: "$4" }
spec: { # TODO: spec }
EOF
    add_log "Template saved to $1"
}
crgentemplate() { cr_gen_template "$@"; }
cr_clone() {
    add_log "=== Func: cr_clone ==="
    local sns="$1"; local tns="$2"; local g="$3"; local v="$4"; local r="$5"; local n="$6"; local nname="${7:-$n}"
    $K8S get "$r.$g/$v" "$n" -n "$sns" -o json | jq "del(.metadata.uid, .metadata.resourceVersion, .metadata.creationTimestamp, .status) | .metadata.namespace = \"$tns\" | .metadata.name = \"$nname\"" | $K8S apply -n "$tns" -f - | add_log
}
crclone() { cr_clone "$@"; }
cr_migrate_ns() {
    add_log "=== Func: cr_migrate_ns ==="
    cr_clone "$1" "$2" "$3" "$4" "$5" "$6" && cr_del "$1" "$3" "$4" "$5" "$6"
}
crmigrate() { cr_migrate_ns "$@"; }
cr_ls() { 
    add_log "=== Func: cr_ls ==="
    $K8S get "$4.$2/$3" -n "$1" "${@:5}" | add_log; 
}
crls() { cr_ls "$@"; }
cr_ls_all() { 
    add_log "=== Func: cr_ls_all ==="
    $K8S get "$3.$1/$2" --all-namespaces "${@:4}" | add_log; 
}
crlsall() { cr_ls_all "$@"; }
cr_ls_label() { 
    add_log "=== Func: cr_ls_label ==="
    $K8S get "$4.$2/$3" -n "$1" -l "$5" -o wide | add_log; 
}
crlslabel() { cr_ls_label "$@"; }
cr_get() { 
    add_log "=== Func: cr_get ==="
    $K8S get "$4.$2/$3" "$5" -n "$1" -o yaml | add_log; 
}
crget() { cr_get "$@"; }
cr_get_spec() { 
    add_log "=== Func: cr_get_spec ==="
    $K8S get "$4.$2/$3" "$5" -n "$1" -o jsonpath='{.spec}' | jq '.' | add_log; 
}
crspec() { cr_get_spec "$@"; }
cr_get_status() { 
    add_log "=== Func: cr_get_status ==="
    $K8S get "$4.$2/$3" "$5" -n "$1" -o jsonpath='{.status}' | jq '.' | add_log; 
}
crstatus() { cr_get_status "$@"; }
cr_get_conditions() { 
    add_log "=== Func: cr_get_conditions ==="
    $K8S get "$4.$2/$3" "$5" -n "$1" -o jsonpath='{range .status.conditions[*]}Type: {.type}, Status: {.status}{"\n"}{end}' | add_log; 
}
crconditions() { cr_get_conditions "$@"; }
cr_get_events() { 
    add_log "=== Func: cr_get_events ==="
    $K8S get events -n "$1" --field-selector "involvedObject.name=$2,involvedObject.kind=$3" --sort-by='.lastTimestamp' | add_log; 
}
crevents() { cr_get_events "$@"; }
cr_count() { 
    add_log "=== Func: cr_count ==="
    $K8S get "$4.$2/$3" -n "$1" --no-headers | wc -l | add_log; 
}
crcount() { cr_count "$@"; }
cr_diff() { 
    add_log "=== Func: cr_diff ==="
    diff -u "$6" <($K8S get "$4.$2/$3" "$5" -n "$1" -o yaml) | add_log; 
}
crdiff() { cr_diff "$@"; }
cr_compare() {
    add_log "=== Func: cr_compare ==="
    diff -u <($K8S get "$4.$2/$3" "$5" -n "$1" -o yaml) <($K8S get "$4.$2/$3" "$6" -n "$1" -o yaml) | add_log
}
crcompare() { cr_compare "$@"; }
cr_export() { 
    add_log "=== Func: cr_export ==="
    $K8S get "$4.$2/$3" -n "$1" -o yaml > "$5" && add_log "Export saved to $5"; 
}
crexport() { cr_export "$@"; }
cr_upd_patch() { 
    add_log "=== Func: cr_upd_patch ==="
    $K8S patch "$4.$2/$3" "$5" -n "$1" --type="${7:-merge}" -p "$6" | add_log; 
}
crpatch() { cr_upd_patch "$@"; }
cr_upd_replace() { 
    add_log "=== Func: cr_upd_replace ==="
    $K8S replace -n "$1" -f "$2" | add_log; 
}
crreplace() { cr_upd_replace "$@"; }
cr_upd_field() { 
    add_log "=== Func: cr_upd_field ==="
    $K8S patch "$4.$2/$3" "$5" -n "$1" --type=json -p "[{\"op\":\"replace\",\"path\":\"$6\",\"value\":$7}]" | add_log; 
}
crfield() { cr_upd_field "$@"; }
cr_upd_clear_finalizers() { 
    add_log "=== Func: cr_upd_clear_finalizers ==="
    $K8S patch "$4.$2/$3" "$5" -n "$1" --type=merge -p '{"metadata":{"finalizers":[]}}' | add_log; 
}
crcleanfinalizers() { cr_upd_clear_finalizers "$@"; }
cr_upd_scrub_status() { 
    add_log "=== Func: cr_upd_scrub_status ==="
    $K8S patch "$4.$2/$3" "$5" -n "$1" --type=merge -p '{"status":null}' --subresource=status | add_log; 
}
crscrub() { cr_upd_scrub_status "$@"; }
cr_del() { 
    add_log "=== Func: cr_del ==="
    $K8S delete "$4.$2/$3" "$5" -n "$1" ${6:+--grace-period=$6} | add_log; 
}
crdel() { cr_del "$@"; }
cr_del_force() { 
    add_log "=== Func: cr_del_force ==="
    $K8S delete "$4.$2/$3" "$5" -n "$1" --grace-period=0 --force | add_log; 
}
crdelforce() { cr_del_force "$@"; }
cr_exists() { 
    add_log "=== Func: cr_exists ==="
    if $K8S get "$4.$2/$3" "$5" -n "$1" &>/dev/null; then add_log "Custom Resource $5 exists in namespace $1"; return 0; else add_log "Custom Resource $5 does NOT exist in namespace $1"; return 1; fi
}
crexists() { cr_exists "$@"; }
cr_watch() { 
    add_log "=== Func: cr_watch ==="
    $K8S get "$4.$2/$3" "$5" -n "$1" -w ${6:+--request-timeout=${6}s} | add_log; 
}
crwatch() { cr_watch "$@"; }
cr_wait_cond() {
    add_log "=== Func: cr_wait_cond ==="
    local t="${8:-120}"
    add_log "Wait up to ${t}s for cr/$5 $6 == $7..."
    timeout "$t" bash -c "until $K8S get $4.$2/$3 $5 -n $1 -o jsonpath='$6' | grep -q '^$7$'; do sleep 3; done" | add_log
}
crwait() { cr_wait_cond "$@"; }
cr_valid() { 
    add_log "=== Func: cr_valid ==="
    $K8S get "$4.$2/$3" "$5" -n "$1" -o yaml | $K8S apply --dry-run=server -n "$1" -f - | add_log; 
}
crvalid() { cr_valid "$@"; }
cr_backup() { 
    add_log "=== Func: cr_backup ==="
    $K8S get "$4.$2/$3" "$5" -n "$1" -o yaml > "$6" && add_log "Backup saved to $6"; 
}
crbak() { cr_backup "$@"; }
cr_restore() { 
    add_log "=== Func: cr_restore ==="
    $K8S apply -n "$1" -f "$2" | add_log; 
}
crrestore() { cr_restore "$@"; }
# === HELPER OPERATIONS ===
api_resources() { 
    add_log "=== Func: api_resources ==="
    $K8S api-resources ${1:+--api-group=$1} | add_log; 
}
apiresources() { api_resources "$@"; }
api_versions() { 
    add_log "=== Func: api_versions ==="
    $K8S api-versions | add_log; 
}
apiversions() { api_versions "$@"; }
build_gvr() { 
    add_log "=== Func: build_gvr ==="
    echo "$3.$1/$2" | add_log; 
}
buildgvr() { build_gvr "$@"; }
