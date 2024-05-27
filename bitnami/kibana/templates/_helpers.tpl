{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Kibana image name
*/}}
{{- define "kibana.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "kibana.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kibana.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/*
Return true if the deployment should include dashboards
*/}}
{{- define "kibana.importSavedObjects" -}}
{{- if or .Values.savedObjects.configmap .Values.savedObjects.urls }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Set Elasticsearch URL.
*/}}
{{- define "kibana.elasticsearch.url" -}}
{{- if .Values.elasticsearch.hosts -}}
{{- $totalHosts := len .Values.elasticsearch.hosts -}}
{{- $protocol := ternary "https" "http" .Values.elasticsearch.security.tls.enabled -}}
{{- range $i, $hostTemplate := .Values.elasticsearch.hosts -}}
{{- $host := tpl $hostTemplate $ }}
{{- printf "%s://%s:%s" $protocol $host (include "kibana.elasticsearch.port" $) -}}
{{- if (lt ( add1 $i ) $totalHosts ) }}{{- printf "," -}}{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Set Elasticsearch Port.
*/}}
{{- define "kibana.elasticsearch.port" -}}
{{- include "common.tplvalues.render" (dict "value" .Values.elasticsearch.port "context" $) -}}
{{- end -}}

{{/*
Set Elasticsearch PVC.
*/}}
{{- define "kibana.pvc" -}}
{{- .Values.persistence.existingClaim | default (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "kibana.initScriptsSecret" -}}
{{- printf "%s" (tpl .Values.initScriptsSecret $) -}}
{{- end -}}

{{/*
Get the initialization scripts configmap name.
*/}}
{{- define "kibana.initScriptsCM" -}}
{{- printf "%s" (tpl .Values.initScriptsCM $) -}}
{{- end -}}

{{/*
Get the saved objects configmap name.
*/}}
{{- define "kibana.savedObjectsCM" -}}
{{- printf "%s" (tpl .Values.savedObjects.configmap $) -}}
{{- end -}}

{{/*
Set Elasticsearch Port.
*/}}
{{- define "kibana.configurationCM" -}}
{{- .Values.configurationCM | default (printf "%s-conf" (include "common.names.fullname" .)) -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "kibana.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "kibana.validateValues.noElastic" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.configConflict" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.extraVolumes" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.tls" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.elasticsearch.auth" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.elasticsearch.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - must provide an ElasticSearch */}}
{{- define "kibana.validateValues.noElastic" -}}
{{- if and (not .Values.elasticsearch.hosts) (not .Values.elasticsearch.port) -}}
kibana: no-elasticsearch
    You did not specify an external Elasticsearch instance.
    Please set elasticsearch.hosts and elasticsearch.port
{{- else if and (not .Values.elasticsearch.hosts) .Values.elasticsearch.port }}
kibana: missing-es-settings-host
    You specified the external Elasticsearch port but not the host. Please
    set elasticsearch.hosts
{{- else if and .Values.elasticsearch.hosts (not .Values.elasticsearch.port) }}
kibana: missing-es-settings-port
    You specified the external Elasticsearch hosts but not the port. Please
    set elasticsearch.port
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - configuration conflict */}}
{{- define "kibana.validateValues.configConflict" -}}
{{- if and (.Values.extraConfiguration) (.Values.configurationCM) -}}
kibana: conflict-configuration
    You specified a ConfigMap with kibana.yml and a set of settings to be added
    to the default kibana.yml. Please only set either extraConfiguration or configurationCM
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - Incorrect extra volume settings */}}
{{- define "kibana.validateValues.extraVolumes" -}}
{{- if and (.Values.extraVolumes) (not .Values.extraVolumeMounts) -}}
kibana: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them. Please set
    the extraVolumeMounts value
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - No certificates for Kibana server */}}
{{- define "kibana.validateValues.tls" -}}
{{- if and .Values.tls.enabled (not .Values.tls.existingSecret) (not .Values.tls.autoGenerated) -}}
kibana: tls.enabled
    In order to enable HTTPS for Kibana, you also need to provide an existing secret
    containing the TLS certificates (--set tls.existingSecret="my-secret") or enable
    auto-generated certificates (--set elasticsearch.security.auth.existingSecret="true").
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - No credentials for Elasticsearch auth */}}
{{- define "kibana.validateValues.elasticsearch.auth" -}}
{{- if and .Values.elasticsearch.security.auth.enabled (not .Values.elasticsearch.security.auth.kibanaPassword) (not .Values.elasticsearch.security.auth.existingSecret) -}}
kibana: missing-kibana-credentials
    You enabled Elasticsearch authentication but you didn't provide the required credentials for
    Kibana to connect. Please provide them (--set elasticsearch.security.auth.kibanaPassword="XXXXX")
    or the name of an existing secret containing them (--set elasticsearch.security.auth.existingSecret="my-secret").
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - Elasticsearch HTTPS no trusted CA */}}
{{- define "kibana.validateValues.elasticsearch.tls" -}}
{{- if and .Values.elasticsearch.security.tls.enabled (ne "none" .Values.elasticsearch.security.tls.verificationMode) (not .Values.elasticsearch.security.tls.existingSecret) -}}
kibana: missing-elasticsearch-trusted-ca
    You configured communication with Elasticsearch REST API using HTTPS and
    verification enabled but no existing secret containing the Truststore or CA
    certificate was provided (--set elasticsearch.security.tls.existingSecret="my-secret").
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "kibana.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}

{{/*
Return the secret containing Kibana TLS certificates
*/}}
{{- define "kibana.tlsSecretName" -}}
{{- $secretName := .Values.tls.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret object should be created
*/}}
{{- define "kibana.createTlsSecret" -}}
{{- if and .Values.tls.enabled .Values.tls.autoGenerated (not .Values.tls.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
basePath URL in use by the APIs.
*/}}
{{- define "kibana.basePath" -}}
{{- if  (.Values.configuration.server.rewriteBasePath) }}
{{- .Values.configuration.server.basePath -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a Passwords secret object should be created
*/}}
{{- define "kibana.createSecret" -}}
{{- $kibanaPassword := and .Values.elasticsearch.security.auth.enabled (not .Values.elasticsearch.security.auth.existingSecret) -}}
{{- $serverTlsPassword := and .Values.tls.enabled (or .Values.tls.keystorePassword .Values.tls.keyPassword) (not .Values.tls.passwordsSecret) -}}
{{- $elasticsearchTlsPassword := and .Values.elasticsearch.security.tls.enabled .Values.elasticsearch.security.tls.truststorePassword (not .Values.elasticsearch.security.tls.passwordsSecret) -}}
{{- if or $kibanaPassword $serverTlsPassword $elasticsearchTlsPassword }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of secret containing the Elasticsearch auth credentials
*/}}
{{- define "kibana.elasticsearch.auth.secretName" -}}
{{- if .Values.elasticsearch.security.auth.existingSecret -}}
  {{- printf "%s" .Values.elasticsearch.security.auth.existingSecret -}}
{{- else -}}
  {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of secret containing the Elasticsearch auth credentials
*/}}
{{- define "kibana.elasticsearch.tls.secretName" -}}
{{- if .Values.elasticsearch.security.tls.passwordsSecret -}}
  {{- printf "%s" .Values.elasticsearch.security.tls.passwordsSecret -}}
{{- else -}}
  {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of secret containing the Elasticsearch auth credentials
*/}}
{{- define "kibana.tls.secretName" -}}
{{- if .Values.tls.passwordsSecret -}}
  {{- printf "%s" .Values.tls.passwordsSecret -}}
{{- else -}}
  {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "kibana.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
