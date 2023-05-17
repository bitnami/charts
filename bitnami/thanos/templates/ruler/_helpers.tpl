{{- define "thanos.ruler.queryUrl" -}}
{{- $query := (include "thanos.query.values" . | fromYaml) -}}
{{- if .Values.queryUrl }}
    {{- printf "%s" $.Values.queryUrl  -}}
{{- else -}}
{{- printf "http://%s-query.%s.svc.%s:%d" (include "common.names.fullname" . ) .Release.Namespace .Values.clusterDomain (int  $query.service.ports.http) -}}
{{- end -}}
{{- end -}}
