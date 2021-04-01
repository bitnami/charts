{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "harbor.autoGenCert" -}}
  {{- if and .Values.service.tls.enabled (not .Values.service.tls.existingSecret) -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.autoGenCertForIngress" -}}
  {{- if and (eq (include "harbor.autoGenCert" .) "true") .Values.ingress.enabled -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.autoGenCertForNginx" -}}
  {{- if and (eq (include "harbor.autoGenCert" .) "true") (not .Values.ingress.enabled) -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.caBundleVolume" -}}
- name: ca-bundle-certs
  secret:
    secretName: {{ .Values.caBundleSecretName }}
{{- end -}}

{{- define "harbor.caBundleVolumeMount" -}}
- name: ca-bundle-certs
  mountPath: /harbor_cust_cert/custom-ca.crt
  subPath: ca.crt
{{- end -}}

{{/* Scheme for all components except notary because it only support http mode */}}
{{- define "harbor.component.scheme" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "https" -}}
  {{- else -}}
    {{- printf "http" -}}
  {{- end -}}
{{- end -}}

{{/* Chartmuseum component container port */}}
{{- define "harbor.chartmuseum.containerPort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "9443" -}}
  {{- else -}}
    {{- printf "9999" -}}
  {{- end -}}
{{- end -}}

{{/* Chartmuseum component service port */}}
{{- define "harbor.chartmuseum.servicePort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "443" -}}
  {{- else -}}
    {{- printf "80" -}}
  {{- end -}}
{{- end -}}

{{/* Clair Adapter component container port */}}
{{- define "harbor.clairAdapter.containerPort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "8443" -}}
  {{- else -}}
    {{- printf "8080" -}}
  {{- end -}}
{{- end -}}

{{/* Clair Adapter component service port */}}
{{- define "harbor.clairAdapter.servicePort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "8443" -}}
  {{- else -}}
    {{- printf "8080" -}}
  {{- end -}}
{{- end -}}

{{/* Core component container port */}}
{{- define "harbor.core.containerPort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "8443" -}}
  {{- else -}}
    {{- printf "8080" -}}
  {{- end -}}
{{- end -}}

{{/* Core component service port */}}
{{- define "harbor.core.servicePort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "443" -}}
  {{- else -}}
    {{- printf "80" -}}
  {{- end -}}
{{- end -}}

{{/* Jobservice component container port */}}
{{- define "harbor.jobservice.containerPort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "8443" -}}
  {{- else -}}
    {{- printf "8080" -}}
  {{- end -}}
{{- end -}}

{{/* Jobservice component service port */}}
{{- define "harbor.jobservice.servicePort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "443" -}}
  {{- else -}}
    {{- printf "80" -}}
  {{- end -}}
{{- end -}}

{{/* Portal component container port */}}
{{- define "harbor.portal.containerPort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "8443" -}}
  {{- else -}}
    {{- printf "8080" -}}
  {{- end -}}
{{- end -}}

{{/* Portal component service port */}}
{{- define "harbor.portal.servicePort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "443" -}}
  {{- else -}}
    {{- printf "80" -}}
  {{- end -}}
{{- end -}}

{{/* Registry server component container port */}}
{{- define "harbor.registry.containerPort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "5443" -}}
  {{- else -}}
    {{- printf "5000" -}}
  {{- end -}}
{{- end -}}

{{/* Registry server component service port */}}
{{- define "harbor.registry.servicePort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "5443" -}}
  {{- else -}}
    {{- printf "5000" -}}
  {{- end -}}
{{- end -}}

{{/* RegistryCtl component container port */}}
{{- define "harbor.registryCtl.containerPort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "8443" -}}
  {{- else -}}
    {{- printf "8080" -}}
  {{- end -}}
{{- end -}}

{{/* RegistryCtl component service port */}}
{{- define "harbor.registryctl.servicePort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "8443" -}}
  {{- else -}}
    {{- printf "8080" -}}
  {{- end -}}
{{- end -}}

{{/* Trivy component container port */}}
{{- define "harbor.trivy.containerPort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "8443" -}}
  {{- else -}}
    {{- printf "8080" -}}
  {{- end -}}
{{- end -}}

{{/* Trivy component service port */}}
{{- define "harbor.trivy.servicePort" -}}
  {{- if .Values.internalTLS.enabled -}}
    {{- printf "8443" -}}
  {{- else -}}
    {{- printf "8080" -}}
  {{- end -}}
{{- end -}}

{{/* Clair Adadpter URL */}}
{{- define "harbor.clairAdapter.url" -}}
  {{- printf "%s://%s:%s" (include "harbor.component.scheme" .) (include "harbor.clair" .) (include "harbor.clairAdapter.servicePort" .) -}}
{{- end -}}

{{/* port is included in this url as a workaround for issue https://github.com/aquasecurity/harbor-scanner-trivy/issues/108 */}}
{{- define "harbor.core.url" -}}
  {{- printf "%s://%s:%s" (include "harbor.component.scheme" .) (include "harbor.core" .) (include "harbor.core.servicePort" .) -}}
{{- end -}}

{{- define "harbor.jobservice.url" -}}
  {{- printf "%s://%s-jobservice" (include "harbor.component.scheme" .)  (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.portal.url" -}}
  {{- printf "%s://%s" (include "harbor.component.scheme" .) (include "harbor.portal" .) -}}
{{- end -}}

{{- define "harbor.chartmuseum.url" -}}
  {{- printf "%s://%s" (include "harbor.component.scheme" .) (include "harbor.chartmuseum" .) -}}
{{- end -}}

{{- define "harbor.registry.url" -}}
  {{- printf "%s://%s:%s" (include "harbor.component.scheme" .) (include "harbor.registry" .) (include "harbor.registry.servicePort" .) -}}
{{- end -}}

{{- define "harbor.registryCtl.url" -}}
  {{- printf "%s://%s:%s" (include "harbor.component.scheme" .) (include "harbor.registry" .) (include "harbor.registryctl.servicePort" .) -}}
{{- end -}}

{{- define "harbor.tokenService.url" -}}
  {{- printf "%s/service/token" (include "harbor.core.url" .) -}}
{{- end -}}

{{- define "harbor.trivy.url" -}}
  {{- printf "%s://%s:%s" (include "harbor.component.scheme" .) (include "harbor.trivy" .) (include "harbor.trivy.servicePort" .) -}}
{{- end -}}

{{- define "harbor.core.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.core.tls.existingSecret (printf "%s-crt" (include "harbor.core" .))) -}}
{{- end -}}

{{/* Chartmuseum TLS secret name */}}
{{- define "harbor.chartmuseum.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.chartmuseum.tls.existingSecret (printf "%s-crt" (include "harbor.chartmuseum" .))) -}}
{{- end -}}

{{/* Chartmuseum TLS secret name */}}
{{- define "harbor.clair.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.clair.tls.existingSecret (printf "%s-crt" (include "harbor.clair" .))) -}}
{{- end -}}

{{/* Chartmuseum TLS secret name */}}
{{- define "harbor.jobservice.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.jobservice.tls.existingSecret (printf "%s-crt" (include "harbor.jobservice" .))) -}}
{{- end -}}

{{/* Chartmuseum TLS secret name */}}
{{- define "harbor.portal.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.portal.tls.existingSecret (printf "%s-crt" (include "harbor.portal" .))) -}}
{{- end -}}

{{/* Chartmuseum TLS secret name */}}
{{- define "harbor.registry.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.registry.tls.existingSecret (printf "%s-crt" (include "harbor.registry" .))) -}}
{{- end -}}

{{/* Chartmuseum TLS secret name */}}
{{- define "harbor.trivy.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.trivy.tls.existingSecret (printf "%s-crt" (include "harbor.trivy" .))) -}}
{{- end -}}

{{/*
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

{{- define "harbor.database.clairUsername" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.postgresqlUsername -}}
  {{- else -}}
    {{- if .Values.externalDatabase.clairUsername -}}
        {{- .Values.externalDatabase.clairUsername -}}
    {{- else -}}
        {{- .Values.externalDatabase.user -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.notaryServerUsername" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.postgresqlUsername -}}
  {{- else -}}
    {{- if .Values.externalDatabase.notaryServerUsername -}}
        {{- .Values.externalDatabase.notaryServerUsername -}}
    {{- else -}}
        {{- .Values.externalDatabase.user -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.notarySignerUsername" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.postgresqlUsername -}}
  {{- else -}}
    {{- if .Values.externalDatabase.notarySignerUsername -}}
        {{- .Values.externalDatabase.notarySignerUsername -}}
    {{- else -}}
        {{- .Values.externalDatabase.user -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.rawPassword" -}}
  {{- if eq .Values.postgresql.enabled true -}}
      {{- .Values.postgresql.postgresqlPassword -}}
  {{- else -}}
      {{- .Values.externalDatabase.password -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.clairRawPassword" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.postgresqlPassword -}}
  {{- else -}}
    {{- if .Values.externalDatabase.clairPassword -}}
        {{- .Values.externalDatabase.clairPassword -}}
    {{- else -}}
        {{- .Values.externalDatabase.password -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.notaryServerRawPassword" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.postgresqlPassword -}}
  {{- else -}}
    {{- if .Values.externalDatabase.notaryServerPassword -}}
        {{- .Values.externalDatabase.notaryServerPassword -}}
    {{- else -}}
        {{- .Values.externalDatabase.password -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.notarySignerRawPassword" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.postgresqlPassword -}}
  {{- else -}}
    {{- if .Values.externalDatabase.notarySignerPassword -}}
        {{- .Values.externalDatabase.notarySignerPassword -}}
    {{- else -}}
        {{- .Values.externalDatabase.password -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.database.escapedClairRawPassword" -}}
  {{- include "harbor.database.clairRawPassword" . | urlquery | replace "+" "%20" -}}
{{- end -}}

{{ define "harbor.database.escapedNotaryServerRawPassword" -}}
  {{- include "harbor.database.notaryServerRawPassword" . | urlquery | replace "+" "%20" -}}
{{- end -}}

{{- define "harbor.database.escapedNotarySignerRawPassword" -}}
  {{- include "harbor.database.notarySignerRawPassword" . | urlquery | replace "+" "%20" -}}
{{- end -}}

{{- define "harbor.database.encryptedPassword" -}}
  {{- include "harbor.database.rawPassword" . | b64enc | quote -}}
{{- end -}}

{{- define "harbor.database.encryptedClairPassword" -}}
  {{- include "harbor.database.clairRawPassword" . | b64enc | quote -}}
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
postgres://{{ template "harbor.database.clairUsername" . }}:{{ template "harbor.database.escapedClairRawPassword" . }}@{{ template "harbor.database.host" . }}:{{ template "harbor.database.port" . }}/{{ template "harbor.database.clairDatabase" . }}?sslmode={{ template "harbor.database.sslmode" . }}
{{- end -}}

{{- define "harbor.database.notaryServer" -}}
postgres://{{ template "harbor.database.notaryServerUsername" . }}:{{ template "harbor.database.escapedNotaryServerRawPassword" . }}@{{ template "harbor.database.host" . }}:{{ template "harbor.database.port" . }}/{{ template "harbor.database.notaryServerDatabase" . }}?sslmode={{ template "harbor.database.sslmode" . }}
{{- end -}}

{{- define "harbor.database.notarySigner" -}}
postgres://{{ template "harbor.database.notarySignerUsername" . }}:{{ template "harbor.database.escapedNotarySignerRawPassword" . }}@{{ template "harbor.database.host" . }}:{{ template "harbor.database.port" . }}/{{ template "harbor.database.notarySignerDatabase" . }}?sslmode={{ template "harbor.database.sslmode" . }}
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
    {{- if eq .Values.externalRedis.sentinel.enabled true -}}
        {{- .Values.externalRedis.sentinel.hosts -}}/{{- .Values.externalRedis.sentinel.masterSet -}}
    {{- else -}}
        {{- .Values.externalRedis.host -}}
    {{- end -}}
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

{{- define "harbor.redis.clairAdapterDatabaseIndex" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "4" -}}
  {{- else -}}
    {{- .Values.externalRedis.clairAdapterDatabaseIndex -}}
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

{{- define "harbor.redis.trivyAdapterDatabaseIndex" -}}
  {{- if .Values.redis.enabled -}}
    {{- printf "%s" "5" -}}
  {{- else -}}
    {{- .Values.externalRedis.trivyAdapterDatabaseIndex -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redis.escapedRawPassword" -}}
  {{- if (include "harbor.redis.rawPassword" . ) -}}
    {{- include "harbor.redis.rawPassword" . | urlquery | replace "+" "%20" -}}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "harbor.redisForJobservice" -}}
  {{- if eq .Values.externalRedis.sentinel.enabled false -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://redis:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- else -}}
      {{- template "harbor.redis.host" . -}}:{{ template "harbor.redis.port" . -}}/{{ template "harbor.redis.jobserviceDatabaseIndex" . -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis+sentinel://redis:%s@%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis+sentinel://%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "harbor.redisForGC" -}}
  {{- if eq .Values.externalRedis.sentinel.enabled false -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://redis:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis+sentinel://redis:%s@%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis+sentinel://%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.registryDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "harbor.redisForClairAdapter" -}}
  {{- if eq .Values.externalRedis.sentinel.enabled false -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://redis:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.clairAdapterDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.clairAdapterDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis+sentinel://redis:%s@%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.clairAdapterDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis+sentinel://%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.clairAdapterDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redisForTrivyAdapter" -}}
  {{- if eq .Values.externalRedis.sentinel.enabled false -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://redis:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis+sentinel://redis:%s@%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis+sentinel://%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redisForCore" -}}
  {{- if eq .Values.externalRedis.sentinel.enabled false -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://redis:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis+sentinel://redis:%s@%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.coreDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis+sentinel://%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.coreDatabaseIndex" . ) -}}
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

{{- define "harbor.chartmuseum" -}}
  {{- printf "%s-chartmuseum" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.database" -}}
  {{- printf "%s-database" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.clair" -}}
  {{- printf "%s-clair" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.trivy" -}}
  {{- printf "%s-trivy" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.notary-server" -}}
  {{- printf "%s-notary-server" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.notary-signer" -}}
  {{- printf "%s-notary-signer" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.nginx" -}}
  {{- printf "%s-nginx" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.ingress" -}}
  {{- printf "%s-ingress" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.ingress-notary" -}}
  {{- printf "%s-ingress-notary" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "harbor.noProxy" -}}
  {{- printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" (include "harbor.core" .) (include "harbor.jobservice" .) (include "harbor.database" .) (include "harbor.chartmuseum" .) (include "harbor.clair" .) (include "harbor.notary-server" .) (include "harbor.notary-signer" .) (include "harbor.registry" .) (include "harbor.portal" .) (include "harbor.trivy" .) .Values.proxy.noProxy -}}
{{- end -}}

{{/*
Return the proper Harbor Core image name
*/}}
{{- define "harbor.coreImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.coreImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Portal image name
*/}}
{{- define "harbor.portalImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.portalImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Trivy Adapter image name
*/}}
{{- define "harbor.trivyImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.trivyImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Job Service image name
*/}}
{{- define "harbor.jobserviceImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.jobserviceImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper ChartMuseum image name
*/}}
{{- define "harbor.chartMuseumImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.chartMuseumImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Notary Server image name
*/}}
{{- define "harbor.notaryServerImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.notaryServerImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Notary Signer image name
*/}}
{{- define "harbor.notarySignerImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.notarySignerImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Registry image name
*/}}
{{- define "harbor.registryImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.registryImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Registryctl image name
*/}}
{{- define "harbor.registryctlImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.registryctlImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Clair image name
*/}}
{{- define "harbor.clairImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.clairImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Clair image name
*/}}
{{- define "harbor.clairAdapterImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.clairAdapterImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Nginx image name
*/}}
{{- define "harbor.nginxImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.nginxImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "harbor.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.coreImage .Values.portalImage .Values.jobserviceImage .Values.clairImage .Values.clairAdapterImage .Values.trivyImage .Values.notaryServerImage .Values.notarySignerImage .Values.registryImage .Values.registryctlImage .Values.nginxImage .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "harbor.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.coreImage -}}
{{- include "common.warnings.rollingTag" .Values.portalImage -}}
{{- include "common.warnings.rollingTag" .Values.jobserviceImage -}}
{{- include "common.warnings.rollingTag" .Values.registryImage -}}
{{- include "common.warnings.rollingTag" .Values.registryctlImage -}}
{{- include "common.warnings.rollingTag" .Values.clairImage -}}
{{- include "common.warnings.rollingTag" .Values.clairAdapterImage -}}
{{- include "common.warnings.rollingTag" .Values.trivyImage -}}
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

{{/* Validate .Values of Harbor - must provide a password for PostgreSQL */}}
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
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Storage Class for chartmuseum
*/}}
{{- define "harbor.chartmuseum.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence.persistentVolumeClaim.chartmuseum "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Storage Class for jobservice
*/}}
{{- define "harbor.jobservice.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence.persistentVolumeClaim.jobservice "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Storage Class for registry
*/}}
{{- define "harbor.registry.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence.persistentVolumeClaim.registry "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Storage Class for trivy
*/}}
{{- define "harbor.trivy.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence.persistentVolumeClaim.trivy "global" .Values.global ) -}}
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
