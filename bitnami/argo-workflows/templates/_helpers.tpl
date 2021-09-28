{{/*
Return the proper server image name
*/}}
{{- define "argo-workflows.server.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.server.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper controller image name
*/}}
{{- define "argo-workflows.controller.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper service name for Argo Workflows server
*/}}
{{- define "argo-workflows.server.fullname" -}}
  {{- printf "%s-server" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Return the proper service name for Argo Workflows controller
*/}}
{{- define "argo-workflows.controller.fullname" -}}
  {{- printf "%s-controller" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "argo-workflows.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified mysql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "argo-workflows.mysql.fullname" -}}
{{- $name := default "mysql" .Values.mysql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mysql" "chartValues" .Values.mysql "context" $) -}}
{{- end -}}

{{/*
Create the name of the server service account to use
*/}}
{{- define "argo-workflows.server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create -}}
    {{ default (printf "%s-server" (include "common.names.fullname" .)) .Values.server.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.server.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the controller service account to use
*/}}
{{- define "argo-workflows.controller.serviceAccountName" -}}
{{- if .Values.controller.serviceAccount.create -}}
    {{ default (printf "%s-controller" (include "common.names.fullname" .)) .Values.controller.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.controller.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the workflows service account to use
*/}}
{{- define "argo-workflows.workflows.serviceAccountName" -}}
{{- if .Values.workflows.serviceAccount.create -}}
    {{ default (printf "%s-workflows" (include "common.names.fullname" .)) .Values.workflows.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.workflows.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "argo-workflows.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.server.image .Values.controller.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper configmap for the controller
*/}}
{{- define "argo-workflows.controller.configMapName" -}}
{{- if .Values.controller.existingConfigMap }}
{{- .Values.controller.existingConfigMap -}}
{{- else -}}
{{- include "argo-workflows.controller.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Validate instanceID configuration
*/}}
{{- define "argo-workflows.validateValues.instanceID" -}}
{{- if .Values.controller.instanceID.enabled -}}
{{- if not (or .Values.controller.instanceID.explicitID .Values.controller.instanceID.useReleaseName) -}}
{{- printf "Error: controller.instanceID.useReleaseName or controller.instanceID.explicitID is required when enabling instanceID" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate artifact repository configuration
*/}}
{{- define "argo-workflows.validateValues.artifactRepository" -}}
{{- if .Values.controller.artifactRepository.enabled -}}
{{- if not .Values.controller.artifactRepository.configuration -}}
{{- printf "Error: controller.artifactRepository.configuration is required when enabling controller.artifactRepository.enabled" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "argo-workflows.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "argo-workflows.validateValues.instanceID" .) -}}
{{- $messages := append $messages (include "argo-workflows.validateValues.artifactRepository" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}
