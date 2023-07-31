{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Deepspeed client fullname
*/}}
{{- define "deepspeed.client.fullname.v1" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "client" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Deepspeed worker fullname
*/}}
{{- define "deepspeed.worker.fullname.v1" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "worker" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Deepspeed client service account to use
*/}}
{{- define "deepspeed.client.serviceAccountName.v1" -}}
{{- if .Values.client.serviceAccount.create -}}
    {{ default (printf "%s" (include "deepspeed.client.fullname.v1" .)) .Values.client.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.client.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Name of the Deepspeed worker service account to use
*/}}
{{- define "deepspeed.worker.serviceAccountName.v1" -}}
{{- if .Values.worker.serviceAccount.create -}}
    {{ default (printf "%s" (include "deepspeed.worker.fullname.v1" .)) .Values.worker.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.worker.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Return the proper Deepspeed image name
*/}}
{{- define "deepspeed.image.v1" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper git image name
*/}}
{{- define "deepspeed.git.image.v1" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.gitImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "deepspeed.volumePermissions.image.v1" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Get the hostfile configmap.
*/}}
{{- define "deepspeed.hostfileConfigMapName.v1" -}}
{{- if .Values.config.existingHostFileConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.config.existingHostFileConfigMap "context" $) -}}
{{- else }}
    {{- printf "%s-hosts" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the ssh client configmap.
*/}}
{{- define "deepspeed.ssh.clientConfigMapName.v1" -}}
{{- if .Values.config.existingSSHClientConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.config.existingSSHClientConfigMap "context" $) -}}
{{- else }}
    {{- printf "%s-ssh-client" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the ssh worker configmap.
*/}}
{{- define "deepspeed.ssh.serverConfigMapName.v1" -}}
{{- if .Values.config.existingSSHServerConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.config.existingSSHServerConfigMap "context" $) -}}
{{- else }}
    {{- printf "%s-ssh-server" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the source configmap.
*/}}
{{- define "deepspeed.sourceConfigMapName.v1" -}}
{{- if .Values.source.existingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.source.existingConfigMap "context" $) -}}
{{- else }}
    {{- printf "%s-source" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the ssh key secret.
*/}}
{{- define "deepspeed.ssh.keySecretName.v1" -}}
{{- if .Values.config.existingSSHKeySecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.config.existingSSHKeySecret "context" $) -}}
{{- else }}
    {{- printf "%s-ssh-key" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "deepspeed.imagePullSecrets.v1" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.gitImage .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return true if the source configmap should be created
*/}}
{{- define "deepspeed.source.createConfigMap.v1" -}}
{{- if and .Values.client.enabled (eq .Values.source.type "configmap") .Values.source.configMap (not .Values.source.existingConfigMap) -}}
{{- true -}}
{{- end }}
{{- end -}}

