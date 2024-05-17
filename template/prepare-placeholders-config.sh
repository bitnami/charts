#!/usr/bin/env bash

echo 'placeholders:' | tee placeholders.yaml >/dev/null

grep -RPo '%%[^%]+%%' ./CHART_NAME \
 | awk -F: '{print $2}' \
 | sort \
 | uniq \
 | xargs -I{} bash -c 'grep -Rn "{}" ./CHART_NAME | while read -r tpl; do echo "    # $tpl"; done; echo -e "  - tpl: \047{}\047\n    value: \047{}\047"; echo' \
 | tee -a placeholders.yaml >/dev/null