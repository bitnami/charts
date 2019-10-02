#!/bin/bash

run_helm_lint_chart() {
    local -r chart_name="${1:?missing_chart_name}"
    local -r chart_path="$(git rev-parse --show-toplevel)"/"$chart_name"
    local test_failed=0

    printf '\033[0;34m- Running helm lint %s\n\033[0m' "$chart_name"
    if helm lint "$chart_path"; then
        printf '\033[0;32m\U00002705 helm lint %s\n\n\033[0m' "$chart_name"
    else
        printf '\033[0;31m\U0001F6AB helm lint %s failed.\n\n\033[0m' "$chart_name"
        test_failed=1
    fi
    for values_file in "$chart_path"/values.yaml "$chart_path"/ci/*.yaml; do
        if [[ ! -f "$values_file" ]];then
            continue
        fi
        values_file_display=${values_file#$chart_path/}

        printf '\033\033[0;34m- Running helm template --values %s %s\n\033[0m' "$values_file_display" "$chart_name"
        helm repo add bitnami https://charts.bitnami.com/bitnami >> /dev/null
        helm dependency update "$chart_path" >> /dev/null
        if helm template --values "$values_file" "$chart_path" >> /dev/null; then
            printf '\033[0;32m\U00002705 helm template --values %s %s\n\n\033[0m' "$values_file_display" "$chart_name"
        else
            printf '\033[0;31m\U0001F6AB helm template --values %s %s failed.\n\n\033[0m' "$values_file_display" "$chart_path"
            test_failed=1
        fi
    done

    if [[ "$test_failed" = "1" ]]; then
        false
    else
        true
    fi
}
