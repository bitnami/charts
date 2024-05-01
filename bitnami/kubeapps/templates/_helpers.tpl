{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kubeapps.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.frontend.image .Values.dashboard.image .Values.apprepository.image .Values.apprepository.syncImage .Values.authProxy.image .Values.pinnipedProxy.image .Values.kubeappsapis.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Kubeapps apprepository-controller image name
*/}}
{{- define "kubeapps.apprepository.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.apprepository.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper apprepository-controller sync image name
*/}}
{{- define "kubeapps.apprepository.syncImage" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.apprepository.syncImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper dashboard image name
*/}}
{{- define "kubeapps.dashboard.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.dashboard.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper frontend image name
*/}}
{{- define "kubeapps.frontend.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.frontend.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper auth proxy image name
*/}}
{{- define "kubeapps.authProxy.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.authProxy.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper pinniped proxy image name
*/}}
{{- define "kubeapps.pinnipedProxy.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.pinnipedProxy.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper kubeappsapis image name
*/}}
{{- define "kubeapps.kubeappsapis.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.kubeappsapis.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper oci-catalog image name
*/}}
{{- define "kubeapps.ociCatalog.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.ociCatalog.image "global" .Values.global) -}}
{{- end -}}

{{/*
Create a default fully qualified app name for PostgreSQL dependency.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kubeapps.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the Postgresql Hostname
*/}}
{{- define "kubeapps.postgresql.host" -}}
{{- if .Values.postgresql.enabled }}
  {{- if eq .Values.postgresql.architecture "replication" }}
      {{- printf "%s-primary" (include "kubeapps.postgresql.fullname" .) | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
      {{- printf "%s" (include "kubeapps.postgresql.fullname" .) -}}
  {{- end -}}
{{- else -}}
  {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql Port
*/}}
{{- define "kubeapps.postgresql.port" -}}
{{- if .Values.postgresql.enabled }}
    {{- print "5432" -}}
{{- else -}}
    {{- printf "%d" (int .Values.externalDatabase.port) -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for Redis dependency.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kubeapps.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{/*
Create name for the apprepository-controller based on the fullname
*/}}
{{- define "kubeapps.apprepository.fullname" -}}
{{- printf "%s-internal-apprepository-controller" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for the apprepository-controller based on the namespace
*/}}
{{- define "kubeapps.apprepository.fullname.namespace" -}}
{{- printf "%s-internal-apprepository-controller" (include "common.names.fullname.namespace" .) | trunc 63 | trimSuffix "-" -}}
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
Create name for kubeappsapis based on the fullname
*/}}
{{- define "kubeapps.kubeappsapis.fullname" -}}
{{- printf "%s-internal-kubeappsapis" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for the clusters config based on the fullname
*/}}
{{- define "kubeapps.clusters-config.fullname" -}}
{{- printf "%s-clusters-config" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the apprepository-controller service account to use
*/}}
{{- define "kubeapps.apprepository.serviceAccountName" -}}
{{- if .Values.apprepository.serviceAccount.create -}}
    {{- default (include "kubeapps.apprepository.fullname" .) .Values.apprepository.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.apprepository.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the kubeappsapis service account to use
*/}}
{{- define "kubeapps.kubeappsapis.serviceAccountName" -}}
{{- if .Values.kubeappsapis.serviceAccount.create -}}
    {{- default (include "kubeapps.kubeappsapis.fullname" .) .Values.kubeappsapis.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.kubeappsapis.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create proxy_pass for the kubeappsapis
*/}}
{{- define "kubeapps.kubeappsapis.proxy_pass" -}}
{{- printf "http://%s:%d" (include "kubeapps.kubeappsapis.fullname" .) (int .Values.kubeappsapis.service.ports.http) -}}
{{- end -}}

{{/*
Create name for the secrets related to oauth2_proxy
*/}}
{{- define "kubeapps.oauth2_proxy-secret.name" -}}
{{- if .Values.authProxy.existingOauth2Secret -}}
{{- printf "%s" (tpl .Values.authProxy.existingOauth2Secret $) -}}
{{- else -}}
{{- printf "%s-oauth2" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
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
{{- print "%s" .name -}}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Frontend service port number
*/}}
{{- define "kubeapps.frontend-port-number" -}}
{{- if .Values.authProxy.enabled -}}
{{ .Values.authProxy.containerPorts.proxy | int }}
{{- else -}}
{{ .Values.frontend.containerPorts.http | int }}
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
Returns the name of the global packaging namespace for the Helm plugin.
It uses the value passed in the plugin's config, but falls back to the "release namespace + suffix" formula.
*/}}
{{- define "kubeapps.helmGlobalPackagingNamespace" -}}
  {{- if .Values.kubeappsapis.pluginConfig.helm.packages.v1alpha1.globalPackagingNamespace }}
      {{- printf "%s" .Values.kubeappsapis.pluginConfig.helm.packages.v1alpha1.globalPackagingNamespace -}}
  {{- else -}}
      {{- printf "%s%s" .Release.Namespace .Values.apprepository.globalReposNamespaceSuffix -}}
  {{- end -}}
{{- end -}}

