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

{{/* Harbor Adapter for Clair URL */}}
{{- define "harbor.clairAdapter.url" -}}
  {{- printf "%s://%s:%d" (ternary "https" "http" .Values.internalTLS.enabled) (include "harbor.clair" .) (ternary .Values.clair.adapter.service.ports.https .Values.clair.adapter.service.ports.http .Values.internalTLS.enabled | int ) -}}
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

{{- define "harbor.chartmuseum.url" -}}
  {{- printf "%s://%s:%d" (ternary "https" "http" .Values.internalTLS.enabled) (include "harbor.chartmuseum" .) (ternary .Values.chartmuseum.service.ports.https .Values.chartmuseum.service.ports.http .Values.internalTLS.enabled | int) -}}
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

{{/* Chartmuseum TLS secret name */}}
{{- define "harbor.chartmuseum.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.chartmuseum.tls.existingSecret (printf "%s-crt" (include "harbor.chartmuseum" .))) -}}
{{- end -}}

{{/* Clair TLS secret name */}}
{{- define "harbor.clair.tls.secretName" -}}
{{- printf "%s" (coalesce .Values.clair.tls.existingSecret (printf "%s-crt" (include "harbor.clair" .))) -}}
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

{{- define "harbor.database.clairUsername" -}}
{{- ternary "postgres" (default .Values.externalDatabase.user .Values.externalDatabase.clairUsername) .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.notaryServerUsername" -}}
{{- ternary "postgres" (default .Values.externalDatabase.user .Values.externalDatabase.notaryServerUsername) .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.notarySignerUsername" -}}
{{- ternary "postgres" (default .Values.externalDatabase.user .Values.externalDatabase.notarySignerUsername) .Values.postgresql.enabled -}}
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

{{- define "harbor.database.clairRawPassword" -}}
{{- ternary (include "harbor.database.rawPassword" .) (default .Values.externalDatabase.password .Values.externalDatabase.clairPassword) .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.notaryServerRawPassword" -}}
{{- ternary (include "harbor.database.rawPassword" .) (default .Values.externalDatabase.password .Values.externalDatabase.notaryServerPassword) .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.notarySignerRawPassword" -}}
{{- ternary (include "harbor.database.rawPassword" .) (default .Values.externalDatabase.password .Values.externalDatabase.notarySignerPassword) .Values.postgresql.enabled -}}
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
{{- ternary "registry" .Values.externalDatabase.coreDatabase .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.clairDatabase" -}}
{{- ternary "postgres" .Values.externalDatabase.clairDatabase .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.notaryServerDatabase" -}}
{{- ternary "notaryserver" .Values.externalDatabase.notaryServerDatabase .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.notarySignerDatabase" -}}
{{- ternary "notarysigner" .Values.externalDatabase.notarySignerDatabase .Values.postgresql.enabled -}}
{{- end -}}

{{- define "harbor.database.sslmode" -}}
{{- ternary "disable" .Values.externalDatabase.sslmode .Values.postgresql.enabled -}}
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

{{/*
Create a default fully qualified app name
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "harbor.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{- define "harbor.redis.host" -}}
{{- ternary (printf "%s-master" (include "harbor.redis.fullname" .)) (ternary (printf "%s/%s" .Values.externalRedis.sentinel.hosts .Values.externalRedis.sentinel.masterSet) .Values.externalRedis.host .Values.externalRedis.sentinel.enabled) .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.port" -}}
{{- ternary "6379" .Values.externalRedis.port .Values.redis.enabled -}}
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

{{- define "harbor.redis.chartmuseumDatabaseIndex" -}}
{{- ternary "3" .Values.externalRedis.chartmuseumDatabaseIndex .Values.redis.enabled -}}
{{- end -}}

{{- define "harbor.redis.clairAdapterDatabaseIndex" -}}
{{- ternary "4" .Values.externalRedis.clairAdapterDatabaseIndex .Values.redis.enabled -}}
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
  {{- if eq .Values.externalRedis.sentinel.enabled false -}}
    {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://redis:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.jobserviceDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" .) (include "harbor.redis.port" .) (include "harbor.redis.jobserviceDatabaseIndex" .) -}}
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

{{- define "harbor.exporter" -}}
  {{- printf "%s-exporter" (include "common.names.fullname" .) -}}
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
Return the proper ChartMuseum image name
*/}}
{{- define "harbor.chartmuseum.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.chartmuseum.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Notary Server image name
*/}}
{{- define "harbor.notary.server.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.notary.server.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Notary Signer image name
*/}}
{{- define "harbor.notary.signer.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.notary.signer.image "global" .Values.global ) -}}
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
Return the proper Harbor Clair image name
*/}}
{{- define "harbor.clair.server.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.clair.server.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Harbor Clair image name
*/}}
{{- define "harbor.clair.adapter.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.clair.adapter.image "global" .Values.global ) -}}
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
{{- include "common.images.pullSecrets" (dict "images" (list .Values.core.image .Values.exporter.image .Values.portal.image .Values.jobservice.image .Values.clair.server.image .Values.clair.adapter.image .Values.chartmuseum.image .Values.trivy.image .Values.notary.server.image .Values.notary.signer.image .Values.registry.server.image .Values.registry.controller.image .Values.nginx.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "harbor.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.core.image -}}
{{- include "common.warnings.rollingTag" .Values.portal.image -}}
{{- include "common.warnings.rollingTag" .Values.jobservice.image -}}
{{- include "common.warnings.rollingTag" .Values.registry.server.image -}}
{{- include "common.warnings.rollingTag" .Values.registry.controller.image -}}
{{- include "common.warnings.rollingTag" .Values.clair.server.image -}}
{{- include "common.warnings.rollingTag" .Values.clair.adapter.image -}}
{{- include "common.warnings.rollingTag" .Values.chartmuseum.image -}}
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
