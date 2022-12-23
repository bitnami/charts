{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "mxnet.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Apache MXNet (Incubating) image name
*/}}
{{- define "mxnet.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper git image name
*/}}
{{- define "git.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.git "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "mxnet.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mxnet.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.git .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/* Validate values of Apache MXNet (Incubating) - number of workers must be greater than 0 */}}
{{- define "mxnet.entrypoint" -}}
{{- if .Values.entrypoint.file }}
  {{- if (.Values.entrypoint.file | regexFind "[.]py$") }}
python3 {{ .Values.entrypoint.file }} {{ if .Values.entrypoint.args }}{{ .Values.entrypoint.args }}{{ end }}
  {{- else }}
bash {{ .Values.entrypoint.file }} {{ if .Values.entrypoint.args }}{{ .Values.entrypoint.args }}{{ end }}
  {{- end }}
  {{- else }}
sleep infinity
  {{- end }}
{{- end -}}

{{- define "mxnet.volumes" -}}
{{- if .Values.existingSecret }}
- name: secret-data
  secret:
    secretName: {{ .Values.existingSecret }}
{{- end }}
{{- if .Values.configMap }}
- name: ext-files
  configMap:
    name: {{ .Values.configMap }}
{{- else if .Files.Glob "files/*" }}
- name: local-files
  configMap:
    name: {{ printf "%s-files" (include "common.names.fullname" .) }}
{{- else if .Values.cloneFilesFromGit.enabled }}
- name: git-cloned-files
  emptyDir: {}
{{- end }}
{{- end -}}

{{- define "mxnet.volumeMounts" -}}
{{- if .Values.configMap }}
- name: ext-files
  mountPath: /app
{{- else if .Files.Glob "files/*" }}
- name: local-files
  mountPath: /app
{{- else if .Values.cloneFilesFromGit.enabled }}
- name: git-cloned-files
  mountPath: /app
{{- end }}
{{- if .Values.existingSecret }}
- name: secret-data
  mountPath: /secrets
{{- end }}
{{- end -}}


{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "mxnet.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "mxnet.validateValues.mode" .) -}}
{{- $messages := append $messages (include "mxnet.validateValues.workerCount" .) -}}
{{- $messages := append $messages (include "mxnet.validateValues.serverCount" .) -}}
{{- $messages := append $messages (include "mxnet.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Apache MXNet (Incubating) - must provide a valid mode ("distributed" or "standalone") */}}
{{- define "mxnet.validateValues.mode" -}}
{{- if and (ne .Values.mode "distributed") (ne .Values.mode "standalone") -}}
mxnet: mode
    Invalid mode selected. Valid values are "distributed" and
    "standalone". Please set a valid mode (--set mode="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of Apache MXNet (Incubating) - number of workers must be greater than 0 */}}
{{- define "mxnet.validateValues.workerCount" -}}
{{- $replicaCount := int .Values.worker.replicaCount }}
{{- if and (eq .Values.mode "distributed") (lt $replicaCount 1) -}}
mxnet: worker.replicaCount
    Worker count must be greater than 0 in distributed mode!!
    Please set a valid worker count size (--set worker.replicaCount=X)
{{- end -}}
{{- end -}}

{{/* Validate values of Apache MXNet (Incubating) - number of workers must be greater than 0 */}}
{{- define "mxnet.validateValues.serverCount" -}}
{{- $replicaCount := int .Values.server.replicaCount }}
{{- if and (eq .Values.mode "distributed") (lt $replicaCount 1) -}}
mxnet: server.replicaCount
    Server count must be greater than 0 in distributed mode!!
    Please set a valid worker count size (--set server.replicaCount=X)
{{- end -}}
{{- end -}}

{{/* Validate values of Apache MXNet (Incubating) - Incorrect extra volume settings */}}
{{- define "mxnet.validateValues.extraVolumes" -}}
{{- if and (.Values.extraVolumes) (not (or .Values.extraVolumeMounts .Values.cloneFilesFromGit.extraVolumeMounts)) -}}
mxnet: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them. Please set
    the extraVolumeMounts value
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "mxnet.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.git }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}
