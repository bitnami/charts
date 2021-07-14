{{/*
Return the proper web image name
*/}}
{{- define "concourse.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.concourse.image "global" .Values.global) }}
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
{{- include "common.images.pullSecrets" (dict "images" (list .Values.concourse.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}


{{/*
Compile all warnings into a single message.
*/}}
{{- define "concourse.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "concourse.validateValues.enabeled" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Check if web or worker are enable */}}
{{- define "concourse.validateValues.enabeled" }}
{{ if not (or .Values.web.enabled .Values.worker.enabled) }}
concourse: enabeled
  Must set either web.enabled or worker.enabled to create a concourse deployment
{{ end }}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
Sometimes GitVersion will contain a `v` so we need
to strip that out.
*/}}
{{- define "concourse.deployment.apiVersion" -}}
{{- $version := include "concourse.kubeVersion" . -}}
{{- if semverCompare "<1.9-0" $version -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
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
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "concourse.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "concourse.database.host" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- template "concourse.postgresql.fullname" . }}
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
Creates the address of the TSA service.
*/}}
{{- define "concourse.web.tsa.address" -}}
{{- $port := .Values.web.tsa.containerPort -}}
{{ template "concourse.web.fullname" . }}-gateway:{{- print $port -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "concourse.postgresql.secretName" -}}
{{- if and (.Values.postgresql.enabled) (not .Values.postgresql.existingSecret) -}}
    {{- printf "%s" (include "concourse.postgresql.fullname" .) -}}
{{- else if and (.Values.postgresql.enabled) (.Values.postgresql.existingSecret) -}}
    {{- printf "%s" .Values.postgresql.existingSecret -}}
{{- else }}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- printf "%s" .Values.externalDatabase.existingSecret -}}
    {{- else -}}
        {{ printf "%s-%s" .Release.Name "externaldb" }}
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
