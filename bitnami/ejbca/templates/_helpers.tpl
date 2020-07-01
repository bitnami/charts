{{/*
Expand the name of the chart.
*/}}
{{- define "ejbca.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ejbca.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ejbca.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "ejbca.labels" -}}
app.kubernetes.io/name: {{ include "ejbca.name" . }}
helm.sh/chart: {{ include "ejbca.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Match Labels
*/}}
{{- define "ejbca.matchLabels" -}}
app.kubernetes.io/name: {{ include "ejbca.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper EJBCA image name
*/}}
{{- define "ejbca.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "ejbca.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if or .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "ejbca.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "ejbca.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "ejbca.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.storageClass -}}
              {{- if (eq "-" .Values.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.storageClass -}}
        {{- if (eq "-" .Values.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the correct EJBCA secret.
*/}}
{{- define "ejbca.secretName" -}}
{{- if .Values.existingSecret -}}
    {{- printf "%s" .Values.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "ejbca.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "ejbca.databaseHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" (include "mariadb.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "ejbca.databasePort" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" | quote -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | quote ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Database Name
*/}}
{{- define "ejbca.databaseName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.db.name -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "ejbca.databaseUsername" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.db.user -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Secret Name
*/}}
{{- define "ejbca.databaseSecretName" -}}
{{- if and (.Values.mariadb.enabled) (not .Values.mariadb.existingSecret) -}}
    {{- printf "%s" (include "mariadb.fullname" .) -}}
{{- else if and (.Values.mariadb.enabled) (.Values.mariadb.existingSecret) -}}
    {{- printf "%s" .Values.mariadb.existingSecret -}}
{{- else }}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- printf "%s" .Values.externalDatabase.existingSecret -}}
    {{- else -}}
        {{- printf "%s-%s" .Release.Name "externaldb" -}}
    {{- end -}}
{{- end -}}
{{- end -}}
