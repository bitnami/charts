#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Using the Github API to detect the files changed as git merge-base stops working when the branch is behind
files_changed_data="$(gh api --paginate "/repos/${GITHUB_REPOSITORY}/pulls/${PULL_REQUEST_NUMBER}/files")"
files_changed="$(echo "$files_changed_data" | jq -r '.[] | .filename')"
# Adding || true to avoid "Process exited with code 1" errors
charts_dirs_changed="$(echo "$files_changed" | xargs dirname | grep -o "bitnami/[^/]*" | sort | uniq || true)"
# Using grep -c as a better alternative to wc -l when dealing with empty strings."
num_charts_changed="$(echo "$charts_dirs_changed" | grep -c "bitnami" || true)"
num_version_bumps="$(echo "$files_changed_data" | jq -r '[.[] | select(.filename|match("bitnami/[^/]+/Chart.yaml")) | select(.patch|contains("+version")) ] | length' )"
non_readme_files=$(echo "$files_changed" | grep -vc "\.md" || true)

if [[ $(curl -Lks "${PULL_REQUEST_URL}" | jq '.state | index("closed")') != *null* ]]; then
    # The PR for which this workflow run was launched is now closed -> SKIP
    echo "error=The PR for which this workflow run was launched is now closed. The tests will be skipped." >> "$GITHUB_OUTPUT"
    echo "result=skip" >> "$GITHUB_OUTPUT"
elif [[ "$non_readme_files" -le "0" ]]; then
    # The only changes are .md files -> SKIP
    echo "result=skip" >> "$GITHUB_OUTPUT"
elif [[ "$num_charts_changed" -ne "$num_version_bumps" ]]; then
    # Changes done in charts but version not bumped -> ERROR
    echo "error=Detected changes in charts without version bump in Chart.yaml. Charts changed: ${num_charts_changed}. Version bumps detected: ${num_version_bumps}" >> "$GITHUB_OUTPUT"
    echo "result=fail" >> "$GITHUB_OUTPUT"
elif [[ "$num_charts_changed" -eq "1" ]]; then
    # Changes done in only one chart -> OK
    echo "result=ok" >> "$GITHUB_OUTPUT"
    # Extra output: chart name
    chart_name="${charts_dirs_changed//bitnami\/}"
    echo "chart=${chart_name}" >> "$GITHUB_OUTPUT"
    # Extra output: values-updated
    # shellcheck disable=SC2076
    if [[ "${files_changed[*]}" =~ "bitnami/${chart_name}/values.yaml" ]]; then
        echo "values-updated=true" >> "$GITHUB_OUTPUT"
    fi
elif [[ "$num_charts_changed" -le "0" ]]; then
    # Changes done in the bitnami/ folder but not inside a chart subfolder -> SKIP
    echo "error=No changes detected in charts. The rest of the tests will be skipped." >> "$GITHUB_OUTPUT"
    echo "result=skip" >> "$GITHUB_OUTPUT"
else
    # Changes done in more than chart -> SKIP
    echo "error=Changes detected in more than one chart directory. It is strongly advised to change only one chart in a PR. The rest of the tests will be skipped." >> "$GITHUB_OUTPUT"
    echo "result=skip" >> "$GITHUB_OUTPUT"
fi
