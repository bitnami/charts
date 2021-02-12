
{{/*
Create a default fully qualified app name
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "discourse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker image registry secret names
*/}}
{{- define "discourse.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the Discourse secret name
*/}}
{{- define "discourse.secretName" -}}
{{- if .Values.discourse.existingSecret }}
    {{- printf "%s" .Values.discourse.existingSecret -}}
{{- else -}}
    {{- printf "%s-discourse" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the user defined LoadBalancerIP for this release
Note, returns 127.0.0.1 if using ClusterIP.
*/}}
{{- define "discourse.serviceIP" -}}
{{- if eq .Values.service.type "ClusterIP" -}}
127.0.0.1
{{- else -}}
{{- .Values.service.loadBalancerIP | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
If not using ClusterIP, or if a host or LoadBalancerIP is not defined, the value will be empty
*/}}
{{- define "discourse.host" -}}
{{- $host := .Values.discourse.host | default "" -}}
{{- default (include "discourse.serviceIP" .) $host -}}
{{- end -}}

{{/*
Return the proper Discourse image name
*/}}
{{- define "discourse.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Storage Class
*/}}
{{- define "discourse.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence "global" .Values.global) -}}
{{- end -}}

{{/*
Return the Postgresql hostname
*/}}
{{- define "discourse.databaseHost" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" (include "postgresql.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql port
*/}}
{{- define "discourse.databasePort" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "5432" | quote -}}
{{- else -}}
    {{- .Values.externalDatabase.port | quote -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql database name
*/}}
{{- define "discourse.databaseName" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.postgresqlDatabase -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql user
*/}}
{{- define "discourse.databaseUser" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.postgresqlUsername -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object for Postgres should be created
*/}}
{{- define "discourse.postgresql.createSecret" -}}
{{- if and (not .Values.postgresql.enabled) (not .Values.externalDatabase.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql secret name
*/}}
{{- define "discourse.postgresql.secretName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.postgresql.existingSecret }}
        {{- printf "%s" .Values.postgresql.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "postgresql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret }}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-database" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis(TM) hostname
*/}}
{{- define "discourse.redisHost" -}}
{{- if .Values.redis.enabled }}
    {{- printf "%s-master" (include "redis.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalRedis.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis(TM) port
*/}}
{{- define "discourse.redisPort" -}}
{{- if .Values.redis.enabled }}
    {{- printf "6379" | quote -}}
{{- else -}}
    {{- .Values.externalRedis.port | quote -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object for Redis(TM) should be created
*/}}
{{- define "discourse.redis.createSecret" -}}
{{- if and (not .Values.redis.enabled) (not .Values.externalRedis.existingSecret) .Values.externalRedis.password }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis(TM) secret name
*/}}
{{- define "discourse.redis.secretName" -}}
{{- if .Values.redis.enabled }}
    {{- if .Values.redis.existingSecret }}
        {{- printf "%s" .Values.redis.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "redis.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalRedis.existingSecret }}
    {{- printf "%s" .Values.externalRedis.existingSecret -}}
{{- else -}}
    {{- printf "%s-redis" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis(TM) secret key
*/}}
{{- define "discourse.redis.secretPasswordKey" -}}
{{- if and .Values.redis.enabled .Values.redis.existingSecret }}
    {{- required "You need to provide existingSecretPasswordKey when an existingSecret is specified in redis" .Values.redis.existingSecretPasswordKey | printf "%s" }}
{{- else if and (not .Values.redis.enabled) .Values.externalRedis.existingSecret }}
    {{- required "You need to provide existingSecretPasswordKey when an existingSecret is specified in redis" .Values.externalRedis.existingSecretPasswordKey | printf "%s" }}
{{- else -}}
    {{- printf "redis-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return whether Redis(TM) uses password authentication or not
*/}}
{{- define "discourse.redis.usePassword" -}}
{{- if or (and .Values.redis.enabled .Values.redis.usePassword) (and (not .Values.redis.enabled) (or .Values.externalRedis.password .Values.externalRedis.existingSecret)) }}
    {{- true -}}
{{- end -}}
{{- end -}}
