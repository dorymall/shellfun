#!/bin/bash
help_jb(){
    # --- JOB OPERATIONS (jb_*) ---
    echo "Func: jb_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies Job YAML file"
    echo "Func: jb_add_basic (\$ns, \$name, \$image, \$cmd) | Act: [kubectl] create job | Desc: Creates basic Job"
    echo "Func: jb_clone (\$sns, \$name, \$tns, [\$tname]) | Act: [sed] and [kubectl] apply | Desc: Clones Job"
    echo "Func: jb_ls (\$ns, [\$args...]) | Act: [kubectl] get jobs | Desc: Lists Jobs"
    echo "Func: jb_ls_all ([\$args...]) | Act: [kubectl] get jobs --all-namespaces | Desc: Lists Jobs in all namespaces"
    echo "Func: jb_ls_pods (\$ns, \$name) | Act: [kubectl] get pods -l | Desc: Lists pods manage by Job"
    echo "Func: jb_get_info (\$ns, \$name) | Act: [kubectl] get job -o wide | Desc: Gets wide Job info"
    echo "Func: jb_get_status (\$ns, \$name) | Act: [jsonpath] .status | Desc: Gets Job status"
    echo "Func: jb_get_logs (\$ns, \$name) | Act: [kubectl] logs | Desc: Gets logs from Job pod"
    echo "Func: jb_get_duration (\$ns, \$name) | Act: [jsonpath] .status.completionTime | Desc: Gets Job duration/completion time"
    echo "Func: jb_get_events (\$ns, \$name) | Act: [kubectl] get events | Desc: Gets events for Job"
    echo "Func: jb_desc (\$ns, \$name) | Act: [kubectl] describe job | Desc: Describes Job"
    echo "Func: jb_get (\$ns, \$name) | Act: [kubectl] get job -o yaml | Desc: Gets Job YAML"
    echo "Func: jb_upd_parallelism (\$ns, \$name, \$parallelism) | Act: [kubectl] patch job | Desc: Updates Job parallelism"
    echo "Func: jb_upd_label (\$ns, \$name, \$key, \$val) | Act: [kubectl] label job | Desc: Adds/updates Job label"
    echo "Func: jb_upd_unlabel (\$ns, \$name, \$key) | Act: [kubectl] label job (remove) | Desc: Removes label"
    echo "Func: jb_upd_annotate (\$ns, \$name, \$key, \$val) | Act: [kubectl] annotate job | Desc: Adds/updates annotation"
    echo "Func: jb_del (\$ns, \$name) | Act: [kubectl] delete job | Desc: Deletes Job"
    echo "Func: jb_del_done (\$ns) | Act: [kubectl] delete jobs --field-selector | Desc: Deletes successful jobs"
    echo "Func: jb_del_failed (\$ns) | Act: [kubectl] delete jobs --field-selector | Desc: Deletes failed jobs"
    echo "Func: jb_exists (\$ns, \$name) | Act: [kubectl] get &>/dev/null | Desc: Checks if Job exists"
    echo "Func: jb_watch (\$ns, [\$name]) | Act: [kubectl] get job --watch | Desc: Watches Jobs"
    echo "Func: jb_valid (\$ns, \$name) | Act: [kubectl] apply --dry-run | Desc: Checks if Job YAML is valid"
    echo "Func: jb_backup (\$ns, \$name, [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups Job to YAML file"
    echo "Func: jb_restore (\$file) | Act: [kubectl] apply -f | Desc: Restores Job/CronJob from file"
    
    # --- CRONJOB OPERATIONS (cj_*) ---
    echo "Func: cj_add_f (\$file) | Act: [kubectl] apply -f | Desc: Applies CronJob YAML file"
    echo "Func: cj_add_basic (\$ns, \$name, \$schedule, \$image, \$cmd) | Act: [kubectl] create cronjob | Desc: Creates basic CronJob"
    echo "Func: cj_ls (\$ns, [\$args...]) | Act: [kubectl] get cronjobs | Desc: Lists CronJobs"
    echo "Func: cj_ls_all ([\$args...]) | Act: [kubectl] get cronjobs --all-namespaces | Desc: Lists CronJobs in all namespaces"
    echo "Func: cj_ls_jobs (\$ns, \$name) | Act: [jq] filter by ownerReference | Desc: Lists jobs triggered by CronJob"
    echo "Func: cj_get_schedule (\$ns, \$name) | Act: [jsonpath] .spec.schedule | Desc: Gets Cron schedule"
    echo "Func: cj_get_last_run (\$ns, \$name) | Act: [jsonpath] .status.lastScheduleTime | Desc: Gets last schedule time"
    echo "Func: cj_desc (\$ns, \$name) | Act: [kubectl] describe cj | Desc: Describes CronJob"
    echo "Func: cj_get (\$ns, \$name) | Act: [kubectl] get cj -o yaml | Desc: Gets CronJob YAML"
    echo "Func: cj_upd_schedule (\$ns, \$name, \$schedule) | Act: [kubectl] patch cj | Desc: Updates CronJob schedule"
    echo "Func: cj_upd_suspend (\$ns, \$name) | Act: [kubectl] patch cj suspend=true | Desc: Suspends CronJob"
    echo "Func: cj_upd_resume (\$ns, \$name) | Act: [kubectl] patch cj suspend=false | Desc: Resumes CronJob"
    echo "Func: cj_run (\$ns, \$name) | Act: [kubectl] create job --from | Desc: Manually triggers CronJob"
    echo "Func: cj_del (\$ns, \$name) | Act: [kubectl] delete cj | Desc: Deletes CronJob"
    echo "Func: cj_watch (\$ns, [\$name]) | Act: [kubectl] get cj --watch | Desc: Watches CronJobs"
    echo "Func: cj_backup (\$ns, [\$name], [\$file]) | Act: [kubectl] get -o yaml > file | Desc: Backups CronJob to YAML file"
}

