{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Returns an init-container that changes the owner and group of the persistent volume(s) mountpoint(s) to 'runAsUser:fsGroup' on each node
*/}}
{{- define "clickhouse.defaultInitContainers.volumePermissions" -}}
{{- $roleValues := .context.Values -}}
{{- if not (empty .role) }}
  {{- $roleValues = index .context.Values .role -}}
{{- end }}
- name: volume-permissions
  image: {{ include "clickhouse.volumePermissions.image" .context }}
  imagePullPolicy: {{ .context.Values.defaultInitContainers.volumePermissions.image.pullPolicy | quote }}
  {{- if .context.Values.defaultInitContainers.volumePermissions.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .context.Values.defaultInitContainers.volumePermissions.containerSecurityContext "context" .context) | nindent 4 }}
  {{- end }}
  {{- if .context.Values.defaultInitContainers.volumePermissions.resources }}
  resources: {{- toYaml .context.Values.defaultInitContainers.volumePermissions.resources | nindent 4 }}
  {{- else if ne .context.Values.defaultInitContainers.volumePermissions.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .context.Values.defaultInitContainers.volumePermissions.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      mkdir -p {{ $roleValues.persistence.mountPath }}
      {{- if eq ( toString ( .context.Values.defaultInitContainers.volumePermissions.containerSecurityContext.runAsUser )) "auto" }}
      find {{ $roleValues.persistence.mountPath }} -mindepth 1 -maxdepth 1 -not -name ".snapshot" -not -name "lost+found" |  xargs -r chown -R $(id -u):$(id -G | cut -d " " -f2)
      {{- else }}
      find {{ $roleValues.persistence.mountPath }} -mindepth 1 -maxdepth 1 -not -name ".snapshot" -not -name "lost+found" |  xargs -r chown -R {{ $roleValues.containerSecurityContext.runAsUser }}:{{ $roleValues.podSecurityContext.fsGroup }}
      {{- end }}
  volumeMounts:
    - name: data
      mountPath: {{ $roleValues.persistence.mountPath }}
{{- end -}}