{{/*
Return the definition of wait for workers init container
*/}}
{{- define "deepspeed.client.waitForWorkers.v1" -}}
- name: wait-for-workers
  image: {{ include "deepspeed.image.v1" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      worker_hosts=(
      {{- $workers := .Values.worker.replicaCount | int }}
      {{- range $i, $e := until $workers }}
        {{ include "deepspeed.worker.fullname.v1" $ }}-{{ $i }}.{{ printf "%s-headless" (include "deepspeed.worker.fullname.v1" $) }}
      {{- end }}
      )

      check_worker() {
          local -r worker_host="${1:-?missing host}"
          if ssh "$worker_host" "echo OK"; then
             return 0
          else
             return 1
          fi
      }

      [[ -f "/opt/bitnami/scripts/deepspeed/entrypoint.sh" ]] && source "/opt/bitnami/scripts/deepspeed/entrypoint.sh"

      for host in "${worker_hosts[@]}"; do
          echo "Checking connection to $host"
          if retry_while "check_worker $host"; then
              echo "Connected to $host"
          else
              echo "Error connecting to $host"
              exit 1
          fi
      done

      echo "Connection success"
      exit 0

  volumeMounts:
    - name: ssh-client-config
      mountPath: /etc/ssh/ssh_config.d/deepspeed_ssh_client.conf
      subPath: deepspeed_ssh_client.conf
    - name: ssh-client-private-key
      mountPath: /bitnami/ssh/client-private-key
    - name: ssh-local-folder
      mountPath: /home/deepspeed/.ssh
{{- end -}}

{{/*
Return the definition of the ssh server configuration init container
*/}}
{{- define "deepspeed.ssh.serverInitContainer.v1" -}}
- name: ssh-server-configure
  image: {{ include "deepspeed.image.v1" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      echo "Obtaining public key and generating authorized_keys file"
      mkdir -p /home/deepspeed/.ssh
      ssh-keygen -y -f /bitnami/ssh/client-private-key/id_rsa > /home/deepspeed/.ssh/authorized_keys
      # Create user environment file so the container env vars are included
      echo "C_INCLUDE_PATH=$C_INCLUDE_PATH" >> /home/deepspeed/.ssh/environment
      echo "CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH" >> /home/deepspeed/.ssh/environment
      echo "PATH=$PATH" >> /home/deepspeed/.ssh/environment
      chmod 700 /home/deepspeed/.ssh
      chmod 600 /home/deepspeed/.ssh/authorized_keys
      ssh-keygen -A -f /bitnami/ssh/server-private-key/
  volumeMounts:
    - name: ssh-client-private-key
      mountPath: /bitnami/ssh/client-private-key
    # ssh-keygen -A forces /etc/ssh in the prefix path
    - name: ssh-worker-private-key
      mountPath: /bitnami/ssh/server-private-key/etc/ssh
    - name: worker-home
      mountPath: /home/
{{- end -}}


{{/*
Return the definition of the git clone init container
*/}}
{{- define "deespeed.git.cloneInitContainer.v1" -}}
- name: git-clone-repository
  image: {{ include "deepspeed.git.image.v1" . }}
  imagePullPolicy: {{ .Values.gitImage.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      [[ -f "/opt/bitnami/scripts/git/entrypoint.sh" ]] && source "/opt/bitnami/scripts/git/entrypoint.sh"
      git clone {{ .Values.source.git.repository }} {{ if .Values.source.git.revision }}--branch {{ .Values.source.git.revision }}{{ end }} /app
  volumeMounts:
    - name: source
      mountPath: /app
  {{- if .Values.source.git.extraVolumeMounts }}
    {{- include "common.tplvalues.render" (dict "value" .Values.source.git.extraVolumeMounts "context" $) | nindent 12 }}
  {{- end }}
{{- end -}}

{{/*
Return the volume-permissions init container
*/}}
{{- define "deepspeed.volumePermissionsInitContainer.v1" -}}
- name: volume-permissions
  image: {{ include "deepspeed.volumePermissions.image.v1" . }}
  imagePullPolicy: {{ default "" .Values.volumePermissions.image.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      mkdir -p {{ .Values.client.persistence.mountPath }}
      chown {{ .Values.client.containerSecurityContext.runAsUser }}:{{ .Values.client.podSecurityContext.fsGroup }} {{ .Values.persistence.mountPath }}
      find {{ .Values.client.persistence.mountPath }} -mindepth 1 -maxdepth 1 -not -name ".snapshot" -not -name "lost+found" | xargs chown -R {{ .Values.client.containerSecurityContext.runAsUser }}:{{ .Values.client.podSecurityContext.fsGroup }}
  securityContext:
    runAsUser: 0
  {{- if .Values.volumePermissions.resources }}
  resources: {{- toYaml .Values.volumePermissions.resources | nindent 12 }}
  {{- end }}
  volumeMounts:
    - name: data
      mountPath: {{ .Values.client.persistence.mountPath }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "deepspeed.validateValues.v1" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "deepspeed.validateValues.job.v1" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}


{{/* Check if there are rolling tags in the images */}}
{{- define "deepspeed.checkRollingTags.v1" -}}
{{- include "common.warnings.rollingTag" .Values.image -}}
{{- include "common.warnings.rollingTag" .Values.gitImage -}}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image -}}
{{- end -}}

{{/* Check that a command has been defined when using a job */}}
{{- define "deepspeed.validateValues.job.v1" -}}
{{- if and .Values.client.useJob (not .Values.source.launchCommand) (not .Values.client.args) }}
deepspeed: no-job-command

You defined deepspeed to be launched as a job but specified no command. Use the source.launchCommand value
to specify a command.
{{- end -}}
{{- end -}}
