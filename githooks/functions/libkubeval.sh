#!/bin/bash

check_kubeval() {
    if ! command -v kubeval > /dev/null 2>&1; then
        printf '\033[0;31m\U0001F6AB kubeval is not installed\033[0m'
        printf '  Install it from https://github.com/instrumenta/kubeval/releases'
        exit 1
    fi
}

run_kubeval_chart() {
    local -r chart_name="${1:?missing_chart_name}"
    local -r chart_path="$(git rev-parse --show-toplevel)"/"$chart_name"
    local test_failed=0
    for values_file in "$chart_path"/values.yaml "$chart_path"/ci/*.yaml; do
        if [[ ! -f "$values_file" ]];then
            continue
        fi
        values_file_display=${values_file#$chart_path/}

        printf '\033[0;34m- Running helm template --values %s %s | kubeval\n\033[0m' "$values_file_display" "$chart_name"
        if helm template --values "$values_file" "$chart_path" | kubeval; then
            printf '\033[0;32m\U00002705 helm template --values %s %s | kubeval\n\n\033[0m' "$values_file_display" "$chart_name"
        else
            printf '\033[0;31m\U0001F6AB helm template --values %s %s | kubeval failed.\n\n\033[0m' "$values_file_display" "$chart_name"
            test_failed=1
        fi
    done
    if [[ "$test_failed" = "1" ]]; then
        false
    else
        true
    fi
}
