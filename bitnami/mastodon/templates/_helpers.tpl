{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Mastodon image name
*/}}
{{- define "mastodon.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "mastodon.volumePermissions.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mastodon.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Mastodon web fullname
*/}}
{{- define "mastodon.web.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "web" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Mastodon tootctlMediaManagement fullname
*/}}
{{- define "mastodon.tootctlMediaManagement.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "tootctl-media" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Mastodon tootctl media option to include follows
*/}}
{{- define "mastodon.tootctlMediaManagement.includeFollows" -}}
    {{- if .Values.tootctlMediaManagement.includeFollows -}}
    	{{- print "--include-follows" -}}	
    {{- end -}}
{{- end -}}

{{/*
Return the proper Mastodon web domain
*/}}
{{- define "mastodon.web.domain" -}}
    {{- if .Values.webDomain -}}
        {{- print .Values.webDomain -}}
    {{- else if .Values.apache.enabled -}}
        {{- if .Values.apache.ingress.enabled -}}
        {{- print .Values.apache.ingress.hostname -}}
        {{- else if .Values.apache.service.loadBalancerIP -}}
        {{- print .Values.apache.service.loadBalancerIP -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Return the proper Mastodon streaming fullname
*/}}
{{- define "mastodon.streaming.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "streaming" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return Mastodon streaming url
*/}}
{{- define "mastodon.streaming.url" -}}
  {{- if .Values.useSecureWebSocket -}}
    {{- printf "wss://%s" (include "mastodon.web.domain" .) | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "ws://%s" (include "mastodon.web.domain" .) | trunc 63 | trimSuffix "-" -}}
  {{- end -}}  
{{- end -}}

