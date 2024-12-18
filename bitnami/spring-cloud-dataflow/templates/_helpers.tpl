{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper server fullname
*/}}
{{- define "scdf.server.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper skipper fullname
*/}}
{{- define "scdf.skipper.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "skipper" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper prometheus-proxy fullname
*/}}
{{- define "scdf.prometheus-proxy.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "prometheus-proxy" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name for MariaDB subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "scdf.mariadb.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mariadb" "chartValues" .Values.mariadb "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name for RabbitMQ subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "scdf.rabbitmq.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "rabbitmq" "chartValues" .Values.rabbitmq "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name for Kafka subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "scdf.kafka.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "kafka" "chartValues" .Values.kafka "context" $) -}}
{{- end -}}

{{/*
Return the proper Spring Cloud Dataflow Server image name
*/}}
{{- define "scdf.server.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.server.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Spring Cloud Skipper image name
*/}}
{{- define "scdf.skipper.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.skipper.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Spring Cloud Skipper image name
*/}}
{{- define "scdf.waitForBackends.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.waitForBackends.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Prometheus Rsocket Proxy image name
*/}}
{{- define "scdf.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "scdf.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.server.image .Values.skipper.image .Values.waitForBackends.image .Values.metrics.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the Service Account to use
*/}}
{{- define "scdf.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
    {{- default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else }}
    {{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the Spring Cloud Dataflow Server configuration configmap.
*/}}
{{- define "scdf.server.configmapName" -}}
{{- if .Values.server.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.server.existingConfigmap $) -}}
{{- else -}}
    {{- include "scdf.server.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for Spring Cloud Dataflow Server
*/}}
{{- define "scdf.server.createConfigmap" -}}
{{- if not .Values.server.existingConfigmap }}
    {- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the Spring Cloud Skipper configuration configmap.
*/}}
{{- define "scdf.skipper.configmapName" -}}
{{- if .Values.skipper.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.skipper.existingConfigmap $) -}}
{{- else -}}
    {{- include "scdf.skipper.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for Spring Cloud Skipper
*/}}
{{- define "scdf.skipper.createConfigmap" -}}
{{- if not .Values.skipper.existingConfigmap }}
    {- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the database URL used by the dataflow server
*/}}
{{- define "scdf.database.dataflow.url" -}}
  {{- if .Values.externalDatabase.dataflow.url }}
    {{- printf "%s" .Values.externalDatabase.dataflow.url -}}
  {{- else -}}
    {{- printf "jdbc:%s://%s:%s/%s%s" (include "scdf.database.scheme" .) (include "scdf.database.host" .) (include "scdf.database.port" .) (include "scdf.database.server.name" .) (include "scdf.database.jdbc.parameters" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the database URL used by skipper
*/}}
{{- define "scdf.database.skipper.url" -}}
  {{- if .Values.externalDatabase.skipper.url }}
    {{- printf "%s" .Values.externalDatabase.skipper.url -}}
  {{- else -}}
    {{- printf "jdbc:%s://%s:%s/%s%s" (include "scdf.database.scheme" .) (include "scdf.database.host" .) (include "scdf.database.port" .) (include "scdf.database.skipper.name" .) (include "scdf.database.jdbc.parameters" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the database Hostname
*/}}
{{- define "scdf.database.host" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" (include "scdf.mariadb.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the database Port
*/}}
{{- define "scdf.database.port" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the database driver
*/}}
{{- define "scdf.database.driver" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- printf "org.mariadb.jdbc.Driver" -}}
  {{- else -}}
    {{- .Values.externalDatabase.driver -}}
  {{- end -}}
{{- end -}}

{{/*
Return the database scheme
*/}}
{{- define "scdf.database.scheme" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- printf "mariadb" -}}
  {{- else -}}
    {{- .Values.externalDatabase.scheme -}}
  {{- end -}}
{{- end -}}

{{/*
Return the JDBC URL parameters
*/}}
{{- define "scdf.database.jdbc.parameters" -}}
  {{- if and .Values.mariadb.enabled .Values.mariadb.jdbcParameter.useMysqlMetadata -}}
    {{- printf "?useMysqlMetadata=true" -}}
  {{- else -}}
    {{- printf "" -}}
  {{- end -}}
{{- end -}}

{{/*
Return the Data Flow Database Name
*/}}
{{- define "scdf.database.server.name" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.dataflow.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Data Flow Database User
*/}}
{{- define "scdf.database.server.user" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.dataflow.username -}}
{{- end -}}
{{- end -}}

{{/*
Return the Data Flow Database secret name
*/}}
{{- define "scdf.database.server.secretName" -}}
{{- $secretName := coalesce .Values.externalDatabase.dataflow.existingSecret .Values.externalDatabase.existingPasswordSecret -}}
{{- if $secretName -}}
    {{- printf "%s" $secretName -}}
{{- else if .Values.mariadb.enabled }}
    {{- printf "%s" (include "scdf.mariadb.fullname" .) -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "scdf.server.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Skipper Database Name
*/}}
{{- define "scdf.database.skipper.name" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "skipper" -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.skipper.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Skipper Database User
*/}}
{{- define "scdf.database.skipper.user" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "skipper" -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.skipper.username -}}
{{- end -}}
{{- end -}}

{{/*
Return the Skipper Database secret name
*/}}
{{- define "scdf.database.skipper.secretName" -}}
{{- $secretName := coalesce .Values.externalDatabase.skipper.existingSecret .Values.externalDatabase.existingPasswordSecret -}}
{{- if $secretName -}}
    {{- printf "%s" $secretName -}}
{{- else if .Values.mariadb.enabled }}
    {{- printf "%s" (include "scdf.mariadb.fullname" .) -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "scdf.skipper.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Kafka Port
*/}}
{{- define "scdf.kafka.port" -}}
{{- if .Values.kafka.enabled }}
    {{- printf "%d" (.Values.kafka.service.ports.client | int ) -}}
{{- else -}}
    {{- $port := regexFind ":[0-9]+" .Values.externalKafka.brokers | trimPrefix ":" | default "9092" | int -}}
    {{- printf "%d" $port -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ host
*/}}
{{- define "scdf.rabbitmq.host" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- printf "%s" (include "scdf.rabbitmq.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalRabbitmq.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ Port
*/}}
{{- define "scdf.rabbitmq.port" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- printf "%d" (.Values.rabbitmq.service.ports.amqp | int ) -}}
{{- else -}}
    {{- printf "%d" (.Values.externalRabbitmq.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ username
*/}}
{{- define "scdf.rabbitmq.user" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- printf "%s" .Values.rabbitmq.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalRabbitmq.username -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ secret name
*/}}
{{- define "scdf.rabbitmq.secretName" -}}
{{- $secretName := coalesce .Values.externalRabbitmq.existingSecret .Values.externalRabbitmq.existingPasswordSecret -}}
{{- if $secretName -}}
    {{- printf "%s" $secretName -}}
{{- else if .Values.rabbitmq.enabled }}
    {{- printf "%s" (include "scdf.rabbitmq.fullname" .) -}}
{{- else -}}
    {{- printf "%s-externalrabbitmq" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ host
*/}}
{{- define "scdf.rabbitmq.vhost" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- printf "/" -}}
{{- else -}}
    {{- printf "%s" .Values.externalRabbitmq.vhost -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "scdf.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "scdf.validateValues.features" .) -}}
{{- $messages := append $messages (include "scdf.validateValues.messagingSystem" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Spring Cloud Dataflow - Enabled features */}}
{{- define "scdf.validateValues.features" -}}
{{- if and (not .Values.server.configuration.batchEnabled) (not .Values.server.configuration.streamingEnabled) -}}
scdf: features
    You must enabled support for streams or tasks and schedules.
    Please enable any of these features setting the parameters below to 'true'
      - server.configuration.batchEnabled
      - server.configuration.streamingEnabled
{{- end -}}
{{- end -}}

{{/* Validate values of Spring Cloud Dataflow - Messaging System */}}
{{- define "scdf.validateValues.messagingSystem" -}}
{{- if and (or .Values.kafka.enabled .Values.externalKafka.enabled) .Values.rabbitmq.enabled -}}
scdf: Messaging System
    You can only use one messaging system.
    Please enable only RabbitMQ or Kafka as messaging system.
{{- else if and .Values.kafka.enabled .Values.externalKafka.enabled -}}
scdf: Messaging System
    You can only have one Kafka configuration enabled.
    Please ensure only one of the following parameters is set to 'true'
      - kafka.enabled
      - externalKafka.enabled
{{- end -}}
{{- end -}}

{{/*
Return Deployer Environment Variables. Empty string or variables started with comma prefix.
*/}}
{{- define "scdf.deployer.environmentVariables" -}}
  {{- if .Values.deployer.environmentVariables -}}
    {{- if kindIs "string" .Values.deployer.environmentVariables -}}
      {{- printf "- %s" .Values.deployer.environmentVariables | trim -}}
    {{- else -}}
      {{- toYaml .Values.deployer.environmentVariables -}}
    {{- end -}}
  {{- else -}}
    {{- printf "" -}}
  {{- end -}}
{{- end -}}
