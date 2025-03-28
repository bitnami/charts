{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper OS image name
*/}}
{{- define "opensearch.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper sysctl image name
*/}}
{{- define "opensearch.sysctl.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.sysctlImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "opensearch.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper OpenSearch Dashboards image name
*/}}
{{- define "opensearch.dashboards.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.dashboards.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper OpenSearch Snapshots image name
*/}}
{{- define "opensearch.snapshots.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.snapshots.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "opensearch.imagePullSecrets" -}}
{{ include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.sysctlImage .Values.volumePermissions.image .Values.dashboards.image .Values.snapshots.image) "context" $) }}
{{- end -}}

{{/*
Return the proper sysctl image name
*/}}
{{- define "opensearch.sysctl.initContainer" -}}
## Image that performs the sysctl operation to modify Kernel settings (needed sometimes to avoid boot errors)
- name: sysctl
  image: {{ include "opensearch.sysctl.image" . }}
  imagePullPolicy: {{ .Values.sysctlImage.pullPolicy | quote }}
  command:
    - /bin/bash
    - -ec
    - |
      {{- include "opensearch.sysctlIfLess" (dict "key" "vm.max_map_count" "value" "262144") | nindent 14 }}
      {{- include "opensearch.sysctlIfLess" (dict "key" "fs.file-max" "value" "65536") | nindent 14 }}
  securityContext:
    privileged: true
    runAsUser: 0
  {{- if .Values.sysctlImage.resources }}
  resources: {{- toYaml .Values.sysctlImage.resources | nindent 12 }}
  {{- else if ne .Values.sysctlImage.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.sysctlImage.resourcesPreset) | nindent 12 }}
  {{- end }}
{{- end -}}

{{/*
Return the copy plugins init container definition
*/}}
{{- define "opensearch.copy-default-plugins.initContainer" -}}
{{- $block := index .context.Values .component }}
- name: copy-default-plugins
  image: {{ include "opensearch.image" .context }}
  imagePullPolicy: {{ .context.Values.image.pullPolicy | quote }}
  {{- if $block.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" $block.containerSecurityContext "context" .context) | nindent 12 }}
  {{- end }}
  {{- if $block.resources }}
  resources: {{- toYaml $block.resources | nindent 12 }}
  {{- else if ne $block.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" $block.resourcesPreset) | nindent 12 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
        . /opt/bitnami/scripts/liblog.sh
        . /opt/bitnami/scripts/libfs.sh
        . /opt/bitnami/scripts/opensearch-env.sh

        mkdir -p /emptydir/app-conf-dir /emptydir/app-plugins-dir
        info "Copying directories to empty dir"

        if ! is_dir_empty "$DB_DEFAULT_CONF_DIR"; then
            info "Copying default configuration"
            cp -nr --preserve=mode "$DB_DEFAULT_CONF_DIR"/* /emptydir/app-conf-dir
        fi
        if ! is_dir_empty "$DB_DEFAULT_PLUGINS_DIR"; then
            info "Copying default plugins"
            cp -nr "$DB_DEFAULT_PLUGINS_DIR"/* /emptydir/app-plugins-dir
        fi

        info "Copy operation completed"
  volumeMounts:
    - name: empty-dir
      mountPath: /emptydir
{{- end -}}

{{/*
Return the copy plugins init container definition
*/}}
{{- define "opensearch.dashboards.copy-default-plugins.initContainer" -}}
- name: copy-default-plugins
  image: {{ include "opensearch.dashboards.image" . }}
  imagePullPolicy: {{ .Values.dashboards.image.pullPolicy | quote }}
  {{- if .Values.dashboards.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.dashboards.containerSecurityContext "context" $) | nindent 12 }}
  {{- end }}
  {{- if .Values.dashboards.resources }}
  resources: {{- toYaml .Values.dashboards.resources | nindent 12 }}
  {{- else if ne .Values.dashboards.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.dashboards.resourcesPreset) | nindent 12 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
        #!/bin/bash

        . /opt/bitnami/scripts/libfs.sh
        . /opt/bitnami/scripts/opensearch-dashboards-env.sh

        if ! is_dir_empty "$SERVER_DEFAULT_PLUGINS_DIR"; then
            cp -nr "$SERVER_DEFAULT_PLUGINS_DIR"/* /plugins
        fi
  volumeMounts:
    - name: empty-dir
      mountPath: /plugins
      subPath: app-plugins-dir
{{- end -}}

{{/*
Set Elasticsearch PVC.
*/}}
{{- define "opensearch.dashboards.pvc" -}}
{{- .Values.dashboards.persistence.existingClaim | default (include "opensearch.dashboards.fullname" .) -}}
{{- end -}}

