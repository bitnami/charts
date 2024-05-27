{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Parse server client image name
*/}}
{{- define "parse.server.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.server.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Parse dashboard image name
*/}}
{{- define "parse.dashboard.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.dashboard.image "global" .Values.global) }}
{{- end -}}


{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "parse.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "parse.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.server.image .Values.dashboard.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "parse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "parse.server.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper server fullname
*/}}
{{- define "parse.server.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper dashboard fullname
*/}}
{{- define "parse.dashboard.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "dashboard" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "parse.mongodb.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-mongodb" .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-mongodb" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the user defined LoadBalancerIP for this release.
Note, returns 127.0.0.1 if using ClusterIP.
*/}}
{{- define "parse.serviceIP" -}}
{{- if eq .Values.dashboard.service.type "ClusterIP" -}}
127.0.0.1
{{- else -}}
{{- default "" .Values.dashboard.service.loadBalancerIP -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
If not using ClusterIP, or if a host or LoadBalancerIP is not defined, the value will be empty.
*/}}
{{- define "parse.host" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- $host := default "" .Values.server.host -}}
{{- if .Values.ingress.enabled -}}
{{- $ingressHost := .Values.ingress.server.hostname -}}
{{- $serverHost := default $ingressHost $host -}}
{{- default (include "parse.serviceIP" .) $serverHost -}}
{{- else -}}
{{- default (include "parse.serviceIP" .) $host -}}
{{- end -}}
{{- end -}}

{{/*
Gets the port to access Parse outside the cluster.
When using ingress, we should use the port 80/443 instead of service.ports.http
*/}}
{{- define "parse.external-port" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.ingress.enabled -}}
{{- $ingressHttpPort := "80" -}}
{{- $ingressHttpsPort := "443" -}}
{{- if eq .Values.dashboard.parseServerUrlProtocol "https" -}}
{{- $ingressHttpsPort -}}
{{- else -}}
{{- $ingressHttpPort -}}
{{- end -}}
{{- else -}}
{{ .Values.server.containerPorts.http }}
{{- end -}}
{{- end -}}

{{/*
Return the Parse Cloud Clode scripts configmap.
*/}}
{{- define "parse.cloudCodeScriptsCMName" -}}
{{- if .Values.server.existingCloudCodeScriptsCM -}}
    {{- printf "%s" (tpl .Values.server.existingCloudCodeScriptsCM $) -}}
{{- else -}}
    {{- printf "%s-cloud-code-scripts" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "parse.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.server.image }}
{{- include "common.warnings.rollingTag" .Values.dashboard.image }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "parse.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "parse.validateValues.dashboard.serverUrlProtocol" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Parse Dashboard - if tls is enable on server side must provide https protocol
*/}}
{{- define "parse.validateValues.dashboard.serverUrlProtocol" -}}
{{- if .Values.ingress.enabled -}}
{{- if and .Values.ingress.tls (ne $.Values.dashboard.parseServerUrlProtocol "https") -}}
parse: dashboard.parseServerUrlProtocol
    If Parse Server is using ingress with tls enable then It must be set as "https"
    in order to form the URLs with this protocol, in another case, Parse Dashboard will always redirect to "http".
{{- end -}}
{{- end -}}
{{- end -}}
