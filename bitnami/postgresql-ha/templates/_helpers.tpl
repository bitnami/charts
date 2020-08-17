{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postgresql-ha.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postgresql-ha.fullname" -}}
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
{{- define "postgresql-ha.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "postgresql-ha.labels" -}}
app.kubernetes.io/name: {{ template "postgresql-ha.name" . }}
helm.sh/chart: {{ template "postgresql-ha.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "postgresql-ha.matchLabels" -}}
app.kubernetes.io/name: {{ template "postgresql-ha.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Fully qualified app name for PostgreSQL
*/}}
{{- define "postgresql-ha.postgresql" -}}
{{- printf "%s-postgresql" (include "postgresql-ha.fullname" .) -}}
{{- end -}}

{{/*
Fully qualified app name for Pgpool
*/}}
{{- define "postgresql-ha.pgpool" -}}
{{- printf "%s-pgpool" (include "postgresql-ha.fullname" .) -}}
{{- end -}}

{{/*
Fully qualified app name for LDAP
*/}}
{{- define "postgresql-ha.ldap" -}}
{{- printf "%s-ldap" (include "postgresql-ha.fullname" .) -}}
{{- end -}}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "postgresql-ha.postgresqlImage" -}}
{{- $registryName := .Values.postgresqlImage.registry -}}
{{- $repositoryName := .Values.postgresqlImage.repository -}}
{{- $tag := .Values.postgresqlImage.tag | toString -}}
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
Return the proper Pgpool image name
*/}}
{{- define "postgresql-ha.pgpoolImage" -}}
{{- $registryName := .Values.pgpoolImage.registry -}}
{{- $repositoryName := .Values.pgpoolImage.repository -}}
{{- $tag := .Values.pgpoolImage.tag | toString -}}
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
Return the proper PostgreSQL Prometheus exporter image name
*/}}
{{- define "postgresql-ha.volumePermissionsImage" -}}
{{- $registryName := .Values.volumePermissionsImage.registry -}}
{{- $repositoryName := .Values.volumePermissionsImage.repository -}}
{{- $tag := .Values.volumePermissionsImage.tag | toString -}}
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
Return the proper PostgreSQL Prometheus exporter image name
*/}}
{{- define "postgresql-ha.metricsImage" -}}
{{- $registryName := .Values.metricsImage.registry -}}
{{- $repositoryName := .Values.metricsImage.repository -}}
{{- $tag := .Values.metricsImage.tag | toString -}}
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
{{- define "postgresql-ha.imagePullSecrets" -}}
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
{{- end -}}
{{- else if or .Values.postgresqlImage.pullSecrets .Values.pgpoolImage.pullSecrets .Values.volumePermissionsImage.pullSecrets .Values.metricsImage.pullSecrets }}
imagePullSecrets:
{{- range .Values.postgresqlImage.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- range .Values.pgpoolImage.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- range .Values.volumePermissionsImage.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- range .Values.metricsImage.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- end -}}
{{- else if or .Values.postgresqlImage.pullSecrets .Values.pgpoolImage.pullSecrets .Values.volumePermissionsImage.pullSecrets .Values.metricsImage.pullSecrets }}
imagePullSecrets:
{{- range .Values.postgresqlImage.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- range .Values.pgpoolImage.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- range .Values.volumePermissionsImage.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- range .Values.metricsImage.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL username
*/}}
{{- define "postgresql-ha.postgresqlUsername" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.username }}
            {{- .Values.global.postgresql.username -}}
        {{- else -}}
            {{- .Values.postgresql.username -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.username -}}
    {{- end -}}
{{- else -}}
    {{- .Values.postgresql.username -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL postgres user password
*/}}
{{- define "postgresql-ha.postgresqlPostgresPassword" -}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.postgresPassword }}
            {{- .Values.global.postgresql.postgresPassword -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.postgresql.postgresPassword (empty .Values.postgresql.postgresPassword) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.postgresql.postgresPassword (empty .Values.postgresql.postgresPassword) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.postgresql.postgresPassword (empty .Values.postgresql.postgresPassword) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL password
*/}}
{{- define "postgresql-ha.postgresqlPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.password }}
            {{- .Values.global.postgresql.password -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.postgresql.password (empty .Values.postgresql.password) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.postgresql.password (empty .Values.postgresql.password) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.postgresql.password (empty .Values.postgresql.password) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool Admin username
*/}}
{{- define "postgresql-ha.pgpoolAdminUsername" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.pgpool }}
        {{- if .Values.global.pgpool.adminUsername }}
            {{- .Values.global.pgpool.adminUsername -}}
        {{- else -}}
            {{- .Values.pgpool.adminUsername -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.pgpool.adminUsername -}}
    {{- end -}}
{{- else -}}
    {{- .Values.pgpool.adminUsername -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool Admin password
*/}}
{{- define "postgresql-ha.pgpoolAdminPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.pgpool }}
        {{- if .Values.global.pgpool.adminPassword }}
            {{- .Values.global.pgpool.adminPassword -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.pgpool.adminPassword (empty .Values.pgpool.adminPassword) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.pgpool.adminPassword (empty .Values.pgpool.adminPassword) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.pgpool.adminPassword (empty .Values.pgpool.adminPassword) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL database to create
*/}}
{{- define "postgresql-ha.postgresqlDatabase" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- $postgresqlDatabase := default "postgres" .Values.postgresql.database -}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.database }}
            {{- default "postgres" .Values.global.postgresql.database -}}
        {{- else -}}
            {{- $postgresqlDatabase -}}
        {{- end -}}
    {{- else -}}
        {{- $postgresqlDatabase -}}
    {{- end -}}
{{- else -}}
    {{- $postgresqlDatabase -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL repmgr username
*/}}
{{- define "postgresql-ha.postgresqlRepmgrUsername" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.repmgrUsername }}
            {{- .Values.global.postgresql.repmgrUsername -}}
        {{- else -}}
            {{- .Values.postgresql.repmgrUsername -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.repmgrUsername -}}
    {{- end -}}
{{- else -}}
    {{- .Values.postgresql.repmgrUsername -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL repmgr password
*/}}
{{- define "postgresql-ha.postgresqlRepmgrPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.repmgrPassword }}
            {{- .Values.global.postgresql.repmgrPassword -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.postgresql.repmgrPassword (empty .Values.postgresql.repmgrPassword) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.postgresql.repmgrPassword (empty .Values.postgresql.repmgrPassword) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.postgresql.repmgrPassword (empty .Values.postgresql.repmgrPassword) -}}
{{- end -}}
{{- end -}}

{{/*
Return the database to use for repmgr
*/}}
{{- define "postgresql-ha.repmgrDatabase" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.repmgrDatabase }}
            {{- .Values.global.postgresql.repmgrDatabase -}}
        {{- else -}}
            {{- .Values.postgresql.repmgrDatabase -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.repmgrDatabase -}}
    {{- end -}}
{{- else -}}
    {{- .Values.postgresql.repmgrDatabase -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for PostgreSQL
*/}}
{{- define "postgresql-ha.postgresqlCreateSecret" -}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.existingSecret }}
        {{- else if (not .Values.postgresql.existingSecret) -}}
            {{- true -}}
        {{- end -}}
    {{- else if (not .Values.postgresql.existingSecret) -}}
        {{- true -}}
    {{- end -}}
{{- else if (not .Values.postgresql.existingSecret) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL credentials secret.
*/}}
{{- define "postgresql-ha.postgresqlSecretName" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.existingSecret }}
            {{- printf "%s" (tpl .Values.global.postgresql.existingSecret $) -}}
        {{- else if .Values.postgresql.existingSecret -}}
            {{- printf "%s" (tpl .Values.postgresql.existingSecret $) -}}
        {{- else -}}
            {{- printf "%s" (include "postgresql-ha.postgresql" .) -}}
        {{- end -}}
     {{- else if .Values.postgresql.existingSecret -}}
         {{- printf "%s" (tpl .Values.postgresql.existingSecret $) -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.postgresql" .) -}}
     {{- end -}}
{{- else -}}
     {{- if .Values.postgresql.existingSecret -}}
         {{- printf "%s" (tpl .Values.postgresql.existingSecret $) -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.postgresql" .) -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for Pgpool
*/}}
{{- define "postgresql-ha.pgpoolCreateSecret" -}}
{{- if .Values.global }}
    {{- if .Values.global.pgpool }}
        {{- if .Values.global.pgpool.existingSecret }}
        {{- else if (not .Values.pgpool.existingSecret) -}}
            {{- true -}}
        {{- end -}}
    {{- else if (not .Values.pgpool.existingSecret) -}}
        {{- true -}}
    {{- end -}}
{{- else if (not .Values.pgpool.existingSecret) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool credentials secret.
*/}}
{{- define "postgresql-ha.pgpoolSecretName" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.pgpool }}
        {{- if .Values.global.pgpool.existingSecret }}
            {{- printf "%s" .Values.global.pgpool.existingSecret -}}
        {{- else if .Values.pgpool.existingSecret -}}
            {{- printf "%s" .Values.pgpool.existingSecret -}}
        {{- else -}}
            {{- printf "%s" (include "postgresql-ha.pgpool" .) -}}
        {{- end -}}
     {{- else if .Values.pgpool.existingSecret -}}
         {{- printf "%s" .Values.pgpool.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.pgpool" .) -}}
     {{- end -}}
{{- else -}}
     {{- if .Values.pgpool.existingSecret -}}
         {{- printf "%s" .Values.pgpool.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.pgpool" .) -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL configuration configmap.
*/}}
{{- define "postgresql-ha.postgresqlConfigurationCM" -}}
{{- if .Values.postgresql.configurationCM -}}
{{- printf "%s" (tpl .Values.postgresql.configurationCM $) -}}
{{- else -}}
{{- printf "%s-configuration" (include "postgresql-ha.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL extended configuration configmap.
*/}}
{{- define "postgresql-ha.postgresqlExtendedConfCM" -}}
{{- if .Values.postgresql.extendedConfCM -}}
{{- printf "%s" (tpl .Values.postgresql.extendedConfCM $) -}}
{{- else -}}
{{- printf "%s-extended-configuration" (include "postgresql-ha.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool configuration configmap.
*/}}
{{- define "postgresql-ha.pgpoolConfigurationCM" -}}
{{- if .Values.pgpool.configurationCM -}}
{{- printf "%s" (tpl .Values.pgpool.configurationCM $) -}}
{{- else -}}
{{- printf "%s-configuration" (include "postgresql-ha.pgpool" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL initdb scripts configmap.
*/}}
{{- define "postgresql-ha.postgresqlInitdbScriptsCM" -}}
{{- if .Values.postgresql.initdbScriptsCM -}}
{{- printf "%s" (tpl .Values.postgresql.initdbScriptsCM $) -}}
{{- else -}}
{{- printf "%s-initdb-scripts" (include "postgresql-ha.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "postgresql-ha.postgresqlInitdbScriptsSecret" -}}
{{- if .Values.postgresql.initdbScriptsSecret -}}
{{- include "postgresql-ha.tplValue" (dict "value" .Values.postgresql.initdbScriptsSecret "context" $) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool initdb scripts configmap.
*/}}
{{- define "postgresql-ha.pgpoolInitdbScriptsCM" -}}
{{- if .Values.pgpool.initdbScriptsCM -}}
{{- printf "%s" (tpl .Values.pgpool.initdbScriptsCM $) -}}
{{- else -}}
{{- printf "%s-initdb-scripts" (include "postgresql-ha.pgpool" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the pgpool initialization scripts Secret name.
*/}}
{{- define "postgresql-ha.pgpoolInitdbScriptsSecret" -}}
{{- if .Values.pgpool.initdbScriptsSecret -}}
{{- include "postgresql-ha.tplValue" (dict "value" .Values.pgpool.initdbScriptsSecret "context" $) -}}
{{- end -}}
{{- end -}}

{{/*
Return the LDAP bind password
*/}}
{{- define "postgresql-ha.ldapPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.ldap }}
        {{- if .Values.global.ldap.bindpw }}
            {{- .Values.global.ldap.bindpw -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.ldap.bindpw (empty .Values.ldap.bindpw) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.ldap.bindpw (empty .Values.ldap.bindpw) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.ldap.bindpw (empty .Values.ldap.bindpw) -}}
{{- end -}}
{{- end -}}


{{/*
Return the LDAP credentials secret.
*/}}
{{- define "postgresql-ha.ldapSecretName" -}}
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
            {{- printf "%s" (include "postgresql-ha.ldap" .) -}}
        {{- end -}}
     {{- else if .Values.ldap.existingSecret -}}
         {{- printf "%s" .Values.ldap.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.ldap" .) -}}
     {{- end -}}
{{- else -}}
     {{- if .Values.ldap.existingSecret -}}
         {{- printf "%s" .Values.ldap.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.ldap" .) -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Storage Class
*/}}
{{- define "postgresql-ha.storageClass" -}}
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

{{/* Check if there are rolling tags in the images */}}
{{- define "postgresql-ha.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.postgresqlImage.repository) (not (.Values.postgresqlImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.postgresqlImage.repository }}:{{ .Values.postgresqlImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.pgpoolImage.repository) (not (.Values.pgpoolImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.pgpoolImage.repository }}:{{ .Values.pgpoolImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.metricsImage.repository) (not (.Values.metricsImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.metricsImage.repository }}:{{ .Values.metricsImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- end -}}

{{/*
Return the appropriate apiVersion for networkPolicy
*/}}
{{- define "postgresql-ha.networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
"extensions/v1beta1"
{{- else if semverCompare "^1.7-0" .Capabilities.KubeVersion.GitVersion -}}
"networking.k8s.io/v1"
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "postgresql-ha.tplValue" (dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "postgresql-ha.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "postgresql-ha.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "postgresql-ha.validateValues.nodesHostnames" .) -}}
{{- $messages := append $messages (include "postgresql-ha.validateValues.ldap" .) -}}
{{- $messages := append $messages (include "postgresql-ha.validateValues.ldapPgHba" .) -}}
{{- $messages := append $messages (include "postgresql-ha.validateValues.upgradeRepmgrExtension" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - PostgreSQL nodes hostnames cannot be longer than 128 characters */}}
{{- define "postgresql-ha.validateValues.nodesHostnames" -}}
{{- $postgresqlFullname := include "postgresql-ha.postgresql" . }}
{{- $postgresqlHeadlessServiceName := printf "%s-headless" (include "postgresql-ha.postgresql" .) }}
{{- $releaseNamespace := .Release.Namespace }}
{{- $clusterDomain:= .Values.clusterDomain }}
{{- $nodeHostname := printf "%s-00.%s.%s.svc.%s:1234" $postgresqlFullname $postgresqlHeadlessServiceName $releaseNamespace $clusterDomain }}
{{- if gt (len $nodeHostname) 128 -}}
postgresql-ha: Nodes hostnames
    PostgreSQL nodes hostnames ({{ $nodeHostname }}) exceeds the characters limit for Pgpool: 128.
    Consider using a shorter release name or namespace.
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - must provide mandatory LDAP paremeters when LDAP is enabled */}}
{{- define "postgresql-ha.validateValues.ldap" -}}
{{- if and .Values.ldap.enabled (or (empty .Values.ldap.uri) (empty .Values.ldap.base) (empty .Values.ldap.binddn) (empty .Values.ldap.bindpw)) -}}
postgresql-ha: LDAP
    Invalid LDAP configuration. When enabling LDAP support, the parameters "ldap.uri",
    "ldap.base", "ldap.binddn", and "ldap.bindpw" are mandatory. Please provide them:

    $ helm install {{ .Release.Name }} bitnami/postgresql-ha \
      --set ldap.enabled=true \
      --set ldap.uri="ldap://my_ldap_server" \
      --set ldap.base="dc=example\,dc=org" \
      --set ldap.binddn="cn=admin\,dc=example\,dc=org" \
      --set ldap.bindpw="admin"
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - PostgreSQL HBA configuration must trust every user when LDAP is enabled */}}
{{- define "postgresql-ha.validateValues.ldapPgHba" -}}
{{- if and .Values.ldap.enabled (not .Values.postgresql.pgHbaTrustAll) }}
postgresql-ha: LDAP & pg_hba.conf
    PostgreSQL HBA configuration must trust every user when LDAP is enabled.
    Please configure HBA to trust every user (--set postgresql.pgHbaTrustAll=true)
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - There must be an unique replica when upgrading repmgr extension */}}
{{- define "postgresql-ha.validateValues.upgradeRepmgrExtension" -}}
{{- $postgresqlReplicaCount := int .Values.postgresql.replicaCount }}
{{- if and .Values.postgresql.upgradeRepmgrExtension (gt $postgresqlReplicaCount 1) }}
postgresql-ha: Upgrade repmgr extension
    There must be only one replica when upgrading repmgr extension:

    $ helm upgrade {{ .Release.Name }} bitnami/postgresql-ha \
      --set postgresql.replicaCount=1 \
      --set postgresql.upgradeRepmgrExtension=true
{{- end -}}
{{- end -}}

{{/* Set PGPASSWORD as environment variable depends on configuration */}}
{{- define "postgresql-ha.pgpassword" -}}
{{- if .Values.postgresql.usePasswordFile -}}
PGPASSWORD=$(< $POSTGRES_PASSWORD_FILE)
{{- else -}}
PGPASSWORD=$POSTGRES_PASSWORD
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool secret containing custom users to be added to
pool_passwd file.
*/}}
{{- define "postgresql-ha.pgpoolCustomUsersSecretName" -}}
{{- if .Values.pgpool.customUsersSecret -}}
{{- printf "%s" (tpl .Values.pgpool.customUsersSecret $) -}}
{{- else -}}
{{- printf "%s-custom-users" (include "postgresql-ha.pgpool" .) -}}
{{- end -}}
{{- end -}}
