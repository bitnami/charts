#!/usr/bin/env python3
"""Fetch alerting from provided urls into this chart."""
import json
import os
import re
import shutil
import subprocess
import textwrap
from pathlib import Path

import _jsonnet
import yaml
from yaml.representer import SafeRepresenter

ROOT = Path(__file__).parent.parent
ALERTS_OUTPUT_DIR = ROOT.joinpath("templates", "alert-rule")


# https://stackoverflow.com/a/20863889/961092
class LiteralStr(str):
    pass


def change_style(style, representer):
    def new_representer(dumper, data):
        scalar = representer(dumper, data)
        scalar.style = style
        return scalar

    return new_representer


# Alerting rules source
chart = {
    "git": "https://github.com/thanos-io/thanos.git",
    "branch": "main",
    "source": "mixin.libsonnet",
    "cwd": "mixin",
    "destination": ALERTS_OUTPUT_DIR,
    "is_mixin": True,
    "mixin_vars": {"_config+": {}}
}

# Thanos PrometheusRule names to Bitnami parameters map
rule_name_map = {
    'thanos-bucket-replicate': 'replicate',
    'thanos-component-absent': 'absent_rules',
    'thanos-compact': 'compaction',
    'thanos-query': 'query',
    'thanos-receive': 'receive',
    'thanos-rule': 'ruler',
    'thanos-sidecar': 'sidecar',
    'thanos-store': 'store_gateway'
}

replacement_map = {
    'job=~".*thanos-sidecar.*"': {
        'replacement': 'job=~"{{ .Values.metrics.prometheusRule.default.sidecarJobRegex }}"',
        'init': ''
    },
    'runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-': {
        'replacement': 'runbook_url: {{ .Values.metrics.prometheusRule.runbookUrl }}',
        'init': ''
    },
}

# standard header
header = '''{{- /*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{- /*
Generated from '%(name)s' group from %(url)s
Do not change in-place! In order to change this file run the script in
https://github.com/bitnami/charts/tree/main/bitnami/thanos/hack
*/ -}}
{{- if and .Values.metrics.enabled (or .Values.metrics.prometheusRule.default.create %(condition)s ) }}
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: %(name)s
  namespace: {{ default .Release.Namespace .Values.metrics.prometheusRule.namespace | quote }}
  labels: {{- include "common.labels.standard" ( dict "customLabels" .Values.commonLabels "context" $ ) | nindent 4 }}
    {{- if .Values.metrics.prometheusRule.additionalLabels }}
    {{- include "common.tplvalues.render" (dict "value" .Values.metrics.prometheusRule.additionalLabels "context" $) | nindent 4 }}
    {{- end }}
  {{- if .Values.commonAnnotations }}
  annotations: {{- include "common.tplvalues.render" ( dict "value" .Values.commonAnnotations "context" $ ) | nindent 4 }}
  {{- end }}
spec:
  groups:
  -'''

additional_annotation = '''{{- if .Values.commonAnnotations }}
{{- include "common.tplvalues.render" ( dict "value" .Values.commonAnnotations "context" $ ) | nindent 8 }}
{{- end }}'''

additional_rule_labels = '''
{{- if .Values.metrics.prometheusRule.additionalLabels }}
{{- include "common.tplvalues.render" (dict "value" .Values.metrics.prometheusRule.additionalLabels "context" $) | nindent 8 }}
{{- end }}'''


def init_yaml_styles():
    represent_literal_str = change_style('|', SafeRepresenter.represent_str)
    yaml.add_representer(LiteralStr, represent_literal_str)


def escape(s):
    return s.replace("{{", "{{`{{").replace("}}", "}}`}}").replace("{{`{{", "{{`{{`}}").replace("}}`}}", "{{`}}`}}")


def fix_expr(rules):
    """Remove trailing whitespaces and line breaks, which happen to creep in
     due to yaml import specifics;
     convert multiline expressions to literal style, |-"""
    for rule in rules:
        rule['expr'] = rule['expr'].rstrip()
        if '\n' in rule['expr']:
            rule['expr'] = LiteralStr(rule['expr'])


def yaml_str_repr(struct, indent=4):
    """represent yaml as a string"""
    text = yaml.dump(
        struct,
        width=1000,  # to disable line wrapping
        default_flow_style=False  # to disable multiple items on single line
    )
    text = escape(text)  # escape {{ and }} for helm
    text = textwrap.indent(text, ' ' * indent)[indent - 1:]  # indent everything, and remove very first line extra indentation
    return text


