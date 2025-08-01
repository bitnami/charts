{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}


{{/*
Return the proper jaeger image name
*/}}
{{- define "jaeger.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper cassandra external image name
*/}}
{{- define "jaeger.cqlshImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cqlshImage "global" .Values.global) }}
{{- end -}}


{{/*
Create the name of the query deployment
*/}}
{{- define "jaeger.query.fullname" -}}
    {{ printf "%s-query" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Create the name of the query deployment
*/}}
{{- define "jaeger.cassandra.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "cassandra" "chartValues" .Values.cassandra "context" $) -}}
{{- end -}}

{{/*
Return the Kafka broker configuration.
ref: https://kafka.apache.org/documentation/#configuration
*/}}
{{- define "jaeger.query.configuration" -}}
{{- if .Values.query.configuration }}
{{- include "common.tplvalues.render" (dict "value" .Values.query.configuration "context" .) }}
{{- else }}
service:
  extensions: [jaeger_storage, jaeger_query, healthcheckv2]
  pipelines:
    traces:
      receivers: [nop]
      processors: [batch]
      exporters: [nop]
  telemetry:
    resource:
      service.name: jaeger-query
    metrics:
      level: detailed
      readers:
        - pull:
            exporter:
              prometheus:
                host: 0.0.0.0
                port: "${env:QUERY_METRICS_PORT}"
    logs:
      level: info
extensions:
  healthcheckv2:
    use_v2: true
    http:
      endpoint: "${env:QUERY_HEALTHCHECK_HOST_PORT}"
  jaeger_query:
    storage:
      traces: jaeger_storage
    grpc:
      endpoint: "${env:QUERY_GRPC_SERVER_HOST_PORT}"
    http:
      endpoint: "${env:QUERY_HTTP_SERVER_HOST_PORT}"
  jaeger_storage:
    backends:
      jaeger_storage: {{ include "jaeger.cassandra.storage" . | nindent 8 }}
receivers:
  nop:
processors:
  batch:
exporters:
  nop:
{{- end -}}
{{- end -}}



{{- define "jaeger.collector.configuration" -}}
{{- if .Values.collector.configuration }}
{{- include "common.tplvalues.render" (dict "value" .Values.collector.configuration "context" .) }}
{{- else }}
service:
  extensions: [jaeger_storage, healthcheckv2]
  pipelines:
    traces:
      receivers: {{ include "common.tplvalues.render" (dict "value" .Values.collector.receivers "context" .) | nindent 12 }}
      processors: [batch]
      exporters: [jaeger_storage_exporter]
  telemetry:
    resource:
      service.name: jaeger-collector
    metrics:
      level: detailed
      readers:
        - pull:
            exporter:
              prometheus:
                host: 0.0.0.0
                port: "${env:COLLECTOR_METRICS_PORT}"
    logs:
      level: info
extensions:
  healthcheckv2:
    use_v2: true
    http:
      endpoint: "${env:COLLECTOR_HEALTHCHECK_HOST_PORT}"
  jaeger_storage:
    backends:
      jaeger_storage: {{ include "jaeger.cassandra.storage" . | nindent 8 }}
receivers:
  {{- if has "otlp" .Values.collector.receivers }}
  otlp:
    protocols:
      grpc:
        endpoint: "${env:COLLECTOR_OTLP_GRPC_HOST_PORT}"
      http:
        endpoint: "${env:COLLECTOR_OTLP_HTTP_HOST_PORT}"
  {{- end }}
  {{- if has "jaeger" .Values.collector.receivers }}
  jaeger:
    protocols:
      grpc:
        endpoint: "${env:COLLECTOR_JAEGER_GRPC_SERVER_HOST_PORT}"
      thrift_http:
        endpoint: "${env:COLLECTOR_JAEGER_THRIFT_HTTP_HOST_PORT}"
  {{- end }}
  {{- if has "zipkin" .Values.collector.receivers }}
  zipkin:
    endpoint: "${env:COLLECTOR_ZIPKIN_HOST_PORT}"
  {{- end }}
processors:
  batch:
exporters:
  jaeger_storage_exporter:
    trace_storage: jaeger_storage
{{- end -}}
{{- end -}}

{{- define "jaeger.cassandra.storage" -}}
cassandra:
  schema:
    keyspace: "${env:CASSANDRA_KEYSPACE}"
    create: true
    datacenter: "${env:CASSANDRA_DATACENTER}"
  connection:
    servers: ["${env:CASSANDRA_SERVERS}:${env:CASSANDRA_PORT}"]
    auth:
      basic:
        username: "${env:CASSANDRA_USERNAME}"
        password: "${env:CASSANDRA_PASSWORD}"
        allowed_authenticators: ["org.apache.cassandra.auth.PasswordAuthenticator"]
    tls:
      insecure: true
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "jaeger.imagePullSecrets" -}}
{{ include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.cqlshImage) "context" $) }}
{{- end -}}

