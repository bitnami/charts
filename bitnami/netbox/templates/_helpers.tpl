{{/*
Return the proper netbox image name
*/}}
{{- define "netbox.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "netbox.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "netbox.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image  .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the fill relase name
*/}}
{{- define "netbox.names.fullname" -}}
{{ template "common.names.fullname" . }}
{{- end -}}


{{/*
Compile all warnings into a single message.
*/}}
{{- define "netbox.validateValues" -}}
{{- $messages := list -}}
# {{- $messages := append $messages (include "netbox.validateValues.foo" .) -}}
# {{- $messages := append $messages (include "netbox.validateValues.bar" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "netbox.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "netbox.database.host" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- template "netbox.postgresql.fullname" . }}
  {{- else -}}
    {{- .Values.externalDatabase.host -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.database.port" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "5432" -}}
  {{- else -}}
    {{- .Values.externalDatabase.port -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.database.username" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.postgresqlUsername -}}
  {{- else -}}
    {{- .Values.externalDatabase.user -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.database.rawPassword" -}}
  {{- if eq .Values.postgresql.enabled true -}}
      {{- .Values.postgresql.postgresqlPassword -}}
  {{- else -}}
      {{- .Values.externalDatabase.password -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.database.escapedRawPassword" -}}
  {{- include "netbox.database.rawPassword" . | urlquery | replace "+" "%20" -}}
{{- end -}}

{{- define "netbox.database.encryptedPassword" -}}
  {{- include "netbox.database.rawPassword" . | b64enc | quote -}}
{{- end -}}



{{- define "netbox.database" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "netbox" -}}
  {{- else -}}
    {{- .Values.externalDatabase.database -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.database.sslmode" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "disable" -}}
  {{- else -}}
    {{- .Values.externalDatabase.sslmode -}}
  {{- end -}}
{{- end -}}

Create a default fully qualified redis name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "netbox.redis.fullname" -}}
{{- $name := default "redis" .Values.redis.nameOverride -}}
{{- printf "%s-%s-master" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "netbox.redis.taskRedis.host" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- template "netbox.redis.fullname" . -}}
  {{- else -}}
    {{- .Values.externalRedis.taskRedis.host -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.redis.taskRedis.port" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "6379" -}}
  {{- else -}}
    {{- .Values.externalRedis.taskRedis.port -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.redis.cachingRedis.host" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- template "netbox.redis.fullname" . -}}
  {{- else -}}
    {{- .Values.externalRedis.cachingRedis.host -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.redis.cachingRedis.port" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "6379" -}}
  {{- else -}}
    {{- .Values.externalRedis.cachingRedis.port -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.redis.taskRedis.databaseIndex" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "0" }}
  {{- else -}}
    {{- .Values.externalRedis.taskRedis.databaseIndex -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.redis.cachingRedis.databaseIndex" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "1" }}
  {{- else -}}
    {{- .Values.externalRedis.cachingRedis.databaseIndex -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.redis.taskRedis.ssl" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "false" }}
  {{- else -}}
    {{- .Values.externalRedis.taskRedis.ssl -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.redis.cachingRedis.ssl" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "false" }}
  {{- else -}}
    {{- .Values.externalRedis.cachingRedis.ssl -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.redis.taskRedis.rawPassword" -}}
  {{- if and (not .Values.redis.enabled) .Values.externalRedis.taskRedis.password -}}
    {{- .Values.externalRedis.taskRedis.password -}}
  {{- end -}}
  {{- if and .Values.redis.enabled .Values.redis.password .Values.redis.usePassword -}}
    {{- .Values.redis.password -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.redis.cachingRedis.rawPassword" -}}
  {{- if and (not .Values.redis.enabled) .Values.externalRedis.cachingRedis.password -}}
    {{- .Values.externalRedis.cachingRedis.password -}}
  {{- end -}}
  {{- if and .Values.redis.enabled .Values.redis.password .Values.redis.usePassword -}}
    {{- .Values.redis.password -}}
  {{- end -}}
{{- end -}}

{{- define "netbox.redis.escapedRawPassword" -}}
  {{- if (include "netbox.redis.rawPassword" . ) -}}
    {{- include "netbox.redis.rawPassword" . | urlquery | replace "+" "%20" -}}
  {{- end -}}
{{- end -}}
