{{/* vim: set filetype=mustache: */}}
{{/*
Return the proper image name
{{ include "common.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "common.images.image" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $tag := .imageRoot.tag | toString -}}
{{- if .global }}
    {{- if .global.imageRegistry }}
     {{- $registryName = .global.imageRegistry -}}
    {{- end -}}
{{- end -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
{{ include "common.images.pullSecrets" ( dict "images" (list .Values.path.to.the.image1, .Values.path.to.the.image2) "global" $) }}
*/}}
{{- define "common.images.pullSecrets" -}}
{{- if .global }}
{{- if .global.imagePullSecrets }}
imagePullSecrets:
  {{- range .global.imagePullSecrets }}
  - name: {{ . }}
  {{- end }}
{{- end }}
{{- else }}
{{- $pullSecrets := list }}
{{- range .images }}
  {{- if .pullSecrets }}
    {{- $pullSecrets = append $pullSecrets .pullSecrets }}
  {{- end }}
{{- end }}
{{- if $pullSecrets }}
imagePullSecrets:
  {{- range $pullSecrets }}
  - name: {{ . }}
  {{- end }}
{{- end }}
{{- end -}}
{{- end -}}
