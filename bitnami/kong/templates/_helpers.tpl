{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kong.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper kong image name
*/}}
{{- define "kong.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper kong image name
*/}}
{{- define "kong.ingress-controller.image" -}}
{{- $registryName := .Values.ingressController.image.registry -}}
{{- $repositoryName := .Values.ingressController.image.repository -}}
{{- $tag := .Values.ingressController.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper kong migration image name
*/}}
{{- define "kong.migration.image" -}}
{{- $registryName := .Values.migration.image.registry -}}
{{- $repositoryName := .Values.migration.image.repository -}}
{{- $tag := .Values.migration.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "kong.labels" -}}
app.kubernetes.io/name: {{ include "kong.name" . }}
helm.sh/chart: {{ include "kong.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kong.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kong.cassandra.fullname" -}}
{{- printf "%s-%s" .Release.Name "cassandra" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "kong.matchLabels" -}}
app.kubernetes.io/name: {{ include "kong.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kong.fullname" -}}
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
{{- define "kong.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get Cassandra port
*/}}
{{- define "kong.cassandra.port" -}}
{{- if .Values.cassandra.enabled -}}
{{- .Values.cassandra.service.port -}}
{{- else -}}
{{- .Values.cassandra.external.port -}}
{{- end -}}
{{- end -}}

{{/*
Get Cassandra contact points
*/}}
{{- define "kong.cassandra.contactPoints" -}}
{{- $global := . -}}
{{- if .Values.cassandra.enabled -}}
  {{- $replicas := int .Values.cassandra.cluster.replicaCount -}}
  {{- $domain := .Values.clusterDomain -}}
  {{- range $i, $e := until $replicas }}
    {{- include "kong.cassandra.fullname" $global }}-{{ $i }}.{{ include "kong.cassandra.fullname" $global }}-headless.{{ $global.Release.Namespace }}.svc.{{ $domain }}
    {{- if (lt ( add1 $i ) $replicas ) -}}
    ,
    {{- end -}}
  {{- end -}}
{{- else -}}
  {{- $replicas := len .Values.cassandra.external.hosts -}}
  {{- range $i, $e := until $replicas }}
    {{- index $global.Values.cassandra.external.hosts $i -}}
    {{- if (lt ( add1 $i ) $replicas ) -}}
    ,
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get PostgreSQL host
*/}}
{{- define "kong.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
  {{- template "kong.postgresql.fullname" . -}}
{{- else -}}
  {{ .Values.postgresql.external.host }}
{{- end -}}
{{- end -}}

{{/*
Get PostgreSQL user
*/}}
{{- define "kong.postgresql.user" -}}
{{- if .Values.postgresql.enabled -}}
  {{- .Values.postgresql.postgresqlUsername -}}
{{- else -}}
  {{ .Values.postgresql.external.user }}
{{- end -}}
{{- end -}}

{{/*
Get Cassandra user
*/}}
{{- define "kong.cassandra.user" -}}
{{- if .Values.postgresql.enabled -}}
  {{- .Values.cassandra.dbUser.user -}}
{{- else -}}
  {{ .Values.cassandra.external.user }}
{{- end -}}
{{- end -}}

{{/*
Get Cassandra secret
*/}}
{{- define "kong.cassandra.secretName" -}}
{{- if .Values.cassandra.existingSecret -}}
  {{- .Values.cassandra.existingSecret -}}
{{- else if .Values.cassandra.enabled }}
  {{- template "kong.cassandra.fullname" . -}}
{{- else -}}
  {{- printf "%s-external-secret" ( include "kong.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get PostgreSQL secret
*/}}
{{- define "kong.postgresql.secretName" -}}
{{- if .Values.postgresql.existingSecret -}}
  {{- .Values.postgresql.existingSecret -}}
{{- else if .Values.postgresql.enabled }}
  {{- template "kong.postgresql.fullname" . -}}
{{- else -}}
  {{- printf "%s-external-secret" ( include "kong.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kong.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.migration.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.ingressController.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if (or .Values.image.pullSecrets .Values.ingressController.image.pullSecrets .Values.migration.image.pullSecrets)}}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.migration.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.ingressController.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret for a external database should be created
*/}}
{{- define "kong.createExternalDBSecret" -}}
{{- if and (not .Values.postgresql.enabled) (not .Values.cassandra.enabled) (not .Values.cassandra.existingSecret) (not .Values.postgresql.existingSecret) -}}
  {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get proper service account
*/}}
{{- define "kong.serviceAccount" -}}
{{- if .Values.ingressController.rbac.existingServiceAccount -}}
{{ .Values.ingressController.rbac.existingServiceAccount }}
{{- else -}}
{{- include "kong.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Validate values for kong.
*/}}
{{- define "kong.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "kong.validateValues.database" .) -}}
{{- $messages := append $messages (include "kong.validateValues.rbac" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the RBAC
*/}}
{{- define "kong.validateValues.rbac" -}}
{{- if and .Values.ingressController.enabled (not .Values.ingressController.rbac.existingServiceAccount) (not .Values.ingressController.rbac.create) -}}
INVALID RBAC: You enabled the Kong Ingress Controller sidecar without creating RBAC objects and not
specifying an existing Service Account. Specify an existing Service Account in ingressController.rbac.existingServiceAccount
or allow the chart to create the proper RBAC objects with ingressController.rbac.create
{{- end -}}
{{- end -}}
{{/*
Function to validate the external database
*/}}
{{- define "kong.validateValues.database" -}}

{{- if and (not (eq .Values.database "postgresql")) (not (eq .Values.database "cassandra")) -}}
INVALID DATABASE: The value "{{ .Values.database }}" is not allowed for the "database" value. It
must be one either "postgresql" or "cassandra".
{{- end }}

{{- if and (eq .Values.database "postgresql") (not .Values.postgresql.enabled) (not .Values.postgresql.external.host) -}}
NO DATABASE: You disabled the Cassandra sub-chart but did not specify external Cassandra hosts. Either deploy the PostgreSQL sub-chart by setting cassandra.enabled=true or set a value for cassandra.external.hosts.
{{- end }}

{{- if and (eq .Values.database "postgresql") (not .Values.postgresql.enabled) (not .Values.postgresql.external.host) -}}
NO DATABASE: You disabled the PostgreSQL sub-chart but did not specify an external PostgreSQL host. Either deploy the PostgreSQL sub-chart by setting postgresql.enabled=true or set a value for postgresql.external.host.
{{- end }}


{{- if and (eq .Values.database "postgresql") .Values.postgresql.enabled .Values.postgresql.external.host -}}
CONFLICT: You specified to deploy the PostgreSQL sub-chart and also specified an external
PostgreSQL instance. Only one of postgresql.enabled (deploy sub-chart) and postgresql.external.host can be set
{{- end }}

{{- if and (eq .Values.database "cassandra") .Values.cassandra.enabled .Values.cassandra.external.hosts -}}
CONFLICT: You specified to deploy the Cassandra sub-chart and also specified external
Cassandra hosts. Only one of cassandra.enabled (deploy sub-chart) and cassandra.external.hosts can be set
{{- end }}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "kong.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "kong.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