def add_rules_conditions(rules, rules_map, indent=4):
    """Add if wrapper for rules, listed in rules_map"""
    rule_condition = '{{- if %s }}\n'
    for alert_name in rules_map:
        line_start = ' ' * indent + '- alert: '
        if line_start + alert_name in rules:
            rule_text = textwrap.indent(rule_condition % rules_map[alert_name], " " * indent)
            start = 0
            # to modify all alerts with same name
            while True:
                try:
                    # add if condition
                    index = rules.index(line_start + alert_name, start)
                    start = index + len(rule_text) + 1
                    rules = rules[:index] + rule_text + rules[index:]
                    # add end of if
                    try:
                        next_index = rules.index(line_start, index + len(rule_text) + 1)
                    except ValueError:
                        # we found the last alert in file if there are no alerts after it
                        next_index = len(rules)

                    # depending on the rule ordering in rules_map it's possible that an if statement from another rule is present at the end of this block.
                    found_block_end = False
                    last_line_index = next_index
                    while not found_block_end:
                        last_line_index = rules.rindex('\n', index, last_line_index - 1)  # find the starting position of the last line
                        last_line = rules[last_line_index + 1:next_index]

                        if last_line.startswith('{{- if'):
                            next_index = last_line_index + 1  # move next_index back if the current block ends in an if statement
                            continue

                        found_block_end = True
                    rules = rules[:next_index] + " " * indent + '{{- end }}\n' + rules[next_index:]
                except ValueError:
                    break
    return rules


def add_rules_per_rule_conditions(rules, group, indent=4):
    """Add if wrapper for rules, listed in alert_condition_map"""
    rules_condition_map = {}
    for rule in group['rules']:
        if 'alert' in rule:
            rules_condition_map[rule['alert']] = f"not (.Values.metrics.prometheusRule.default.disabled.{rule['alert']} | default false)"

    rules = add_rules_conditions(rules, rules_condition_map, indent)
    return rules


def add_custom_labels(rules_str, indent=4, label_indent=2):
    """Add if wrapper for additional rules labels"""
    additional_rule_labels_indented = textwrap.indent(additional_rule_labels, " " * (indent + label_indent * 2))

    # labels: cannot be null, if a rule does not have any labels by default, the labels block
    # should only be added if there are .Values defaultRules.additionalRuleLabels defined
    rule_seperator = "\n" + " " * indent + "-.*"
    label_seperator = "\n" + " " * indent + "  labels:"
    section_seperator = "\n" + " " * indent + r"  \S"
    section_seperator_len = len(section_seperator) - 1
    rules_positions = re.finditer(rule_seperator,rules_str)

    # fetch breakpoint between each set of rules
    ruleStartingLine = [(rule_position.start(), rule_position.end()) for rule_position in rules_positions]

    if not ruleStartingLine:
        return ""

    head = rules_str[:ruleStartingLine[0][0]]

    # construct array of rules so they can be handled individually
    rules = []
    # pylint: disable=E1136
    # See https://github.com/pylint-dev/pylint/issues/1498 for None Values
    previousRule = None
    for r in ruleStartingLine:
        if previousRule is not None:
            rules.append(rules_str[previousRule[0]:r[0]])
        previousRule = r

    rules.append(rules_str[previousRule[0]:len(rules_str)-1])

    for i, rule in enumerate(rules):
        current_label = re.search(label_seperator, rule)
        if current_label:
            # `labels:` block exists
            # determine if there are any existing entries
            entries = re.search(section_seperator, rule[current_label.end():])
            if entries:
                entries_end = entries.end() + current_label.end() - section_seperator_len
                rules[i] = rule[:entries_end] + additional_rule_labels_indented + rule[entries_end:]
            else:
                # `labels:` does not contain any entries
                # append template to label section
                rules[i] += additional_rule_labels_indented
        else:
            # `labels:` block does not exist
            # create it and append template
            rules[i] += " " * indent + "  labels:" + additional_rule_labels_indented
    return head + "".join(rules) + "\n"


