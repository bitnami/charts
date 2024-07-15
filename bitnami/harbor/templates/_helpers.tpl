{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{/*
Set the http prefix if the externalURl doesn't have it
*/}}
{{- define "harbor.externalUrl" -}}
{{- if hasPrefix "http" .Values.externalURL -}}
    {{- print .Values.externalURL -}}
{{- else if and (eq .Values.exposureType "proxy") .Values.nginx.tls.enabled -}}
    {{- printf "https://%s" .Values.externalURL -}}
{{- else if and (eq .Values.exposureType "ingress") .Values.ingress.core.tls -}}
    {{- printf "https://%s" .Values.externalURL -}}
{{- else -}}
    {{- printf "http://%s" .Values.externalURL -}}
{{- end -}}
{{- end -}}

{{- define "harbor.autoGenCertForNginx" -}}
{{- if and (eq .Values.exposureType "proxy") .Values.nginx.tls.enabled (not .Values.nginx.tls.existingSecret) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{- define "harbor.caBundleVolume" -}}
- name: ca-bundle-certs
  secret:
    secretName: {{ .Values.internalTLS.caBundleSecret }}
{{- end -}}

{{- define "harbor.coreOverridesJsonSecret" -}}
{{- if .Values.core.configOverwriteJsonSecret -}}
{{- print .Values.core.configOverwriteJsonSecret }}
{{- else }}
{{- printf "%s-config-override" (include "harbor.core" .) -}}
{{- end -}}
{{- end -}}

{{- define "harbor.caBundleVolumeMount" -}}
- name: ca-bundle-certs
  mountPath: /harbor_cust_cert/custom-ca.crt
  subPath: ca.crt
{{- end -}}

{{/* port is included in this url as a workaround for issue https://github.com/aquasecurity/harbor-scanner-trivy/issues/108 */}}
{{- define "harbor.core.url" -}}
  {{- printf "%s://%s:%d" (ternary "https" "http" .Values.internalTLS.enabled) (include "harbor.core" .) (ternary .Values.core.service.ports.https .Values.core.service.ports.http .Values.internalTLS.enabled | int) -}}
{{- end -}}

{{- define "harbor.jobservice.url" -}}
  {{- printf "%s://%s-jobservice:%d" (ternary "https" "http" .Values.internalTLS.enabled) (include "common.names.fullname" .) (ternary .Values.jobservice.service.ports.https .Values.jobservice.service.ports.http .Values.internalTLS.enabled | int) -}}
{{- end -}}

{{- define "harbor.portal.url" -}}
  {{- printf "%s://%s:%d" (ternary "https" "http" .Values.internalTLS.enabled) (include "harbor.portal" .) (ternary .Values.portal.service.ports.https .Values.portal.service.ports.http .Values.internalTLS.enabled | int) -}}
{{- end -}}

{{- define "harbor.registry.url" -}}
  {{- printf "%s://%s:%d" (ternary "https" "http" .Values.internalTLS.enabled) (include "harbor.registry" .) (ternary .Values.registry.server.service.ports.https .Values.registry.server.service.ports.http .Values.internalTLS.enabled | int ) -}}
{{- end -}}

{{- define "harbor.registryCtl.url" -}}
  {{- printf "%s://%s:%d" (ternary "https" "http" .Values.internalTLS.enabled) (include "harbor.registry" .) (ternary .Values.registry.controller.service.ports.https .Values.registry.controller.service.ports.http .Values.internalTLS.enabled | int ) -}}
{{- end -}}

{{- define "harbor.tokenService.url" -}}
  {{- printf "%s/service/token" (include "harbor.core.url" .) -}}
{{- end -}}

{{- define "harbor.trivy.url" -}}
  {{- printf "%s://%s:%d" (ternary "https" "http" .Values.internalTLS.enabled) (include "harbor.trivy" .) (ternary .Values.trivy.service.ports.https .Values.trivy.service.ports.http .Values.internalTLS.enabled | int) -}}
{{- end -}}

{{- define "harbor.core.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.core.tls.existingSecret (printf "%s-crt" (include "harbor.core" .))) -}}
{{- end -}}

{{/* Jobservice TLS secret name */}}
{{- define "harbor.jobservice.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.jobservice.tls.existingSecret (printf "%s-crt" (include "harbor.jobservice" .))) -}}
{{- end -}}

{{/* Portal TLS secret name */}}
{{- define "harbor.portal.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.portal.tls.existingSecret (printf "%s-crt" (include "harbor.portal" .))) -}}
{{- end -}}

{{/* Registry TLS secret name */}}
{{- define "harbor.registry.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.registry.tls.existingSecret (printf "%s-crt" (include "harbor.registry" .))) -}}
{{- end -}}

{{/* Trivy TLS secret name */}}
{{- define "harbor.trivy.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.trivy.tls.existingSecret (printf "%s-crt" (include "harbor.trivy" .))) -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "harbor.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{- define "harbor.database.host" -}}
{{- if eq .Values.postgresql.architecture "replication" }}
    {{- ternary (printf "%s-primary" (include "harbor.postgresql.fullname" .)) .Values.externalDatabase.host .Values.postgresql.enabled -}}
{{- else }}
    {{- ternary (include "harbor.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled -}}
{{- end -}}
{{- end -}}

{{- define "harbor.database.port" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.username" -}}
{{- ternary "postgres" .Values.externalDatabase.user .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.rawPassword" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- coalesce .Values.global.postgresql.auth.postgresPassword .Values.postgresql.auth.postgresPassword -}}
        {{- else -}}
            {{- .Values.postgresql.auth.postgresPassword -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.postgresPassword -}}
    {{- end -}}
{{- else -}}
    {{- .Values.externalDatabase.password -}}
{{- end -}}
{{- end -}}

{{- define "harbor.database.encryptedPassword" -}}
  {{- include "harbor.database.rawPassword" . | b64enc | quote -}}
{{- end -}}

{{- define "harbor.database.coreDatabase" -}}
{{- ternary "registry" .Values.externalDatabase.coreDatabase .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.sslmode" -}}
{{- ternary "disable" .Values.externalDatabase.sslmode .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Create a default fully qualified app name
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "harbor.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{- define "harbor.redis.host" -}}
{{- ternary (ternary (printf "%s-headless" (include "harbor.redis.fullname" .)) (printf "%s-master" (include "harbor.redis.fullname" .)) .Values.redis.sentinel.enabled) (ternary (printf "%s" .Values.externalRedis.sentinel.hosts) .Values.externalRedis.host .Values.externalRedis.sentinel.enabled) .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.port" -}}
{{- ternary (ternary (int64 .Values.redis.sentinel.service.ports.sentinel) "6379" .Values.redis.sentinel.enabled) .Values.externalRedis.port .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.sentinel.masterSet" -}}
{{- ternary (ternary (printf "%s" .Values.redis.sentinel.masterSet) ("") .Values.redis.sentinel.enabled) (ternary (printf "%s" .Values.externalRedis.sentinel.masterSet) ("") .Values.externalRedis.sentinel.enabled) .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.coreDatabaseIndex" -}}
{{- ternary "0" .Values.externalRedis.coreDatabaseIndex .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.jobserviceDatabaseIndex" -}}
{{- ternary "1" .Values.externalRedis.jobserviceDatabaseIndex .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.registryDatabaseIndex" -}}
{{- ternary "2" .Values.externalRedis.registryDatabaseIndex .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.trivyAdapterDatabaseIndex" -}}
{{- ternary "5" .Values.externalRedis.trivyAdapterDatabaseIndex .Values.redis.enabled -}}
{{- end -}}

{{/*
Return whether Redis&reg; uses password authentication or not
*/}}
{{- define "harbor.redis.auth.enabled" -}}
{{- if or .Values.redis.auth.enabled (and (not .Values.redis.enabled) .Values.externalRedis.password) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{- define "harbor.redis.rawPassword" -}}
  {{- if and (not .Values.redis.enabled) .Values.externalRedis.password -}}
    {{- .Values.externalRedis.password -}}
  {{- end -}}
  {{- if and .Values.redis.enabled .Values.redis.auth.password .Values.redis.auth.enabled -}}
    {{- .Values.redis.auth.password -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redis.escapedRawPassword" -}}
  {{- if (include "harbor.redis.rawPassword" . ) -}}
    {{- include "harbor.redis.rawPassword" . | urlquery | replace "+" "%20" -}}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "harbor.redisForJobservice" -}}
  {{- if and (eq .Values.externalRedis.sentinel.enabled false) (eq .Values.redis.sentinel.enabled false) -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://default:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" .) (include "harbor.redis.port" .) (include "harbor.redis.jobserviceDatabaseIndex" .) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis+sentinel://default:%s@%s:%s/%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.sentinel.masterSet" . ) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis+sentinel://%s:%s/%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.sentinel.masterSet" . ) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "harbor.redisForGC" -}}
  {{- if and (eq .Values.externalRedis.sentinel.enabled false) (eq .Values.redis.sentinel.enabled false) -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://default:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis+sentinel://default:%s@%s:%s/%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.sentinel.masterSet" . ) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis+sentinel://%s:%s/%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.sentinel.masterSet" . ) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redisForTrivyAdapter" -}}
  {{- if and (eq .Values.externalRedis.sentinel.enabled false) (eq .Values.redis.sentinel.enabled false) -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://default:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis+sentinel://default:%s@%s:%s/%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.sentinel.masterSet" . ) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis+sentinel://%s:%s/%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.sentinel.masterSet" . ) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redisForCore" -}}
  {{- if and (eq .Values.externalRedis.sentinel.enabled false) (eq .Values.redis.sentinel.enabled false) -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://default:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis+sentinel://default:%s@%s:%s/%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.sentinel.masterSet" . ) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis+sentinel://%s:%s/%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.sentinel.masterSet" . ) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.portal" -}}
  {{- printf "%s-portal" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.core" -}}
  {{- printf "%s-core" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.redis" -}}
  {{- printf "%s-redis" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.jobservice" -}}
  {{- printf "%s-jobservice" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.registry" -}}
  {{- printf "%s-registry" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.database" -}}
  {{- printf "%s-database" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.trivy" -}}
  {{- printf "%s-trivy" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.nginx" -}}
  {{- printf "%s-nginx" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.exporter" -}}
  {{- printf "%s-exporter" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.ingress" -}}
  {{- printf "%s-ingress" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.noProxy" -}}
  {{- printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" (include "harbor.core" .) (include "harbor.jobservice" .) (include "harbor.database" .) (include "harbor.registry" .) (include "harbor.portal" .) (include "harbor.trivy" .) .Values.proxy.noProxy -}}
{{- end -}}

{{/*
Return the proper Harbor Core image name
*/}}
{{- define "harbor.core.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.core.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Exporter image name
*/}}
{{- define "harbor.exporter.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.exporter.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Portal image name
*/}}
{{- define "harbor.portal.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.portal.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Trivy Adapter image name
*/}}
{{- define "harbor.trivy.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.trivy.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Job Service image name
*/}}
{{- define "harbor.jobservice.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.jobservice.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Registry image name
*/}}
{{- define "harbor.registry.server.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.registry.server.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Registryctl image name
*/}}
{{- define "harbor.registry.controller.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.registry.controller.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Nginx image name
*/}}
{{- define "harbor.nginx.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.nginx.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "harbor.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "harbor.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.core.image .Values.exporter.image .Values.portal.image .Values.jobservice.image .Values.trivy.image .Values.registry.server.image .Values.registry.controller.image .Values.nginx.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "harbor.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.core.image -}}
{{- include "common.warnings.rollingTag" .Values.portal.image -}}
{{- include "common.warnings.rollingTag" .Values.jobservice.image -}}
{{- include "common.warnings.rollingTag" .Values.registry.server.image -}}
{{- include "common.warnings.rollingTag" .Values.registry.controller.image -}}
{{- include "common.warnings.rollingTag" .Values.trivy.image -}}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "harbor.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "harbor.validateValues.postgresqlPassword" .) -}}
{{- $messages := append $messages (include "harbor.validateValues.exposureType" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Harbor - must provide a password for PostgreSQL */}}
{{- define "harbor.validateValues.postgresqlPassword" -}}
{{- if .Values.postgresql.enabled -}}
  {{- if empty (include "harbor.database.rawPassword" .) -}}
harbor: PostgreSQL password
    A database password is required!.
    Please set a password (--set postgresql.auth.postgresPassword="xxxx")
  {{- end -}}
{{- else -}}
  {{- if not .Values.externalDatabase.password -}}
harbor: External PostgreSQL password
    An external database password is required!.
    Please set a password (--set externalDatabase.password="xxxx")
  {{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Harbor - must provide a valid exposureType */}}
{{- define "harbor.validateValues.exposureType" -}}
{{- if and (ne .Values.exposureType "ingress") (ne .Values.exposureType "proxy") -}}
harbor: exposureType
    Invalid exposureType selected. Valid values are "ingress" and
    "proxy". Please set a valid exposureType (--set exposureType="xxxx")
{{- end -}}
{{- end -}}

{{/* lists all tracing related environment variables except for TRACE_SERVICE_NAME, which should be set separately */}}
{{- define "harbor.tracing.envvars" -}}
TRACE_ENABLE: {{ .Values.tracing.enabled | quote }}
TRACE_SAMPLE_RATE: {{ .Values.tracing.sampleRate | quote }}
TRACE_NAMESPACE: {{ .Values.tracing.namespace | quote }}
TRACE_ATTRIBUTES: {{ .Values.tracing.attributes | toJson }}
{{- if .Values.tracing.jaeger.enabled }}
TRACE_JAEGER_ENDPOINT: {{ .Values.tracing.jaeger.endpoint | quote }}
TRACE_JAEGER_USERNAME: {{ .Values.tracing.jaeger.username | quote }}
TRACE_JAEGER_PASSWORD: {{ .Values.tracing.jaeger.password | quote }}
TRACE_JAEGER_AGENT_HOSTNAME: {{ .Values.tracing.jaeger.agentHost | quote }}
TRACE_JAEGER_AGENT_PORT: {{ .Values.tracing.jaeger.agentPort | quote }}
{{- end }}
{{- if .Values.tracing.otel.enabled }}
TRACE_OTEL_ENDPOINT: {{ .Values.tracing.otel.endpoint | quote }}
TRACE_OTEL_URL_PATH: {{ .Values.tracing.otel.urlpath | quote }}
TRACE_OTEL_COMPRESSION: {{ .Values.tracing.otel.compression | quote }}
TRACE_OTEL_TIMEOUT: {{ .Values.tracing.otel.timeout | quote }}
TRACE_OTEL_INSECURE: {{ .Values.tracing.otel.insecure | quote }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use for the Harbor Core
*/}}
{{- define "harbor.core.serviceAccountName" -}}
{{- if .Values.core.serviceAccount.create -}}
    {{ default (include "harbor.core" .) .Values.core.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else -}}
    {{ default "default" .Values.core.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the Harbor Registry
*/}}
{{- define "harbor.registry.serviceAccountName" -}}
{{- if .Values.registry.serviceAccount.create -}}
    {{ default (include "harbor.registry" .) .Values.registry.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else -}}
    {{ default "default" .Values.registry.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the Harbor Portal
*/}}
{{- define "harbor.portal.serviceAccountName" -}}
{{- if .Values.portal.serviceAccount.create -}}
    {{ default (include "harbor.portal" .) .Values.portal.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else -}}
    {{ default "default" .Values.portal.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the Harbor Jobservice
*/}}
{{- define "harbor.jobservice.serviceAccountName" -}}
{{- if .Values.jobservice.serviceAccount.create -}}
    {{ default (include "harbor.jobservice" .) .Values.jobservice.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else -}}
    {{ default "default" .Values.jobservice.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the Harbor Exporter
*/}}
{{- define "harbor.exporter.serviceAccountName" -}}
{{- if .Values.exporter.serviceAccount.create -}}
    {{ default (include "harbor.exporter" .) .Values.exporter.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else -}}
    {{ default "default" .Values.exporter.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the Trivy
*/}}
{{- define "harbor.trivy.serviceAccountName" -}}
{{- if .Values.trivy.serviceAccount.create -}}
    {{ default (include "harbor.trivy" .) .Values.trivy.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else -}}
    {{ default "default" .Values.trivy.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the Harbor Nginx
*/}}
{{- define "harbor.nginx.serviceAccountName" -}}
{{- if .Values.nginx.serviceAccount.create -}}
    {{ default (include "harbor.nginx" .) .Values.nginx.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else -}}
    {{ default "default" .Values.nginx.serviceAccount.name }}
{{- end -}}
{{- end -}}
