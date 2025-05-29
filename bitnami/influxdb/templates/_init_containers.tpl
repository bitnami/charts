{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Returns an init-container that changes the owner and group of the persistent volume(s) mountpoint(s) to 'runAsUser:fsGroup' on each node
*/}}
{{- define "influxdb.defaultInitContainers.volumePermissions" -}}
- name: volume-permissions
  image: {{ include "influxdb.volumePermissions.image" . }}
  imagePullPolicy: {{ .Values.defaultInitContainers.volumePermissions.image.pullPolicy | quote }}
  {{- if .Values.defaultInitContainers.volumePermissions.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.defaultInitContainers.volumePermissions.containerSecurityContext "context" .) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultInitContainers.volumePermissions.resources }}
  resources: {{- toYaml .Values.defaultInitContainers.volumePermissions.resources | nindent 4 }}
  {{- else if ne .Values.defaultInitContainers.volumePermissions.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.defaultInitContainers.volumePermissions.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      mkdir -p {{ .Values.persistence.mountPath }}
      {{- if eq ( toString ( .Values.defaultInitContainers.volumePermissions.containerSecurityContext.runAsUser )) "auto" }}
      find {{ .Values.persistence.mountPath }} -mindepth 1 -maxdepth 1 -not -name ".snapshot" -not -name "lost+found" |  xargs -r chown -R $(id -u):$(id -G | cut -d " " -f2)
      {{- else }}
      find {{ .Values.persistence.mountPath }} -mindepth 1 -maxdepth 1 -not -name ".snapshot" -not -name "lost+found" |  xargs -r chown -R {{ .Values.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }}
      {{- end }}
  volumeMounts:
    - name: data
      mountPath: {{ .Values.persistence.mountPath }}
{{- end -}}
