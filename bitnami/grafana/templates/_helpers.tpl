{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "grafana.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "grafana.fullname" -}}
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
{{- define "grafana.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "grafana.labels" -}}
app.kubernetes.io/name: {{ include "grafana.name" . }}
helm.sh/chart: {{ include "grafana.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "grafana.matchLabels" -}}
app.kubernetes.io/name: {{ include "grafana.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return the proper Grafana image name
*/}}
{{- define "grafana.image" -}}
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
Return the proper Grafana Image Renderer image name
*/}}
{{- define "grafana.imageRenderer.image" -}}
{{- $registryName := .Values.imageRenderer.image.registry -}}
{{- $repositoryName := .Values.imageRenderer.image.repository -}}
{{- $tag := .Values.imageRenderer.image.tag | toString -}}
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
{{- define "grafana.imagePullSecrets" -}}
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
{{- else if or .Values.image.pullSecrets .Values.imageRenderer.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.imageRenderer.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- else if or .Values.image.pullSecrets .Values.imageRenderer.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.imageRenderer.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Return  the proper Storage Class
*/}}
{{- define "grafana.storageClass" -}}
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
Return the Grafana admin credentials secret
*/}}
{{- define "grafana.adminSecretName" -}}
{{- if .Values.admin.existingSecret -}}
    {{- printf "%s" (tpl .Values.admin.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-admin" (include "grafana.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Grafana admin password key
*/}}
{{- define "grafana.adminSecretPasswordKey" -}}
{{- if and .Values.admin.existingSecret .Values.admin.existingSecretPasswordKey -}}
    {{- printf "%s" (tpl .Values.admin.existingSecretPasswordKey $) -}}
{{- else -}}
    {{- printf "GF_SECURITY_ADMIN_PASSWORD" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "grafana.createAdminSecret" -}}
{{- if not .Values.admin.existingSecret }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the Grafana SMTP credentials secret
*/}}
{{- define "grafana.smtpSecretName" -}}
{{- if .Values.smtp.existingSecret }}
    {{- printf "%s" (tpl .Values.smtp.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-smtp" (include "grafana.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Grafana SMTP user key
*/}}
{{- define "grafana.smtpSecretUserKey" -}}
{{- if and .Values.smtp.existingSecret .Values.smtp.existingSecretUserKey -}}
    {{- printf "%s" (tpl .Values.smtp.existingSecretUserKey $) -}}
{{- else -}}
    {{- printf "GF_SMTP_USER" -}}
{{- end -}}
{{- end -}}

{{/*
Return the Grafana SMTP password key
*/}}
{{- define "grafana.smtpSecretPasswordKey" -}}
{{- if and .Values.smtp.existingSecret .Values.smtp.existingSecretPasswordKey -}}
    {{- printf "%s" (tpl .Values.smtp.existingSecretPasswordKey $) -}}
{{- else -}}
    {{- printf "GF_SMTP_PASSWORD" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "grafana.createSMTPSecret" -}}
{{- if and .Values.smtp.enabled (not .Values.smtp.existingSecret) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "grafana.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.imageRenderer.image.repository) (not (.Values.imageRenderer.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.imageRenderer.image.repository }}:{{ .Values.imageRenderer.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- end -}}

{{/*
Validate values for Grafana.
*/}}
{{- define "grafana.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "grafana.validateValues.database" .) -}}
{{- $messages := append $messages (include "grafana.validateValues.configmapsOrSecrets" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the external database
*/}}
{{- define "grafana.validateValues.database" -}}
{{- $replicaCount := int .Values.replicaCount }}
{{- if gt $replicaCount 1 -}}
WARNING: Using more than one replica requires using an external database to share data between Grafana instances.
         By default Grafana uses an internal sqlite3 per instance but you can configure an external MySQL or PostgreSQL.
         Please, ensure you provide a configuration file configuring the external database to share data between replicas.
{{- end -}}
{{- end -}}

{{/*
Function to validate grafana confirmaps and secrets
*/}}
{{- define "grafana.validateValues.configmapsOrSecrets" -}}
{{- if and .Values.config.useGrafanaIniFile (not .Values.config.grafanaIniSecret) (not .Values.config.grafanaIniConfigMap) -}}
WARNING: You enabled config.useGrafanaIniFile but did not specify config.grafanaIniSecret nor config.grafanaIniConfigMap
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "grafana.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "grafana.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either grafana.fullname if serviceAccount.create
is true or default otherwise.
*/}}
{{- define "grafana.serviceAccountName" -}}
    {{- if .Values.serviceAccount.create -}}
        {{ default (include "grafana.fullname" .) .Values.serviceAccount.name }}
    {{- else -}}
        {{ default "default" .Values.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "grafana.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}

