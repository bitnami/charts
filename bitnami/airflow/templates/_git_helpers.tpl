{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}
{{/*
Returns the name that will identify the repository internally and it will be used to create folders or
volume names
*/}}
{{- define "airflow.git.repository.name" -}}
  {{- $defaultName := regexFind "/.*$" .repository | replace "//" "" | replace "/" "-" | replace "." "-" -}}
  {{- .name | default $defaultName | kebabcase -}}
{{- end -}}

{{/*
Returns the volume mounts that will be used by git containers (clone and sync)
*/}}
{{- define "airflow.git.volumeMounts" -}}
{{- if .Values.git.dags.enabled }}
- name: empty-dir
  mountPath: /dags
  subPath: app-git-dags-dir
{{- end }}
{{- if .Values.git.plugins.enabled }}
- name: empty-dir
  mountPath: /plugins
  subPath: app-git-plugins-dir
{{- end }}
{{- end -}}

{{/*
Returns the volume mounts that will be used by the main container
*/}}
{{- define "airflow.git.maincontainer.volumeMounts" -}}
{{- if .Values.git.dags.enabled }}
  {{- range .Values.git.dags.repositories }}
- name: empty-dir
  mountPath: /opt/bitnami/airflow/dags/git_{{ include "airflow.git.repository.name" . }}
  {{- if .path }}
  subPath: app-git-dags-dir/{{ include "airflow.git.repository.name" . }}/{{ .path }}
  {{- else }}
  subPath: app-git-dags-dir/{{ include "airflow.git.repository.name" . }}
  {{- end }}
  {{- end }}
{{- end }}
{{- if .Values.git.plugins.enabled }}
  {{- range .Values.git.plugins.repositories }}
