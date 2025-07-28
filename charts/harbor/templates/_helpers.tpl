{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Set the http prefix if the externalURl doesn't have it
*/}}
{{- define "harbor.externalUrl" -}}
{{- $templatedExternalUrl := tpl .Values.externalURL . -}}
{{- if hasPrefix "http" $templatedExternalUrl -}}
    {{- print $templatedExternalUrl -}}
{{- else -}}
    {{- printf "%s://%s" (ternary "https" "http" (or (and (eq .Values.exposureType "proxy") .Values.nginx.tls.enabled) (and (eq .Values.exposureType "ingress") .Values.ingress.core.tls))) $templatedExternalUrl -}}
{{- end -}}
{{- end -}}

{{/*
Return true if the NGINX TLS certs should be auto-generated
*/}}
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

{{/* Secret key that contains the Harbor admin password */}}
{{- define "harbor.secret.adminPasswordKey" -}}
{{- default "HARBOR_ADMIN_PASSWORD" .Values.existingSecretAdminPasswordKey -}}
{{- end -}}

{{/* Core secret name */}}
{{- define "harbor.core.secretName" -}}
{{- default (include "harbor.core" .) .Values.core.existingSecret -}}
{{- end -}}

{{/* Core token secret name */}}
{{- define "harbor.core.token.secretName" -}}
{{- default (include "harbor.core" .) .Values.core.secretName -}}
{{- end -}}

{{/* Core env. vars secret name */}}
{{- define "harbor.core.envvars.secretName" -}}
{{- default (printf "%s-envvars" (include "harbor.core" .)) .Values.core.existingEnvVarsSecret -}}
{{- end -}}

{{/* Core configuration overrides secret name */}}
{{- define "harbor.core.overridesJsonSecret" -}}
{{- default (printf "%s-config-override" (include "harbor.core" .)) .Values.core.configOverwriteJsonSecret -}}
{{- end -}}

{{/* Core TLS secret name */}}
{{- define "harbor.core.tls.secretName" -}}
{{- default (printf "%s-crt" (include "harbor.core" .)) .Values.core.tls.existingSecret -}}
{{- end -}}

{{/* Jobservice secret name */}}
{{- define "harbor.jobservice.secretName" -}}
{{- default (include "harbor.jobservice" .) .Values.jobservice.existingSecret -}}
{{- end -}}

{{/* Jobservice TLS secret name */}}
{{- define "harbor.jobservice.tls.secretName" -}}
{{- default (printf "%s-crt" (include "harbor.jobservice" .)) .Values.jobservice.tls.existingSecret -}}
{{- end -}}

{{/* Portal TLS secret name */}}
{{- define "harbor.portal.tls.secretName" -}}
{{- default (printf "%s-crt" (include "harbor.portal" .)) .Values.portal.tls.existingSecret -}}
{{- end -}}

{{/* Registry TLS secret name */}}
{{- define "harbor.registry.tls.secretName" -}}
{{- default (printf "%s-crt" (include "harbor.registry" .)) .Values.registry.tls.existingSecret -}}
{{- end -}}

