{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Redis(TM) image name
*/}}
{{- define "redis-cluster.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "redis-cluster.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "redis-cluster.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return sysctl image
*/}}
{{- define "redis-cluster.sysctl.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.sysctlImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "redis-cluster.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
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
Return the appropriate apiVersion for PodSecurityPolicy.
*/}}
{{- define "podSecurityPolicy.apiVersion" -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "policy/v1beta1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert file.
*/}}
{{- define "redis-cluster.tlsCert" -}}
{{- printf "/opt/bitnami/redis/certs/%s" .Values.tls.certFilename -}}
{{- end -}}

{{/*
Return the path to the cert key file.
*/}}
{{- define "redis-cluster.tlsCertKey" -}}
{{- printf "/opt/bitnami/redis/certs/%s" .Values.tls.certKeyFilename -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "redis-cluster.tlsCACert" -}}
{{- printf "/opt/bitnami/redis/certs/%s" .Values.tls.certCAFilename -}}
{{- end -}}

{{/*
Return the path to the DH params file.
*/}}
{{- define "redis-cluster.tlsDHParams" -}}
{{- if .Values.tls.dhParamsFilename -}}
{{- printf "/opt/bitnami/redis/certs/%s" .Values.tls.dhParamsFilename -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "redis-cluster.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "redis-cluster.secretName" -}}
{{- if .Values.existingSecret -}}
{{- printf "%s" .Values.existingSecret -}}
{{- else -}}
{{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password key to be retrieved from Redis(TM) secret.
*/}}
{{- define "redis-cluster.secretPasswordKey" -}}
{{- if and .Values.existingSecret .Values.existingSecretPasswordKey -}}
{{- printf "%s" .Values.existingSecretPasswordKey -}}
{{- else -}}
{{- printf "redis-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return Redis(TM) password
*/}}
{{- define "redis-cluster.password" -}}
{{- if not (empty .Values.global.redis.password) }}
    {{- .Values.global.redis.password -}}
{{- else if not (empty .Values.password) -}}
    {{- .Values.password -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Determines whether or not to create the Statefulset
*/}}
{{- define "redis-cluster.createStatefulSet" -}}
    {{- if not .Values.cluster.externalAccess.enabled -}}
        {{- true -}}
    {{- end -}}
    {{- if and .Values.cluster.externalAccess.enabled .Values.cluster.externalAccess.service.loadBalancerIP -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "redis-cluster.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image -}}
{{- include "common.warnings.rollingTag" .Values.metrics.image -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "redis-cluster.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "redis-cluster.validateValues.updateParameters" .) -}}
{{- $messages := append $messages (include "redis-cluster.validateValues.tlsParameters" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Redis(TM) Cluster - check update parameters */}}
{{- define "redis-cluster.validateValues.updateParameters" -}}
{{- if and .Values.cluster.update.addNodes ( or (and .Values.cluster.externalAccess.enabled .Values.cluster.externalAccess.service.loadBalancerIP) ( not .Values.cluster.externalAccess.enabled )) -}}
  {{- if .Values.cluster.externalAccess.enabled }}
    {{- if not .Values.cluster.update.newExternalIPs -}}
redis-cluster: newExternalIPs
     You must provide the newExternalIPs to perform the cluster upgrade when using external access.
    {{- end -}}
  {{- else }}
    {{- if not .Values.cluster.update.currentNumberOfNodes -}}
redis-cluster: currentNumberOfNodes
    You must provide the currentNumberOfNodes to perform an upgrade when not using external access.
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Redis(TM) Cluster - tls settings */}}
{{- define "redis-cluster.validateValues.tlsParameters" -}}
{{- if .Values.tls.enabled }}
{{- if not .Values.tls.certFilename -}}
redis-cluster: TLSSecretMissingSecret
     A secret containing the certificates for the TLS traffic is required when TLS is enabled. Please set the tls.certificatesSecret value
{{- end -}}
{{- if not .Values.tls.certFilename -}}
redis-cluster: TLSSecretMissingCert
     A certificate filename is required when TLS is enabled. Please set the tls.certFilename value
{{- end -}}
{{- if not .Values.tls.certFilename -}}
redis-cluster: TLSSecretMissingCert
     A certificate filename is required when TLS is enabled. Please set the tls.certFilename value
{{- end -}}
{{- if not .Values.tls.certKeyFilename -}}
redis-cluster: TLSSecretMissingCertKey
     A certificate key filename is required when TLS is enabled. Please set the tls.certKeyFilename value
{{- end -}}
{{- if not .Values.tls.certCAFilename -}}
redis-cluster: TLSSecretMissingCertCA
     A certificate CA filename is required when TLS is enabled. Please set the tls.certCAFilename value
{{- end -}}
{{- end -}}
{{- end -}}
