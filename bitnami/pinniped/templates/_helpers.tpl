{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper concierge image name
*/}}
{{- define "pinniped.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "pinniped.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names using the pinniped.yaml format
{{ include "pinniped.config.imagePullSecrets" ( dict "images" (list .Values.path.to.the.image1, .Values.path.to.the.image2) "global" .Values.global) }}
*/}}
{{- define "pinniped.config.imagePullSecrets" -}}
{{- $pullSecrets := list -}}
{{- if .global -}}
{{- range .global.imagePullSecrets -}}
{{- $pullSecrets = append $pullSecrets . -}}
{{- end -}}
{{- end -}}

{{- range .images -}}
{{- range .pullSecrets -}}
{{- $pullSecrets = append $pullSecrets . -}}
{{- end -}}
{{- end -}}

{{- if (not (empty $pullSecrets)) -}}
imagePullSecrets:
{{- range $pullSecrets | uniq }}
 - {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Pinniped Concierge helpers
*/}}

{{/*
Return the proper Concierge fullname
*/}}
{{- define "pinniped.concierge.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "concierge" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Concierge fullname (with ns)
*/}}
{{- define "pinniped.concierge.fullname.namespace" -}}
{{- printf "%s-%s-%s" (include "common.names.fullname" .) "concierge" (include "common.names.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Concierge API fullname
*/}}
{{- define "pinniped.concierge.api.fullname" -}}
{{- printf "%s-%s" (include "pinniped.concierge.fullname.namespace" .) "api" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper impersonation proxy fullname
*/}}
{{- define "pinniped.concierge.impersonation-proxy.fullname" -}}
{{- printf "%s-%s" (include "pinniped.concierge.fullname" .) "impersonation-proxy" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper impersonation proxy fullname
*/}}
{{- define "pinniped.concierge.kube-cert-agent.fullname" -}}
{{- printf "%s-%s" (include "pinniped.concierge.fullname" .) "kube-cert-agent-server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the Loki configuration configmap.
*/}}
{{- define "pinniped.concierge.configmapName" -}}
{{- if .Values.concierge.existingConfigmap -}}
    {{- .Values.concierge.existingConfigmap -}}
{{- else }}
    {{- printf "%s" (include "pinniped.concierge.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "pinniped.concierge.serviceAccountName" -}}
{{- if .Values.concierge.serviceAccount.concierge.create -}}
    {{ default (include "pinniped.concierge.fullname" .) .Values.concierge.serviceAccount.concierge.name }}
{{- else -}}
    {{ default "default" .Values.concierge.serviceAccount.concierge.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "pinniped.concierge.impersonation-proxy.serviceAccountName" -}}
{{- if .Values.concierge.serviceAccount.impersonationProxy.create -}}
    {{ default (include "pinniped.concierge.impersonation-proxy.fullname" .) .Values.concierge.serviceAccount.impersonationProxy.name }}
{{- else -}}
    {{ default "default" .Values.concierge.serviceAccount.impersonationProxy.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "pinniped.concierge.kube-cert-agent.serviceAccountName" -}}
{{- if .Values.concierge.serviceAccount.kubeCertAgentService.create -}}
    {{ default (include "pinniped.concierge.kube-cert-agent.fullname" .) .Values.concierge.serviceAccount.kubeCertAgentService.name }}
{{- else -}}
    {{ default "default" .Values.concierge.serviceAccount.kubeCertAgentService.name }}
{{- end -}}
{{- end -}}

{{/*
Pinniped Supervisor helpers
*/}}

{{/*
Return the proper Supervisor fullname
*/}}
{{- define "pinniped.supervisor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "supervisor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Supervisor fullname (with ns)
*/}}
{{- define "pinniped.supervisor.fullname.namespace" -}}
{{- printf "%s-%s-%s" (include "common.names.fullname" .) "supervisor" (include "common.names.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Supervisor API fullname
*/}}
{{- define "pinniped.supervisor.api.fullname" -}}
{{- printf "%s-%s" (include "pinniped.supervisor.fullname" .) "api" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the Pinniped Supervisor configuration configmap.
*/}}
{{- define "pinniped.supervisor.configmapName" -}}
{{- if .Values.supervisor.existingConfigmap -}}
    {{- .Values.supervisor.existingConfigmap -}}
{{- else }}
    {{- printf "%s" (include "pinniped.supervisor.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "pinniped.supervisor.serviceAccountName" -}}
{{- if .Values.supervisor.serviceAccount.create -}}
    {{ default (include "pinniped.supervisor.fullname" .) .Values.supervisor.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.supervisor.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "pinniped.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "pinniped.validateValues.deploy" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Loki - Memcached (IndexWrites) */}}
{{- define "pinniped.validateValues.deploy" -}}
{{- if not (or .Values.concierge.enabled .Values.supervisor.enabled) -}}
pinniped: No deployments
    Neither the Concierge of the Supervisor was deployed. Please deploy one of them by setting concierge.enabled=true or supervisor.enabled=true
{{- end -}}
{{- end -}}
