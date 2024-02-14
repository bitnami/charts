{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}
{{/*
Warning about using rolling tag.
Usage:
{{ include "common.warnings.rollingTag" .Values.path.to.the.imageRoot }}
*/}}
{{- define "common.warnings.rollingTag" -}}

{{- if and (contains "bitnami/" .repository) (not (.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .repository }}:{{ .tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/tutorials/understand-rolling-tags-containers
{{- end }}
{{- end -}}

{{/*
Warning about not setting the resource object in all deployments.
Usage:
{{ include "common.warnings.resources" (dict "sections" (list "path1" "path2") context $) }}
Example:
{{- include "common.warnings.resources" (dict "sections" (list "csiProvider.provider" "server" "volumePermissions" "") "context" $) }}
The list in the example assumes that the following values exist:
  - csiProvider.provider.resources
  - server.resources
  - volumePermissions.resources
  - resources
*/}}
{{- define "common.warnings.resources" -}}
{{ $values := .context.Values -}}
{{- range .sections -}}
{{- if eq . "" -}}
{{/* Case where the resources section is at the root (one main deployment in the chart) */}}
{{- if not (index $values "resources") }}

WARNING: Main deployment does not have the "resources" value set. Using "resourcesPreset" is not recommended for production. For production workloads, please set the "resources" value adapted to your workload needs. 
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
{{- end -}}
{{- else -}}
{{/* Case where the are multiple resources sections (more than one main deployment in the chart) */}}
{{- $keys := split "." .}}
{{/* We iterate through the different levels until arriving to the resource section. Example: a.b.c.resources */}}
{{- $section := $values }}
{{- range $keys -}}
{{- $section = index $section . -}}
{{- end -}}
{{- if and (or (not (hasKey $section "enabled")) (index $section "enabled")) (not (index $section "resources")) }}

WARNING: Section {{ . }} does not have the "resources" value set. Using "{{ . }}.resourcesPreset" is not recommended for production. For production workloads, please set the "{{ . }}.resources" value adapted to your workload needs. 
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}
