{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper image name
*/}}
{{- define "mlflow.v0.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "mlflow.v0.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container wait-permissions image)
*/}}
{{- define "mlflow.v0.waitContainer.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.waitContainer.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mlflow.v0.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.waitContainer.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Fullname of the tracking service
*/}}
{{- define "mlflow.v0.tracking.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "tracking" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "mlflow.v0.tracking.serviceAccountName" -}}
{{- if .Values.tracking.serviceAccount.create -}}
    {{ default (include "mlflow.v0.tracking.fullname" .) .Values.tracking.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.tracking.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the MLflow Tracking Secret Name
*/}}
{{- define "mlflow.v0.tracking.secretName" -}}
{{- if .Values.tracking.auth.existingSecret -}}
{{- include "common.tplvalues.render" (dict "value" .Values.tracking.auth.existingSecret "context" $) -}}
{{- else -}}
{{- include "mlflow.v0.tracking.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the MLflow Tracking Secret key for the password
*/}}
{{- define "mlflow.v0.tracking.passwordKey" -}}
{{- coalesce .Values.tracking.auth.existingSecretPasswordKey "admin-password" -}}
{{- end -}}

{{/*
Return the MLflow Tracking Secret key for the user
*/}}
{{- define "mlflow.v0.tracking.userKey" -}}
{{- coalesce .Values.tracking.auth.existingSecretUserKey "admin-user" -}}
{{- end -}}

{{/*
Return the MLFlow Tracking Port
*/}}
{{- define "mlflow.v0.tracking.port" -}}
{{- int ( ternary .Values.tracking.service.ports.https .Values.tracking.service.ports.http .Values.tracking.tls.enabled ) -}}
{{- end -}}

{{/*
Return the MLFlow Tracking Port Name
*/}}
{{- define "mlflow.v0.tracking.portName" -}}
{{- ternary "https" "http" .Values.tracking.tls.enabled -}}
{{- end -}}

{{/*
Return the MLFlow Tracking Protocol
*/}}
{{- define "mlflow.v0.tracking.protocol" -}}
{{- ternary "https" "http" .Values.tracking.tls.enabled -}}
{{- end -}}

{{/*
Return the MLFlow Tracking URI
*/}}
{{- define "mlflow.v0.tracking.uri" -}}
{{ printf "%s://%s:%v" (include "mlflow.v0.tracking.protocol" .) (include "mlflow.v0.tracking.fullname" .) (include "mlflow.v0.tracking.port" .) }}
{{- end -}}

{{/*
Get the source configmap.
*/}}
{{- define "mlflow.v0.tracking.auth.overridesConfigMapName" -}}
{{- if .Values.tracking.auth.overridesConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.tracking.auth.overridesConfigMap "context" $) -}}
{{- else }}
    {{- printf "%s-auth-overrides" (include "mlflow.v0.tracking.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Init container definition for copying the certificates
*/}}
{{- define "mlflow.v0.tracking.copyCertsInitContainer" -}}
- name: copy-certs
  image: {{ include "mlflow.v0.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.tracking.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.tracking.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash
      cp -L /tmp/certs/* /bitnami/mlflow/certs
      chmod 600 {{ include "mlflow.v0.tracking.tlsCertKey" . }}
  volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: raw-certificates
      mountPath: /tmp/certs
    - name: mlflow-certificates
      mountPath: /bitnami/mlflow/certs
{{- end }}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "mlflow.v0.tracking.renderAuthConfInitContainer" -}}
- name: get-default-auth-conf
  image: {{ include "mlflow.v0.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.tracking.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.tracking.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash
      cp /bitnami/mlflow-basic-auth/basic_auth.ini /bitnami/rendered-basic-auth/basic_auth.ini
  volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: rendered-basic-auth
      mountPath: /bitnami/rendered-basic-auth
- name: render-auth-conf
  image: {{ include "mlflow.v0.waitContainer.image" . }}
  imagePullPolicy: {{ .Values.waitContainer.image.pullPolicy }}
  {{- if .Values.tracking.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.tracking.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash
      # First render the overrides
      render-template /bitnami/basic-auth-overrides/*.ini > /tmp/rendered-overrides.ini
      # Loop through the ini overrides and apply it to the final basic_auth.ini
      # read the file line by line
      while IFS='=' read -r key value
      do
        # remove leading and trailing spaces from key and value
        key="$(echo $key | tr -d " ")"
        value="$(echo $value | tr -d " ")"

        ini-file set -s mlflow -k "$key" -v "$value" /bitnami/rendered-basic-auth/basic_auth.ini
      done < "/tmp/rendered-overrides.ini"
      # Remove temporary files
      rm /tmp/rendered-overrides.ini
  env:
    {{- if (include "mlflow.v0.database.enabled" .) }}
    - name: MLFLOW_DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "mlflow.v0.database.secretName" . }}
          key: {{ include "mlflow.v0.database.passwordKey" . | quote }}
    - name: MLFLOW_DATABASE_AUTH_URI
      value: {{ include "mlflow.v0.database-auth.uri" . | quote }}
    {{- end }}
    - name: MLFLOW_TRACKING_USERNAME
      valueFrom:
        secretKeyRef:
          name: {{ include "mlflow.v0.tracking.secretName" . }}
          key: {{ include "mlflow.v0.tracking.userKey" . | quote }}
    - name: MLFLOW_TRACKING_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "mlflow.v0.tracking.secretName" . }}
          key: {{ include "mlflow.v0.tracking.passwordKey" . | quote }}
    {{- if .Values.tracking.extraEnvVars }}
    {{- include "common.tplvalues.render" (dict "value" .Values.tracking.extraEnvVars "context" $) | nindent 4 }}
    {{- end }}
  envFrom:
    {{- if .Values.tracking.extraEnvVarsCM }}
    - configMapRef:
        name: {{ include "common.tplvalues.render" (dict "value" .Values.tracking.extraEnvVarsCM "context" $) }}
    {{- end }}
    {{- if .Values.tracking.extraEnvVarsSecret }}
    - secretRef:
        name: {{ include "common.tplvalues.render" (dict "value" .Values.tracking.extraEnvVarsSecret "context" $) }}
    {{- end }}
  volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: basic-auth-overrides
      mountPath: /bitnami/basic-auth-overrides
    - name: rendered-basic-auth
      mountPath: /bitnami/rendered-basic-auth
{{- end -}}

{{/*
Init container definition for upgrading the database
*/}}
{{- define "mlflow.v0.tracking.upgradeDBInitContainer" -}}
- name: upgrade-db
  image: {{ include "mlflow.v0.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.tracking.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.tracking.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - mlflow
  args:
    - db
    - upgrade
    - {{ include "mlflow.v0.database.uri" . }}
  env:
    - name: MLFLOW_DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "mlflow.v0.database.secretName" . }}
          key: {{ include "mlflow.v0.database.passwordKey" . | quote }}
  volumeMounts:
    - name: tmp
      mountPath: /tmp
{{- end -}}

{{/*
Init container definition for upgrading the database
*/}}
{{- define "mlflow.v0.tracking.upgradeDBAuthInitContainer" -}}
- name: upgrade-db-auth
  image: {{ include "mlflow.v0.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.tracking.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.tracking.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - python
  args:
    - -m
    - mlflow.server.auth
    - db
    - upgrade
    - --url
    - {{ include "mlflow.v0.database-auth.uri" . }}
  env:
    - name: MLFLOW_DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "mlflow.v0.database.secretName" . }}
          key: {{ include "mlflow.v0.database.passwordKey" . | quote }}
  volumeMounts:
    - name: tmp
      mountPath: /tmp
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "mlflow.v0.tracking.createTlsSecret" -}}
{{- if and .Values.tracking.tls.autoGenerated (not .Values.tracking.tls.certificatesSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "mlflow.v0.tracking.tlsSecretName" -}}
{{- if .Values.tracking.tls.autoGenerated }}
    {{- printf "%s-crt" (include "mlflow.v0.tracking.fullname" .) -}}
{{- else -}}
    {{ required "A secret containing TLS certificates is required when TLS is enabled" .Values.tracking.tls.certificatesSecret }}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert file.
*/}}
{{- define "mlflow.v0.tracking.tlsCert" -}}
{{- if .Values.tracking.tls.autoGenerated }}
    {{- printf "/bitnami/mlflow/certs/tls.crt" -}}
{{- else -}}
    {{- required "Certificate filename is required when TLS in enabled" .Values.tracking.tls.certFilename | printf "/bitnami/mlflow/certs/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert key file.
*/}}
{{- define "mlflow.v0.tracking.tlsCertKey" -}}
{{- if .Values.tracking.tls.autoGenerated }}
    {{- printf "/bitnami/mlflow/certs/tls.key" -}}
{{- else -}}
{{- required "Certificate Key filename is required when TLS in enabled" .Values.tracking.tls.certKeyFilename | printf "/bitnami/mlflow/certs/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "mlflow.v0.tracking.tlsCACert" -}}
{{- if .Values.tracking.tls.autoGenerated }}
    {{- printf "/bitnami/mlflow/certs/ca.crt" -}}
{{- else -}}
    {{- if .Values.tracking.tls.certCAFilename -}}
    {{- printf "/bitnami/mlflow/certs/%s" .Values.tracking.tls.certCAFilename -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Fullname of the run service
*/}}
{{- define "mlflow.v0.run.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "run" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use (run deployment)
*/}}
{{- define "mlflow.v0.run.serviceAccountName" -}}
{{- if .Values.run.serviceAccount.create -}}
    {{ default (include "mlflow.v0.run.fullname" .) .Values.run.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.run.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return true if the source configmap should be created
*/}}
{{- define "mlflow.v0.run.source.createConfigMap" -}}
{{- if and (eq .Values.run.source.type "configmap") .Values.run.source.configMap (not .Values.run.source.existingConfigMap) -}}
{{- true -}}
{{- end }}
{{- end -}}

{{/*
Get the source configmap.
*/}}
{{- define "mlflow.v0.run.source.configMapName" -}}
{{- if .Values.run.source.existingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.run.source.existingConfigMap "context" $) -}}
{{- else }}
    {{- printf "%s-source" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL fullname
*/}}
{{- define "mlflow.v0.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the PostgreSQL Hostname
*/}}
{{- define "mlflow.v0.database.enabled" -}}
{{- if or .Values.postgresql.enabled .Values.externalDatabase.host -}}
{{- true }}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Hostname
*/}}
{{- define "mlflow.v0.database.host" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if eq .Values.postgresql.architecture "replication" -}}
        {{- printf "%s-%s" (include "mlflow.v0.postgresql.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- print (include "mlflow.v0.postgresql.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- print .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Port
*/}}
{{- define "mlflow.v0.database.port" -}}
{{- if .Values.postgresql.enabled -}}
    {{- printf "%d" (.Values.postgresql.primary.service.ports.postgresql | int) -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL User
*/}}
{{- define "mlflow.v0.database.user" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print .Values.postgresql.auth.username -}}
{{- else -}}
    {{- print .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL database name
*/}}
{{- define "mlflow.v0.database.name" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print .Values.postgresql.auth.database -}}
{{- else -}}
    {{- print .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL auth database name
NOTE: This macro is run in both the parent chart and the PostgreSQL
subchart (as it is used in the init scripts), so we need to control the
scope
*/}}
{{- define "mlflow.v0.database-auth.name" -}}
{{- if .Values.postgresql -}}
    {{/* Inside parent chart */}}
    {{- if .Values.postgresql.enabled -}}
    {{- printf "%s_auth" .Values.postgresql.auth.database -}}
    {{- else -}}
    {{- print .Values.externalDatabase.authDatabase -}}
    {{- end -}}
{{- else -}}
    {{/* Inside postgresql sub-chart, therefore postgresql.enabled=true */}}
    {{- printf "%s_auth" .Values.auth.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Secret Name
*/}}
{{- define "mlflow.v0.database.secretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
    {{- print .Values.postgresql.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "mlflow.v0.postgresql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- print .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "common.names.fullname" .) "externaldb" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve key of the PostgreSQL secret
*/}}
{{- define "mlflow.v0.database.passwordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- print .Values.externalDatabase.existingSecretPasswordKey -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve the URI of the database
*/}}
{{- define "mlflow.v0.database.uri" -}}
{{- printf "postgresql://%s:$(MLFLOW_DATABASE_PASSWORD)@%s:%v/%s" (include "mlflow.v0.database.user" .) (include "mlflow.v0.database.host" .) (include "mlflow.v0.database.port" .) (include "mlflow.v0.database.name" .) -}}
{{- end -}}

{{/*
Retrieve the URI of the auth database
*/}}
{{- define "mlflow.v0.database-auth.uri" -}}
{{- printf "postgresql://%s:$(MLFLOW_DATABASE_PASSWORD)@%s:%v/%s" (include "mlflow.v0.database.user" .) (include "mlflow.v0.database.host" .) (include "mlflow.v0.database.port" .) (include "mlflow.v0.database-auth.name" .) -}}
{{- end -}}

{{/*
Return the volume-permissions init container
*/}}
{{- define "mlflow.v0.volumePermissionsInitContainer" -}}
- name: volume-permissions
  image: {{ include "mlflow.v0.volumePermissions.image"  }}
  imagePullPolicy: {{ default "" .Values.volumePermissions.image.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      mkdir -p {{ .Values.persistence.mountPath }}
      chown {{ .Values.volumePermissions.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }} {{ .Values.persistence.mountPath }}
      find {{ .Values.persistence.mountPath }} -mindepth 1 -maxdepth 1 -not -name ".snapshot" -not -name "lost+found" | xargs chown -R {{ .Values.volumePermissions.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }}
  {{- if .Values.volumePermissions.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.volumePermissions.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.volumePermissions.resources }}
  resources: {{- toYaml .Values.volumePermissions.resources | nindent 12 }}
  {{- else if ne .Values.volumePermissions.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.volumePermissions.resourcesPreset) | nindent 12 }}
  {{- end }}
  volumeMounts:
    - name: data
      mountPath: {{ .Values.persistence.mountPath }}
    - name: tmp
      mountPath: /tmp
{{- end -}}


{{/*
Deal with external artifact storage
*/}}

{{/*
Return MinIO(TM) fullname
*/}}
{{- define "mlflow.v0.minio.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "minio" "chartValues" .Values.minio "context" $) -}}
{{- end -}}


{{/*
Return whether S3 is enabled
*/}}
{{- define "mlflow.v0.s3.enabled" -}}
{{- if or .Values.minio.enabled .Values.externalS3.host -}}
{{- true }}
{{- end -}}
{{- end -}}

{{/*
Return whether artifacts should be served from S3
*/}}
{{- define "mlflow.v0.s3.serveArtifacts" -}}
    {{- if and (or .Values.minio.enabled .Values.externalS3.host) .Values.externalS3.serveArtifacts  -}}
        {{- true }}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 backend host
*/}}
{{- define "mlflow.v0.s3.host" -}}
    {{- if .Values.minio.enabled -}}
        {{- include "mlflow.v0.minio.fullname" . -}}
    {{- else -}}
        {{- print .Values.externalS3.host -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 port
*/}}
{{- define "mlflow.v0.s3.port" -}}
{{- ternary .Values.minio.service.ports.api .Values.externalS3.port .Values.minio.enabled -}}
{{- end -}}

{{/*
Return the S3 bucket
*/}}
{{- define "mlflow.v0.s3.bucket" -}}
    {{- if .Values.minio.enabled -}}
        {{- print .Values.minio.defaultBuckets -}}
    {{- else -}}
        {{- print .Values.externalS3.bucket -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 protocol
*/}}
{{- define "mlflow.v0.s3.protocol" -}}
    {{- if .Values.minio.enabled -}}
        {{- ternary "https" "http" .Values.minio.tls.enabled  -}}
    {{- else -}}
        {{- print .Values.externalS3.protocol -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 credentials secret name
*/}}
{{- define "mlflow.v0.s3.secretName" -}}
{{- if .Values.minio.enabled -}}
    {{- if .Values.minio.auth.existingSecret -}}
    {{- print .Values.minio.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "mlflow.v0.minio.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalS3.existingSecret -}}
    {{- print .Values.externalS3.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "common.names.fullname" .) "externals3" -}}
{{- end -}}
{{- end -}}

{{/*
Return the S3 access key id inside the secret
*/}}
{{- define "mlflow.v0.s3.accessKeyIDKey" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "root-user"  -}}
    {{- else -}}
        {{- print .Values.externalS3.existingSecretAccessKeyIDKey -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 secret access key inside the secret
*/}}
{{- define "mlflow.v0.s3.secretAccessKeyKey" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "root-password"  -}}
    {{- else -}}
        {{- print .Values.externalS3.existingSecretKeySecretKey -}}
    {{- end -}}
{{- end -}}

{{/*
Google Cloud Storage Section
*/}}

{{/*
Return the GCS bucket
*/}}
{{- define "mlflow.v0.gcs.bucket" -}}
    {{- if .Values.externalGCS.enabled -}}
        {{- print .Values.externalGCS.bucket -}}
    {{- end -}}
{{- end -}}

{{/*
Return whether artifacts should be served from GCS
*/}}
{{- define "mlflow.v0.gcs.serveArtifacts" -}}
    {{- if .Values.externalGCS.serveArtifacts  -}}
        {{- true }}
    {{- end -}}
{{- end -}}



{{/*
Return the proper git image name
*/}}
{{- define "mlflow.v0.git.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.gitImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the definition of the git clone init container
*/}}
{{- define "mlflow.v0.git.cloneInitContainer" -}}
- name: git-clone-repository
  image: {{ include "mlflow.v0.git.image" . }}
  imagePullPolicy: {{ .Values.gitImage.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      rm -rf /app/*
      [[ -f "/opt/bitnami/scripts/git/entrypoint.sh" ]] && source "/opt/bitnami/scripts/git/entrypoint.sh"
      git clone {{ .Values.run.source.git.repository }} {{ if .Values.run.source.git.revision }}--branch {{ .Values.run.source.git.revision }}{{ end }} /app
  {{- if .Values.run.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.run.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: source
      mountPath: /app
    - name: tmp
      mountPath: /tmp
    # It creates at startup ssh in case it performs ssh-based git clone
    - name: tmp
      mountPath: /etc/ssh
  {{- if .Values.run.source.git.extraVolumeMounts }}
    {{- include "common.tplvalues.render" (dict "value" .Values.run.source.git.extraVolumeMounts "context" .) | nindent 12 }}
  {{- end }}
{{- end -}}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "mlflow.v0.waitForServiceInitContainer" -}}
- name: {{ printf "wait-for-%s" .target }}
  image: {{ include "mlflow.v0.waitContainer.image" .context }}
  imagePullPolicy: {{ .context.Values.waitContainer.image.pullPolicy }}
  {{- if .context.Values.waitContainer.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .context.Values.waitContainer.containerSecurityContext "context" .context) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash
      retry_while() {
        local -r cmd="${1:?cmd is missing}"
        local -r retries="${2:-12}"
        local -r sleep_time="${3:-5}"
        local return_value=1

        read -r -a command <<< "$cmd"
        for ((i = 1 ; i <= retries ; i+=1 )); do
            "${command[@]}" && return_value=0 && break
            sleep "$sleep_time"
        done
        return $return_value
      }

      check_host() {
          local -r host="${1:-?missing host}"
          local -r port="${2:-?missing port}"
          if wait-for-port --timeout=5 --host=${host} --state=inuse $port ; then
             return 0
          else
             return 1
          fi
      }

      echo "Checking connection to {{ .host }}:{{ .port }}"
      if ! retry_while "check_host {{ .host }} {{ .port }}"; then
          echo "Connection error"
          exit 1
      fi

      echo "Connection success"
      exit 0
  volumeMounts:
    - name: tmp
      mountPath: /tmp
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "mlflow.v0.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "mlflow.v0.validateValues.job" .) -}}
{{- $messages := append $messages (include "mlflow.v0.validateValues.auth" .) -}}
{{- $messages := append $messages (include "mlflow.v0.validateValues.deploy" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Check that a command has been defined when using a job */}}
{{- define "mlflow.v0.validateValues.job" -}}
{{- if and .Values.run.useJob (not .Values.run.source.launchCommand) (not .Values.run.args) }}
mlflow: no-job-command

You defined MLflow to be launched as a job but specified no command. Use the run.source.launchCommand value
to specify a command.
{{- end -}}
{{- end -}}

{{/* Check that the database is deployed when enabling authorization */}}
{{- define "mlflow.v0.validateValues.auth" -}}
{{- if and .Values.tracking.auth.enabled (not (include "mlflow.v0.database.enabled" .)) -}}
mlflow: auth-requires-db

You enabled basic authentication but did not configure a database. Please set postgresql.enabled=true or configure the externalDatabase section.
{{- end -}}
{{- end -}}

{{/* Check that one of the deployments is enabled */}}
{{- define "mlflow.v0.validateValues.deploy" -}}
{{- if and (not .Values.tracking.enabled) (not .Values.run.enabled) -}}
mlflow: no-deploy

You did not deploy either a MLflow job or the tracking server. Please set one of the two: tracking.enabled=true or run.enabled=true
{{- end -}}
{{- end -}}
