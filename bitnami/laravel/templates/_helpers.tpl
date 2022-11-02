{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "laravel.mariadb.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mariadb" "chartValues" .Values.mariadb "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "laravel.memcached.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "memcached" "chartValues" .Values.memcached "context" $) -}}
{{- end -}}

{{/*
Return the proper laravel image name
*/}}
{{- define "laravel.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "laravel.metrics.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "laravel.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "laravel.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "laravel.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "laravel.customHTAccessCM" -}}
{{- printf "%s" .Values.customHTAccessCM -}}
{{- end -}}

{{/*
Return the laravel configuration secret
*/}}
{{- define "laravel.configSecretName" -}}
{{- if .Values.existinglaravelConfigurationSecret -}}
    {{- printf "%s" (tpl .Values.existinglaravelConfigurationSecret $) -}}
{{- else -}}
    {{- printf "%s-configuration" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for laravel configuration
*/}}
{{- define "laravel.createConfigSecret" -}}
{{- if and .Values.laravelConfiguration (not .Values.existinglaravelConfigurationSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the laravel Apache configuration configmap
*/}}
{{- define "laravel.apache.configmapName" -}}
{{- if .Values.existingApacheConfigurationConfigMap -}}
    {{- printf "%s" (tpl .Values.existingApacheConfigurationConfigMap $) -}}
{{- else -}}
    {{- printf "%s-apache-configuration" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for Apache configuration
*/}}
{{- define "laravel.apache.createConfigmap" -}}
{{- if and .Values.apacheConfiguration (not .Values.existingApacheConfigurationConfigMap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "laravel.databaseHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
        {{- printf "%s-primary" (include "laravel.mariadb.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "laravel.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "laravel.databasePort" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Database Name
*/}}
{{- define "laravel.databaseName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "laravel.databaseUser" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Secret Name
*/}}
{{- define "laravel.databaseSecretName" -}}
{{- if .Values.mariadb.enabled }}
    {{- if .Values.mariadb.auth.existingSecret -}}
        {{- printf "%s" .Values.mariadb.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "laravel.mariadb.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.externalDatabase.existingSecret "context" $) -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Memcached Hostname
*/}}
{{- define "laravel.cacheHost" -}}
{{- if .Values.memcached.enabled }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomain }}
    {{- printf "%s.%s.svc.%s" (include "laravel.memcached.fullname" .) $releaseNamespace $clusterDomain -}}
{{- else -}}
    {{- printf "%s" .Values.externalCache.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Memcached Port
*/}}
{{- define "laravel.cachePort" -}}
{{- if .Values.memcached.enabled }}
    {{- printf "11211" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalCache.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the laravel Secret Name
*/}}
{{- define "laravel.secretName" -}}
{{- if .Values.existingSecret }}
    {{- printf "%s" .Values.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the SMTP Secret Name
*/}}
{{- define "laravel.smtpSecretName" -}}
{{- if .Values.smtpExistingSecret }}
    {{- printf "%s" .Values.smtpExistingSecret -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "laravel.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "laravel.validateValues.configuration" .) -}}
{{- $messages := append $messages (include "laravel.validateValues.htaccess" .) -}}
{{- $messages := append $messages (include "laravel.validateValues.database" .) -}}
{{- $messages := append $messages (include "laravel.validateValues.cache" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of laravel - Custom wp-config.php
*/}}
{{- define "laravel.validateValues.configuration" -}}
{{- if and (or .Values.laravelConfiguration .Values.existinglaravelConfigurationSecret) (not .Values.laravelSkipInstall) -}}
laravel: laravelConfiguration
    You are trying to use a wp-config.php file. This setup is only supported
    when skipping wizard installation (--set laravelSkipInstall=true).
{{- end -}}
{{- end -}}

{{/*
Validate values of laravel - htaccess configuration
*/}}
{{- define "laravel.validateValues.htaccess" -}}
{{- if and .Values.customHTAccessCM .Values.allowOverrideNone -}}
laravel: customHTAccessCM
    You are trying to use custom htaccess rules but Apache was configured
    to prohibit overriding directives with htaccess files. To use this feature,
    allow overriding Apache directives (--set allowOverrideNone=false).
{{- end -}}
{{- end -}}

{{/* Validate values of laravel - Database */}}
{{- define "laravel.validateValues.database" -}}
{{- if and (not .Values.mariadb.enabled) (or (empty .Values.externalDatabase.host) (empty .Values.externalDatabase.port) (empty .Values.externalDatabase.database)) -}}
laravel: database
   You disable the MariaDB installation but you did not provide the required parameters
   to use an external database. To use an external database, please ensure you provide
   (at least) the following values:

       externalDatabase.host=DB_SERVER_HOST
       externalDatabase.database=DB_NAME
       externalDatabase.port=DB_SERVER_PORT
{{- end -}}
{{- end -}}

{{/* Validate values of laravel - Cache */}}
{{- define "laravel.validateValues.cache" -}}
{{- if and .Values.laravelConfigureCache (not .Values.memcached.enabled) (or (empty .Values.externalCache.host) (empty .Values.externalCache.port)) -}}
laravel: cache
   You enabled cache via W3 Total Cache without but you did not enable the Memcached
   installation nor you did provided the required parameters to use an external cache server.
   Please enable the Memcached installation (--set memcached.enabled=true) or
   provide the external cache server values:

       externalCache.host=CACHE_SERVER_HOST
       externalCache.port=CACHE_SERVER_PORT
{{- end -}}
{{- end -}}
