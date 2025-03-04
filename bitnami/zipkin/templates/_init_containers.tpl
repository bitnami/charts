{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "zipkin.init-containers.wait-for-cassandra" -}}
- name: wait-for-cassandra
  image: {{ include "zipkin.init-containers.wait.image" . }}
  imagePullPolicy: {{ .Values.defaultInitContainers.waitForCassandra.image.pullPolicy }}
  {{- if .Values.defaultInitContainers.waitForCassandra.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.defaultInitContainers.waitForCassandra.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultInitContainers.waitForCassandra.resources }}
  resources: {{- toYaml .Values.defaultInitContainers.waitForCassandra.resources | nindent 4 }}
  {{- else if ne .Values.defaultInitContainers.waitForCassandra.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.defaultInitContainers.waitForCassandra.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - bash
  args:
    - -ec
    - |

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
      value: {{ include "zipkin.cassandra.host" . | quote }}
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" .Values.defaultInitContainers.waitForCassandra.image.debug | quote }}
    - name: CQLSH_PORT
      value: {{ include "zipkin.cassandra.port" . | quote }}
    - name: CASSANDRA_USERNAME
      value: {{ include "zipkin.cassandra.user" . | quote }}
    - name: CASSANDRA_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "zipkin.cassandra.secretName" . }}
          key: {{ include "zipkin.cassandra.passwordKey" . }}
    - name: CASSANDRA_KEYSPACE
      value: {{ include "zipkin.cassandra.user" . }}
{{- end -}}

{{/*
Init container definition for initializing the TLS certificates
*/}}
{{- define "zipkin.init-containers.init-certs" -}}
- name: init-certs
  image: {{ include "zipkin.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.defaultInitContainers.initCerts.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.defaultInitContainers.initCerts.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultInitContainers.initCerts.resources }}
  resources: {{- toYaml .Values.defaultInitContainers.initCerts.resources | nindent 4 }}
  {{- else if ne .Values.defaultInitContainers.initCerts.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.defaultInitContainers.initCerts.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - bash
  args:
    - -ec
    - |
      set -e
      {{- if .Values.usePasswordFiles }}
      # We need to load all the secret env vars to the system
      for file in $(find /bitnami/zipkin/secrets -type f); do
          env_var_name="$(basename $file)"
          echo "Exporting $env_var_name"
          export $env_var_name="$(< $file)"
      done
      {{- end }}
      {{- if .Values.tls.usePemCerts }}
      if [[ -f "/certs/tls.key" ]] && [[ -f "/certs/tls.crt" ]]; then
          openssl pkcs12 -export -in "/certs/tls.crt" \
              -passout pass:"${ARMERIA_SSL_KEY_STORE_PASSWORD}" \
              -inkey "/certs/tls.key" \
              -out "/tmp/keystore.p12"
          keytool -importkeystore -srckeystore "/tmp/keystore.p12" \
              -srcstoretype PKCS12 \
              -srcstorepass "${ARMERIA_SSL_KEY_STORE_PASSWORD}" \
              -deststorepass "${ARMERIA_SSL_KEY_STORE_PASSWORD}" \
              -destkeystore "/opt/bitnami/zipkin/certs/zipkin.jks"
          rm "/tmp/keystore.p12"
      else
          echo "Couldn't find the expected PEM certificates! They are mandatory when encryption via TLS is enabled."
          exit 1
      fi
      {{- else }}
      if [[ -f "/certs/zipkin.jks" ]]; then
          cp "/certs/zipkin.jks" "/opt/bitnami/zipkin/certs/zipkin.jks"
      else
          echo "Couldn't find the expected Java Key Stores (JKS) files! They are mandatory when encryption via TLS is enabled."
          exit 1
      fi
      {{- end }}
  env:
    {{- if not .Values.usePasswordFiles }}
    {{- if or .Values.tls.passwordSecret .Values.tls.password .Values.tls.autoGenerated.enabled .Values.tls.usePemCerts }}
    - name: ZIPKIN_KEYSTORE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "zipkin.tls.passwordSecretName" . }}
          key: keystore-password
    {{- end }}
    {{- end }}
  volumeMounts:
    - name: input-tls-certs
      mountPath: /certs
    - name: empty-dir
      mountPath: /opt/bitnami/zipkin/certs
      subPath: app-processed-certs-dir
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    {{- if .Values.usePasswordFiles }}
    {{- if or .Values.tls.passwordSecret .Values.tls.password .Values.tls.autoGenerated.enabled .Values.tls.usePemCerts }}
    - name: keystore-password
      mountPath: /bitnami/zipkin/secrets/keystore-password
    {{- end }}
    {{- end }}
{{- end -}}