{{/* Trivy TLS secret name */}}
{{- define "harbor.trivy.tls.secretName" -}}
{{- default (printf "%s-crt" (include "harbor.trivy" .)) .Values.trivy.tls.existingSecret -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "harbor.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{- define "harbor.database.host" -}}
{{- if .Values.postgresql.enabled -}}
    {{- ternary (printf "%s-primary" (include "harbor.postgresql.fullname" .)) (include "harbor.postgresql.fullname" .) (eq .Values.postgresql.architecture "replication") -}}
{{- else -}}
    {{- tpl .Values.externalDatabase.host . -}}
{{- end -}}
{{- end -}}

{{- define "harbor.database.port" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.username" -}}
{{- ternary "postgres" .Values.externalDatabase.user .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.rawPassword" -}}
{{- if .Values.postgresql.enabled -}}
  {{- coalesce (((.Values.global).postgresql).auth).postgresPassword .Values.postgresql.auth.postgresPassword -}}
{{- else if not .Values.externalDatabase.existingSecret -}}
  {{- .Values.externalDatabase.password -}}
{{- end -}}
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
{{- if .context.Values.redis.enabled -}}
{{- ternary (printf "%s-headless.%s.svc.%s" (include "harbor.redis.fullname" .context ) (include "common.names.namespace" .context) .context.Values.clusterDomain ) (printf "%s-master.%s.svc.%s" (include "harbor.redis.fullname" .context) (include "common.names.namespace" .context) .context.Values.clusterDomain ) .context.Values.redis.sentinel.enabled -}} 
{{- else -}}
{{- $externalRedis := ternary ( get .context.Values.externalRedis .component ) .context.Values.externalRedis .context.Values.externalRedis.instancePerComponent -}}
{{- ternary (printf "%s" $externalRedis.sentinel.hosts) $externalRedis.host $externalRedis.sentinel.enabled -}}
{{- end -}}
{{- end -}}

{{- define "harbor.redis.port" -}}
{{- if .context.Values.redis.enabled -}}
{{- ternary (int64 .context.Values.redis.sentinel.service.ports.sentinel) "6379" .context.Values.redis.sentinel.enabled -}}
{{- else -}}
{{- ternary (get .context.Values.externalRedis .component ).port .context.Values.externalRedis.port .context.Values.externalRedis.instancePerComponent -}}
{{- end -}}
{{- end -}}

{{- define "harbor.redis.sentinel.enabled" -}}
{{- if or (and .context.Values.redis.enabled .context.Values.redis.sentinel) (and (not .context.Values.redis.enabled) (ternary (get .context.Values.externalRedis .component ).sentinel .context.Values.externalRedis.sentinel .context.Values.externalRedis.instancePerComponent)) -}}
true
{{- end -}}
{{- end -}}

{{- define "harbor.redis.sentinel.masterSet" -}}
{{- $sentinel := .context.Values.redis.sentinel -}}
{{- if not .context.Values.redis.enabled -}}
{{- $sentinel = ternary (get .context.Values.externalRedis .component ).sentinel .context.Values.externalRedis.sentinel .context.Values.externalRedis.instancePerComponent -}}
{{- end -}}
{{- ternary (printf "%s" $sentinel.masterSet) ("") $sentinel.enabled -}}
{{- end -}}

{{- define "harbor.redis.coreDatabaseIndex" -}}
{{- ternary "0" (ternary (get .Values.externalRedis "core" ).index .Values.externalRedis.coreDatabaseIndex .Values.externalRedis.instancePerComponent) .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.jobserviceDatabaseIndex" -}}
{{- ternary "1" (ternary (get .Values.externalRedis "jobservice" ).index .Values.externalRedis.jobserviceDatabaseIndex .Values.externalRedis.instancePerComponent) .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.registryDatabaseIndex" -}}
{{- ternary "2" (ternary (get .Values.externalRedis "registry" ).index .Values.externalRedis.registryDatabaseIndex .Values.externalRedis.instancePerComponent) .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.trivyAdapterDatabaseIndex" -}}
{{- ternary "5" (ternary (get .Values.externalRedis "trivy" ).index .Values.externalRedis.trivyAdapterDatabaseIndex .Values.externalRedis.instancePerComponent) .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.username" -}}
{{- if .context.Values.redis.enabled -}}
  {{- print "default" -}}
{{- else -}}
  {{- $externalRedis := ternary ( get .context.Values.externalRedis .component ) .context.Values.externalRedis .context.Values.externalRedis.instancePerComponent -}}
  {{- default "default" $externalRedis.username -}}
{{- end -}}
{{- end -}}

{{- define "harbor.redis.rawPassword" -}}
  {{- $externalRedis := ternary ( get .context.Values.externalRedis .component ) .context.Values.externalRedis .context.Values.externalRedis.instancePerComponent -}}
  {{- if and (not .context.Values.redis.enabled) $externalRedis.password -}}
    {{- $externalRedis.password -}}
  {{- else if and (not .context.Values.redis.enabled) $externalRedis.existingSecret -}}
    {{- $secret := tpl $externalRedis.existingSecret .context -}}
    {{- include "common.secrets.lookup" (dict "secret" $secret "key" "redis-password" "context" .context) }}
  {{- end -}}
  {{- if and .context.Values.redis.enabled .context.Values.redis.auth.enabled .context.Values.redis.auth.password -}}
    {{- .context.Values.redis.auth.password -}}
  {{- else if and .context.Values.redis.enabled .context.Values.redis.auth.enabled .context.Values.redis.auth.existingSecret -}}
    {{- $secret := tpl .context.Values.redis.auth.existingSecret .context -}}
    {{- include "common.secrets.lookup" (dict "secret" $secret "key" "redis-password" "context" .context) }}
  {{- end -}}
{{- end -}}

{{- define "harbor.redis.escapedRawPassword" -}}
  {{- if (include "harbor.redis.rawPassword" . ) -}}
    {{- include "harbor.redis.rawPassword" . | urlquery | replace "+" "%20" -}}
  {{- end -}}
{{- end -}}

{{/* Redis Scheme used in the connection URL */}}
{{- define "harbor.redis.scheme" -}}
  {{- $externalRedis := ternary ( get .context.Values.externalRedis .component ) .context.Values.externalRedis .context.Values.externalRedis.instancePerComponent -}}
  {{- $defaultScheme := ternary "rediss" "redis" (or $externalRedis.tls.enabled .context.Values.redis.tls.enabled ) -}}
  {{- if or $externalRedis.sentinel.enabled .context.Values.redis.sentinel.enabled -}}
    {{- printf "%s+sentinel" $defaultScheme -}}
  {{- else -}}
    {{- print $defaultScheme -}}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "harbor.redisForJobservice" -}}
  {{- $component := "jobservice" -}}
  {{- $args := dict "context" . "component" $component -}}
  {{- if not (include "harbor.redis.sentinel.enabled" $args)  -}}
    {{- if (include "harbor.redis.escapedRawPassword" $args) -}}
      {{- printf "%s://%s:%s@%s:%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.username" $args) (include "harbor.redis.escapedRawPassword" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "%s://%s:%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" $args) -}}
      {{- printf "%s://%s:%s@%s:%s/%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.username" $args) (include "harbor.redis.escapedRawPassword" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.sentinel.masterSet" $args) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "%s://%s:%s/%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.sentinel.masterSet" $args) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "harbor.redisForGC" -}}
  {{- $component := "registry" -}}
  {{- $args := dict "context" . "component" $component -}}
  {{- if not (include "harbor.redis.sentinel.enabled" $args)  -}}
    {{- if (include "harbor.redis.escapedRawPassword" $args) -}}
      {{- printf "%s://%s:%s@%s:%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.username" $args) (include "harbor.redis.escapedRawPassword" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "%s://%s:%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" $args) -}}
      {{- printf "%s://%s:%s@%s:%s/%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.username" $args) (include "harbor.redis.escapedRawPassword" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.sentinel.masterSet" $args) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "%s://%s:%s/%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.sentinel.masterSet" $args) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redisForTrivyAdapter" -}}
  {{- $component := "trivy" -}}
  {{- $args := dict "context" . "component" $component -}}
  {{- if not (include "harbor.redis.sentinel.enabled" $args)  -}}
    {{- if (include "harbor.redis.escapedRawPassword" $args) -}}
      {{- printf "%s://%s:%s@%s:%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.username" $args) (include "harbor.redis.escapedRawPassword" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "%s://%s:%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" $args) -}}
      {{- printf "%s://%s:%s@%s:%s/%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.username" $args) (include "harbor.redis.escapedRawPassword" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.sentinel.masterSet" $args) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "%s://%s:%s/%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.sentinel.masterSet" $args) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redisForCore" -}}
  {{- $component := "core" -}}
  {{- $args := dict "context" . "component" $component -}}
  {{- if not (include "harbor.redis.sentinel.enabled" $args)  -}}
    {{- if (include "harbor.redis.escapedRawPassword" $args) -}}
      {{- printf "%s://%s:%s@%s:%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.username" $args) (include "harbor.redis.escapedRawPassword" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "%s://%s:%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" $args) -}}
      {{- printf "%s://%s:%s@%s:%s/%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.username" $args) (include "harbor.redis.escapedRawPassword" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.sentinel.masterSet" $args) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "%s://%s:%s/%s/%s" (include "harbor.redis.scheme" $args) (include "harbor.redis.host" $args) (include "harbor.redis.port" $args) (include "harbor.redis.sentinel.masterSet" $args) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/* Volume Mount with Redis TLS secrets */}}
{{- define "harbor.redis.caVolumeMount" -}}
{{- $externalRedis := ternary ( get .context.Values.externalRedis .component ) .context.Values.externalRedis .context.Values.externalRedis.instancePerComponent -}}
{{- if or .context.Values.redis.tls.enabled $externalRedis.tls.enabled -}}
- name: redis-certs
  mountPath: /harbor_cust_cert/redis-ca.crt
  subPath: {{ include "harbor.redis.caFileName" . | quote }}
{{- end -}}
{{- end -}}

{{/* Volume with Redis TLS secrets */}}
{{- define "harbor.redis.caVolume" -}}
{{- $externalRedis := ternary ( get .context.Values.externalRedis .component ) .context.Values.externalRedis .context.Values.externalRedis.instancePerComponent -}}
{{- if or .context.Values.redis.tls.enabled $externalRedis.tls.enabled -}}
- name: redis-certs
  secret:
    secretName: {{ include "harbor.redis.caSecretName" . | quote }}
{{- end -}}
{{- end -}}

{{/* Get Redis secret with the CA certificate */}}
{{- define "harbor.redis.caSecretName" -}}
  {{- $externalRedis := ternary ( get .context.Values.externalRedis .component ) .context.Values.externalRedis .context.Values.externalRedis.instancePerComponent -}}
  {{- if and .context.Values.redis.enabled .content.Values.redis.tls.enabled .context.Values.redis.tls.existingSecret -}}
    {{- print (tpl .content.Values.redis.tls.existingSecret .) -}}
  {{- else if and $externalRedis.tls.enabled $externalRedis.tls.existingSecret -}}
    {{- print (tpl $externalRedis.tls.existingSecret .) -}}
  {{- else -}}
    {{- printf "%s-crt" (include "harbor.redis.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/* Get key in Redis secret with the CA certificate */}}
{{- define "harbor.redis.caFileName" -}}
  {{- $externalRedis := ternary ( get .context.Values.externalRedis .component ) .context.Values.externalRedis .context.Values.externalRedis.instancePerComponent -}}
  {{- if and .context.Values.redis.enabled .context.Values.redis.tls.enabled .context.Values.redis.tls.certCAFilename -}}
    {{- print (tpl .context.Values.redis.tls.certCAFilename .) -}}
  {{- else if and $externalRedis.tls.enabled $externalRedis.tls.certCAFilename -}}
    {{- print (tpl $externalRedis.tls.certCAFilename .) -}}
  {{- else -}}
    {{- print "ca.crt" -}}
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
{{- $messages := append $messages (include "harbor.validateValues.redisTLS" .) -}}
{{- $messages := append $messages (include "harbor.validateValues.redisMutualTLS" .) -}}
{{- $messages := append $messages (include "harbor.validateValues.externalRedis" .) -}}
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
    {{- if and (not .Values.externalDatabase.password) (not .Values.externalDatabase.existingSecret) -}}
harbor: External PostgreSQL password
    An external database password is required!.
    Please set a password (--set externalDatabase.password="xxxx") or using an existing secret
  {{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Harbor - must provide a valid exposureType */}}
{{- define "harbor.validateValues.exposureType" -}}
{{- if and (ne .Values.exposureType "ingress") (ne .Values.exposureType "proxy") (ne .Values.exposureType "none") -}}
harbor: exposureType
    Invalid exposureType selected. Valid values are "ingress", "proxy" and "none".
    Please set a valid exposureType (--set exposureType="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of Harbor - must provide a valid Redis TLS config */}}
{{- define "harbor.validateValues.redisTLS" -}}
{{- if or (and (not .Values.redis.enabled) .Values.externalRedis.tls.enabled (not .Values.externalRedis.tls.existingSecret)) 
          (and .Values.redis.enabled (not .Values.redis.tls.autoGenerated) (not .Values.redis.tls.existingSecret)) -}}
harbor: Redis TLS
    CA certificate for Redis when TLS is enabled is required.
    Please set redis.tls.existingSecret or  externalRedis.tls.existingSecret. Example:
    kubectl create secret generic redis-ca --from-file ca.crt (--set externalRedis.tls.existingSecret="redis-ca")
{{- end -}}
{{- end -}}

{{/* Validate values of Harbor - Redis Mutual TLS not supported */}}
{{- define "harbor.validateValues.redisMutualTLS" -}}
{{- if and .Values.redis.tls.enabled .Values.redis.tls.authClients -}}
harbor: Redis Mutual TLS
    At the moment Harbor does not support this configuration. Please set
    redis.tls.authClients to false (--set redis.tls.authClients=false)
{{- end -}}
{{- end -}}

{{/* Validate values of Harbor - externalRedis configuration */}}
{{- define "harbor.validateValues.externalRedis" -}}
{{- if and .Values.externalRedis.instancePerComponent ( or ( not .Values.externalRedis.core.host ) ( not .Values.externalRedis.jobservice.host ) ( and .Values.externalRedis.trivy.enabled ( not .Values.externalRedis.trivy.host ) ) ( not .Values.externalRedis.registry.host ) ) -}}
harbor: External Redis instance per Harbor component
    Following values are mandatory when externalRedis.instancePerComponent is set:
      * externalRedis.core.host
      * externalRedis.jobservice.host
      * externalRedis.trivy.host
      * externalRedis.registry.host
{{- end -}}
{{- end -}}

{{/* lists all tracing related environment variables except for TRACE_SERVICE_NAME, which should be set separately */}}
{{- define "harbor.tracing.envvars" -}}
TRACE_ENABLED: {{ .Values.tracing.enabled | quote }}
TRACE_SAMPLE_RATE: {{ .Values.tracing.sampleRate | quote }}
TRACE_NAMESPACE: {{ .Values.tracing.namespace | quote }}
TRACE_ATTRIBUTES: {{ .Values.tracing.attributes | toJson | squote }}
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