{{/*
Name for the OpenSearch service
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.service.name" -}}
{{- include "common.names.fullname" . | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Port number for the OpenSearch service REST API port
*/}}
{{- define "opensearch.service.ports.restAPI" -}}
{{- printf "%d" (int .Values.service.ports.restAPI) -}}
{{- end -}}

{{/*
Create a default fully qualified master name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.master.fullname" -}}
{{- $name := default "master" .Values.master.nameOverride -}}
{{- if .Values.master.fullnameOverride -}}
{{- .Values.master.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default master service name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.master.servicename" -}}
{{- $name := coalesce .Values.master.service.headless.nameOverride .Values.master.servicenameOverride | default "" -}}
{{- default (printf "%s-hl" (include "opensearch.master.fullname" .)) (tpl $name .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified coordinating name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.coordinating.fullname" -}}
{{- $name := default "coordinating" .Values.coordinating.nameOverride -}}
{{- if .Values.coordinating.fullnameOverride -}}
{{- .Values.coordinating.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default coordinating service name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.coordinating.servicename" -}}
{{- $name := coalesce .Values.coordinating.service.headless.nameOverride .Values.coordinating.servicenameOverride | default "" -}}
{{- default (printf "%s-hl" (include "opensearch.coordinating.fullname" .)) (tpl $name .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified data name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.data.fullname" -}}
{{- $name := default "data" .Values.data.nameOverride -}}
{{- if .Values.data.fullnameOverride -}}
{{- .Values.data.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default data service name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.data.servicename" -}}
{{- $name := coalesce .Values.data.service.headless.nameOverride .Values.data.servicenameOverride | default "" -}}
{{- default (printf "%s-hl" (include "opensearch.data.fullname" .)) (tpl $name .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified ingest name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.ingest.fullname" -}}
{{- $name := default "ingest" .Values.ingest.nameOverride -}}
{{- if .Values.ingest.fullnameOverride -}}
{{- .Values.ingest.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default ingest service name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.ingest.servicename" -}}
{{- $name := coalesce .Values.ingest.service.headless.nameOverride .Values.ingest.servicenameOverride | default "" -}}
{{- default (printf "%s-hl" (include "opensearch.ingest.fullname" .)) (tpl $name .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Returns true if at least one master-eligible node replica has been configured.
*/}}
{{- define "opensearch.master.enabled" -}}
{{- if or .Values.master.autoscaling.hpa.enabled (gt (int .Values.master.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one coordinating-only node replica has been configured.
*/}}
{{- define "opensearch.coordinating.enabled" -}}
{{- if or .Values.coordinating.autoscaling.hpa.enabled (gt (int .Values.coordinating.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one data-only node replica has been configured.
*/}}
{{- define "opensearch.data.enabled" -}}
{{- if or .Values.data.autoscaling.hpa.enabled (gt (int .Values.data.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one ingest-only node replica has been configured.
*/}}
{{- define "opensearch.ingest.enabled" -}}
{{- if and .Values.ingest.enabled (or .Values.ingest.autoscaling.hpa.enabled (gt (int .Values.ingest.replicaCount) 0)) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one dashboards replica has been configured.
*/}}
{{- define "opensearch.dashboards.enabled" -}}
{{- if and .Values.dashboards.enabled (or .Values.dashboards.autoscaling.hpa.enabled (gt (int .Values.dashboards.replicaCount) 0)) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the hostname of every OpenSearch seed node
*/}}
{{- define "opensearch.hosts" -}}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $releaseNamespace := include "common.names.namespace" . }}
{{- if (include "opensearch.master.enabled" .) -}}
{{- $masterFullname := include "opensearch.master.servicename" .}}
{{- $masterFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- if (include "opensearch.coordinating.enabled" .) -}}
{{- $coordinatingFullname := include "opensearch.coordinating.servicename" .}}
{{- $coordinatingFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- if (include "opensearch.data.enabled" .) -}}
{{- $dataFullname := include "opensearch.data.servicename" .}}
{{- $dataFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- if (include "opensearch.ingest.enabled" .) -}}
{{- $ingestFullname := include "opensearch.ingest.servicename" .}}
{{- $ingestFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- range .Values.extraHosts }}
{{- . }},
{{- end }}
{{- end -}}

{{/*
Get the initialization scripts volume name.
*/}}
{{- define "opensearch.initScripts" -}}
{{- printf "%s-init-scripts" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Get the initialization scripts ConfigMap name.
*/}}
{{- define "opensearch.initScriptsCM" -}}
{{- print (tpl .Values.initScriptsCM .) -}}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "opensearch.initScriptsSecret" -}}
{{- print (tpl .Values.initScriptsSecret .) -}}
{{- end -}}

{{/*
Create the name of the master service account to use
*/}}
{{- define "opensearch.master.serviceAccountName" -}}
{{- if .Values.master.serviceAccount.create -}}
    {{ default (include "opensearch.master.fullname" .) .Values.master.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.master.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the coordinating-only service account to use
*/}}
{{- define "opensearch.coordinating.serviceAccountName" -}}
{{- if .Values.coordinating.serviceAccount.create -}}
    {{ default (include "opensearch.coordinating.fullname" .) .Values.coordinating.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.coordinating.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the data service account to use
*/}}
{{- define "opensearch.data.serviceAccountName" -}}
{{- if .Values.data.serviceAccount.create -}}
    {{ default (include "opensearch.data.fullname" .) .Values.data.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.data.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the ingest service account to use
*/}}
{{- define "opensearch.ingest.serviceAccountName" -}}
{{- if .Values.ingest.serviceAccount.create -}}
    {{ default (include "opensearch.ingest.fullname" .) .Values.ingest.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.ingest.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret for typed nodes.
*/}}
{{- define "opensearch.node.tlsSecretName" -}}
{{- $secretName := index .context.Values.security.tls .nodeRole "existingSecret" -}}
{{- if $secretName -}}
    {{- print (tpl $secretName .context) -}}
{{- else -}}
    {{- printf "%s-crt" (include (printf "opensearch.%s.fullname" .nodeRole) .context) -}}
{{- end -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret items for typed nodes.
*/}}
{{- define "opensearch.node.tlsSecretItems" -}}
{{- $items := list }}
{{- $items = append $items (dict "key" (include "opensearch.node.tlsSecretCertKey" (dict "nodeRole" .nodeRole "context" .context)) "path" "tls.crt") }}
{{- $items = append $items (dict "key" (include "opensearch.node.tlsSecretKeyKey" (dict "nodeRole" .nodeRole "context" .context)) "path" "tls.key") }}
{{- $items = append $items (dict "key" (include "opensearch.node.tlsSecretCAKey" (dict "nodeRole" .nodeRole "context" .context)) "path" "ca.crt") }}
{{ $items | toYaml }}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret key of the certificate for typed nodes.
*/}}
{{- define "opensearch.node.tlsSecretCertKey" -}}
{{- include "opensearch.tlsSecretKey" (dict "type" .nodeRole "secretKey" "certKey" "defaultKey" "tls.crt" "context" .context) -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret key of the certificates key for typed nodes.
*/}}
{{- define "opensearch.node.tlsSecretKeyKey" -}}
{{- include "opensearch.tlsSecretKey" (dict "type" .nodeRole "secretKey" "keyKey" "defaultKey" "tls.key" "context" .context) -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret key of the ca certificate for typed nodes.
*/}}
{{- define "opensearch.node.tlsSecretCAKey" -}}
{{- include "opensearch.tlsSecretKey" (dict "type" .nodeRole "secretKey" "caKey" "defaultKey" "ca.crt" "context" .context) -}}
{{- end -}}

