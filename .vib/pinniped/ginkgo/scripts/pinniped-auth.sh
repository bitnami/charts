#/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# Run pinniped cli to obtain custom kubeconfig and auth into the cluster
pinniped get kubeconfig --kubeconfig=<(echo $KUBECONFIG | base64 -d) > pinniped-config.yaml
pinniped whoami --kubeconfig=pinniped-config.yaml

echo 'Script finished correctly'
