{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper JanusGraph image name
*/}}
{{- define "janusgraph.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "janusgraph.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper image name (for the sidecar JMX exporter image)
*/}}
{{- define "janusgraph.metrics.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.metrics.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "janusgraph.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "janusgraph.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the volume-permissions init container
*/}}
{{- define "janusgraph.volumePermissionsInitContainer" -}}
- name: volume-permissions
  image: {{ include "janusgraph.volumePermissions.image"  }}
  imagePullPolicy: {{ default "" .Values.volumePermissions.image.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      mkdir -p {{ .Values.persistence.mountPath }}
      chown {{ .Values.volumePermissions.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }} {{ .Values.persistence.mountPath }}
      find {{ .Values.persistence.mountPath }} -mindepth 1 -maxdepth 1 -not -name ".snapshot" -not -name "lost+found" | xargs chown -R {{ .Values.volumePermissions.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }}
  {{- if .Values.volumePermissions.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.volumePermissions.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.volumePermissions.resources }}
  resources: {{- toYaml .Values.volumePermissions.resources | nindent 4 }}
  {{- else if ne .Values.volumePermissions.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.volumePermissions.resourcesPreset) | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: data
      mountPath: {{ .Values.persistence.mountPath }}
{{- end -}}

{{/*
Return the wait-for-storage init container
*/}}
{{- define "janusgraph.waitForStorage" -}}
- name: wait-for-storage
  image: {{ include "janusgraph.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash

      # HACK: Gremlin console interactive mode won't work unless its history file is writable at /opt/bitnami/janusgraph
      # To be able to run with readOnlyRootFilesystem, we create the file and mount it as a volume
      # Additionally copy the default content of the ext directory for console plugins installation
      touch /base-dir/.gremlin_groovy_history
      cp /opt/bitnami/janusgraph/ext/* /ext-dir

      # Load env variables
      [[ -f /opt/bitnami/scripts/janusgraph-env.sh ]] && . /opt/bitnami/scripts/janusgraph-env.sh

      # Copy Janusgraph configmap
      cp "/bitnami/janusgraph/conf/janusgraph.properties" "${JANUSGRAPH_PROPERTIES}"

      # Configure libnss_wrapper
      if [[ -f /opt/bitnami/scripts/libos.sh ]]; then
        . /opt/bitnami/scripts/libos.sh
        if ! am_i_root; then
            export LNAME="janusgraph"
            export LD_PRELOAD="/opt/bitnami/common/lib/libnss_wrapper.so"
            if ! user_exists "$(id -u)" && [[ -f "$LD_PRELOAD" ]]; then
                info "Configuring libnss_wrapper"
                NSS_WRAPPER_PASSWD="$(mktemp)"
                export NSS_WRAPPER_PASSWD
                NSS_WRAPPER_GROUP="$(mktemp)"
                export NSS_WRAPPER_GROUP
                echo "janusgraph:x:$(id -u):$(id -g):JanusGraph:${JANUSGRAPH_BASE_DIR}:/bin/false" > "$NSS_WRAPPER_PASSWD"
                echo "janusgraph:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
                chmod 400 "$NSS_WRAPPER_PASSWD" "$NSS_WRAPPER_GROUP"
            fi
        fi
      fi

      # Configure from environment variables
      if [[ -f "/opt/bitnami/scripts/libjanusgraph.sh" ]]; then
        . /opt/bitnami/scripts/libjanusgraph.sh
        janusgraph_properties_configure_from_environment_variables
      fi

      # Check storage
      echo "graph = JanusGraphFactory.open('${JANUSGRAPH_PROPERTIES}')" > "/tmp/check-storage.groovy"
      info "Waiting for Storage backend to be ready..."

      if ! retry_while "${JANUSGRAPH_BIN_DIR}/gremlin.sh -e /tmp/check-storage.groovy"; then
          error "Storage backend is not ready yet."
          exit 1
      fi

      # Cleanup
      rm "/tmp/check-storage.groovy" "${JANUSGRAPH_PROPERTIES}"
      info "Storage is ready"
  env:
    - name: JANUSGRAPH_PROPERTIES
      value: /tmp/janusgraph.properties
    {{- if (include "janusgraph.storage.username" .)}}
    - name: JANUSGRAPH_CFG_STORAGE_USERNAME
      value: {{ include "janusgraph.storage.username" . | quote }}
    {{- if .Values.storageBackend.usePasswordFiles }}
    - name: JANUSGRAPH_CFG_STORAGE_PASSWORD_FILE
      value: {{ printf "/opt/bitnami/janusgraph/secrets/%s" (include "janusgraph.storage.password.secretKey" .) }}
    {{- else }}
    - name: JANUSGRAPH_CFG_STORAGE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "janusgraph.storage.password.secretName" . }}
          key: {{ include "janusgraph.storage.password.secretKey" . }}
    {{- end }}
    {{- end }}
    {{- if .Values.storageBackend.cassandra.enabled }}
    - name: JANUSGRAPH_CFG_STORAGE_CQL_KEYSPACE
      value: {{ .Values.cassandra.keyspace | quote }}
    {{- end }}
    {{- if .Values.extraEnvVars }}
    {{- include "common.tplvalues.render" (dict "value" .Values.extraEnvVars "context" $) | nindent 4 }}
    {{- end }}
  envFrom:
    {{- if .Values.extraEnvVarsCM }}
    - configMapRef:
        name: {{ include "common.tplvalues.render" (dict "value" .Values.extraEnvVarsCM "context" $) }}
    {{- end }}
    {{- if .Values.extraEnvVarsSecret }}
    - secretRef:
        name: {{ include "common.tplvalues.render" (dict "value" .Values.extraEnvVarsSecret "context" $) }}
    {{- end }}
  {{- if .Values.resources }}
  resources: {{ toYaml .Values.resources | nindent 4 }}
  {{- else if ne .Values.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.resourcesPreset) | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    - name: janusgraph-properties
      mountPath: /bitnami/janusgraph/conf/janusgraph.properties
      subPath: janusgraph.properties
    - name: empty-dir
      mountPath: /ext-dir
      subPath: app-ext-dir
    - name: empty-dir
      mountPath: /base-dir
      subPath: app-base-dir
    {{- if .Values.storageBackend.usePasswordFiles }}
    - name: storage-backend-credentials
      mountPath: /opt/bitnami/janusgraph/secrets/
    {{- end }}
{{- end -}}

{{/*
Returns true if a storage backend has been configured
*/}}
{{- define "janusgraph.storage.enabled" -}}
{{- if or .Values.storageBackend.cassandra.enabled .Values.storageBackend.berkeleyje.enabled .Values.storageBackend.external.backend -}}
{{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns the configured storage backend
*/}}
{{- define "janusgraph.storage.backend" -}}
{{- if .Values.storageBackend.cassandra.enabled -}}
{{- print "cql" -}}
{{- else if .Values.storageBackend.berkeleyje.enabled -}}
{{- print "berkeleyje" -}}
{{- else if .Values.storageBackend.external.backend -}}
{{- print .Values.storageBackend.external.backend -}}
{{- end -}}
{{- end -}}

{{/*
Returns the hostname of the configured storage backend
*/}}
{{- define "janusgraph.storage.hostname" -}}
{{- if .Values.storageBackend.cassandra.enabled -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "cassandra" "chartValues" .Values.storageBackend.cassandra "context" $) -}}
{{- else if .Values.storageBackend.external.hostname -}}
{{- print .Values.storageBackend.external.hostname -}}
{{- end -}}
{{- end -}}

{{/*
Returns the port of the configured storage backend
*/}}
{{- define "janusgraph.storage.port" -}}
{{- if .Values.storageBackend.cassandra.enabled }}
{{- printf "%d" (int .Values.cassandra.service.ports.cql) -}}
{{- else if .Values.storageBackend.external.port -}}
{{- printf "%d" (int .Values.storageBackend.external.port) -}}
{{- end -}}
{{- end -}}

{{/*
Create the storage password secret name
*/}}
{{- define "janusgraph.storage.username" -}}
{{- if .Values.storageBackend.cassandra.enabled -}}
{{- print (default "cassandra" .Values.cassandra.dbUser.user) -}}
{{- else if .Values.storageBackend.external.username -}}
{{- .Values.storageBackend.external.username -}}
{{- end -}}
{{- end -}}

{{/*
Create the storage password secret name
*/}}
{{- define "janusgraph.storage.password.secretName" -}}
{{- if .Values.storageBackend.cassandra.enabled -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "cassandra" "chartValues" .Values.storageBackend.cassandra "context" $) -}}
{{- else if .Values.storageBackend.external.existingSecret -}}
{{- print (tpl .Values.storageBackend.external.existingSecret .) -}}
{{- end -}}
{{- end -}}

{{/*
Create the storage password secret key
*/}}
{{- define "janusgraph.storage.password.secretKey" -}}
{{- if .Values.storageBackend.cassandra.enabled -}}
cassandra-password
{{- else if .Values.storageBackend.external.existingSecretPasswordKey -}}
{{- .Values.storageBackend.external.existingSecretPasswordKey -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if a index management backend has been configured
*/}}
{{- define "janusgraph.index.enabled" -}}
{{- if or .Values.indexBackend.lucene.enabled .Values.indexBackend.external.backend -}}
{{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns the configured index management backend
*/}}
{{- define "janusgraph.index.backend" -}}
{{- if .Values.indexBackend.lucene.enabled -}}
{{- print "lucene" -}}
{{- else if .Values.indexBackend.external.backend -}}
{{- print .Values.indexBackend.external.backend -}}
{{- end -}}
{{- end -}}

{{/*
Returns the hostname of the configured index management backend
*/}}
{{- define "janusgraph.index.hostname" -}}
{{- if .Values.indexBackend.external.hostname -}}
{{- print .Values.indexBackend.external.hostname -}}
{{- end -}}
{{- end -}}

{{/*
Returns the port of the configured index management backend
*/}}
{{- define "janusgraph.index.port" -}}
{{- if .Values.indexBackend.external.port -}}
{{- printf "%d" ( int .Values.indexBackend.external.port) -}}
{{- end -}}
{{- end -}}

{{/*
Returns the Janusgraph JVM Java options for the conteiner
*/}}
{{- define "janusgraph.javaOpts" -}}
{{- if .Values.metrics.enabled -}}
{{ printf "%s -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=%d" .Values.javaOptions (int .Values.containerPorts.jmx) }}
{{- else -}}
{{ print .Values.javaOptions }}
{{- end -}}
{{- end -}}

{{/*
Return the JanusGraph configuration configmap
*/}}
{{- define "janusgraph.configmapName" -}}
{{- if .Values.existingConfigmap -}}
{{- include "common.tplvalues.render" (dict "value" .Values.existingConfigmap "context" $) -}}
{{- else -}}
{{- print (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the JanusGraph metrics configuration configmap
*/}}
{{- define "janusgraph.metrics.configmapName" -}}
{{- if .Values.metrics.existingConfigmap -}}
{{- include "common.tplvalues.render" (dict "value" .Values.metrics.existingConfigmap "context" $) -}}
{{- else -}}
{{ printf "%s-jmx-configuration" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "janusgraph.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "janusgraph.validateValues.storageBackend.enabled" .) -}}
{{- $messages := append $messages (include "janusgraph.validateValues.storageBackend.individual" .) -}}
{{- $messages := append $messages (include "janusgraph.validateValues.indexBackend.individual" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Janusgraph - At least one storage backend is enabled
*/}}
{{- define "janusgraph.validateValues.storageBackend.enabled" -}}
{{- if not (include "janusgraph.storage.enabled" .) -}}
janusgraph: storageBackend
    At least one storage backend has to be configured.
    Currently supported storage backends are:
     - Cassandra (using Cassandra subchart) - storageBackend.cassandra.enabled
     - BerkeleyDB (local) - storageBackend.berkeleyje.enabled
     - External storage - storageBackend.external.backend
{{- end -}}
{{- end -}}

{{/*
Validate values of Janusgraph - Only one storage backend can be configured
*/}}
{{- define "janusgraph.validateValues.storageBackend.individual" -}}
{{- $backends := 0 -}}
{{- if .Values.storageBackend.cassandra.enabled }}{{ $backends = add $backends 1 }}{{ end }}
{{- if .Values.storageBackend.berkeleyje.enabled }}{{ $backends = add $backends 1 }}{{ end }}
{{- if .Values.storageBackend.external.backend }}{{ $backends = add $backends 1 }}{{ end }}
{{- if gt $backends 1 -}}
janusgraph: storageBackend
    Only one storage backend can be configured at the same time
{{- end -}}
{{- end -}}

{{/*
Validate values of Janusgraph - Only one storage backend can be configured
*/}}
{{- define "janusgraph.validateValues.indexBackend.individual" -}}
{{- $backends := 0 -}}
{{- if .Values.indexBackend.lucene.enabled }}{{ $backends = add $backends 1 }}{{ end }}
{{- if .Values.indexBackend.external.backend }}{{ $backends = add $backends 1 }}{{ end }}
{{- if gt $backends 1 -}}
janusgraph: indexBackend
    Only one index backend can be configured at the same time
{{- end -}}
{{- end -}}
