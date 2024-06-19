{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Milvus image name
*/}}
{{- define "milvus.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.milvus.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Attu image name
*/}}
{{- define "milvus.attu.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.attu.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Init job image name
*/}}
{{- define "milvus.init-job.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.initJob.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Wait container image name
*/}}
{{- define "milvus.wait-container.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.waitContainer.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Milvus Data Coordinator fullname
*/}}
{{- define "milvus.data-coordinator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "data-coordinator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Milvus Data Coordinator service account to use
*/}}
{{- define "milvus.data-coordinator.serviceAccountName" -}}
{{- if .Values.dataCoord.serviceAccount.create -}}
    {{ default (printf "%s" (include "milvus.data-coordinator.fullname" .)) .Values.dataCoord.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.dataCoord.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the configuration configmap for Milvus Data Coordinator
*/}}
{{- define "milvus.data-coordinator.configmapName" -}}
{{- if .Values.dataCoord.existingConfigMap -}}
    {{- .Values.dataCoord.existingConfigMap -}}
{{- else }}
    {{- include "milvus.data-coordinator.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the extra configuration configmap for Milvus Data Coordinator
*/}}
{{- define "milvus.data-coordinator.extraConfigmapName" -}}
{{- if .Values.dataCoord.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Value.dataCoord.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "milvus.data-coordinator.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Milvus Index Coordinator fullname
*/}}
{{- define "milvus.index-coordinator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "index-coordinator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Milvus Index Coordinator service account to use
*/}}
{{- define "milvus.index-coordinator.serviceAccountName" -}}
{{- if .Values.indexCoord.serviceAccount.create -}}
    {{ default (printf "%s" (include "milvus.index-coordinator.fullname" .)) .Values.indexCoord.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.indexCoord.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the extra configuration configmap for Milvus Index Coordinator
*/}}
{{- define "milvus.index-coordinator.configmapName" -}}
{{- if .Values.indexCoord.existingConfigMap -}}
    {{- .Values.indexCoord.existingConfigMap -}}
{{- else }}
    {{- include "milvus.index-coordinator.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the extra configuration configmap for Milvus Index Coordinator
*/}}
{{- define "milvus.index-coordinator.extraConfigmapName" -}}
{{- if .Values.indexCoord.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Value.indexCoord.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "milvus.index-coordinator.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Milvus Query Coordinator fullname
*/}}
{{- define "milvus.query-coordinator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-coordinator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Milvus Query Coordinator service account to use
*/}}
{{- define "milvus.query-coordinator.serviceAccountName" -}}
{{- if .Values.queryCoord.serviceAccount.create -}}
    {{ default (printf "%s" (include "milvus.query-coordinator.fullname" .)) .Values.queryCoord.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.queryCoord.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the configuration configmap for Milvus Query Coordinator
*/}}
{{- define "milvus.query-coordinator.configmapName" -}}
{{- if .Values.queryCoord.existingConfigMap -}}
    {{- .Values.queryCoord.existingConfigMap -}}
{{- else }}
    {{- include "milvus.query-coordinator.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the extra configuration configmap for Milvus Query Coordinator
*/}}
{{- define "milvus.query-coordinator.extraConfigmapName" -}}
{{- if .Values.queryCoord.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Value.queryCoord.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "milvus.query-coordinator.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Milvus Root Coordinator fullname
*/}}
{{- define "milvus.root-coordinator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "root-coordinator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Milvus Root Coordinator service account to use
*/}}
{{- define "milvus.root-coordinator.serviceAccountName" -}}
{{- if .Values.rootCoord.serviceAccount.create -}}
    {{- default (printf "%s" (include "milvus.root-coordinator.fullname" .)) .Values.rootCoord.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.rootCoord.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Get the extra configuration configmap for Milvus Root Coordinator
*/}}
{{- define "milvus.root-coordinator.configmapName" -}}
{{- if .Values.rootCoord.existingConfigMap -}}
    {{- .Values.rootCoord.existingConfigMap -}}
{{- else }}
    {{- include "milvus.root-coordinator.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the extra configuration configmap for Milvus Root Coordinator
*/}}
{{- define "milvus.root-coordinator.extraConfigmapName" -}}
{{- if .Values.rootCoord.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Value.rootCoord.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "milvus.root-coordinator.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Milvus Data Node fullname
*/}}
{{- define "milvus.data-node.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "data-node" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Milvus Data Node service account to use
*/}}
{{- define "milvus.data-node.serviceAccountName" -}}
{{- if .Values.dataNode.serviceAccount.create -}}
    {{ default (printf "%s" (include "milvus.data-node.fullname" .)) .Values.dataNode.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.dataNode.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the configuration configmap for Milvus Data Node
*/}}
{{- define "milvus.data-node.configmapName" -}}
{{- if .Values.dataNode.existingConfigMap -}}
    {{- .Values.dataNode.existingConfigMap -}}
{{- else }}
    {{- include "milvus.data-node.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the extra configuration configmap for Milvus Data Node
*/}}
{{- define "milvus.data-node.extraConfigmapName" -}}
{{- if .Values.dataNode.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Value.dataNode.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "milvus.data-node.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Milvus Index node fullname
*/}}
{{- define "milvus.index-node.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "index-node" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Milvus Index Node service account to use
*/}}
{{- define "milvus.index-node.serviceAccountName" -}}
{{- if .Values.indexNode.serviceAccount.create -}}
    {{ default (printf "%s" (include "milvus.index-node.fullname" .)) .Values.indexNode.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.indexNode.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the configuration configmap for Milvus Index Node
*/}}
{{- define "milvus.index-node.configmapName" -}}
{{- if .Values.indexNode.existingConfigMap -}}
    {{- .Values.indexNode.existingConfigMap -}}
{{- else }}
    {{- include "milvus.index-node.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the extra configuration configmap for Milvus Index Node
*/}}
{{- define "milvus.index-node.extraConfigmapName" -}}
{{- if .Values.indexNode.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Value.indexNode.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "milvus.index-node.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Milvus Query Node fullname
*/}}
{{- define "milvus.query-node.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-node" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Milvus Query Node service account to use
*/}}
{{- define "milvus.query-node.serviceAccountName" -}}
{{- if .Values.queryNode.serviceAccount.create -}}
    {{- default (printf "%s" (include "milvus.query-node.fullname" .)) .Values.queryNode.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.queryNode.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Get the configuration configmap for Milvus Query Node
*/}}
{{- define "milvus.query-node.configmapName" -}}
{{- if .Values.queryNode.existingConfigMap -}}
    {{- .Values.queryNode.existingConfigMap -}}
{{- else }}
    {{- include "milvus.query-node.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the extra configuration configmap for Milvus Query Node
*/}}
{{- define "milvus.query-node.extraConfigmapName" -}}
{{- if .Values.queryNode.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Value.queryNode.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "milvus.query-node.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Milvus Proxy fullname
*/}}
{{- define "milvus.proxy.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "proxy" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Milvus Proxy service account to use
*/}}
{{- define "milvus.proxy.serviceAccountName" -}}
{{- if .Values.proxy.serviceAccount.create -}}
    {{ default (printf "%s" (include "milvus.proxy.fullname" .)) .Values.proxy.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.proxy.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the configuration configmap for Milvus Proxy
*/}}
{{- define "milvus.proxy.configmapName" -}}
{{- if .Values.proxy.existingConfigMap -}}
    {{- .Values.proxy.existingConfigMap -}}
{{- else }}
    {{- include "milvus.proxy.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the extra configuration configmap for Milvus Proxy
*/}}
{{- define "milvus.proxy.extraConfigmapName" -}}
{{- if .Values.proxy.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Value.proxy.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "milvus.proxy.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Attu fullname
*/}}
{{- define "milvus.attu.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "attu" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the Attu service account to use
*/}}
{{- define "milvus.attu.serviceAccountName" -}}
{{- if .Values.attu.serviceAccount.create -}}
    {{ default (printf "%s" (include "milvus.attu.fullname" .)) .Values.attu.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.attu.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "milvus.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.milvus.image .Values.waitContainer.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Get the credentials secret
*/}}
{{- define "milvus.secretName" -}}
{{- if .Values.milvus.auth.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.milvus.auth.existingSecret "context" $) -}}
{{- else }}
    {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the secret password key
*/}}
{{- define "milvus.secretPasswordKey" -}}
{{- if and .Values.milvus.auth.existingSecret .Values.milvus.auth.existingSecretPasswordKey -}}
    {{- print .Values.milvus.auth.existingSecretPasswordKey -}}
{{- else }}
    {{- print "password" -}}
{{- end -}}
{{- end -}}