- name: empty-dir
  mountPath: /opt/bitnami/airflow/plugins/git_{{ include "airflow.git.repository.name" . }}
  {{- if .path }}
  subPath: app-git-plugins-dir/{{ include "airflow.git.repository.name" . }}/{{ .path }}
  {{- else }}
  subPath: app-git-plugins-dir/{{ include "airflow.git.repository.name" . }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Returns the init container that will clone repositories files from a given list of git repositories
Usage:
{{ include "airflow.git.containers.clone" ( dict "securityContext" .Values.path.to.the.component.securityContext "context" $ ) }}
*/}}
{{- define "airflow.git.containers.clone" -}}
{{- if or .context.Values.git.dags.enabled .context.Values.git.plugins.enabled }}
- name: clone-repositories
  image: {{ include "git.image" .context | quote }}
  imagePullPolicy: {{ .context.Values.git.image.pullPolicy | quote }}
{{- if .securityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .securityContext "context" .context) | nindent 4 }}
{{- end }}
{{- if .context.Values.git.clone.resources }}
  resources: {{- toYaml .context.Values.git.clone.resources | nindent 4 }}
  {{- else if ne .context.Values.git.clone.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .context.Values.git.clone.resourcesPreset) | nindent 4 }}
{{- end }}
{{- if .context.Values.git.clone.command }}
  command: {{- include "common.tplvalues.render" (dict "value" .context.Values.git.clone.command "context" .context) | nindent 4 }}
{{- else }}
  command:
    - /bin/bash
{{- end }}
{{- if .context.Values.git.clone.args }}
  args: {{- include "common.tplvalues.render" (dict "value" .context.Values.git.clone.args "context" .context) | nindent 4 }}
{{- else }}
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/libfs.sh
      [[ -f "/opt/bitnami/scripts/git/entrypoint.sh" ]] && . /opt/bitnami/scripts/git/entrypoint.sh
    {{- if .context.Values.git.dags.enabled }}
      {{- range .context.Values.git.dags.repositories }}
      is_dir_empty "/dags/{{ include "airflow.git.repository.name" . }}" && git clone {{ .repository }} --branch {{ .branch }} /dags/{{ include "airflow.git.repository.name" . }}
      {{- end }}
    {{- end }}
    {{- if .context.Values.git.plugins.enabled }}
      {{- range .context.Values.git.plugins.repositories }}
      is_dir_empty "/plugins/{{ include "airflow.git.repository.name" . }}" && git clone {{ .repository }} --branch {{ .branch }} /plugins/{{ include "airflow.git.repository.name" . }}
      {{- end }}
    {{- end }}
{{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    - name: empty-dir
      mountPath: /etc/ssh
      subPath: etc-ssh-dir
    - name: empty-dir
      mountPath: /.ssh
      subPath: ssh-dir
    {{- include "airflow.git.volumeMounts" .context | trim | nindent 4 }}
  {{- if .context.Values.git.clone.extraVolumeMounts }}
    {{- include "common.tplvalues.render" (dict "value" .context.Values.git.clone.extraVolumeMounts "context" .context) | nindent 4 }}
  {{- end }}
{{- if .context.Values.git.clone.extraEnvVars }}
  env: {{- include "common.tplvalues.render" (dict "value" .context.Values.git.clone.extraEnvVars "context" .context) | nindent 4 }}
{{- end }}
{{- if or .context.Values.git.clone.extraEnvVarsCM .context.Values.git.clone.extraEnvVarsSecret }}
  envFrom:
    {{- if .context.Values.git.clone.extraEnvVarsCM }}
    - configMapRef:
        name: {{ .context.Values.git.clone.extraEnvVarsCM }}
    {{- end }}
    {{- if .context.Values.git.clone.extraEnvVarsSecret }}
    - secretRef:
        name: {{ .context.Values.git.clone.extraEnvVarsSecret }}
    {{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Returns the container that will pull and sync repositories files from a given list of git repositories
Usage:
{{ include "airflow.git.containers.sync" ( dict "securityContext" .Values.path.to.the.component.securityContext "context" $ ) }}
*/}}
{{- define "airflow.git.containers.sync" -}}
{{- if or .context.Values.git.dags.enabled .context.Values.git.plugins.enabled }}
- name: sync-repositories
  image: {{ include "git.image" .context | quote }}
  imagePullPolicy: {{ .context.Values.git.image.pullPolicy | quote }}
{{- if .securityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .securityContext "context" .context) | nindent 4 }}
{{- end }}
{{- if .context.Values.git.sync.resources }}
  resources: {{- toYaml .context.Values.git.sync.resources | nindent 4 }}
  {{- else if ne .context.Values.git.sync.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .context.Values.git.sync.resourcesPreset) | nindent 4 }}
{{- end }}
{{- if .context.Values.git.sync.command }}
  command: {{- include "common.tplvalues.render" (dict "value" .context.Values.git.sync.command "context" .context) | nindent 4 }}
{{- else }}
  command:
    - /bin/bash
{{- end }}
{{- if .context.Values.git.sync.args }}
  args: {{- include "common.tplvalues.render" (dict "value" .context.Values.git.sync.args "context" .context) | nindent 4 }}
{{- else }}
  args:
    - -ec
    - |
      [[ -f "/opt/bitnami/scripts/git/entrypoint.sh" ]] && . /opt/bitnami/scripts/git/entrypoint.sh
      while true; do
      {{- if .context.Values.git.dags.enabled }}
        {{- range .context.Values.git.dags.repositories }}
          cd /dags/{{ include "airflow.git.repository.name" . }} && git pull origin {{ .branch }} || true
        {{- end }}
      {{- end }}
      {{- if .context.Values.git.plugins.enabled }}
        {{- range .context.Values.git.plugins.repositories }}
          cd /plugins/{{ include "airflow.git.repository.name" . }} && git pull origin {{ .branch }} || true
        {{- end }}
      {{- end }}
          sleep {{ default "60" .context.Values.git.sync.interval }}
      done
{{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    - name: empty-dir
      mountPath: /etc/ssh
      subPath: etc-ssh-dir
    - name: empty-dir
      mountPath: /.ssh
      subPath: ssh-dir
    {{- include "airflow.git.volumeMounts" .context | trim | nindent 4 }}
  {{- if .context.Values.git.sync.extraVolumeMounts }}
    {{- include "common.tplvalues.render" (dict "value" .context.Values.git.sync.extraVolumeMounts "context" .context) | nindent 4 }}
  {{- end }}
{{- if .context.Values.git.sync.extraEnvVars }}
  env: {{- include "common.tplvalues.render" (dict "value" .context.Values.git.sync.extraEnvVars "context" .context) | nindent 4 }}
{{- end }}
{{- if or .context.Values.git.sync.extraEnvVarsCM .context.Values.git.sync.extraEnvVarsSecret }}
  envFrom:
    {{- if .context.Values.git.sync.extraEnvVarsCM }}
    - configMapRef:
        name: {{ .context.Values.git.sync.extraEnvVarsCM }}
    {{- end }}
    {{- if .context.Values.git.sync.extraEnvVarsSecret }}
    - secretRef:
        name: {{ .context.Values.git.sync.extraEnvVarsSecret }}
    {{- end }}
{{- end }}
{{- end }}
{{- end -}}
