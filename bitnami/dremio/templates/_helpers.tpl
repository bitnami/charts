{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper image name
*/}}
{{- define "dremio.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.dremio.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the default init containers)
*/}}
{{- define "dremio.init-containers.default-image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.defaultInitContainers.defaultImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the sidecar JMX exporter image)
*/}}
{{- define "dremio.metrics.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.metrics.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Dremio Master Coordinator fullname
*/}}
{{- define "dremio.master-coordinator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "master-coordinator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Dremio Coordinator fullname
*/}}
{{- define "dremio.coordinator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "coordinator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Dremio Executor fullname
*/}}
{{- define "dremio.executor.fullname" -}}
{{- printf "%s-executor-%s" (include "common.names.fullname" .context) .engine | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "dremio.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.dremio.image .Values.defaultInitContainers.defaultImage .Values.metrics.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dremio.master-coordinator.dremio-conf.useSecret" -}}
{{- if or .Values.masterCoordinator.dremioConf.existingSecret .Values.dremio.dremioConf.secretConfigOverrides .Values.masterCoordinator.dremioConf.secretConfigOverrides -}}
{{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dremio.coordinator.dremio-conf.useSecret" -}}
{{- if or .Values.coordinator.dremioConf.existingSecret .Values.dremio.dremioConf.secretConfigOverrides .Values.coordinator.dremioConf.secretConfigOverrides -}}
{{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dremio.executor.dremio-conf.useSecret" -}}
{{- if or .executorValues.dremioConf.existingSecret .context.Values.dremio.dremioConf.secretConfigOverrides .executorValues.dremioConf.secretConfigOverrides -}}
{{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Dremio metrics configuration configmap
*/}}
{{- define "dremio.metrics.configmapName" -}}
{{- if .Values.metrics.existingConfigmap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.metrics.existingConfigmap "context" $) -}}
{{- else -}}
    {{- printf "%s-metrics-configuration" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dremio.master-coordinator.serviceAccountName" -}}
{{- if .Values.masterCoordinator.serviceAccount.create -}}
    {{ default (include "dremio.master-coordinator.fullname" .) .Values.masterCoordinator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.masterCoordinator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dremio.coordinator.serviceAccountName" -}}
{{- if .Values.coordinator.serviceAccount.create -}}
    {{ default (include "dremio.coordinator.fullname" .) .Values.coordinator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.coordinator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dremio.executor.serviceAccountName" -}}
{{- if .executorValues.serviceAccount.create -}}
    {{ default (include "dremio.executor.fullname" (dict "engine" .engine "context" .context)) .executorValues.serviceAccount.name }}
{{- else -}}
    {{ default "default" .executorValues.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
dremio.conf ConfigMap (master-coordinator)
*/}}
{{- define "dremio.master-coordinator.dremio-conf.configmapName" -}}
{{- if .Values.masterCoordinator.dremioConf.existingConfigmap -}}
    {{- tpl .Values.masterCoordinator.dremioConf.existingConfigmap $ -}}
{{- else -}}
    {{- printf "%s-dremio-conf" (include "dremio.master-coordinator.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
dremio.conf ConfigMap (coordinator)
*/}}
{{- define "dremio.coordinator.dremio-conf.configmapName" -}}
{{- if .Values.coordinator.dremioConf.existingConfigmap -}}
    {{- tpl .Values.coordinator.dremioConf.existingConfigmap $ -}}
{{- else -}}
    {{- printf "%s-dremio-conf" (include "dremio.coordinator.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
dremio.conf ConfigMap (executor)
*/}}
{{- define "dremio.executor.dremio-conf.configmapName" -}}
{{- if .executorValues.dremioConf.existingConfigmap -}}
    {{- tpl .executorValues.dremioConf.existingConfigmap .context -}}
{{- else -}}
    {{- printf "%s-dremio-conf" (include "dremio.executor.fullname" (dict "context" .context "engine" .engine)) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
dremio.conf ConfigMap (master-coordinator)
*/}}
{{- define "dremio.master-coordinator.dremio-conf.secretName" -}}
{{- if .Values.masterCoordinator.dremioConf.existingSecret -}}
    {{- tpl .Values.masterCoordinator.dremioConf.existingSecret $ -}}
{{- else -}}
    {{- printf "%s-dremio-conf" (include "dremio.master-coordinator.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
dremio.conf ConfigMap (coordinator)
*/}}
{{- define "dremio.coordinator.dremio-conf.secretName" -}}
{{- if .Values.coordinator.dremioConf.existingSecret -}}
    {{- tpl .Values.coordinator.dremioConf.existingSecret $ -}}
{{- else -}}
    {{- printf "%s-dremio-conf" (include "dremio.coordinator.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
dremio.conf ConfigMap (executor)
*/}}
{{- define "dremio.executor.dremio-conf.secretName" -}}
{{- if .executorValues.dremioConf.existingSecret -}}
    {{- tpl .executorValues.dremioConf.existingSecret $ -}}
{{- else -}}
    {{- printf "%s-dremio-conf" (include "dremio.executor.fullname" (dict "context" .context "engine" .engine)) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
core-site.xml Secret
*/}}
{{- define "dremio.core-site.secretName" -}}
{{- if .Values.dremio.coreSite.existingSecret -}}
    {{- tpl .Values.dremio.coreSite.existingSecret $ -}}
{{- else -}}
    {{- printf "%s-core-site" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "dremio.tls.createSecret" -}}
{{- if and .Values.dremio.tls.enabled .Values.dremio.tls.autoGenerated.enabled (not .Values.dremio.tls.existingSecret)  }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Jenkins JKS password secret name
*/}}
{{- define "dremio.tls.passwordSecretName" -}}
{{- $secretName := .Values.dremio.tls.passwordSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-tls-pass" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Scylladb TLS credentials secret
*/}}
{{- define "dremio.tls.secretName" -}}
{{- if .Values.dremio.tls.existingSecret -}}
    {{- print (tpl .Values.dremio.tls.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the Dremio auth credentials secret
*/}}
{{- define "dremio.auth.secretName" -}}
{{- if .Values.dremio.auth.existingSecret -}}
    {{- print (tpl .Values.dremio.auth.existingSecret $) -}}
{{- else -}}
    {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return true if the init job should be created
*/}}
{{- define "dremio.bootstrap-user-job.create" -}}
{{- if and .Values.bootstrapUserJob.enabled .Values.dremio.auth.enabled (or .Release.IsInstall .Values.bootstrapUserJob.forceRun) -}}
    {{- true -}}
{{- else -}}
    {{/* Do not return anything */}}
{{- end -}}
{{- end -}}

{{/*
Return the Dremio auth credentials secret
*/}}
{{- define "dremio.auth.passwordKey" -}}
{{- if .Values.dremio.auth.existingSecretKey -}}
    {{- print (tpl .Values.dremio.auth.existingSecretKey $) -}}
{{- else -}}
    {{- print "dremio-password" -}}
{{- end -}}
{{- end -}}

{{/* Return common dremio.conf configuration */}}
{{- define "dremio.dremio-conf.common.default" -}}
paths.local: {{ .Values.masterCoordinator.persistence.mountPath | quote }}
{{- if or (eq .Values.dremio.distStorageType "minio") (eq .Values.dremio.distStorageType "aws") }}
paths.dist: {{ printf "dremioS3://%s%s" (include "dremio.s3.bucket" .) (include "dremio.s3.path" .) | quote }}
{{- end }}
zookeeper: {{ include "dremio.zookeeper.hosts-with-port" . | quote }}
{{- /* Container ports */}}
services.coordinator.web.port: {{ .Values.dremio.containerPorts.web }}
services.coordinator.client-endpoint.port: {{ .Values.dremio.containerPorts.client }}
services.flight.port: {{ .Values.dremio.containerPorts.flight }}
services.fabric.port: {{ .Values.dremio.containerPorts.fabric }}
services.conduit.port: {{ .Values.dremio.containerPorts.conduit }}
services.web-admin.port: {{ .Values.dremio.containerPorts.liveness }}
services.web-admin.host: {{ print "{{ POD_IP }}" | quote }}
{{- if .Values.dremio.tls.enabled }}
services.coordinator.web.ssl.enabled: true
{{- /* We skip Dremio cert auto-generation and rely on the chart instead */}}
services.coordinator.web.ssl.auto-certificate.enabled: false
services.coordinator.web.ssl.keyStore: "/opt/bitnami/dremio/certs/dremio.jks"
services.coordinator.web.ssl.keyStoreType: "jks"
{{- end }}
{{- end }}

{{/* Return common dremio.conf configuration (sensitive) */}}
{{- define "dremio.dremio-conf.common.defaultSecret" -}}
{{- if .Values.dremio.tls.enabled }}
{{- /* Set the value dependant on env vars so we can use external secrets */ -}}
services.coordinator.web.ssl.keyStorePassword: {{ print "{{ DREMIO_KEYSTORE_PASSWORD }}" | quote }}
{{- end }}
{{- end }}

{{- define "dremio.dremio-conf.flattenYAML" -}}
{{- /* Moving parameters to vars before entering the range */ -}}
{{- $prefix := .prefix -}}
{{- /* Loop through the values of the map */ -}}
{{- range $key, $val := .config -}}
{{- $varName := ternary $key (list $prefix $key | join ".") (eq $prefix "") -}}
{{- if kindOf $val | eq "map" -}}
{{- /* If the variable is a map, we call the helper recursively, adding the semi-computed variable name as the prefix */ -}}
{{ include "dremio.dremio-conf.flattenYAML" (dict "config" $val "prefix" $varName) }}
{{- else }}
{{- /* Base case: We reached to a value that is not a map (sting, integer, boolean, array), so we can build the variable */ -}}
{{- if kindOf $val | eq "slice" -}}
{{- /* If it is an array we use the join function to create an array with commas */}}
{{ $varName }}: [{{ join "," $val  }}]
{{- else if kindOf $val | eq "string" -}}
{{- /* String, quote */}}
{{ $varName }}: {{ $val | quote }}
{{- else -}}
{{- /* Integer or boolean */}}
{{ $varName }}: {{ $val }}
{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO(TM) fullname
*/}}
{{- define "dremio.minio.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "minio" "chartValues" .Values.minio "context" $) -}}
{{- end -}}

{{/*
Return the S3 backend host
*/}}
{{- define "dremio.s3.host" -}}
    {{- if .Values.minio.enabled -}}
        {{- include "dremio.minio.fullname" . -}}
    {{- else -}}
        {{- print .Values.externalS3.host -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 backend host
*/}}
{{- define "dremio.s3.protocol" -}}
    {{- if .Values.minio.enabled -}}
        {{- ternary "https" "http" .Values.minio.tls.enabled -}}
    {{- else -}}
        {{- .Values.externalS3.protocol -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 bucket
*/}}
{{- define "dremio.s3.bucket" -}}
    {{- if .Values.minio.enabled -}}
        {{- print .Values.minio.defaultBuckets -}}
    {{- else -}}
        {{- print .Values.externalS3.bucket -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 region
*/}}
{{- define "dremio.s3.region" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "us-east-1"  -}}
    {{- else -}}
        {{- print .Values.externalS3.region -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 port
*/}}
{{- define "dremio.s3.port" -}}
{{- ternary .Values.minio.service.ports.api .Values.externalS3.port .Values.minio.enabled -}}
{{- end -}}

{{/*
Return the S3 path
*/}}
{{- define "dremio.s3.path" -}}
{{- ternary "/dremio" .Values.externalS3.path .Values.minio.enabled -}}
{{- end -}}

{{/*
Return the S3 credentials secret name
*/}}
{{- define "dremio.s3.secretName" -}}
{{- if .Values.minio.enabled -}}
    {{- if .Values.minio.auth.existingSecret -}}
    {{- print .Values.minio.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "dremio.minio.fullname" .) -}}
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
{{- define "dremio.s3.accessKeyIDKey" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "root-user"  -}}
    {{- else -}}
        {{- print .Values.externalS3.existingSecretAccessKeyIDKey -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 secret access key inside the secret
*/}}
{{- define "dremio.s3.secretAccessKeyKey" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "root-password"  -}}
    {{- else -}}
        {{- print .Values.externalS3.existingSecretKeySecretKey -}}
    {{- end -}}
{{- end -}}

{{/*
Return Zookeeper fullname
*/}}
{{- define "dremio.zookeeper.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "zookeeper" "chartValues" .Values.zookeeper "context" $) -}}
{{- end -}}

{{/*
Return zookeeper port
*/}}
{{- define "dremio.zookeeper.port" -}}
{{- if .Values.zookeeper.enabled -}}
    {{- print .Values.zookeeper.containerPorts.client -}}
{{- else -}}
    {{- print .Values.externalZookeeper.port  -}}
{{- end -}}
{{- end -}}

{{/*
Return zookeeper port
*/}}
{{- define "dremio.zookeeper.hosts-with-port" -}}
{{- $context := . -}}
{{- $res := list -}}
{{- if .Values.zookeeper.enabled -}}
  {{- $fullname := include "dremio.zookeeper.fullname" . -}}
  {{- $port := include "dremio.zookeeper.port" . | int -}}
  {{- range $i, $e := until (.Values.zookeeper.replicaCount | int) -}}
    {{- $res = append $res (printf "%s-%d.%s-headless.%s.svc:%d" $fullname $i $fullname $context.Release.Namespace $port) -}}
  {{- end -}}
{{- else -}}
  {{- $port := .Values.externalZookeeper.port | int -}}
  {{- range .Values.externalZookeeper.servers -}}
    {{- $res = append $res (printf "%s:%d" . $port) -}}
  {{- end -}}
{{- end -}}
{{- join "," $res -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "dremio.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- $messages := append $messages (include "dremio.validateValues.minio" .) -}}
{{- $messages := append $messages (include "dremio.validateValues.extraVolumes" .) -}}
{{- $messages := append $messages (include "dremio.validateValues.executor" .) -}}
{{- $messages := append $messages (include "dremio.validateValues.master-coordinator" .) -}}
{{- $messages := append $messages (include "dremio.validateValues.dist-storage" .) -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of dremio - MinIO is properly configured */}}
{{- define "dremio.validateValues.minio" -}}
{{- if and (eq .Values.dremio.distStoreType "minio") (not .Values.minio.enabled) (not .Values.externalS3.host) -}}
dremio: minio
    Distributed store type is set to minio but endpoint is not configured. Please set minio.enabled=true or configure the externalS3 section.
{{- end -}}
{{- end -}}

{{/* Validate values of dremio - Incorrect extra volume settings */}}
{{- define "dremio.validateValues.extraVolumes" -}}
{{- $componentList := list "masterCoordinator" "coordinator" "executor.common" }}
{{- $values := .Values -}}
{{- range $component := $componentList }}
{{- $componentValues := index $values $component }}
{{- if and $componentValues.extraVolumes (not $componentValues.extraVolumeMounts) }}
dremio: missing-extra-volume-mounts
    You specified {{ $component }}.extraVolumes but not mount points for them. Please set
    the {{ $component }}.extraVolumeMounts value
{{- end }}
{{- end }}
{{- end -}}

{{/* Validate values of dremio - MinIO is properly configured */}}
{{- define "dremio.validateValues.executor" -}}
{{- if not .Values.executor.engines  -}}
dremio: missing-engines
    You did not specify any engine for the executors. Please set the executor.engines section.
{{- end -}}
{{- end -}}

{{/* Validate values of dremio - MinIO is properly configured */}}
{{- define "dremio.validateValues.master-coordinator" -}}
{{- if le (int .Values.masterCoordinator.replicaCount) 0  -}}
dremio: master-coordinator
    Dremio requires a master coordinator. Please set masterCoordinator.replicaCount to a minimum value of 1.
{{- end -}}
{{- end -}}

{{/* Validate values of dremio - MinIO is properly configured */}}
{{- define "dremio.validateValues.dist-storage" -}}
{{- $allowedValues := list "aws" "minio" "other" -}}
{{- if not (has .Values.dremio.distStorageType $allowedValues) -}}
dremio: dist-storage
    Allowed values for `distStorageType` are {{ join "," $allowedValues }}.
{{- end -}}
{{- end -}}
