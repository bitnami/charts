{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "victoriametrics.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.vmselect.image .Values.vminsert.image .Values.vmstorage.image .Values.vmauth.image .Values.vmagent.image .Values.defaultInitContainers.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper victoriametrics.vmselect.fullname
*/}}
{{- define "victoriametrics.vmselect.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "vmselect" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Select image name
*/}}
{{- define "victoriametrics.vmselect.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.vmselect.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (VictoriaMetrics Select)
*/}}
{{- define "victoriametrics.vmselect.serviceAccountName" -}}
{{- if .Values.vmselect.serviceAccount.create -}}
    {{ default (include "victoriametrics.vmselect.fullname" .) .Values.vmselect.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.vmselect.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Insert fullname
*/}}
{{- define "victoriametrics.vminsert.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "vminsert" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Insert image name
*/}}
{{- define "victoriametrics.vminsert.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.vminsert.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (VictoriaMetrics Insert)
*/}}
{{- define "victoriametrics.vminsert.serviceAccountName" -}}
{{- if .Values.vminsert.serviceAccount.create -}}
    {{ default (include "victoriametrics.vminsert.fullname" .) .Values.vminsert.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.vminsert.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Storage fullname
*/}}
{{- define "victoriametrics.vmstorage.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "vmstorage" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Storage image name
*/}}
{{- define "victoriametrics.vmstorage.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.vmstorage.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (VictoriaMetrics Storage)
*/}}
{{- define "victoriametrics.vmstorage.serviceAccountName" -}}
{{- if .Values.vmstorage.serviceAccount.create -}}
    {{ default (include "victoriametrics.vmstorage.fullname" .) .Values.vmstorage.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.vmstorage.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Auth fullname
*/}}
{{- define "victoriametrics.vmauth.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "vmauth" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Auth image name
*/}}
{{- define "victoriametrics.vmauth.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.vmauth.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (VictoriaMetrics Auth)
*/}}
{{- define "victoriametrics.vmauth.serviceAccountName" -}}
{{- if .Values.vmauth.serviceAccount.create -}}
    {{ default (include "victoriametrics.vmauth.fullname" .) .Values.vmauth.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.vmauth.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Name of the VictoriaMetrics Auth Secret
*/}}
{{- define "victoriametrics.vmauth.secretName" -}}
{{- if .Values.vmauth.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.vmauth.existingSecret "context" $) -}}
{{- else -}}
    {{- include "victoriametrics.vmauth.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Agent fullname
*/}}
{{- define "victoriametrics.vmagent.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "vmagent" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Agent image name
*/}}
{{- define "victoriametrics.vmagent.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.vmagent.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (VictoriaMetrics Agent)
*/}}
{{- define "victoriametrics.vmagent.serviceAccountName" -}}
{{- if .Values.vmagent.serviceAccount.create -}}
    {{ default (include "victoriametrics.vmagent.fullname" .) .Values.vmagent.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.vmagent.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Name of the VictoriaMetrics Agent Secret
*/}}
{{- define "victoriametrics.vmagent.scrapeConfigMapName" -}}
{{- if .Values.vmagent.existingScrapeConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.vmagent.existingScrapeConfigMap "context" $) -}}
{{- else -}}
    {{- include "victoriametrics.vmagent.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Alert fullname
*/}}
{{- define "victoriametrics.vmalert.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "vmalert" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper VictoriaMetrics Alert image name
*/}}
{{- define "victoriametrics.vmalert.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.vmalert.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (VictoriaMetrics Alert)
*/}}
{{- define "victoriametrics.vmalert.serviceAccountName" -}}
{{- if .Values.vmalert.serviceAccount.create -}}
    {{ default (include "victoriametrics.vmalert.fullname" .) .Values.vmalert.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.vmalert.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Name of the VictoriaMetrics Alert Secret
*/}}
{{- define "victoriametrics.vmalert.rulesConfigMapName" -}}
{{- if .Values.vmalert.existingRulesConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.vmalert.existingRulesConfigMap "context" $) -}}
{{- else -}}
    {{- include "victoriametrics.vmalert.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "victoriametrics.volume-permissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.defaultInitContainers.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{- define "victoriametrics.init-containers.volume-permissions" -}}
{{- /* As most Bitnami charts have volumePermissions in the root, we add this overwrite to maintain a similar UX */}}
- name: volume-permissions
  image: {{ include "victoriametrics.volume-permissions.image" . }}
  imagePullPolicy: {{ .context.Values.defaultInitContainers.volumePermissions.image.pullPolicy | quote }}
  command:
    - /bin/bash
    - -ec
    - |
      {{- if eq ( toString ( .Values.defaultInitContainers.volumePermissions.containerSecurityContext.runAsUser )) "auto" }}
      chown -R `id -u`:`id -G | cut -d " " -f2` {{ .componentValues.persistence.mountPath }}
      {{- else }}
      chown -R {{ .componentValues.containerSecurityContext.runAsUser }}:{{ .componentValues.podSecurityContext.fsGroup }} {{ .componentValues.persistence.mountPath }}
      {{- end }}
  {{- if .Values.defaultInitContainers.volumePermissions.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.defaultInitContainers.volumePermissions.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultInitContainers.volumePermissions.resources }}
  resources: {{- toYaml .Values.defaultInitContainers.volumePermissions.resources | nindent 4 }}
  {{- else if ne .Values.defaultInitContainers.volumePermissions.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.defaultInitContainers.volumePermissions.resourcesPreset) | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: data
      mountPath: {{ .componentValues.persistence.mountPath }}
      {{- if .componentValues.persistence.subPath }}
      subPath: {{ .componentValues.persistence.subPath }}
      {{- end }}
{{- end -}}

{{/*
Validate values for victoriametrics.
*/}}
{{- define "victoriametrics.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}