{{/*
Get the secret password key
*/}}
{{- define "milvus.secretRootPasswordKey" -}}
{{- if and .Values.milvus.auth.existingSecret .Values.milvus.auth.existingSecretPasswordKey -}}
    {{- print .Values.milvus.auth.existingSecretPasswordKey -}}
{{- else }}
    {{- print "root-password" -}}
{{- end -}}
{{- end -}}

{{/*
Get the common configuration configmap.
*/}}
{{- define "milvus.configmapName" -}}
{{- if .Values.milvus.existingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.milvus.existingConfigMap "context" $) -}}
{{- else }}
    {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the common extra configuration configmap.
*/}}
{{- define "milvus.extraConfigmapName" -}}
{{- if .Values.milvus.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Value.milvus.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name for etcd
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.etcd.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "etcd" "chartValues" .Values.etcd "context" $) -}}
{{- end -}}

{{/*
Return etcd port
*/}}
{{- define "milvus.etcd.port" -}}
{{- if .Values.etcd.enabled -}}
    {{/* We are using the headless service so we need to use the container port */}}
    {{- print .Values.etcd.containerPorts.client -}}
{{- else -}}
    {{- print .Values.externalEtcd.port  -}}
{{- end -}}
{{- end -}}

{{/*
Return the etcd headless service name
*/}}
{{- define "milvus.etcd.headlessServiceName" -}}
{{- printf "%s-headless" (include "milvus.etcd.fullname" .) -}}
{{- end -}}

