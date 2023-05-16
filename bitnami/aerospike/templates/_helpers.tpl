{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Aerospike image name
*/}}
{{- define "aerospike.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "aerospike.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the Aerospike configuration configmap
*/}}
{{- define "aerospike.configmapName" -}}
{{- printf "%s-configuration" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "aerospike.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the list of aerospike hosts
*/}}
{{- define "aerospike.hosts" -}}
{{- $hosts := list }}
{{- $fullname := include "common.names.fullname" . }}
{{- $releaseNamespace := .Release.Namespace }}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $hostCount := .Values.replicaCount | int }}
{{- range $e, $i := until $hostCount }}
{{- $hosts = append $hosts (printf "%s-%d.%s-headless.%s.svc.%s" $fullname $i $fullname $releaseNamespace $clusterDomain) }}
{{- end }}
{{- join "," $hosts }}
{{- end -}}
