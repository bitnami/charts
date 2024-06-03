{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Fluentd image name
*/}}
{{- define "fluentd.forwarder.image" -}}
{{- $registryName := default .Values.image.registry .Values.forwarder.image.registry -}}
{{- $repositoryName := default .Values.image.repository .Values.forwarder.image.repository -}}
{{- $tag := default .Values.image.tag .Values.forwarder.image.tag -}}
{{- $imageRoot := dict "registry" $registryName "repository" $repositoryName "tag" $tag -}}
{{ include "common.images.image" (dict "imageRoot" $imageRoot "global" .Values.global) }}
{{- end -}}

{{- define "fluentd.aggregator.image" -}}
{{- $registryName := default .Values.image.registry .Values.aggregator.image.registry -}}
{{- $repositoryName := default .Values.image.repository .Values.aggregator.image.repository -}}
{{- $tag := default .Values.image.tag .Values.aggregator.image.tag -}}
{{- $imageRoot := dict "registry" $registryName "repository" $repositoryName "tag" $tag -}}
{{ include "common.images.image" (dict "imageRoot" $imageRoot "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "fluentd.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the forwarder service account to use
*/}}
{{- define "fluentd.forwarder.serviceAccountName" -}}
{{- if .Values.forwarder.serviceAccount.create -}}
    {{ default (printf "%s-forwarder" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" ) .Values.forwarder.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.forwarder.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the aggregator service account to use
*/}}
{{- define "fluentd.aggregator.serviceAccountName" -}}
{{- if .Values.aggregator.serviceAccount.create -}}
    {{ default (printf "%s-aggregator" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" ) .Values.aggregator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.aggregator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "fluentd.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html
{{- end }}
{{- end -}}

{{/*
Validate data
*/}}
{{- define "fluentd.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "fluentd.validateValues.deployment" .) -}}
{{- $messages := append $messages (include "fluentd.validateValues.ingress" .) -}}
{{- $messages := append $messages (include "fluentd.validateValues.rbac" .) -}}
{{- $messages := append $messages (include "fluentd.validateValues.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
 {{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Fluentd - forwarders and aggregators can't be disabled at the same time */}}
{{- define "fluentd.validateValues.deployment" -}}
{{- if and (not .Values.forwarder.enabled) (not .Values.aggregator.enabled) -}}
fluentd:
    You have disabled both the forwarders and the aggregators.
    Please enable at least one of them (--set forwarder.enabled=true) (--set aggregator.enabled=true)
{{- end -}}
{{- end -}}

{{/* Validate values of Fluentd - if the aggregator index is enabled there must be a port named http in the service */}}
{{- define "fluentd.validateValues.ingress" -}}
{{- if and .Values.aggregator.enabled .Values.aggregator.ingress.enabled (not .Values.aggregator.service.ports.http) }}
fluentd:
    You have enabled the Ingress for the aggregator. The aggregator service needs to have a port named http for the Ingress to work.
    Please, define it in your `values.yaml` file. For example:

    aggregator:
      service:
        type: ClusterIP
        ports:
          http:
            port: 9880
            targetPort: http
            protocol: TCP

{{- end -}}
{{- end -}}

{{/* Validate values of Fluentd - must create serviceAccount to create enable RBAC */}}
{{- define "fluentd.validateValues.rbac" -}}
{{- $pspAvailable := (semverCompare "<1.25-0" (include "common.capabilities.kubeVersion" .)) -}}
{{- if and .Values.forwarder.rbac.create (not .Values.forwarder.serviceAccount.create) }}
fluentd: forwarder.rbac.create
    A ServiceAccount is required ("forwarder.rbac.create=true" is set)
    Please create a ServiceAccount (--set serviceAccount.forwarder.create=true)
{{- end -}}
{{- if and $pspAvailable .Values.forwarder.rbac.pspEnabled (not .Values.forwarder.rbac.create) }}
fluentd: forwarder.rbac.pspEnabled
    Enabling PSP requires RBAC to be created ("forwarder.rbac.create=true" is set)
    Please enable RBAC, or disable creation of PSP (--set forwarder.rbac.create=true) or (--set forwarder.rbac.pspEnabled=false)
{{- end -}}
{{- if and $pspAvailable .Values.forwarder.rbac.pspEnabled (not .Values.forwarder.podSecurityContext.enabled) }}
fluentd: forwarder.rbac.pspEnabled
    Enabling PSP requires enabling forwarder pod security context ("forwarder.podSecurityContext.enabled=true")
{{- end -}}
{{- if and $pspAvailable .Values.forwarder.rbac.pspEnabled (not .Values.forwarder.containerSecurityContext.enabled) }}
fluentd: forwarder.rbac.pspEnabled
    Enabling PSP requires enabling forwarder container security context ("forwarder.containerSecurityContext.enabled=true")
{{- end -}}
{{- end -}}

{{/* Validate values of Fluentd - TLS enabled */}}
{{- define "fluentd.validateValues.tls" -}}
{{- if and .Values.tls.enabled (not .Values.tls.autoGenerated) (or (and .Values.forwarder.enabled (not .Values.tls.forwarder.existingSecret)) (and .Values.aggregator.enabled (not .Values.tls.aggregator.existingSecret))) }}
fluentd: tls.enabled
    In order to enable TLS, you also need to provide
    an existing secret containing the TLS certificates for both Forwarder and Aggregator if enabled, or
    enable auto-generated certificates.
{{- end -}}
{{- end -}}

{{/*
Get the forwarder configmap name.
*/}}
{{- define "fluentd.forwarder.configMap" -}}
{{- if .Values.forwarder.configMap -}}
    {{- printf "%s" (tpl .Values.forwarder.configMap $) -}}
{{- else -}}
    {{- printf "%s-forwarder-cm" (include "common.names.fullname" . ) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the aggregator configmap name.
*/}}
{{- define "fluentd.aggregator.configMap" -}}
{{- if .Values.aggregator.configMap -}}
    {{- printf "%s" (tpl .Values.aggregator.configMap $) -}}
{{- else -}}
    {{- printf "%s-aggregator-cm" (include "common.names.fullname" . ) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the certificates secret name.
*/}}
{{- define "fluentd.forwarder.tlsSecretName" -}}
{{- if .Values.tls.forwarder.existingSecret -}}
    {{- printf "%s" (tpl .Values.tls.forwarder.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-fwd-crt" (include "common.names.fullname" . ) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the certificates secret name.
*/}}
{{- define "fluentd.aggregator.tlsSecretName" -}}
{{- if .Values.tls.aggregator.existingSecret -}}
    {{- printf "%s" (tpl .Values.tls.aggregator.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-agg-crt" (include "common.names.fullname" . ) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret object should be created
*/}}
{{- define "fluentd.createTlsSecret" -}}
{{- if and .Values.tls.enabled .Values.tls.autoGenerated (and (or (not .Values.tls.forwarder.existingSecret) (not .Values.forwarder.enabled)) (or (not .Values.aggregator.enabled) (not .Values.tls.aggregator.existingSecret))) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the initialization forwarder scripts volume name.
*/}}
{{- define "fluentd.forwarder.initScripts" -}}
{{- printf "%s-forwarder-init-scripts" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the initialization aggregator scripts volume name.
*/}}
{{- define "fluentd.aggregator.initScripts" -}}
{{- printf "%s-aggregator-init-scripts" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the initialization forwarder scripts ConfigMap name.
*/}}
{{- define "fluentd.forwarder.initScriptsCM" -}}
{{- printf "%s" .Values.forwarder.initScriptsCM -}}
{{- end -}}

{{/*
Get the initialization aggregator scripts ConfigMap name.
*/}}
{{- define "fluentd.aggregator.initScriptsCM" -}}
{{- printf "%s" .Values.aggregator.initScriptsCM -}}
{{- end -}}

{{/*
Get the initialization forwarder scripts Secret name.
*/}}
{{- define "fluentd.forwarder.initScriptsSecret" -}}
{{- printf "%s" .Values.forwarder.initScriptsSecret -}}
{{- end -}}

{{/*
Get the initialization aggregator scripts Secret name.
*/}}
{{- define "fluentd.aggregator.initScriptsSecret" -}}
{{- printf "%s" .Values.aggregator.initScriptsSecret -}}
{{- end -}}