{{/*
Create a default fully qualified app name for kafka
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.kafka.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "kafka" "chartValues" .Values.kafka "context" $) -}}
{{- end -}}

{{/*
Return true if Kafka is used by Milvus
*/}}
{{- define "milvus.kafka.deployed" -}}
    {{- if or .Values.kafka.enabled .Values.externalKafka.servers -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Return kafka port
*/}}
{{- define "milvus.kafka.port" -}}
{{- if .Values.kafka.enabled -}}
    {{- print .Values.kafka.service.ports.client -}}
{{- else -}}
    {{- print .Values.externalKafka.port  -}}
{{- end -}}
{{- end -}}

{{/*
Return the kafka broker-only nodes headless service name
*/}}
{{- define "milvus.kafka.broker.headlessServiceName" -}}
{{- printf "%s-broker-headless" (include "milvus.kafka.fullname" .) -}}
{{- end -}}

{{/*
Return the kafka controller-eligible nodes headless service name
*/}}
{{- define "milvus.kafka.controller.headlessServiceName" -}}
{{- printf "%s-controller-headless" (include "milvus.kafka.fullname" .) -}}
{{- end -}}

{{/*
Return true if kafka authentication is enabled
*/}}
{{- define "milvus.kafka.authEnabled" -}}
{{- $protocol := include "milvus.kafka.securityProtocol" . -}}
{{- if contains "SASL" $protocol -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return Kafka authentication SASL mechanisms
*/}}
{{- define "milvus.kafka.saslMechanisms" -}}
{{- if .Values.kafka.enabled -}}
    {{- print (upper .Values.kafka.sasl.enabledMechanisms) -}}
{{- else -}}
    {{- print (upper .Values.externalKafka.sasl.enabledMechanisms) -}}
{{- end -}}
{{- end -}}

{{/*
Return Kafka security protocol
*/}}
{{- define "milvus.kafka.securityProtocol" -}}
{{- if .Values.kafka.enabled -}}
    {{- print (upper .Values.kafka.listeners.client.protocol) -}}
{{- else -}}
    {{- print (upper .Values.externalKafka.listener.protocol) -}}
{{- end -}}
{{- end -}}

