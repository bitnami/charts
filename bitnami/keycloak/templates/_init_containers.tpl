{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Returns an init-container that copies writable directories to an empty dir volume in order to not break the application functionality
*/}}
{{- define "keycloak.defaultInitContainers.prepareWriteDirs" -}}
- name: prepare-write-dirs
  image: {{ template "keycloak.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.defaultInitContainers.prepareWriteDirs.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.defaultInitContainers.prepareWriteDirs.containerSecurityContext "context" .) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultInitContainers.prepareWriteDirs.resources }}
  resources: {{- toYaml .Values.defaultInitContainers.prepareWriteDirs.resources | nindent 4 }}
  {{- else if ne .Values.defaultInitContainers.prepareWriteDirs.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.defaultInitContainers.prepareWriteDirs.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/liblog.sh

      info "Copying writable dirs to empty dir"
      # In order to not break the application functionality we need to make some
      # directories writable, so we need to copy it to an empty dir volume
      cp -r --preserve=mode,timestamps /opt/bitnami/keycloak/lib/quarkus /emptydir/app-quarkus-dir
      cp -r --preserve=mode,timestamps /opt/bitnami/keycloak/data /emptydir/app-data-dir
      cp -r --preserve=mode,timestamps /opt/bitnami/keycloak/providers /emptydir/app-providers-dir
      cp -r --preserve=mode,timestamps /opt/bitnami/keycloak/themes /emptydir/app-themes-dir
      info "Copy operation completed"
  volumeMounts:
   - name: empty-dir
     mountPath: /emptydir
{{- end -}}
