#!/usr/bin/env bash

echo "checking pre-reqs..."
command -v yq >/dev/null || apt-get update >/dev/null && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends yq >/dev/null
command -v yq >/dev/null || (echo "FATAL: Required package 'yq' missing and failed to install" && exit 1)

if [[ -n "$1" ]]; then
  chart_name=$1
else
  read -r -p 'Chart name (e.g. my-chart): ' chart_name
fi

if [ ! -d "draft/${chart_name}" ]; then
  echo "draft/${chart_name} not found. Check chart name or run 'make new_chart' to create it."
  exit 1
fi

# Directory containing files to process
TARGET_DIR="draft/${chart_name}"

set -o pipefail
if grep "value: '%%" "${TARGET_DIR}/placeholders.yaml" | sed 's/value://'; then
  echo "Please update or remove the above template placeholders, then re-run the replace/render script"
  exit 1
fi
set +o pipefail

# Read and replace placeholders
while IFS= read -r line
do

    # Extract template and value
    TEMPLATE=$(awk 'BEGIN { FS=":::" } {print $1}' <<<"$line")
    VALUE=$(awk 'BEGIN { FS=":::" } {print $2}' <<<"$line")

    if [[ "$TEMPLATE" == "$VALUE" ]]
    then
        # Skipping $TEMPLATE as it has the same value.
        continue
    fi

    # Use find to recursively locate files and sed to replace the placeholder
    find "$TARGET_DIR" -type f ! -name 'placeholders.yaml' -exec sed -i "s|${TEMPLATE}|${VALUE}|g" {} +

    echo "Replaced '$TEMPLATE' with '$VALUE'."

done < <(yq -r '.placeholders[] | [.tpl, .value] | .[]' "${TARGET_DIR}/placeholders.yaml" | sed 'N;s/\n/:::/')

echo "Chart render complete."