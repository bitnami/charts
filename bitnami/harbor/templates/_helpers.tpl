{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "harbor.name" -}}
{{- default "harbor" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
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

{{- define "harbor.redis.clairAdapterDatabaseIndex" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "4" }}
  {{- else -}}
    {{- .Values.externalRedis.clairAdapterIndex -}}
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
    {{- printf "%s" "5" }}
  {{- else -}}
    {{- .Values.externalRedis.trivyAdapterIndex -}}
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
    {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.clairAdapterDatabaseIndex" . ) -}}
  {{- end -}}
{{- end -}}

{{- define "harbor.redisForTrivyAdapter" -}}
  {{- if (include "harbor.redis.escapedRawPassword" . ) -}}
    {{- printf "redis://redis:%s@%s:%s/%s" (include "harbor.redis.escapedRawPassword" . ) (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) }}
  {{- else }}
    {{- printf "redis://%s:%s/%s" (include "harbor.redis.host" . ) (include "harbor.redis.port" . ) (include "harbor.redis.trivyAdapterDatabaseIndex" . ) -}}
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

{{- define "harbor.noProxy" -}}
  {{- printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" (include "harbor.core" .) (include "harbor.jobservice" .) (include "harbor.database" .) (include "harbor.chartmuseum" .) (include "harbor.clair" .) (include "harbor.notary-server" .) (include "harbor.notary-signer" .) (include "harbor.registry" .) (include "harbor.portal" .) .Values.proxy.noProxy -}}
{{- end -}}

{{/*
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
{{- include "common.images.image" ( dict "imageRoot" Values.coreImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Harbor Portal image name
*/}}
{{- define "harbor.portalImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.portalImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Harbor Trivy Adapter image name
*/}}
{{- define "harbor.trivyImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.trivyImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Harbor Job Service image name
*/}}
{{- define "harbor.jobserviceImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.jobserviceImage "global" $) -}}
{{- end -}}

{{/*
Return the proper ChartMuseum image name
*/}}
{{- define "harbor.chartMuseumImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.chartMuseumImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Harbor Notary Server image name
*/}}
{{- define "harbor.notaryServerImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.notaryServerImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Harbor Notary Signer image name
*/}}
{{- define "harbor.notarySignerImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.notarySignerImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Harbor Registry image name
*/}}
{{- define "harbor.registryImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.registryImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Harbor Registryctl image name
*/}}
{{- define "harbor.registryctlImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.registryctlImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Harbor Clair image name
*/}}
{{- define "harbor.clairImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.clairImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Harbor Clair image name
*/}}
{{- define "harbor.clairAdapterImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.clairAdapterImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Nginx image name
*/}}
{{- define "harbor.nginxImage" -}}
{{- include "common.images.image" ( dict "imageRoot" Values.nginxImage "global" $) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "harbor.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.coreImage.pullSecrets .Values.portalImage.pullSecrets .Values.jobserviceImage.pullSecrets .Values.clairImage .Values.clairAdapterImage .Values.trivyImage .Values.notaryServerImage.pullSecrets .Values.notarySignerImage.pullSecrets .Values.registryImage.pullSecrets .Values.registryctlImage.pullSecrets .Values.nginxImage.pullSecrets .Values.volumePermissions.image.pullSecrets) "global" $) -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "harbor.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.coreImage -}}
{{- include "common.warnings.rollingTag" .Values.portalImage -}}
{{- include "common.warnings.rollingTag" .Values.jobserviceImage -}}
{{- include "common.warnings.rollingTag" .Values.registryImage -}}
{{- include "common.warnings.rollingTag" .Values.registryctlImage -}}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image -}}
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
{{- include "common.images.image" ( dict "imageRoot" Values.volumePermissions.image "global" $) -}}
{{- end -}}

{{/*
Return the proper Storage Class for chartmuseum
*/}}
{{- define "harbor.chartmuseum.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence.persistentVolumeClaim.chartmuseum "global" $) -}}
{{- end -}}

{{/*
Return the proper Storage Class for jobservice
*/}}
{{- define "harbor.jobservice.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence.persistentVolumeClaim.jobservice "global" $) -}}
{{- end -}}

{{/*
Return the proper Storage Class for registry
*/}}
{{- define "harbor.registry.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence.persistentVolumeClaim.registry "global" $) -}}
{{- end -}}

{{/*
Return the proper Storage Class for trivy
*/}}
{{- define "harbor.trivy.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence.persistentVolumeClaim.trivy "global" $) -}}
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
