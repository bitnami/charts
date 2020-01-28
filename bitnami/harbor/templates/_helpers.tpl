{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "harbor.name" -}}
{{- default "harbor" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "harbor.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "harbor.fullname" -}}
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

{{/* Helm required labels */}}
{{- define "harbor.labels" -}}
app.kubernetes.io/name: "{{ template "harbor.name" . }}"
helm.sh/chart: "{{ template "harbor.chart" . }}"
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* matchLabels */}}
{{- define "harbor.matchLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: "{{ template "harbor.name" . }}"
{{- end -}}

{{- define "harbor.autoGenCert" -}}
  {{- if and .Values.service.tls.enabled (not .Values.service.tls.secretName) -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.autoGenCertForIngress" -}}
  {{- if and (eq (include "harbor.autoGenCert" .) "true") (eq .Values.service.type "Ingress") -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.autoGenCertForNginx" -}}
  {{- if and (eq (include "harbor.autoGenCert" .) "true") (ne .Values.service.type "Ingress") -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "harbor.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "harbor.database.host" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- template "harbor.postgresql.fullname" . }}
  {{- else -}}
    {{- .Values.externalDatabase.host -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.port" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "5432" -}}
  {{- else -}}
    {{- .Values.externalDatabase.port -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.username" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.postgresqlUsername -}}
  {{- else -}}
    {{- .Values.externalDatabase.user -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.rawPassword" -}}
  {{- if eq .Values.postgresql.enabled true -}}
      {{- .Values.postgresql.postgresqlPassword -}}
  {{- else -}}
      {{- .Values.externalDatabase.password -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.escapedRawPassword" -}}
  {{- include "harbor.database.rawPassword" . | urlquery | replace "+" "%20" -}}
{{- end -}}

{{- define "harbor.database.encryptedPassword" -}}
  {{- include "harbor.database.rawPassword" . | b64enc | quote -}}
{{- end -}}

{{- define "harbor.database.coreDatabase" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "registry" -}}
  {{- else -}}
    {{- .Values.externalDatabase.coreDatabase -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.clairDatabase" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "postgres" -}}
  {{- else -}}
    {{- .Values.externalDatabase.clairDatabase -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.notaryServerDatabase" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "notaryserver" -}}
  {{- else -}}
    {{- .Values.externalDatabase.notaryServerDatabase -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.notarySignerDatabase" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "notarysigner" -}}
  {{- else -}}
    {{- .Values.externalDatabase.notarySignerDatabase -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.sslmode" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "disable" -}}
  {{- else -}}
    {{- .Values.externalDatabase.sslmode -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.clair" -}}
postgres://{{ template "harbor.database.username" . }}:{{ template "harbor.database.escapedRawPassword" . }}@{{ template "harbor.database.host" . }}:{{ template "harbor.database.port" . }}/{{ template "harbor.database.clairDatabase" . }}?sslmode={{ template "harbor.database.sslmode" . }}
{{- end -}}

{{- define "harbor.database.notaryServer" -}}
postgres://{{ template "harbor.database.username" . }}:{{ template "harbor.database.escapedRawPassword" . }}@{{ template "harbor.database.host" . }}:{{ template "harbor.database.port" . }}/{{ template "harbor.database.notaryServerDatabase" . }}?sslmode={{ template "harbor.database.sslmode" . }}
{{- end -}}

{{- define "harbor.database.notarySigner" -}}
postgres://{{ template "harbor.database.username" . }}:{{ template "harbor.database.escapedRawPassword" . }}@{{ template "harbor.database.host" . }}:{{ template "harbor.database.port" . }}/{{ template "harbor.database.notarySignerDatabase" . }}?sslmode={{ template "harbor.database.sslmode" . }}
{{- end -}}

Create a default fully qualified redis name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "harbor.redis.fullname" -}}
{{- $name := default "redis" .Values.redis.nameOverride -}}
{{- printf "%s-%s-master" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "harbor.redis.host" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- template "harbor.redis.fullname" . -}}
  {{- else -}}
    {{- .Values.externalRedis.host -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redis.port" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "6379" -}}
  {{- else -}}
    {{- .Values.externalRedis.port -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redis.coreDatabaseIndex" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "0" }}
  {{- else -}}
    {{- .Values.externalRedis.coreDatabaseIndex -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redis.jobserviceDatabaseIndex" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "1" }}
  {{- else -}}
    {{- .Values.externalRedis.jobserviceDatabaseIndex -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redis.registryDatabaseIndex" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "2" }}
  {{- else -}}
    {{- .Values.externalRedis.registryDatabaseIndex -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redis.chartmuseumDatabaseIndex" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "3" }}
  {{- else -}}
    {{- .Values.externalRedis.chartmuseumDatabaseIndex -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redis.rawPassword" -}}
  {{- if and (not .Values.redis.enabled) .Values.externalRedis.password -}}
    {{- .Values.externalRedis.password -}}
  {{- end -}}
  {{- if and .Values.redis.enabled .Values.redis.password .Values.redis.usePassword -}}
    {{- .Values.redis.password -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redis.escapedRawPassword" -}}
  {{- if (include "harbor.redis.rawPassword" . ) -}}
    {{- include "harbor.redis.rawPassword" . | urlquery | replace "+" "%20" -}}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "harbor.redisForJobservice" -}}
  {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
    {{- printf "redis://redis:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.jobserviceDatabaseIndex" . ) }}
  {{- else }}
    {{- template "harbor.redis.host" . }}:{{ template "harbor.redis.port" . }}/{{ template "harbor.redis.jobserviceDatabaseIndex" . }}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "harbor.redisForGC" -}}
  {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
    {{- printf "redis://redis:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.registryDatabaseIndex" . ) }}
  {{- else }}
    {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.registryDatabaseIndex" . ) -}}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "harbor.redisForClairAdapter" -}}
  {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
    {{- printf "redis://redis:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.registryDatabaseIndex" . ) }}
  {{- else }}
    {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.registryDatabaseIndex" . ) -}}
  {{- end -}}
{{- end -}}

{{/*
host:port,pool_size,password
100 is the default value of pool size
*/}}
{{- define "harbor.redisForCore" -}}
  {{- template "harbor.redis.host" . }}:{{ template "harbor.redis.port" . }},100,{{ template "harbor.redis.rawPassword" . }}
{{- end -}}

{{- define "harbor.portal" -}}
  {{- printf "%s-portal" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.core" -}}
  {{- printf "%s-core" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.redis" -}}
  {{- printf "%s-redis" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.jobservice" -}}
  {{- printf "%s-jobservice" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.registry" -}}
  {{- printf "%s-registry" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.chartmuseum" -}}
  {{- printf "%s-chartmuseum" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.database" -}}
  {{- printf "%s-database" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.clair" -}}
  {{- printf "%s-clair" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.notary-server" -}}
  {{- printf "%s-notary-server" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.notary-signer" -}}
  {{- printf "%s-notary-signer" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.nginx" -}}
  {{- printf "%s-nginx" (include "harbor.fullname" .) -}}
{{- end -}}

{{- define "harbor.ingress" -}}
  {{- printf "%s-ingress" (include "harbor.fullname" .) -}}
{{- end -}}

Create a default fully qualified nginx name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "harbor.nginx.fullname" -}}
{{- $name := default "nginx" .Values.nginx.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Harbor Core image name
*/}}
{{- define "harbor.coreImage" -}}
{{- $registryName := .Values.coreImage.registry -}}
{{- $repositoryName := .Values.coreImage.repository -}}
{{- $tag := .Values.coreImage.tag | toString -}}
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
Return the proper Harbor Portal image name
*/}}
{{- define "harbor.portalImage" -}}
{{- $registryName := .Values.portalImage.registry -}}
{{- $repositoryName := .Values.portalImage.repository -}}
{{- $tag := .Values.portalImage.tag | toString -}}
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
Return the proper Harbor Job Service image name
*/}}
{{- define "harbor.jobserviceImage" -}}
{{- $registryName := .Values.jobserviceImage.registry -}}
{{- $repositoryName := .Values.jobserviceImage.repository -}}
{{- $tag := .Values.jobserviceImage.tag | toString -}}
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
Return the proper ChartMuseum image name
*/}}
{{- define "harbor.chartMuseumImage" -}}
{{- $registryName := .Values.chartMuseumImage.registry -}}
{{- $repositoryName := .Values.chartMuseumImage.repository -}}
{{- $tag := .Values.chartMuseumImage.tag | toString -}}
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
Return the proper Harbor Notary Server image name
*/}}
{{- define "harbor.notaryServerImage" -}}
{{- $registryName := .Values.notaryServerImage.registry -}}
{{- $repositoryName := .Values.notaryServerImage.repository -}}
{{- $tag := .Values.notaryServerImage.tag | toString -}}
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
Return the proper Harbor Notary Signer image name
*/}}
{{- define "harbor.notarySignerImage" -}}
{{- $registryName := .Values.notarySignerImage.registry -}}
{{- $repositoryName := .Values.notarySignerImage.repository -}}
{{- $tag := .Values.notarySignerImage.tag | toString -}}
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
Return the proper Harbor Registry image name
*/}}
{{- define "harbor.registryImage" -}}
{{- $registryName := .Values.registryImage.registry -}}
{{- $repositoryName := .Values.registryImage.repository -}}
{{- $tag := .Values.registryImage.tag | toString -}}
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
Return the proper Harbor Registryctl image name
*/}}
{{- define "harbor.registryctlImage" -}}
{{- $registryName := .Values.registryctlImage.registry -}}
{{- $repositoryName := .Values.registryctlImage.repository -}}
{{- $tag := .Values.registryctlImage.tag | toString -}}
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
Return the proper Harbor Clair image name
*/}}
{{- define "harbor.clairImage" -}}
{{- $registryName := .Values.clairImage.registry -}}
{{- $repositoryName := .Values.clairImage.repository -}}
{{- $tag := .Values.clairImage.tag | toString -}}
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
Return the proper Harbor Clair image name
*/}}
{{- define "harbor.clairAdapterImage" -}}
{{- $registryName := .Values.clairAdapterImage.registry -}}
{{- $repositoryName := .Values.clairAdapterImage.repository -}}
{{- $tag := .Values.clairAdapterImage.tag | toString -}}
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
Return the proper Nginx image name
*/}}
{{- define "harbor.nginxImage" -}}
{{- $registryName := .Values.nginxImage.registry -}}
{{- $repositoryName := .Values.nginxImage.repository -}}
{{- $tag := .Values.nginxImage.tag | toString -}}
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
{{- define "harbor.imagePullSecrets" -}}
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
{{- else if or .Values.coreImage.pullSecrets .Values.portalImage.pullSecrets .Values.jobserviceImage.pullSecrets .Values.notaryServerImage.pullSecrets .Values.notarySignerImage.pullSecrets .Values.registryImage.pullSecrets .Values.registryctlImage.pullSecrets .Values.nginxImage.pullSecrets .Values.volumePermissions.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.coreImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.portalImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.jobserviceImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.notaryServerImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.notarySignerImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.registryImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.registryctlImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.nginxImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.volumePermissions.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if or .Values.coreImage.pullSecrets .Values.portalImage.pullSecrets .Values.jobserviceImage.pullSecrets .Values.notaryServerImage.pullSecrets .Values.notarySignerImage.pullSecrets .Values.registryImage.pullSecrets .Values.registryctlImage.pullSecrets .Values.nginxImage.pullSecrets .Values.volumePermissions.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.coreImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.portalImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.jobserviceImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.notaryServerImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.notarySignerImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.registryImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.registryctlImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.nginxImage.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.volumePermissions.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "harbor.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.coreImage.repository) (not (.Values.coreImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.coreImage.repository }}:{{ .Values.coreImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.portalImage.repository) (not (.Values.portalImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.portalImage.repository }}:{{ .Values.portalImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.jobserviceImage.repository) (not (.Values.jobserviceImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.jobserviceImage.repository }}:{{ .Values.jobserviceImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.registryImage.repository) (not (.Values.registryImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.registryImage.repository }}:{{ .Values.registryImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.registryctlImage.repository) (not (.Values.registryctlImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.registryctlImage.repository }}:{{ .Values.registryctlImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.nginxImage.repository) (not (.Values.nginxImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.nginxImage.repository }}:{{ .Values.nginxImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "harbor.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "harbor.validateValues.postgresqlPassword" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Harbor - must provide a password for PostgreSQL */}}
{{- define "harbor.validateValues.postgresqlPassword" -}}
{{- if eq .Values.postgresql.enabled true -}}
  {{- if not .Values.postgresql.postgresqlPassword -}}
harbor: PostgreSQL password
    A database password is required!.
    Please set a passsord (--set postgresql.postgresqlPassword="xxxx")
  {{- end -}}
{{- else -}}
  {{- if not .Values.externalDatabase.password -}}
harbor: External PostgreSQL password
    An external database password is required!.
    Please set a passsord (--set externalDatabase.password="xxxx")
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "harbor.volumePermissions.image" -}}
{{- $registryName := .Values.volumePermissions.image.registry -}}
{{- $repositoryName := .Values.volumePermissions.image.repository -}}
{{- $tag := .Values.volumePermissions.image.tag | toString -}}
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
Return the proper Storage Class for chartmuseum
*/}}
{{- define "harbor.chartmuseum.storageClass" -}}
{{- $chartmuseum := .Values.persistence.persistentVolumeClaim.chartmuseum -}}
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
        {{- if $chartmuseum.storageClass -}}
              {{- if (eq "-" $chartmuseum.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" $chartmuseum.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if $chartmuseum.storageClass -}}
        {{- if (eq "-" $chartmuseum.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" $chartmuseum.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Storage Class for jobservice
*/}}
{{- define "harbor.jobservice.storageClass" -}}
{{- $jobservice := .Values.persistence.persistentVolumeClaim.jobservice -}}
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
        {{- if $jobservice.storageClass -}}
              {{- if (eq "-" $jobservice.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" $jobservice.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if $jobservice.storageClass -}}
        {{- if (eq "-" $jobservice.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" $jobservice.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Storage Class for registry
*/}}
{{- define "harbor.registry.storageClass" -}}
{{- $registry := .Values.persistence.persistentVolumeClaim.registry -}}
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
        {{- if $registry.storageClass -}}
              {{- if (eq "-" $registry.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" $registry.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if $registry.storageClass -}}
        {{- if (eq "-" $registry.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" $registry.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "deployment.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "harbor.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "harbor.tplValue" -}}
    {{- if typeIs "string" .value -}}
        {{- tpl .value .context -}}
    {{- else -}}
        {{- tpl (.value | toYaml) .context -}}
    {{- end -}}
{{- end -}}

{{/*
Set the http prefix if the externalURl dont have it
*/}}
{{- define "harbor.externalUrl" -}}
{{- if hasPrefix "http" .Values.externalURL -}}
    {{- print .Values.externalURL -}}
{{- else if .Values.service.tls.enabled -}}
    {{- printf "https://%s" .Values.externalURL -}}
{{- else -}}
    {{- printf "http://%s" .Values.externalURL -}}
{{- end -}}
{{- end -}}
