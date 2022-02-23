{{/*
Return the proper service name for a subcomponent
Usage:
{{ include "subcomponent.service.name" ( dict "componentName" "name" "context" $ ) }}
*/}}
{{- define "subcomponent.service.name" -}}
{{- printf "%s-%s" .context.Release.Name .componentName | trunc 63 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dataplatform.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Define the name of the dataplatform exporter
*/}}
{{- define "dataplatform.exporter-name" -}}
{{- printf "%s-%s" (include "dataplatform.fullname" .) "exporter" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the dataplatform emitter
*/}}
{{- define "dataplatform.emitter-name" -}}
{{- printf "%s-%s" (include "dataplatform.fullname" .) "emitter" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "dataplatform.serviceAccountName" -}}
{{- if .Values.dataplatform.serviceAccount.create -}}
    {{- default (include "dataplatform.fullname" .) .Values.dataplatform.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.dataplatform.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper dataplatform-exporter image name
*/}}
{{- define "dataplatform.exporter.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.dataplatform.exporter.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "dataplatform.exporter.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.dataplatform.exporter.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper dataplatform-emitter image name
*/}}
{{- define "dataplatform.emitter.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.dataplatform.emitter.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "dataplatform.emitter.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.dataplatform.emitter.image ) "global" .Values.global) -}}
{{- end -}}