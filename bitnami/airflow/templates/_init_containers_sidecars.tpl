{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Returns an init-container that prepares the Airflow configuration files for main containers to use them
*/}}
{{- define "airflow.defaultInitContainers.prepareConfig" -}}
- name: prepare-config
  image: {{ include "airflow.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.defaultInitContainers.prepareConfig.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.defaultInitContainers.prepareConfig.containerSecurityContext "context" .) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultInitContainers.prepareConfig.resources }}
  resources: {{- toYaml .Values.defaultInitContainers.prepareConfig.resources | nindent 4 }}
  {{- else if ne .Values.defaultInitContainers.prepareConfig.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.defaultInitContainers.prepareConfig.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/libairflow.sh

      mkdir -p /emptydir/app-base-dir /emptydir/app-conf-dir

      # Copy the configuration files to the writable directory
      cp /opt/bitnami/airflow/airflow.cfg /emptydir/app-base-dir/airflow.cfg

      # Apply changes affecting credentials
      export AIRFLOW_CONF_FILE="/emptydir/app-base-dir/airflow.cfg"
    {{- if (include "airflow.database.useSqlConnection" .) }}
      airflow_conf_set "database" "sql_alchemy_conn" "$AIRFLOW_DATABASE_SQL_CONN"
    {{- else }}
      db_user="$(airflow_encode_url "$AIRFLOW_DATABASE_USERNAME")"
      db_password="$(airflow_encode_url "$AIRFLOW_DATABASE_PASSWORD")"
      airflow_conf_set "database" "sql_alchemy_conn" "postgresql+psycopg2://${db_user}:${db_password}@${AIRFLOW_DATABASE_HOST}:${AIRFLOW_DATABASE_PORT_NUMBER}/${AIRFLOW_DATABASE_NAME}"
    {{- end }}
    {{- if or (eq .Values.executor "CeleryExecutor") (eq .Values.executor "CeleryKubernetesExecutor") }}
      redis_credentials=":$(airflow_encode_url "$REDIS_PASSWORD")"
      [[ -n "$REDIS_USER" ]] && redis_credentials="$(airflow_encode_url "$REDIS_USER")$redis_credentials"
    {{- if (include "airflow.database.useSqlConnection" .) }}
      airflow_conf_set "celery" "result_backend" "db+${AIRFLOW_DATABASE_SQL_CONN}"
    {{- else }}
      airflow_conf_set "celery" "result_backend" "db+postgresql://${db_user}:${db_password}@${AIRFLOW_DATABASE_HOST}:${AIRFLOW_DATABASE_PORT_NUMBER}/${AIRFLOW_DATABASE_NAME}"
    {{- end }}
      airflow_conf_set "celery" "broker_url" "redis://${redis_credentials}@${REDIS_HOST}:${REDIS_PORT_NUMBER}/${REDIS_DATABASE}"
    {{- end }}
      info "Airflow configuration ready"

      if [[ -f "/opt/bitnami/airflow/config/airflow_local_settings.py" ]]; then
          cp /opt/bitnami/airflow/config/airflow_local_settings.py /emptydir/app-conf-dir/airflow_local_settings.py
      else
          touch /emptydir/app-conf-dir/airflow_local_settings.py
      fi

      # HACK: When testing the db connection it creates an empty airflow.db file at the
      # application root
      touch /emptydir/app-base-dir/airflow.db
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.image.debug .Values.diagnosticMode.enabled) | quote }}
    {{- if (include "airflow.database.useSqlConnection" .) }}
    - name: AIRFLOW_DATABASE_SQL_CONN
      valueFrom:
        secretKeyRef:
          name: {{ include "airflow.database.secretName" . }}
          key: {{ include "airflow.database.secretKey" . }}
    {{- else }}
    - name: AIRFLOW_DATABASE_NAME
      value: {{ include "airflow.database.name" . }}
    - name: AIRFLOW_DATABASE_USERNAME
      value: {{ include "airflow.database.user" . }}
    - name: AIRFLOW_DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "airflow.database.secretName" . }}
          key: {{ include "airflow.database.secretKey" . }}
    - name: AIRFLOW_DATABASE_HOST
      value: {{ include "airflow.database.host" . }}
    - name: AIRFLOW_DATABASE_PORT_NUMBER
      value: {{ include "airflow.database.port" . }}
    {{- end }}
    {{- if or (eq .Values.executor "CeleryExecutor") (eq .Values.executor "CeleryKubernetesExecutor") }}
    - name: REDIS_HOST
      value: {{ include "airflow.redis.host" . | quote }}
    - name: REDIS_PORT_NUMBER
      value: {{ include "airflow.redis.port" . | quote }}
    {{- if and (not .Values.redis.enabled) .Values.externalRedis.username }}
    - name: REDIS_USER
      value: {{ .Values.externalRedis.username | quote }}
    {{- end }}
    - name: REDIS_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "airflow.redis.secretName" . }}
          key: redis-password
    {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /emptydir
    - name: configuration
      mountPath: /opt/bitnami/airflow/airflow.cfg
      subPath: airflow.cfg
    - name: configuration
      mountPath: /opt/bitnami/airflow/config/airflow_local_settings.py
      subPath: airflow_local_settings.py
{{- end -}}

{{/*
Returns an init-container that prepares the Airflow Webserver configuration files for main containers to use them
*/}}
{{- define "airflow.defaultInitContainers.prepareWebConfig" -}}
- name: prepare-web-config
  image: {{ include "airflow.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.defaultInitContainers.prepareConfig.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.defaultInitContainers.prepareConfig.containerSecurityContext "context" .) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultInitContainers.prepareConfig.resources }}
  resources: {{- toYaml .Values.defaultInitContainers.prepareConfig.resources | nindent 4 }}
  {{- else if ne .Values.defaultInitContainers.prepareConfig.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.defaultInitContainers.prepareConfig.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/libairflow.sh

      # Copy the configuration files to the writable directory
      cp /opt/bitnami/airflow/webserver_config.py /emptydir/app-base-dir/webserver_config.py
    {{- if .Values.ldap.enabled }}
      export AIRFLOW_WEBSERVER_CONF_FILE="/emptydir/app-base-dir/webserver_config.py"
      airflow_webserver_conf_set "AUTH_LDAP_BIND_PASSWORD" "$AIRFLOW_LDAP_BIND_PASSWORD" "yes"
    {{- end }}
      info "Airflow webserver configuration ready"
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.image.debug .Values.diagnosticMode.enabled) | quote }}
    {{- if .Values.ldap.enabled }}
    - name: AIRFLOW_LDAP_BIND_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "airflow.ldap.secretName" . }}
          key: bind-password
    {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /emptydir
    - name: webserver-configuration
      mountPath: /opt/bitnami/airflow/webserver_config.py
      subPath: webserver_config.py
{{- end -}}

{{/*
Returns an init-container that waits for db migrations to be ready
*/}}
{{- define "airflow.defaultInitContainers.waitForDBMigrations" -}}
- name: wait-for-db-migrations
  image: {{ include "airflow.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.defaultInitContainers.waitForDBMigrations.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.defaultInitContainers.waitForDBMigrations.containerSecurityContext "context" .) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultInitContainers.waitForDBMigrations.resources }}
  resources: {{- toYaml .Values.defaultInitContainers.waitForDBMigrations.resources | nindent 4 }}
  {{- else if ne .Values.defaultInitContainers.waitForDBMigrations.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.defaultInitContainers.waitForDBMigrations.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/airflow-env.sh
      . /opt/bitnami/scripts/libairflow.sh

      info "Waiting for db migrations to be completed"
      airflow_wait_for_db_migrations
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.image.debug .Values.diagnosticMode.enabled) | quote }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    - name: empty-dir
      mountPath: /opt/bitnami/airflow/logs
      subPath: app-logs-dir
    - name: empty-dir
      mountPath: /opt/bitnami/airflow/tmp
      subPath: app-tmp-dir
    - name: empty-dir
      mountPath: /opt/bitnami/airflow/airflow.db
      subPath: app-base-dir/airflow.db
    - name: empty-dir
      mountPath: /opt/bitnami/airflow/airflow.cfg
      subPath: app-base-dir/airflow.cfg
    {{- if .Values.extraVolumeMounts }}
    {{- include "common.tplvalues.render" (dict "value" .Values.extraVolumeMounts "context" $) | nindent 4 }}
    {{- end }}
{{- end -}}

{{/*
Returns the name that will identify the repository internally and it will be used to
create folders or volume names
*/}}
{{- define "airflow.dagsPlugins.repository.name" -}}
  {{- $defaultName := regexFind "/.*$" .repository | replace "//" "" | replace "/" "-" | replace "." "-" -}}
  {{- .name | default $defaultName | kebabcase -}}
{{- end -}}

{{/*
Returns shared structure between load-dags and load-plugins init containers
*/}}
{{- define "airflow.defaultInitContainers.shared" -}}
- image: {{ include "airflow.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.defaultInitContainers.loadDAGsPlugins.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.defaultInitContainers.loadDAGsPlugins.containerSecurityContext "context" .) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultInitContainers.loadDAGsPlugins.resources }}
  resources: {{- toYaml .Values.defaultInitContainers.loadDAGsPlugins.resources | nindent 4 }}
  {{- else if ne .Values.defaultInitContainers.loadDAGsPlugins.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.defaultInitContainers.loadDAGsPlugins.resourcesPreset) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultInitContainers.loadDAGsPlugins.command }}
  command: {{- include "common.tplvalues.render" (dict "value" .Values.defaultInitContainers.loadDAGsPlugins.command "context" .) | nindent 4 }}
  {{- else }}
  command: ["/bin/bash"]
  {{- end }}
  {{- if .Values.defaultInitContainers.loadDAGsPlugins.extraEnvVars }}
  env: {{- include "common.tplvalues.render" (dict "value" .Values.defaultInitContainers.loadDAGsPlugins.extraEnvVars "context" .) | nindent 4 }}
  {{- end }}
  {{- if or .Values.defaultInitContainers.loadDAGsPlugins.extraEnvVarsCM .Values.defaultInitContainers.loadDAGsPlugins.extraEnvVarsSecret }}
  envFrom:
    {{- if .Values.defaultInitContainers.loadDAGsPlugins.extraEnvVarsCM }}
    - configMapRef:
        name: {{ .Values.defaultInitContainers.loadDAGsPlugins.extraEnvVarsCM }}
    {{- end }}
    {{- if .Values.defaultInitContainers.loadDAGsPlugins.extraEnvVarsSecret }}
    - secretRef:
        name: {{ .Values.defaultInitContainers.loadDAGsPlugins.extraEnvVarsSecret }}
    {{- end }}
  {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    - name: empty-dir
      mountPath: /opt/bitnami/airflow/nss-wrapper
      subPath: app-nss-wrapper-dir
    - name: empty-dir
      mountPath: /etc/ssh
      subPath: etc-ssh-dir
    - name: empty-dir
      mountPath: /opt/bitnami/airflow/.ssh
      subPath: ssh-dir
    {{- if .Values.defaultInitContainers.loadDAGsPlugins.extraVolumeMounts }}
    {{- include "common.tplvalues.render" (dict "value" .Values.defaultInitContainers.loadDAGsPlugins.extraVolumeMounts "context" $) | nindent 4 }}
    {{- end }}
{{- end -}}

{{/*
Returns an init-container that loads DAGs from a ConfigMap or Git repositories
*/}}
{{- define "airflow.defaultInitContainers.loadDAGs" -}}
{{ include "airflow.defaultInitContainers.shared" . }}
    {{- if not (empty .Values.dags.existingConfigmap) }}
    - name: external-dags
      mountPath: /configmap
    {{- end }}
    {{- if or (not (empty .Values.dags.existingConfigmap)) (not (empty .Values.dags.repositories)) }}
    - name: empty-dir
      mountPath: /dags
      subPath: app-dags-dir
    {{- end }}
    {{- if or .Values.dags.sshKey .Values.dags.existingSshKeySecret }}
    - name: dags-ssh-key
      mountPath: /opt/bitnami/airflow/.ssh/dags-ssh-key
      subPath: dags-ssh-key
    {{- end }}
  {{- if .Values.defaultInitContainers.loadDAGsPlugins.args }}
  args: {{- include "common.tplvalues.render" (dict "value" .Values.defaultInitContainers.loadDAGsPlugins.args "context" .) | nindent 4 }}
  {{- else }}
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/libfs.sh
      . /opt/bitnami/scripts/libos.sh

      if ! am_i_root && [[ -e "$LIBNSS_WRAPPER_PATH" ]]; then
          echo "airflow:x:$(id -u):$(id -g):Airflow:$AIRFLOW_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
          echo "airflow:x:$(id -g):" > "$NSS_WRAPPER_GROUP"

          export LD_PRELOAD="$LIBNSS_WRAPPER_PATH"
          export HOME="$AIRFLOW_HOME"
      fi

    {{- if or .Values.dags.sshKey .Values.dags.existingSshKeySecret }}
      export GIT_SSH_COMMAND="ssh -i /opt/bitnami/airflow/.ssh/dags-ssh-key -o StrictHostKeyChecking=no"
    {{- end }}
    {{- range .Values.dags.repositories }}
      is_dir_empty "/dags/{{ include "airflow.dagsPlugins.repository.name" . }}" && git clone {{ .repository }} --depth 1 --branch {{ .branch }} /dags/{{ include "airflow.dagsPlugins.repository.name" . }}
    {{- end }}
    {{- if not (empty .Values.dags.existingConfigmap) }}
      mkdir -p /dags/external
      cp -v /configmap/* /dags/external
    {{- end }}
  {{- end }}
  name: load-dags
{{- end -}}

{{/*
Returns an init-container that loads plugins from  Git repositories
*/}}
{{- define "airflow.defaultInitContainers.loadPlugins" -}}
{{ include "airflow.defaultInitContainers.shared" . }}
    - name: empty-dir
      mountPath: /plugins
      subPath: app-plugins-dir
    {{- if or .Values.plugins.sshKey .Values.plugins.existingSshKeySecret }}
    - name: plugins-ssh-key
      mountPath: /opt/bitnami/airflow/.ssh/plugins-ssh-key
      subPath: plugins-ssh-key
    {{- end }}
  {{- if .Values.defaultInitContainers.loadDAGsPlugins.args }}
  args: {{- include "common.tplvalues.render" (dict "value" .Values.defaultInitContainers.loadDAGsPlugins.args "context" .) | nindent 4 }}
  {{- else }}
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/libfs.sh
      . /opt/bitnami/scripts/libos.sh

      if ! am_i_root && [[ -e "$LIBNSS_WRAPPER_PATH" ]]; then
          echo "airflow:x:$(id -u):$(id -g):Airflow:$AIRFLOW_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
          echo "airflow:x:$(id -g):" > "$NSS_WRAPPER_GROUP"

          export LD_PRELOAD="$LIBNSS_WRAPPER_PATH"
          export HOME="$AIRFLOW_HOME"
      fi

    {{- if or .Values.plugins.sshKey .Values.plugins.existingSshKeySecret }}
      export GIT_SSH_COMMAND="ssh -i /opt/bitnami/airflow/.ssh/plugins-ssh-key -o StrictHostKeyChecking=no"
    {{- end }}
    {{- range .Values.plugins.repositories }}
      is_dir_empty "/plugins/{{ include "airflow.dagsPlugins.repository.name" . }}" && git clone {{ .repository }} --depth 1 --branch {{ .branch }} /plugins/{{ include "airflow.dagsPlugins.repository.name" . }}
    {{- end }}
  {{- end }}
  name: load-plugins
{{- end -}}

{{/*
Returns shared structure between sync-dags and sync-plugins sidecars
*/}}
{{- define "airflow.defaultSidecars.shared" -}}
- image: {{ include "airflow.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.defaultSidecars.syncDAGsPlugins.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.defaultSidecars.syncDAGsPlugins.containerSecurityContext "context" .) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultSidecars.syncDAGsPlugins.resources }}
  resources: {{- toYaml .Values.defaultSidecars.syncDAGsPlugins.resources | nindent 4 }}
  {{- else if ne .Values.defaultSidecars.syncDAGsPlugins.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.defaultSidecars.syncDAGsPlugins.resourcesPreset) | nindent 4 }}
  {{- end }}
  {{- if .Values.defaultSidecars.syncDAGsPlugins.command }}
  command: {{- include "common.tplvalues.render" (dict "value" .Values.defaultSidecars.syncDAGsPlugins.command "context" .) | nindent 4 }}
  {{- else }}
  command: ["/bin/bash"]
  {{- end }}
  {{- if .Values.defaultSidecars.syncDAGsPlugins.extraEnvVars }}
  env: {{- include "common.tplvalues.render" (dict "value" .Values.defaultSidecars.syncDAGsPlugins.extraEnvVars "context" .) | nindent 4 }}
  {{- end }}
  {{- if or .Values.defaultSidecars.syncDAGsPlugins.extraEnvVarsCM .Values.defaultSidecars.syncDAGsPlugins.extraEnvVarsSecret }}
  envFrom:
    {{- if .Values.defaultSidecars.syncDAGsPlugins.extraEnvVarsCM }}
    - configMapRef:
        name: {{ .Values.defaultSidecars.syncDAGsPlugins.extraEnvVarsCM }}
    {{- end }}
    {{- if .Values.defaultSidecars.syncDAGsPlugins.extraEnvVarsSecret }}
    - secretRef:
        name: {{ .Values.defaultSidecars.syncDAGsPlugins.extraEnvVarsSecret }}
    {{- end }}
  {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    - name: empty-dir
      mountPath: /opt/bitnami/airflow/nss-wrapper
      subPath: app-nss-wrapper-dir
    - name: empty-dir
      mountPath: /etc/ssh
      subPath: etc-ssh-dir
    - name: empty-dir
      mountPath: /opt/bitnami/airflow/.ssh
      subPath: ssh-dir
    {{- if .Values.defaultSidecars.syncDAGsPlugins.extraVolumeMounts }}
    {{- include "common.tplvalues.render" (dict "value" .Values.defaultSidecars.syncDAGsPlugins.extraVolumeMounts "context" $) | nindent 4 }}
    {{- end }}
{{- end -}}

{{/*
Returns a sidecar that syncs DAGs from Git repositories
*/}}
{{- define "airflow.defaultSidecars.syncDAGs" -}}
{{ include "airflow.defaultSidecars.shared" . }}
    - name: empty-dir
      mountPath: /dags
      subPath: app-dags-dir
    {{- if or .Values.dags.sshKey .Values.dags.existingSshKeySecret }}
    - name: dags-ssh-key
      mountPath: /opt/bitnami/airflow/.ssh/dags-ssh-key
      subPath: dags-ssh-key
    {{- end }}
  {{- if .Values.defaultSidecars.syncDAGsPlugins.args }}
  args: {{- include "common.tplvalues.render" (dict "value" .Values.defaultSidecars.syncDAGsPlugins.args "context" .) | nindent 4 }}
  {{- else }}
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/libos.sh

      if ! am_i_root && [[ -e "$LIBNSS_WRAPPER_PATH" ]]; then
          echo "airflow:x:$(id -u):$(id -g):Airflow:$AIRFLOW_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
          echo "airflow:x:$(id -g):" > "$NSS_WRAPPER_GROUP"

          export LD_PRELOAD="$LIBNSS_WRAPPER_PATH"
          export HOME="$AIRFLOW_HOME"
      fi

      while true; do
    {{- if or .Values.dags.sshKey .Values.dags.existingSshKeySecret }}
      export GIT_SSH_COMMAND="ssh -i /opt/bitnami/airflow/.ssh/dags-ssh-key -o StrictHostKeyChecking=no"
    {{- end }}
    {{- range .Values.dags.repositories }}
          cd /dags/{{ include "airflow.dagsPlugins.repository.name" . }} && git pull origin {{ .branch }} || true
    {{- end }}
          sleep {{ default "60" .Values.defaultSidecars.syncDAGsPlugins.interval }}
      done
  {{- end }}
  name: sync-dags
{{- end -}}

{{/*
Returns a sidecar that syncs plugins from Git repositories
*/}}
{{- define "airflow.defaultSidecars.syncPlugins" -}}
{{ include "airflow.defaultSidecars.shared" . }}
    - name: empty-dir
      mountPath: /plugins
      subPath: app-plugins-dir
    {{- if or .Values.plugins.sshKey .Values.plugins.existingSshKeySecret }}
    - name: plugins-ssh-key
      mountPath: /opt/bitnami/airflow/.ssh/plugins-ssh-key
      subPath: plugins-ssh-key
    {{- end }}
  {{- if .Values.defaultSidecars.syncDAGsPlugins.args }}
  args: {{- include "common.tplvalues.render" (dict "value" .Values.defaultSidecars.syncDAGsPlugins.args "context" .) | nindent 4 }}
  {{- else }}
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/libos.sh

      if ! am_i_root && [[ -e "$LIBNSS_WRAPPER_PATH" ]]; then
          echo "airflow:x:$(id -u):$(id -g):Airflow:$AIRFLOW_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
          echo "airflow:x:$(id -g):" > "$NSS_WRAPPER_GROUP"

          export LD_PRELOAD="$LIBNSS_WRAPPER_PATH"
          export HOME="$AIRFLOW_HOME"
      fi
    {{- if or .Values.plugins.sshKey .Values.plugins.existingSshKeySecret }}
      export GIT_SSH_COMMAND="ssh -i /opt/bitnami/airflow/.ssh/plugins-ssh-key -o StrictHostKeyChecking=no"
    {{- end }}
      while true; do
    {{- range .Values.plugins.repositories }}
          cd /plugins/{{ include "airflow.dagsPlugins.repository.name" . }} && git pull origin {{ .branch }} || true
    {{- end }}
          sleep {{ default "60" .Values.defaultSidecars.syncDAGsPlugins.interval }}
      done
  {{- end }}
  name: sync-plugins
{{- end -}}

{{/*
Returns the volume mounts to use on Airflow containers to mount custom DAGs
*/}}
{{- define "airflow.dags.volumeMounts" -}}
{{- if not (empty .Values.dags.existingConfigmap) }}
- name: empty-dir
  mountPath: /opt/bitnami/airflow/dags/external
  subPath: app-dags-dir/external
{{- end }}
{{- range .Values.dags.repositories }}
- name: empty-dir
  mountPath: /opt/bitnami/airflow/dags/git_{{ include "airflow.dagsPlugins.repository.name" . }}
  {{- if .path }}
  subPath: app-dags-dir/{{ include "airflow.dagsPlugins.repository.name" . }}/{{ .path }}
  {{- else }}
  subPath: app-dags-dir/{{ include "airflow.dagsPlugins.repository.name" . }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Returns the extra volumes to add on Airflow pods to load custom DAGS
*/}}
{{- define "airflow.dags.volumes" -}}
{{- if .Values.dags.existingConfigmap }}
- name: external-dags
  configMap:
    name: {{ tpl .Values.dags.existingConfigmap $ }}
{{- end }}
{{- if or .Values.dags.sshKey .Values.dags.existingSshKeySecret }}
- name: dags-ssh-key
  secret:
    secretName: {{ include "airflow.dags.ssh.secretName" . }}
    items:
      - key: {{ default "dags-ssh-key" (tpl .Values.dags.existingSshKeySecretKey .) }}
        path: dags-ssh-key
        mode: 0600
{{- end }}
{{- end -}}

{{/*
Returns the volume mounts to use on Airflow containers to mount custom plugins
*/}}
{{- define "airflow.plugins.volumeMounts" -}}
{{- range .Values.plugins.repositories }}
- name: empty-dir
  mountPath: /opt/bitnami/airflow/plugins/git_{{ include "airflow.dagsPlugins.repository.name" . }}
  {{- if .path }}
  subPath: app-plugins-dir/{{ include "airflow.dagsPlugins.repository.name" . }}/{{ .path }}
  {{- else }}
  subPath: app-plugins-dir/{{ include "airflow.dagsPlugins.repository.name" . }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Returns the extra volumes to add on Airflow pods to load custom plugins
*/}}
{{- define "airflow.plugins.volumes" -}}
{{- if or .Values.plugins.sshKey .Values.plugins.existingSshKeySecret }}
- name: plugins-ssh-key
  secret:
    secretName: {{ include "airflow.plugins.ssh.secretName" . }}
    items:
      - key: {{ default "plugins-ssh-key" (tpl .Values.plugins.existingSshKeySecretKey .) }}
        path: plugins-ssh-key
        mode: 0600
{{- end }}
{{- end -}}