{{/*
Return the opensearch admin TLS credentials secret for all nodes.
*/}}
{{- define "opensearch.admin.tlsSecretName" -}}
{{- $secretName := .context.Values.security.tls.admin.existingSecret -}}
{{- if $secretName -}}
    {{- print (tpl $secretName .context) -}}
{{- else -}}
    {{- printf "%s-admin-crt" (include "common.names.fullname" .context) -}}
{{- end -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret items for all nodes.
*/}}
{{- define "opensearch.admin.tlsSecretItems" -}}
{{- $items := list }}
{{- $items = append $items (dict "key" (include "opensearch.admin.tlsSecretCertKey" (dict "context" .context)) "path" "admin.crt") }}
{{- $items = append $items (dict "key" (include "opensearch.admin.tlsSecretKeyKey" (dict "context" .context)) "path" "admin.key") }}
{{ $items | toYaml }}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret key of the certificate for all nodes.
*/}}
{{- define "opensearch.admin.tlsSecretCertKey" -}}
{{- include "opensearch.tlsSecretKey" (dict "type" "admin" "secretKey" "certKey" "defaultKey" "admin.crt" "context" .context) -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret key of the certificates key for all nodes.
*/}}
{{- define "opensearch.admin.tlsSecretKeyKey" -}}
{{- include "opensearch.tlsSecretKey" (dict "type" "admin" "secretKey" "keyKey" "defaultKey" "admin.key" "context" .context) -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret key of the given type.
*/}}
{{- define "opensearch.tlsSecretKey" -}}
{{- $secretConfig := index .context.Values.security.tls .type -}}
{{- if $secretConfig.existingSecret }}
{{- print (index $secretConfig .secretKey | default .defaultKey) }}
{{- else }}
{{- print .defaultKey }}
{{- end }}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "opensearch.createTlsSecret" -}}
{{- if and .Values.security.enabled .Values.security.tls.autoGenerated (not (include "opensearch.security.tlsSecretsProvided" .)) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if an authentication credentials secret object should be created
*/}}
{{- define "opensearch.createSecret" -}}
{{- if and .Values.security.enabled (not .Values.security.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the OpenSearch authentication credentials secret name
*/}}
{{- define "opensearch.secretName" -}}
{{- if .Values.security.existingSecret -}}
    {{- print (tpl .Values.security.existingSecret $) -}}
{{- else -}}
    {{- print (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS password secret object should be created
*/}}
{{- define "opensearch.createTlsPasswordsSecret" -}}
{{- if and .Values.security.enabled (not .Values.security.tls.passwordsSecret) (or .Values.security.tls.keystorePassword .Values.security.tls.truststorePassword .Values.security.tls.keyPassword ) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the OpenSearch TLS password secret name
*/}}
{{- define "opensearch.tlsPasswordsSecret" -}}
{{- if .Values.security.tls.passwordsSecret -}}
    {{- print (tpl .Values.security.tls.passwordsSecret .) -}}
{{- else -}}
    {{- printf "%s-tls-pass" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Returns the name of the secret key containing the Keystore password
*/}}
{{- define "opensearch.keystorePasswordKey" -}}
{{- default "keystore-password" (tpl .Values.security.tls.secretKeystoreKey .) -}}
{{- end -}}

{{/*
Returns the name of the secret key containing the Truststore password
*/}}
{{- define "opensearch.truststorePasswordKey" -}}
{{- default "truststore-password" (tpl .Values.security.tls.secretTruststoreKey .) -}}
{{- end -}}

{{/*
Returns the name of the secret key containing the PEM key password
*/}}
{{- define "opensearch.keyPasswordKey" -}}
{{- default "key-password" (tpl .Values.security.tls.secretKey .) -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "opensearch.configure.security" -}}
{{- $nodesDN := list }}
{{- if and (include "opensearch.master.enabled" .) }}
{{- $nodesDN = append $nodesDN (printf "CN=%s" (include "opensearch.master.fullname" .))}}
{{- end }}
{{- if and (include "opensearch.data.enabled" .) }}
{{- $nodesDN = append $nodesDN (printf "CN=%s" (include "opensearch.data.fullname" .))}}
{{- end }}
{{- if and (include "opensearch.coordinating.enabled" .) }}
{{- $nodesDN = append $nodesDN (printf "CN=%s" (include "opensearch.coordinating.fullname" .))}}
{{- end }}
{{- if and (include "opensearch.ingest.enabled" .) }}
{{- $nodesDN = append $nodesDN (printf "CN=%s" (include "opensearch.ingest.fullname" .))}}
{{- end }}
- name: OPENSEARCH_SECURITY_NODES_DN
  value: {{ coalesce .Values.security.tls.nodesDN ( join ";" $nodesDN ) }}
- name: OPENSEARCH_SECURITY_ADMIN_DN
  value: {{ coalesce .Values.security.tls.adminDN "CN=admin;CN=admin" }}
- name: OPENSEARCH_ENABLE_SECURITY
  value: "true"
- name: OPENSEARCH_PASSWORD
  valueFrom:
    secretKeyRef:
        name: {{ include "opensearch.secretName" . }}
        key: opensearch-password
- name: OPENSEARCH_DASHBOARDS_PASSWORD
  valueFrom:
    secretKeyRef:
        name: {{ include "opensearch.secretName" . }}
        key: opensearch-dashboards-password
- name: LOGSTASH_PASSWORD
  valueFrom:
    secretKeyRef:
        name: {{ include "opensearch.secretName" . }}
        key: logstash-password
- name: OPENSEARCH_ENABLE_FIPS_MODE
  value: {{ .Values.security.fipsMode | quote }}
- name: OPENSEARCH_TLS_VERIFICATION_MODE
  value: {{ .Values.security.tls.verificationMode | quote }}
- name: OPENSEARCH_ENABLE_REST_TLS
  value: {{ ternary "true" "false" .Values.security.tls.restEncryption | quote }}
{{- if or (include "opensearch.createTlsSecret" .) .Values.security.tls.usePemCerts }}
- name: OPENSEARCH_TLS_USE_PEM
  value: "true"
{{- else }}
- name: OPENSEARCH_KEYSTORE_LOCATION
  value: "/opt/bitnami/opensearch/config/certs/{{ .Values.security.tls.keystoreFilename }}"
- name: OPENSEARCH_TRUSTSTORE_LOCATION
  value: "/opt/bitnami/opensearch/config/certs/{{ .Values.security.tls.truststoreFilename }}"
{{- end }}
{{- if and (not .Values.security.tls.usePemCerts) (or .Values.security.tls.keystorePassword .Values.security.tls.passwordsSecret) }}
- name: OPENSEARCH_KEYSTORE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "opensearch.tlsPasswordsSecret" . }}
      key: {{ include "opensearch.keystorePasswordKey" . | quote }}
{{- end }}
{{- if and (not .Values.security.tls.usePemCerts) (or .Values.security.tls.truststorePassword .Values.security.tls.passwordsSecret) }}
- name: OPENSEARCH_TRUSTSTORE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "opensearch.tlsPasswordsSecret" . }}
      key: {{ include "opensearch.truststorePasswordKey" . | quote }}
{{- end }}
{{- if and .Values.security.tls.usePemCerts (or .Values.security.tls.keyPassword .Values.security.tls.passwordsSecret) }}
- name: OPENSEARCH_KEY_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "opensearch.tlsPasswordsSecret" . }}
      key: {{ include "opensearch.keyPasswordKey" . | quote }}
{{- end }}
{{- end -}}

