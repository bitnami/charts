{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "airflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "airflow.fullname" -}}
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
{{- define "airflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "airflow.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "airflow.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Full path to CA Cert file
*/}}
{{- define "airflow.ldapCAFilename"}}
{{- printf "/opt/bitnami/airflow/certs/%s" .Values.ldap.tls.CAcertificateFilename -}}
{{- end -}}

{{/*
Fully qualified app name for LDAP
*/}}
{{- define "airflow.ldap" -}}
{{- printf "%s-ldap" (include "airflow.fullname" .) -}}
{{- end -}}

{{/*
Return the LDAP credentials secret.
*/}}
{{- define "airflow.ldapSecretName" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.ldap }}
        {{- if .Values.global.ldap.existingSecret }}
            {{- printf "%s" .Values.global.ldap.existingSecret -}}
        {{- else if .Values.ldap.existingSecret -}}
            {{- printf "%s" .Values.ldap.existingSecret -}}
        {{- else -}}
            {{- printf "%s" (include "airflow.ldap" .) -}}
        {{- end -}}
     {{- else if .Values.ldap.existingSecret -}}
         {{- printf "%s" .Values.ldap.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "airflow.ldap" .) -}}
     {{- end -}}
{{- else -}}
     {{- if .Values.ldap.existingSecret -}}
         {{- printf "%s" .Values.ldap.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "airflow.ldap" .) -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "airflow.labels" -}}