# =============================================================================
# 🏃 JOB OPERATIONS (jb_*)
# =============================================================================

# ===== jb_add_f(file) =====
jb_add_f() { $K8S apply -f "$1"; }

# ===== jb_add_basic(ns, name, image, cmd) =====
jb_add_basic() { $K8S create job "$2" --image="$3" -n "$1" -- "$4"; }

# ===== jb_clone(sns, name, tns, [tname]) =====
jb_clone() {
    local tn="${4:-$2}"
    $K8S get job "$2" -n "$1" -o yaml | sed "s/namespace: $1/namespace: $3/; s/name: $2/name: $tn/" | $K8S apply -f -
}

# ===== jb_ls(ns, [args...]) =====
jb_ls() { $K8S get jobs -n "$1" "${@:2}"; }

# ===== jb_ls_all([args...]) =====
jb_ls_all() { $K8S get jobs --all-namespaces "$@"; }

# ===== jb_ls_pods(ns, name) =====
jb_ls_pods() { $K8S get pods -n "$1" -l job-name="$2"; }

# ===== jb_get_info(ns, name) =====
jb_get_info() { $K8S get job "$2" -n "$1" -o wide; }

# ===== jb_get_status(ns, name) =====
jb_get_status() { $K8S get job "$2" -n "$1" -o jsonpath='{.status}'; }

# ===== jb_get_logs(ns, name) =====
jb_get_logs() {
    local p=$(jb_ls_pods "$1" "$2" -o name | head -1)
    [ -n "$p" ] && $K8S logs "$p" -n "$1" || echo "No pod found for job $2"
}

# ===== jb_get_duration(ns, name) =====
jb_get_duration() { $K8S get job "$2" -n "$1" -o jsonpath='{.status.completionTime}' ; }

# ===== jb_get_events(ns, name) =====
jb_get_events() { $K8S get events -n "$1" --field-selector involvedObject.name="$2"; }

# ===== jb_desc(ns, name) =====
jb_desc() { $K8S describe job "$2" -n "$1"; }

# ===== jb_get(ns, name) =====
jb_get() { $K8S get job "$2" -n "$1" -o yaml; }

# ===== jb_upd_parallelism(ns, name, parallelism) =====
jb_upd_parallelism() { $K8S patch job "$2" -n "$1" -p "{\"spec\":{\"parallelism\":$3}}"; }

# ===== jb_upd_label(ns, name, key, val) =====
jb_upd_label() { $K8S label job "$2" "$3"="$4" -n "$1"; }

# ===== jb_upd_unlabel(ns, name, key) =====
jb_upd_unlabel() { $K8S label job "$2" "$3-" -n "$1"; }

# ===== jb_upd_annotate(ns, name, key, val) =====
jb_upd_annotate() { $K8S annotate job "$2" "$3"="$4" -n "$1"; }

# ===== jb_del(ns, name) =====
jb_del() { $K8S delete job "$2" -n "$1"; }

# ===== jb_del_done(ns) =====
jb_del_done() { $K8S delete job -n "$1" --field-selector status.successful=1; }

# ===== jb_del_failed(ns) =====
jb_del_failed() { $K8S delete job -n "$1" --field-selector status.failed=1; }

# ===== jb_exists(ns, name) =====
jb_exists() { $K8S get job "$2" -n "$1" &>/dev/null; }

# ===== jb_watch(ns, [name]) =====
jb_watch() { [ -n "$2" ] && $K8S get job "$2" -n "$1" --watch || $K8S get job -n "$1" --watch; }

# ===== jb_valid(ns, name) =====
jb_valid() { $K8S get job "$2" -n "$1" -o yaml | $K8S apply --dry-run=client -f -; }

