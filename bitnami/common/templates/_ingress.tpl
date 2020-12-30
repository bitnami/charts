{{/* vim: set filetype=mustache: */}}

{{/*
Generate path entry that is compatible with all Kubernetes API versions.

Usage:
{{ include "common.ingress.path" (dict "path" "pathPrefix" "pathType" "pathType" "serviceName" "backendName" "servicePort" "backendPort" "context" $) }}

Params:
  - path - String. Path inside the service
  - pathType - String. Path type
  - serviceName - String. Name of an existing service backend
  - servicePort - String/Int. Port name (or number) of the service. It will be translated to different yaml depending if it is a string or an integer.
  - context - Dict - Required. The context for the template evaluation.
*/}}
{{- define "common.ingress.path" -}}
- path: {{ .path }}
  {{- if eq "true" (include "common.ingress.supportsPathType" .context) }}
  pathType: {{ .pathType }}
  {{- end }}
  backend: {{- include "common.ingress.backend" (dict "serviceName" .serviceName "servicePort" .servicePort "context" .context)  | nindent 4 }}
{{- end -}}

{{/*
Generate backend entry that is compatible with all Kubernetes API versions.

Usage:
{{ include "common.ingress.backend" (dict "serviceName" "backendName" "servicePort" "backendPort" "context" $) }}

Params:
  - serviceName - String. Name of an existing service backend
  - servicePort - String/Int. Port name (or number) of the service. It will be translated to different yaml depending if it is a string or an integer.
  - context - Dict - Required. The context for the template evaluation.
*/}}
{{- define "common.ingress.backend" -}}
{{- $apiVersion := (include "common.capabilities.ingress.apiVersion" .context) -}}
{{- if (eq $apiVersion "extensions/v1beta1") -}}
serviceName: {{ .serviceName }}
servicePort: {{ .servicePort }}
{{- else -}}
service:
  name: {{ .serviceName }}
  port:
    {{- if typeIs "string" .servicePort }}
    name: {{ .servicePort }}
    {{- else if typeIs "int" .servicePort }}
    number: {{ .servicePort }}
    {{- end }}
{{- end -}}
{{- end -}}

{{/*
Print "true" if the API pathType field is supported
Usage:
{{ include "common.ingress.supportsPathType" . }}
*/}}
{{- define "common.ingress.supportsPathType" -}}
{{- $apiVersion := (include "common.capabilities.ingress.apiVersion" .) -}}
{{- if (semverCompare "<1.18-0" .Capabilities.KubeVersion.Version) -}}
{{- print "false" -}}
{{- else -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}
