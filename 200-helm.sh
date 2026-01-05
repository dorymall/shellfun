#!/bin/bash

help_helm(){
    echo "create helm chart: https://helm.sh/docs/topics/charts/"
    echo "Where to call: Run this function inside the directory where you want the new chart folder to be created."

    echo ""
    echo "Func: helm_create_chart_by_name                   (\$name)                                   | Act: [helm] create                    | Desc: Creates a new Helm chart with default directory structure, Run this function inside the directory where you want the new chart folder to be created. Will output the chart directory with the default structure."
    echo "Func: helm_lint_chart_by_path                     (\$path)                                   | Act: [helm] lint                      | Desc: Examines a chart for possible issues, call "
    echo "Func: helm_package_by_path                        (\$path)                                   | Act: [helm] package                   | Desc: Packages a chart into a versioned chart archive file"
    echo "Func: helm_repo_add_url_by_name_by_url                  (\$name, \$url)                            | Act: [helm] repo add                  | Desc: Adds a Helm chart repository"
    echo "Func: helm_install_chart_by_ns_by_release_by_chart    (\$ns, \$release, \$chart)                 | Act: [helm] install                   | Desc: Installs a Helm chart"
    echo "Func: helm_install_ver_by_ns_by_release_by_chart_by_ver (\$ns, \$release, \$chart, \$ver)          | Act: [helm] install --version         | Desc: Installs chart with specific version"
    echo "Func: helm_install_set_by_ns_by_release_by_chart_by_param (\$ns, \$release, \$chart, \$param)        | Act: [helm] install --set             | Desc: Installs chart with value overrides"
    echo "Func: helm_install_with_vals_by_ns_by_release_by_chart_by_val_file (\$ns, \$release, \$chart, \$val_file)      | Act: [helm] install -f                | Desc: Installs chart with release name & values file"
    echo "Func: helm_install_archive_by_ns_by_release_by_archive  (\$ns, \$release, \$archive)               | Act: [helm] install (archive)         | Desc: Installs chart from local archive (.tgz)"
    echo "Func: helm_install_dir_by_ns_by_release_by_dir          (\$ns, \$release, \$path)                  | Act: [helm] install (dir)             | Desc: Installs chart from unpacked directory"
    echo "Func: helm_install_url_by_ns_by_release_by_url          (\$ns, \$release, \$url)                   | Act: [helm] install (url)             | Desc: Installs chart from full URL"
    echo "Func: helm_added_repos_ls                               ()                                       | Act: [helm] repo list                 | Desc: Lists added Helm repositories"
    echo "Func: helm_ls_installed_by_ns                           (\$ns, [\$args...])                        | Act: [helm] list                      | Desc: Lists releases in a namespace"
    echo "Func: helm_ls_installed_from_all_ns                     ([\$args...])                              | Act: [helm] list --all-namespaces     | Desc: Lists releases in all namespaces"
    echo "Func: helm_ls_all_installed_failed_deleted              ([\$args...])                              | Act: [helm] list --all                | Desc: Lists all releases (installed, failed, deleted)"
    echo "Func: helm_installed_chart_status_by_ns_by_release      (\$ns, \$release)                          | Act: [helm] status                    | Desc: Gets status of a Helm release"
    echo "Func: helm_get_overridden_values_by_ns_by_release       (\$ns, \$release)                          | Act: [helm] get values                | Desc: Gets overridden values for a release"
    echo "Func: helm_show_values_by_chart                         (\$chart)                                  | Act: [helm] show values               | Desc: Shows the default values for a chart"
    echo "Func: helm_show_all_chart_contents_by_chart             (\$chart)                                  | Act: [helm] show all                  | Desc: Inspects a chart and lists its contents"
    echo "Func: helm_pull_chart_to_local_by_chart                 (\$chart)                                  | Act: [helm] pull                      | Desc: Downloads chart package to CURRENT directory"
    echo "Func: helm_pull_chart_untar_to_local_by_chart           (\$chart)                                  | Act: [helm] pull --untar              | Desc: Pulls and untars the chart into a directory in the CURRENT folder"
    echo "Func: helm_pull_chart_verify_to_local_by_chart          (\$chart)                                  | Act: [helm] pull --verify             | Desc: Verifies package and downloads to CURRENT directory"
    echo "Func: helm_pull_chart_version_to_local_by_chart_by_ver  (\$chart, \$ver)                           | Act: [helm] pull --version            | Desc: Pulls specific version of chart to CURRENT directory"
    echo "Func: helm_display_chart_dependencies_by_chart          (\$chart)                                  | Act: [helm] dependency list           | Desc: Displays a list of a chart dependencies"
    echo "Func: helm_search_chart_in_added_repos_by_keyword       (\$keyword)                                | Act: [helm] search repo               | Desc: Searches for charts in added repos"
    echo "Func: helm_search_artifact_hub_by_keyword               (\$keyword)                                | Act: [helm] search hub                | Desc: Searches for charts on Artifact Hub"
    echo "Func: helm_repo_info_update                             ()                                       | Act: [helm] repo update               | Desc: Updates information of available charts"
    echo "Func: helm_update_installed_chart_by_ns_by_release_by_chart (\$ns, \$release, \$chart, [\$args...]) | Act: [helm] upgrade --install         | Desc: Upgrades or installs a release"
    echo "Func: helm_update_with_values_file_by_ns_by_release_by_chart_by_val_file (\$ns, \$release, \$chart, \$val_file) | Act: [helm] upgrade -f                | Desc: Upgrades release with values file"
    echo "Func: helm_rollback_installed_release_by_ns_by_release_by_revision (\$ns, \$release, \$revision)    | Act: [helm] rollback                  | Desc: Rolls back a release to a specific revision"
    echo "Func: helm_del_added_repo_by_name                       (\$name)                                   | Act: [helm] repo remove               | Desc: Removes a Helm repository"
    echo "Func: helm_del_installed_release_by_ns_by_release_name  (\$ns, \$release)                          | Act: [helm] uninstall                 | Desc: Uninstalls a Helm release"
    echo "Func: helm_install_mac                                  ()                                       | Act: [brew] install helm              | Desc: Installs Helm on macOS using Homebrew"
    echo "Func: helm_install_ubuntu                               ()                                       | Act: [apt] install helm               | Desc: Installs Helm on Ubuntu using APT"
    echo "Func: helm_install_win                                  ()                                       | Act: [choco] install helm             | Desc: Installs Helm on Windows using Chocolatey/Winget"
}

