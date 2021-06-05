{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fluentd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fluentd.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fluentd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "fluentd.labels" -}}
app.kubernetes.io/name: {{ include "fluentd.name" . }}
helm.sh/chart: {{ include "fluentd.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on daemonset.spec.selector.matchLabels, statefulset.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "fluentd.matchLabels" -}}
app.kubernetes.io/name: {{ include "fluentd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return the proper Fluentd image name
*/}}
{{- define "fluentd.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "fluentd.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the forwarder service account to use
*/}}
{{- define "fluentd.forwarder.serviceAccountName" -}}
{{- if .Values.forwarder.serviceAccount.create -}}
    {{ default (printf "%s-forwarder" (include "fluentd.fullname" .)) .Values.forwarder.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.forwarder.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the aggregator service account to use
*/}}
{{- define "fluentd.aggregator.serviceAccountName" -}}
{{- if .Values.aggregator.serviceAccount.create -}}
    {{ default (printf "%s-aggregator" (include "fluentd.fullname" .)) .Values.aggregator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.aggregator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "fluentd.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
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
{{- $messages := append $messages (include "fluentd.validateValues.serviceAccount" .) -}}
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
{{- if and .Values.aggregator.enabled .Values.aggregator.ingress.enabled (not .Values.aggregator.service.ports.http)}}
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
{{- if not (typeIs "<nil>" .Values.rbac.create) -}}
fluentd: rbac.create
    Top-level rbac configuration has been removed, as it only applied to the forwarder.
    Please migrate to forwarder.rbac.create
{{- end -}}
{{- if and .Values.forwarder.rbac.create (not .Values.forwarder.serviceAccount.create) }}
fluentd: forwarder.rbac.create
    A ServiceAccount is required ("forwarder.rbac.create=true" is set)
    Please create a ServiceAccount (--set serviceAccount.forwarder.create=true)
{{- end -}}
{{- if and .Values.forwarder.rbac.pspEnabled (not .Values.forwarder.rbac.create) }}
fluentd: forwarder.rbac.pspEnabled
    Enabling PSP requires RBAC to be created ("forwarder.rbac.create=true" is set)
    Please enable RBAC, or disable creation of PSP (--set forwarder.rbac.create=true) or (--set forwarder.rbac.pspEnabled=false)
{{- end -}}
{{- if and .Values.forwarder.rbac.pspEnabled (not .Values.forwarder.securityContext.enabled) }}
fluentd: forwarder.rbac.pspEnabled
    Enabling PSP requires enabling forwarder pod security context ("forwarder.securityContext.enabled=true")
{{- end -}}
{{- if and .Values.forwarder.rbac.pspEnabled (not .Values.forwarder.containerSecurityContext.enabled) }}
fluentd: forwarder.rbac.pspEnabled
    Enabling PSP requires enabling forwarder container security context ("forwarder.containerSecurityContext.enabled=true")
{{- end -}}
{{- end -}}

{{/* Validate values of Fluentd - prefer per component serviceAccounts to top-level definition */}}
{{- define "fluentd.validateValues.serviceAccount" -}}
{{- if not (typeIs "<nil>" .Values.serviceAccount.create) -}}
fluentd: serviceAccount.create:
    Top-level serviceAccount configuration has been removed, as it only applied to the forwarder.
    Please migrate to forwarder.serviceAccount.create
{{- end -}}
{{- if .Values.serviceAccount.name }}
fluentd: serviceAccount.name
    Top-level serviceAccount configuration has been removed, as it only applied to the forwarder.
    Please migrate to forwarder.serviceAccount.name
{{- end -}}
{{- if .Values.serviceAccount.annotations }}
fluentd: serviceAccount.annotations
    Top-level serviceAccount configuration has been removed, as it only applied to the forwarder.
    Please migrate to forwarder.serviceAccount.annotations
{{- end -}}
{{- end -}}

{{/*
Get the forwarder configmap name.
*/}}
{{- define "fluentd.forwarder.configMap" -}}
{{- if .Values.forwarder.configMap -}}
    {{- printf "%s" (tpl .Values.forwarder.configMap $) -}}
{{- else -}}
    {{- printf "%s-forwarder-cm" (include "fluentd.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the aggregator configmap name.
*/}}
{{- define "fluentd.aggregator.configMap" -}}
{{- if .Values.aggregator.configMap -}}
    {{- printf "%s" (tpl .Values.aggregator.configMap $) -}}
{{- else -}}
    {{- printf "%s-aggregator-cm" (include "fluentd.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the certificates secret name.
*/}}
{{- define "fluentd.tls.secretName" -}}
{{- if .Values.tls.existingSecret -}}
    {{- printf "%s" (tpl .Values.tls.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-tls" (include "fluentd.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "fluentd.tplValue" (dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "fluentd.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
