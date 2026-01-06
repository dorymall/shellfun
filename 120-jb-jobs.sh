#!/bin/bash
help_jb(){
    add_log_help "=== help_jb ==="
    # --- JOB OPERATIONS (jb_*) ---
    add_log_help "Func: jb_add_f [jbaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies Job YAML file"
    add_log_help "Func: jb_add_basic [jbadd] (\$ns, \$name, \$image, \$cmd) | Act: [kubectl] create job | Desc: Creates basic Job"
    add_log_help "Func: jb_clone [jbclone] (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones Job"
    add_log_help "Func: jb_ls [jbls] (\$ns, [\$args...]) | Act: [kubectl] get jobs | Desc: Lists Jobs"
    add_log_help "Func: jb_ls_all [jblsall] ([\$args...]) | Act: [kubectl] get jobs --all-namespaces | Desc: Lists Jobs in all namespaces"
    add_log_help "Func: jb_ls_pods [jbpods] (\$ns, \$name) | Act: [kubectl] get pods -l | Desc: Lists pods manage by Job"
    add_log_help "Func: jb_get_info [jbinfo] (\$ns, \$name) | Act: [kubectl] get job -o wide | Desc: Gets wide Job info"
    add_log_help "Func: jb_get_status [jbstatus] (\$ns, \$name) | Act: [jsonpath] .status | Desc: Gets Job status"
    add_log_help "Func: jb_get_logs [jblogs] (\$ns, \$name) | Act: [kubectl] logs | Desc: Gets logs from Job pod"
    add_log_help "Func: jb_get_duration [jbduration] (\$ns, \$name) | Act: [jsonpath] .status.completionTime | Desc: Gets Job duration/completion time"
    add_log_help "Func: jb_get_events [jbevents] (\$ns, \$name) | Act: [kubectl] get events | Desc: Gets events for Job"
    add_log_help "Func: jb_desc [jbdesc] (\$ns, \$name) | Act: [kubectl] describe job | Desc: Describes Job"
    add_log_help "Func: jb_get [jbget] (\$ns, \$name) | Act: [kubectl] get job -o yaml | Desc: Gets Job YAML"
    add_log_help "Func: jb_upd_parallelism [jbupdparallelism] (\$ns, \$name, \$parallelism) | Act: [kubectl] patch job | Desc: Updates Job parallelism"
    add_log_help "Func: jb_upd_label [jblabel] (\$ns, \$name, \$key, \$val) | Act: [kubectl] label job | Desc: Adds/updates Job label"
    add_log_help "Func: jb_upd_unlabel [jbunlabel] (\$ns, \$name, \$key) | Act: [kubectl] label job (remove) | Desc: Removes label"
    add_log_help "Func: jb_upd_annotate [jbannotate] (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate job | Desc: Adds/updates annotation"
    add_log_help "Func: jb_del [jbdel] (\$ns, \$name) | Act: [kubectl] delete job | Desc: Deletes Job"
    add_log_help "Func: jb_del_done [jbdeldone] (\$ns) | Act: [kubectl] delete jobs --field-selector | Desc: Deletes successful jobs"
    add_log_help "Func: jb_del_failed [jbdelerr] (\$ns) | Act: [kubectl] delete jobs --field-selector | Desc: Deletes failed jobs"
    add_log_help "Func: jb_exists [jbexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if Job exists"
    add_log_help "Func: jb_watch [jbwatch] (\$ns, [\$name]) | Act: [kubectl] get job --watch | Desc: Watches Jobs"
    add_log_help "Func: jb_valid [jbvalid] (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if Job YAML is valid"
    add_log_help "Func: jb_backup [jbbak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups Job to YAML file"
    add_log_help "Func: jb_restore [jbrestore] (\$file) | Act: [kubectl] apply -f | Desc: Restores Job/CronJob from file"
    
    # --- CRONJOB OPERATIONS (cj_*) ---
    add_log_help "Func: cj_add_f [cjaddf] (\$file) | Act: [kubectl] apply -f | Desc: Applies CronJob YAML file"
    add_log_help "Func: cj_add_basic [cjadd] (\$ns, \$name, \$schedule, \$image, \$cmd) | Act: [kubectl] create cronjob | Desc: Creates basic CronJob"
    add_log_help "Func: cj_ls [cjls] (\$ns, [\$args...]) | Act: [kubectl] get cronjobs | Desc: Lists CronJobs"
    add_log_help "Func: cj_ls_all [cjlsall] ([\$args...]) | Act: [kubectl] get cronjobs --all-namespaces | Desc: Lists CronJobs in all namespaces"
    add_log_help "Func: cj_ls_jobs [cjjobs] (\$ns, \$name) | Act: [jq] filter by ownerReference | Desc: Lists jobs triggered by CronJob"
    add_log_help "Func: cj_get_schedule [cjsched] (\$ns, \$name) | Act: [jsonpath] .spec.schedule | Desc: Gets Cron schedule"
    add_log_help "Func: cj_get_last_run [cjlastrun] (\$ns, \$name) | Act: [jsonpath] .status.lastScheduleTime | Desc: Gets last schedule time"
    add_log_help "Func: cj_desc [cjdesc] (\$ns, \$name) | Act: [kubectl] describe cj | Desc: Describes CronJob"
    add_log_help "Func: cj_get [cjget] (\$ns, \$name) | Act: [kubectl] get cj -o yaml | Desc: Gets CronJob YAML"
    add_log_help "Func: cj_upd_schedule [cjuschedule] (\$ns, \$name, \$schedule) | Act: [kubectl] patch cj | Desc: Updates CronJob schedule"
    add_log_help "Func: cj_upd_suspend [cjsuspend] (\$ns, \$name) | Act: [kubectl] patch cj suspend=true | Desc: Suspends CronJob"
    add_log_help "Func: cj_upd_resume [cjresume] (\$ns, \$name) | Act: [kubectl] patch cj suspend=false | Desc: Resumes CronJob"
    add_log_help "Func: cj_run [cjrun] (\$ns, \$name) | Act: [kubectl] create job --from | Desc: Manually triggers CronJob"
    add_log_help "Func: cj_del [cjdel] (\$ns, \$name) | Act: [kubectl] delete cj | Desc: Deletes CronJob"
    add_log_help "Func: cj_exists [cjexists] (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if CronJob exists"
    add_log_help "Func: cj_watch [cjwatch] (\$ns, [\$name]) | Act: [kubectl] get cj --watch | Desc: Watches CronJobs"
    add_log_help "Func: cj_backup [cjbak] (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups CronJob to YAML file"
}
# === JOB OPERATIONS (jb_*) ===
jb_add_f() { 
    add_log "=== Func: jb_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
jbaddf() { jb_add_f "$@"; }
jb_add_basic() { 
    add_log "=== Func: jb_add_basic ==="
    $K8S create job "$2" --image="$3" -n "$1" -- "$4" | add_log; 
}
jbadd() { jb_add_basic "$@"; }
jb_clone() {
    add_log "=== Func: jb_clone ==="
    local tn="${4:-$2}"
    $K8S get job "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f - | add_log
}
jbclone() { jb_clone "$@"; }
jb_ls() { 
    add_log "=== Func: jb_ls ==="
    $K8S get jobs -n "$1" "${@:2}" | add_log; 
}
jbls() { jb_ls "$@"; }
jb_ls_all() { 
    add_log "=== Func: jb_ls_all ==="
    $K8S get jobs --all-namespaces "$@" | add_log; 
}
jblsall() { jb_ls_all "$@"; }
jb_ls_pods() { 
    add_log "=== Func: jb_ls_pods ==="
    $K8S get pods -n "$1" -l job-name="$2" | add_log; 
}
jbpods() { jb_ls_pods "$@"; }
jb_get_info() { 
    add_log "=== Func: jb_get_info ==="
    $K8S get job "$2" -n "$1" -o wide | add_log; 
}
jbinfo() { jb_get_info "$@"; }
jb_get_status() { 
    add_log "=== Func: jb_get_status ==="
    $K8S get job "$2" -n "$1" -o jsonpath='{.status}' | add_log; 
}
jbstatus() { jb_get_status "$@"; }
jb_get_logs() {
    add_log "=== Func: jb_get_logs ==="
    local p=$(jb_ls_pods "$1" "$2" -o name | head -1)
    if [ -n "$p" ]; then $K8S logs "$p" -n "$1" | add_log; else add_log "No pod found for job $2"; fi
}
jblogs() { jb_get_logs "$@"; }
jb_get_duration() { 
    add_log "=== Func: jb_get_duration ==="
    $K8S get job "$2" -n "$1" -o jsonpath='{.status.completionTime}' | add_log; 
}
jbduration() { jb_get_duration "$@"; }
jb_get_events() { 
    add_log "=== Func: jb_get_events ==="
    $K8S get events -n "$1" --field-selector involvedObject.name="$2" | add_log; 
}
jbevents() { jb_get_events "$@"; }
jb_desc() { 
    add_log "=== Func: jb_desc ==="
    $K8S describe job "$2" -n "$1" | add_log; 
}
jbdesc() { jb_desc "$@"; }
jb_get() { 
    add_log "=== Func: jb_get ==="
    $K8S get job "$2" -n "$1" -o yaml | add_log; 
}
jbget() { jb_get "$@"; }
jb_upd_parallelism() { 
    add_log "=== Func: jb_upd_parallelism ==="
    $K8S patch job "$2" -n "$1" -p "{\"spec\":{\"parallelism\":$3}}" | add_log; 
}
jbupdparallelism() { jb_upd_parallelism "$@"; }
jb_upd_label() { 
    add_log "=== Func: jb_upd_label ==="
    $K8S label job "$2" "$3"="$4" -n "$1" | add_log; 
}
jblabel() { jb_upd_label "$@"; }
jb_upd_unlabel() { 
    add_log "=== Func: jb_upd_unlabel ==="
    $K8S label job "$2" "$3-" -n "$1" | add_log; 
}
jbunlabel() { jb_upd_unlabel "$@"; }
jb_upd_annotate() { 
    add_log "=== Func: jb_upd_annotate ==="
    $K8S annotate job "$2" "$3"="$4" -n "$1" | add_log; 
}
jbannotate() { jb_upd_annotate "$@"; }
jb_del() { 
    add_log "=== Func: jb_del ==="
    $K8S delete job "$2" -n "$1" | add_log; 
}
jbdel() { jb_del "$@"; }
jb_del_done() { 
    add_log "=== Func: jb_del_done ==="
    $K8S delete job -n "$1" --field-selector status.successful=1 | add_log; 
}
jbdeldone() { jb_del_done "$@"; }
jb_del_failed() { 
    add_log "=== Func: jb_del_failed ==="
    $K8S delete job -n "$1" --field-selector status.failed=1 | add_log; 
}
jbdelerr() { jb_del_failed "$@"; }
jb_exists() { 
    add_log "=== Func: jb_exists ==="
    if $K8S get job "$2" -n "$1" &>/dev/null; then add_log "Job $2 exists in namespace $1"; return 0; else add_log "Job $2 does NOT exist in namespace $1"; return 1; fi
}
jbexists() { jb_exists "$@"; }
jb_watch() { 
    add_log "=== Func: jb_watch ==="
    if [ -n "$2" ]; then $K8S get job "$2" -n "$1" --watch | add_log; else $K8S get job -n "$1" --watch | add_log; fi
}
jbwatch() { jb_watch "$@"; }
jb_valid() { 
    add_log "=== Func: jb_valid ==="
    $K8S get job "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f - | add_log; 
}
jbvalid() { jb_valid "$@"; }
jb_backup() { 
    add_log "=== Func: jb_backup ==="
    $K8S get job "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
jbbak() { jb_backup "$@"; }
jb_restore() { 
    add_log "=== Func: jb_restore ==="
    $K8S apply -f "$1" | add_log; 
}
jbrestore() { jb_restore "$@"; }
# === CRONJOB OPERATIONS (cj_*) ===
cj_add_f() { 
    add_log "=== Func: cj_add_f ==="
    $K8S apply -f "$1" | add_log; 
}
cjaddf() { cj_add_f "$@"; }
cj_add_basic() { 
    add_log "=== Func: cj_add_basic ==="
    $K8S create cronjob "$2" --schedule="$3" --image="$4" -n "$1" -- "$5" | add_log; 
}
cjadd() { cj_add_basic "$@"; }
cj_ls() { 
    add_log "=== Func: cj_ls ==="
    $K8S get cronjobs -n "$1" "${@:2}" | add_log; 
}
cjls() { cj_ls "$@"; }
cj_ls_all() { 
    add_log "=== Func: cj_ls_all ==="
    $K8S get cronjobs --all-namespaces "$@" | add_log; 
}
cjlsall() { cj_ls_all "$@"; }
cj_ls_jobs() { 
    add_log "=== Func: cj_ls_jobs ==="
    $K8S get jobs -n "$1" --field-selector metadata.ownerReferences[0].name="$2" | add_log; 
}
cjjobs() { cj_ls_jobs "$@"; }
cj_get_schedule() { 
    add_log "=== Func: cj_get_schedule ==="
    $K8S get cj "$2" -n "$1" -o jsonpath='{.spec.schedule}' | add_log; 
}
cjsched() { cj_get_schedule "$@"; }
cj_get_last_run() { 
    add_log "=== Func: cj_get_last_run ==="
    $K8S get cj "$2" -n "$1" -o jsonpath='{.status.lastScheduleTime}' | add_log; 
}
cjlastrun() { cj_get_last_run "$@"; }
cj_desc() { 
    add_log "=== Func: cj_desc ==="
    $K8S describe cj "$2" -n "$1" | add_log; 
}
cjdesc() { cj_desc "$@"; }
cj_get() { 
    add_log "=== Func: cj_get ==="
    $K8S get cj "$2" -n "$1" -o yaml | add_log; 
}
cjget() { cj_get "$@"; }
cj_upd_schedule() { 
    add_log "=== Func: cj_upd_schedule ==="
    $K8S patch cj "$2" -n "$1" -p "{\"spec\":{\"schedule\":\"$3\"}}" | add_log; 
}
cjuschedule() { cj_upd_schedule "$@"; }
cj_upd_suspend() { 
    add_log "=== Func: cj_upd_suspend ==="
    $K8S patch cj "$2" -n "$1" -p "{\"spec\":{\"suspend\":true}}" | add_log; 
}
cjsuspend() { cj_upd_suspend "$@"; }
cj_upd_resume() { 
    add_log "=== Func: cj_upd_resume ==="
    $K8S patch cj "$2" -n "$1" -p "{\"spec\":{\"suspend\":false}}" | add_log; 
}
cjresume() { cj_upd_resume "$@"; }
cj_run() { 
    add_log "=== Func: cj_run ==="
    $K8S create job --from=cronjob/"$2" "${2}-manual-$(date +%s)" -n "$1" | add_log; 
}
cjrun() { cj_run "$@"; }
cj_del() { 
    add_log "=== Func: cj_del ==="
    $K8S delete cj "$2" -n "$1" | add_log; 
}
cjdel() { cj_del "$@"; }
cj_exists() { 
    add_log "=== Func: cj_exists ==="
    if $K8S get cj "$2" -n "$1" &>/dev/null; then add_log "CronJob $2 exists in namespace $1"; return 0; else add_log "CronJob $2 does NOT exist in namespace $1"; return 1; fi
}
cjexists() { cj_exists "$@"; }
cj_watch() { 
    add_log "=== Func: cj_watch ==="
    if [ -n "$2" ]; then $K8S get cj "$2" -n "$1" --watch | add_log; else $K8S get cj -n "$1" --watch | add_log; fi
}
cjwatch() { cj_watch "$@"; }
cj_backup() { 
    add_log "=== Func: cj_backup ==="
    $K8S get cj "$2" -n "$1" -o yaml > "${3:-$2.yaml}" && add_log "Backup saved to ${3:-$2.yaml}"; 
}
cjbak() { cj_backup "$@"; }