{{/*
Default configuration ConfigMap name
*/}}
{{- define "mastodon.defaultConfigmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- print .Values.existingConfigmap -}}
{{- else -}}
    {{- printf "%s-default" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name
*/}}
{{- define "mastodon.extraConfigmapName" -}}
{{- if .Values.extraConfigExistingConfigmap -}}
    {{- print .Values.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Default configuration Secret name
*/}}
{{- define "mastodon.defaultSecretName" -}}
{{- if .Values.existingSecret -}}
    {{- print .Values.existingSecret -}}
{{- else -}}
    {{- printf "%s-default" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Extra configuration Secret name
*/}}
{{- define "mastodon.extraSecretName" -}}
{{- if .Values.extraConfigExistingSecret -}}
    {{- print .Values.extraConfigExistingSecret -}}
{{- else -}}
    {{- printf "%s-extra" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "mastodon.pvc" -}}
{{- coalesce .Values.persistence.existingClaim (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return MinIO(TM) fullname
*/}}
{{- define "mastodon.minio.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "minio" "chartValues" .Values.minio "context" $) -}}
{{- end -}}

{{/*
Return the S3 backend host
*/}}
{{- define "mastodon.s3.host" -}}
    {{- if .Values.minio.enabled -}}
        {{- include "mastodon.minio.fullname" . -}}
    {{- else -}}
        {{- print .Values.externalS3.host -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 alias host
*/}}
{{- define "mastodon.s3.aliasHost" -}}
    {{- if .Values.s3AliasHost -}}
        {{- print .Values.s3AliasHost -}}
    {{- else if .Values.minio.enabled -}}
        {{- if .Values.minio.service.loadBalancerIP }}
            {{- print .Values.minio.service.loadBalancerIP -}}
        {{- else -}}
            {{- printf "%s/%s" (include "mastodon.web.domain" .)  (include "mastodon.s3.bucket" . ) -}}
        {{- end -}}
    {{- else if .Values.externalS3.host -}}
        {{- print .Values.externalS3.host -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 bucket
*/}}
{{- define "mastodon.s3.bucket" -}}
    {{- if .Values.minio.enabled -}}
        {{- print .Values.minio.defaultBuckets -}}
    {{- else -}}
        {{- print .Values.externalS3.bucket -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 protocol
*/}}
{{- define "mastodon.s3.protocol" -}}
    {{- if .Values.minio.enabled -}}
        {{- ternary "https" "http" .Values.minio.tls.enabled  -}}
    {{- else -}}
        {{- print .Values.externalS3.protocol -}}
    {{- end -}}
{{- end -}}

{{- define "mastodon.s3.protocol.setting" -}}
    {{- if .Values.forceHttpsS3Protocol -}}
        {{- print "https" -}}
    {{- else -}}
        {{- print (include "mastodon.s3.protocol" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 region
*/}}
{{- define "mastodon.s3.region" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "us-east-1"  -}}
    {{- else -}}
        {{- print .Values.externalS3.region -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 port
*/}}
{{- define "mastodon.s3.port" -}}
{{- ternary .Values.minio.service.ports.api .Values.externalS3.port .Values.minio.enabled -}}
{{- end -}}

{{/*
Return the S3 endpoint
*/}}
{{- define "mastodon.s3.endpoint" -}}
{{- $port := include "mastodon.s3.port" . | int -}}
{{- $printedPort := "" -}}
{{- if and (ne $port 80) (ne $port 443) -}}
    {{- $printedPort = printf ":%d" $port -}}
{{- end -}}
{{- printf "%s://%s%s" (include "mastodon.s3.protocol" .) (include "mastodon.s3.host" .) $printedPort -}}
{{- end -}}

{{/*
Return the S3 credentials secret name
*/}}
{{- define "mastodon.s3.secretName" -}}
{{- if .Values.minio.enabled -}}
    {{- if .Values.minio.auth.existingSecret -}}
    {{- print .Values.minio.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "mastodon.minio.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalS3.existingSecret -}}
    {{- print .Values.externalS3.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "common.names.fullname" .) "externals3" -}}
{{- end -}}
{{- end -}}

{{/*
Return the S3 access key id inside the secret
*/}}
{{- define "mastodon.s3.accessKeyIDKey" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "root-user"  -}}
    {{- else -}}
        {{- print .Values.externalS3.existingSecretAccessKeyIDKey -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 secret access key inside the secret
*/}}
{{- define "mastodon.s3.secretAccessKeyKey" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "root-password"  -}}
    {{- else -}}
        {{- print .Values.externalS3.existingSecretKeySecretKey -}}
    {{- end -}}
{{- end -}}

{{/*
Return the proper Mastodon sidekiq fullname
*/}}
{{- define "mastodon.sidekiq.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "sidekiq" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return true if the init job should be created
*/}}
{{- define "mastodon.createInitJob" -}}
{{- if or .Values.initJob.migrateDB .Values.initJob.createAdmin .Values.initJob.precompileAssets .Values.initJob.migrateElasticsearch -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "mastodon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Return Elasticsearch fullname
*/}}
{{- define "mastodon.elasticsearch.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "elasticsearch" "chartValues" .Values.elasticsearch "context" $) -}}
{{- end -}}

{{/*
Return true if Elasticseach auth is enabled
*/}}
{{- define "mastodon.elasticsearch.auth.enabled" -}}
{{- if .Values.elasticsearch.enabled -}}
    {{- if .Values.elasticsearch.security.enabled -}}
        {{- true -}}
    {{- end -}}
{{- else if .Values.externalElasticsearch.password -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Elasticsearch Secret Name
*/}}
{{- define "mastodon.elasticsearch.secretName" -}}
{{- if .Values.elasticsearch.enabled -}}
    {{- print (include "mastodon.elasticsearch.fullname" .) -}}
{{- else if .Values.externalElasticsearch.existingSecret -}}
    {{- print .Values.externalElasticsearch.existingSecret -}}
{{- else -}}
    {{- printf "%s-externalelasticsearch" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve key of the Elasticsearch secret
*/}}
{{- define "mastodon.elasticsearch.passwordKey" -}}
{{- if .Values.elasticsearch.enabled -}}
    {{- print "elasticsearch-password" -}}
{{- else -}}
    {{- print .Values.externalElasticsearch.existingSecretPasswordKey -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified Elasticsearch name.
*/}}
{{- define "mastodon.elasticsearch.host" -}}
{{- if .Values.elasticsearch.enabled -}}
    {{- include "mastodon.elasticsearch.fullname" . -}}
{{- else -}}
    {{- print .Values.externalElasticsearch.host -}}
{{- end -}}
{{- end -}}

{{/*
Return Elasticsearch port
*/}}
{{- define "mastodon.elasticsearch.port" -}}
{{- if .Values.elasticsearch.enabled -}}
    {{- print .Values.elasticsearch.service.ports.restAPI -}}
{{- else -}}
    {{- print .Values.externalElasticsearch.port -}}
{{- end -}}
{{- end -}}

{{/*
Return Redis(TM) fullname
*/}}
{{- define "mastodon.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified Redis(TM) name.
*/}}
{{- define "mastodon.redis.host" -}}
{{- if .Values.redis.enabled -}}
    {{- printf "%s-master" (include "mastodon.redis.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- print .Values.externalRedis.host -}}
{{- end -}}
{{- end -}}

{{/*
Return Redis(TM) port
*/}}
{{- define "mastodon.redis.port" -}}
{{- if .Values.redis.enabled -}}
    {{- print .Values.redis.master.service.ports.redis -}}
{{- else -}}
    {{- print .Values.externalRedis.port  -}}
{{- end -}}
{{- end -}}

{{/*
Return if Redis(TM) authentication is enabled
*/}}
{{- define "mastodon.redis.auth.enabled" -}}
{{- if .Values.redis.enabled -}}
    {{- if .Values.redis.auth.enabled -}}
        {{- true -}}
    {{- end -}}
{{- else if or .Values.externalRedis.password .Values.externalRedis.existingSecret -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis(TM) Secret Name
*/}}
{{- define "mastodon.redis.secretName" -}}
{{- if .Values.redis.enabled -}}
    {{- print (include "mastodon.redis.fullname" .) -}}
{{- else if .Values.externalRedis.existingSecret -}}
    {{- print .Values.externalRedis.existingSecret -}}
{{- else -}}
    {{- printf "%s-externalredis" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve key of the Redis(TM) secret
*/}}
{{- define "mastodon.redis.passwordKey" -}}
{{- if .Values.redis.enabled -}}
    {{- print "redis-password" -}}
{{- else -}}
    {{- if .Values.externalRedis.existingSecret -}}
        {{- if .Values.externalRedis.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalRedis.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "redis-password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "redis-password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL fullname
*/}}
{{- define "mastodon.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the PostgreSQL Hostname
*/}}
{{- define "mastodon.database.host" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if eq .Values.postgresql.architecture "replication" -}}
        {{- printf "%s-%s" (include "mastodon.postgresql.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- print (include "mastodon.postgresql.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- print .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Port
*/}}
{{- define "mastodon.database.port" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print .Values.postgresql.primary.service.ports.postgresql -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL User
*/}}
{{- define "mastodon.database.user" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print .Values.postgresql.auth.username -}}
{{- else -}}
    {{- print .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL database name
*/}}
{{- define "mastodon.database.name" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print .Values.postgresql.auth.database -}}
{{- else -}}
    {{- print .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Secret Name
*/}}
{{- define "mastodon.database.secretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
    {{- print .Values.postgresql.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "mastodon.postgresql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- print .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "common.names.fullname" .) "externaldb" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve key of the PostgreSQL secret
*/}}
{{- define "mastodon.database.passwordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- print .Values.externalDatabase.existingSecretPasswordKey -}}
{{- end -}}
{{- end -}}

{{/*
Return the SMTP Secret Name
*/}}
{{- define "mastodon.smtp.secretName" -}}
{{- if .Values.smtp.existingSecret -}}
    {{- print .Values.smtp.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "common.names.fullname" .) "smtp" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve SMTP server key
*/}}
{{- define "mastodon.smtp.serverKey" -}}
{{- if .Values.smtp.existingSecretServerKey -}}
    {{- print .Values.smtp.existingSecretServerKey -}}
{{- else -}}
    {{- print "server" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve SMTP login key
*/}}
{{- define "mastodon.smtp.loginKey" -}}
{{- if .Values.smtp.existingSecretLoginKey -}}
    {{- print .Values.smtp.existingSecretLoginKey -}}
{{- else -}}
    {{- print "login" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve SMTP password key
*/}}
{{- define "mastodon.smtp.passwordKey" -}}
{{- if .Values.smtp.existingSecretPasswordKey -}}
    {{- print .Values.smtp.existingSecretPasswordKey -}}
{{- else -}}
    {{- print "password" -}}
{{- end -}}
{{- end -}}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "mastodon.waitForDBInitContainer" -}}
# We need to wait for the PostgreSQL database to be ready in order to start with Mastodon.
# As it is a ReplicaSet, we need that all nodes are configured in order to start with
# the application or race conditions can occur
- name: wait-for-db
  image: {{ template "mastodon.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.web.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.web.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash

      set -o errexit
      set -o nounset
      set -o pipefail

      . /opt/bitnami/scripts/liblog.sh
      . /opt/bitnami/scripts/libvalidations.sh
      . /opt/bitnami/scripts/libmastodon.sh
      . /opt/bitnami/scripts/mastodon-env.sh

      mastodon_wait_for_postgresql_connection "postgresql://${MASTODON_DATABASE_USER}:${MASTODON_DATABASE_PASSWORD:-}@${MASTODON_DATABASE_HOST}:${MASTODON_DATABASE_PORT_NUMBER}/${MASTODON_DATABASE_NAME}"
      info "Database is ready"
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.image.debug .Values.diagnosticMode.enabled) | quote }}
    - name: MASTODON_DATABASE_HOST
      value: {{ include "mastodon.database.host" . | quote }}
    - name: MASTODON_DATABASE_PORT_NUMBER
      value: {{ include "mastodon.database.port" . | quote }}
    - name: MASTODON_DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "mastodon.database.secretName" . }}
          key: {{ include "mastodon.database.passwordKey" . }}
    - name: MASTODON_DATABASE_USER
      value: {{ include "mastodon.database.user" . }}
    - name: MASTODON_DATABASE_NAME
      value: {{ include "mastodon.database.name" . }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}

{{/*
Init container definition for waiting for Redis(TM) to be ready
*/}}
{{- define "mastodon.waitForRedisInitContainer" }}
# We need to wait for the Redis(TM) to be ready in order to start with Mastodon.
# As it is a ReplicaSet, we need that all nodes are configured in order to start with
# the application or race conditions can occur
- name: wait-for-redis
  image: {{ template "mastodon.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.web.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.web.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash

      set -o errexit
      set -o nounset
      set -o pipefail

      . /opt/bitnami/scripts/liblog.sh
      . /opt/bitnami/scripts/libvalidations.sh
      . /opt/bitnami/scripts/libmastodon.sh
      . /opt/bitnami/scripts/mastodon-env.sh

      mastodon_wait_for_redis_connection "redis://${MASTODON_REDIS_PASSWORD:-}@${MASTODON_REDIS_HOST}:${MASTODON_REDIS_PORT_NUMBER}"
      info "Redis(TM) is ready"
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.image.debug .Values.diagnosticMode.enabled) | quote }}
    - name: MASTODON_REDIS_HOST
      value: {{ include "mastodon.redis.host" . | quote }}
    - name: MASTODON_REDIS_PORT_NUMBER
      value: {{ include "mastodon.redis.port" . | quote }}
    {{- if (include "mastodon.redis.auth.enabled" .) }}
    - name: MASTODON_REDIS_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "mastodon.redis.secretName" . }}
          key: {{ include "mastodon.redis.passwordKey" . }}
    {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}

{{/*
Init container definition for waiting for Elasticsearch to be ready
*/}}
{{- define "mastodon.waitForElasticsearchInitContainer" -}}
- name: wait-for-elasticsearch
  image: {{ template "mastodon.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.web.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.web.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash

      set -o errexit
      set -o nounset
      set -o pipefail

      . /opt/bitnami/scripts/liblog.sh
      . /opt/bitnami/scripts/libvalidations.sh
      . /opt/bitnami/scripts/libmastodon.sh
      . /opt/bitnami/scripts/mastodon-env.sh

      mastodon_wait_for_elasticsearch_connection "http://${MASTODON_ELASTICSEARCH_HOST}:${MASTODON_ELASTICSEARCH_PORT_NUMBER}"
      info "Mastodon web is ready"
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.image.debug .Values.diagnosticMode.enabled) | quote }}
    - name: MASTODON_ELASTICSEARCH_HOST
      value: {{ include "mastodon.elasticsearch.host" . | quote }}
    - name: MASTODON_ELASTICSEARCH_PORT_NUMBER
      value: {{ include "mastodon.elasticsearch.port" . | quote }}
    {{- if (include "mastodon.elasticsearch.auth.enabled" .) }}
    - name: MASTODON_ELASTICSEARCH_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "mastodon.elasticsearch.secretName" . }}
          key: {{ include "mastodon.elasticsearch.passwordKey" . }}
    {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}

{{/*
Init container definition for waiting for S3 to be ready
*/}}
{{- define "mastodon.waitForS3InitContainer" -}}
- name: wait-for-s3
  image: {{ template "mastodon.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.web.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.web.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash

      set -o errexit
      set -o nounset
      set -o pipefail

      . /opt/bitnami/scripts/liblog.sh
      . /opt/bitnami/scripts/libvalidations.sh
      . /opt/bitnami/scripts/libmastodon.sh
      . /opt/bitnami/scripts/mastodon-env.sh

      mastodon_wait_for_s3_connection "$MASTODON_S3_HOSTNAME" "$MASTODON_S3_PORT_NUMBER"
      info "S3 is ready"
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.image.debug .Values.diagnosticMode.enabled) | quote }}
    - name: MASTODON_S3_HOSTNAME
      value: {{ include "mastodon.s3.host" . | quote }}
    - name: MASTODON_S3_PORT_NUMBER
      value: {{ include "mastodon.s3.port" . | quote }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}

{{/*
Init container definition for waiting for Mastodon Web to be ready
*/}}
{{- define "mastodon.waitForWebInitContainer" -}}
- name: wait-for-web
  image: {{ template "mastodon.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.web.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.web.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash

      set -o errexit
      set -o nounset
      set -o pipefail

      . /opt/bitnami/scripts/liblog.sh
      . /opt/bitnami/scripts/libvalidations.sh
      . /opt/bitnami/scripts/libmastodon.sh
      . /opt/bitnami/scripts/mastodon-env.sh

      mastodon_wait_for_web_connection "http://${MASTODON_WEB_HOST}:${MASTODON_WEB_PORT}"
      info "Mastodon web is ready"
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.image.debug .Values.diagnosticMode.enabled) | quote }}
    - name: MASTODON_WEB_HOST
      value: {{ include "mastodon.web.fullname" . | quote }}
    - name: MASTODON_WEB_PORT
      value: {{ .Values.web.service.ports.http | quote }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}

{{/*
Return Apache fullname
*/}}
{{- define "mastodon.apache.fullname" -}}
    {{- include "common.names.dependency.fullname" (dict "chartName" "apache" "chartValues" .Values.apache "context" $) -}}
{{- end -}}

{{/*
Return name of the Apache vhost configmap
*/}}
{{- define "mastodon.apache.vhostconfigmap" -}}
    {{- if .Values.apache -}}
        {{- printf "%s-mastodon-vhost" (include "mastodon.apache.fullname" .) -}}
    {{- else -}}
        {{- /* HACK: If this helper is called inside the Apache subchart, it won't use the Mastodon scope
        but the Apache scope, therefore the helper mastodon.apache.fullname will fail because .Values.apache will not exist
        that's why we need to use the common.names.fullname instead */ -}}
        {{- printf "%s-mastodon-vhost" (include "common.names.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "mastodon.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "mastodon.validateValues.postgresql" .) -}}
{{- $messages := append $messages (include "mastodon.validateValues.redis" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Mastodon - PostgreSQL */}}
{{- define "mastodon.validateValues.postgresql" -}}
{{- if and .Values.postgresql.enabled .Values.externalDatabase.host -}}
mastodon: PostgreSQL
    You can only use one database.
    Please choose installing a PostgreSQL chart (--set postgresql.enabled=true) or
    using an external database (--set externalDatabase.host)
{{- end -}}
{{- if and (not .Values.postgresql.enabled) (not .Values.externalDatabase.host) -}}
mastodon: NoPostgreSQL
    You did not set any database.
    Please choose installing a PostgreSQL chart (--set postgresql.enabled=true) or
    using an external instance (--set externalDatabase.host)
{{- end -}}
{{- end -}}

{{/* Validate values of Mastodon - Redis(TM) */}}
{{- define "mastodon.validateValues.redis" -}}
{{- if and .Values.redis.enabled .Values.externalRedis.host -}}
mastodon: Redis
    You can only use one Redis.
    Please choose installing a Redis(TM) chart (--set redis.enabled=true) or
    using an external Redis(TM) (--set externalRedis.host)
{{- end -}}
{{- if and (not .Values.redis.enabled) (not .Values.externalRedis.host) -}}
mastodon: NoRedis
    You did not set any Redis.
    Please choose installing a Redis(TM) chart (--set redis.enabled=true) or
    using an external instance (--set externalRedis.host)
{{- end -}}
{{- end -}}
