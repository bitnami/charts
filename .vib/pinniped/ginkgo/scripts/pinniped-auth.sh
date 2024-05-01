#/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# Run pinniped cli to obtain custom kubeconfig and auth into the cluster
pinniped get kubeconfig --concierge-mode ImpersonationProxy --kubeconfig=<(echo $KUBECONFIG | base64 -d | sed "s%server:.*%server: https://${KUBERNETES_SERVICE_HOST}%g") > pinniped-config.yaml
pinniped whoami --kubeconfig=pinniped-config.yaml

echo 'Script finished correctly'
