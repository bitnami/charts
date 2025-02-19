#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

cd "${GITHUB_WORKSPACE}/charts" || exit 1

hardcoded_images=()
while read -r image; do
    if [[ -n "$image" && $image != {{*}} ]]; then
        hardcoded_images+=("${image}")
    fi
done <<< "$(grep --exclude "NOTES.txt" -REoh "\s*image:\s+[\"']*.+[\"']*\s*$" "bitnami/${CHART}/templates" | sed "s/image: [\"']*//" | sed "s/[\"']*$//")"

echo "${hardcoded_images[@]}"
if [[ ${#hardcoded_images[@]} -gt 0 ]] ; then
    echo "error=Found hardcoded images in the chart templates: ${hardcoded_images[*]}"
    exit 1
fi
