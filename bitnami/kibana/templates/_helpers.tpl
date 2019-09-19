{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kibana.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kibana.imagePullSecrets" -}}
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
{{- else if or .Values.image.pullSecrets .Values.volumePermissions.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.volumePermissions.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if or .Values.image.pullSecrets .Values.volumePermissions.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.volumePermissions.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Return true if the deployment should include dashboards
*/}}
{{- define "kibana.importSavedObjects" -}}
{{- if or .Values.savedObjects.configmap .Values.savedObjects.urls }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Kibana image name
*/}}
{{- define "kibana.image" -}}
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
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kibana.fullname" -}}
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
Create a default fully qualified elasticsearch name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kibana.elasticsearch.fullname" -}}
{{- if .Values.elasticsearch.fullnameOverride -}}
{{- .Values.elasticsearch.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "elasticsearch" .Values.elasticsearch.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kibana.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kibana.elasticsearch.url" -}}
{{- if not .Values.elasticsearch.useBundled -}}
{{- if .Values.elasticsearch.external.hosts -}}
{{- $totalHosts := len .Values.elasticsearch.external.hosts -}}
{{- range $i, $host := .Values.elasticsearch.external.hosts -}}
{{- printf "http://%s:%s" $host (include "kibana.elasticsearch.port" $) -}}
{{- if (lt ( add1 $i ) $totalHosts ) }}{{- printf "," -}}{{- end }}
{{- end -}}
{{- end -}}
{{- else -}}
{{- printf "http://%s:%s" (printf "%s-coordinating-only" (include "kibana.elasticsearch.fullname" .)) (include "kibana.elasticsearch.port" .) -}}
{{- end -}}
{{- end -}}

{{/*
Set Elasticsearch Port.
*/}}
{{- define "kibana.elasticsearch.port" -}}
{{- if .Values.elasticsearch.useBundled -}}
{{- .Values.elasticsearch.coordinating.service.port -}}
{{- else -}}
{{- .Values.elasticsearch.external.port -}}
{{- end -}}
{{- end -}}

{{/*
Set Elasticsearch Port.
*/}}
{{- define "kibana.pvc" -}}
{{- .Values.persistence.existingClaim | default (include "kibana.fullname" .) -}}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "kibana.initScriptsSecret" -}}
{{- printf "%s" (tpl .Values.initScriptsSecret $) -}}
{{- end -}}

{{/*
Get the initialization scripts configmap name.
*/}}
{{- define "kibana.initScriptsCM" -}}
{{- printf "%s" (tpl .Values.initScriptsCM $) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "kibana.volumePermissions.image" -}}
{{- $registryName := .Values.volumePermissions.image.registry -}}
{{- $repositoryName := .Values.volumePermissions.image.repository -}}
{{- $tag := .Values.volumePermissions.image.tag | toString -}}
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
Get the saved objects configmap name.
*/}}
{{- define "kibana.savedObjectsCM" -}}
{{- printf "%s" (tpl .Values.savedObjects.configmap $) -}}
{{- end -}}

{{/*
Set Elasticsearch Port.
*/}}
{{- define "kibana.configurationCM" -}}
{{- .Values.configurationCM | default (printf "%s-conf" (include "kibana.fullname" .)) -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "kibana.labels" -}}
app.kubernetes.io/name: {{ include "kibana.name" . }}
helm.sh/chart: {{ include "kibana.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "kibana.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.storageClass -}}
              {{- if (eq "-" .Values.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.storageClass -}}
        {{- if (eq "-" .Values.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "kibana.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "kibana.validateValues.noElastic" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.elasticConflict" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.externalESSettings" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.configConflict" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}


{{/* Validate values of Kibana - must provide a ElasticSearch */}}
{{- define "kibana.validateValues.noElastic" -}}
{{- if and (not .Values.elasticsearch.useBundled) (not .Values.elasticsearch.external.hosts) (not .Values.elasticsearch.external.port) -}}
kibana: no-elasticsearch
    You did not specify an external Elasticsearch instance nor enabled the bundled
    one. Please set either elasticsearch.useBundled=true or set elasticsearch.external.hosts and elasticsearch.external.port
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - conflict with ElasticSearch */}}
{{- define "kibana.validateValues.elasticConflict" -}}
{{- if and (.Values.elasticsearch.useBundled) (.Values.elasticsearch.external.hosts) -}}
kibana: conflict-elasticsearch
    You specified both the external Elasticsearch instance and the bundled one.
    Please only set either elasticsearch.useBundled=true or elasticsearch.external.hosts
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - Missing external ES Setting */}}
{{- define "kibana.validateValues.externalESSettings" -}}
{{- if (not .Values.elasticsearch.useBundled) }}
{{- if and (not .Values.elasticsearch.external.hosts) .Values.elasticsearch.external.port }}
kibana: missing-es-settings-host
    You specified the external Elasticsearch port but not the host. Please
    set elasticsearch.external.hosts
{{- end -}}
{{- if and .Values.elasticsearch.external.hosts (not .Values.elasticsearch.external.port) }}
kibana: missing-es-settings-port
    You specified the external Elasticsearch hosts but not the port. Please
    set elasticsearch.external.port
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - configuration conflict */}}
{{- define "kibana.validateValues.configConflict" -}}
{{- if and (.Values.extraConfiguration) (.Values.configurationCM) -}}
kibana: conflict-configuration
    You specified a ConfigMap with kibana.yml and a set of settings to be added
    to the default kibana.yml. Please only set either extraConfiguration or configurationCM
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - Incorrect extra volume settings */}}
{{- define "kibana.validateValues.extraVolumes" -}}
{{- if and (.Values.extraVolumes) (not .Values.extraVolumeMounts) -}}
kibana: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them. Please set
    the extraVolumeMounts value
{{- end -}}
{{- end -}}
