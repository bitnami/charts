{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Sealed Secrets image name
*/}}
{{- define "sealed-secrets.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "sealed-secrets.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "sealed-secrets.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the unsealer cluster role
*/}}
{{- define "sealed-secrets.clusterRoleName" -}}
{{- if .Values.rbac.clusterRoleName -}}
    {{ printf "%s" .Values.rbac.clusterRoleName }}
{{- else -}}
    {{ printf "%s-unsealer" (include "common.names.fullname" .) }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the unsealer namespaced cluster role
*/}}
{{- define "sealed-secrets.namespacedRoleName" -}}
{{- if .Values.rbac.namespacedRolesName -}}
    {{ printf "%s" .Values.rbac.namespacedRolesName }}
{{- else -}}
    {{ printf "%s-unsealer" (include "common.names.fullname" .) | quote }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the secret that hold keys
*/}}
{{- define "sealed-secrets.secretName" -}}
{{- if .Values.secretName -}}
    {{ printf "%s" .Values.secretName }}
{{- else -}}
    {{ printf "%s-key" (include "common.names.fullname" .) | quote }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for PodSecurityPolicy.
*/}}
{{- define "podSecurityPolicy.apiVersion" -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "policy/v1beta1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}