{{/*
Return kafka credential secret name
*/}}
{{- define "milvus.kafka.secretName" -}}
{{- if .Values.kafka.enabled -}}
    {{- printf "%s-user-passwords" (include "milvus.kafka.fullname" .) -}}
{{- else if .Values.externalKafka.sasl.existingSecret -}}
    {{- print .Values.externalKafka.sasl.existingSecret -}}
{{- else -}}
    {{- printf "%s-external-kafka" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return kafka secret password key
*/}}
{{- define "milvus.kafka.secretPasswordKey" -}}
{{- if .Values.kafka.enabled -}}
    {{- print "system-user-password" -}}
{{- else -}}
    {{- print .Values.externalKafka.sasl.existingSecretPasswordKey -}}
{{- end -}}
{{- end -}}

{{/*
Return kafka username
*/}}
{{- define "milvus.kafka.user" -}}
{{- if .Values.kafka.enabled -}}
    {{- print (index .Values.kafka.sasl.client.users 0) -}}
{{- else -}}
    {{- print .Values.externalKafka.sasl.user -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO(TM) fullname
*/}}
{{- define "milvus.minio.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "minio" "chartValues" .Values.minio "context" $) -}}
{{- end -}}

{{/*
Return the S3 backend host
*/}}
{{- define "milvus.s3.host" -}}
    {{- if .Values.minio.enabled -}}
        {{- include "milvus.minio.fullname" . -}}
    {{- else -}}
        {{- print .Values.externalS3.host -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 bucket
*/}}
{{- define "milvus.s3.bucket" -}}
    {{- if .Values.minio.enabled -}}
        {{- print .Values.minio.defaultBuckets -}}
    {{- else -}}
        {{- print .Values.externalS3.bucket -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 protocol
*/}}
{{- define "milvus.s3.protocol" -}}
    {{- if .Values.minio.enabled -}}
        {{- ternary "https" "http" .Values.minio.tls.enabled  -}}
    {{- else -}}
        {{- print .Values.externalS3.protocol -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 root path
*/}}
{{- define "milvus.s3.rootPath" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "file"  -}}
    {{- else -}}
        {{- print .Values.externalS3.rootPath -}}
    {{- end -}}
{{- end -}}

{{/*
Return true if IAM is used (this is for cloud providers)
*/}}
{{- define "milvus.s3.useIAM" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "false"  -}}
    {{- else -}}
        {{- print .Values.externalS3.useIAM -}}
    {{- end -}}
{{- end -}}

{{/*
Return true if TLS is used
*/}}
{{- define "milvus.s3.useSSL" -}}
    {{- if .Values.minio.enabled -}}
        {{- .Values.minio.tls.enabled  -}}
    {{- else if (eq .Values.externalS3.protocol "https") -}}
        {{- print "true" -}}
    {{- else -}}
        {{- print "false" -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 port
*/}}
{{- define "milvus.s3.port" -}}
{{- ternary .Values.minio.service.ports.api .Values.externalS3.port .Values.minio.enabled -}}
{{- end -}}

{{/*
Return the S3 credentials secret name
*/}}
{{- define "milvus.s3.secretName" -}}
{{- if .Values.minio.enabled -}}
    {{- if .Values.minio.auth.existingSecret -}}
    {{- print .Values.minio.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "milvus.minio.fullname" .) -}}
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
{{- define "milvus.s3.accessKeyIDKey" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "root-user"  -}}
    {{- else -}}
        {{- print .Values.externalS3.existingSecretAccessKeyIDKey -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 secret access key inside the secret
*/}}
{{- define "milvus.s3.secretAccessKeyKey" -}}
    {{- if .Values.minio.enabled -}}
        {{- print "root-password"  -}}
    {{- else -}}
        {{- print .Values.externalS3.existingSecretKeySecretKey -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 secret access key inside the secret
*/}}
{{- define "milvus.s3.deployed" -}}
    {{- if or .Values.minio.enabled .Values.externalS3.host -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "milvus.waitForETCDInitContainer" -}}
- name: wait-for-etcd
  image: {{ template "milvus.wait-container.image" . }}
  imagePullPolicy: {{ .Values.waitContainer.image.pullPolicy }}
  {{- if .Values.waitContainer.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.waitContainer.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.waitContainer.resources }}
  resources: {{- toYaml .Values.waitContainer.resources | nindent 4 }}
  {{- else if ne .Values.waitContainer.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.waitContainer.resourcesPreset) | nindent 4 }}
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

      etcd_hosts=(
      {{- if .Values.etcd.enabled  }}
        "{{ ternary "https" "http" $.Values.etcd.auth.client.secureTransport }}://{{ printf "%s:%v" (include "milvus.etcd.fullname" $ ) (include "milvus.etcd.port" $ ) }}"
      {{- else }}
      {{- range $node :=.Values.externalEtcd.servers }}
        "{{ ternary "https" "http" $.Values.externalEtcd.tls.enabled }}://{{ printf "%s:%v" $node (include "milvus.etcd.port" $) }}"
      {{- end }}
      {{- end }}
      )

      check_etcd() {
          local -r etcd_host="${1:-?missing etcd}"
          local params_cert=""

          if echo $etcd_host | grep https; then
             params_cert="--cacert /bitnami/milvus/conf/cert/etcd/client/{{ .Values.externalEtcd.tls.caCert }} --cert /bitnami/milvus/conf/cert/etcd/client/{{ .Values.externalEtcd.tls.cert }} --key /bitnami/milvus/conf/cert/etcd/client/{{ .Values.externalEtcd.tls.key }}"
          fi
          if [ ! -z {{ .Values.externalEtcd.tls.keyPassword }} ]; then
            params_cert=$params_cert" --pass {{  .Values.externalEtcd.tls.keyPassword }}"
          fi
          if curl --max-time 5 "${etcd_host}/version" $params_cert | grep etcdcluster; then
             return 0
          else
             return 1
          fi
      }

      for host in "${etcd_hosts[@]}"; do
          echo "Checking connection to $host"
          if retry_while "check_etcd $host"; then
              echo "Connected to $host"
          else
              echo "Error connecting to $host"
              exit 1
          fi
      done

      echo "Connection success"
      exit 0
  {{- if and .Values.externalEtcd.tls.enabled .Values.externalEtcd.tls.existingSecret }}
  volumeMounts:
    - name: etcd-client-certs
      mountPath: /bitnami/milvus/conf/cert/etcd/client
      readOnly: true
  {{- end }}
{{- end -}}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "milvus.waitForS3InitContainer" -}}
- name: wait-for-s3
  image: {{ template "milvus.wait-container.image" . }}
  imagePullPolicy: {{ .Values.waitContainer.image.pullPolicy }}
  {{- if .Values.waitContainer.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.waitContainer.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.waitContainer.resources }}
  resources: {{- toYaml .Values.waitContainer.resources | nindent 4 }}
  {{- else if ne .Values.waitContainer.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.waitContainer.resourcesPreset) | nindent 4 }}
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

      check_s3() {
          local -r s3_host="${1:-?missing s3}"
          if curl --max-time 5 "${s3_host}" | grep "RequestId"; then
             return 0
          else
             return 1
          fi
      }

      host={{ printf "%v:%v" (include "milvus.s3.host" .) (include "milvus.s3.port" .) }}

      echo "Checking connection to $host"
      if retry_while "check_s3 $host"; then
        echo "Connected to $host"
      else
        echo "Error connecting to $host"
        exit 1
      fi

      echo "Connection success"
      exit 0
{{- end -}}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "milvus.waitForKafkaInitContainer" -}}
- name: wait-for-kafka
  image: {{ template "milvus.image" . }} {{/* Bitnami shell does not have wait-for-port */}}
  imagePullPolicy: {{ .Values.waitContainer.image.pullPolicy }}
  {{- if .Values.waitContainer.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.waitContainer.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.waitContainer.resources }}
  resources: {{- toYaml .Values.waitContainer.resources | nindent 4 }}
  {{- else if ne .Values.waitContainer.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.waitContainer.resourcesPreset) | nindent 4 }}
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

      kafka_hosts=(
      {{- if .Values.kafka.enabled  }}
        {{ include "milvus.kafka.fullname" . | quote }}
      {{- else }}
      {{- range $node :=.Values.externalKafka.servers }}
        {{ print $node | quote }}
      {{- end }}
      {{- end }}
      )

      check_kafka() {
          local -r kafka_host="${1:-?missing kafka}"
          if wait-for-port --timeout=5 --host=${kafka_host} --state=inuse {{ include "milvus.kafka.port" . }}; then
             return 0
          else
             return 1
          fi
      }

      for host in "${kafka_hosts[@]}"; do
          echo "Checking connection to $host"
          if retry_while "check_kafka $host"; then
              echo "Connected to $host"
          else
              echo "Error connecting to $host"
              exit 1
          fi
      done

      echo "Connection success"
      exit 0
{{- end -}}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "milvus.waitForProxyInitContainer" -}}
- name: wait-for-proxy
  image: {{ template "milvus.image" . }} {{/* Bitnami shell does not have wait-for-port */}}
  imagePullPolicy: {{ .Values.waitContainer.image.pullPolicy }}
  {{- if .Values.waitContainer.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.waitContainer.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.waitContainer.resources }}
  resources: {{- toYaml .Values.waitContainer.resources | nindent 4 }}
  {{- else if ne .Values.waitContainer.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.waitContainer.resourcesPreset) | nindent 4 }}
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

      check_proxy() {
          local -r proxy_host="${1:-?missing proxy}"
          if wait-for-port --timeout=5 --host=${proxy_host} --state=inuse {{ .Values.proxy.service.ports.grpc }}; then
             return 0
          else
             return 1
          fi
      }

      host={{ include "milvus.proxy.fullname" . | quote }}

      echo "Checking connection to $host"
      if retry_while "check_proxy $host"; then
          echo "Connected to $host"
      else
          echo "Error connecting to $host"
          exit 1
      fi

      echo "Connection success"
      exit 0
{{- end -}}


