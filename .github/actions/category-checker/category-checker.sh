#!/bin/bash

command=${1:?Missing command}

ALLOWED_CATEGORIES=(Analytics ApplicationServer CMS CRM CertificateAuthority Database DeveloperTools Forum HumanResourceManagement Infrastructure LogManagement MachineLearning ProjectManagement Wiki WorkFlow E-Commerce eLearning)

if [[ "$command" == "check-categories" ]]; then
  modified_charts=($(ct --config /ct-config.yaml list-changed))
  if [[ -z "$modified_charts" ]]; then
    echo "::set-output name=categories-are-correct::true"
  else
    success=false
    for chart in "${modified_charts[@]}"; do
      category=$(yq -r .annotations.category "bitnami/${chart}/Chart.yaml")
      [[ ${ALLOWED_CATEGORIES[*]} =~ "$category" ]] && success=true
    done
    if [[ "$success" == "true" ]]; then
      echo "::set-output name=categories-are-correct::true"
    else
      echo "::set-output name=categories-are-correct::false"
      echo "ERROR: Missing or invalid category"
      exit 1 # Exit with non-zero code to make the action fail
    fi
  fi
fi

