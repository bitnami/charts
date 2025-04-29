{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Airflow Web server fullname
*/}}
{{- define "airflow.web.fullname" -}}
{{- printf "%s-web" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Airflow Scheduler fullname
*/}}
{{- define "airflow.scheduler.fullname" -}}
{{- printf "%s-scheduler" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Airflow Dag Processor fullname
*/}}
{{- define "airflow.dagProcessor.fullname" -}}
{{- printf "%s-dag-processor" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Airflow Triggerer fullname
*/}}
{{- define "airflow.triggerer.fullname" -}}
{{- printf "%s-triggerer" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Airflow Worker fullname
*/}}
{{- define "airflow.worker.fullname" -}}
{{- printf "%s-worker" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Airflow metrics fullname
*/}}
{{- define "airflow.metrics.fullname" -}}
{{- printf "%s-statsd-metrics" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Airflow image name
*/}}
{{- define "airflow.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
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
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Get the Redis&reg; fullname
*/}}
{{- define "airflow.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified redis name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.redis.host" -}}
{{- if .Values.redis.enabled -}}
    {{- printf "%s-master" (include "airflow.redis.fullname" .) -}}
{{- else -}}
    {{- printf "%s" (tpl .Values.externalRedis.host $) -}}
{{- end -}}
{{- end -}}

{{/*
Get the Redis&reg; port
*/}}
{{- define "airflow.redis.port" -}}
{{- if .Values.redis.enabled -}}
    {{- print .Values.redis.master.service.ports.redis -}}
{{- else -}}
    {{- print .Values.externalRedis.port  -}}
{{- end -}}
{{- end -}}

