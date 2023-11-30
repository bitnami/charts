{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{- /* vim: set filetype=mustache: */}}

{{/*
Return the proper Spark image name
*/}}
{{- define "spark.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "spark.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "spark.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/* Get the secret for passwords */}}
{{- define "spark.passwordsSecretName" -}}
{{- if .Values.security.passwordsSecretName -}}
  {{- printf "%s" .Values.security.passwordsSecretName -}}
{{- else }}
  {{- printf "%s-secret" (include "common.names.fullname" .) -}}
{{- end }}
{{- end -}}

{{/*
Return the secret containing Spark TLS certificates
*/}}
{{- define "spark.tlsSecretName" -}}
{{- $secretName := coalesce .Values.security.ssl.existingSecret .Values.security.certificatesSecretName -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret object should be created
*/}}
{{- define "spark.createTlsSecret" -}}
{{- if and .Values.security.ssl.autoGenerated .Values.security.ssl.enabled (not .Values.security.ssl.existingSecret) (not .Values.security.certificatesSecretName) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "spark.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image -}}
{{- end -}}

{{/* Validate values of Spark - Incorrect extra volume settings */}}
{{- define "spark.validateValues.extraVolumes" -}}
{{- if and (.Values.worker.extraVolumes) (not .Values.worker.extraVolumeMounts) -}}
spark: missing-worker-extra-volume-mounts
    You specified worker extra volumes but no mount points for them. Please set
    the extraVolumeMounts value
{{- end -}}
{{- end -}}

{/* Validate values of Spark - number of workers must be greater than 0 */}}
{{- define "spark.validateValues.workerCount" -}}
{{- $replicaCount := int .Values.worker.replicaCount }}
{{- if lt $replicaCount 1 -}}
spark: workerCount
    Worker replicas must be greater than 0!!
    Please set a valid worker count size (--set worker.replicaCount=X)
{{- end -}}
{{- end -}}

{{/* Validate values of Spark - Security SSL enabled */}}
{{- define "spark.validateValues.security.ssl" -}}
{{- if and .Values.security.ssl.enabled (not .Values.security.ssl.autoGenerated) (not .Values.security.ssl.existingSecret) (not .Values.security.certificatesSecretName) }}
spark: security.ssl.enabled
    In order to enable Security SSL, you also need to provide
    an existing secret containing the Keystore and Truststore or
    enable auto-generated certificates.
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "spark.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "spark.validateValues.extraVolumes" .) -}}
{{- $messages := append $messages (include "spark.validateValues.workerCount" .) -}}
{{- $messages := append $messages (include "spark.validateValues.security.ssl" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Get the initialization scripts volume name.
*/}}
{{- define "spark.initScripts" -}}
{{- printf "%s-init-scripts" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Get the initialization scripts ConfigMap name.
*/}}
{{- define "spark.initScriptsCM" -}}
{{- printf "%s" .Values.initScriptsCM -}}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "spark.initScriptsSecret" -}}
{{- printf "%s" .Values.initScriptsSecret -}}
{{- end -}}
