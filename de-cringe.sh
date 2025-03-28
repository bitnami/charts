#!/bin/bash

# Replace 'oci://registry-1.docker.io/bitnamicharts' with 'oci://ghcr.io/defenseunicorns/bitferno' in all 'Chart.yaml' files under the 'bitnami' folder
find bitnami -type f -name 'Chart.yaml' -exec sed -i 's|oci://registry-1.docker.io/bitnamicharts|oci://ghcr.io/defenseunicorns/bitferno|g' {} +

# Remove contents of insecureImages template if file contains "relocatedImages"
if grep -q "relocatedImages" bitnami/common/templates/_errors.tpl; then
  sed -i '/{{- \$relocatedImages := list -}}/,/{{- print \$warnString -}}/d' bitnami/common/templates/_errors.tpl
  sed -i '$d' bitnami/common/templates/_errors.tpl
fi

# Remove extra workflows that existin the fork causing conflicts
find .github/workflows -maxdepth 1 -type f ! -name 'publish.yaml' ! -name 'update.yml' -exec rm -f {} + 