{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "envoy-gateway.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.ratelimitImage .Values.envoyImage) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Envoy Gateway image name
*/}}
{{- define "envoy-gateway.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Rate Limit image name
*/}}
{{- define "envoy-gateway.ratelimit.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.ratelimitImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Envoy image name
*/}}
{{- define "envoy-gateway.envoy.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.envoyImage "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use (envoy-gateway)
*/}}
{{- define "envoy-gateway.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{- default (include "envoy-gateway.certgen.fullname" .) .Values.certgen.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.certgen.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Certificate Generation init-job fullname
*/}}
{{- define "envoy-gateway.certgen.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "certgen" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use (Certificate Generation init-job)
*/}}
{{- define "envoy-gateway.certgen.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{- default (include "common.names.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Get the certificates secret.
*/}}
{{- define "envoy-gateway.certsSecret" -}}
{{- if .Values.existingTLSSecret -}}
    {{- tpl .Values.existingTLSSecret $ -}}
{{- else }}
    {{- /* Hardcoded in the operator code: https://github.com/envoyproxy/gateway/blob/main/internal/provider/kubernetes/secrets.go#L52 */ -}}
    {{- print "envoy-gateway" -}}
{{- end -}}
{{- end -}}

{{/*
Get the configuration configmap.
*/}}
{{- define "envoy-gateway.configMapName" -}}
{{- if .Values.existingConfigMap -}}
    {{- tpl .Values.existingConfigMap $ -}}
{{- else }}
    {{- include "common.names.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Validate values for envoy-gateway.
*/}}
{{- define "envoy-gateway.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "envoy-gateway.validateValues.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the tls settings
*/}}
{{- define "envoy-gateway.validateValues.tls" -}}
{{- if and .Values.existingTLSSecret .Values.certgen.enabled -}}
envoy-gateway: Cannot set existing tls secret if the certificate generation job is enabled. Please set certgen.enabled=true or existingTLSSecret, but not both
{{- end -}}
{{- end -}}