# This Helm chart is based on the original chart from the Apache Software Foundation.
# Modifications have been made by PO-YU SHEN on 2025/04/29.
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

{{- /*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper StreamPark image name
*/}}
{{- define "streampark.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper busybox image name
*/}}
{{- define "streampark.busybox.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.busybox.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name for init database job
*/}}
{{- define "streampark.database.image" -}}
{{- if .Values.postgresql.enabled }}
{{- include "common.images.image" (dict "imageRoot" .Values.postgresql.image "global" .Values.global) -}}
{{- else if .Values.mysql.enabled }}
{{- include "common.images.image" (dict "imageRoot" .Values.mysql.image "global" .Values.global) -}}
{{- else }}
  {{- if .Values.externalDatabase.enabled }}
  {{- include "common.images.image" (dict "imageRoot" .Values.externalDatabase.image "global" .Values.global) -}}
  {{- else }}
  {{- print "docker.io/busybox:latest" }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Return the proper image name for dind
*/}}
{{- define "streampark.image.dind" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.dockerInDocker.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "streampark.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" $) -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "streampark.name" -}}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the operator service account to use
*/}}
{{- define "streampark.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default .Values.serviceAccount.name (include "common.names.fullname" .) }}
{{- else -}}
{{- default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "streampark.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "streampark.mysql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mysql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the Database hostname
*/}}
{{- define "streampark.databaseHost" -}}
{{- if .Values.postgresql.enabled }}
  {{- if eq .Values.postgresql.architecture "replication" }}
    {{- include "streampark.postgresql.fullname" . -}}-primary
  {{- else -}}
    {{- include "streampark.postgresql.fullname" . -}}
  {{- end -}}
{{- else if .Values.mysql.enabled }}
  {{- if eq .Values.mysql.architecture "replication" }}
    {{- include "streampark.mysql.fullname" . -}}-primary
  {{- else -}}
    {{- include "streampark.mysql.fullname" . -}}
  {{- end -}}
{{- else }}
  {{- default "localhost" .Values.externalDatabase.host }}
{{- end -}}
{{- end -}}

{{/*
Return the Database user
*/}}
{{- define "streampark.databaseUser" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- coalesce .Values.global.postgresql.auth.username .Values.postgresql.auth.username -}}
        {{- else -}}
            {{- .Values.postgresql.auth.username -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.username -}}
    {{- end -}}
{{- else if .Values.mysql.enabled -}}
    {{- if .Values.global.mysql -}}
        {{- if .Values.global.mysql.auth -}}
            {{- coalesce .Values.global.mysql.auth.username .Values.mysql.auth.username -}}
        {{- else -}}
            {{- .Values.mysql.auth.username -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.mysql.auth.username -}}
    {{- end -}}
{{- else -}}
  {{- default "streampark" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database encrypted password
*/}}
{{- define "streampark.databaseSecretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- if .Values.global.postgresql.auth.existingSecret -}}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "streampark.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "streampark.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "streampark.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else if .Values.mysql.enabled -}}
    {{- if .Values.global.mysql -}}
        {{- if .Values.global.mysql.auth -}}
            {{- if .Values.global.mysql.auth.existingSecret -}}
                {{- tpl .Values.global.mysql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "streampark.mysql.fullname" .) (tpl .Values.mysql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "streampark.mysql.fullname" .) (tpl .Values.mysql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "streampark.mysql.fullname" .) (tpl .Values.mysql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- default (printf "%s-externaldb" (include "common.names.fullname" .)) (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "streampark.databaseSecretPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- default "password" .Values.postgresql.auth.secretKeys.userPasswordKey -}}
{{- else if .Values.mysql.enabled -}}
    {{- print "mysql-password" -}}
{{- else -}}
    {{- if and .Values.externalDatabase.existingSecret .Values.externalDatabase.existingSecretPasswordKey -}}
      {{- .Values.externalDatabase.existingSecretPasswordKey -}}
    {{- else -}}
      {{- print "password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Docker host used by StreamPark
*/}}
{{- define "streampark.dind.host" -}}
{{- if .Values.dockerInDocker.create -}}
{{- printf "tcp://%s-dind:2375" (include "common.names.fullname" $) -}}
{{- else -}}
{{- printf "tcp://%s:%s" (default "127.0.0.1" .Values.dockerInDocker.externalHost) (default "2375" .Values.dockerInDocker.externalPort) -}}
{{- end -}}
{{- end -}}

{{/*
RBAC rules used to create the operator (cluster)role based on the scope
*/}}
{{- define "streampark.rbacRules" -}}
rules:
  - apiGroups:
      - "*"
    resources:
      - pods
      - services
      - endpoints
      - persistentvolumeclaims
      - events
      - configmaps
      - secrets
      - nodes
      - deployments
      - ingresses
      - replicasets
      - pods/log
      - jobs
    verbs:
      - "*"
{{- end -}}

{{/*
Callback URL for StreamPark SSO
*/}}
{{- define "streampark.sso.callbackUrl" -}}
{{- $protocol := "http" }}
{{- if .Values.ingress.tls.enabled }}
{{- $protocol = "https" }}
{{- end }}
{{- if .Values.streamParkConfiguration.sso.callbackUrl -}}
  {{ .Values.streamParkConfiguration.sso.callbackUrl | quote}}
{{- else -}}
  {{- if .Values.ingress.enabled }}
    {{- printf "%s://%s/callback" $protocol .Values.ingress.hostname }}
  {{- else }}
    {{- printf "http://%s.%s.svc:10000/callback" (include "common.names.fullname" $) (include "common.names.namespace" .) }}
  {{- end }}
{{- end -}}
{{- end -}}

{{/*
Environment variable for database
*/}}
{{- define "streampark.database.env" -}}
{{- if .Values.externalDatabase.enabled -}}
- name: DATASOURCE_DIALECT
  value: {{ .Values.externalDatabase.type }}
- name: DATASOURCE_HOST
  value: {{ .Values.externalDatabase.host }}
- name: DATASOURCE_URL
  {{- if eq "pgsql" .Values.externalDatabase.type }}
  value: {{ print "jdbc:postgresql://" .Values.externalDatabase.host ":" (default "5432" .Values.externalDatabase.port) "/streampark?stringtype=unspecified" }}
  {{- else if eq "mysql" .Values.externalDatabase.type }}
  value: {{ print "jdbc:mysql://" .Values.externalDatabase.host ":" (default "3306" .Values.externalDatabase.port) "/streampark?useSSL=false&useUnicode=true&characterEncoding=UTF-8&allowPublicKeyRetrieval=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2B8" }}
  {{- else }}
  value: {{ print "jdbc:postgresql://localhost:5432/streampark?stringtype=unspecified" }}
  {{- end }}
- name: DATASOURCE_USERNAME
  value: {{ include "streampark.databaseUser" . }}
- name: DATASOURCE_PASSWORD
  valueFrom:
    secretKeyRef:
      {{- if .Values.externalDatabase.existingSecret }}
      name: {{ .Values.externalDatabase.existingSecret }}
      key: {{ .Values.externalDatabase.existingSecretPasswordKey | default "password" }}
      {{- else }}
      name: {{ printf "%s-externalDatabase-password" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" }}
      key: "admin-password"
      {{- end }}
{{- else if .Values.postgresql.enabled -}}
- name: DATASOURCE_DIALECT
  value: pgsql
- name: DATASOURCE_HOST
  value: {{ include "streampark.databaseHost" . }}
- name: DATASOURCE_URL
  value: {{ print "jdbc:postgresql://" (include "streampark.databaseHost" .) ":5432/streampark?stringtype=unspecified" }}
- name: DATASOURCE_USERNAME
  value: {{ include "streampark.databaseUser" . }}
- name: DATASOURCE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "streampark.databaseSecretName" . }}
      key: {{ include "streampark.databaseSecretPasswordKey" . }}
{{- else if .Values.mysql.enabled -}}
- name: DATASOURCE_DIALECT
  value: mysql
- name: DATASOURCE_HOST
  value: {{ include "streampark.databaseHost" . }}
- name: DATASOURCE_URL
  value: {{ print "jdbc:mysql://" (include "streampark.databaseHost" .) ":3306/streampark?useSSL=false&useUnicode=true&characterEncoding=UTF-8&allowPublicKeyRetrieval=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2B8" }}
- name: DATASOURCE_USERNAME
  value: {{ include "streampark.databaseUser" . }}
- name: DATASOURCE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "streampark.databaseSecretName" . }}
      key: {{ include "streampark.databaseSecretPasswordKey" . }}
{{- else -}}
- name: DATASOURCE_DIALECT
  value: h2
{{- end -}}
{{- end -}}
