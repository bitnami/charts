{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper SeaweedFS Master Server fullname
*/}}
{{- define "seaweedfs.master.fullname" -}}
{{- printf "%s-master" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper SeaweedFS Volume Server fullname
*/}}
{{- define "seaweedfs.volume.fullname" -}}
{{- printf "%s-volume" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper SeaweedFS Filer Server fullname
*/}}
{{- define "seaweedfs.filer.fullname" -}}
{{- printf "%s-filer" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper SeaweedFS Amazon S3 API fullname
*/}}
{{- define "seaweedfs.s3.fullname" -}}
{{- printf "%s-s3" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper SeaweedFS WebDAV fullname
*/}}
{{- define "seaweedfs.webdav.fullname" -}}
{{- printf "%s-webdav" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper SeaweedFS MariaDB database fullname
*/}}
{{- define "seaweedfs.mariadb.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mariadb" "chartValues" .Values.mariadb "context" $) -}}
{{- end -}}

{{/*
Return the proper SeaweedFS image name
*/}}
{{- define "seaweedfs.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "seaweedfs.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "seaweedfs.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "seaweedfs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the Master Server configuration configmap.
*/}}
{{- define "seaweedfs.master.configmapName" -}}
{{- if .Values.master.existingConfigmap -}}
    {{- print (tpl .Values.master.existingConfigmap .) -}}
{{- else -}}
    {{- print (include "seaweedfs.master.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Volume Server configuration configmap.
*/}}
{{- define "seaweedfs.volume.configmapName" -}}
{{- if .Values.volume.existingConfigmap -}}
    {{- print (tpl .Values.volume.existingConfigmap .) -}}
{{- else -}}
    {{- print (include "seaweedfs.volume.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Filer Server configuration configmap.
*/}}
{{- define "seaweedfs.filer.configmapName" -}}
{{- if .Values.filer.existingConfigmap -}}
    {{- print (tpl .Values.filer.existingConfigmap .) -}}
{{- else -}}
    {{- print (include "seaweedfs.filer.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Master Server peers
*/}}
{{- define "seaweedfs.master.servers" -}}
{{- $peers := list -}}
{{- $masterFullname := include "seaweedfs.master.fullname" . -}}
{{- $masterHeadlessSvcName := printf "%s-headless" (include "seaweedfs.master.fullname" .) -}}
{{- $clusterDomain := .Values.clusterDomain -}}
{{- $masterPort := int .Values.master.containerPorts.http -}}
{{- range $i := until (int .Values.master.replicaCount) }}
    {{- $peers = append $peers (printf "%s-%d.%s.$(NAMESPACE).svc.%s:%d" $masterFullname $i $masterHeadlessSvcName $clusterDomain $masterPort) -}}
{{- end -}}
{{- print (join "," $peers) -}}
{{- end -}}

{{/*
Return true if persistence is enabled for any of the data volumes for Volume Server
*/}}
{{- define "seaweedfs.volume.persistence.enabled" -}}
{{- $persistenceEnabled := false -}}
{{- range .Values.volume.dataVolumes -}}
{{- if .persistence.enabled -}}
    {{- $persistenceEnabled = true -}}
{{- end -}}
{{- end -}}
{{- $persistenceEnabled -}}
{{- end -}}

{{/*
Return the user defined LoadBalancerIP for Volume Server service
Note: returns 127.0.0.1 if using ClusterIP
*/}}
{{- define "seaweedfs.volume.serviceIP" -}}
{{- if eq .Values.volume.service.type "ClusterIP" -}}
{{- print "127.0.0.1" -}}
{{- else if eq .Values.volume.service.type "LoadBalancer" -}}
{{- .Values.volume.service.loadBalancerIP | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Return the advertised URL to access Volume Server
*/}}
{{- define "seaweedfs.volume.publicUrl" -}}
{{- if .Values.volume.ingress.enabled -}}
    {{- printf "%s%s" .Values.volume.ingress.hostname .Values.volume.ingress.path | default "" -}}
{{- else if .Values.volume.publicUrl -}}
    {{- .Values.volume.publicUrl | default "" -}}
{{- else -}}
    {{- include "seaweedfs.volume.serviceIP" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the mTLS CA
*/}}
{{- define "seaweedfs.security.mTLS.caSecretName" -}}
{{- if or .Values.security.mTLS.autoGenerated.enabled (not (empty .Values.security.mTLS.ca)) -}}
    {{- printf "%s-ca-crt" (include "common.names.fullname" .) -}}
{{- else -}}
    {{- required "An existing CA secret name must be provided if CA cert is not provided!" (tpl .Values.security.mTLS.existingCASecret .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the mTLS master certificates
*/}}
{{- define "seaweedfs.security.mTLS.master.secretName" -}}
{{- if or .Values.security.mTLS.autoGenerated.enabled (and (not (empty .Values.security.mTLS.master.cert)) (not (empty .Values.security.mTLS.master.key))) -}}
    {{- printf "%s-crt" (include "seaweedfs.master.fullname" .) -}}
{{- else -}}
    {{- required "An existing master secret name must be provided if master cert and key are not provided!" (tpl .Values.security.mTLS.master.existingSecret .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the mTLS filer certificates
*/}}
{{- define "seaweedfs.security.mTLS.filer.secretName" -}}
{{- if or .Values.security.mTLS.autoGenerated.enabled (and (not (empty .Values.security.mTLS.filer.cert)) (not (empty .Values.security.mTLS.filer.key))) -}}
    {{- printf "%s-crt" (include "seaweedfs.filer.fullname" .) -}}
{{- else -}}
    {{- required "An existing filer secret name must be provided if filer cert and key are not provided!" (tpl .Values.security.mTLS.filer.existingSecret .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the mTLS volume certificates
*/}}
{{- define "seaweedfs.security.mTLS.volume.secretName" -}}
{{- if or .Values.security.mTLS.autoGenerated.enabled (and (not (empty .Values.security.mTLS.volume.cert)) (not (empty .Values.security.mTLS.volume.key))) -}}
    {{- printf "%s-crt" (include "seaweedfs.volume.fullname" .) -}}
{{- else -}}
    {{- required "An existing volume secret name must be provided if volume cert and key are not provided!" (tpl .Values.security.mTLS.volume.existingSecret .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the mTLS client certificates
*/}}
{{- define "seaweedfs.security.mTLS.client.secretName" -}}
{{- if or .Values.security.mTLS.autoGenerated.enabled (and (not (empty .Values.security.mTLS.client.cert)) (not (empty .Values.security.mTLS.client.key))) -}}
    {{- printf "%s-client-crt" (include "common.names.fullname" .) -}}
{{- else -}}
    {{- required "An existing client secret name must be provided if client cert and key are not provided!" (tpl .Values.security.mTLS.client.existingSecret .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the database hostname
*/}}
{{- define "seaweedfs.database.host" -}}
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
        {{- printf "%s-primary" (include "seaweedfs.mariadb.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- print (include "seaweedfs.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- print .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the database port
*/}}
{{- define "seaweedfs.database.port" -}}
{{- if .Values.mariadb.enabled }}
    {{- print "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the database name
*/}}
{{- define "seaweedfs.database.name" -}}
{{- if .Values.mariadb.enabled }}
    {{- print .Values.mariadb.auth.database -}}
{{- else -}}
    {{- print .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the database user
*/}}
{{- define "seaweedfs.database.user" -}}
{{- if .Values.mariadb.enabled }}
    {{- print .Values.mariadb.auth.username -}}
{{- else -}}
    {{- print .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the database secret name
*/}}
{{- define "seaweedfs.database.secretName" -}}
{{- if .Values.mariadb.enabled }}
    {{- if .Values.mariadb.auth.existingSecret -}}
        {{- print (tpl .Values.mariadb.auth.existingSecret .) -}}
    {{- else -}}
        {{- print (include "seaweedfs.mariadb.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- print (tpl .Values.externalDatabase.existingSecret .) -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Returns an init-container that waits for the database to be ready
*/}}
{{- define "seaweedfs.filer.waitForDBInitContainer" -}}
- name: wait-for-db
  image: {{ include "common.images.image" (dict "imageRoot" .Values.mariadb.image "global" .Values.global) }}
  imagePullPolicy: {{ .Values.mariadb.image.pullPolicy }}
  {{- if .Values.filer.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.filer.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
  args:
    - -ec
    - |
      #!/bin/bash

      set -o errexit
      set -o nounset
      set -o pipefail

      . /opt/bitnami/scripts/liblog.sh
      . /opt/bitnami/scripts/libvalidations.sh
      . /opt/bitnami/scripts/libmariadb.sh
      . /opt/bitnami/scripts/mariadb-env.sh

      info "Waiting for host $DATABASE_HOST"
      mariadb_is_ready() {
          if ! echo "select 1" | mysql_remote_execute "$DATABASE_HOST" "$DATABASE_PORT_NUMBER" "$DATABASE_NAME" "$DATABASE_USER" "$DATABASE_PASSWORD"; then
             return 1
          fi
          return 0
      }
      if ! retry_while "mariadb_is_ready"; then
          error "Database not ready"
          exit 1
      fi
      info "Database is ready"
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.mariadb.image.debug .Values.diagnosticMode.enabled) | quote }}
    - name: DATABASE_HOST
      value: {{ include "seaweedfs.database.host" . | quote }}
    - name: DATABASE_PORT_NUMBER
      value: {{ include "seaweedfs.database.port" . | quote }}
    - name: DATABASE_NAME
      value: {{ include "seaweedfs.database.name" . | quote }}
    - name: DATABASE_USER
      value: {{ include "seaweedfs.database.user" . | quote }}
    - name: DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "seaweedfs.database.secretName" . }}
          key: mariadb-password
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}

{{/*
Returns an init-container that generates auth configuration for the Amazon S3 API
*/}}
{{- define "seaweedfs.s3.authConfigInitContainer" -}}
- name: auth-config-init
  image: {{ template "seaweedfs.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.s3.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.s3.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
  args:
    - -ec
    - |
      #!/bin/bash

      cat > "/auth/config.json" <<EOF
      {
        "identities": [
          {
            "name": "admin",
            "credentials": [
              {
                "accessKey": "${ADMIN_ACCESS_KEY_ID}",
                "secretKey": "${ADMIN_SECRET_ACCESS_KEY}"
              }
            ],
            "actions": [
              "Admin",
              "Read",
              "List",
              "Tagging",
              "Write"
            ]
          },
          {
            "name": "read_only",
            "credentials": [
              {
                "accessKey": "${READ_ACCESS_KEY_ID}",
                "secretKey": "${READ_SECRET_ACCESS_KEY}"
              }
            ],
            "actions": [
              "Read"
            ]
          }
        ]
      }
      EOF
  env:
    - name: ADMIN_ACCESS_KEY_ID
      valueFrom:
        secretKeyRef:
          name: {{ printf "%s-auth" (include "seaweedfs.s3.fullname" .) }}
          key: admin_access_key_id
    - name: ADMIN_SECRET_ACCESS_KEY
      valueFrom:
        secretKeyRef:
          name: {{ printf "%s-auth" (include "seaweedfs.s3.fullname" .) }}
          key: admin_secret_access_key
    - name: READ_ACCESS_KEY_ID
      valueFrom:
        secretKeyRef:
          name: {{ printf "%s-auth" (include "seaweedfs.s3.fullname" .) }}
          key: read_access_key_id
    - name: READ_SECRET_ACCESS_KEY
      valueFrom:
        secretKeyRef:
          name: {{ printf "%s-auth" (include "seaweedfs.s3.fullname" .) }}
          key: read_secret_access_key
  volumeMounts:
    - name: empty-dir
      mountPath: /auth
      subPath: auth-dir
{{- end -}}

{{/*
Return the name of the secret containing the WebDAV TLS certificates
*/}}
{{- define "seaweedfs.webdav.tls.secretName" -}}
{{- if or .Values.security.mTLS.autoGenerated.enabled (and (not (empty .Values.webdav.tls.cert)) (not (empty .Values.webdav.tls.key))) -}}
    {{- printf "%s-crt" (include "seaweedfs.webdav.fullname" .) -}}
{{- else -}}
    {{- required "An existing secret name must be provided if WebDAV TLS cert and key are not provided!" (tpl .Values.webdav.tls.existingSecret .) -}}
{{- end -}}
{{- end -}}


{{/*
Compile all warnings into a single message.
*/}}
{{- define "seaweedfs.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "seaweedfs.validateValues.security.mTLS" .) -}}
{{- $messages := append $messages (include "seaweedfs.validateValues.master.replicaCount" .) -}}
{{- $messages := append $messages (include "seaweedfs.validateValues.volume.replicaCount" .) -}}
{{- $messages := append $messages (include "seaweedfs.validateValues.volume.dataVolumes" .) -}}
{{- $messages := append $messages (include "seaweedfs.validateValues.filer.database" .) -}}
{{- $messages := append $messages (include "seaweedfs.validateValues.s3" .) -}}
{{- $messages := append $messages (include "seaweedfs.validateValues.webdav" .) -}}
{{- $messages := append $messages (include "seaweedfs.validateValues.webdav.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of SeaweedFS - MTLS
*/}}
{{- define "seaweedfs.validateValues.security.mTLS" -}}
{{- if and .Values.security.enabled .Values.security.mTLS.enabled .Values.security.mTLS.autoGenerated.enabled -}}
{{- if or (not (empty .Values.security.mTLS.ca)) (not (empty .Values.security.mTLS.master.cert)) (not (empty .Values.security.mTLS.master.key)) (not (empty .Values.security.mTLS.volume.cert)) (not (empty .Values.security.mTLS.volume.key)) (not (empty .Values.security.mTLS.filer.cert)) (not (empty .Values.security.mTLS.filer.key)) (not (empty .Values.security.mTLS.client.cert)) (not (empty .Values.security.mTLS.client.key)) -}}
security.mTLS.autoGenerated
    When enabling auto-generated MTLS certificates, all certificate and key fields must be empty.
    Please disable auto-generated MTLS certificates (--set security.mTLS.autoGenerated.enabled=false) or
    remove the certificate and key fields.
{{- end -}}
{{- if or (not (empty .Values.security.mTLS.existingCASecret) ) (not (empty .Values.security.mTLS.master.existingSecret)) (not (empty .Values.security.mTLS.volume.existingSecret)) (not (empty .Values.security.mTLS.filer.existingSecret)) (not (empty .Values.security.mTLS.client.existingSecret)) -}}
security.mTLS.autoGenerated
    When enabling auto-generated MTLS certificates, all existing secret fields must be empty.
    Please disable auto-generated MTLS certificates (--set security.mTLS.autoGenerated.enabled=false) or
    remove the existing secret fields.
{{- end -}}
{{- if and (ne .Values.security.mTLS.autoGenerated.engine "helm") (ne .Values.security.mTLS.autoGenerated.engine "cert-manager") -}}
security.mTLS.autoGenerated.engine
    Invalid mechanism to generate the mTLS certificates selected. Valid values are "helm" and
    "cert-manager". Please set a valid one (--set security.mTLS.autoGenerated.engine="xxx")
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of SeaweedFS - number of Master server replicas
*/}}
{{- define "seaweedfs.validateValues.master.replicaCount" -}}
{{- $masterReplicaCount := int .Values.master.replicaCount }}
{{- if and .Values.master.persistence.enabled .Values.master.persistence.existingClaim (gt $masterReplicaCount 1) -}}
master.replicaCount
    A single existing PVC cannot be shared between multiple Master Server replicas.
    Please set a valid number of replicas (--set master.replicaCount=1), disable persistence
    (--set master.persistence.enabled=false) or rely on dynamic provisioning via Persitent
    Volume Claims (--set master.persistence.existingClaim="").
{{- end -}}
{{- end -}}

{{/*
Validate values of SeaweedFS - number of Volume server replicas
*/}}
{{- define "seaweedfs.validateValues.volume.replicaCount" -}}
{{- $volumeReplicaCount := int .Values.volume.replicaCount }}
{{- range .Values.volume.dataVolumes -}}
{{- if and .persistence.enabled .persistence.existingClaim (gt $volumeReplicaCount 1) -}}
volume.replicaCount
    A single existing PVC cannot be shared between multiple Volume Server replicas.
    Please set a valid number of replicas (--set volume.replicaCount=1), disable persistence
    (--set volume.dataVolumes[].persistence.enabled=false) or rely on dynamic provisioning via Persitent
    Volume Claims (--set volume.dataVolumes[].persistence.existingClaim="").
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of SeaweedFS - Duplicates on Volume server dataVolumes
*/}}
{{- define "seaweedfs.validateValues.volume.dataVolumes" -}}
{{- $uniqueNames := list -}}
{{- $uniqueMountPaths := list -}}
{{- range .Values.volume.dataVolumes -}}
{{- if has .name $uniqueNames -}}
volume.dataVolumes[]
    Duplicate .name values are not allowed in the volume.dataVolumes array.
    Please ensure that all .name values are unique.
{{- else -}}
{{- $uniqueNames = append $uniqueNames .name -}}
{{- end -}}
{{- if has .mountPath $uniqueMountPaths -}}
volume.dataVolumes[]
    Duplicate .mountPath values are not allowed in the volume.dataVolumes array.
    Please ensure that all .mountPath values are unique.
{{- else -}}
{{- $uniqueMountPaths = append $uniqueMountPaths .mountPath -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of SeaweedFS - Filer server database
*/}}
{{- define "seaweedfs.validateValues.filer.database" -}}
{{- if and (not .Values.filer.enabled) .Values.mariadb.enabled -}}
mariadb.enabled
    The Filer Server is disabled, but the MariaDB dependency is enabled.
    Please enable the Filer Server (--set filer.enabled=true) or
    disable the MariaDB dependency (--set mariadb.enabled=false).
{{- end -}}
{{- end -}}

{{/*
Validate values of SeaweedFS - Amazon S3 API
*/}}
{{- define "seaweedfs.validateValues.s3" -}}
{{- if and (not .Values.filer.enabled) .Values.s3.enabled -}}
s3.enabled
    The Filer Server is disabled, but the Amazon S3 API is enabled.
    Please enable the Filer Server (--set filer.enabled=true) or
    disable the Amazon S3 API (--set s3.enabled=false).
{{- end -}}
{{- end -}}

{{/*
Validate values of SeaweedFS - WebDAV
*/}}
{{- define "seaweedfs.validateValues.webdav" -}}
{{- if and (not .Values.filer.enabled) .Values.webdav.enabled -}}
s3.enabled
    The Filer Server is disabled, but WebDAV is enabled.
    Please enable the Filer Server (--set filer.enabled=true) or
    disable WebDAV (--set webdav.enabled=false).
{{- end -}}
{{- end -}}

{{/*
Validate values of SeaweedFS - WebDAV TLS
*/}}
{{- define "seaweedfs.validateValues.webdav.tls" -}}
{{- if and .Values.filer.enabled .Values.webdav.enabled .Values.webdav.tls.enabled .Values.security.mTLS.autoGenerated.enabled -}}
{{- if or (not (empty .Values.webdav.tls.cert)) (not (empty .Values.webdav.tls.key)) -}}
webdav.tls.autoGenerated
    When enabling auto-generated TLS certificates, certificate and key fields must be empty.
    Please disable auto-generated TLS certificates (--set webdav.tls.autoGenerated=false) or
    remove the certificate and key fields (--set webdav.tls.cert="",webdav.tls.key="").
{{- end -}}
{{- if not (empty .Values.webdav.tls.existingSecret) -}}
webdav.tls.autoGenerated
    When enabling auto-generated TLS certificates, the existing secret field must be empty.
    Please disable auto-generated TLS certificates (--set webdav.tls.autoGenerated=false) or
    remove the existing secret field (--set webdav.tls.existingSecret="").
{{- end -}}
{{- if and (ne .Values.webdav.tls.autoGenerated.engine "helm") (ne .Values.webdav.tls.autoGenerated.engine "cert-manager") -}}
webdav.tls.autoGenerated.engine
    Invalid mechanism to generate the TLS certificates selected. Valid values are "helm" and
    "cert-manager". Please set a valid one (--set webdav.tls.autoGenerated.engine="xxx")
{{- end -}}
{{- end -}}
{{- end -}}
