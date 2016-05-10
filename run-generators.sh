#!/bin/bash

## Runs the helmc generator on all chart templates to create manifests with the
## default configuration. The command used to generate the manifests is the same
## as the one specified in the template.

SCRIPT_DIR=$(dirname $0)
cd $SCRIPT_DIR

BASE_DIR=$PWD
for file in $(grep -r "^#helm:generate" . --exclude-dir=manifests --exclude-dir=_docs --exclude-dir=_tests | cut -d':' -f1)
do
  CHART_DIR=$(echo $file | cut -d'/' -f2)
  TEMPLATE_FILE=$(echo "$file" | cut -d'/' -f3-)
  COMMAND=$(cat $file | grep ^#helm:generate | cut -d' ' -f2- | sed "s|\$HELM_GENERATE_FILE|--force $TEMPLATE_FILE|")
  cd $CHART_DIR
  echo "Running generator: $COMMAND"
  $COMMAND
  cd $BASE_DIR
done
