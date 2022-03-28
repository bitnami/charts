{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper ES image name
*/}}
{{- define "elasticsearch.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}


{{/*
Create a default fully qualified master name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.master.fullname" -}}
{{- if .Values.master.fullnameOverride -}}
{{- .Values.master.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.master.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified ingest name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.ingest.fullname" -}}
{{- if .Values.ingest.fullnameOverride -}}
{{- .Values.ingest.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.ingest.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified coordinating name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.coordinating.fullname" -}}
{{- if .Values.global.kibanaEnabled -}}
{{- printf "%s-%s" .Release.Name .Values.global.coordinating.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if .Values.coordinating -}}
{{- if .Values.coordinating.fullnameOverride -}}
{{- .Values.coordinating.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.global.coordinating.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the hostname of every ElasticSearch seed node
*/}}
{{- define "elasticsearch.hosts" -}}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $releaseNamespace := .Release.Namespace }}
{{- if gt (.Values.master.replicas | int) 0 }}
{{- $masterFullname := include "elasticsearch.master.fullname" . }}
{{- $masterFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- if gt (.Values.coordinating.replicas | int) 0 }}
{{- $coordinatingFullname := include "elasticsearch.coordinating.fullname" . }}
{{- $coordinatingFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- if gt (.Values.data.replicas | int) 0 }}
{{- $dataFullname := include "elasticsearch.data.fullname" . }}
{{- $dataFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- if and (eq .Values.ingest.enabled true) (gt (.Values.ingest.replicas | int) 0) }}
{{- $ingestFullname := include "elasticsearch.ingest.fullname" . }}
{{- $ingestFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified data name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.data.fullname" -}}
{{- if .Values.data.fullnameOverride -}}
{{- .Values.data.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.data.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{ template "elasticsearch.initScriptsSecret" . }}
{{/*
Get the initialization scripts volume name.
*/}}
{{- define "elasticsearch.initScripts" -}}
{{- printf "%s-init-scripts" (include "common.names.fullname" .) -}}
{{- end -}}

{{ template "elasticsearch.initScriptsCM" . }}
{{/*
Get the initialization scripts ConfigMap name.
*/}}
{{- define "elasticsearch.initScriptsCM" -}}
{{- printf "%s" .Values.initScriptsCM -}}
{{- end -}}

{{ template "elasticsearch.initScriptsSecret" . }}
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
Create a default fully qualified metrics name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.metrics.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.metrics.name | trunc 63 | trimSuffix "-" -}}
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
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "elasticsearch.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.curator.image .Values.sysctlImage .Values.volumePermissions.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "elasticsearch.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Storage Class
Usage:
{{ include "elasticsearch.storageClass" (dict "global" .Values.global "local" .Values.master) }}
*/}}
{{- define "elasticsearch.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .global -}}
    {{- if .global.storageClass -}}
        {{- if (eq "-" .global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .local.persistence.storageClass -}}
              {{- if (eq "-" .local.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .local.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .local.persistence.storageClass -}}
        {{- if (eq "-" .local.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .local.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for cronjob APIs.
*/}}
{{- define "cronjob.apiVersion" -}}
{{- if semverCompare "< 1.8-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "batch/v2alpha1" }}
{{- else if and (semverCompare ">=1.8-0" .Capabilities.KubeVersion.GitVersion) (semverCompare "< 1.21-0" .Capabilities.KubeVersion.GitVersion) -}}
{{- print "batch/v1beta1" }}
{{- else if semverCompare ">=1.21-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "batch/v1" }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "elasticsearch.curator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.curator.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "elasticsearch.curator.serviceAccountName" -}}
{{- if .Values.curator.serviceAccount.create -}}
    {{ default (include "elasticsearch.curator.fullname" .) .Values.curator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.curator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper ES curator image name
*/}}
{{- define "elasticsearch.curator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.curator.image "global" .Values.global) }}
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
{{- coalesce .Values.security.existingSecret (include "common.names.fullname" .) -}}
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
{{- coalesce .Values.security.tls.passwordsSecret (printf "%s-tls-pass" (include "common.names.fullname" .)) -}}
{{- end -}}

{{/*
Return the name of the http port. Whether or not security is enabeld: http or https
*/}}
{{- define "elasticsearch.httpPortName" -}}
{{- if .Values.security.enabled }}
    {{- "https" -}}
{{- else -}}
    {{- "http" -}}
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
      key: keystore-password
{{- end }}
{{- if and (not .Values.security.tls.usePemCerts) (or .Values.security.tls.truststorePassword .Values.security.tls.passwordsSecret) }}
- name: ELASTICSEARCH_TRUSTSTORE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "elasticsearch.tlsPasswordsSecret" . }}
      key: truststore-password
{{- end }}
{{- if and .Values.security.tls.usePemCerts (or .Values.security.tls.keyPassword .Values.security.tls.passwordsSecret) }}
- name: ELASTICSEARCH_KEY_PASSWORD
  value: {{ .Values.security.tls.keyPassword | quote }}
{{- end }}
{{- end -}}

{{/*
Returns true if at least 1 existing secret was provided
*/}}
{{- define "elasticsearch.security.tlsSecretsProvided" -}}
{{- $masterSecret :=.Values.security.tls.master.existingSecret -}}
{{- $dataSecret :=.Values.security.tls.data.existingSecret -}}
{{- $coordSecret :=.Values.security.tls.coordinating.existingSecret -}}
{{- $ingestSecret :=.Values.security.tls.ingest.existingSecret -}}
{{- $ingestEnabled := .Values.ingest.enabled -}}
{{- if or $masterSecret $dataSecret $coordSecret (and $ingestEnabled $ingestSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Elasticsearch - Existing secret not provided for master nodes */}}
{{- define "elasticsearch.validateValues.security.missingTlsSecrets.master" -}}
{{- if and .Values.security.enabled (include "elasticsearch.security.tlsSecretsProvided" .) (not .Values.security.tls.master.existingSecret) -}}
elasticsearch: security.tls.master.existingSecret
    Missing secret containing the TLS certificates for the Elasticsearch master nodes.
    Provide the certificates using --set .Values.security.tls.master.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Elasticsearch - Existing secret not provided for data nodes */}}
{{- define "elasticsearch.validateValues.security.missingTlsSecrets.data" -}}
{{- if and .Values.security.enabled (include "elasticsearch.security.tlsSecretsProvided" .) (not .Values.security.tls.data.existingSecret) -}}
elasticsearch: security.tls.data.existingSecret
    Missing secret containing the TLS certificates for the Elasticsearch data nodes.
    Provide the certificates using --set .Values.security.tls.data.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Elasticsearch - Existing secret not provided for coordinating-only nodes */}}
{{- define "elasticsearch.validateValues.security.missingTlsSecrets.coordinating" -}}
{{- if and .Values.security.enabled (include "elasticsearch.security.tlsSecretsProvided" .) (not .Values.security.tls.coordinating.existingSecret) -}}
elasticsearch: security.tls.coordinating.existingSecret
    Missing secret containing the TLS certificates for the Elasticsearch coordinating-only nodes.
    Provide the certificates using --set .Values.security.tls.coordinating.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Elasticsearch - Existing secret not provided for ingest nodes */}}
{{- define "elasticsearch.validateValues.security.missingTlsSecrets.ingest" -}}
{{- if and .Values.security.enabled .Values.ingest.enabled (include "elasticsearch.security.tlsSecretsProvided" .) (not .Values.security.tls.ingest.existingSecret) -}}
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

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "elasticsearch.validateValues" -}}
{{- $messages := list -}}
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
