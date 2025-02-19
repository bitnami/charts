#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

cd "${GITHUB_WORKSPACE}/charts" || exit 1

if [[ "$CHART" != "common" && "$CHART" != "fluentd" ]]; then
    readarray -t tag_paths < <(yq e '.. | (path | join("."))' "bitnami/${CHART}/values.yaml" | grep -E '\.tag$' | sed 's/.tag$//g' | sort -u)
    readarray -t registry_paths < <(yq e '.. | (path | join("."))' "bitnami/${CHART}/values.yaml" | grep '\.registry$' | sed 's/.registry$//g' | sort -u)

    # We assume that image objects are those that contain both keys 'tag' and 'registry'
    images_paths=()
    for path in "${tag_paths[@]}"; do
        if echo "${registry_paths[@]}" | grep -w -q "$path"; then
            [[ -n "$path" ]] && images_paths+=("$path")
        fi
    done

    # Get the images defined in the image warning helper
    readarray -d ' ' -t images_list_tmp < <(grep -E 'common.warnings.modifiedImages' "bitnami/${CHART}/templates/NOTES.txt" | sed -E 's/.*\(list (.+)\) "context".*/\1/' | sed 's/.Values.//g')

    # Remove any empty element from the array
    images_list=()
    for i in "${images_list_tmp[@]}"; do
        if echo "$i" | grep -q -E "\S+"; then
            images_list+=("$i")
        fi
    done

    # Compare the image objects and the image warning list
    if [[ ${#images_list[@]} -eq ${#images_paths[@]} ]]; then
        for path in "${images_list[@]}"; do
            if ! echo "${images_paths[*]}" | grep -w -q "$path"; then
                echo "Found inconsistencies in the images warning list: '${images_list[*]}' should be equal to '${images_paths[*]}'"
                exit 1
            fi
        done
    else
        echo "Found inconsistencies in the images warning list: '${images_list[*]}' should be equal to '${images_paths[*]}'"
        exit 1
    fi
fi
