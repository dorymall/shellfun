#!/bin/bash

help_helm(){
    add_log_help "=== help_helm ==="
    add_log_help "create helm chart: https://helm.sh/docs/topics/charts/"
    add_log_help "Where to call: Run these functions inside the directory where you want the new chart folder to be created."
    add_log_help ""
    add_log_help "Func: helm_create_chart_by_name [hcreate] (\$name) | Act: [helm] create | Desc: Creates a new Helm chart"
    add_log_help "Func: helm_lint_chart_by_path [hlint] (\$path) | Act: [helm] lint | Desc: Examines a chart for issues"
    add_log_help "Func: helm_package_by_path [hpackage] (\$path) | Act: [helm] package | Desc: Packages a chart into an archive"
    add_log_help "Func: helm_repo_add_url_by_name_by_url [hrepoadd] (\$name, \$url) | Act: [helm] repo add | Desc: Adds a Helm repository"
    add_log_help "Func: helm_install_chart_by_ns_by_release_by_chart [hinstall] (\$ns, \$release, \$chart) | Act: [helm] install | Desc: Installs a Helm chart"
    add_log_help "Func: helm_install_ver_by_ns_by_release_by_chart_by_ver [hinstallversion] (\$ns, \$release, \$chart, \$ver) | Act: [helm] install --version | Desc: Installs chart with specific version"
    add_log_help "Func: helm_install_set_by_ns_by_release_by_chart_by_param [hinstallset] (\$ns, \$release, \$chart, \$param) | Act: [helm] install --set | Desc: Installs chart with overrides"
    add_log_help "Func: helm_install_with_vals_by_ns_by_release_by_chart_by_val_file [hinstallfile] (\$ns, \$release, \$chart, \$val_file) | Act: [helm] install -f | Desc: Installs chart with values file"
    add_log_help "Func: helm_install_archive_by_ns_by_release_by_archive [hinstallarchive] (\$ns, \$release, \$archive) | Act: [helm] install (archive) | Desc: Installs chart from local archive"
    add_log_help "Func: helm_install_dir_by_ns_by_release_by_dir [hinstalldir] (\$ns, \$release, \$path) | Act: [helm] install (dir) | Desc: Installs chart from directory"
    add_log_help "Func: helm_install_url_by_ns_by_release_by_url [hinstallurl] (\$ns, \$release, \$url) | Act: [helm] install (url) | Desc: Installs chart from full URL"
    add_log_help "Func: helm_added_repos_ls [hrepolist] () | Act: [helm] repo list | Desc: Lists added repositories"
    add_log_help "Func: helm_ls_installed_by_ns [hlist] (\$ns, [\$args...]) | Act: [helm] list | Desc: Lists releases in a namespace"
    add_log_help "Func: helm_ls_installed_from_all_ns [hlistall] ([\$args...]) | Act: [helm] list --all-namespaces | Desc: Lists releases in all namespaces"
    add_log_help "Func: helm_ls_all_installed_failed_deleted [hlistfail] ([\$args...]) | Act: [helm] list --all | Desc: Lists all releases"
    add_log_help "Func: helm_installed_chart_status_by_ns_by_release [hstatus] (\$ns, \$release) | Act: [helm] status | Desc: Gets status of a release"
    add_log_help "Func: helm_get_overridden_values_by_ns_by_release [hvalues] (\$ns, \$release) | Act: [helm] get values | Desc: Gets overridden values"
    add_log_help "Func: helm_show_values_by_chart [hshowvalues] (\$chart) | Act: [helm] show values | Desc: Shows default values"
    add_log_help "Func: helm_show_all_chart_contents_by_chart [hshowall] (\$chart) | Act: [helm] show all | Desc: Inspects a chart contents"
    add_log_help "Func: helm_pull_chart_to_local_by_chart [hpull] (\$chart) | Act: [helm] pull | Desc: Downloads chart package"
    add_log_help "Func: helm_pull_chart_untar_to_local_by_chart [hpulluntar] (\$chart) | Act: [helm] pull --untar | Desc: Pulls and untars into a directory"
    add_log_help "Func: helm_pull_chart_verify_to_local_by_chart [hpullverify] (\$chart) | Act: [helm] pull --verify | Desc: Verifies and downloads package"
    add_log_help "Func: helm_pull_chart_version_to_local_by_chart_by_ver [hpullversion] (\$chart, \$ver) | Act: [helm] pull --version | Desc: Pulls specific version"
    add_log_help "Func: helm_display_chart_dependencies_by_chart [hdep] (\$chart) | Act: [helm] dependency list | Desc: Displays dependencies"
    add_log_help "Func: helm_search_chart_in_added_repos_by_keyword [hsearch] (\$keyword) | Act: [helm] search repo | Desc: Searches added repos"
    add_log_help "Func: helm_search_artifact_hub_by_keyword [hsearchhub] (\$keyword) | Act: [helm] search hub | Desc: Searches Artifact Hub"
    add_log_help "Func: helm_repo_info_update [hrepoupdate] () | Act: [helm] repo update | Desc: Updates repository information"
    add_log_help "Func: helm_update_installed_chart_by_ns_by_release_by_chart [hupgrade] (\$ns, \$release, \$chart, [\$args...]) | Act: [helm] upgrade --install | Desc: Upgrades or installs"
    add_log_help "Func: helm_update_with_values_file_by_ns_by_release_by_chart_by_val_file [hupgradefile] (\$ns, \$release, \$chart, \$val_file) | Act: [helm] upgrade -f | Desc: Upgrades with values file"
    add_log_help "Func: helm_rollback_installed_release_by_ns_by_release_by_revision [hundo] (\$ns, \$release, \$revision) | Act: [helm] rollback | Desc: Rolls back to revision"
    add_log_help "Func: helm_del_added_repo_by_name [hrepodel] (\$name) | Act: [helm] repo remove | Desc: Removes a repository"
    add_log_help "Func: helm_del_installed_release_by_ns_by_release_name [huninstall] (\$ns, \$release) | Act: [helm] uninstall | Desc: Uninstalls a release"
    add_log_help "Func: helm_install_mac () | Act: [brew] install helm | Desc: Installs Helm on macOS"
    add_log_help "Func: helm_install_ubuntu () | Act: [apt] install helm | Desc: Installs Helm on Ubuntu"
    add_log_help "Func: helm_install_win () | Act: [choco] install helm | Desc: Installs Helm on Windows"
}
# === CREATE / PUT OPERATIONS ===
helm_create_chart_by_name() {
    add_log "=== Func: helm_create_chart_by_name ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hcreate <name>"; return 1; }
    $HELM_EXEC create "$1" | add_log; 
}
hcreate() { helm_create_chart_by_name "$@"; }
helm_lint_chart_by_path() {
    add_log "=== Func: helm_lint_chart_by_path ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hlint <path>"; return 1; }
    $HELM_EXEC lint "$1" | add_log; 
}
hlint() { helm_lint_chart_by_path "$@"; }
helm_package_by_path() {
    add_log "=== Func: helm_package_by_path ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hpackage <path>"; return 1; }
    $HELM_EXEC package "$1" | add_log; 
}
hpackage() { helm_package_by_path "$@"; }
helm_repo_add_url_by_name_by_url() {
    add_log "=== Func: helm_repo_add_url_by_name_by_url ==="
    [[ -z "$1" || -z "$2" ]] && { add_log "❌ Usage: hrepoadd <name> <url>"; return 1; }
    $HELM_EXEC repo add "$1" "$2" | add_log; 
}
hrepoadd() { helm_repo_add_url_by_name_by_url "$@"; }
helm_install_chart_by_ns_by_release_by_chart() {
    add_log "=== Func: helm_install_chart_by_ns_by_release_by_chart ==="
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { add_log "❌ Usage: hinstall <ns> <release> <chart>"; return 1; }
    $HELM_EXEC install "$2" "$3" -n "$1" | add_log; 
}
hinstall() { helm_install_chart_by_ns_by_release_by_chart "$@"; }
helm_install_ver_by_ns_by_release_by_chart_by_ver() {
    add_log "=== Func: helm_install_ver_by_ns_by_release_by_chart_by_ver ==="
    [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]] && { add_log "❌ Usage: hinstallversion <ns> <release> <chart> <ver>"; return 1; }
    $HELM_EXEC install "$2" "$3" -n "$1" --version "$4" | add_log; 
}
hinstallversion() { helm_install_ver_by_ns_by_release_by_chart_by_ver "$@"; }
helm_install_set_by_ns_by_release_by_chart_by_param() {
    add_log "=== Func: helm_install_set_by_ns_by_release_by_chart_by_param ==="
    [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]] && { add_log "❌ Usage: hinstallset <ns> <release> <chart> <param>"; return 1; }
    $HELM_EXEC install "$2" "$3" -n "$1" --set "$4" | add_log; 
}
hinstallset() { helm_install_set_by_ns_by_release_by_chart_by_param "$@"; }
helm_install_with_vals_by_ns_by_release_by_chart_by_val_file() {
    add_log "=== Func: helm_install_with_vals_by_ns_by_release_by_chart_by_val_file ==="
    [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]] && { add_log "❌ Usage: hinstallfile <ns> <release> <chart> <val_file>"; return 1; }
    $HELM_EXEC install "$2" "$3" -n "$1" -f "$4" | add_log; 
}
hinstallfile() { helm_install_with_vals_by_ns_by_release_by_chart_by_val_file "$@"; }
helm_install_archive_by_ns_by_release_by_archive() {
    add_log "=== Func: helm_install_archive_by_ns_by_release_by_archive ==="
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { add_log "❌ Usage: hinstallarchive <ns> <release> <archive>"; return 1; }
    $HELM_EXEC install "$2" "$3" -n "$1" | add_log; 
}
hinstallarchive() { helm_install_archive_by_ns_by_release_by_archive "$@"; }
helm_install_dir_by_ns_by_release_by_dir() {
    add_log "=== Func: helm_install_dir_by_ns_by_release_by_dir ==="
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { add_log "❌ Usage: hinstalldir <ns> <release> <dir>"; return 1; }
    $HELM_EXEC install "$2" "$3" -n "$1" | add_log; 
}
hinstalldir() { helm_install_dir_by_ns_by_release_by_dir "$@"; }
helm_install_url_by_ns_by_release_by_url() {
    add_log "=== Func: helm_install_url_by_ns_by_release_by_url ==="
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { add_log "❌ Usage: hinstallurl <ns> <release> <url>"; return 1; }
    $HELM_EXEC install "$2" "$3" -n "$1" | add_log; 
}
hinstallurl() { helm_install_url_by_ns_by_release_by_url "$@"; }
# === READ / DESCRIBE / LS / GET OPERATIONS ===
helm_added_repos_ls() { 
    add_log "=== Func: helm_added_repos_ls ==="
    $HELM_EXEC repo list | add_log; 
}
hrepolist() { helm_added_repos_ls "$@"; }
helm_ls_installed_by_ns() {
    add_log "=== Func: helm_ls_installed_by_ns ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hlist <ns> [args...]"; return 1; }
    $HELM_EXEC list -n "$1" "${@:2}" | add_log
}
hlist() { helm_ls_installed_by_ns "$@"; }
helm_ls_installed_from_all_ns() { 
    add_log "=== Func: helm_ls_installed_from_all_ns ==="
    $HELM_EXEC list -A "$@" | add_log; 
}
hlistall() { helm_ls_installed_from_all_ns "$@"; }
helm_ls_all_installed_failed_deleted() { 
    add_log "=== Func: helm_ls_all_installed_failed_deleted ==="
    $HELM_EXEC list --all "$@" | add_log; 
}
hlistfail() { helm_ls_all_installed_failed_deleted "$@"; }
helm_installed_chart_status_by_ns_by_release() {
    add_log "=== Func: helm_installed_chart_status_by_ns_by_release ==="
    [[ -z "$1" || -z "$2" ]] && { add_log "❌ Usage: hstatus <ns> <release>"; return 1; }
    $HELM_EXEC status "$2" -n "$1" | add_log
}
hstatus() { helm_installed_chart_status_by_ns_by_release "$@"; }
helm_get_overridden_values_by_ns_by_release() {
    add_log "=== Func: helm_get_overridden_values_by_ns_by_release ==="
    [[ -z "$1" || -z "$2" ]] && { add_log "❌ Usage: hvalues <ns> <release>"; return 1; }
    $HELM_EXEC get values "$2" -n "$1" | add_log
}
hvalues() { helm_get_overridden_values_by_ns_by_release "$@"; }
helm_show_values_by_chart() {
    add_log "=== Func: helm_show_values_by_chart ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hshowvalues <chart>"; return 1; }
    $HELM_EXEC show values "$1" | add_log
}
hshowvalues() { helm_show_values_by_chart "$@"; }
helm_show_all_chart_contents_by_chart() {
    add_log "=== Func: helm_show_all_chart_contents_by_chart ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hshowall <chart>"; return 1; }
    $HELM_EXEC show all "$1" | add_log
}
hshowall() { helm_show_all_chart_contents_by_chart "$@"; }
helm_pull_chart_to_local_by_chart() {
    add_log "=== Func: helm_pull_chart_to_local_by_chart ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hpull <chart>"; return 1; }
    $HELM_EXEC pull "$1" | add_log
}
hpull() { helm_pull_chart_to_local_by_chart "$@"; }
helm_pull_chart_untar_to_local_by_chart() {
    add_log "=== Func: helm_pull_chart_untar_to_local_by_chart ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hpulluntar <chart>"; return 1; }
    $HELM_EXEC pull "$1" --untar=true | add_log
}
hpulluntar() { helm_pull_chart_untar_to_local_by_chart "$@"; }
helm_pull_chart_verify_to_local_by_chart() {
    add_log "=== Func: helm_pull_chart_verify_to_local_by_chart ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hpullverify <chart>"; return 1; }
    $HELM_EXEC pull "$1" --verify | add_log
}
hpullverify() { helm_pull_chart_verify_to_local_by_chart "$@"; }
helm_pull_chart_version_to_local_by_chart_by_ver() {
    add_log "=== Func: helm_pull_chart_version_to_local_by_chart_by_ver ==="
    [[ -z "$1" || -z "$2" ]] && { add_log "❌ Usage: hpullversion <chart> <ver>"; return 1; }
    $HELM_EXEC pull "$1" --version "$2" | add_log
}
hpullversion() { helm_pull_chart_version_to_local_by_chart_by_ver "$@"; }
helm_display_chart_dependencies_by_chart() {
    add_log "=== Func: helm_display_chart_dependencies_by_chart ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hdep <chart>"; return 1; }
    $HELM_EXEC dependency list "$1" | add_log
}
hdep() { helm_display_chart_dependencies_by_chart "$@"; }
helm_search_chart_in_added_repos_by_keyword() {
    add_log "=== Func: helm_search_chart_in_added_repos_by_keyword ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hsearch <keyword>"; return 1; }
    $HELM_EXEC search repo "$1" | add_log
}
hsearch() { helm_search_chart_in_added_repos_by_keyword "$@"; }
helm_search_artifact_hub_by_keyword() {
    add_log "=== Func: helm_search_artifact_hub_by_keyword ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hsearchhub <keyword>"; return 1; }
    $HELM_EXEC search hub "$1" | add_log
}
hsearchhub() { helm_search_artifact_hub_by_keyword "$@"; }
# === UPDATE OPERATIONS ===
helm_repo_info_update() { 
    add_log "=== Func: helm_repo_info_update ==="
    $HELM_EXEC repo update | add_log; 
}
hrepoupdate() { helm_repo_info_update "$@"; }
helm_update_installed_chart_by_ns_by_release_by_chart() {
    add_log "=== Func: helm_update_installed_chart_by_ns_by_release_by_chart ==="
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { add_log "❌ Usage: hupgrade <ns> <release> <chart> [args...]"; return 1; }
    $HELM_EXEC upgrade "$2" "$3" -n "$1" --install "${@:4}" | add_log
}
hupgrade() { helm_update_installed_chart_by_ns_by_release_by_chart "$@"; }
helm_update_with_values_file_by_ns_by_release_by_chart_by_val_file() {
    add_log "=== Func: helm_update_with_values_file_by_ns_by_release_by_chart_by_val_file ==="
    [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]] && { add_log "❌ Usage: hupgradefile <ns> <release> <chart> <val_file>"; return 1; }
    $HELM_EXEC upgrade "$2" "$3" -n "$1" -f "$4" --install | add_log
}
hupgradefile() { helm_update_with_values_file_by_ns_by_release_by_chart_by_val_file "$@"; }
helm_rollback_installed_release_by_ns_by_release_by_revision() {
    add_log "=== Func: helm_rollback_installed_release_by_ns_by_release_by_revision ==="
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { add_log "❌ Usage: hundo <ns> <release> <revision>"; return 1; }
    $HELM_EXEC rollback "$2" "$3" -n "$1" | add_log
}
hundo() { helm_rollback_installed_release_by_ns_by_release_by_revision "$@"; }
# === DELETE OPERATIONS ===
helm_del_added_repo_by_name() {
    add_log "=== Func: helm_del_added_repo_by_name ==="
    [[ -z "$1" ]] && { add_log "❌ Usage: hrepodel <name>"; return 1; }
    $HELM_EXEC repo remove "$1" | add_log
}
hrepodel() { helm_del_added_repo_by_name "$@"; }
helm_del_installed_release_by_ns_by_release_name() {
    add_log "=== Func: helm_del_installed_release_by_ns_by_release_name ==="
    [[ -z "$1" || -z "$2" ]] && { add_log "❌ Usage: huninstall <ns> <release>"; return 1; }
    $HELM_EXEC uninstall "$2" -n "$1" | add_log
}
huninstall() { helm_del_installed_release_by_ns_by_release_name "$@"; }
helm_install_mac() { 
    add_log "=== Func: helm_install_mac ==="
    brew install helm | add_log; 
}
helm_install_ubuntu() { 
    add_log "=== Func: helm_install_ubuntu ==="
    sudo apt-get install helm -y | add_log; 
}
helm_install_win() { 
    add_log "=== Func: helm_install_win ==="
    choco install kubernetes-helm | add_log; 
}
