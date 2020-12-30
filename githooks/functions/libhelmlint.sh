#!/bin/bash

run_helm_lint_chart() {
    local -r chart_name="${1:?missing_chart_name}"
    local -r chart_path="$(git rev-parse --show-toplevel)"/"$chart_name"
    local test_failed=0

    printf '\033[0;34m- Running helm lint %s\n\033[0m' "$chart_name"
    if ! helm lint "$chart_path"; then
        printf '\033[0;31m\U0001F6AB helm lint %s failed.\n\n\033[0m' "$chart_name"
        test_failed=1
    fi

    local -r ci_values_file_list=$(mktemp)

    if [[ -d "$chart_path"/ci ]]; then
        find "$chart_path"/ci -type f -regex ".*\.yaml" > "$ci_values_file_list"
    fi
    printf '\033\033[0;34m- Running helm template in %s \n\033[0m' "$chart_name"

    for values_file in "$chart_path"/values.yaml $(< "$ci_values_file_list"); do
        if [[ ! -f "$values_file" ]] || [[ "$values_file" = */bitnami/common/* ]];then
            continue
        fi
        values_file_display=${values_file#$chart_path/}

        if ! helm template --values "$values_file" "$chart_path" >> /dev/null; then
            printf '\033[0;31m\U0001F6AB helm template --values %s %s failed.\n\n\033[0m' "$values_file_display" "$chart_path"
            test_failed=1
        fi
    done

    rm "$ci_values_file_list"

    if [[ "$test_failed" = "1" ]]; then
        false
    else
        printf '\033[0;32m\U00002705 helm lint and helm template %s\n\n\033[0m' "$chart_name"
        true
    fi
}
