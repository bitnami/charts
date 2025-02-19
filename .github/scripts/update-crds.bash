#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

cd "${GITHUB_WORKSPACE}/charts" || exit 1

# Updating CRDs stored at 'bitnami/$CHART/crds', 'bitnami/$CHART/templates/crds', and "bitnami/${CHART}/charts/${CHART}-crds/crds"
mapfile -t crd_files < <(find "bitnami/${CHART}/crds" "bitnami/${CHART}/templates/crds" "bitnami/${CHART}/charts/${CHART}-crds/crds" -name "*.yaml" -o -name "*.yml" 2>/dev/null || true)
for file in "${crd_files[@]}"; do
    # Automatically update CRDs that use the '# Source' header
    source_url_tpl="$(head -n 1 "$file" | grep -E "^# ?Source: ?" | sed -E 's|^# ?Source: ?||' || true)"
    if [[ -n "$source_url_tpl" ]]; then
        # Validate the second line of the CRD file includes the version of the CRD
        crd_version="$(head -n 2 $file | tail -n 1 | grep -E "^# ?Version: ?" | sed -E 's|^# ?Version: ?||' || true)"
        if [[ -z "$crd_version" ]]; then
            echo "error=CRD file '${file}' does not include the '#Version: <version> header'"
            exit 1
        fi
        # Additional headers may be used for extra features
        # Conditional - Adds a conditional {{if}}/{{end}} to the downloaded upstream CRD
        # VersionOf - Name of a subcomponent, its version will be used for CRD tracking instead of the main component version
        # UseKustomize - If set to true, uses Kustomize to render the CRDs
        # RequiresFilter - If set to true, uses yq to filter resources having 'kind: CustomResourceDefinition', useful when using 'install.yaml' file as upstream source
        continue=true
        line_n=2
        extra_headers=""
        CONDITIONAL=""
        SUBCOMPONENT=""
        USE_KUSTOMIZE=""
        REQUIRES_FILTER=""
        while [ "$continue" = true ]; do
            line_n=$((line_n+1))
            line="$(head -n $line_n $file | tail -n 1)"
            if [[ $line =~ ^#\ ?[a-zA-Z]+:\ ? ]]; then
                if [[ $line =~ ^#\ ?Conditional:\ ? ]]; then
                    CONDITIONAL="$(echo $line | sed -E 's|^# ?Conditional: ?||')"
                    CONDITIONAL="{{- if ${CONDITIONAL} }}\n"
                elif [[ $line =~ ^#\ ?VersionOf:\ ? ]]; then
                    SUBCOMPONENT="$(echo $line | sed -E 's|^# ?VersionOf: ?||')"
                elif [[ $line =~ ^#\ ?UseKustomize:\ ? ]]; then
                    USE_KUSTOMIZE="$(echo $line | sed -E 's|^# ?UseKustomize: ?||' || true)"
                elif [[ $line =~ ^#\ ?RequiresFilter:\ ? ]]; then
                    REQUIRES_FILTER="$(echo $line | sed -E 's|^# ?RequiresFilter: ?||' || true)"
                else
                    echo "error=Header ${line} not recognized'"
                    exit 1
                fi
                    extra_headers="${extra_headers}${line}\n"
            else
                continue=false
            fi
        done
        # Obtain the version of the subcomponent if provided, otherwise use the main component version
        if [[ -n "$SUBCOMPONENT" ]]; then
            APP_VERSION="$(cat bitnami/${CHART}/Chart.yaml | grep -E "image: \S+${SUBCOMPONENT}:" | sed -E "s|.*${SUBCOMPONENT}:([0-9\.]+)-.*|\1|")"
        else
            APP_VERSION="$(yq e '.appVersion' bitnami/${CHART}/Chart.yaml)"
        fi
        # Replace version placeholder, if present
        source_url=$(echo "$source_url_tpl" | sed "s/{version}/${APP_VERSION}/")
        # If the application version is newer, automatically update the CRD file
        if [[ "$APP_VERSION" != "$crd_version" ]]; then
            if [[ "$USE_KUSTOMIZE" = "true" ]]; then
                kubectl kustomize "$source_url" > $file
            else
                curl -Lks --fail -o $file "$source_url"
            fi
            if [[ "$REQUIRES_FILTER" = "true" ]]; then
                yq -i e '. | select(.kind == "CustomResourceDefinition") | ... head_comment=""' $file
            fi
            sed -i "1s|^|# Source: ${source_url_tpl}\n# Version: ${APP_VERSION}\n${extra_headers}${CONDITIONAL}|" $file
            if [[ -n "$CONDITIONAL" ]]; then
                echo -E "{{- end }}" >> $file
            fi
            echo "info=CRD file '${file}' automatically updated using source '$source_url'"
        fi
    else
        echo "info=CRD file '$file' does not contain the '#Source' header. Skipping..."
    fi
done

# Commit all changes, if any
if git status -s | grep "bitnami/${CHART}"; then
    git add "bitnami/${CHART}"
    git commit -m "Update CRDs automatically" --signoff
fi
