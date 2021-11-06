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
{{- define "imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "concourse.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "concourse.validateValues.enabled" .) -}}
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

{{/*
Return  the proper Storage Class
*/}}
{{- define "concourse.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence "global" .Values.global ) -}}
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
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "concourse.database.host" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- template "concourse.postgresql.fullname" . -}}
  {{- else -}}
    {{- .Values.externalDatabase.host -}}
  {{- end -}}
{{- end -}}

{{- define "concourse.database.port" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "5432" -}}
  {{- else -}}
    {{- .Values.externalDatabase.port -}}
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

{{/* Concourse credential web secret name */}}
{{- define "concourse.web.secretName" -}}
{{- if .Values.web.existingSecret -}}
  {{- .Values.web.existingSecret -}}
{{- else -}}
  {{- printf "%s" (include "concourse.web.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
  Concourse configuration configmap name
*/}}
{{- define "concourse.web.configmapName" -}}
{{- if .Values.web.existingConfigmap -}}
  {{- .Values.web.existingConfigmap -}}
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
{{- $port := printf "%v" .Values.web.tsa.containerPort -}}
{{- printf "%s-gateway:%s" (include "concourse.web.fullname" .) $port -}}
{{- else -}}
{{- range $i, $tsaHost := .Values.worker.tsa.hosts -}}{{- if $i -}},{{ end -}}{{- $tsaHost -}}{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "concourse.postgresql.secretName" -}}
{{- if and (.Values.postgresql.enabled) (not .Values.postgresql.existingSecret) -}}
    {{- printf "%s" (include "concourse.postgresql.fullname" .) -}}
{{- else if and (.Values.postgresql.enabled) (.Values.postgresql.existingSecret) -}}
    {{- printf "%s" .Values.postgresql.existingSecret -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- printf "%s" .Values.externalDatabase.existingSecret -}}
    {{- else -}}
        {{ printf "%s-%s" .Release.Name "externaldb" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "concourse.database.existingsecret.key" -}}
{{- if .Values.postgresql.enabled -}}
    {{- printf "%s" "postgresql-password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- printf "%s" "postgresql-password" -}}
        {{- end -}}
    {{- else -}}
        {{- printf "%s" "postgresql-password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}
