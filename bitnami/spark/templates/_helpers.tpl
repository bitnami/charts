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
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{- /*
As we use a headless service we need to append -master-svc to
the service name.
*/ -}}
{{- define "spark.master.service.name" -}}
{{ include "common.names.fullname" . }}-master-svc
{{- end -}}

{{/* Get the secret for passwords */}}
{{- define "spark.passwordsSecretName" -}}
{{- if .Values.security.passwordsSecretName -}}
  {{- printf "%s" .Values.security.passwordsSecretName -}}
{{- else }}
  {{- printf "%s-secret" (include "common.names.fullname" .) -}}
{{- end }}
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

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "spark.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "spark.validateValues.extraVolumes" .) -}}
{{- $messages := append $messages (include "spark.validateValues.workerCount" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