{{/*
Create a container for checking cassandra availability
*/}}
{{- define "jaeger.waitForDBInitContainer" -}}
{{- $context := .context }}
{{- $block := index .context.Values .component }}
- name: jaeger-cassandra-ready-check
  image: {{ include "jaeger.cqlshImage" .context }}
  imagePullPolicy: {{ .context.Values.image.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash

      set -o errexit
      set -o nounset
      set -o pipefail

      . /opt/bitnami/scripts/libos.sh

      check_cassandra_keyspace_schema() {
          echo "SELECT 1" | cqlsh -u $CASSANDRA_USERNAME -p $CASSANDRA_PASSWORD -e "SELECT keyspace_name FROM system_schema.keyspaces WHERE keyspace_name='${CASSANDRA_KEYSPACE}';"
      }

      info "Connecting to the Cassandra instance $CQLSH_HOST:$CQLSH_PORT"
      if ! retry_while "check_cassandra_keyspace_schema" 12 30; then
        error "Could not connect to the database server"
        exit 1
      else
        info "Connection check success"
      fi
  env:
    - name: CQLSH_HOST
      value: {{ include "jaeger.cassandra.host" .context }}
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" .context.Values.cqlshImage.debug | quote }}
    - name: CQLSH_PORT
      value: {{ include "jaeger.cassandra.port" .context }}
    - name: CASSANDRA_USERNAME
      value: {{ include "jaeger.cassandra.user" .context }}
    - name: CASSANDRA_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "jaeger.cassandra.secretName" .context }}
          key: {{ include "jaeger.cassandra.secretKey" .context }}
    - name: CASSANDRA_KEYSPACE
      value: {{ .context.Values.cassandra.keyspace }}
  {{- if $block.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" $block.containerSecurityContext "context" .context) | nindent 4 }}
  {{- end }}
  {{- if .context.Values.cqlshImage.resources }}
  resources: {{- toYaml .context.Values.cqlshImage.resources | nindent 4 }}
  {{- else if ne .context.Values.cqlshImage.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .context.Values.cqlshImage.resourcesPreset) | nindent 4 }}
  {{- end }}
{{- end -}}

{{/*
Get the jaeger collector configmap name
*/}}
{{- define "jaeger.collector.configMapName" -}}
{{- if .Values.collector.existingConfigmap -}}
    {{- print (tpl .Values.collector.existingConfigmap .) -}}
{{- else -}}
    {{- print (include "jaeger.collector.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the jaeger query configmap name
*/}}
{{- define "jaeger.query.configMapName" -}}
{{- if .Values.query.existingConfigmap -}}
    {{- print (tpl .Values.query.existingConfigmap .) -}}
{{- else -}}
    {{- print (include "jaeger.query.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the collector
*/}}
{{- define "jaeger.collector.serviceAccountName" -}}
{{- if .Values.collector.serviceAccount.create -}}
    {{ default (include "jaeger.collector.fullname" .) .Values.collector.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.collector.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Create the name of the service account to use for the query
*/}}
{{- define "jaeger.query.serviceAccountName" -}}
{{- if .Values.query.serviceAccount.create -}}
    {{ default (include "jaeger.query.fullname" .) .Values.query.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.query.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the collector deployment
*/}}
{{- define "jaeger.collector.fullname" -}}
    {{ printf "%s-collector" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Create the cassandra secret name
*/}}
{{- define "jaeger.cassandra.secretName" -}}
    {{- if not .Values.cassandra.enabled -}}
        {{- tpl .Values.externalDatabase.existingSecret $ -}}
    {{- else -}}
        {{- default (include "jaeger.cassandra.fullname" .) .Values.cassandra.dbUser.existingSecret -}}
    {{- end -}}
{{- end -}}

{{/*
Create the cassandra secret key
*/}}
{{- define "jaeger.cassandra.secretKey" -}}
    {{- if not .Values.cassandra.enabled -}}
        {{- .Values.externalDatabase.existingSecretPasswordKey -}}
    {{- else -}}
        cassandra-password
    {{- end -}}
{{- end -}}

{{/*
Create the cassandra user
*/}}
{{- define "jaeger.cassandra.user" -}}
    {{- if not .Values.cassandra.enabled -}}
        {{- .Values.externalDatabase.dbUser.user | quote -}}
    {{- else -}}
        {{- .Values.cassandra.dbUser.user | quote -}}
    {{- end -}}
{{- end -}}

{{/*
Create the cassandra host
*/}}
{{- define "jaeger.cassandra.host" -}}
    {{- if not .Values.cassandra.enabled -}}
        {{- .Values.externalDatabase.host | quote -}}
    {{- else -}}
        {{- include "common.names.dependency.fullname" (dict "chartName" "cassandra" "chartValues" .Values.cassandra "context" $) -}}
    {{- end }}
{{- end }}

{{/*
Create the cassandra port
*/}}
{{- define "jaeger.cassandra.port" -}}
    {{- if not .Values.cassandra.enabled -}}
        {{- .Values.externalDatabase.port | quote -}}
    {{- else }}
        {{- .Values.cassandra.service.ports.cql | quote -}}
    {{- end -}}
{{- end -}}

{{/*
Create the cassandra datacenter
*/}}
{{- define "jaeger.cassandra.datacenter" -}}
    {{- if not .Values.cassandra.enabled -}}
        {{- .Values.externalDatabase.cluster.datacenter | quote -}}
    {{- else }}
        {{- .Values.cassandra.cluster.datacenter | quote -}}
    {{- end -}}
{{- end -}}

{{/*
Return the cassandra keyspace
*/}}
{{- define "jaeger.cassandra.keyspace" -}}
{{- if .Values.keyspace }}
    {{- /* Inside cassandra subchart */ -}}
    {{- print .Values.keyspace -}}
{{- else if .Values.cassandra.enabled }}
    {{- print .Values.cassandra.keyspace -}}
{{- else -}}
    {{- print .Values.externalDatabase.keyspace -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "jaeger.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "jaeger.validateValues.cassandra" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of jaeger - Cassandra */}}
{{- define "jaeger.validateValues.cassandra" -}}
{{- if and .Values.cassandra.enabled .Values.externalDatabase.host -}}
jaeger: Cassandra
    You can only use one database.
    Please choose installing a Cassandra chart (--set cassandra.enabled=true) or
    using an external database (--set externalDatabase.host)
{{- end -}}
{{- if and (not .Values.cassandra.enabled) (not .Values.externalDatabase.host) -}}
jaeger: Cassandra
    You did not set any database.
    Please choose installing a Cassandra chart (--set mongodb.enabled=true) or
    using an external database (--set externalDatabase.host)
{{- end -}}
{{- end -}}