def add_custom_annotations(rules, indent=4, annotation_indent=2):
    """Add if wrapper for additional rules annotations"""
    additional_annotation_indented = textwrap.indent(additional_annotation, " " * (indent + annotation_indent * 2))
    annotations = "      annotations:\n"
    annotations_len = len(annotations) + 1
    rule_condition_len = len(additional_annotation_indented) + 1

    separator = " " * indent + "- alert:.*"
    alerts_positions = re.finditer(separator, rules)
    alert = 0

    for alert_position in alerts_positions:
        # Add rule_condition after 'annotations:' statement
        index = alert_position.end() + annotations_len + rule_condition_len * alert
        rules = rules[:index] + additional_annotation_indented + "\n" + rules[index:]
        alert += 1

    return rules


def write_group_to_file(group, url, destination):
    fix_expr(group['rules'])
    group_name = group['name']

    # prepare rules string representation
    rules = yaml_str_repr(group)
    # add replacements of custom variables and include their initialisation in case it's needed
    init_line = ''
    for match_str, replacement in replacement_map.items():
        if group_name in replacement.get('limitGroup', [group_name]) and match_str in rules:
            rules = rules.replace(match_str, replacement['replacement'])
            if replacement['init']:
                init_line += '\n' + replacement['init']

    # append per-alert rules
    rules = add_custom_labels(rules)
    rules = add_custom_annotations(rules)
    rules = add_rules_per_rule_conditions(rules, group)

    # initialize header
    lines = header % {
        'name': sanitize_name(group['name']),
        'url': url,
        'condition': f".Values.metrics.prometheusRule.default.{rule_name_map.get(group['name'], '')}",
        'init_line': init_line,
    }

    # rules themselves
    lines += rules

    # footer
    lines += '{{- end }}'

    filename = rule_name_map.get(group['name'], group['name']) + '.yaml'
    new_filename = "%s/%s" % (destination, filename)

    # make sure directories to store the file exist
    os.makedirs(destination, exist_ok=True)

    # recreate the file
    with open(new_filename, 'w') as f:
        print(lines, file=f)

    print("Generated %s" % new_filename)


def main():
    init_yaml_styles()
    # read the rules, create a new template file per group
    url = chart['git']

    print(f"Clone {url}")
    checkout_dir = Path(os.path.basename(url))
    shutil.rmtree(checkout_dir, ignore_errors=True)

    subprocess.run(
        ["git", "clone", url, "--branch", chart['branch'], "--single-branch", "--depth", "1", checkout_dir],
        check=True
    )

    cwd = Path.cwd()
    source_cwd = chart['cwd']
    mixin_file = chart['source']
    mixin_dir = cwd.joinpath(checkout_dir, source_cwd)
    if os.path.exists(mixin_dir.joinpath("jsonnetfile.json")):
        print("Running jsonnet-bundler, because jsonnetfile.json exists")
        subprocess.run(["jb", "install"], cwd=mixin_dir, check=True)

    if 'content' in chart:
        with open(mixin_dir.joinpath(mixin_file), "w") as f:
            f.write(chart['content'])

    mixin_vars = json.dumps(chart['mixin_vars'])

    print(f"Generating rules from {mixin_file}")
    print(f"Change cwd to {checkout_dir.joinpath(source_cwd)}")
    os.chdir(mixin_dir)

    mixin = """
    local kp =
        { prometheusAlerts+:: {}} +
        (import "%s") +
        %s;

    kp.prometheusAlerts
    """

    alerts = json.loads(_jsonnet.evaluate_snippet(mixin_file, mixin % (mixin_file, mixin_vars), import_callback=jsonnet_import_callback))
    os.chdir(cwd)

    # etcd workaround, their file don't have spec level
    groups = alerts['spec']['groups'] if alerts.get('spec') else alerts['groups']
    for group in groups:
        write_group_to_file(group, url, chart['destination'])

    print("Finished")


def sanitize_name(name):
    return re.sub('[_]', '-', name).lower()


def jsonnet_import_callback(base, rel):
    if "github.com" in base:
        base = os.getcwd() + '/vendor/' + base[base.find('github.com'):]
    elif "github.com" in rel:
        base = os.getcwd() + '/vendor/'

    if os.path.isfile(base + rel):
        return base + rel, open(base + rel).read().encode('utf-8')

    raise RuntimeError('File not found')


if __name__ == '__main__':
    main()
