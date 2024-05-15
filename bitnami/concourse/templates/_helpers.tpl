{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper web image name
*/}}
{{- define "concourse.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "concourse.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "concourse.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create a default fully qualified web node(s) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "concourse.web.fullname" -}}
{{- printf "%s-web" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified worker node(s) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "concourse.worker.fullname" -}}
{{- printf "%s-worker" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified web node(s) name adding the installation's namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "concourse.web.fullname.namespace" -}}
{{- printf "%s-web" (include "common.names.fullname.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified worker node(s) name adding the installation's namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "concourse.worker.fullname.namespace" -}}
{{- printf "%s-worker" (include "common.names.fullname.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use (worker)
*/}}
{{- define "concourse.worker.serviceAccountName" -}}
{{- if .Values.worker.serviceAccount.create -}}
    {{ default (include "concourse.worker.fullname" .) .Values.worker.serviceAccount.name -}}
{{- else -}}
    {{ default "default" .Values.worker.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (web)
*/}}
{{- define "concourse.web.serviceAccountName" -}}
{{- if .Values.web.serviceAccount.create -}}
    {{ default (include "concourse.web.fullname" .) .Values.web.serviceAccount.name -}}
{{- else -}}
    {{ default "default" .Values.web.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "concourse.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{- define "concourse.database.host" -}}
{{- ternary (include "concourse.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled | quote -}}
{{- end -}}

{{- define "concourse.database.port" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "concourse.database.user" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- coalesce .Values.global.postgresql.auth.username .Values.postgresql.auth.username | quote -}}
        {{- else -}}
            {{- .Values.postgresql.auth.username | quote -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.username | quote -}}
    {{- end -}}
{{- else -}}
    {{- .Values.externalDatabase.user | quote -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "concourse.database.name" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- coalesce .Values.global.postgresql.auth.database .Values.postgresql.auth.database | quote -}}
        {{- else -}}
            {{- .Values.postgresql.auth.database | quote -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.database | quote -}}
    {{- end -}}
{{- else -}}
    {{- .Values.externalDatabase.database | quote -}}
{{- end -}}
{{- end -}}

{{/*
Get the user defined LoadBalancerIP for this release.
Note, returns 127.0.0.1 if using ClusterIP.
*/}}
{{- define "concourse.serviceIP" -}}
{{- if eq .Values.service.web.type "ClusterIP" -}}
127.0.0.1
{{- else -}}
{{- .Values.service.web.loadBalancerIP | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
If not using ClusterIP, or if a host or LoadBalancerIP is not defined, the value will be empty.
When using Ingress, it will be set to the Ingress hostname.
*/}}
{{- define "concourse.host" -}}
{{- if .Values.ingress.enabled -}}
  {{- $host := .Values.ingress.hostname | default "" -}}
  {{- printf "%s://%s" (ternary "https" "http" .Values.web.tls.enabled) (default (include "concourse.serviceIP" .) $host) -}}
{{- else if .Values.web.externalUrl -}}
  {{- $host := .Values.web.externalUrl | default "" -}}
  {{- printf "%s://%s" (ternary "https" "http" .Values.web.tls.enabled) $host -}}
{{- else if (include "concourse.serviceIP" .) -}}
  {{- printf "%s://%s" (ternary "https" "http" .Values.web.tls.enabled) (include "concourse.serviceIP" .) -}}
{{- end -}}
{{- end -}}

{{/* Concourse credential web secret name */}}
{{- define "concourse.web.secretName" -}}
{{- if .Values.web.existingSecret -}}
  {{- printf "%s" .Values.web.existingSecret -}}
{{- else -}}
  {{- printf "%s" (include "concourse.web.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
  Concourse configuration configmap name
*/}}
{{- define "concourse.web.configmapName" -}}
{{- if .Values.web.existingConfigmap -}}
  {{- printf "%s" .Values.web.existingConfigmap -}}
{{- else -}}
  {{- printf "%s" (include "concourse.web.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/* Concourse credential worker secret name */}}
{{- define "concourse.worker.secretName" -}}
{{- if .Values.worker.existingSecret -}}
  {{ .Values.worker.existingSecret -}}
{{- else -}}
  {{- printf "%s" (include "concourse.worker.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Creates the address of the TSA service.
*/}}
{{- define "concourse.web.tsa.address" -}}
{{- if .Values.web.enabled -}}
{{- $port := printf "%v" .Values.web.containerPorts.tsa -}}
{{- printf "%s-gateway:%s" (include "concourse.web.fullname" .) $port -}}
{{- else -}}
{{- range $i, $tsaHost := .Values.worker.tsa.hosts -}}{{- if $i -}},{{ end -}}{{- $tsaHost -}}{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "concourse.postgresql.secretName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- if .Values.global.postgresql.auth.existingSecret }}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "concourse.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "concourse.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "concourse.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- default (printf "%s-externaldb" .Release.Name) (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "concourse.database.existingsecret.key" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "concourse.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "concourse.validateValues.enabled" .) -}}
{{- $messages := append $messages (include "concourse.web.conjur.validateValues" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Check if web or worker are enable */}}
{{- define "concourse.validateValues.enabled" -}}
{{- if not (or .Values.web.enabled .Values.worker.enabled) -}}
concourse: enabled
  Must set either web.enabled or worker.enabled to create a Concourse deployment
{{- end -}}
{{- end -}}

{{/* Check Conjur parameters */}}
{{- define "concourse.web.conjur.validateValues" -}}
{{- if .Values.web.conjur.enabled -}}
{{- if (empty .Values.web.conjur.applianceUrl) -}}
{{- printf "Must set web.conjur.applianceUrl to integrate Conjur. Please set the parameter (--set web.conjur.applianceUrl=\"xxxx\")." -}}
{{- end -}}
{{- if (empty .Values.secrets.conjurAccount) -}}
{{- printf "Must set secrets.conjurAccount to integrate Conjur. Please set the parameter (--set secrets.conjurAccount=\"xxxx\")." -}}
{{- end -}}
{{- if (empty .Values.secrets.conjurAuthnLogin) -}}
{{- printf "Must set secrets.conjurAuthnLogin to integrate Conjur. Please set the parameter (--set secrets.conjurAuthnLogin=\"xxxx\")." -}}
{{- end -}}
{{- if and (empty .Values.secrets.conjurAuthnTokenFile) (empty .Values.secrets.conjurAuthnApiKey) -}}
{{- printf "Must set either secrets.conjurAuthnApiKey or secrets.conjurAuthnTokenFile to integrate Conjur. Please set the parameter (--set secrets.conjurAuthnLogin=\"xxxx\" or --set secrets.conjurAuthnTokenFile=\"xxxx\")" -}}
{{- end -}}
{{- if and .Values.secrets.conjurAuthnTokenFile .Values.secrets.conjurAuthnApiKey -}}
{{- printf "You specified both secrets.conjurAuthnTokenFile and secrets.conjurAuthnApiKey. You can only set one to integrate Conjur." -}}
{{- end -}}
{{- end -}}
{{- end -}}