HELM="${HELM:-helm}"

# =============================================================================
# ✨ CREATE / PUT OPERATIONS
# =============================================================================

# ===== helm_create_chart_by_name(name) =====
helm_create_chart_by_name() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_create_chart_by_name <name>"; return 1; }
    $HELM create "$1"
}
# wordpress/
#   Chart.yaml          # A YAML file containing information about the chart
#   LICENSE             # OPTIONAL: A plain text file containing the license for the chart
#   README.md           # OPTIONAL: A human-readable README file
#   values.yaml         # The default configuration values for this chart
#   values.schema.json  # OPTIONAL: A JSON Schema for imposing a structure on the values.yaml file
#   charts/             # A directory containing any charts upon which this chart depends.
#   crds/               # Custom Resource Definitions
#   templates/          # A directory of templates that, when combined with values,
#                       # will generate valid Kubernetes manifest files.
#   templates/NOTES.txt # OPTIONAL: A plain text file containing short usage notes
#
# ===== helm_lint_chart_by_path(path) =====
helm_lint_chart_by_path() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_lint_chart_by_path <path>"; return 1; }
    $HELM lint "$1"
}

# ===== helm_package_by_path(path) =====
helm_package_by_path() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_package_by_path <path>"; return 1; }
    $HELM package "$1"
}

# ===== helm_repo_add_url_by_name_by_url(name, url) =====
helm_repo_add_url_by_name_by_url() {
    [[ -z "$1" || -z "$2" ]] && { echo "❌ Usage: helm_repo_add_url_by_name_by_url <name> <url>"; return 1; }
    $HELM repo add "$1" "$2"
}

# ===== helm_install_chart_by_ns_by_release_by_chart(ns, release, chart) =====
helm_install_chart_by_ns_by_release_by_chart() {
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { echo "❌ Usage: helm_install_chart_by_ns_by_release_by_chart <ns> <release> <chart>"; return 1; }
    $HELM install "$2" "$3" -n "$1"
}

