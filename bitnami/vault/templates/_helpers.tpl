{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "vault.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.server.image .Values.csiProvider.image .Values.injector.image .Values.volumePermissions.image ) "context" $) -}}
{{- end -}}

{{/*
Return the proper Vault Server fullname
*/}}
{{- define "vault.server.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Vault Server fullname (with namespace)
*/}}
{{- define "vault.server.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Vault Server image name
*/}}
{{- define "vault.server.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.server.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Vault Server)
*/}}
{{- define "vault.server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create -}}
    {{ default (include "vault.server.fullname" .) .Values.server.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.server.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Name of the server ConfigMap
*/}}
{{- define "vault.server.configmapName" -}}
{{- if .Values.server.existingConfigMap -}}
    {{ include "common.tplvalues.render" (dict "value" .Values.server.existingConfigMap "context" $) }}
{{- else -}}
    {{ include "vault.server.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Vault Kubernetes Injector fullname
*/}}
{{- define "vault.injector.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "injector" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Vault Kubernetes Injector fullname (with namespace)
(removing image- prefix to avoid name length issues)
*/}}
{{- define "vault.injector.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "injector" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Vault Kubernetes Injector image name
*/}}
{{- define "vault.injector.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.injector.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Vault Kubernetes Injector)
*/}}
{{- define "vault.injector.serviceAccountName" -}}
{{- if .Values.injector.serviceAccount.create -}}
    {{ default (include "vault.injector.fullname" .) .Values.injector.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.injector.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Vault CSI Provider fullname
*/}}
{{- define "vault.csi-provider.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "csi-provider" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Vault CSI Provider fullname (with namespace)
*/}}
{{- define "vault.csi-provider.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "csi-provider" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Vault CSI Provider image name
*/}}
{{- define "vault.csi-provider.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.csiProvider.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Vault CSI Provider)
*/}}
{{- define "vault.csi-provider.serviceAccountName" -}}
{{- if .Values.csiProvider.serviceAccount.create -}}
    {{ default (include "vault.csi-provider.fullname" .) .Values.csiProvider.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.csiProvider.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Name of the server ConfigMap
*/}}
{{- define "vault.csi-provider.configmapName" -}}
{{- if .Values.csiProvider.existingConfigMap -}}
    {{ include "common.tplvalues.render" (dict "value" .Values.csiProvider.existingConfigMap "context" $) }}
{{- else -}}
    {{ include "vault.server.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "vault.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Validate values for Vault.
*/}}
{{- define "vault.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "vault.validateValues.controllers" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the controller deployment
*/}}
{{- define "vault.validateValues.controllers" -}}
{{- if not (or .Values.server.enabled .Values.csiProvider.enabled .Values.injector.enabled) -}}
vault: Missing controllers. At least one controller should be enabled.
{{- end -}}
{{- end -}}