{{/*
Returns true if at least 1 existing secret was provided
*/}}
{{- define "opensearch.security.tlsSecretsProvided" -}}
{{- $masterSecret := (and (include "opensearch.master.enabled" .) .Values.security.tls.master.existingSecret) -}}
{{- $coordinatingSecret := (and (include "opensearch.coordinating.enabled" .) .Values.security.tls.coordinating.existingSecret) -}}
{{- $dataSecret := (and (include "opensearch.data.enabled" .) .Values.security.tls.data.existingSecret) -}}
{{- $ingestSecret := (and (include "opensearch.ingest.enabled" .) .Values.security.tls.ingest.existingSecret) -}}
{{- if or $masterSecret $coordinatingSecret $dataSecret $ingestSecret }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/* Validate values of OpenSearch - Existing secret not provided for master nodes */}}
{{- define "opensearch.validateValues.security.missingTlsSecrets.master" -}}
{{- $masterSecret := (and (include "opensearch.master.enabled" .) (not .Values.security.tls.master.existingSecret)) -}}
{{- if and .Values.security.enabled (include "opensearch.security.tlsSecretsProvided" .) $masterSecret -}}
opensearch: security.tls.master.existingSecret
    Missing secret containing the TLS certificates for the OpenSearch master nodes.
    Provide the certificates using --set .security.tls.master.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of OpenSearch - Existing secret not provided for coordinating-only nodes */}}
{{- define "opensearch.validateValues.security.missingTlsSecrets.coordinating" -}}
{{- $coordinatingSecret := (and (include "opensearch.coordinating.enabled" .) (not .Values.security.tls.coordinating.existingSecret)) -}}
{{- if and .Values.security.enabled (include "opensearch.security.tlsSecretsProvided" .) $coordinatingSecret -}}
opensearch: security.tls.coordinating.existingSecret
    Missing secret containing the TLS certificates for the OpenSearch coordinating-only nodes.
    Provide the certificates using --set .security.tls.coordinating.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of OpenSearch - Existing secret not provided for data nodes */}}
{{- define "opensearch.validateValues.security.missingTlsSecrets.data" -}}
{{- $dataSecret := (and (include "opensearch.data.enabled" .) (not .Values.security.tls.data.existingSecret)) -}}
{{- if and .Values.security.enabled (include "opensearch.security.tlsSecretsProvided" .) $dataSecret -}}
opensearch: security.tls.data.existingSecret
    Missing secret containing the TLS certificates for the OpenSearch data nodes.
    Provide the certificates using --set .security.tls.data.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of OpenSearch - Existing secret not provided for ingest nodes */}}
{{- define "opensearch.validateValues.security.missingTlsSecrets.ingest" -}}
{{- $ingestSecret := (and (include "opensearch.ingest.enabled" .) (not .Values.security.tls.ingest.existingSecret)) -}}
{{- if and .Values.security.enabled (include "opensearch.security.tlsSecretsProvided" .) $ingestSecret -}}
opensearch: security.tls.ingest.existingSecret
    Missing secret containing the TLS certificates for the OpenSearch ingest nodes.
    Provide the certificates using --set .security.tls.ingest.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of OpenSearch - TLS enabled but no certificates provided */}}
{{- define "opensearch.validateValues.security.tls" -}}
{{- if and .Values.security.enabled (not .Values.security.tls.autoGenerated) (not (include "opensearch.security.tlsSecretsProvided" .)) -}}
opensearch: security.tls
    In order to enable X-Pack Security, it is necessary to configure TLS.
    Three different mechanisms can be used:
        - Provide an existing secret containing the Keystore and Truststore for each role
        - Provide an existing secret containing the PEM certificates for each role and enable `security.tls.usePemCerts=true`
        - Enable using auto-generated certificates with `security.tls.autoGenerated=true`
    Existing secrets containing either JKS/PKCS12 or PEM certificates can be provided using --set Values.security.tls.master.existingSecret=master-certs,
    --set Values.security.tls.data.existingSecret=data-certs, --set Values.security.tls.coordinating.existingSecret=coordinating-certs, --set Values.security.tls.ingest.existingSecret=ingest-certs
{{- end -}}
{{- end -}}

