{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name for Kafka subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "schema-registry.kafka.fullname" -}}
{{- if .Values.kafka.fullnameOverride -}}
{{- .Values.kafka.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "kafka" .Values.kafka.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "schema-registry.chart" -}}
{{- include "common.names.chart" . -}}
{{- end }}

{{/*
Return the proper Schema Registry image name
*/}}
{{- define "schema-registry.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "schema-registry.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the Service Account to use
*/}}
{{- define "schema-registry.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
    {{- default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else }}
    {{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the Schema Registry Configuration configmap.
*/}}
{{- define "schema-registry.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for Schema Registry Configuration
*/}}
{{- define "schema-registry.createConfigMap" -}}
{{- if and .Values.configuration (not .Values.existingConfigmap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Log4J Configuration configmap.
*/}}
{{- define "schema-registry.log4j.configmapName" -}}
{{- if .Values.existingLog4jConfigMap -}}
    {{- printf "%s" (tpl .Values.existingLog4jConfigMap $) -}}
{{- else -}}
    {{- printf "%s-log4j" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for Log4J Configuration
*/}}
{{- define "schema-registry.log4j.createConfigMap" -}}
{{- if and .Values.log4j (not .Values.existingLog4jConfigMap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the type of listener
Usage:
{{ include "schema-registry.listenerType" ( dict "protocol" .Values.path.to.the.Value ) }}
*/}}
{{- define "schema-registry.listenerType" -}}
{{- if eq .protocol "plaintext" -}}
PLAINTEXT
{{- else if or (eq .protocol "tls") (eq .protocol "mtls") -}}
SSL
{{- else if eq .protocol "sasl_tls" -}}
SASL_SSL
{{- else if eq .protocol "sasl" -}}
SASL_PLAINTEXT
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "schema-registry.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "schema-registry.validateValues.authentication.sasl" .) -}}
{{- $messages := append $messages (include "schema-registry.validateValues.authentication.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Schema Registry - SASL authentication */}}
{{- define "schema-registry.validateValues.authentication.sasl" -}}
{{- $kafkaProtocol := include "schema-registry.listenerType" ( dict "protocol" (ternary .Values.kafka.auth.clientProtocol .Values.externalKafka.auth.protocol .Values.kafka.enabled) ) -}}
{{- if .Values.kafka.enabled }}
{{- if and (contains "SASL" $kafkaProtocol) (or (not .Values.kafka.auth.sasl.jaas.clientUsers) (not .Values.kafka.auth.sasl.jaas.clientPasswords)) }}
schema-registry: kafka.auth.jaas.clientUsers kafka.auth.jaas.clientPasswords
    It's mandatory to set the SASL credentials when enabling SASL authentication with Kafka brokers.
    You can specify these credentials setting the parameters below:
      - kafka.auth.jaas.clientUsers
      - kafka.auth.jaas.clientPasswords
{{- end }}
{{- else if and (contains "SASL" $kafkaProtocol) (or (not .Values.externalKafka.auth.jaas.user) (not .Values.externalKafka.auth.jaas.password)) }}
schema-registry: externalKafka.auth.jaas.user externalKafka.auth.jaas.password
    It's mandatory to set the SASL credentials when enabling SASL authentication with Kafka brokers.
    You can specify these credentials setting the parameters below:
      - kexternalKafka.auth.jaas.user
      - externalKafka.auth.jaas.password
{{- end -}}
{{- end -}}

{{/* Validate values of Schema Registry - TLS authentication */}}
{{- define "schema-registry.validateValues.authentication.tls" -}}
{{- $kafkaProtocol := include "schema-registry.listenerType" ( dict "protocol" (ternary .Values.kafka.auth.clientProtocol .Values.externalKafka.auth.protocol .Values.kafka.enabled) ) -}}
{{- if and (contains "SSL" $kafkaProtocol) (not .Values.auth.kafka.jksSecret) }}
kafka: auth.kafka.jksSecret
    A secret containing the Schema Registry JKS files is required when TLS encryption in enabled
{{- end -}}
{{- end -}}
