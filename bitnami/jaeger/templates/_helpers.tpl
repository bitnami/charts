{{/* vim: set filetype=mustache: */}}


{{/*
Return the proper jaeger&trade; image name
*/}}
{{- define "jaeger.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}


{{/*
Create the name of the query deployment
*/}}
{{- define "jaeger.query.fullname" -}}
    {{ printf "%s-query" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Create a container for checking cassandra availability
*/}}
{{- define "jaeger.waitForDBInitContainer" -}}
- name: jaeger-cassandra-ready-check
  image: {{ printf "%s/%s:%s" .Values.cassandra.image.registry .Values.cassandra.image.repository .Values.cassandra.image.tag }}
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
  - name: CQLSH
    value: /opt/bitnami/cassandra/bin/cqlsh
  - name: CQLSH_HOST
    value: {{ printf "%s-cassandra" (include "common.names.fullname" .) }}
  - name: CQLSH_PORT
    value: {{ .Values.cassandra.containerPorts.cql | quote }}
  - name: CASSANDRA_USERNAME
    value: {{ .Values.cassandra.dbUser.user }}
  - name: CASSANDRA_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ printf "%s-cassandra" (include "common.names.fullname" .) }}
        key: cassandra-password
  - name: CASSANDRA_KEYSPACE
    value: {{ .Values.cassandra.keyspace }}
{{- end -}}

{{/*
Create the name of the service account to use for the collector
*/}}
{{- define "jaeger.collector.serviceAccountName" -}}
{{- if .Values.collector.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.collector.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.collector.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the agent
*/}}
{{- define "jaeger.agent.serviceAccountName" -}}
{{- if .Values.agent.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.agent.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.agent.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the query
*/}}
{{- define "jaeger.query.serviceAccountName" -}}
{{- if .Values.query.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.query.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.query.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the collector deployment. This name includes 2 hyphens due to
an issue about env vars collision with the chart name when the release name is set to just 'jaeger'
ref. https://github.com/jaegertracing/jaeger-operator/issues/1158
*/}}
{{- define "jaeger.collector.fullname" -}}
    {{ printf "%s-collector" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Create the name of the agent deployment
*/}}
{{- define "jaeger.agent.fullname" -}}
    {{ printf "%s--agent" (include "common.names.fullname" .) }}
{{- end -}}