{{/* Validate at least OpenSearch one master node is configured */}}
{{- define "opensearch.validateValues.master.replicas" -}}
{{- if not (include "opensearch.master.enabled" .) -}}
opensearch: master.replicas
    OpenSearch needs at least one master-eligible node to form a cluster.
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "opensearch.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "opensearch.validateValues.master.replicas" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.tls" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.missingTlsSecrets.master" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.missingTlsSecrets.data" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.missingTlsSecrets.coordinating" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.missingTlsSecrets.ingest" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Sysctl set if less then
*/}}
{{- define "opensearch.sysctlIfLess" -}}
CURRENT=`sysctl -n {{ .key }}`;
DESIRED="{{ .value }}";
if [ "$DESIRED" -gt "$CURRENT" ]; then
    sysctl -w {{ .key }}={{ .value }};
fi;
{{- end -}}

{{/*
Create a default fully qualified dashboards name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.dashboards.fullname" -}}
{{- $name := default "dashboards" .Values.dashboards.nameOverride -}}
{{- if .Values.dashboards.fullnameOverride -}}
{{- .Values.dashboards.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the dashboards service account to use
*/}}
{{- define "opensearch.dashboards.serviceAccountName" -}}
{{- if .Values.dashboards.serviceAccount.create -}}
    {{ default (include "opensearch.dashboards.fullname" .) .Values.dashboards.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.dashboards.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default Dashboards service name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.dashboards.servicename" -}}
{{- $name := coalesce .Values.dashboards.service.nameOverride .Values.dashboards.servicenameOverride | default "" -}}
{{- default (include "opensearch.dashboards.fullname" .) (tpl $name .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Set OpenSearch URL.
*/}}
{{- define "opensearch.url" -}}
{{- $protocol := ternary "https" "http" .Values.security.tls.restEncryption -}}
{{- printf "%s://%s:%s" $protocol (include "opensearch.service.name" .) (include "opensearch.service.ports.restAPI" .) -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret for Dashboards UI.
*/}}
{{- define "opensearch.dashboards.tlsSecretName" -}}
{{- $secretName := .Values.dashboards.tls.existingSecret -}}
{{- if $secretName -}}
    {{- print (tpl $secretName .) -}}
{{- else -}}
    {{- printf "%s-crt" (include "opensearch.dashboards.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "opensearch.dashboards.createTlsSecret" -}}
{{- if and .Values.dashboards.tls.enabled .Values.dashboards.tls.autoGenerated (not .Values.dashboards.tls.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified snapshots name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.snapshots.fullname" -}}
{{- $name := default "snapshots" .Values.snapshots.nameOverride -}}
{{- if .Values.snapshots.fullnameOverride -}}
{{- .Values.snapshots.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a global mount path for snapshots volume based on repo path
*/}}
{{- define "opensearch.snapshots.mountPath" -}}
{{- required "Value snapshotRepoPath must be set!" $.Values.snapshotRepoPath -}}
{{- end -}}

{{/*
Create name for snapshot API repo data ConfigMap
*/}}
{{- define "opensearch.snapshots.repoDataConfigMap" -}}
{{- printf "%s-repo-data" (include "opensearch.snapshots.fullname" $) -}}
{{- end -}}

{{/*
Create name for snapshot API policy data ConfigMap
*/}}
{{- define "opensearch.snapshots.policyDataConfigMap" -}}
{{- printf "%s-policy-data" (include "opensearch.snapshots.fullname" $) -}}
{{- end -}}
