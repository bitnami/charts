{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Appsmith image name
*/}}
{{- define "appsmith.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Appsmith image name
*/}}
{{- define "appsmith.redirect.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.backend.redirectAmbassador.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Appsmith backend fullname
*/}}
{{- define "appsmith.backend.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "backend" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Return the proper Appsmith backend fullname
*/}}
{{- define "appsmith.redirect.fullname" -}}
{{- printf "%s-%s" (include "appsmith.backend.fullname" .) "redirect" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Return the proper Appsmith rts fullname
*/}}
{{- define "appsmith.rts.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "rts" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "appsmith.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "appsmith.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image .Values.backend.redirectAmbassador.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "appsmith.backend.secretName" -}}
{{- if .Values.backend.existingSecret -}}
    {{- .Values.backend.existingSecret -}}
{{- else }}
    {{- include "appsmith.backend.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
TODO: Review comments
Retrieve key of the Backend secret (admin password)
*/}}
{{- define "appsmith.backend.password.secretKey" -}}
{{- if .Values.backend.existingSecret -}}
    {{- printf "%s" .Values.backend.existingSecretPasswordKey -}}
{{- else -}}
    {{- print "admin-password" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve key of the Backend secret (encryption salt)
*/}}
{{- define "appsmith.backend.encryptionSalt.secretKey" -}}
{{- if .Values.backend.existingSecret -}}
    {{- printf "%s" .Values.backend.existingSecretEncryptionSaltKey -}}
{{- else -}}
    {{- print "encryption-salt" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve key of the Backend secret (encryption password)
*/}}
{{- define "appsmith.backend.encryptionPassword.secretKey" -}}
{{- if .Values.backend.existingSecret -}}
    {{- printf "%s" .Values.backend.existingSecretEncryptionPasswordKey -}}
{{- else -}}
    {{- print "encryption-password" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "appsmith.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Set the subdirectory for git connected apps to store their local repo
*/}}
{{- define "appsmith.gitDataPath" -}}
{{- if and .Values.backend.persistence.enabled .Values.backend.persistence.gitDataPath -}}
    {{- if .Values.backend.persistence.subPath -}}
        {{- printf "%s/%s/%s" .Values.backend.persistence.mountPath .Values.backend.persistence.subPath .Values.backend.persistence.gitDataPath }}
    {{- else -}}
        {{- printf "%s/%s" .Values.backend.persistence.mountPath .Values.backend.persistence.gitDataPath }}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return Redis(TM) fullname
*/}}
{{- define "appsmith.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified redis name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "appsmith.redis.host" -}}
{{- if .Values.redis.enabled -}}
    {{- printf "%s-master" (include "appsmith.redis.fullname" .) -}}
{{- else -}}
    {{- print .Values.externalRedis.host -}}
{{- end -}}
{{- end -}}

{{/*
Return Redis(TM) port
*/}}
{{- define "appsmith.redis.port" -}}
{{- if .Values.redis.enabled -}}
    {{- print .Values.redis.master.service.ports.redis -}}
{{- else -}}
    {{- print .Values.externalRedis.port  -}}
{{- end -}}
{{- end -}}

{{/*
Return MongoDB fullname
*/}}
{{- define "appsmith.mongodb.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mongodb" "chartValues" .Values.mongodb "context" $) -}}
{{- end -}}

{{/*
Return list of mongodb hosts
*/}}
{{- define "appsmith.mongodb.hosts" -}}
{{- if .Values.mongodb.enabled -}}
    {{- $mongodbfullname := include "appsmith.mongodb.fullname" . -}}
    {{- $replicas := .Values.mongodb.replicaCount | int }}
    {{- $hosts := printf "%s-0.%s-headless" $mongodbfullname $mongodbfullname -}}
    {{- range $i, $_e := until (sub $replicas 1 | int) }}
        {{- $hosts = printf "%s,%s-%d.%s-headless" $hosts $mongodbfullname (add $i 1 | int) $mongodbfullname -}}
    {{- end }}
    {{- print $hosts }}
{{- else -}}
    {{- print (join "," .Values.externalDatabase.hosts)  -}}
{{- end -}}
{{- end -}}

{{/*
Return mongodb port
*/}}
{{- define "appsmith.mongodb.port" -}}
{{- if .Values.mongodb.enabled -}}
    {{/* We are using the headless service so we need to use the container port */}}
    {{- print .Values.mongodb.containerPorts.mongodb -}}
{{- else -}}
    {{- print .Values.externalDatabase.port  -}}
{{- end -}}
{{- end -}}

{{/*
Return the MongoDB Secret Name
*/}}
{{- define "appsmith.mongodb.secretName" -}}
{{- if .Values.mongodb.enabled }}
    {{- printf "%s" (include "appsmith.mongodb.fullname" .) -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "appsmith.waitForDBInitContainer" -}}
# We need to wait for the MongoDB database to be ready in order to start with Appsmith.
# As it is a ReplicaSet, we need that all nodes are configured in order to start with
# the application or race conditions can occur
- name: wait-for-db
  image: {{ template "appsmith.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.backend.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.backend.containerSecurityContext "context" $) | nindent 4 }}
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
      . /opt/bitnami/scripts/libappsmith.sh
      . /opt/bitnami/scripts/appsmith-env.sh

      info "Waiting for MongoDB replica set to come up"
      for host in ${APPSMITH_DATABASE_HOST//,/ }; do
            info "Waiting for host $host"
            appsmith_wait_for_mongodb_connection "mongodb://${APPSMITH_DATABASE_USER}:${APPSMITH_DATABASE_PASSWORD}@${host}:${APPSMITH_DATABASE_PORT_NUMBER}/${APPSMITH_DATABASE_NAME}"
      done
      info "Database is ready"
  env:
    - name: APPSMITH_DATABASE_HOST
      value: {{ include "appsmith.mongodb.hosts" . | quote }}
    - name: APPSMITH_DATABASE_PORT_NUMBER
      value: {{ include "appsmith.mongodb.port" . | quote }}
    - name: APPSMITH_DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "appsmith.mongodb.secretName" . }}
          key: {{ include "appsmith.mongodb.secretKey" . }}
    - name: APPSMITH_DATABASE_USER
      value: {{ ternary (index .Values.mongodb.auth.usernames 0) .Values.externalDatabase.username .Values.mongodb.enabled | quote }}
    - name: APPSMITH_DATABASE_NAME
      value: {{ ternary (index .Values.mongodb.auth.databases 0) .Values.externalDatabase.database .Values.mongodb.enabled | quote }}
{{- end -}}

{{- define "appsmith.waitForBackendInitContainer" -}}
- name: wait-for-backend
  image: {{ template "appsmith.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.backend.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.backend.containerSecurityContext "context" $) | nindent 4 }}
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
      . /opt/bitnami/scripts/libappsmith.sh
      . /opt/bitnami/scripts/appsmith-env.sh

      info "Waiting for Appsmith backend to be available"

      check_api() {
          curl --max-time 5 "http://$APPSMITH_API_HOST:$APPSMITH_API_PORT/api/v1/users/me" | grep -q "success"
      }

      if retry_while check_api; then
          info "Backend is available"
          exit 0
      else
          error "Backend not available"
          exit 1
      fi
  env:
    - name: APPSMITH_API_HOST
      value: {{ include "appsmith.backend.fullname" . | quote }}
    - name: APPSMITH_API_PORT
      value: {{ .Values.backend.service.ports.http | quote }}
{{- end -}}

{{- define "appsmith.waitForRTSInitContainer" -}}
- name: wait-for-rts
  image: {{ template "appsmith.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.rts.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.rts.containerSecurityContext "context" $) | nindent 4 }}
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
      . /opt/bitnami/scripts/libappsmith.sh
      . /opt/bitnami/scripts/appsmith-env.sh

      info "Waiting for Appsmith RTS to be available"

      check_api() {
          curl --max-time 5 "http://$APPSMITH_RTS_HOST:$APPSMITH_RTS_PORT/rts-api/v1/health-check" | grep -q "success"
      }

      if retry_while check_api; then
          info "RTS is available"
          exit 0
      else
          error "RTS not available"
          exit 1
      fi
  env:
    - name: APPSMITH_RTS_HOST
      value: {{ include "appsmith.rts.fullname" . | quote }}
    - name: APPSMITH_RTS_PORT
      value: {{ .Values.rts.service.ports.http | quote }}
{{- end -}}

{{/*
Retrieve key of the MongoDB secret
*/}}
{{- define "appsmith.mongodb.secretKey" -}}
{{- if .Values.mongodb.enabled -}}
    {{- print "mongodb-passwords" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "db-password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "db-password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis Secret Name
*/}}
{{- define "appsmith.redis.secretName" -}}
{{- if .Values.redis.enabled }}
    {{- printf "%s" (include "appsmith.redis.fullname" .) -}}
{{- else if .Values.externalRedis.existingSecret -}}
    {{- printf "%s" .Values.externalRedis.existingSecret -}}
{{- else -}}
    {{- printf "%s-externalredis" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve key of the Redis secret
*/}}
{{- define "appsmith.redis.secretKey" -}}
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
Compile all warnings into a single message.
*/}}
{{- define "appsmith.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "appsmith.validateValues.mongodb" .) -}}
{{- $messages := append $messages (include "appsmith.validateValues.redis" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Appsmith - MongoDB */}}
{{- define "appsmith.validateValues.mongodb" -}}
{{- if and .Values.mongodb.enabled .Values.externalDatabase.hosts -}}
appsmith: MongoDB
    You can only use one database.
    Please choose installing a MongoDB chart (--set mongodb.enabled=true) or
    using an external database (--set externalDatabase.hosts)
{{- end -}}
{{- if and (not .Values.mongodb.enabled) (not .Values.externalDatabase.hosts) -}}
appsmith: NoMongoDB
    You did not set any database.
    Please choose installing a MongoDB chart (--set mongodb.enabled=true) or
    using an external instance (--set externalDatabase.hosts)
{{- end -}}
{{- end -}}

{{/* Validate values of Appsmith - Redis */}}
{{- define "appsmith.validateValues.redis" -}}
{{- if and .Values.redis.enabled .Values.externalDatabase.hosts -}}
appsmith: Redis
    You can only use one Redis.
    Please choose installing a Redis chart (--set redis.enabled=true) or
    using an external Redis (--set externalRedis.host)
{{- end -}}
{{- if and (not .Values.redis.enabled) (not .Values.externalRedis.host) -}}
appsmith: NoRedis
    You did not set any Redis.
    Please choose installing a Redis chart (--set redis.enabled=true) or
    using an external instance (--set externalRedis.host)
{{- end -}}
{{- end -}}