app.kubernetes.io/name: {{ template "airflow.name" . }}
helm.sh/chart: {{ template "airflow.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Return the proper Airflow image name
*/}}
{{- define "airflow.image" -}}
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
Return the proper Airflow Scheduler image name
*/}}
{{- define "airflow.schedulerImage" -}}
{{- $registryName := .Values.schedulerImage.registry -}}
{{- $repositoryName := .Values.schedulerImage.repository -}}
{{- $tag := .Values.schedulerImage.tag | toString -}}
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
Return the proper Airflow Worker image name
*/}}
{{- define "airflow.workerImage" -}}
{{- $registryName := .Values.workerImage.registry -}}
{{- $repositoryName := .Values.workerImage.repository -}}
{{- $tag := .Values.workerImage.tag | toString -}}
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
Return the proper git image name
*/}}
{{- define "git.image" -}}
{{- $registryName := .Values.git.registry -}}
{{- $repositoryName := .Values.git.repository -}}
{{- $tag := .Values.git.tag | toString -}}
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
Return the proper Airflow Metrics image name
*/}}
{{- define "airflow.metrics.image" -}}
{{- $registryName := .Values.metrics.image.registry -}}
{{- $repositoryName := .Values.metrics.image.repository -}}
{{- $tag := .Values.metrics.image.tag | toString -}}
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
{{- define "airflow.imagePullSecrets" -}}
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
{{- else if or .Values.image.pullSecrets .Values.schedulerImage.pullSecrets .Values.workerImage.pullSecrets .Values.git.pullSecrets .Values.metrics.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.schedulerImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.workerImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.git.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.metrics.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if or .Values.image.pullSecrets .Values.schedulerImage.pullSecrets .Values.workerImage.pullSecrets .Values.git.pullSecrets .Values.metrics.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.schedulerImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.workerImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.git.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.metrics.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

Create a default fully qualified redis name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.redis.fullname" -}}
{{- $name := default "redis" .Values.redis.nameOverride -}}
{{- printf "%s-%s-master" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the Redis credentials secret.
*/}}
{{- define "airflow.redis.secretName" -}}
{{- if and (.Values.redis.enabled) (not .Values.redis.existingSecret) -}}
    {{/* Create a template for the redis secret
    We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
    */}}
    {{- $name := default "redis" .Values.redis.nameOverride -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else if and (.Values.redis.enabled) ( .Values.redis.existingSecret) -}}
    {{- printf "%s" .Values.redis.existingSecret -}}
{{- else }}
    {{- if .Values.externalRedis.existingSecret -}}
        {{- printf "%s" .Values.externalRedis.existingSecret -}}
    {{- else -}}
        {{ printf "%s-%s" .Release.Name "externalredis" }}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "airflow.postgresql.secretName" -}}
{{- if and (.Values.postgresql.enabled) (not .Values.postgresql.existingSecret) -}}
    {{- printf "%s" (include "airflow.postgresql.fullname" .) -}}
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
Get the secret name
*/}}
{{- define "airflow.secretName" -}}
{{- if .Values.airflow.auth.existingSecret -}}
{{- printf "%s" .Values.airflow.auth.existingSecret -}}
{{- else -}}
{{- printf "%s" (include "airflow.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "airflow.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "airflow.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "airflow.validateValues.cloneDagFilesFromGit.repositories" .) -}}
{{- $messages := append $messages (include "airflow.validateValues.cloneDagFilesFromGit.repository_details" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Airflow - Atleast one repository details must be provided when "airflow.cloneDagFilesFromGit.enabled" is "true" */}}
{{- define "airflow.validateValues.cloneDagFilesFromGit.repositories" -}}
{{- if and .Values.airflow.cloneDagFilesFromGit.enabled (empty .Values.airflow.cloneDagFilesFromGit.repositories) -}}
{{- if or (empty .Values.airflow.cloneDagFilesFromGit.repository) (empty .Values.airflow.cloneDagFilesFromGit.branch) -}}
airflow: airflow.cloneDagFilesFromGit.repositories
    At least one repository must be provided when enabling downloading DAG files
    from git repository (--set airflow.cloneDagFilesFromGit.repositories[0].repository="xxx"
    --set airflow.cloneDagFilesFromGit.repositories[0].name="xxx"
    --set airflow.cloneDagFilesFromGit.repositories[0].branch="name")
{{- end -}}
{{- end -}}
{{- end -}}
{{/* Validate values of Airflow - "airflow.cloneDagFilesFromGit.repositories.repository", "airflow.cloneDagFilesFromGit.repositories.name", "airflow.cloneDagFilesFromGit.repositories.branch" must be provided when "airflow.cloneDagFilesFromGit.enabled" is "true" */}}
{{- define "airflow.validateValues.cloneDagFilesFromGit.repository_details" -}}
{{- if .Values.airflow.cloneDagFilesFromGit.enabled -}}
{{- range $index, $repository_detail := .Values.airflow.cloneDagFilesFromGit.repositories }}
{{- if empty $repository_detail.repository -}}
airflow: airflow.cloneDagFilesFromGit.repositories[$index].repository
    The repository must be provided when enabling downloading DAG files
    from git repository (--set airflow.cloneDagFilesFromGit.repositories[$index].repository="xxx")
{{- end -}}
{{- if empty $repository_detail.name -}}
airflow: airflow.cloneDagFilesFromGit.repositories[$index].name
    The name must be provided when enabling downloading DAG files
    from git repository (--set airflow.cloneDagFilesFromGit.repositories[$index].name="xxx")
{{- end -}}
{{- if empty $repository_detail.branch -}}
airflow: airflow.cloneDagFilesFromGit.repositories[$index].branch
    The branch must be provided when enabling downloading DAG files
    from git repository (--set airflow.cloneDagFilesFromGit.repositories[$index].branch="xxx")
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Airflow - "airflow.clonePluginsFromGit.repository" must be provided when "airflow.clonePluginsFromGit.enabled" is "true" */}}
{{- define "airflow.validateValues.clonePluginsFromGit.repository" -}}
{{- if and .Values.airflow.clonePluginsFromGit.enabled (empty .Values.airflow.clonePluginsFromGit.repository) -}}
airflow: airflow.clonePluginsFromGit.repository
    The repository must be provided when enabling downloading plugins
    from git repository (--set airflow.clonePluginsFromGit.repository="xxx")
{{- end -}}
{{- end -}}
{{/* Validate values of Airflow - "airflow.clonePluginsFromGit.branch" must be provided when "airflow.clonePluginsFromGit.enabled" is "true" */}}
{{- define "airflow.validateValues.clonePluginsFromGit.branch" -}}
{{- if and .Values.airflow.clonePluginsFromGit.enabled (empty .Values.airflow.clonePluginsFromGit.branch) -}}
airflow: airflow.clonePluginsFromGit.branch
    The branch must be provided when enabling downloading plugins
    from git repository (--set airflow.clonePluginsFromGit.branch="xxx")
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "airflow.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.schedulerImage.repository) (not (.Values.schedulerImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.schedulerImage.repository }}:{{ .Values.schedulerImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.workerImage.repository) (not (.Values.workerImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.workerImage.repository }}:{{ .Values.workerImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.git.repository) (not (.Values.git.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.git.repository }}:{{ .Values.git.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- end -}}
