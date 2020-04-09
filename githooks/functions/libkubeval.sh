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

    local -r ci_values_file_list=$(mktemp)

    if [[ -d "$chart_path"/ci ]]; then
        find "$chart_path"/ci -type f -regex ".*\.yaml" > "$ci_values_file_list"
    fi
    printf '\033[0;34m- Running kubeval in %s \033[0m\n' "$chart_name"

    for values_file in "$chart_path"/values.yaml $(< "$ci_values_file_list"); do
        if [[ ! -f "$values_file" ]];then
            continue
        fi
        values_file_display=${chart_name}/${values_file#$chart_path/}

        for options_str in "--strict" "--strict --openshift"; do
            # Redirect to an output file so we create less verbosity
            cmd_output_file=$(mktemp)
            read -r -a opt_array <<< "$options_str"
            # printf '\033[0;34m- Running helm template --values %s %s | kubeval %s \033[0m\n' "$values_file_display" "$chart_name" "${options_str}"
            if ! helm template --values "$values_file" "$chart_path" | kubeval --ignore-missing-schemas "${opt_array[@]}" > "$cmd_output_file" 2>&1; then
                cat "$cmd_output_file"
                printf '\033[0;31m\U0001F6AB helm template --values %s %s | kubeval --ignore-missing-schemas %s failed.\033[0m\n' "$values_file_display" "$chart_name" "${options_str}"
                test_failed=1
            fi
            rm "$cmd_output_file"
        done
    done

    rm "$ci_values_file_list"

    if [[ "$test_failed" = "1" ]]; then
        false
    else
        printf '\033[0;32m\U00002705 Kubeval %s\n\033[0m' "$chart_name"
        true
    fi
}