# ===== jb_backup(ns, name, [file]) =====
jb_backup() { $K8S get job "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# ===== jb_restore(file) =====
jb_restore() { $K8S apply -f "$1"; }

# =============================================================================
# 🗓️ CRONJOB OPERATIONS (cj_*)
# =============================================================================

# ===== cj_add_f(file) =====
cj_add_f() { $K8S apply -f "$1"; }

# ===== cj_add_basic(ns, name, schedule, image, cmd) =====
cj_add_basic() { $K8S create cronjob "$2" --schedule="$3" --image="$4" -n "$1" -- "$5"; }

# ===== cj_ls(ns, [args...]) =====
cj_ls() { $K8S get cronjobs -n "$1" "${@:2}"; }

# ===== cj_ls_all([args...]) =====
cj_ls_all() { $K8S get cronjobs --all-namespaces "$@"; }

# ===== cj_ls_jobs(ns, name) =====
cj_ls_jobs() { $K8S get jobs -n "$1" --field-selector metadata.ownerReferences[0].name="$2"; }

# ===== cj_get_schedule(ns, name) =====
cj_get_schedule() { $K8S get cj "$2" -n "$1" -o jsonpath='{.spec.schedule}'; }

# ===== cj_get_last_run(ns, name) =====
cj_get_last_run() { $K8S get cj "$2" -n "$1" -o jsonpath='{.status.lastScheduleTime}'; }

# ===== cj_desc(ns, name) =====
cj_desc() { $K8S describe cj "$2" -n "$1"; }

# ===== cj_get(ns, name) =====
cj_get() { $K8S get cj "$2" -n "$1" -o yaml; }

# ===== cj_upd_schedule(ns, name, schedule) =====
cj_upd_schedule() { $K8S patch cj "$2" -n "$1" -p "{\"spec\":{\"schedule\":\"$3\"}}"; }

# ===== cj_upd_suspend(ns, name) =====
cj_upd_suspend() { $K8S patch cj "$2" -n "$1" -p "{\"spec\":{\"suspend\":true}}"; }

# ===== cj_upd_resume(ns, name) =====
cj_upd_resume() { $K8S patch cj "$2" -n "$1" -p "{\"spec\":{\"suspend\":false}}"; }

# ===== cj_run(ns, name) =====
cj_run() { $K8S create job --from=cronjob/"$2" "${2}-manual-$(date +%s)" -n "$1"; }

# ===== cj_del(ns, name) =====
cj_del() { $K8S delete cj "$2" -n "$1"; }

# ===== cj_exists(ns, name) =====
cj_exists() { $K8S get cj "$2" -n "$1" &>/dev/null; }

# ===== cj_watch(ns, [name]) =====
cj_watch() { [ -n "$2" ] && $K8S get cj "$2" -n "$1" --watch || $K8S get cj -n "$1" --watch; }

# ===== cj_backup(ns, name, [file]) =====
cj_backup() { $K8S get cj "$2" -n "$1" -o yaml > "${3:-$2.yaml}"; }

# ========== BACKWARD COMPATIBILITY ALIASES ==========
jb_add() { jb_add_basic "$@"; }
cj_add() { cj_add_basic "$@"; }
jb_view() { jb_get_info "$@"; }
jb_pods() { jb_ls_pods "$@"; }
jb_logs() { jb_get_logs "$@"; }
jb_duration() { jb_get_duration "$@"; }
jb_events() { jb_get_events "$@"; }
cj_jobs() { cj_ls_jobs "$@"; }
cj_schedule() { cj_get_schedule "$@"; }
cj_last() { cj_get_last_run "$@"; }
jb_scale() { jb_upd_parallelism "$@"; }
jb_suspend() { jb_upd_suspend "$@"; } # Some jobs support suspend
jb_resume() { jb_upd_resume "$@"; }
cj_suspend() { cj_upd_suspend "$@"; }
cj_resume() { cj_upd_resume "$@"; }
jb_del_f() { jb_del "$@"; }
create_job() { jb_add_basic "$@"; }
delete_job() { jb_del "$@"; }
list_jobs() { jb_ls "$@"; }
job_exists() { jb_exists "$@"; }
create_cron_job() { cj_add_basic "$@"; }
delete_cron_job() { cj_del "$@"; }
list_cron_jobs() { cj_ls "$@"; }
cron_job_exists() { cj_exists "$@"; }
describe_job() { jb_desc "$@"; }
describe_cron_job() { cj_desc "$@"; }
get_job_yaml() { jb_get "$@"; }
get_cron_job_yaml() { cj_get "$@"; }
watch_job() { jb_watch "$@"; }
watch_cron_job() { cj_watch "$@"; }
backup_job() { jb_backup "$@"; }
backup_cron_job() { cj_backup "$@"; }