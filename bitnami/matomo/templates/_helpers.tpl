{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "matomo.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper certificate image name
*/}}
{{- define "certificates.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.certificates.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Matomo image name
*/}}
{{- define "matomo.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "matomo.metrics.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "matomo.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "matomo.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image .Values.certificates.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "matomo.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence "global" .Values.global) -}}
{{- end -}}

{{/*
Matomo credential secret name
*/}}
{{- define "matomo.secretName" -}}
{{- coalesce .Values.existingSecret (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the SMTP Secret Name
*/}}
{{- define "matomo.smtpSecretName" -}}
{{- if .Values.smtpExistingSecret }}
    {{- printf "%s" .Values.smtpExistingSecret -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "matomo.databaseHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
        {{- printf "%s-%s" (include "matomo.mariadb.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "matomo.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "matomo.databasePort" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Database Name
*/}}
{{- define "matomo.databaseName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "matomo.databaseUser" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Secret Name
*/}}
{{- define "matomo.databaseSecretName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" (include "matomo.mariadb.fullname" .) -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "common.names.fullname" .) "externaldb" -}}
{{- end -}}
{{- end -}}

{{/*
Return the database password key
*/}}
{{- define "matomo.databasePasswordKey" -}}
{{- if .Values.mariadb.enabled -}}
mariadb-password
{{- else -}}
db-password
{{- end -}}
{{- end -}}

{{/*
Return the matomo pods needed initContainers
*/}}
{{- define "matomo.initContainers" -}}
{{- if and .Values.volumePermissions.enabled .Values.persistence.enabled }}
- name: volume-permissions
  image: {{ include "matomo.volumePermissions.image" . }}
  imagePullPolicy: {{ .Values.volumePermissions.image.pullPolicy | quote }}
  command:
    - sh
    - -c
    - |
      mkdir -p "/bitnami/matomo"
      chown -R "{{ .Values.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }}" "/bitnami/matomo"
  securityContext:
    runAsUser: 0
  {{- if .Values.volumePermissions.resources }}
  resources: {{- toYaml .Values.volumePermissions.resources | nindent 4 }}
  {{- else if ne .Values.volumePermissions.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.volumePermissions.resourcesPreset) | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: matomo-data
      mountPath: /bitnami/matomo
{{- end }}
{{- if .Values.certificates.customCAs }}
- name: certificates
  image: {{ template "certificates.image" . }}
  imagePullPolicy: {{ default .Values.image.pullPolicy .Values.certificates.image.pullPolicy }}
  imagePullSecrets:
  {{- range (default .Values.image.pullSecrets .Values.certificates.image.pullSecrets) }}
    - name: {{ . }}
  {{- end }}
  securityContext:
    runAsUser: 0
  {{- if .Values.certificates.command }}
  command: {{- include "common.tplvalues.render" (dict "value" .Values.certificates.command "context" $) | nindent 4 }}
  {{- else if .Values.certificates.customCertificate.certificateSecret }}
  command:
    - sh
    - -c
    - install_packages ca-certificates openssl
  {{- else }}
  command:
    - sh
    - -c
    - install_packages ca-certificates openssl
    && openssl req -new -x509 -days 3650 -nodes -sha256
      -subj "/CN=$(hostname)" -addext "subjectAltName = DNS:$(hostname)"
      -out  /etc/ssl/certs/ssl-cert-snakeoil.pem
      -keyout /etc/ssl/private/ssl-cert-snakeoil.key -extensions v3_req
  {{- end }}
  {{- if .Values.certificates.args }}
  args: {{- include "common.tplvalues.render" (dict "value" .Values.certificates.args "context" $) | nindent 4 }}
  {{- end }}
  env: {{- include "common.tplvalues.render" (dict "value" .Values.certificates.extraEnvVars "context" $) | nindent 4 }}
  envFrom:
    {{- if .Values.certificates.extraEnvVarsCM }}
    - configMapRef:
        name: {{ include "common.tplvalues.render" (dict "value" .Values.certificates.extraEnvVarsCM "context" $) }}
    {{- end }}
    {{- if .Values.certificates.extraEnvVarsSecret }}
    - secretRef:
        name: {{ include "common.tplvalues.render" (dict "value" .Values.certificates.extraEnvVarsSecret "context" $) }}
    {{- end }}
  volumeMounts:
    - name: etc-ssl-certs
      mountPath: /etc/ssl/certs
      readOnly: false
    - name: etc-ssl-private
      mountPath: /etc/ssl/private
      readOnly: false
    - name: custom-ca-certificates
      mountPath: /usr/local/share/ca-certificates
      readOnly: true
{{- end }}
{{- end }}
{{/*
Return if cronjob X is enabled. Takes into account the deprecated value 'cronjobs.enabled'.
Use: include "matomo.cronjobs.enabled" (dict "context" $ "cronjob" "archive" )
*/}}
{{- define "matomo.cronjobs.enabled" -}}
{{- if ( hasKey .context.Values.cronjobs "enabled" ) -}}
  {{- if .context.Values.cronjobs.enabled -}}
    {{- true -}}
  {{- end -}}
{{- else -}}
  {{- if ( get .context.Values.cronjobs .cronjob ).enabled  -}}
    {{- true -}}
  {{- end -}}
{{- end -}}
{{- end }}
