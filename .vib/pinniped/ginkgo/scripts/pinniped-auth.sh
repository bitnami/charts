#/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# Install required packages and download pinniped-cli 
# The version is hardcoded because there is no way to know it in advance. 
install_packages -qq curl
curl -JLks https://get.pinniped.dev/v0.24.0/pinniped-cli-linux-amd64 -o pinniped && chmod +x pinniped

# Run pinniped cli to obtain custom kubeconfig and auth into the cluster
./pinniped get kubeconfig --kubeconfig=<(echo $KUBECONFIG | base64 -d) > pinniped-config.yaml
./pinniped whoami --kubeconfig=pinniped-config.yaml

echo 'Script finished correctly'
