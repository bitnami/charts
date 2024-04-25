{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Deepspeed client fullname
*/}}
{{- define "deepspeed.v0.client.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "client" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper deepspeed.v0.worker.fullname
*/}}
{{- define "deepspeed.v0.worker.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "worker" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Deepspeed client service account to use
*/}}
{{- define "deepspeed.v0.client.serviceAccountName" -}}
{{- if .Values.client.serviceAccount.create -}}
    {{ default (printf "%s" (include "deepspeed.v0.client.fullname" .)) .Values.client.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.client.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Name of the Deepspeed worker service account to use
*/}}
{{- define "deepspeed.v0.worker.serviceAccountName" -}}
{{- if .Values.worker.serviceAccount.create -}}
    {{ default (printf "%s" (include "deepspeed.v0.worker.fullname" .)) .Values.worker.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.worker.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Return the proper Deepspeed image name
*/}}
{{- define "deepspeed.v0.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper git image name
*/}}
{{- define "deepspeed.v0.git.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.gitImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "deepspeed.v0.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Get the hostfile configmap.
*/}}
{{- define "deepspeed.v0.hostfileConfigMapName" -}}
{{- if .Values.config.existingHostFileConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.config.existingHostFileConfigMap "context" $) -}}
{{- else }}
    {{- printf "%s-hosts" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the ssh client configmap.
*/}}
{{- define "deepspeed.v0.ssh.clientConfigMapName" -}}
{{- if .Values.config.existingSSHClientConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.config.existingSSHClientConfigMap "context" $) -}}
{{- else }}
    {{- printf "%s-ssh-client" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the ssh worker configmap.
*/}}
{{- define "deepspeed.v0.ssh.serverConfigMapName" -}}
{{- if .Values.config.existingSSHServerConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.config.existingSSHServerConfigMap "context" $) -}}
{{- else }}
    {{- printf "%s-ssh-server" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the source configmap.
*/}}
{{- define "deepspeed.v0.source.configMapName" -}}
{{- if .Values.source.existingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.source.existingConfigMap "context" $) -}}
{{- else }}
    {{- printf "%s-source" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the ssh key secret.
*/}}
{{- define "deepspeed.v0.ssh.keySecretName" -}}
{{- if .Values.config.existingSSHKeySecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.config.existingSSHKeySecret "context" $) -}}
{{- else }}
    {{- printf "%s-ssh-key" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "deepspeed.v0.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.gitImage .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return true if the source configmap should be created
*/}}
{{- define "deepspeed.v0.source.createConfigMap" -}}
{{- if and .Values.client.enabled (eq .Values.source.type "configmap") .Values.source.configMap (not .Values.source.existingConfigMap) -}}
{{- true -}}
{{- end }}
{{- end -}}

