{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Cilium Agent fullname
*/}}
{{- define "cilium.agent.fullname" -}}
{{- printf "%s-agent" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Cilium Operator fullname
*/}}
{{- define "cilium.operator.fullname" -}}
{{- printf "%s-operator" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Cilium Envoy fullname
*/}}
{{- define "cilium.envoy.fullname" -}}
{{- printf "%s-envoy" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Hubble Relay fullname
*/}}
{{- define "cilium.hubble.relay.fullname" -}}
{{- printf "%s-hubble-relay" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Hubble UI fullname
*/}}
{{- define "cilium.hubble.ui.fullname" -}}
{{- printf "%s-hubble-ui" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Cilium Agent fullname (with namespace)
*/}}
{{- define "cilium.agent.fullname.namespace" -}}
{{- printf "%s-agent" (include "common.names.fullname.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Cilium Operator fullname (with namespace)
*/}}
{{- define "cilium.operator.fullname.namespace" -}}
{{- printf "%s-operator" (include "common.names.fullname.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Hubble UI fullname
*/}}
{{- define "cilium.hubble.ui.fullname.namespace" -}}
{{- printf "%s-hubble-ui" (include "common.names.fullname.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Cilium key-value store fullname
*/}}
{{- define "cilium.kvstore.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "etcd" "chartValues" .Values.etcd "context" $) -}}
{{- end -}}

{{/*
Return the proper Cilium Agent image name
*/}}
{{- define "cilium.agent.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.agent.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Cilium Operator image name
*/}}
{{- define "cilium.operator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.operator.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Cilium Operator image name
*/}}
{{- define "cilium.envoy.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.envoy.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Hubble Relay image name
*/}}
{{- define "cilium.hubble.relay.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.hubble.relay.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Hubble UI Frontend image name
*/}}
{{- define "cilium.hubble.ui.frontend.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.hubble.ui.frontend.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Hubble UI Backend image name
*/}}
{{- define "cilium.hubble.ui.backend.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.hubble.ui.backend.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "cilium.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.agent.image .Values.operator.image .Values.envoy.image .Values.hubble.relay.image .Values.hubble.ui.frontend.image .Values.hubble.ui.backend.image) "context" $) -}}
{{- end -}}

{{/*
Return the Cilium configuration configmap.
*/}}
{{- define "cilium.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- print (tpl .Values.existingConfigmap $) -}}
{{- else -}}
    {{- print (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Cilium configuration configmap.
*/}}
{{- define "cilium.envoy.configmapName" -}}
{{- if .Values.envoy.existingConfigmap -}}
    {{- print (tpl .Values.envoy.existingConfigmap $) -}}
{{- else -}}
    {{- print (include "cilium.envoy.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Hubble Relay configuration configmap.
*/}}
{{- define "cilium.hubble.relay.configmapName" -}}
{{- if .Values.hubble.relay.existingConfigmap -}}
    {{- print (tpl .Values.hubble.relay.existingConfigmap $) -}}
{{- else -}}
    {{- print (include "cilium.hubble.relay.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Hubble UI frontend configuration configmap.
*/}}
{{- define "cilium.hubble.ui.frontend.configmapName" -}}
{{- if .Values.hubble.ui.frontend.existingServerBlockConfigmap -}}
    {{- print (tpl .Values.hubble.ui.frontend.existingServerBlockConfigmap $) -}}
{{- else -}}
    {{- printf "%s-server-block" (include "cilium.hubble.ui.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for Cilium Agent
*/}}
{{- define "cilium.agent.serviceAccountName" -}}
{{- if .Values.agent.serviceAccount.create -}}
    {{ default (include "cilium.agent.fullname" .) .Values.agent.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.agent.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for Cilium Operator
*/}}
{{- define "cilium.operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create -}}
    {{ default (include "cilium.operator.fullname" .) .Values.operator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.operator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for Cilium Envoy
*/}}
{{- define "cilium.envoy.serviceAccountName" -}}
{{- if .Values.envoy.serviceAccount.create -}}
    {{ default (include "cilium.envoy.fullname" .) .Values.envoy.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.envoy.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for Hubble Relay
*/}}
{{- define "cilium.hubble.relay.serviceAccountName" -}}
{{- if .Values.hubble.relay.serviceAccount.create -}}
    {{ default (include "cilium.hubble.relay.fullname" .) .Values.hubble.relay.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.hubble.relay.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for Hubble UI
*/}}
{{- define "cilium.hubble.ui.serviceAccountName" -}}
{{- if .Values.hubble.ui.serviceAccount.create -}}
    {{ default (include "cilium.hubble.ui.fullname" .) .Values.hubble.ui.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.hubble.ui.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the TLS certificates for Hubble peers
*/}}
{{- define "cilium.hubble.tls.peers.secretName" -}}
{{- if or .Values.hubble.tls.autoGenerated.enabled (and (not (empty .Values.hubble.tls.peers.cert)) (not (empty .Values.hubble.tls.peers.key))) -}}
    {{- printf "%s-hubble-peers-crt" (include "common.names.fullname" .) -}}
{{- else -}}
    {{- required "An existing secret name must be provided with TLS certs for Hubble peers if cert and key are not provided!" (tpl .Values.hubble.tls.peers.existingSecret .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the TLS certificates for Hubble relay
*/}}
{{- define "cilium.hubble.tls.relay.secretName" -}}
{{- if or .Values.hubble.tls.autoGenerated.enabled (and (not (empty .Values.hubble.tls.relay.cert)) (not (empty .Values.hubble.tls.relay.key))) -}}
    {{- printf "%s-crt" (include "cilium.hubble.relay.fullname" .) -}}
{{- else -}}
    {{- required "An existing secret name must be provided with TLS certs for Hubble relay if cert and key are not provided!" (tpl .Values.hubble.tls.relay.existingSecret .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the TLS certificates for Hubble relay client(s)
*/}}
{{- define "cilium.hubble.tls.relayClient.secretName" -}}
{{- if or .Values.hubble.tls.autoGenerated.enabled (and (not (empty .Values.hubble.tls.relayClient.cert)) (not (empty .Values.hubble.tls.relayClient.key))) -}}
    {{- printf "%s-client-crt" (include "cilium.hubble.relay.fullname" .) -}}
{{- else -}}
    {{- required "An existing secret name must be provided with TLS certs for Hubble relay client(s) if cert and key are not provided!" (tpl .Values.hubble.tls.relayClient.existingSecret .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the host's CNI bin directory
*/}}
{{- define "cilium.agent.hostCNIBinDir" -}}
{{- if .Values.agent.cniPlugin.hostCNIBinDir -}}
    {{- print .Values.agent.cniPlugin.hostCNIBinDir -}}
{{- else if .Values.gcp.enabled -}}
    {{- print "/home/kubernetes/bin" -}}
{{- else -}}
    {{- print "/opt/cni/bin" -}}
{{- end -}}
{{- end -}}

{{/*
Return the host's CNI net configuration directory
*/}}
{{- define "cilium.agent.hostCNINetDir" -}}
{{- default "/etc/cni/net.d" .Values.agent.cniPlugin.hostCNINetDir -}}
{{- end -}}

{{/*
Return the default Cilium Operator command
*/}}
{{- define "cilium.operator.command" -}}
{{- if .Values.operator.command -}}
{{- include "common.tplvalues.render" (dict "value" .Values.operator.command "context" .) -}}
{{- else if .Values.azure.enabled -}}
- cilium-operator-azure
{{- else if .Values.aws.enabled -}}
- cilium-operator-aws
{{- else -}}
- cilium-operator-generic
{{- end -}}
{{- end -}}

{{/*
Return the key-value store endpoints
*/}}
{{- define "cilium.kvstore.endpoints" -}}
{{- if .Values.etcd.enabled -}}
    {{- $svcName := include "cilium.kvstore.fullname" . -}}
    {{- $port := int .Values.etcd.service.ports.client -}}
    {{- printf "- http://%s:%d" $svcName $port -}}
{{- else if .Values.externalKvstore.enabled -}}
    {{- range $endpoint := .Values.externalKvstore.endpoints -}}
        {{- printf "- http://%s" $endpoint -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the key-value store port
*/}}
{{- define "cilium.kvstore.port" -}}
{{- if .Values.etcd.enabled -}}
    {{- printf "%d" int .Values.etcd.service.ports.client -}}
{{- else if .Values.externalKvstore.enabled -}}
    {{- print "2379" -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "cilium.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "cilium.validateValues.kvstore" .) -}}
{{- $messages := append $messages (include "cilium.validateValues.hubble.ui" .) -}}
{{- $messages := append $messages (include "cilium.validateValues.agent.serviceMonitor" .) -}}
{{- $messages := append $messages (include "cilium.validateValues.operator.serviceMonitor" .) -}}
{{- $messages := append $messages (include "cilium.validateValues.envoy.serviceMonitor" .) -}}
{{- $messages := append $messages (include "cilium.validateValues.hubble.peers.serviceMonitor" .) -}}
{{- $messages := append $messages (include "cilium.validateValues.hubble.relay.serviceMonitor" .) -}}
{{- $messages := append $messages (include "cilium.validateValues.provider" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Cilium - KeyValue Store
*/}}
{{- define "cilium.validateValues.kvstore" -}}
{{- if and .Values.etcd.enabled .Values.externalKvstore.enabled -}}
etcd.enabled and externalKvstore.enabled
    Both etcd and externalKvstore are enabled. Please enable only one key-value store.
{{- end -}}
{{- end -}}

{{/*
Validate values of Cilium - Hubble UI
*/}}
{{- define "cilium.validateValues.hubble.ui" -}}
{{- if and (not .Values.hubble.relay.enabled) .Values.hubble.ui.enabled -}}
hubble.ui.enabled
    Hubble UI is enabled but Hubble Relay is disabled, please note Hubble Relay is mandatory
    for Hubble UI to work. To enable Hubble UI, also set `hubble.relay.enabled` to `true`.
{{- end -}}
{{- end -}}

{{/*
Validate values of Cilium - ServiceMonitor for Cilium Agent
*/}}
{{- define "cilium.validateValues.agent.serviceMonitor" -}}
{{- if and (not .Values.agent.metrics.enabled) .Values.agent.metrics.serviceMonitor.enabled -}}
agent.metrics.serviceMonitor.enabled
    A ServiceMonitor for Prometheus Operatos is enabled but metrics are disabled.
    In order to prevent Prometheus from scraping an empty endpoint, the ServiceMonitor resource
    will be skipped. To enable the ServiceMonitor, also set `agent.metrics.enabled` to `true`.
{{- end -}}
{{- end -}}

{{/*
Validate values of Cilium - ServiceMonitor for Cilium Operator
*/}}
{{- define "cilium.validateValues.operator.serviceMonitor" -}}
{{- if and (not .Values.operator.metrics.enabled) .Values.operator.metrics.serviceMonitor.enabled -}}
operator.metrics.serviceMonitor.enabled
    A ServiceMonitor for Prometheus Operatos is enabled but metrics are disabled.
    In order to prevent Prometheus from scraping an empty endpoint, the ServiceMonitor resource
    will be skipped. To enable the ServiceMonitor, also set `operator.metrics.enabled` to `true`.
{{- end -}}
{{- end -}}

{{/*
Validate values of Cilium - ServiceMonitor for Cilium Agent
*/}}
{{- define "cilium.validateValues.envoy.serviceMonitor" -}}
{{- if and (not .Values.envoy.metrics.enabled) .Values.envoy.metrics.serviceMonitor.enabled -}}
envoy.metrics.serviceMonitor.enabled
    A ServiceMonitor for Prometheus Operatos is enabled but metrics are disabled.
    In order to prevent Prometheus from scraping an empty endpoint, the ServiceMonitor resource
    will be skipped. To enable the ServiceMonitor, also set `envoy.metrics.enabled` to `true`.
{{- end -}}
{{- end -}}

{{/*
Validate values of Cilium - ServiceMonitor for Hubble Peers
*/}}
{{- define "cilium.validateValues.hubble.peers.serviceMonitor" -}}
{{- if and (not .Values.hubble.peers.metrics.enabled) .Values.hubble.peers.metrics.serviceMonitor.enabled -}}
hubble.peers.metrics.serviceMonitor.enabled
    A ServiceMonitor for Prometheus Operatos is enabled but metrics are disabled.
    In order to prevent Prometheus from scraping an empty endpoint, the ServiceMonitor resource
    will be skipped. To enable the ServiceMonitor, also set `hubble.peers.metrics.enabled` to `true`.
{{- end -}}
{{- end -}}

{{/*
Validate values of Cilium - ServiceMonitor for Hubble Relay
*/}}
{{- define "cilium.validateValues.hubble.relay.serviceMonitor" -}}
{{- if and (not .Values.hubble.relay.metrics.enabled) .Values.hubble.relay.metrics.serviceMonitor.enabled -}}
hubble.relay.metrics.serviceMonitor.enabled
    A ServiceMonitor for Prometheus Operatos is enabled but metrics are disabled.
    In order to prevent Prometheus from scraping an empty endpoint, the ServiceMonitor resource
    will be skipped. To enable the ServiceMonitor, also set `hubble.relay.metrics.enabled` to `true`.
{{- end -}}
{{- end -}}

{{/*
Validate values of Cilium - Cloud Provider
*/}}
{{- define "cilium.validateValues.provider" -}}
{{- if and .Values.azure.enabled .Values.aws.enabled .Values.gcp.enabled -}}
azure.enabled, aws.enabled and gcp.enabled
    All cloud providers are enabled. Please enable only one cloud provider.
{{- else if and .Values.azure.enabled .Values.aws.enabled -}}
azure.enabled and aws.enabled
    Both AWS and Azure are enabled. Please enable only one cloud provider.
{{- else if and .Values.azure.enabled .Values.gcp.enabled -}}
azure.enabled amd gcp.enabled
    Both gcp and Azure are enabled. Please enable only one cloud provider.
{{- else if and .Values.aws.enabled .Values.gcp.enabled -}}
aws.enabled and gcp.enabled
    Both gcp and AWS are enabled. Please enable only one cloud provider.
{{- end -}}
{{- end -}}
