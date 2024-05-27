{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Jenkins image name
*/}}
{{- define "jenkins.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Jenkins agent image name
*/}}
{{- define "jenkins.agent.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.agent.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "jenkins.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "jenkins.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jenkins.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
When using Ingress, it will be set to the Ingress hostname.
*/}}
{{- define "jenkins.host" -}}
{{- if .Values.ingress.enabled }}
{{- .Values.ingress.hostname | default "" -}}
{{- else -}}
{{- .Values.jenkinsHost | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
When using Ingress, it will be set to the Ingress hostname.
*/}}
{{- define "jenkins.configAsCodeCM" -}}
{{- if .Values.configAsCode.existingConfigmap -}}
{{- .Values.configAsCode.existingConfigmap -}}
{{- else -}}
{{- printf "%s-casc" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Jenkins TLS secret name
*/}}
{{- define "jenkins.tlsSecretName" -}}
{{- $secretName := .Values.tls.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Jenkins JKS password secret name
*/}}
{{- define "jenkins.tlsPasswordsSecret" -}}
{{- $secretName := .Values.tls.passwordsSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-tls-pass" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
 We need to adapt the basic Kubernetes resource object to Jenkins agent configuration
*/}}
{{- define "jenkins.agent.resources" -}}
{{ $resources := (dict "limits" (dict) "requests" (dict)) }}
{{- if .Values.agent.resources -}}
    {{ $resources = .Values.agent.resources -}}
{{- else if ne .Values.agent.resourcesPreset "none" -}}
    {{ $resources = include "common.resources.preset" (dict "type" .Values.agent.resourcesPreset) | fromYaml -}}
{{- end -}}
{{- if $resources.limits }}
{{- if $resources.limits.cpu }}
resourceLimitCpu: {{ $resources.limits.cpu }}
{{- end }}
{{- if $resources.limits.memory }}
resourceLimitMemory: {{ $resources.limits.memory }}
{{- end }}
{{- end }}
{{- if $resources.requests }}
{{- if $resources.requests.cpu }}
resourceRequestCpu: {{ $resources.requests.cpu }}
{{- end }}
{{- if $resources.requests.memory }}
resourceRequestMemory: {{ $resources.requests.memory }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "jenkins.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- end -}}
