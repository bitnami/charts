{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kafka.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafka.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Create a default fully qualified zookeeper name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafka.zookeeper.fullname" -}}
{{- if .Values.zookeeper.fullnameOverride -}}
{{- .Values.zookeeper.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "zookeeper" .Values.zookeeper.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "kafka.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "kafka.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Kafka image name
*/}}
{{- define "kafka.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Kafka provisioning image name
*/}}
{{- define "kafka.provisioning.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.provisioning.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container auto-discovery image)
*/}}
{{- define "kafka.externalAccess.autoDiscovery.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.externalAccess.autoDiscovery.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "kafka.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Kafka exporter image name
*/}}
{{- define "kafka.metrics.kafka.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.kafka.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper JMX exporter image name
*/}}
{{- define "kafka.metrics.jmx.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.jmx.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kafka.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.externalAccess.autoDiscovery.image .Values.volumePermissions.image .Values.metrics.kafka.image .Values.metrics.jmx.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Storage Class
*/}}
{{- define "kafka.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.storageClass -}}
              {{- if (eq "-" .Values.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.storageClass -}}
        {{- if (eq "-" .Values.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if authentication via SASL should be configured for client communications
*/}}
{{- define "kafka.client.saslAuthentication" -}}
{{- $saslProtocols := list "sasl" "sasl_tls" -}}
{{- if has .Values.auth.clientProtocol $saslProtocols -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if authentication via SASL should be configured for inter-broker communications
*/}}
{{- define "kafka.interBroker.saslAuthentication" -}}
{{- $saslProtocols := list "sasl" "sasl_tls" -}}
{{- if has .Values.auth.interBrokerProtocol $saslProtocols -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if encryption via TLS for client connections should be configured
*/}}
{{- define "kafka.client.tlsEncryption" -}}
{{- $tlsProtocols := list "tls" "mtls" "sasl_tls" -}}
{{- if (has .Values.auth.clientProtocol $tlsProtocols) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if encryption via TLS for inter broker communication connections should be configured
*/}}
{{- define "kafka.interBroker.tlsEncryption" -}}
{{- $tlsProtocols := list "tls" "mtls" "sasl_tls" -}}
{{- if (has .Values.auth.interBrokerProtocol $tlsProtocols) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if encryption via TLS should be configured
*/}}
{{- define "kafka.tlsEncryption" -}}
{{- if or (include "kafka.client.tlsEncryption" .) (include "kafka.interBroker.tlsEncryption" .) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the type of listener
Usage:
{{ include "kafka.listenerType" ( dict "protocol" .Values.path.to.the.Value ) }}
*/}}
{{- define "kafka.listenerType" -}}
{{- if eq .protocol "plaintext" -}}
PLAINTEXT
{{- else if or (eq .protocol "tls") (eq .protocol "mtls") -}}
SSL
{{- else if eq .protocol "sasl_tls" -}}
SASL_SSL
{{- else if eq .protocol "sasl" -}}
SASL_PLAINTEXT
{{- end -}}
{{- end -}}

{{/*
Return the Kafka JAAS credentials secret
*/}}
{{- define "kafka.jaasSecretName" -}}
{{- $secretName := coalesce .Values.auth.sasl.jaas.existingSecret .Values.auth.jaas.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-jaas" (include "kafka.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a JAAS credentials secret object should be created
*/}}
{{- define "kafka.createJaasSecret" -}}
{{- $secretName := coalesce .Values.auth.sasl.jaas.existingSecret .Values.auth.jaas.existingSecret -}}
{{- if and (or (include "kafka.client.saslAuthentication" .) (include "kafka.interBroker.saslAuthentication" .) (and .Values.zookeeper.auth.enabled .Values.auth.jaas.zookeeperUser)) (empty $secretName) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Kafka TLS credentials secret
*/}}
{{- define "kafka.tlsSecretName" -}}
{{- $secretName := coalesce .Values.auth.tls.existingSecret .Values.auth.jksSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-tls" (include "kafka.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "kafka.createTlsSecret" -}}
{{- $secretName := coalesce .Values.auth.tls.existingSecret .Values.auth.jksSecret -}}
{{- if and (include "kafka.tlsEncryption" .) (empty $secretName) (eq .Values.auth.tls.type "jks") (.Files.Glob "files/tls/*.jks") }}
    {{- true -}}
{{- else if and (include "kafka.tlsEncryption" .) (empty $secretName) (eq .Values.auth.tls.type "pem") (or (.Files.Glob "files/tls/*.{crt,pem}") .Values.auth.tls.autoGenerated) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Kafka configuration configmap
*/}}
{{- define "kafka.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-configuration" (include "kafka.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "kafka.createConfigmap" -}}
{{- if and .Values.config (not .Values.existingConfigmap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Kafka log4j ConfigMap name.
*/}}
{{- define "kafka.log4j.configMapName" -}}
{{- if .Values.existingLog4jConfigMap -}}
    {{- printf "%s" (tpl .Values.existingLog4jConfigMap $) -}}
{{- else -}}
    {{- printf "%s-log4j-configuration" (include "kafka.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a log4j ConfigMap object should be created.
*/}}
{{- define "kafka.log4j.createConfigMap" -}}
{{- if and .Values.log4j (not .Values.existingLog4jConfigMap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Kafka configuration configmap
*/}}
{{- define "kafka.metrics.jmx.configmapName" -}}
{{- if .Values.metrics.jmx.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.metrics.jmx.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-jmx-configuration" (include "kafka.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "kafka.metrics.jmx.createConfigmap" -}}
{{- if and .Values.metrics.jmx.enabled .Values.metrics.jmx.config (not .Values.metrics.jmx.existingConfigmap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "kafka.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "kafka.validateValues.authProtocols" .) -}}
{{- $messages := append $messages (include "kafka.validateValues.nodePortListLength" .) -}}
{{- $messages := append $messages (include "kafka.validateValues.externalAccessServiceType" .) -}}
{{- $messages := append $messages (include "kafka.validateValues.externalAccessAutoDiscoveryRBAC" .) -}}
{{- $messages := append $messages (include "kafka.validateValues.saslMechanisms" .) -}}
{{- $messages := append $messages (include "kafka.validateValues.tlsSecret" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Kafka - Authentication protocols for Kafka */}}
{{- define "kafka.validateValues.authProtocols" -}}
{{- $authProtocols := list "plaintext" "tls" "mtls" "sasl" "sasl_tls" -}}
{{- if or (not (has .Values.auth.clientProtocol $authProtocols)) (not (has .Values.auth.interBrokerProtocol $authProtocols)) -}}
kafka: auth.clientProtocol auth.interBrokerProtocol
    Available authentication protocols are "plaintext", "tls", "mtls", "sasl" and "sasl_tls"
{{- end -}}
{{- end -}}

{{/* Validate values of Kafka - number of replicas must be the same than NodePort list */}}
{{- define "kafka.validateValues.nodePortListLength" -}}
{{- $replicaCount := int .Values.replicaCount }}
{{- $nodePortListLength := len .Values.externalAccess.service.nodePorts }}
{{- if and .Values.externalAccess.enabled (not .Values.externalAccess.autoDiscovery.enabled) (not (eq $replicaCount $nodePortListLength )) (eq .Values.externalAccess.service.type "NodePort") -}}
kafka: .Values.externalAccess.service.nodePorts
    Number of replicas and nodePort array length must be the same. Currently: replicaCount = {{ $replicaCount }} and nodePorts = {{ $nodePortListLength }}
{{- end -}}
{{- end -}}

{{/* Validate values of Kafka - service type for external access */}}
{{- define "kafka.validateValues.externalAccessServiceType" -}}
{{- if and (not (eq .Values.externalAccess.service.type "NodePort")) (not (eq .Values.externalAccess.service.type "LoadBalancer")) -}}
kafka: externalAccess.service.type
    Available service type for external access are NodePort or LoadBalancer.
{{- end -}}
{{- end -}}

{{/* Validate values of Kafka - RBAC should be enabled when autoDiscovery is enabled */}}
{{- define "kafka.validateValues.externalAccessAutoDiscoveryRBAC" -}}
{{- if and .Values.externalAccess.enabled .Values.externalAccess.autoDiscovery.enabled (not .Values.rbac.create )}}
kafka: rbac.create
    By specifying "externalAccess.enabled=true" and "externalAccess.autoDiscovery.enabled=true"
    an initContainer will be used to autodetect the external IPs/ports by querying the
    K8s API. Please note this initContainer requires specific RBAC resources. You can create them
    by specifying "--set rbac.create=true".
{{- end -}}
{{- end -}}

{{/* Validate values of Kafka - SASL mechanisms must be provided when using SASL */}}
{{- define "kafka.validateValues.saslMechanisms" -}}
{{- if and (or (.Values.auth.clientProtocol | regexFind "sasl") (.Values.auth.interBrokerProtocol | regexFind "sasl") (and .Values.zookeeper.auth.enabled .Values.auth.jaas.zookeeperUser)) (not .Values.auth.saslMechanisms) }}
kafka: auth.saslMechanisms
    The SASL mechanisms are required when either auth.clientProtocol or auth.interBrokerProtocol use SASL or Zookeeper user is provided.
{{- end }}
{{- if not (contains .Values.auth.saslInterBrokerMechanism .Values.auth.saslMechanisms) }}
kafka: auth.saslMechanisms
    auth.saslInterBrokerMechanism must be provided and it should be one of the specified mechanisms at auth.saslMechanisms
{{- end -}}
{{- end -}}

{{/* Validate values of Kafka - A secret containing TLS certs must be provided when TLS authentication is enabled */}}
{{- define "kafka.validateValues.tlsSecret" -}}
{{- $secretName := coalesce .Values.auth.tls.existingSecret .Values.auth.jksSecret -}}
{{- if and (include "kafka.tlsEncryption" .) (eq .Values.auth.tls.type "jks") (empty $secretName) (not (.Files.Glob "files/tls/*.jks}")) }}
kafka: auth.tls.existingSecret
    A secret containing the Kafka JKS keystores and truststore is required
    when TLS encryption in enabled and TLS format is "JKS"
{{- else if and (include "kafka.tlsEncryption" .) (eq .Values.auth.tls.type "pem") (empty $secretName) (not (.Files.Glob "files/tls/*.{crt,pem}")) (not .Values.auth.tls.autoGenerated) }}
kafka: auth.tls.existingSecret
    A secret containing the Kafka TLS certificates and keys is required
    when TLS encryption in enabled and TLS format is "PEM"
{{- end -}}
{{- end -}}
