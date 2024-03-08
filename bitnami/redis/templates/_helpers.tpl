{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Redis image name
*/}}
{{- define "redis.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Redis Sentinel image name
*/}}
{{- define "redis.sentinel.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.sentinel.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "redis.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "redis.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return kubectl image
*/}}
{{- define "redis.kubectl.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.kubectl.image "global" .Values.global) }}
{{- end -}}

{{/*
Return sysctl image
*/}}
{{- define "redis.sysctl.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.sysctl.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "redis.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.sentinel.image .Values.metrics.image .Values.volumePermissions.image .Values.sysctl.image) "context" $) -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiGroup for PodSecurityPolicy.
*/}}
{{- define "podSecurityPolicy.apiGroup" -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "policy" -}}
{{- else -}}
{{- print "extensions" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret object should be created
*/}}
{{- define "redis.createTlsSecret" -}}
{{- if and .Values.tls.enabled .Values.tls.autoGenerated (and (not .Values.tls.existingSecret) (not .Values.tls.certificatesSecret)) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing Redis TLS certificates
*/}}
{{- define "redis.tlsSecretName" -}}
{{- $secretName := coalesce .Values.tls.existingSecret .Values.tls.certificatesSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert file.
*/}}
{{- define "redis.tlsCert" -}}
{{- if (include "redis.createTlsSecret" . ) -}}
    {{- printf "/opt/bitnami/redis/certs/%s" "tls.crt" -}}
{{- else -}}
    {{- required "Certificate filename is required when TLS in enabled" .Values.tls.certFilename | printf "/opt/bitnami/redis/certs/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert key file.
*/}}
{{- define "redis.tlsCertKey" -}}
{{- if (include "redis.createTlsSecret" . ) -}}
    {{- printf "/opt/bitnami/redis/certs/%s" "tls.key" -}}
{{- else -}}
    {{- required "Certificate Key filename is required when TLS in enabled" .Values.tls.certKeyFilename | printf "/opt/bitnami/redis/certs/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "redis.tlsCACert" -}}
{{- if (include "redis.createTlsSecret" . ) -}}
    {{- printf "/opt/bitnami/redis/certs/%s" "ca.crt" -}}
{{- else -}}
    {{- required "Certificate CA filename is required when TLS in enabled" .Values.tls.certCAFilename | printf "/opt/bitnami/redis/certs/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the DH params file.
*/}}
{{- define "redis.tlsDHParams" -}}
{{- if .Values.tls.dhParamsFilename -}}
{{- printf "/opt/bitnami/redis/certs/%s" .Values.tls.dhParamsFilename -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the shared service account to use
*/}}
{{- define "redis.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the master service account to use
*/}}
{{- define "redis.masterServiceAccountName" -}}
{{- if .Values.master.serviceAccount.create -}}
    {{ default (printf "%s-master" (include "common.names.fullname" .)) .Values.master.serviceAccount.name }}
{{- else -}}
    {{- if .Values.serviceAccount.create -}}
        {{ template "redis.serviceAccountName" . }}
    {{- else -}}
        {{ default "default" .Values.master.serviceAccount.name }}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the replicas service account to use
*/}}
{{- define "redis.replicaServiceAccountName" -}}
{{- if .Values.replica.serviceAccount.create -}}
    {{ default (printf "%s-replica" (include "common.names.fullname" .)) .Values.replica.serviceAccount.name }}
{{- else -}}
    {{- if .Values.serviceAccount.create -}}
        {{ template "redis.serviceAccountName" . }}
    {{- else -}}
        {{ default "default" .Values.replica.serviceAccount.name }}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the configuration configmap name
*/}}
{{- define "redis.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-configuration" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "redis.createConfigmap" -}}
{{- if empty .Values.existingConfigmap }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "redis.secretName" -}}
{{- if .Values.auth.existingSecret -}}
{{- printf "%s" (tpl .Values.auth.existingSecret $) -}}
{{- else -}}
{{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password key to be retrieved from Redis&reg; secret.
*/}}
{{- define "redis.secretPasswordKey" -}}
{{- if and .Values.auth.existingSecret .Values.auth.existingSecretPasswordKey -}}
{{- printf "%s" (tpl .Values.auth.existingSecretPasswordKey $) -}}
{{- else -}}
{{- printf "redis-password" -}}
{{- end -}}
{{- end -}}


{{/*
Returns the available value for certain key in an existing secret (if it exists),
otherwise it generates a random value.
*/}}
{{- define "getValueFromSecret" }}
    {{- $len := (default 16 .Length) | int -}}
    {{- $obj := (lookup "v1" "Secret" .Namespace .Name).data -}}
    {{- if $obj }}
        {{- index $obj .Key | b64dec -}}
    {{- else -}}
        {{- randAlphaNum $len -}}
    {{- end -}}
{{- end }}

