{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "airflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "airflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
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
{{- printf "%s-ldap" (include "common.names.fullname" .) -}}
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
Return the proper Airflow image name
*/}}
{{- define "airflow.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Airflow Scheduler image name
*/}}
{{- define "airflow.schedulerImage" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.schedulerImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Airflow Worker image name
*/}}
{{- define "airflow.workerImage" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.workerImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper git image name
*/}}
{{- define "git.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.git.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Airflow Metrics image name
*/}}
{{- define "airflow.metrics.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "airflow.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.schedulerImage .Values.workerImage .Values.git .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
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
    {{/* Create a include for the redis secret
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
{{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Add environmnet variables to configure database values
*/}}
{{- define "airflow.database.host" -}}
{{- ternary (include "airflow.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Add environmnet variables to configure database values
*/}}
{{- define "airflow.database.user" -}}
{{- ternary .Values.postgresql.postgresqlUsername .Values.externalDatabase.user .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Add environmnet variables to configure database values
*/}}
{{- define "airflow.database.name" -}}
{{- ternary .Values.postgresql.postgresqlDatabase .Values.externalDatabase.database .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Add environmnet variables to configure database values
*/}}
{{- define "airflow.database.port" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Add environmnet variables to configure database values
*/}}
{{- define "airflow.configure.database" -}}
- name: AIRFLOW_DATABASE_NAME
  value: {{ include "airflow.database.name" . }}
- name: AIRFLOW_DATABASE_USERNAME
  value: {{ include "airflow.database.user" . }}
- name: AIRFLOW_DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "airflow.postgresql.secretName" . }}
      key: postgresql-password
- name: AIRFLOW_DATABASE_HOST
  value: {{ include "airflow.database.host" . }}
- name: AIRFLOW_DATABASE_PORT_NUMBER
  value: {{ include "airflow.database.port" . }}
{{- end -}}

{{/*
Add environmnet variables to configure redis values
*/}}
{{- define "airflow.configure.redis" -}}
- name: REDIS_HOST
  value: {{ ternary (include "airflow.redis.fullname" .) .Values.externalRedis.host .Values.redis.enabled | quote }}
- name: REDIS_PORT_NUMBER
  value: {{ ternary "6379" .Values.externalRedis.port .Values.redis.enabled | quote }}
{{- if and (not .Values.redis.enabled) .Values.externalRedis.username }}
- name: REDIS_USER
  value: {{ .Values.externalRedis.username | quote }}
{{- end }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "airflow.redis.secretName" . }}
      key: redis-password
{{- end -}}

{{/*
Add environmnet variables to configure airflow common values
*/}}
{{- define "airflow.configure.airflow.common" -}}
- name: AIRFLOW_EXECUTOR
  value: "CeleryExecutor"
- name: AIRFLOW_FERNET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "airflow.secretName" . }}
      key: airflow-fernetKey
- name: AIRFLOW_WEBSERVER_HOST
  value: {{ include "common.names.fullname" . }}
- name: AIRFLOW_WEBSERVER_PORT_NUMBER
  value: {{ .Values.service.port | quote }}
- name: AIRFLOW_LOAD_EXAMPLES
  value: {{ ternary "yes" "no" .Values.airflow.loadExamples | quote }}
{{- if .Values.image.debug }}
- name: BASH_DEBUG
  value: "1"
- name: NAMI_DEBUG
  value: "1"
- name: NAMI_LOG_LEVEL
  value: "trace8"
{{- end }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "airflow.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "airflow.validateValues.dags.repositories" .) -}}
{{- $messages := append $messages (include "airflow.validateValues.dags.repository_details" .) -}}
{{- $messages := append $messages (include "airflow.validateValues.plugins.repositories" .) -}}
{{- $messages := append $messages (include "airflow.validateValues.plugins.repository_details" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Airflow - Atleast one repository details must be provided when "git.dags.enabled" is "true" */}}
{{- define "airflow.validateValues.dags.repositories" -}}
  {{- if and .Values.git.dags.enabled (empty .Values.git.dags.repositories) -}}
airflow: git.dags.repositories
    At least one repository must be provided when enabling downloading DAG files
    from git repository (--set git.dags.repositories[0].repository="xxx"
    --set git.dags.repositories[0].name="xxx"
    --set git.dags.repositories[0].branch="name")
  {{- end -}}
{{- end -}}

{{/* Validate values of Airflow - "git.dags.repositories.repository", "git.dags.repositories.name", "git.dags.repositories.branch" must be provided when "git.dags.enabled" is "true" */}}
{{- define "airflow.validateValues.dags.repository_details" -}}
{{- if .Values.git.dags.enabled -}}
{{- range $index, $repository_detail := .Values.git.dags.repositories }}
{{- if empty $repository_detail.repository -}}
airflow: git.dags.repositories[$index].repository
    The repository must be provided when enabling downloading DAG files
    from git repository (--set git.dags.repositories[$index].repository="xxx")
{{- end -}}
{{- if empty $repository_detail.branch -}}
airflow: git.dags.repositories[$index].branch
    The branch must be provided when enabling downloading DAG files
    from git repository (--set git.dags.repositories[$index].branch="xxx")
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Airflow - "git.plugins.repositories" must be provided when "git.plugins.enabled" is "true" */}}
{{- define "airflow.validateValues.plugins.repositories" -}}
  {{- if and .Values.git.plugins.enabled (empty .Values.git.plugins.repositories) -}}
airflow: git.plugins.repositories
    At least one repository must be provided when enabling downloading DAG files
    from git repository (--set git.plugins.repositories[0].repository="xxx"
    --set git.plugins.repositories[0].name="xxx"
    --set git.plugins.repositories[0].branch="name")
  {{- end -}}
{{- end -}}

{{/* Validate values of Airflow - "git.plugins.repositories.repository", "git.plugins.repositories.name", "git.plugins.repositories.branch" must be provided when "git.plugins.enabled" is "true" */}}
{{- define "airflow.validateValues.plugins.repository_details" -}}
{{- if .Values.git.plugins.enabled -}}
{{- range $index, $repository_detail := .Values.git.plugins.repositories }}
{{- if empty $repository_detail.repository -}}
airflow: git.plugins.repositories[$index].repository
    The repository must be provided when enabling downloading DAG files
    from git repository (--set git.plugins.repositories[$index].repository="xxx")
{{- end -}}
{{- if empty $repository_detail.branch -}}
airflow: git.plugins.repositories[$index].branch
    The branch must be provided when enabling downloading DAG files
    from git repository (--set git.plugins.repositories[$index].branch="xxx")
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "airflow.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.schedulerImage }}
{{- include "common.warnings.rollingTag" .Values.workerImage }}
{{- include "common.warnings.rollingTag" .Values.git.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- end -}}