{{/*
Return the Postgresql secret name
*/}}
{{- define "kubeapps.postgresql.secretName" -}}
  {{- if .Values.postgresql.auth.existingSecret }}
      {{- printf "%s" .Values.postgresql.auth.existingSecret -}}
  {{- else -}}
      {{- printf "%s" (include "kubeapps.postgresql.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the Redis secret name
*/}}
{{- define "kubeapps.redis.secretName" -}}
  {{- if .Values.redis.auth.existingSecret }}
      {{- printf "%s" .Values.redis.auth.existingSecret -}}
  {{- else -}}
      {{- printf "%s" (include "kubeapps.redis.fullname" .) -}}
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
{{- if and .Values.ingress.enabled .Values.ingress.tls (not (include "common.ingress.certManagerRequest" ( dict "annotations" .Values.ingress.annotations ))) (not .Values.ingress.selfSigned) (empty .Values.ingress.extraTls) }}
kubeapps: ingress.tls
    You enabled the TLS configuration for the default ingress hostname but
    you did not enable any of the available mechanisms to create the TLS secret
    to be used by the Ingress Controller.
    Please use any of these alternatives:
      - Use the `ingress.extraTls` and `ingress.secrets` parameters to provide your custom TLS certificates.
      - Rely on cert-manager to create it by adding its supported annotations in `ingress.annotations`
      - Rely on Helm to create self-signed certificates by setting `ingress.selfSigned=true`
{{- end -}}
{{- end -}}

{{/*
# Calculate the kubeappsapis enabledPlugins.
*/}}
{{- define "kubeapps.kubeappsapis.enabledPlugins" -}}
    {{- $enabledPlugins := list }}
    {{- if .Values.kubeappsapis.enabledPlugins }}
      {{- $enabledPlugins = .Values.kubeappsapis.enabledPlugins }}
    {{- else }}
      {{- if and .Values.packaging.flux.enabled .Values.packaging.helm.enabled }}
        {{- fail "packaging: Please enable only one of the flux and helm plugins, since they both operate on Helm releases." }}
      {{- end -}}
      {{- range $plugin, $options := .Values.packaging }}
        {{- if $options.enabled }}
          {{- if eq $plugin "carvel" }}
            {{- $enabledPlugins = append $enabledPlugins "kapp-controller-packages" }}
          {{- else if eq $plugin "flux" }}
            {{- $enabledPlugins = append $enabledPlugins "fluxv2-packages" }}
          {{- else if eq $plugin "helm" }}
            {{- $enabledPlugins = append $enabledPlugins "helm-packages" }}
          {{- else }}
            {{ $msg := printf "packaging: Unsupported packaging option: %s" $plugin }}
            {{- fail $msg }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- if not $enabledPlugins }}
        {{- fail "packaging: Please enable at least one of the packaging plugins." }}
      {{- end }}
      {{- $enabledPlugins = append $enabledPlugins "resources" }}
    {{- end }}
    {{- $enabledPlugins | toJson }}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "kubeapps.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.frontend.image }}
{{- include "common.warnings.rollingTag" .Values.dashboard.image }}
{{- include "common.warnings.rollingTag" .Values.apprepository.image }}
{{- include "common.warnings.rollingTag" .Values.authProxy.image }}
{{- include "common.warnings.rollingTag" .Values.pinnipedProxy.image }}
{{- include "common.warnings.rollingTag" .Values.kubeappsapis.image }}
{{- end -}}