{{/*
Return the definition of wait for workers init container
*/}}
{{- define "deepspeed.v0.client.waitForWorkers" -}}
- name: wait-for-workers
  image: {{ include "deepspeed.v0.image" . }}
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
        {{ include "deepspeed.v0.worker.fullname" $ }}-{{ $i }}.{{ printf "%s-headless" (include "deepspeed.v0.worker.fullname" $) }}
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
  {{- if .Values.client.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.client.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: ssh-client-config
      mountPath: /etc/ssh/ssh_config.d/deepspeed_ssh_client.conf
      subPath: deepspeed_ssh_client.conf
    - name: empty-dir
      mountPath: /etc/ssh/ssh_config
      subPath: ssh-conf-dir/ssh_config
    - name: ssh-client-private-key
      mountPath: /bitnami/ssh/client-private-key
    - name: empty-dir
      mountPath: /home/deepspeed/.ssh
      subPath: app-ssh-dir
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}

{{/*
Return the definition of the ssh client configuration init container
*/}}
{{- define "deepspeed.v0.ssh.clientInitContainer" -}}
- name: ssh-client-configure
  image: {{ include "deepspeed.v0.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      # HACK: Depending on the OS, the ssh version may not have support for
      # /etc/ssh/ssh_config.d. Therefore, we need to copy the ssh_config
      # to a volume and perform modifications to include the configuration
      # from the ConfigMap, as it will not be read
      [[ -f "/opt/bitnami/scripts/deepspeed/entrypoint.sh" ]] && source "/opt/bitnami/scripts/deepspeed/entrypoint.sh"
      cp /etc/ssh/ssh_config /bitnami/ssh/ssh-config
      if [[ ! -d /etc/ssh/ssh_config.d ]]; then
        # Older version of ssh, add the include directive
        echo "Modifying ssh_config with include directive"
        echo "Include /etc/ssh/ssh_config.d/*.conf" >> /bitnami/ssh/ssh-config/ssh_config
      fi
  {{- if .Values.client.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.client.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /bitnami/ssh/ssh-config
      subPath: ssh-conf-dir
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}

{{/*
Return the definition of the ssh server configuration init container
*/}}
{{- define "deepspeed.v0.ssh.serverInitContainer" -}}
- name: ssh-server-configure
  image: {{ include "deepspeed.v0.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      [[ -f "/opt/bitnami/scripts/deepspeed/entrypoint.sh" ]] && source "/opt/bitnami/scripts/deepspeed/entrypoint.sh"
      echo "Obtaining public key and generating authorized_keys file"
      mkdir -p /home/deepspeed/.ssh
      ssh-keygen -y -f /bitnami/ssh/client-private-key/id_rsa > /home/deepspeed/.ssh/authorized_keys
      # Create user environment file so the container env vars are included
      echo "C_INCLUDE_PATH=$C_INCLUDE_PATH" >> /home/deepspeed/.ssh/environment
      echo "CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH" >> /home/deepspeed/.ssh/environment
      echo "PATH=$PATH" >> /home/deepspeed/.ssh/environment
      echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >> /home/deepspeed/.ssh/environment
      echo "CFLAGS=$CFLAGS" >> /home/deepspeed/.ssh/environment
      echo "CPPFLAGS=$CPPFLAGS" >> /home/deepspeed/.ssh/environment
      echo "LDFLAGS=$LDFLAGS" >> /home/deepspeed/.ssh/environment
      chmod 700 /home/deepspeed/.ssh
      chmod 600 /home/deepspeed/.ssh/authorized_keys
      ssh-keygen -A -f /bitnami/ssh/server-private-key/

      replace_in_file() {
          local filename="${1:?filename is required}"
          local match_regex="${2:?match regex is required}"
          local substitute_regex="${3:?substitute regex is required}"
          local posix_regex=${4:-true}

          local result

          # We should avoid using 'sed in-place' substitutions
          # 1) They are not compatible with files mounted from ConfigMap(s)
          # 2) We found incompatibility issues with Debian10 and "in-place" substitutions
          local -r del=$'\001' # Use a non-printable character as a 'sed' delimiter to avoid issues
          if [[ $posix_regex = true ]]; then
              result="$(sed -E "s${del}${match_regex}${del}${substitute_regex}${del}g" "$filename")"
          else
              result="$(sed "s${del}${match_regex}${del}${substitute_regex}${del}g" "$filename")"
          fi
          echo "$result" > "$filename"
      }

      # HACK: Depending on the OS, the ssh version may not have support for
      # /etc/ssh/sshd_config.d. Therefore, we need to copy the sshd_config
      # to a volume and perform modifications to include the configuration
      # from the ConfigMap. The sshd_config file does not allow the
      # Include directive, so we need to append the configuration
      cp /etc/ssh/sshd_config /bitnami/ssh/sshd-config
      if [[ ! -d /etc/ssh/sshd_config.d ]]; then
        # Older version of ssh, merge the contents
        while read -r line; do
          read -a entry <<< $line
          key="${entry[0]}"
          value="${entry[1]}"
          if grep -q "${entry[0]}" /bitnami/ssh/sshd-config/sshd_config; then
            echo "Replacing ${entry[*]} in sshd_config file"
            replace_in_file /bitnami/ssh/sshd-config/sshd_config "^[#]*${entry[0]}.*" "${entry[*]}"
          else
            echo "Adding ${entry[*]} in sshd_config file"
            echo "${entry[*]}" >> /bitnami/ssh/sshd-config/sshd_config
          fi
        done < /bitnami/ssh/server-configmap/*.conf
      fi
  {{- if .Values.worker.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.worker.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: ssh-client-private-key
      mountPath: /bitnami/ssh/client-private-key
    # ssh-keygen -A forces /etc/ssh in the prefix path
    - name: empty-dir
      mountPath: /bitnami/ssh/server-private-key/etc/ssh
      subPath: app-worker-private-key-dir
    - name: ssh-server-config
      mountPath: /bitnami/ssh/server-configmap
    - name: empty-dir
      mountPath: /bitnami/ssh/sshd-config
      subPath: sshd-conf-dir
    - name: empty-dir
      mountPath: /home
      subPath: home-dir
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}


{{/*
Return the definition of the git clone init container
*/}}
{{- define "deespeed.git.cloneInitContainer" -}}
{{- $block := index .context.Values .component }}
- name: git-clone-repository
  image: {{ include "deepspeed.v0.git.image" .context }}
  imagePullPolicy: {{ .context.Values.gitImage.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      rm -rf /app/*
      [[ -f "/opt/bitnami/scripts/git/entrypoint.sh" ]] && source "/opt/bitnami/scripts/git/entrypoint.sh"
      git clone {{ .context.Values.source.git.repository }} {{ if .context.Values.source.git.revision }}--branch {{ .context.Values.source.git.revision }}{{ end }} /app
  {{- if $block.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" $block.containerSecurityContext "context" .context) | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: source
      mountPath: /app
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    # It creates at startup ssh in case it performs ssh-based git clone
    - name: empty-dir
      mountPath: /etc/ssh
      subPath: etc-ssh-dir
  {{- if .context.Values.source.git.extraVolumeMounts }}
    {{- include "common.tplvalues.render" (dict "value" .context.Values.source.git.extraVolumeMounts "context" .context) | nindent 12 }}
  {{- end }}
{{- end -}}

{{/*
Return the volume-permissions init container
*/}}
{{- define "deepspeed.v0.volumePermissionsInitContainer" -}}
{{- $block := index .context.Values .component }}
- name: volume-permissions
  image: {{ include "deepspeed.v0.volumePermissions.image" .context }}
  imagePullPolicy: {{ default "" .context.Values.volumePermissions.image.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      mkdir -p {{ $block.persistence.mountPath }}
      chown {{ $block.containerSecurityContext.runAsUser }}:{{ $block.podSecurityContext.fsGroup }} {{ $block.persistence.mountPath }}
      find {{ $block.client.persistence.mountPath }} -mindepth 1 -maxdepth 1 -not -name ".snapshot" -not -name "lost+found" | xargs chown -R {{ $block.containerSecurityContext.runAsUser }}:{{ $block.podSecurityContext.fsGroup }}
  securityContext:
    runAsUser: 0
  {{- if .context.Values.volumePermissions.resources }}
  resources: {{- toYaml .context.Values.volumePermissions.resources | nindent 12 }}
  {{- else if ne .context.Values.volumePermissions.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .context.Values.volumePermissions.resourcesPreset) | nindent 12 }}
  {{- end }}
  volumeMounts:
    - name: data
      mountPath: {{ $block.persistence.mountPath }}
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "deepspeed.v0.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "deepspeed.v0.validateValues.job" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}


{{/* Check if there are rolling tags in the images */}}
{{- define "deepspeed.v0.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image -}}
{{- include "common.warnings.rollingTag" .Values.gitImage -}}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image -}}
{{- end -}}

{{/* Check that a command has been defined when using a job */}}
{{- define "deepspeed.v0.validateValues.job" -}}
{{- if and .Values.client.useJob (not .Values.source.launchCommand) (not .Values.client.args) }}
deepspeed: no-job-command

You defined deepspeed to be launched as a job but specified no command. Use the source.launchCommand value
to specify a command.
{{- end -}}
{{- end -}}