{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "milvus.prepareMilvusInitContainer" -}}
# This init container renders and merges the Milvus configuration files.
# We need to use a volume because we're working with ReadOnlyRootFilesystem
- name: prepare-milvus
  image: {{ template "milvus.image" .context }}
  imagePullPolicy: {{ .context.Values.milvus.image.pullPolicy }}
  {{- $block := index .context.Values .component }}
  {{- if $block.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" $block.containerSecurityContext "context" .context) | nindent 4 }}
  {{- end }}
  {{- if $block.resources }}
  resources: {{- toYaml $block.resources | nindent 4 }}
  {{- else if ne $block.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" $block.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash
      # Remove previously existing files and copy the default configuration files to ensure they are present in mounted configs directory
      rm -rf /bitnami/milvus/rendered-conf/*
      cp -r /opt/bitnami/milvus/configs/. /bitnami/milvus/rendered-conf
      # Build final milvus.yaml with the sections of the different files
      find /bitnami/milvus/conf -type f -name *.yaml -print0 | sort -z | xargs -0 yq eval-all '. as $item ireduce ({}; . * $item )' /bitnami/milvus/rendered-conf/milvus.yaml > /bitnami/milvus/rendered-conf/pre-render-config_00.yaml

      # Kafka settings
      {{- if (include "milvus.kafka.deployed" .context) }}
      # HACK: In order to enable Kafka we need to remove all Pulsar settings from the configuration file
      # https://github.com/milvus-io/milvus/blob/master/configs/milvus.yaml#L110
      yq 'del(.pulsar)' /bitnami/milvus/rendered-conf/pre-render-config_00.yaml > /bitnami/milvus/rendered-conf/pre-render-config_01.yaml
      # Kafka TLS settings
      {{- if and (not .context.Values.kafka.enabled) .context.Values.externalKafka.tls.enabled .context.Values.externalKafka.tls.existingSecret }}
      yq e -i '.kafka.ssl.enabled = true' /bitnami/milvus/rendered-conf/pre-render-config_01.yaml
      {{- if and .context.Values.externalKafka.tls.cert .context.Values.externalKafka.tls.key }}
      yq e -i '.kafka.ssl.tlsCert = "/opt/bitnami/milvus/configs/cert/kafka/client/{{ .context.Values.externalKafka.tls.cert }}"' /bitnami/milvus/rendered-conf/pre-render-config_01.yaml
      yq e -i '.kafka.ssl.tlsKey = "/opt/bitnami/milvus/configs/cert/kafka/client/{{ .context.Values.externalKafka.tls.key }}"' /bitnami/milvus/rendered-conf/pre-render-config_01.yaml
      {{- end }}
      {{- if .context.Values.externalKafka.tls.caCert }}
      yq e -i '.kafka.ssl.tlsCaCert = "/opt/bitnami/milvus/configs/cert/kafka/client/{{ .context.Values.externalKafka.tls.caCert }}"' /bitnami/milvus/rendered-conf/pre-render-config_01.yaml
      {{- end }}
      {{- if .context.Values.externalKafka.tls.keyPassword }}
      yq e -i '.kafka.ssl.tlsKeyPassword = {{ print "{{ MILVUS_KAFKA_TLS_KEY_PASSWORD }}" | quote }}' /bitnami/milvus/rendered-conf/pre-render-config_01.yaml
      {{- end }}
      {{- end }}
      {{- else }}
      mv /bitnami/milvus/rendered-conf/pre-render-config_00.yaml /bitnami/milvus/rendered-conf/pre-render-config_01.yaml
      {{- end }}

      # Milvus server TLS settings
      yq e '.common.security.tlsMode = {{ .context.Values.proxy.tls.mode }}' /bitnami/milvus/rendered-conf/pre-render-config_01.yaml > /bitnami/milvus/rendered-conf/pre-render-config_02.yaml
      {{- if ne (int .context.Values.proxy.tls.mode) 0 }}
      yq e -i '.tls.serverPemPath = "/opt/bitnami/milvus/configs/cert/milvus/{{ .context.Values.proxy.tls.cert }}"' /bitnami/milvus/rendered-conf/pre-render-config_02.yaml
      yq e -i '.tls.serverKeyPath = "/opt/bitnami/milvus/configs/cert/milvus/{{ .context.Values.proxy.tls.key }}"' /bitnami/milvus/rendered-conf/pre-render-config_02.yaml
      {{- if eq (int .context.Values.proxy.tls.mode) 2 }}
      yq e -i '.tls.caPemPath = "/opt/bitnami/milvus/configs/cert/milvus/{{ .context.Values.proxy.tls.caCert }}"' /bitnami/milvus/rendered-conf/pre-render-config_02.yaml
      {{- end }}
      {{- end }}

      render-template /bitnami/milvus/rendered-conf/pre-render-config_02.yaml > /bitnami/milvus/rendered-conf/milvus.yaml
      rm /bitnami/milvus/rendered-conf/pre-render-config*
      chmod 644 /bitnami/milvus/rendered-conf/milvus.yaml
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .context.Values.milvus.image.debug .context.Values.diagnosticMode.enabled) | quote }}
    {{- if (include "milvus.kafka.deployed" .context) }}
    {{- if (include "milvus.kafka.authEnabled" .context) }}
    - name: MILVUS_KAFKA_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "milvus.kafka.secretName" .context }}
          key: {{ include "milvus.kafka.secretPasswordKey" .context }}
    {{- end }}
    {{- if and .context.Values.externalKafka.tls.enabled .context.Values.externalKafka.tls.keyPassword .context.Values.externalKafka.tls.existingSecret }}
    - name: MILVUS_KAFKA_TLS_KEY_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ printf "%s-external-kafka-tls-passwords" (include "common.names.fullname" .context) }}
          key: key-password
    {{- end }}
    {{- end }}
    {{- if and (include "milvus.s3.deployed" .context) }}
    - name: MILVUS_S3_ACCESS_ID
      valueFrom:
        secretKeyRef:
          name: {{ include "milvus.s3.secretName" .context }}
          key: {{ include "milvus.s3.accessKeyIDKey" .context }}
    - name: MILVUS_S3_SECRET_ACCESS_KEY
      valueFrom:
        secretKeyRef:
          name: {{ include "milvus.s3.secretName" .context }}
          key: {{ include "milvus.s3.secretAccessKeyKey" .context }}
    {{- end }}
    {{- if $block.extraEnvVars }}
    {{- include "common.tplvalues.render" (dict "value" $block.extraEnvVars "context" $) | nindent 4 }}
    {{- end }}
  envFrom:
    {{- if $block.extraEnvVarsCM }}
    - configMapRef:
        name: {{ include "common.tplvalues.render" (dict "value" $block.extraEnvVarsCM "context" .context) }}
    {{- end }}
    {{- if $block.extraEnvVarsSecret }}
    - secretRef:
        name: {{ include "common.tplvalues.render" (dict "value" $block.extraEnvVarsSecret "context" $) }}
    {{- end }}
  volumeMounts:
    - name: config-common
      mountPath: /bitnami/milvus/conf/00_default
    {{- if or .context.Values.milvus.extraConfig .context.Values.milvus.extraConfigExistingConfigMap }}
    - name: extra-config-common
      mountPath: /bitnami/milvus/conf/01_extra_common
    {{- end }}
    - name: component-config-default
      mountPath: /bitnami/milvus/conf/02_component_default
    {{- if or $block.extraConfig $block.extraConfigExistingConfigMap }}
    - name: component-extra-config
      mountPath: /bitnami/milvus/conf/03_extra
    {{- end }}
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    - name: empty-dir
      mountPath: /bitnami/milvus/rendered-conf/
      subPath: app-rendered-conf-dir
{{- end -}}

{{/*
Return true if the init job should be created
*/}}
{{- define "milvus.init-job.create" -}}
{{- if or (and .Values.milvus.auth.enabled .Release.IsInstall) .Values.initJob.forceRun -}}
    {{- true -}}
{{- else -}}
    {{/* Do not return anything */}}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "milvus.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.milvus.image }}
{{- include "common.warnings.rollingTag" .Values.attu.image }}
{{- include "common.warnings.rollingTag" .Values.initJob.image }}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "milvus.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "milvus.validateValues.controllers" .) -}}
{{- $messages := append $messages (include "milvus.validateValues.attu" .) -}}
{{- $messages := append $messages (include "milvus.validateValues.proxy.tls" .) -}}
{{- $messages := append $messages (include "milvus.validateValues.initJob.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail  -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the controller deployment
*/}}
{{- define "milvus.validateValues.controllers" -}}
{{- if not (or .Values.dataCoord.enabled .Values.rootCoord.enabled .Values.indexCoord.enabled .Values.queryCoord.enabled .Values.dataNode.enabled .Values.queryNode.enabled .Values.indexNode.enabled) -}}
milvus: Missing controllers. At least one controller should be enabled.
{{- end -}}
{{- end -}}

{{/*
Function to validate the controller deployment
*/}}
{{- define "milvus.validateValues.attu" -}}
{{- if and .Values.attu.enabled (not .Values.proxy.enabled) -}}
attu: Attu requires the Milvus proxy to be enabled
{{- end -}}
{{- end -}}

{{/*
Function to validate the proxy tls configurations
*/}}
{{- define "milvus.validateValues.proxy.tls" -}}
{{- if .Values.proxy.enabled -}}
{{- $modeList := list 0 1 2 -}}
{{- if not (has (int .Values.proxy.tls.mode) $modeList) -}}
proxy: tls mode must be in [0, 1, 2]
{{- end -}}
{{- if ne (int .Values.proxy.tls.mode) 0 -}}
{{- if empty .Values.proxy.tls.existingSecret -}}
proxy: existingSecret can not be empty when tls mode is not 0
{{- end -}}
{{- if and (eq (int .Values.proxy.tls.mode) 1) (or (empty .Values.proxy.tls.cert) (empty .Values.proxy.tls.key)) -}}
proxy: cert and key can not be empty when tls mode is 1
{{- end -}}
{{- if and (eq (int .Values.proxy.tls.mode) 2) (or (empty .Values.proxy.tls.cert) (empty .Values.proxy.tls.key) (empty .Values.proxy.tls.caCert)) -}}
proxy: cert, key and caCert can not be empty when tls mode is 2
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the initJob tls configurations
*/}}
{{- define "milvus.validateValues.initJob.tls" -}}
{{- if and .Values.proxy.enabled (ne (int .Values.proxy.tls.mode) 0) -}}
{{- if empty .Values.initJob.tls.existingSecret -}}
initJob: existingSecret can not be empty when proxy tls mode is not 0
{{- end -}}
{{- if and (eq (int .Values.proxy.tls.mode) 1) (empty .Values.initJob.tls.cert) -}}
initJob: cert can not be empty when proxy tls mode is 1
{{- end -}}
{{- if and (eq (int .Values.proxy.tls.mode) 2) (or (empty .Values.initJob.tls.cert) (empty .Values.initJob.tls.key) (empty .Values.initJob.tls.caCert)) -}}
initJob: cert, key and caCert can not be empty when proxy tls mode is 2
{{- end -}}
{{- end -}}
{{- end -}}
