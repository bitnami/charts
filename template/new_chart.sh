#!/bin/bash

if [[ -n "$1" ]]; then
  chart_name=$1
else
  read -r -p 'Chart name (e.g. my-chart): ' chart_name
fi

echo "checking chart name not already in use..."
if [ -d "bitnami/${chart_name}" ]; then
  echo "bitnami/${chart_name} already exists."
  exit 1
fi
if [ -d "draft/${chart_name}" ]; then
  echo "draft/${chart_name} already exists."
  exit 1
fi

mkdir -p draft
cp -r "template/" "draft/${chart_name}"
cd "draft/${chart_name}" || exit
./prepare-placeholders-config.sh
mv "CHART_NAME" "${chart_name}"
sed -i "s/\/CHART_NAME\//\/${chart_name}\//g" placeholders.yaml
sed -i "s/value: '%%CHART_NAME%%'/value: ${chart_name}/g" placeholders.yaml
sed -i "s/value: '%%TEMPLATE_NAME%%'/value: ${chart_name}/g" placeholders.yaml
rm ./*.sh
echo "New ${chart_name} created from template. Please update draft/${chart_name}/placeholders.yaml with your values, then run 'make render_template' to continue."
