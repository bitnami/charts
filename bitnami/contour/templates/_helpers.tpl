{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the envoy service account to use
*/}}
{{- define "envoy.envoyServiceAccountName" -}}
{{- if .Values.contour.serviceAccount.create -}}
    {{ default (printf "%s-envoy" (include "common.names.fullname" .)) .Values.envoy.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.envoy.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the contour service account to use
*/}}
{{- define "contour.contourServiceAccountName" -}}
{{- if .Values.contour.serviceAccount.create -}}
    {{ default (printf "%s-contour" (include "common.names.fullname" .)) .Values.contour.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.contour.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the contour-certgen service account to use
*/}}
{{- define "contour.contourCertGenServiceAccountName" -}}
{{- if .Values.contour.certgen.serviceAccount.create -}}
    {{ default (printf "%s-contour-certgen" (include "common.names.fullname" .)) .Values.contour.certgen.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.contour.certgen.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Whether to enabled contour-certgen or not
*/}}
{{- define "contour.contour-certgen.enabled" -}}
{{- if and (not .Values.tlsExistingSecret) (or (not .Values.contour.tlsExistingSecret) (not .Values.envoy.tlsExistingSecret))  -}}
    true
{{- else -}}{{- end -}}
{{- end -}}

{{/*
Contour certs secret name
*/}}
{{- define "contour.contour.certs-secret.name" -}}
{{- $existingSecret := default .Values.tlsExistingSecret .Values.contour.tlsExistingSecret -}}
{{- $name := default "contourcert" $existingSecret -}}
{{- printf "%s" $name -}}
{{- end -}}

{{/*
Envoy certs secret name
*/}}
{{- define "contour.envoy.certs-secret.name" -}}
{{- $existingSecret := default .Values.tlsExistingSecret .Values.envoy.tlsExistingSecret -}}
{{- $name := default "envoycert" $existingSecret -}}
{{- printf "%s" $name -}}
{{- end -}}

{{/*
Create the name of the settings ConfigMap to use.
*/}}
{{- define "contour.configMapName" -}}
{{- if .Values.configInline -}}
    {{ include "common.names.fullname" . }}
{{- else -}}
    {{ .Values.existingConfigMap }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "contour.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "contour.validateValues.envoy.kind" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Contour - must provide a valid Envoy kind */}}
{{- define "contour.validateValues.envoy.kind" -}}
{{- if and .Values.envoy.enabled (ne .Values.envoy.kind "deployment") (ne .Values.envoy.kind "daemonset") -}}
contour: envoy.kind
    Invalid envoy.kind selected. Valid values are "daemonset" and
    "deployment". Please set a valid kind (--set envoy.kind="xxxx")
{{- end -}}
{{- end -}}

{{/* Create the name of the IngressClass to use. */}}
{{- define "contour.ingressClassName" -}}
{{- $ingressClass := .Values.contour.ingressClass }}
{{- if kindIs "string" $ingressClass -}}
    {{ default "contour" $ingressClass }}
{{- else if kindIs "map" $ingressClass -}}
    {{ default "contour" $ingressClass.name }}
{{- else -}}
    contour
{{- end -}}
{{- end -}}

{{/* Whether the name of the ingress class is defined or not */}}
{{- define "contour.isIngressClassNameDefined" -}}
{{- $ingressClass := .Values.contour.ingressClass -}}
{{- if kindIs "string" $ingressClass -}}
    true
{{- else if and (kindIs "map" $ingressClass) ($ingressClass.name) -}}
    true
{{- end -}}
{{- end -}}