{{/*
Return Redis&reg; password
*/}}
{{- define "redis.password" -}}
{{- if or .Values.auth.enabled .Values.global.redis.password }}
    {{- if not (empty .Values.global.redis.password) }}
        {{- .Values.global.redis.password -}}
    {{- else if not (empty .Values.auth.password) -}}
        {{- .Values.auth.password -}}
    {{- else -}}
        {{- include "getValueFromSecret" (dict "Namespace" (include "common.names.namespace" .) "Name" (include "redis.secretName" .) "Length" 10 "Key" (include "redis.secretPasswordKey" .))  -}}
    {{- end -}}
{{- end -}}
{{- end }}

{{/* Check if there are rolling tags in the images */}}
{{- define "redis.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.sentinel.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "redis.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "redis.validateValues.topologySpreadConstraints" .) -}}
{{- $messages := append $messages (include "redis.validateValues.architecture" .) -}}
{{- $messages := append $messages (include "redis.validateValues.podSecurityPolicy.create" .) -}}
{{- $messages := append $messages (include "redis.validateValues.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Redis&reg; - spreadConstrainsts K8s version */}}
{{- define "redis.validateValues.topologySpreadConstraints" -}}
{{- if and (semverCompare "<1.16-0" .Capabilities.KubeVersion.GitVersion) .Values.replica.topologySpreadConstraints -}}
redis: topologySpreadConstraints
    Pod Topology Spread Constraints are only available on K8s  >= 1.16
    Find more information at https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
{{- end -}}
{{- end -}}

{{/* Validate values of Redis&reg; - must provide a valid architecture */}}
{{- define "redis.validateValues.architecture" -}}
{{- if and (ne .Values.architecture "standalone") (ne .Values.architecture "replication") -}}
redis: architecture
    Invalid architecture selected. Valid values are "standalone" and
    "replication". Please set a valid architecture (--set architecture="xxxx")
{{- end -}}
{{- if and .Values.sentinel.enabled (not (eq .Values.architecture "replication")) }}
redis: architecture
    Using redis sentinel on standalone mode is not supported.
    To deploy redis sentinel, please select the "replication" mode
    (--set "architecture=replication,sentinel.enabled=true")
{{- end -}}
{{- end -}}

{{/* Validate values of Redis&reg; - PodSecurityPolicy create */}}
{{- define "redis.validateValues.podSecurityPolicy.create" -}}
{{- if and .Values.podSecurityPolicy.create (not .Values.podSecurityPolicy.enabled) }}
redis: podSecurityPolicy.create
    In order to create PodSecurityPolicy, you also need to enable
    podSecurityPolicy.enabled field
{{- end -}}
{{- end -}}

{{/* Validate values of Redis&reg; - TLS enabled */}}
{{- define "redis.validateValues.tls" -}}
{{- if and .Values.tls.enabled (not .Values.tls.autoGenerated) (not .Values.tls.existingSecret) (not .Values.tls.certificatesSecret) }}
redis: tls.enabled
    In order to enable TLS, you also need to provide
    an existing secret containing the TLS certificates or
    enable auto-generated certificates.
{{- end -}}

{{/* Validate values of Redis&reg; - master service enabled */}}
{{- define "redis.validateValues.createMaster" -}}
{{- if and .Values.sentinel.service.createMaster (or (not .Values.rbac.create) (not .Values.replica.automountServiceAccountToken)) }}
redis: sentinel.service.createMaster
    In order to redirect requests only to the master pod via the service, you also need to
    create rbac and enable replica.automountServiceAccountToken.
{{- end -}}
{{- end -}}

{{/* Define the suffix utilized for external-dns */}}
{{- define "redis.externalDNS.suffix" -}}
{{ printf "%s.%s" (include "common.names.fullname" .) .Values.useExternalDNS.suffix }}
{{- end -}}

{{/* Compile all annotations utilized for external-dns */}}
{{- define "redis.externalDNS.annotations" -}}
{{- if and .Values.useExternalDNS.enabled .Values.useExternalDNS.annotationKey }}
{{ .Values.useExternalDNS.annotationKey }}hostname: {{ include "redis.externalDNS.suffix" . }}
{{- range $key, $val := .Values.useExternalDNS.additionalAnnotations }}
{{ $.Values.useExternalDNS.annotationKey }}{{ $key }}: {{ $val | quote }}
{{- end }}
{{- end }}
{{- end }}
