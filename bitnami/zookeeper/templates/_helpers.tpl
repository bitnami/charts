{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper ZooKeeper image name
*/}}
{{- define "zookeeper.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "zookeeper.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "zookeeper.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "zookeeper.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}

{{/*
Return ZooKeeper Namespace to use
*/}}
{{- define "zookeeper.namespace" -}}
{{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
{{- else -}}
    {{- .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "zookeeper.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the ZooKeeper authentication credentials secret
*/}}
{{- define "zookeeper.secretName" -}}
{{- if .Values.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.auth.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-auth" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a ZooKeeper authentication credentials secret object should be created
*/}}
{{- define "zookeeper.createSecret" -}}
{{- if and .Values.auth.enabled (empty .Values.auth.existingSecret) -}}
    {{- true -}}
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
Return ZooKeeper client password
*/}}
{{- define "zookeeper.client.password" -}}
{{- if not (empty .Values.auth.clientPassword) -}}
    {{- .Values.auth.clientPassword -}}
{{- else -}}
    {{- include "getValueFromSecret" (dict "Namespace" (include "zookeeper.namespace" .) "Name" (printf "%s-auth" (include "common.names.fullname" .)) "Length" 10 "Key" "client-password")  -}}
{{- end -}}
{{- end -}}

{{/*
Return ZooKeeper server password
*/}}
{{- define "zookeeper.server.password" -}}
{{- if not (empty .Values.auth.serverPasswords) -}}
    {{- .Values.auth.serverPasswords -}}
{{- else -}}
    {{- include "getValueFromSecret" (dict "Namespace" (include "zookeeper.namespace" .) "Name" (printf "%s-auth" (include "common.names.fullname" .)) "Length" 10 "Key" "server-password")  -}}
{{- end -}}
{{- end -}}

{{/*
Return the ZooKeeper configuration ConfigMap name
*/}}
{{- define "zookeeper.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a ConfigMap object should be created for ZooKeeper configuration
*/}}
{{- define "zookeeper.createConfigmap" -}}
{{- if and .Values.configuration (not .Values.existingConfigmap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret should be created for ZooKeeper quorum
*/}}
{{- define "zookeeper.quorum.createTlsSecret" -}}
{{- if and .Values.tls.quorum.enabled (not .Values.tls.quorum.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing ZooKeeper quorum TLS certificates
*/}}
{{- define "zookeeper.quorum.tlsSecretName" -}}
{{- $secretName := .Values.tls.quorum.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-quorum-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret containing the Keystore and Truststore password should be created for ZooKeeper quorum
*/}}
{{- define "zookeeper.quorum.createTlsPasswordsSecret" -}}
{{- if and .Values.tls.quorum.enabled (not .Values.tls.quorum.passwordsSecretName) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the Keystore and Truststore password
*/}}
{{- define "zookeeper.quorum.tlsPasswordsSecret" -}}
{{- $secretName := .Values.tls.quorum.passwordsSecretName -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-quorum-tls-pass" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret should be created for ZooKeeper client 
*/}}
{{- define "zookeeper.client.createTlsSecret" -}}
{{- if and .Values.tls.client.enabled (not .Values.tls.client.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing ZooKeeper client TLS certificates
*/}}
{{- define "zookeeper.client.tlsSecretName" -}}
{{- $secretName := .Values.tls.client.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-client-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret containing the Keystore and Truststore password should be created for ZooKeeper client
*/}}
{{- define "zookeeper.client.createTlsPasswordsSecret" -}}
{{- if and .Values.tls.client.enabled (not .Values.tls.client.passwordsSecretName) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the Keystore and Truststore password
*/}}
{{- define "zookeeper.client.tlsPasswordsSecret" -}}
{{- $secretName := .Values.tls.client.passwordsSecretName -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-client-tls-pass" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "zookeeper.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "zookeeper.validateValues.auth" .) -}}
{{- $messages := append $messages (include "zookeeper.validateValues.client.tls" .) -}}
{{- $messages := append $messages (include "zookeeper.validateValues.quorum.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of ZooKeeper - Authentication enabled
*/}}
{{- define "zookeeper.validateValues.auth" -}}
{{- if and .Values.auth.enabled (or (not .Values.auth.clientUser) (not .Values.auth.serverUsers)) }}
zookeeper: auth.enabled
    In order to enable authentication, you need to provide the list
    of users to be created and the user to use for clients access.
{{- end -}}
{{- end -}}

{{/*
Validate values of ZooKeeper - Client TLS enabled
*/}}
{{- define "zookeeper.validateValues.client.tls" -}}
{{- if and .Values.tls.client.enabled (not .Values.tls.client.autoGenerated) (not .Values.tls.client.existingSecret) }}
zookeeper: tls.client.enabled
    In order to enable Client TLS encryption, you also need to provide
    an existing secret containing the Keystore and Truststore or
    enable auto-generated certificates.
{{- end -}}
{{- end -}}

{{/*
Validate values of ZooKeeper - Quorum TLS enabled
*/}}
{{- define "zookeeper.validateValues.quorum.tls" -}}
{{- if and .Values.tls.quorum.enabled (not .Values.tls.quorum.autoGenerated) (not .Values.tls.quorum.existingSecret) }}
zookeeper: tls.quorum.enabled
    In order to enable Quorum TLS, you also need to provide
    an existing secret containing the Keystore and Truststore or
    enable auto-generated certificates.
{{- end -}}
{{- end -}}