# ===== helm_install_ver_by_ns_by_release_by_chart_by_ver(ns, release, chart, ver) =====
helm_install_ver_by_ns_by_release_by_chart_by_ver() {
    [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]] && { echo "❌ Usage: helm_install_ver_by_ns_by_release_by_chart_by_ver <ns> <release> <chart> <ver>"; return 1; }
    $HELM install "$2" "$3" -n "$1" --version "$4"
}

# ===== helm_install_set_by_ns_by_release_by_chart_by_param(ns, release, chart, param) =====
helm_install_set_by_ns_by_release_by_chart_by_param() {
    [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]] && { echo "❌ Usage: helm_install_set_by_ns_by_release_by_chart_by_param <ns> <release> <chart> <param>"; return 1; }
    $HELM install "$2" "$3" -n "$1" --set "$4"
}

# ===== helm_install_with_vals_by_ns_by_release_by_chart_by_val_file(ns, release, chart, val_file) =====
helm_install_with_vals_by_ns_by_release_by_chart_by_val_file() {
    [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]] && { echo "❌ Usage: helm_install_with_vals_by_ns_by_release_by_chart_by_val_file <ns> <release> <chart> <val_file>"; return 1; }
    $HELM install "$2" "$3" -n "$1" -f "$4"
}

# ===== helm_install_archive_by_ns_by_release_by_archive(ns, release, archive) =====
helm_install_archive_by_ns_by_release_by_archive() {
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { echo "❌ Usage: helm_install_archive_by_ns_by_release_by_archive <ns> <release> <archive>"; return 1; }
    $HELM install "$2" "$3" -n "$1"
}

# ===== helm_install_dir_by_ns_by_release_by_dir(ns, release, dir) =====
helm_install_dir_by_ns_by_release_by_dir() {
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { echo "❌ Usage: helm_install_dir_by_ns_by_release_by_dir <ns> <release> <dir>"; return 1; }
    $HELM install "$2" "$3" -n "$1"
}

# ===== helm_install_url_by_ns_by_release_by_url(ns, release, url) =====
helm_install_url_by_ns_by_release_by_url() {
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { echo "❌ Usage: helm_install_url_by_ns_by_release_by_url <ns> <release> <url>"; return 1; }
    $HELM install "$2" "$3" -n "$1"
}

# =============================================================================
# 🔍 READ / DESCRIBE / LS / GET OPERATIONS
# =============================================================================

# ===== helm_added_repos_ls() =====
helm_added_repos_ls() { $HELM repo list; }

# ===== helm_ls_installed_by_ns(ns, [args...]) =====
helm_ls_installed_by_ns() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_ls_installed_by_ns <ns> [args...]"; return 1; }
    $HELM list -n "$1" "${@:2}"
}

# ===== helm_ls_installed_from_all_ns([args...]) =====
helm_ls_installed_from_all_ns() { $HELM list -A "$@"; }

# ===== helm_ls_all_installed_failed_deleted([args...]) =====
helm_ls_all_installed_failed_deleted() { $HELM list --all "$@"; }

# ===== helm_installed_chart_status_by_ns_by_release(ns, release) =====
helm_installed_chart_status_by_ns_by_release() {
    [[ -z "$1" || -z "$2" ]] && { echo "❌ Usage: helm_installed_chart_status_by_ns_by_release <ns> <release>"; return 1; }
    $HELM status "$2" -n "$1"
}

# ===== helm_get_overridden_values_by_ns_by_release(ns, release) =====
helm_get_overridden_values_by_ns_by_release() {
    [[ -z "$1" || -z "$2" ]] && { echo "❌ Usage: helm_get_overridden_values_by_ns_by_release <ns> <release>"; return 1; }
    $HELM get values "$2" -n "$1"
}

# ===== helm_show_values_by_chart(chart) =====
helm_show_values_by_chart() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_show_values_by_chart <chart>"; return 1; }
    $HELM show values "$1"
}

# ===== helm_show_all_chart_contents_by_chart(chart) =====
helm_show_all_chart_contents_by_chart() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_show_all_chart_contents_by_chart <chart>"; return 1; }
    $HELM show all "$1"
}

