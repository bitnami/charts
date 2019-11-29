#!/bin/bash

run_version_change_chart() {
    local -r chart_name="${1:?missing_chart_name}"
    local -r chart_path="$(git rev-parse --show-toplevel)"/"$chart_name"
    local test_failed=0

    printf '\033[0;34m- Checking if the version was changed in on %s/Chart.yaml\n\033[0m' "$chart_name"

    if (git diff master "$chart_path"/Chart.yaml | grep "+version:" > /dev/null 2>&1); then
        printf '\033[0;32m\U00002705 %s version updated.\n\n\033[0m' "$chart_name"
    else
        printf '\033[0;31m\U0001F6AB %s version was not updated.\n\n\033[0m' "$chart_name"
        test_failed=1
    fi

    if [[ "$test_failed" = "1" ]]; then
        false
    else
        true
    fi
}
