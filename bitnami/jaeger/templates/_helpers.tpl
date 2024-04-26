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
          echo "SELECT 1" | cqlsh -u $CASSANDRA_USERNAME -p $CASSANDRA_PASSWORD -e "SELECT COUNT(*) FROM ${CASSANDRA_KEYSPACE}.traces"
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
Create the name of the service account to use for the agent
*/}}
{{- define "jaeger.agent.serviceAccountName" -}}
{{- if .Values.agent.serviceAccount.create -}}
    {{ default (include "jaeger.agent.fullname" .) .Values.agent.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.agent.serviceAccount.name }}
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
Create the name of the collector deployment. This name includes 2 hyphens due to
an issue about env vars collision with the chart name when the release name is set to just 'jaeger'
ref. https://github.com/jaegertracing/jaeger-operator/issues/1158
*/}}
{{- define "jaeger.agent.fullname" -}}
    {{ printf "%s--agent" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Create the cassandra secret name
*/}}
{{- define "jaeger.cassandra.secretName" -}}
    {{- if not .Values.cassandra.enabled -}}
        {{- .Values.externalDatabase.existingSecret -}}
    {{- else -}}
        {{- printf "%s-cassandra" (include "common.names.fullname" .) -}}
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
Create the cassandra keyspace
*/}}
{{- define "jaeger.cassandra.keyspace" -}}
    {{- if not .Values.cassandra.enabled -}}
        {{- .Values.externalDatabase.keyspace | quote -}}
    {{- else }}
        {{- .Values.cassandra.keyspace | quote -}}
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
