{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "flux.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.helmController.image .Values.imageAutomationController.image .Values.imageReflectorController.image .Values.kustomizeController.image .Values.notificationController.image .Values.sourceController.image .Values.volumePermissions.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Kustomize Controller fullname
*/}}
{{- define "flux.kustomize-controller.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "kustomize-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Kustomize Controller fullname (with namespace)
*/}}
{{- define "flux.kustomize-controller.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "kustomize-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Kustomize Controller image name
*/}}
{{- define "flux.kustomize-controller.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.kustomizeController.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Kustomize Controller)
*/}}
{{- define "flux.kustomize-controller.serviceAccountName" -}}
{{- if .Values.kustomizeController.serviceAccount.create -}}
    {{ default (include "flux.kustomize-controller.fullname" .) .Values.kustomizeController.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.kustomizeController.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Helm Controller fullname
*/}}
{{- define "flux.helm-controller.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "helm-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Helm Controller fullname (with namespace)
*/}}
{{- define "flux.helm-controller.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "helm-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Helm Controller image name
*/}}
{{- define "flux.helm-controller.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.helmController.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Helm Controller)
*/}}
{{- define "flux.helm-controller.serviceAccountName" -}}
{{- if .Values.helmController.serviceAccount.create -}}
    {{ default (include "flux.helm-controller.fullname" .) .Values.helmController.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.helmController.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Source Controller fullname
*/}}
{{- define "flux.source-controller.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "source-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Source Controller fullname (with namespace)
*/}}
{{- define "flux.source-controller.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "source-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Source Controller image name
*/}}
{{- define "flux.source-controller.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.sourceController.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Source Controller)
*/}}
{{- define "flux.source-controller.serviceAccountName" -}}
{{- if .Values.sourceController.serviceAccount.create -}}
    {{ default (include "flux.source-controller.fullname" .) .Values.sourceController.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.sourceController.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Notification Controller fullname
*/}}
{{- define "flux.notification-controller.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "notification-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Notification Controller fullname (with namespace)
*/}}
{{- define "flux.notification-controller.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "notification-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Notification Controller image name
*/}}
{{- define "flux.notification-controller.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.notificationController.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Notification Controller)
*/}}
{{- define "flux.notification-controller.serviceAccountName" -}}
{{- if .Values.notificationController.serviceAccount.create -}}
    {{ default (include "flux.notification-controller.fullname" .) .Values.notificationController.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.notificationController.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Image Reflector Controller fullname
(removing image- prefix to avoid name length issues)
*/}}
{{- define "flux.image-reflector-controller.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "reflector-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Image Reflector Controller fullname (with namespace)
(removing image- prefix to avoid name length issues)
*/}}
{{- define "flux.image-reflector-controller.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "reflector-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Image Reflector Controller image name
*/}}
{{- define "flux.image-reflector-controller.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.imageReflectorController.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Image Reflector Controller)
*/}}
{{- define "flux.image-reflector-controller.serviceAccountName" -}}
{{- if .Values.imageReflectorController.serviceAccount.create -}}
    {{ default (include "flux.image-reflector-controller.fullname" .) .Values.imageReflectorController.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.imageReflectorController.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Image Automation Controller fullname
(removing image- prefix to avoid name length issues)
*/}}
{{- define "flux.image-automation-controller.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "automation-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Image Automation Controller fullname (with namespace)
(removing image- prefix to avoid name length issues)
*/}}
{{- define "flux.image-automation-controller.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "automation-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Image Automation Controller image name
*/}}
{{- define "flux.image-automation-controller.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.imageAutomationController.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Image Automation Controller)
*/}}
{{- define "flux.image-automation-controller.serviceAccountName" -}}
{{- if .Values.imageAutomationController.serviceAccount.create -}}
    {{ default (include "flux.image-automation-controller.fullname" .) .Values.imageAutomationController.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.imageAutomationController.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "flux.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Validate values for flux.
*/}}
{{- define "flux.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "flux.validateValues.controllers" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the controller deployment
*/}}
{{- define "flux.validateValues.controllers" -}}
{{- if not (or .Values.kustomizeController.enabled .Values.helmController.enabled .Values.sourceController.enabled .Values.notificationController.enabled .Values.imageReflectorController.enabled .Values.imageAutomationController.enabled) -}}
flux: Missing controllers. At least one controller should be enabled.
{{- end -}}
{{- end -}}
