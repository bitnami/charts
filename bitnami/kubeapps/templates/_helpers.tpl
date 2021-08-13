{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kubeapps.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.frontend.image .Values.dashboard.image .Values.apprepository.image .Values.apprepository.syncImage .Values.assetsvc.image .Values.kubeops.image .Values.authProxy.image .Values.pinnipedProxy.image .Values.testImage) "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified app name for PostgreSQL dependency.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kubeapps.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for the apprepository-controller based on the fullname
*/}}
{{- define "kubeapps.apprepository.fullname" -}}
{{- printf "%s-internal-apprepository-controller" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for the assetsvc based on the fullname
*/}}
{{- define "kubeapps.assetsvc.fullname" -}}
{{- printf "%s-internal-assetsvc" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for the dashboard based on the fullname
*/}}
{{- define "kubeapps.dashboard.fullname" -}}
{{- printf "%s-internal-dashboard" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for the dashboard config based on the fullname
*/}}
{{- define "kubeapps.dashboard-config.fullname" -}}
{{- printf "%s-internal-dashboard-config" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for the frontend config based on the fullname
*/}}
{{- define "kubeapps.frontend-config.fullname" -}}
{{- printf "%s-frontend-config" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for kubeops based on the fullname
*/}}
{{- define "kubeapps.kubeops.fullname" -}}
{{- printf "%s-internal-kubeops" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for the clusters config based on the fullname
*/}}
{{- define "kubeapps.clusters-config.fullname" -}}
{{- printf "%s-clusters-config" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create proxy_pass for the frontend config
*/}}
{{- define "kubeapps.frontend-config.proxy_pass" -}}
http://{{ include "kubeapps.kubeops.fullname" . }}:{{ .Values.kubeops.service.port }}
{{- end -}}

{{/*
Create name for the secrets related to oauth2_proxy
*/}}
{{- define "kubeapps.oauth2_proxy-secret.name" -}}
{{- printf "%s-oauth2" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for pinniped-proxy based on the fullname.
Currently used for a service name only.
*/}}
{{- define "kubeapps.pinniped-proxy.fullname" -}}
{{- printf "%s-internal-pinniped-proxy" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Repositories that include a caCert or an authorizationHeader
*/}}
{{- define "kubeapps.repos-with-orphan-secrets" -}}
{{- range .Values.apprepository.initialRepos }}
{{- if or .caCert .authorizationHeader }}
.name
{{- end }}
{{- end }}
{{- end -}}

{{/*
Frontend service port number
*/}}
{{- define "kubeapps.frontend-port-number" -}}
{{- if .Values.authProxy.enabled -}}
{{ .Values.authProxy.containerPort | int }}
{{- else -}}
{{ .Values.frontend.containerPort | int }}
{{- end -}}
{{- end -}}

{{/*
Returns the kubeappsCluster based on the configured clusters by finding the cluster without
a defined apiServiceURL.
*/}}
{{- define "kubeapps.kubeappsCluster" -}}
    {{- $kubeappsCluster := "" }}
    {{- if eq (len .Values.clusters) 0 }}
        {{- fail "At least one cluster must be defined." }}
    {{- end }}
    {{- range .Values.clusters }}
        {{- if or .isKubeappsCluster ( eq (.apiServiceURL | toString) "<nil>") }}
            {{- if eq $kubeappsCluster "" }}
                {{- $kubeappsCluster = .name }}
            {{- else }}
                {{- fail "Only one cluster can be configured using either 'isKubeappsCluster: true' or without an apiServiceURL to refer to the cluster on which Kubeapps is installed. Please check the provided 'clusters' configuration." }}
            {{- end }}
        {{- end }}
    {{- end }}
    {{- $kubeappsCluster }}
{{- end -}}

{{/*
Returns a JSON list of cluster names only (without sensitive tokens etc.)
*/}}
{{- define "kubeapps.clusterNames" -}}
    {{- $sanitizedClusters := list }}
    {{- range .Values.clusters }}
    {{- $sanitizedClusters = append $sanitizedClusters .name }}
    {{- end }}
    {{- $sanitizedClusters | toJson }}
{{- end -}}

{{/*
Return the Postgresql secret name
*/}}
{{- define "kubeapps.postgresql.secretName" -}}
  {{- if .Values.postgresql.existingSecret }}
      {{- printf "%s" .Values.postgresql.existingSecret -}}
  {{- else -}}
      {{- printf "%s" (include "kubeapps.postgresql.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "kubeapps.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "kubeapps.validateValues.ingress.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Kubeapps - TLS configuration for Ingress
*/}}
{{- define "kubeapps.validateValues.ingress.tls" -}}
{{- if and .Values.ingress.enabled .Values.ingress.tls (not .Values.ingress.certManager) (not .Values.ingress.selfSigned) (empty .Values.ingress.extraTls) }}
kubeapps: ingress.tls
    You enabled the TLS configuration for the default ingress hostname but
    you did not enable any of the available mechanisms to create the TLS secret
    to be used by the Ingress Controller.
    Please use any of these alternatives:
      - Use the `ingress.extraTls` and `ingress.secrets` parameters to provide your custom TLS certificates.
      - Relay on cert-manager to create it by setting `ingress.certManager=true`
      - Relay on Helm to create self-signed certificates by setting `ingress.selfSigned=true`
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "kubeapps.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.frontend.image }}
{{- include "common.warnings.rollingTag" .Values.dashboard.image }}
{{- include "common.warnings.rollingTag" .Values.apprepository.image }}
{{- include "common.warnings.rollingTag" .Values.assetsvc.image }}
{{- include "common.warnings.rollingTag" .Values.kubeops.image }}
{{- include "common.warnings.rollingTag" .Values.authProxy.image }}
{{- include "common.warnings.rollingTag" .Values.pinnipedProxy.image }}
{{- end -}}
