{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kuberay.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.operator.image .Values.apiserver.image .Values.rayImage ) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Kuberay Operator fullname
*/}}
{{- define "kuberay.operator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "operator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Kuberay Operator fullname (with namespace)
*/}}
{{- define "kuberay.operator.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "operator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Kuberay Operator image name
*/}}
{{- define "kuberay.operator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.operator.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Kuberay Operator)
*/}}
{{- define "kuberay.operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create -}}
    {{ default (include "kuberay.operator.fullname" .) .Values.operator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.operator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Kuberay Kubernetes API Server fullname
*/}}
{{- define "kuberay.apiserver.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "apiserver" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Kuberay Kubernetes API Server fullname (with namespace)
(removing image- prefix to avoid name length issues)
*/}}
{{- define "kuberay.apiserver.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "apiserver" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Kuberay Kubernetes API Server image name
*/}}
{{- define "kuberay.apiserver.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.apiserver.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (Kuberay API Server)
*/}}
{{- define "kuberay.apiserver.serviceAccountName" -}}
{{- if .Values.apiserver.serviceAccount.create -}}
    {{ default (include "kuberay.apiserver.fullname" .) .Values.apiserver.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.apiserver.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Kuberay Kubernetes API Server image name
*/}}
{{- define "kuberay.ray.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.rayImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Ray Cluster fullname
*/}}
{{- define "kuberay.cluster.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "cluster" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use (Kuberay Operator)
*/}}
{{- define "kuberay.cluster.serviceAccountName" -}}
{{- if .Values.cluster.serviceAccount.create -}}
    {{ default (include "kuberay.cluster.fullname" .) .Values.cluster.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.cluster.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Validate values for Kuberay.
*/}}
{{- define "kuberay.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "kuberay.validateValues.controllers" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the controller deployment
*/}}
{{- define "kuberay.validateValues.controllers" -}}
{{- if not (or .Values.operator.enabled .Values.apiserver.enabled) -}}
kuberay: Missing controllers. At least one controller should be enabled.
{{- end -}}
{{- end -}}
