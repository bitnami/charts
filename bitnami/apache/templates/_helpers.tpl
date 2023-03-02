{{/* vim: set filetype=mustache: */}}
{{/*
Return the proper Apache image name
*/}}
{{- define "apache.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Apache Docker Image Registry Secret Names
*/}}
{{- define "apache.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "apache.metrics.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return true if mouting a static web page
*/}}
{{- define "apache.useHtdocs" -}}
{{ default "" (or .Values.cloneHtdocsFromGit.enabled .Values.htdocsConfigMap .Values.htdocsPVC) }}
{{- end -}}

{{/*
Return associated volume
*/}}
{{- define "apache.htdocsVolume" -}}
{{- if .Values.cloneHtdocsFromGit.enabled }}
emptyDir: {}
{{- else if .Values.htdocsConfigMap }}
configMap:
  name: {{ .Values.htdocsConfigMap }}
{{- else if .Values.htdocsPVC }}
persistentVolumeClaim:
  claimName: {{ .Values.htdocsPVC }}
{{- end }}
{{- end -}}

{{/*
Validate data
*/}}
{{- define "apache.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "apache.validateValues.htdocs" .) -}}
{{- $messages := append $messages (include "apache.validateValues.htdocsGit" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
 {{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "apache.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Validate data (htdocs)
*/}}
{{- define "apache.validateValues.htdocs" -}}
{{- if or (and .Values.cloneHtdocsFromGit.enabled (or .Values.htdocsPVC .htdocsConfigMap )) (and .Values.htdocsPVC (or .Values.htdocsConfigMap .Values.cloneHtdocsFromGit.enabled )) (and .Values.htdocsConfigMap (or .Values.htdocsPVC .Values.cloneHtdocsFromGit.enabled )) }}
apache: htdocs
    You have selected more than one way of deploying htdocs. Please select only one of htdocsConfigMap cloneHtdocsFromGit or htdocsVolume
{{- end }}
{{- end -}}

{{/*
Validate data (htdocs git)
*/}}
{{- define "apache.validateValues.htdocsGit" -}}
{{- if .Values.cloneHtdocsFromGit.enabled }}
  {{- if not .Values.cloneHtdocsFromGit.repository }}
apache: htdocs-git-repository
    You did not specify a git repository to clone. Please set cloneHtdocsFromGit.repository
  {{- end }}
  {{- if not .Values.cloneHtdocsFromGit.branch }}
apache: htdocs-git-branch
    You did not specify a branch to checkout in the git repository. Please set cloneHtdocsFromGit.branch
  {{- end }}
{{- end -}}
{{- end -}}

{{/*
Validate values of Apache - Incorrect extra volume settings
*/}}
{{- define "apache.validateValues.extraVolumes" -}}
{{- if and (.Values.extraVolumes) (not (or .Values.extraVolumeMounts .Values.cloneHtdocsFromGit.extraVolumeMounts)) -}}
apache: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them. Please set
    the extraVolumeMounts value
{{- end -}}
{{- end -}}

{{/*
Return the proper git image name
*/}}
{{- define "git.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.git "global" .Values.global) -}}
{{- end -}}

{{/*
Get the vhosts config map name.
*/}}
{{- define "apache.vhostsConfigMap" -}}
{{- if .Values.vhostsConfigMap -}}
    {{- printf "%s" (tpl .Values.vhostsConfigMap $) -}}
{{- else -}}
    {{- printf "%s-vhosts" (include "common.names.fullname" . ) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the httpd.conf config map name.
*/}}
{{- define "apache.httpdConfConfigMap" -}}
{{- if .Values.httpdConfConfigMap -}}
    {{- printf "%s" (tpl .Values.httpdConfConfigMap $) -}}
{{- else -}}
    {{- printf "%s-httpd-conf" (include "common.names.fullname" . ) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
