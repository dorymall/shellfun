LIBRARIES=(
    "/var/repos/r-shellfun/000-cluster.sh"
    "/var/repos/r-shellfun/000-git.sh"
    "/var/repos/r-shellfun/000-ns-namespace.sh"
    "/var/repos/r-shellfun/010-ap-apply.sh"
    "/var/repos/r-shellfun/020-cm-configmap.sh"
    "/var/repos/r-shellfun/030-dp-deployment.sh"
    "/var/repos/r-shellfun/040-pod.sh"
    "/var/repos/r-shellfun/050-sv-services.sh"
    "/var/repos/r-shellfun/070-sec-secrets.sh"
    "/var/repos/r-shellfun/080-ing-ingress.sh"
    "/var/repos/r-shellfun/090-pv-storage.sh"
    "/var/repos/r-shellfun/100-np-network-policies.sh"
    "/var/repos/r-shellfun/110-rb-rbac.sh"
    "/var/repos/r-shellfun/120-jb-jobs.sh"
    "/var/repos/r-shellfun/130-hpa-autoscaling.sh"
    "/var/repos/r-shellfun/140-ds-daemonsets.sh"
    "/var/repos/r-shellfun/150-ss-statefulsets.sh"
    "/var/repos/r-shellfun/160-cr-custom-resources.sh"
    "/var/repos/r-shellfun/170-rq-resource-management.sh"
    "/var/repos/r-shellfun/180-pd-monitoring.sh"
    "/var/repos/r-shellfun/190-bk-backup.sh"
    "/var/repos/r-shellfun/200-helm.sh"
)

for lib in "${LIBRARIES[@]}"; do
    if [ -f "$lib" ]; then
        . "$lib"
    else
        echo "Warning: Library file $lib not found."
    fi
done

function add_log(){
    local folder="${sf_logs_folder:-$(pwd)}"
    local log_file="$folder/_sf.log"

    # Ensure the directory exists
    mkdir -p "$folder" 2>/dev/null

    # Handle positional arguments
    if [ $# -gt 0 ]; then
        echo "$@" | tee -a "$log_file"
    fi

    # Handle piped input (stdin)
    if [ ! -t 0 ]; then
        cat - | tee -a "$log_file"
    fi


}

function add_log_help(){
    local folder="${sf_logs_folder:-$(pwd)}"
    local log_file="$folder/_helpsf.log"

    # Ensure the directory exists
    mkdir -p "$folder" 2>/dev/null

    # Handle positional arguments
    if [ $# -gt 0 ]; then
        echo "$@" | tee -a "$log_file"
    fi

    # Handle piped input (stdin)
    if [ ! -t 0 ]; then
        cat - | tee -a "$log_file"
    fi


}

function show_usage() {
    add_log "=====Shell fun loaded===="
}

show_usage

