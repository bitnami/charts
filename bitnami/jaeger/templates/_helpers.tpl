{{/* vim: set filetype=mustache: */}}


{{/*
Return the proper jaeger&trade; image name
*/}}
{{- define "jaeger.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "jaeger.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image .Values.backup.uploadProviders.google.image .Values.backup.uploadProviders.azure.image) "global" .Values.global) }}
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

{{/*
Return the cassandra subchart password.
*/}}
{{- define "jaeger.cassandraSubChartPassword" -}}
{{- if not (empty .Values.cassandra.dbUser.password) -}}
    {{- .Values.cassandra.dbUser.password -}}
{{- else -}}
    {{- include "getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (include "common.names.fullname" .) "Length" 10 "Key" "cassandra-password")  -}}
{{- end -}}
{{- end -}}

{{/*
Return the jaeger&trade; initialization scripts configmap.
*/}}
{{- define "jaeger.initdbScriptsConfigmapName" -}}
{{- if .Values.jaeger.initdbScriptsCM -}}
    {{- printf "%s" (tpl .Values.jaeger.initdbScriptsCM $) -}}
{{- else -}}
    {{- printf "%s-initdb-scripts" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the jaeger&trade; initialization scripts secret.
*/}}
{{- define "jaeger.initdbScriptsSecret" -}}
{{- printf "%s" (tpl .Values.jaeger.initdbScriptsSecret $) -}}
{{- end -}}
