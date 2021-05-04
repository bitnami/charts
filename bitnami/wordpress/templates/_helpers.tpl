{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wordpress.mariadb.fullname" -}}
{{- printf "%s-mariadb" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wordpress.memcached.fullname" -}}
{{- printf "%s-memcached" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper WordPress image name
*/}}
{{- define "wordpress.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "wordpress.metrics.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "wordpress.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wordpress.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wordpress.customHTAccessCM" -}}
{{- printf "%s" .Values.customHTAccessCM -}}
{{- end -}}

{{/*
Return the WordPress configuration secret
*/}}
{{- define "wordpress.configSecretName" -}}
{{- if .Values.existingWordPressConfigurationSecret -}}
    {{- printf "%s" (tpl .Values.existingWordPressConfigurationSecret $) -}}
{{- else -}}
    {{- printf "%s-configuration" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for WordPress configuration
*/}}
{{- define "wordpress.createConfigSecret" -}}
{{- if and .Values.wordpressConfiguration (not .Values.existingWordPressConfigurationSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the WordPress Apache configuration configmap
*/}}
{{- define "wordpress.apache.configmapName" -}}
{{- if .Values.existingApacheConfigurationConfigMap -}}
    {{- printf "%s" (tpl .Values.existingApacheConfigurationConfigMap $) -}}
{{- else -}}
    {{- printf "%s-apache-configuration" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for Apache configuration
*/}}
{{- define "wordpress.apache.createConfigmap" -}}
{{- if and .Values.apacheConfiguration (not .Values.existingApacheConfigurationConfigMap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "wordpress.databaseHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
        {{- printf "%s-primary" (include "wordpress.mariadb.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "wordpress.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "wordpress.databasePort" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Database Name
*/}}
{{- define "wordpress.databaseName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "wordpress.databaseUser" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Secret Name
*/}}
{{- define "wordpress.databaseSecretName" -}}
{{- if .Values.mariadb.enabled }}
    {{- if .Values.mariadb.auth.existingSecret -}}
        {{- printf "%s" .Values.mariadb.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "wordpress.mariadb.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Memcached Hostname
*/}}
{{- define "wordpress.cacheHost" -}}
{{- if .Values.memcached.enabled }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomain }}
    {{- printf "%s.%s.svc.%s" (include "wordpress.memcached.fullname" .) $releaseNamespace $clusterDomain -}}
{{- else -}}
    {{- printf "%s" .Values.externalCache.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Memcached Port
*/}}
{{- define "wordpress.cachePort" -}}
{{- if .Values.memcached.enabled }}
    {{- printf "11211" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalCache.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the WordPress Secret Name
*/}}
{{- define "wordpress.secretName" -}}
{{- if .Values.existingSecret }}
    {{- printf "%s" .Values.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the SMTP Secret Name
*/}}
{{- define "wordpress.smtpSecretName" -}}
{{- if .Values.smtpExistingSecret }}
    {{- printf "%s" .Values.smtpExistingSecret -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "wordpress.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "wordpress.validateValues.configuration" .) -}}
{{- $messages := append $messages (include "wordpress.validateValues.htaccess" .) -}}
{{- $messages := append $messages (include "wordpress.validateValues.database" .) -}}
{{- $messages := append $messages (include "wordpress.validateValues.cache" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of WordPress - Custom wp-config.php
*/}}
{{- define "wordpress.validateValues.configuration" -}}
{{- if and (or .Values.wordpressConfiguration .Values.existingWordPressConfigurationSecret) (not .Values.wordpressSkipInstall) -}}
wordpress: wordpressConfiguration
    You are trying to use a wp-config.php file. This setup is only supported
    when skipping wizard installation (--set wordpressSkipInstall=true).
{{- end -}}
{{- end -}}

{{/*
Validate values of WordPress - htaccess configuration
*/}}
{{- define "wordpress.validateValues.htaccess" -}}
{{- if and .Values.customHTAccessCM .Values.allowOverrideNone -}}
wordpress: customHTAccessCM
    You are trying to use custom htaccess rules but Apache was configured
    to prohibit overriding directives with htaccess files. To use this feature,
    allow overriding Apache directives (--set allowOverrideNone=false).
{{- end -}}
{{- end -}}

{{/* Validate values of WordPress - Database */}}
{{- define "wordpress.validateValues.database" -}}
{{- if and (not .Values.mariadb.enabled) (or (empty .Values.externalDatabase.host) (empty .Values.externalDatabase.port) (empty .Values.externalDatabase.database)) -}}
wordpress: database
   You disable the MariaDB installation but you did not provide the required parameters
   to use an external database. To use an external database, please ensure you provide
   (at least) the following values:

       externalDatabase.host=DB_SERVER_HOST
       externalDatabase.database=DB_NAME
       externalDatabase.port=DB_SERVER_PORT
{{- end -}}
{{- end -}}

{{/* Validate values of WordPress - Cache */}}
{{- define "wordpress.validateValues.cache" -}}
{{- if and .Values.wordpressConfigureCache (not .Values.memcached.enabled) (or (empty .Values.externalCache.host) (empty .Values.externalCache.port)) -}}
wordpress: cache
   You enabled cache via W3 Total Cache without but you did not enable the Memcached
   installation nor you did provided the required parameters to use an external cache server.
   Please enable the Memcached installation (--set memcached.enabled=true) or
   provide the external cache server values:

       externalCache.host=CACHE_SERVER_HOST
       externalCache.port=CACHE_SERVER_PORT
{{- end -}}
{{- end -}}
