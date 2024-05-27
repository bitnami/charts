{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper ES image name
*/}}
{{- define "elasticsearch.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "elasticsearch.imagePullSecrets" -}}
{{ include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.sysctlImage .Values.volumePermissions.image) "context" $) }}
{{- end -}}

{{/*
Return the proper ES exporter image name
*/}}
{{- define "elasticsearch.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper sysctl image name
*/}}
{{- define "elasticsearch.sysctl.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.sysctlImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "elasticsearch.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}


{{/*
Name for the Elasticsearch service
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
Required for the Kibana subchart to find Elasticsearch service.
*/}}
{{- define "elasticsearch.service.name" -}}
{{- if .Values.global.kibanaEnabled -}}
    {{- $name := .Values.global.elasticsearch.service.name -}}
    {{- if contains $name .Release.Name -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" ( include "common.names.fullname" . )  | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Port number for the Elasticsearch service REST API port
Required for the Kibana subchart to find Elasticsearch service.
*/}}
{{- define "elasticsearch.service.ports.restAPI" -}}
{{- if .Values.global.kibanaEnabled -}}
{{- printf "%d" (int .Values.global.elasticsearch.service.ports.restAPI) -}}
{{- else -}}
{{- printf "%d" (int .Values.service.ports.restAPI) -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified master name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.master.fullname" -}}
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
{{- define "elasticsearch.master.servicename" -}}
{{- if .Values.master.servicenameOverride -}}
{{- .Values.master.servicenameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-hl" (include "elasticsearch.master.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified coordinating name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.coordinating.fullname" -}}
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
{{- define "elasticsearch.coordinating.servicename" -}}
{{- if .Values.coordinating.servicenameOverride -}}
{{- .Values.coordinating.servicenameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-hl" (include "elasticsearch.coordinating.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified data name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.data.fullname" -}}
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
{{- define "elasticsearch.data.servicename" -}}
{{- if .Values.data.servicenameOverride -}}
{{- .Values.data.servicenameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-hl" (include "elasticsearch.data.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified ingest name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.ingest.fullname" -}}
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
{{- define "elasticsearch.ingest.servicename" -}}
{{- if .Values.ingest.servicenameOverride -}}
{{- .Values.ingest.servicenameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-hl" (include "elasticsearch.ingest.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified metrics name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.metrics.fullname" -}}
{{- $name := default "metrics" .Values.metrics.nameOverride -}}
{{- if .Values.metrics.fullnameOverride -}}
{{- .Values.metrics.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one master-elegible node replica has been configured.
*/}}
{{- define "elasticsearch.master.enabled" -}}
{{- if or .Values.master.autoscaling.enabled (gt (int .Values.master.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one coordinating-only node replica has been configured.
*/}}
{{- define "elasticsearch.coordinating.enabled" -}}
{{- if or .Values.coordinating.autoscaling.enabled (gt (int .Values.coordinating.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one data-only node replica has been configured.
*/}}
{{- define "elasticsearch.data.enabled" -}}
{{- if or .Values.data.autoscaling.enabled (gt (int .Values.data.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one ingest-only node replica has been configured.
*/}}
{{- define "elasticsearch.ingest.enabled" -}}
{{- if and .Values.ingest.enabled (or .Values.ingest.autoscaling.enabled (gt (int .Values.ingest.replicaCount) 0)) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if only one master node replica has been configured to assume all the roles
*/}}
{{- define "elasticsearch.singleNode.enabled" -}}
{{- if and (eq (int .Values.master.replicaCount) 1) (not (or .Values.master.masterOnly .Values.master.autoscaling.enabled (include "elasticsearch.data.enabled" .) (include "elasticsearch.coordinating.enabled" .) (include "elasticsearch.ingest.enabled" .))) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the hostname of every ElasticSearch seed node
*/}}
{{- define "elasticsearch.hosts" -}}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $releaseNamespace := include "common.names.namespace" . }}
{{- if (include "elasticsearch.master.enabled" .) -}}
{{- $masterFullname := include "elasticsearch.master.servicename" .}}
{{- $masterFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- if (include "elasticsearch.coordinating.enabled" .) -}}
{{- $coordinatingFullname := include "elasticsearch.coordinating.servicename" .}}
{{- $coordinatingFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- if (include "elasticsearch.data.enabled" .) -}}
{{- $dataFullname := include "elasticsearch.data.servicename" .}}
{{- $dataFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- if (include "elasticsearch.ingest.enabled" .) -}}
{{- $ingestFullname := include "elasticsearch.ingest.servicename" .}}
{{- $ingestFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- range .Values.extraHosts }}
{{- . }},
{{- end }}
{{- end -}}

{{/*
Get the initialization scripts volume name.
*/}}
{{- define "elasticsearch.initScripts" -}}
{{- printf "%s-init-scripts" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Get the initialization scripts ConfigMap name.
*/}}
{{- define "elasticsearch.initScriptsCM" -}}
{{- printf "%s" .Values.initScriptsCM -}}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "elasticsearch.initScriptsSecret" -}}
{{- printf "%s" .Values.initScriptsSecret -}}
{{- end -}}

{{/*
 Create the name of the master service account to use
 */}}
{{- define "elasticsearch.master.serviceAccountName" -}}
{{- if .Values.master.serviceAccount.create -}}
    {{ default (include "elasticsearch.master.fullname" .) .Values.master.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.master.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the coordinating-only service account to use
 */}}
{{- define "elasticsearch.coordinating.serviceAccountName" -}}
{{- if .Values.coordinating.serviceAccount.create -}}
    {{ default (include "elasticsearch.coordinating.fullname" .) .Values.coordinating.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.coordinating.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the data service account to use
 */}}
{{- define "elasticsearch.data.serviceAccountName" -}}
{{- if .Values.data.serviceAccount.create -}}
    {{ default (include "elasticsearch.data.fullname" .) .Values.data.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.data.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the ingest service account to use
 */}}
{{- define "elasticsearch.ingest.serviceAccountName" -}}
{{- if .Values.ingest.serviceAccount.create -}}
    {{ default (include "elasticsearch.ingest.fullname" .) .Values.ingest.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.ingest.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the metrics service account to use
 */}}
{{- define "elasticsearch.metrics.serviceAccountName" -}}
{{- if .Values.metrics.serviceAccount.create -}}
    {{ default (include "elasticsearch.metrics.fullname" .) .Values.metrics.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.metrics.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the elasticsearch TLS credentials secret for master nodes.
*/}}
{{- define "elasticsearch.master.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.master.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "elasticsearch.master.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the elasticsearch TLS credentials secret for data nodes.
*/}}
{{- define "elasticsearch.data.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.data.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "elasticsearch.data.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the elasticsearch TLS credentials secret for ingest nodes.
*/}}
{{- define "elasticsearch.ingest.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.ingest.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "elasticsearch.ingest.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the elasticsearch TLS credentials secret for coordinating-only nodes.
*/}}
{{- define "elasticsearch.coordinating.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.coordinating.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "elasticsearch.coordinating.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "elasticsearch.createTlsSecret" -}}
{{- if and .Values.security.enabled .Values.security.tls.autoGenerated (not (include "elasticsearch.security.tlsSecretsProvided" .)) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if an authentication credentials secret object should be created
*/}}
{{- define "elasticsearch.createSecret" -}}
{{- if and .Values.security.enabled (not .Values.security.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Elasticsearch authentication credentials secret name
*/}}
{{- define "elasticsearch.secretName" -}}
{{- default (include "common.names.fullname" .) .Values.security.existingSecret  -}}
{{- end -}}

{{/*
Return true if a TLS password secret object should be created
*/}}
{{- define "elasticsearch.createTlsPasswordsSecret" -}}
{{- if and .Values.security.enabled (not .Values.security.tls.passwordsSecret) (or .Values.security.tls.keystorePassword .Values.security.tls.truststorePassword .Values.security.tls.keyPassword ) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Elasticsearch TLS password secret name
*/}}
{{- define "elasticsearch.tlsPasswordsSecret" -}}
{{- default (printf "%s-tls-pass" (include "common.names.fullname" .)) .Values.security.tls.passwordsSecret -}}
{{- end -}}

{{/*
Returns the name of the secret key containing the Keystore password
*/}}
{{- define "elasticsearch.keystorePasswordKey" -}}
{{- if .Values.security.tls.secretKeystoreKey -}}
{{- printf "%s" .Values.security.tls.secretKeystoreKey -}}
{{- else -}}
{{- print "keystore-password"}}
{{- end -}}
{{- end -}}


{{/*
Returns the name of the secret key containing the Truststore password
*/}}
{{- define "elasticsearch.truststorePasswordKey" -}}
{{- if .Values.security.tls.secretTruststoreKey -}}
{{- printf "%s" .Values.security.tls.secretTruststoreKey -}}
{{- else -}}
{{- print "truststore-password"}}
{{- end -}}
{{- end -}}

{{/*
Returns the name of the secret key containing the PEM key password
*/}}
{{- define "elasticsearch.keyPasswordKey" -}}
{{- if .Values.security.tls.secretKey -}}
{{- printf "%s" .Values.security.tls.secretKey -}}
{{- else -}}
{{- print "key-password"}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "elasticsearch.configure.security" -}}
- name: ELASTICSEARCH_ENABLE_SECURITY
  value: "true"
- name: ELASTICSEARCH_PASSWORD
  valueFrom:
    secretKeyRef:
        name: {{ include "elasticsearch.secretName" . }}
        key: elasticsearch-password
- name: ELASTICSEARCH_ENABLE_FIPS_MODE
  value: {{ .Values.security.fipsMode | quote }}
- name: ELASTICSEARCH_TLS_VERIFICATION_MODE
  value: {{ .Values.security.tls.verificationMode | quote }}
- name: ELASTICSEARCH_ENABLE_REST_TLS
  value: {{ ternary "true" "false" .Values.security.tls.restEncryption | quote }}
{{- if or (include "elasticsearch.createTlsSecret" .) .Values.security.tls.usePemCerts }}
- name: ELASTICSEARCH_TLS_USE_PEM
  value: "true"
{{- else }}
- name: ELASTICSEARCH_KEYSTORE_LOCATION
  value: "/opt/bitnami/elasticsearch/config/certs/{{ .Values.security.tls.keystoreFilename }}"
- name: ELASTICSEARCH_TRUSTSTORE_LOCATION
  value: "/opt/bitnami/elasticsearch/config/certs/{{ .Values.security.tls.truststoreFilename }}"
{{- end }}
{{- if and (not .Values.security.tls.usePemCerts) (or .Values.security.tls.keystorePassword .Values.security.tls.passwordsSecret) }}
- name: ELASTICSEARCH_KEYSTORE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "elasticsearch.tlsPasswordsSecret" . }}
      key: {{ include "elasticsearch.keystorePasswordKey" . | quote }}
{{- end }}
{{- if and (not .Values.security.tls.usePemCerts) (or .Values.security.tls.truststorePassword .Values.security.tls.passwordsSecret) }}
- name: ELASTICSEARCH_TRUSTSTORE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "elasticsearch.tlsPasswordsSecret" . }}
      key: {{ include "elasticsearch.truststorePasswordKey" . | quote }}
{{- end }}
{{- if and .Values.security.tls.usePemCerts (or .Values.security.tls.keyPassword .Values.security.tls.passwordsSecret) }}
- name: ELASTICSEARCH_KEY_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "elasticsearch.tlsPasswordsSecret" . }}
      key: {{ include "elasticsearch.keyPasswordKey" . | quote }}
{{- end }}
{{- end -}}

{{/*
Returns true if at least 1 existing secret was provided
*/}}
{{- define "elasticsearch.security.tlsSecretsProvided" -}}
{{- $masterSecret := (and (include "elasticsearch.master.enabled" .) .Values.security.tls.master.existingSecret) -}}
{{- $coordinatingSecret := (and (include "elasticsearch.coordinating.enabled" .) .Values.security.tls.coordinating.existingSecret) -}}
{{- $dataSecret := (and (include "elasticsearch.data.enabled" .) .Values.security.tls.data.existingSecret) -}}
{{- $ingestSecret := (and (include "elasticsearch.ingest.enabled" .) .Values.security.tls.ingest.existingSecret) -}}
{{- if or $masterSecret $coordinatingSecret $dataSecret $ingestSecret }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Elasticsearch - Existing secret not provided for master nodes */}}
{{- define "elasticsearch.validateValues.security.missingTlsSecrets.master" -}}
{{- $masterSecret := (and (include "elasticsearch.master.enabled" .) (not .Values.security.tls.master.existingSecret)) -}}
{{- if and .Values.security.enabled (include "elasticsearch.security.tlsSecretsProvided" .) $masterSecret -}}
elasticsearch: security.tls.master.existingSecret
    Missing secret containing the TLS certificates for the Elasticsearch master nodes.
    Provide the certificates using --set .Values.security.tls.master.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Elasticsearch - Existing secret not provided for coordinating-only nodes */}}
{{- define "elasticsearch.validateValues.security.missingTlsSecrets.coordinating" -}}
{{- $coordinatingSecret := (and (include "elasticsearch.coordinating.enabled" .) (not .Values.security.tls.coordinating.existingSecret)) -}}
{{- if and .Values.security.enabled (include "elasticsearch.security.tlsSecretsProvided" .) $coordinatingSecret -}}
elasticsearch: security.tls.coordinating.existingSecret
    Missing secret containing the TLS certificates for the Elasticsearch coordinating-only nodes.
    Provide the certificates using --set .Values.security.tls.coordinating.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Elasticsearch - Existing secret not provided for data nodes */}}
{{- define "elasticsearch.validateValues.security.missingTlsSecrets.data" -}}
{{- $dataSecret := (and (include "elasticsearch.data.enabled" .) (not .Values.security.tls.data.existingSecret)) -}}
{{- if and .Values.security.enabled (include "elasticsearch.security.tlsSecretsProvided" .) $dataSecret -}}
elasticsearch: security.tls.data.existingSecret
    Missing secret containing the TLS certificates for the Elasticsearch data nodes.
    Provide the certificates using --set .Values.security.tls.data.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Elasticsearch - Existing secret not provided for ingest nodes */}}
{{- define "elasticsearch.validateValues.security.missingTlsSecrets.ingest" -}}
{{- $ingestSecret := (and (include "elasticsearch.ingest.enabled" .) (not .Values.security.tls.ingest.existingSecret)) -}}
{{- if and .Values.security.enabled (include "elasticsearch.security.tlsSecretsProvided" .) $ingestSecret -}}
elasticsearch: security.tls.ingest.existingSecret
    Missing secret containing the TLS certificates for the Elasticsearch ingest nodes.
    Provide the certificates using --set .Values.security.tls.ingest.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Elasticsearch - TLS enabled but no certificates provided */}}
{{- define "elasticsearch.validateValues.security.tls" -}}
{{- if and .Values.security.enabled (not .Values.security.tls.autoGenerated) (not (include "elasticsearch.security.tlsSecretsProvided" .)) -}}
elasticsearch: security.tls
    In order to enable X-Pack Security, it is necessary to configure TLS.
    Three different mechanisms can be used:
        - Provide an existing secret containing the Keystore and Truststore for each role
        - Provide an existing secret containing the PEM certificates for each role and enable `security.tls.usePemCerts=true`
        - Enable using auto-generated certificates with `security.tls.autoGenerated=true`
    Existing secrets containing either JKS/PKCS12 or PEM certificates can be provided using --set Values.security.tls.master.existingSecret=master-certs,
    --set Values.security.tls.data.existingSecret=data-certs, --set Values.security.tls.coordinating.existingSecret=coordinating-certs, --set Values.security.tls.ingest.existingSecret=ingest-certs
{{- end -}}
{{- end -}}

