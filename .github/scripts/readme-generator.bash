#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

exit_code=0
cd "${GITHUB_WORKSPACE}/charts" || exit 1

echo "Validating README.md for bitnami/${CHART}"

# Validating *.registry parameters
while read -r line; do
    echo "$line" | grep --quiet "\[default: \(REGISTRY_NAME\|\"\"\)\]" || exit_code=$?
done < <(grep "@param\s\+[A-Za-z\.]\+\.registry\s\+" "bitnami/${CHART}/values.yaml")
if [[ $exit_code -ne 0 ]]; then
    echo "error=Please ensure all *.registry params include the [default: REGISTRY_NAME] modifier in the chart bitnami/${CHART}/values.yaml file"
    exit "$exit_code"
fi

# Validating *.repository parameters
while read -r line; do
    param=$(echo "$line" | awk '{print $3}')
    # Checking if it's a image's registry-related param
    registry_param="${param//.repository/.registry}"
    grep --quiet "@param\s\+${registry_param}" "bitnami/${CHART}/values.yaml" && ( echo "$line" | grep --quiet "\[default: \(REPOSITORY_NAME/.*\|\"\"\)\]" || exit_code=$? )
done < <(grep "@param\s\+[A-Za-z\.]\+\.repository\s\+" "bitnami/${CHART}/values.yaml")
if [[ $exit_code -ne 0 ]]; then
    echo "error=Please ensure all *.repository params include the [default: REPOSITORY_NAME] modifier the in the chart bitnami/${CHART}/values.yaml file"
    exit "$exit_code"
fi

# Validating *.tag parameters
grep -v --quiet "@param\s\+[A-Za-z\.]\+\.tag\s\+" "bitnami/${CHART}/values.yaml" || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
    echo "error=Please ensure all *.tag params are skipped (@skip) in the bitnami/${CHART}/values.yaml file"
    exit "$exit_code"
fi
echo "Updating README.md for bitnami/${CHART}"
readme-generator --values "bitnami/${CHART}/values.yaml" --readme "bitnami/${CHART}/README.md" --schema "/tmp/schema.json"

# Commit all changes, if any
if git status -s | grep "bitnami/${CHART}"; then
    git add "bitnami/${CHART}"
    git commit -m "Update README.md with readme-generator-for-helm" --signoff
fi
