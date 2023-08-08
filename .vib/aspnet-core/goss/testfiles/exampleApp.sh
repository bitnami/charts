#!/bin/bash
#
# Script to help you configure the ASP.NET example application
#

cd "$(mktemp -d)"
curl -L "https://github.com/dotnet/AspNetCore.Docs/archive/refs/heads/main.zip" -o ./AspNetCoreDocs.zip
unzip -j ./AspNetCoreDocs.zip '*/aspnetcore/performance/caching/output/samples/7.x/*'
rm -rf ./AspNetCoreDocs.zip

echo "##################################################################"
echo "#### Update the runtime-parameters.yaml file with these lines ####"
echo "##################################################################"
echo ""
echo "extraDeploy:"
echo "  - |-"
kubectl create secret generic example-app --from-file=. -o yaml --dry-run=client  | sed 's/^/   /'
