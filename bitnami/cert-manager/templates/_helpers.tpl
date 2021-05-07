{{/*
Return the proper certmanager.image name
*/}}
{{- define "certmanager.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper certmanager.image name
*/}}
{{- define "certmanager.acmesolver.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.acmesolver.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "certmanager.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "certmanager.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.controller.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "certmanager.controller.fullname" -}}
{{- printf "%s-controller" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either common.names.fullname if controller.serviceAccount.create
is true or default otherwise.
*/}}
{{- define "certmanager.controller.serviceAccountName" -}}
    {{- if .Values.controller.serviceAccount.create -}}
        {{- if (empty .Values.controller.serviceAccount.name) -}}
          {{- printf "%s-controller" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
        {{- else -}}
          {{ default "default" .Values.controller.serviceAccount.name }}
        {{- end -}}
    {{- else -}}
        {{ default "default" .Values.controller.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper certmanager.webhook image name
*/}}
{{- define "certmanager.webhook.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.webhook.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "certmanager.webhook.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.webhook.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "certmanager.webhook.fullname" -}}
{{- printf "%s-webhook" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either common.names.fullname if webhook.serviceAccount.create
is true or default otherwise.
*/}}
{{- define "certmanager.webhook.serviceAccountName" -}}
    {{- if .Values.webhook.serviceAccount.create -}}
        {{- if (empty .Values.webhook.serviceAccount.name) -}}
          {{- printf "%s-webhook" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
        {{- else -}}
          {{ default "default" .Values.webhook.serviceAccount.name }}
        {{- end -}}
    {{- else -}}
        {{ default "default" .Values.webhook.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper cainjector image name
*/}}
{{- define "certmanager.cainjector.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cainjector.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "certmanager.cainjector.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.cainjector.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "certmanager.cainjector.fullname" -}}
{{- printf "%s-cainjector" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either common.names.fullname if webhook.serviceAccount.create
is true or default otherwise.
*/}}
{{- define "certmanager.cainjector.serviceAccountName" -}}
    {{- if .Values.cainjector.serviceAccount.create -}}
        {{- if (empty .Values.cainjector.serviceAccount.name) -}}
          {{- printf "%s-cainjector" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
        {{- else -}}
          {{ default "default" .Values.cainjector.serviceAccount.name }}
        {{- end -}}
    {{- else -}}
        {{ default "default" .Values.cainjector.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{- define "certmanager.webhook.caRef" -}}
{{ .Release.Namespace }}/{{ template "certmanager.webhook.fullname" . }}-ca
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "certmanager.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "certmanager.validateValues.setCRD" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Cert Manager - CRD */}}
{{- define "certmanager.validateValues.setCRD" -}}
{{- if not .Values.installCRDs -}}
cert-manager: CRDs
    You will use cert manager without installing CRDs.
    If you want to include our CRD resources, please install the cert manager using the crd flags (--set .Values.installCRDs=true).
{{- end -}}
{{- end -}}