# ===== helm_pull_chart_to_local_by_chart(chart) =====
helm_pull_chart_to_local_by_chart() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_pull_chart_to_local_by_chart <chart>"; return 1; }
    $HELM pull "$1"
}

# ===== helm_pull_chart_untar_to_local_by_chart(chart) =====
helm_pull_chart_untar_to_local_by_chart() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_pull_chart_untar_to_local_by_chart <chart>"; return 1; }
    $HELM pull "$1" --untar=true
}

# ===== helm_pull_chart_verify_to_local_by_chart(chart) =====
helm_pull_chart_verify_to_local_by_chart() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_pull_chart_verify_to_local_by_chart <chart>"; return 1; }
    $HELM pull "$1" --verify
}

# ===== helm_pull_chart_version_to_local_by_chart_by_ver(chart, ver) =====
helm_pull_chart_version_to_local_by_chart_by_ver() {
    [[ -z "$1" || -z "$2" ]] && { echo "❌ Usage: helm_pull_chart_version_to_local_by_chart_by_ver <chart> <ver>"; return 1; }
    $HELM pull "$1" --version "$2"
}

# ===== helm_display_chart_dependencies_by_chart(chart) =====
helm_display_chart_dependencies_by_chart() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_display_chart_dependencies_by_chart <chart>"; return 1; }
    $HELM dependency list "$1"
}

# ===== helm_search_chart_in_added_repos_by_keyword(keyword) =====
helm_search_chart_in_added_repos_by_keyword() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_search_chart_in_added_repos_by_keyword <keyword>"; return 1; }
    $HELM search repo "$1"
}

# ===== helm_search_artifact_hub_by_keyword(keyword) =====
helm_search_artifact_hub_by_keyword() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_search_artifact_hub_by_keyword <keyword>"; return 1; }
    $HELM search hub "$1"
}

# =============================================================================
# 🔄 UPDATE OPERATIONS
# =============================================================================

# ===== helm_repo_info_update() =====
helm_repo_info_update() { $HELM repo update; }

# ===== helm_update_installed_chart_by_ns_by_release_by_chart(ns, release, chart, [args...]) =====
helm_update_installed_chart_by_ns_by_release_by_chart() {
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { echo "❌ Usage: helm_update_installed_chart_by_ns_by_release_by_chart <ns> <release> <chart> [args...]"; return 1; }
    $HELM upgrade "$2" "$3" -n "$1" --install "${@:4}"
}

# ===== helm_update_with_values_file_by_ns_by_release_by_chart_by_val_file(ns, release, chart, val_file) =====
helm_update_with_values_file_by_ns_by_release_by_chart_by_val_file() {
    [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]] && { echo "❌ Usage: helm_update_with_values_file_by_ns_by_release_by_chart_by_val_file <ns> <release> <chart> <val_file>"; return 1; }
    $HELM upgrade "$2" "$3" -n "$1" -f "$4" --install
}

# ===== helm_rollback_installed_release_by_ns_by_release_by_revision(ns, release, revision) =====
helm_rollback_installed_release_by_ns_by_release_by_revision() {
    [[ -z "$1" || -z "$2" || -z "$3" ]] && { echo "❌ Usage: helm_rollback_installed_release_by_ns_by_release_by_revision <ns> <release> <revision>"; return 1; }
    $HELM rollback "$2" "$3" -n "$1"
}

# =============================================================================
# 🗑️ DELETE OPERATIONS
# =============================================================================

# ===== helm_del_added_repo_by_name(name) =====
helm_del_added_repo_by_name() {
    [[ -z "$1" ]] && { echo "❌ Usage: helm_del_added_repo_by_name <name>"; return 1; }
    $HELM repo remove "$1"
}

# ===== helm_del_installed_release_by_ns_by_release_name(ns, release) =====
helm_del_installed_release_by_ns_by_release_name() {
    [[ -z "$1" || -z "$2" ]] && { echo "❌ Usage: helm_del_installed_release_by_ns_by_release_name <ns> <release>"; return 1; }
    $HELM uninstall "$2" -n "$1"
}

# ===== helm_install_mac() =====
helm_install_mac() { brew install helm; }

# ===== helm_install_ubuntu() =====
helm_install_ubuntu() { sudo apt-get install helm -y; }

# ===== helm_install_win() =====
helm_install_win() { choco install kubernetes-helm; }