{{/* Validate at least Elasticsearch one master node is configured */}}
{{- define "elasticsearch.validateValues.master.replicas" -}}
{{- if not (include "elasticsearch.master.enabled" .) -}}
elasticsearch: master.replicas
    Elasticsearch needs at least one master-elegible node to form a cluster.
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "elasticsearch.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "elasticsearch.validateValues.master.replicas" .) -}}
{{- $messages := append $messages (include "elasticsearch.validateValues.security.tls" .) -}}
{{- $messages := append $messages (include "elasticsearch.validateValues.security.missingTlsSecrets.master" .) -}}
{{- $messages := append $messages (include "elasticsearch.validateValues.security.missingTlsSecrets.data" .) -}}
{{- $messages := append $messages (include "elasticsearch.validateValues.security.missingTlsSecrets.coordinating" .) -}}
{{- $messages := append $messages (include "elasticsearch.validateValues.security.missingTlsSecrets.ingest" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Sysctl set if less then
*/}}
{{- define "elasticsearch.sysctlIfLess" -}}
CURRENT=`sysctl -n {{ .key }}`;
DESIRED="{{ .value }}";
if [ "$DESIRED" -gt "$CURRENT" ]; then
    sysctl -w {{ .key }}={{ .value }};
fi;
{{- end -}}
