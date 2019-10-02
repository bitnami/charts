#!/bin/bash

render_and_yaml_lint() {
    local -r chart_path="${1:?missing_chart}"
    local -r path="${2:?missing_file}"
    local -r values="${3:?missing_values}"
    local -r repo_path="$(git rev-parse --show-toplevel)"
    local -r display_chart_path=${chart_path#"$repo_path/"}
    local -r display_values=${values#"$repo_path/"}
    local -r lint_rules="{extends: default, rules: {line-length: disable, trailing-spaces: disable, truthy: enable, document-start: disable, empty-lines: {max-end: 2} }}"
    printf '\033[0;34m- Running yamllint on %s/%s (values: %s)\n\033[0m' "$display_chart_path" "$path" "$display_values"

    if ! helm template --values "$values" "$chart_path" -x "$path" | yamllint -s -d "$lint_rules" -; then
        printf '\033[0;31m\\U0001F6AB (helm template --values %s %s -x %s | yamllint -s -d "%s" -) failed\n\n\033[0m' "$display_values" "$display_chart_path" "$path" "$lint_rules"
        false
    else
        printf '\033[0;32m\U00002705 %s/%s (values: %s)\n\n\033[0m' "$display_chart_path" "$path" "$display_values"
        true
    fi
}

yaml_lint_file() {
    local -r path="${1:?missing_file}"
    local -r lint_rules="{extends: default, rules: {line-length: disable, trailing-spaces: disable, truthy: enable, document-start: disable, empty-lines: {max-end: 2}}}"
    local -r repo_path="$(git rev-parse --show-toplevel)"
    local -r display_path=${path#"$repo_path/"}
    printf '\033[0;34m- Running yamllint on %s\n' "$display_path"
    if ! yamllint -s -d "$lint_rules" "$path"; then
        printf '\033[0;31m\U0001F6AB yamllint -s -d "%s" %s failed\n\n\033[0m' "$lint_rules" "$display_path"
        false
    else
        printf '\033[0;32m\U00002705 %s\n\n\033[0m' "$display_path"
        true
    fi
}

check_yaml_lint() {
    if ! command -v yamllint > /dev/null 2>&1; then
        printf '\033[0;31m\U0001F6AB yamllint is not installed\033[0m'
        printf '  Installation for Linux'
        printf '    pip install --user yamllint'
        printf '  Installation for Mac OS'
        printf '    brew install yamllint'
        exit 1
    fi
}

run_yaml_lint_chart() {
    local -r chart_name="${1:?missing_chart_name}"
    local -r chart_path="$(git rev-parse --show-toplevel)"/"$chart_name"
    local test_failed=0
    for yaml_file in "$chart_path"/values.yaml "$chart_path"/values-production.yaml "$chart_path"/requirements.yaml "$chart_path"/Chart.yaml "$chart_path"/ci/*; do
        if [[ -f "$yaml_file" ]] && ! yaml_lint_file "$yaml_file"; then
            test_failed=1
        fi
    done

    for values_file in "$chart_path"/values.yaml "$chart_path"/ci/*.yaml; do
        if [[ ! -f "$values_file" ]];then
            continue
        fi
        for yaml_file in "$chart_path"/templates/*.yaml; do
            path_basename=templates/$(basename "$yaml_file")
            if ! render_and_yaml_lint "$chart_path" "$path_basename" "$values_file"; then
                test_failed=1
            fi
        done
    done

    if [[ "$test_failed" = "1" ]]; then
        false
    else
        true
    fi
}