{{/*
Get the Redis&reg; credentials secret.
*/}}
{{- define "airflow.redis.secretName" -}}
{{- if .Values.redis.enabled -}}
    {{- if .Values.redis.auth.existingSecret -}}
        {{- print (tpl .Values.redis.auth.existingSecret .) -}}
    {{- else -}}
        {{- print (include "airflow.redis.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalRedis.existingSecret -}}
    {{- print (tpl .Values.externalRedis.existingSecret .) -}}
{{- else -}}
    {{- printf "%s-externalredis" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "airflow.database.secretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- $existingSecret := coalesce (((.Values.global.postgresql).auth).existingSecret) .Values.postgresql.auth.existingSecret -}}
    {{- if $existingSecret -}}
        {{- print (tpl $existingSecret .) -}}
    {{- else -}}
        {{- print (include "airflow.postgresql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- print (tpl .Values.externalDatabase.existingSecret .) -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the secret name
*/}}
{{- define "airflow.secretName" -}}
{{- if .Values.auth.existingSecret -}}
    {{- print (tpl .Values.auth.existingSecret .) -}}
{{- else -}}
    {{- print (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the configmap name
*/}}
{{- define "airflow.configMapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- print (tpl .Values.existingConfigmap .) -}}
{{- else -}}
    {{- print (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the configmap name for Airflow Webserver
*/}}
{{- define "airflow.web.configMapName" -}}
{{- if .Values.web.existingConfigmap -}}
    {{- print (tpl .Values.web.existingConfigmap .) -}}
{{- else -}}
    {{- print (include "airflow.web.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the configmap name for StatsD exporter
*/}}
{{- define "airflow.metrics.configMapName" -}}
{{- if .Values.metrics.existingConfigmap -}}
    {{- print (tpl .Values.metrics.existingConfigmap .) -}}
{{- else -}}
    {{- print (include "airflow.metrics.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the TLS certificates for Airflow webserver
*/}}
{{- define "airflow.web.tls.secretName" -}}
{{- if or .Values.web.tls.autoGenerated.enabled (and (not (empty .Values.web.tls.cert)) (not (empty .Values.web.tls.key))) -}}
    {{- printf "%s-crt" (include "airflow.web.fullname" .) -}}
{{- else -}}
    {{- required "An existing secret name must be provided with TLS certs for Airflow webserver if cert and key are not provided!" (tpl .Values.web.tls.existingSecret .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the LDAP credentials secret.
*/}}
{{- define "airflow.ldap.secretName" -}}
{{- if .Values.ldap.existingSecret -}}
    {{- print (tpl .Values.ldap.existingSecret .) -}}
{{- else -}}
    {{- printf "%s-ldap" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret name containing the SSH keys for loading DAGs Git repositories
*/}}
{{- define "airflow.dags.ssh.secretName" -}}
{{- if .Values.dags.existingSshKeySecret -}}
    {{- print (tpl .Values.dags.existingSshKeySecret .) -}}
{{- else -}}
    {{- printf "%s-ssh" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret name containing the SSH keys for loading plugins Git repositories
*/}}
{{- define "airflow.plugins.ssh.secretName" -}}
{{- if .Values.plugins.existingSshKeySecret -}}
    {{- print (tpl .Values.plugins.existingSshKeySecret .) -}}
{{- else -}}
    {{- printf "%s-ssh" (include "common.names.fullname" .) -}}
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
Return true if a SQL connection string is used to connect to the database
*/}}
{{- define "airflow.database.useSqlConnection" -}}
{{- if and (not .Values.postgresql.enabled) (or .Values.externalDatabase.sqlConnection (and .Values.externalDatabase.existingSecret .Values.externalDatabase.existingSecretSqlConnectionKey)) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "airflow.database.host" -}}
{{- if eq .Values.postgresql.architecture "replication" }}
{{- (ternary (include "airflow.postgresql.fullname" .) (tpl .Values.externalDatabase.host $) .Values.postgresql.enabled | printf "%s-primary") | quote -}}
{{- else -}}
{{- ternary (include "airflow.postgresql.fullname" .) (tpl .Values.externalDatabase.host $) .Values.postgresql.enabled | quote -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "airflow.database.user" -}}
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
{{- define "airflow.database.name" -}}
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
Add environment variables to configure database values
*/}}
{{- define "airflow.database.secretKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- if and .Values.externalDatabase.existingSecret .Values.externalDatabase.existingSecretSqlConnectionKey -}}
        {{- print (tpl .Values.externalDatabase.existingSecretSqlConnectionKey .) -}}
    {{- else if .Values.externalDatabase.existingSecret -}}
        {{- default "password" (tpl .Values.externalDatabase.existingSecretPasswordKey .) -}}
    {{- else -}}
        {{- ternary "password" "sql-connection" (empty .Values.externalDatabase.sqlConnection) -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "airflow.database.port" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "airflow.redis.existingsecret.key" -}}
{{- if .Values.redis.enabled -}}
    {{- printf "%s" "redis-password" -}}
{{- else -}}
    {{- if .Values.externalRedis.existingSecret -}}
        {{- if .Values.externalRedis.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalRedis.existingSecretPasswordKey -}}
        {{- else -}}
            {{- printf "%s" "redis-password" -}}
        {{- end -}}
    {{- else -}}
        {{- printf "%s" "redis-password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure airflow common values
*/}}
{{- define "airflow.configure.airflow.common" -}}
- name: BITNAMI_DEBUG
  value: {{ ternary "true" "false" (or .Values.image.debug .Values.diagnosticMode.enabled) | quote }}
{{- if .Values.usePasswordFiles }}
- name: AIRFLOW__CORE__FERNET_KEY_CMD
  value: "cat /opt/bitnami/airflow/secrets/airflow-fernet-key"
- name: AIRFLOW__WEBSERVER__SECRET_KEY_CMD
  value: "cat /opt/bitnami/airflow/secrets/airflow-secret-key"
{{- if (include "airflow.isImageMajorVersion3" .) }}
- name: AIRFLOW__API_AUTH__JWT_SECRET_CMD
  value: "cat /opt/bitnami/airflow/secrets/airflow-jwt-secret-key"
{{- end }}
{{- else }}
- name: AIRFLOW__CORE__FERNET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "airflow.secretName" . }}
      key: airflow-fernet-key
- name: AIRFLOW__WEBSERVER__SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "airflow.secretName" . }}
      key: airflow-secret-key
{{- if (include "airflow.isImageMajorVersion3" .) }}
- name: AIRFLOW__API_AUTH__JWT_SECRET_CMD
  valueFrom:
    secretKeyRef:
      name: {{ include "airflow.secretName" . }}
      key: airflow-jwt-secret-key
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get the user defined LoadBalancerIP for this release.
Note, returns 127.0.0.1 if using ClusterIP.
*/}}
{{- define "airflow.serviceIP" -}}
{{- if eq .Values.service.type "ClusterIP" -}}
127.0.0.1
{{- else -}}
{{- .Values.service.loadBalancerIP | default "127.0.0.1" -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
If not using ClusterIP, or if a host or LoadBalancerIP is not defined, the value will be empty.
*/}}
{{- define "airflow.baseUrl" -}}
{{- $host := default (include "airflow.serviceIP" .) .Values.web.baseUrl -}}
{{- $port := printf ":%d" (int .Values.service.ports.http) -}}
{{- $schema := ternary "https://" "http://" (or .Values.web.tls.enabled (and .Values.ingress.enabled .Values.ingress.tls)) -}}
{{- if regexMatch "^https?://" .Values.web.baseUrl -}}
  {{- $schema = "" -}}
{{- end -}}
{{- if or (regexMatch ":\\d+$" .Values.web.baseUrl) (eq $port ":80") (eq $port ":443") -}}
  {{- $port = "" -}}
{{- end -}}
{{- if and .Values.ingress.enabled .Values.ingress.hostname -}}
  {{- $host = .Values.ingress.hostname -}}
{{- end -}}
{{- printf "%s%s%s" $schema $host $port -}}
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
{{- $messages := append $messages (include "airflow.validateValues.triggerer.replicaCount" .) -}}
{{- $messages := append $messages (include "airflow.validateValues.metrics" . ) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Airflow - At least one repository details must be provided when "dags.enabled" is "true"
*/}}
{{- define "airflow.validateValues.dags.repositories" -}}
{{- if and .Values.dags.enabled (empty .Values.dags.repositories) (empty .Values.dags.existingConfigmap) -}}
airflow: dags.repositories
    At least one repository must be provided when enabling downloading DAG files
    from git repositories (--set dags.repositories[0].repository="xxx"
    --set dags.repositories[0].name="xxx"
    --set dags.repositories[0].branch="name")
{{- end -}}
{{- end -}}

{{/*
Validate values of Airflow - "dags.repositories.repository", "dags.repositories.name", "dags.repositories.branch" must be provided when "dags.enabled" is "true"
*/}}
{{- define "airflow.validateValues.dags.repository_details" -}}
{{- if .Values.dags.enabled -}}
{{- range $index, $repository_detail := .Values.dags.repositories }}
{{- if empty $repository_detail.repository -}}
airflow: dags.repositories[$index].repository
    The repository must be provided when enabling downloading DAG files
    from git repository (--set dags.repositories[$index].repository="xxx")
{{- end -}}
{{- if empty $repository_detail.branch -}}
airflow: dags.repositories[$index].branch
    The branch must be provided when enabling downloading DAG files
    from git repository (--set dags.repositories[$index].branch="xxx")
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Airflow - "plugins.repositories" must be provided when "plugins.enabled" is "true"
*/}}
{{- define "airflow.validateValues.plugins.repositories" -}}
{{- if and .Values.plugins.enabled (empty .Values.plugins.repositories) -}}
airflow: plugins.repositories
    At least one repository must be provided when enabling downloading plugins
    from git repositories (--set plugins.repositories[0].repository="xxx"
    --set plugins.repositories[0].name="xxx"
    --set plugins.repositories[0].branch="name")
{{- end -}}
{{- end -}}

{{/*
Validate values of Airflow - "plugins.repositories.repository", "plugins.repositories.name", "plugins.repositories.branch" must be provided when "plugins.enabled" is "true"
*/}}
{{- define "airflow.validateValues.plugins.repository_details" -}}
{{- if .Values.plugins.enabled -}}
{{- range $index, $repository_detail := .Values.plugins.repositories }}
{{- if empty $repository_detail.repository -}}
airflow: plugins.repositories[$index].repository
    The repository must be provided when enabling downloading DAG files
    from git repository (--set plugins.repositories[$index].repository="xxx")
{{- end -}}
{{- if empty $repository_detail.branch -}}
airflow: plugins.repositories[$index].branch
    The branch must be provided when enabling downloading DAG files
    from git repository (--set plugins.repositories[$index].branch="xxx")
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Airflow - number of Triggerer replicas
*/}}
{{- define "airflow.validateValues.triggerer.replicaCount" -}}
{{- $replicaCount := int .Values.triggerer.replicaCount }}
{{- if and .Values.triggerer.enabled .Values.triggerer.persistence.enabled .Values.triggerer.persistence.existingClaim (or (gt $replicaCount 1) .Values.triggerer.autoscaling.hpa.enabled) -}}
airflow: triggerer.replicaCount
    A single existing PVC cannot be shared between multiple replicas.
    Please set a valid number of replicas (--set triggerer.replicaCount=1),
    disable HPA (--set triggerer.autoscaling.hpa.enabled=false), disable persistence
    (--set triggerer.persistence.enabled=false) or rely on dynamic provisioning via Persistent
    Volume Claims (--set triggerer.persistence.existingClaim="").
{{- end -}}
{{- end -}}

{{/*
Validate values of Airflow - metrics
*/}}
{{- define "airflow.validateValues.metrics" -}}
{{- if and .Values.metrics.enabled (include "airflow.database.useSqlConnection" .) }}
airflow: metrics
    The metrics feature is currently not supported when using an SQL connection string to connect to the database.
{{- end -}}
{{- end -}}

{{/*
In Airflow version 2.1.0, the CeleryKubernetesExecutor requires setting workers with CeleryExecutor in order to work properly.
This is a workaround and is subject to Airflow official resolution.
Ref: https://github.com/bitnami/charts/pull/6096#issuecomment-856499047
*/}}
{{- define "airflow.worker.executor" -}}
{{- print (ternary "CeleryExecutor" .Values.executor (eq .Values.executor "CeleryKubernetesExecutor")) -}}
{{- end -}}

{{/*
Validates a semver constraint
*/}}
{{- define "airflow.semverCondition" -}}
{{- $constraint := .constraint -}}
{{- $imageVersion := .imageVersion -}}

{{/* tag 'latest' is an special case, where we fall to .Chart.AppVersion value */}}
{{- if eq "latest" $imageVersion -}}
{{- $imageVersion = .context.Chart.AppVersion -}}
{{- else -}}
{{- $imageVersion = (index (splitList "-" $imageVersion) 0 ) -}}
{{- end -}}

{{- if semverCompare $constraint $imageVersion -}}
true
{{- end -}}
{{- end -}}

{{/*
Validates the image tag version is equal or higher than 3.0.0
*/}}
{{- define "airflow.isImageMajorVersion3" -}}
{{- include "airflow.semverCondition" (dict "constraint" "^3" "imageVersion" .Values.image.tag "context" $) -}}
{{- end -}}

{{/*
Validates the image tag version is equal or higher than 2.0.0
*/}}
{{- define "airflow.isImageMajorVersion2" -}}
{{- include "airflow.semverCondition" (dict "constraint" "^2" "imageVersion" .Values.image.tag "context" $) -}}
{{- end -}}
