{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper RabbitMQ Cluster Operator fullname
Note: We use the regular common function as the chart name already contains the
the rabbitmq-cluster-operator name.
*/}}
{{- define "rmqco.clusterOperator.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Return the proper RabbitMQ Messaging Topology Operator fullname
NOTE: Not using the common function to avoid generating too long names
*/}}
{{- define "rmqco.msgTopologyOperator.fullname" -}}
{{- if .Values.msgTopologyOperator.fullnameOverride -}}
    {{- printf "%s" .Values.msgTopologyOperator.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.fullnameOverride -}}
    {{- printf "%s-%s" .Values.fullnameOverride "messaging-topology-operator" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- printf "%s-%s" .Release.Name "rabbitmq-messaging-topology-operator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper RabbitMQ Messaging Topology Operator fullname adding the installation's namespace.
*/}}
{{- define "rmqco.msgTopologyOperator.fullname.namespace" -}}
{{- printf "%s-%s" (include "rmqco.msgTopologyOperator.fullname" .) (include "common.names.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper RabbitMQ Messaging Topology Operator fullname
NOTE: Not using the common function to avoid generating too long names
*/}}
{{- define "rmqco.msgTopologyOperator.webhook.fullname" -}}
{{- if .Values.msgTopologyOperator.fullnameOverride -}}
    {{- printf "%s-%s" .Values.msgTopologyOperator.fullnameOverride "webhook" | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.fullnameOverride -}}
    {{- printf "%s-%s" .Values.fullnameOverride "messaging-topology-operator-webhook" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- printf "%s-%s" .Release.Name "rabbitmq-messaging-topology-operator-webhook" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper RabbitMQ Messaging Topology Operator fullname adding the installation's namespace.
*/}}
{{- define "rmqco.msgTopologyOperator.webhook.fullname.namespace" -}}
{{- printf "%s-%s" (include "rmqco.msgTopologyOperator.webhook.fullname" .) (include "common.names.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper RabbitMQ Messaging Topology Operator fullname
*/}}
{{- define "rmqco.msgTopologyOperator.webhook.secretName" -}}
{{- if .Values.msgTopologyOperator.existingWebhookCertSecret -}}
    {{- .Values.msgTopologyOperator.existingWebhookCertSecret -}}
{{- else }}
    {{- include "rmqco.msgTopologyOperator.webhook.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper RabbitMQ Default User Credential updater image name
*/}}
{{- define "rmqco.defaultCredentialUpdater.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.credentialUpdaterImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper RabbitMQ Cluster Operator image name
*/}}
{{- define "rmqco.clusterOperator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.clusterOperator.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper RabbitMQ Cluster Operator image name
*/}}
{{- define "rmqco.msgTopologyOperator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.msgTopologyOperator.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper RabbitMQ image name
*/}}
{{- define "rmqco.rabbitmq.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.rabbitmqImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "rmqco.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.clusterOperator.image .Values.rabbitmqImage) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names as a comma separated string
*/}}
{{- define "rmqco.imagePullSecrets.string" -}}
{{- $pullSecrets := list }}
{{- if .Values.global }}
  {{- range .Values.global.imagePullSecrets -}}
    {{- $pullSecrets = append $pullSecrets . -}}
  {{- end -}}
{{- end -}}
{{- range (list .Values.clusterOperator.image .Values.rabbitmqImage) -}}
  {{- range .pullSecrets -}}
    {{- $pullSecrets = append $pullSecrets . -}}
  {{- end -}}
{{- end -}}
{{- if (not (empty $pullSecrets)) }}
  {{- printf "%s" (join "," $pullSecrets) -}}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use (Cluster Operator)
*/}}
{{- define "rmqco.clusterOperator.serviceAccountName" -}}
{{- if .Values.clusterOperator.serviceAccount.create -}}
    {{ default (printf "%s" (include "rmqco.clusterOperator.fullname" .)) .Values.clusterOperator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.clusterOperator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (Messaging Topology Operator)
*/}}
{{- define "rmqco.msgTopologyOperator.serviceAccountName" -}}
{{- if .Values.msgTopologyOperator.serviceAccount.create -}}
    {{ default (printf "%s" (include "rmqco.msgTopologyOperator.fullname" .)) .Values.msgTopologyOperator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.msgTopologyOperator.serviceAccount.name }}
{{- end -}}
{{- end -}}
