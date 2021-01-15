{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Kibana image name
*/}}
{{- define "kibana.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "kibana.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kibana.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
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
Set Elasticsearch URL.
*/}}
{{- define "kibana.elasticsearch.url" -}}
{{- if .Values.elasticsearch.hosts -}}
{{- $totalHosts := len .Values.elasticsearch.hosts -}}
{{- $protocol := ternary "https" "http" .Values.elasticsearch.tls -}}
{{- range $i, $hostTemplate := .Values.elasticsearch.hosts -}}
{{- $host := tpl $hostTemplate $ }}
{{- printf "%s://%s:%s" $protocol $host (include "kibana.elasticsearch.port" $) -}}
{{- if (lt ( add1 $i ) $totalHosts ) }}{{- printf "," -}}{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Set Elasticsearch Port.
*/}}
{{- define "kibana.elasticsearch.port" -}}
{{- .Values.elasticsearch.port -}}
{{- end -}}

{{/*
Set Elasticsearch PVC.
*/}}
{{- define "kibana.pvc" -}}
{{- .Values.persistence.existingClaim | default (include "common.names.fullname" .) -}}
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
Get the saved objects configmap name.
*/}}
{{- define "kibana.savedObjectsCM" -}}
{{- printf "%s" (tpl .Values.savedObjects.configmap $) -}}
{{- end -}}

{{/*
Set Elasticsearch Port.
*/}}
{{- define "kibana.configurationCM" -}}
{{- .Values.configurationCM | default (printf "%s-conf" (include "common.names.fullname" .)) -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "kibana.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "kibana.validateValues.noElastic" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.configConflict" .) -}}
{{- $messages := append $messages (include "kibana.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Kibana - must provide an ElasticSearch */}}
{{- define "kibana.validateValues.noElastic" -}}
{{- if and (not .Values.elasticsearch.hosts) (not .Values.elasticsearch.port) -}}
kibana: no-elasticsearch
    You did not specify an external Elasticsearch instance.
    Please set elasticsearch.hosts and elasticsearch.port
{{- else if and (not .Values.elasticsearch.hosts) .Values.elasticsearch.port }}
kibana: missing-es-settings-host
    You specified the external Elasticsearch port but not the host. Please
    set elasticsearch.hosts
{{- else if and .Values.elasticsearch.hosts (not .Values.elasticsearch.port) }}
kibana: missing-es-settings-port
    You specified the external Elasticsearch hosts but not the port. Please
    set elasticsearch.port
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

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "kibana.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}
