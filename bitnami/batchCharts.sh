#!/bin/bash

for item in *; do
  if [ -d "$item" ]; then
    cd "$item" || exit
    CHART="$(basename "$(pwd)")"
    echo "Bitnami chart found: ${CHART}"
    CURRENT_VERSION="$(grep '^version:' 'Chart.yaml' | cut -d' ' -f2)"
    NEW_VERSION="$(/usr/local/bin/semver bump patch $CURRENT_VERSION)"
    echo "-- Bumping version from ${CURRENT_VERSION} to ${NEW_VERSION}"
    sed -i -e "s/${CURRENT_VERSION}/${NEW_VERSION}/g" Chart.yaml
    cd .. || exit
  fi
done
