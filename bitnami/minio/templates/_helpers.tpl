{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper MinIO&reg; image name
*/}}
{{- define "minio.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}

{{- end -}}

{{/*
Return the proper MinIO&reg; Client image name
*/}}
{{- define "minio.clientImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.clientImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "minio.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "minio.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.clientImage .Values.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/*
Get the user to use to access MinIO&reg;
*/}}
{{- define "minio.secret.userValue" -}}
{{- if (and (empty .Values.auth.rootUser) .Values.auth.forcePassword) }}
    {{ required "A root username is required!" .Values.auth.rootUser }}
{{- else -}}
    {{- include "common.secrets.passwords.manage" (dict "secret" (include "common.names.fullname" .) "key" "root-user" "providedValues" (list "auth.rootUser") "context" $) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password to use to access MinIO&reg;
*/}}
{{- define "minio.secret.passwordValue" -}}
{{- if (and (empty .Values.auth.rootPassword) .Values.auth.forcePassword) }}
    {{ required "A root password is required!" .Values.auth.rootPassword }}
{{- else -}}
    {{- include "common.secrets.passwords.manage" (dict "secret" (include "common.names.fullname" .) "key" "root-password" "providedValues" (list "auth.rootPassword") "context" $) -}}
{{- end -}}
{{- end -}}

{{/*
Get the credentials secret.
*/}}
{{- define "minio.secretName" -}}
{{- if .Values.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.auth.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the root user key.
*/}}
{{- define "minio.rootUserKey" -}}
{{- if and (.Values.auth.existingSecret) (.Values.auth.rootUserSecretKey) -}}
    {{- printf "%s" (tpl .Values.auth.rootUserSecretKey $) -}}
{{- else -}}
    {{- "root-user" -}}
{{- end -}}
{{- end -}}

{{/*
Get the root password key.
*/}}
{{- define "minio.rootPasswordKey" -}}
{{- if and (.Values.auth.existingSecret) (.Values.auth.rootPasswordSecretKey) -}}
    {{- printf "%s" (tpl .Values.auth.rootPasswordSecretKey $) -}}
{{- else -}}
    {{- "root-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "minio.createSecret" -}}
{{- if and (not .Values.auth.existingSecret) .Values.auth.useSecret -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a PVC object should be created (only in standalone mode)
*/}}
{{- define "minio.createPVC" -}}
{{- if and .Values.persistence.enabled (not .Values.persistence.existingClaim) (eq .Values.mode "standalone") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the PVC name (only in standalone mode)
*/}}
{{- define "minio.claimName" -}}
{{- if and .Values.persistence.existingClaim }}
    {{- printf "%s" (tpl .Values.persistence.existingClaim $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either common.names.fullname if serviceAccount.create
is true or default otherwise.
*/}}
{{- define "minio.serviceAccountName" -}}
    {{- if .Values.serviceAccount.create -}}
        {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
    {{- else -}}
        {{ default "default" .Values.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "minio.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "minio.validateValues.mode" .) -}}
{{- $messages := append $messages (include "minio.validateValues.totalDrives" .) -}}
{{- $messages := append $messages (include "minio.validateValues.tls" .) -}}
{{- $messages := append $messages (include "minio.validateValues.defaultBuckets" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of MinIO&reg; - must provide a valid mode ("distributed" or "standalone")
*/}}
{{- define "minio.validateValues.mode" -}}
{{- $allowedValues := list "distributed" "standalone" }}
{{- if not (has .Values.mode $allowedValues) -}}
minio: mode
    Invalid mode selected. Valid values are "distributed" and
    "standalone". Please set a valid mode (--set mode="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of MinIO&reg; - total number of drives should be greater than 4
*/}}
{{- define "minio.validateValues.totalDrives" -}}
{{- $replicaCount := int .Values.statefulset.replicaCount }}
{{- $drivesPerNode := int .Values.statefulset.drivesPerNode }}
{{- $zones := int .Values.statefulset.zones }}
{{- $totalDrives := mul $replicaCount $zones $drivesPerNode }}
{{- if and (eq .Values.mode "distributed") (lt $totalDrives 4) -}}
minio: total drives
    The total number of drives should be greater than 4 to guarantee erasure coding!
    Please set a combination of nodes, and drives per node that match this condition.
    For instance (--set statefulset.replicaCount=2 --set statefulset.drivesPerNode=2)
{{- end -}}
{{- end -}}

{{/*
Validate values of MinIO&reg; - TLS secret must provided if TLS is enabled
*/}}
{{- define "minio.validateValues.tls" -}}
{{- if and .Values.tls.enabled (not .Values.tls.existingSecret) (not .Values.tls.autoGenerated) }}
minio: tls.existingSecret, tls.autoGenerated
    In order to enable TLS, you also need to provide
    an existing secret containing the TLS certificates or
    enable auto-generated certificates.
{{- end -}}
{{- end -}}

{{/*
Validate values of MinIO&reg; - defaultBuckets does not work in distributed mode
*/}}
{{- define "minio.validateValues.defaultBuckets" -}}
{{- if and (eq .Values.mode "distributed") (not (empty .Values.defaultBuckets)) }}
minio: defaultBuckets
    defaultBuckets does not work in distributed mode.
    Use a provisioning job instead.
{{- end -}}
{{- end -}}

{{/*
Return the secret containing MinIO TLS certificates
*/}}
{{- define "minio.tlsSecretName" -}}
{{- if .Values.tls.existingSecret -}}
    {{- printf "%s" (tpl .Values.tls.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret object should be created
*/}}
{{- define "minio.createTlsSecret" -}}
{{- if and .Values.tls.enabled .Values.tls.autoGenerated (not .Values.tls.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Provisioning job labels (exclude matchLabels from standard labels)
*/}}
{{- define "minio.labels.provisioning" -}}
{{- $podLabels := include "common.tplvalues.merge" ( dict "values" ( list .Values.provisioning.podLabels .Values.commonLabels ) "context" . ) }}
{{- $provisioningLabels := (include "common.labels.standard" ( dict "customLabels" $podLabels "context" $ ) | fromYaml ) -}}
{{- range (include "common.labels.matchLabels" ( dict "customLabels" $podLabels "context" $ ) | fromYaml | keys ) -}}
{{- $_ := unset $provisioningLabels . -}}
{{- end -}}
{{- print ($provisioningLabels | toYaml) -}}
{{- end -}}

{{/*
Return the ingress anotation
*/}}
{{- define "minio.ingress.annotations" -}}
{{ .Values.ingress.annotations | toYaml }}
{{- end -}}

{{/*
Return the api ingress anotation
*/}}
{{- define "minio.apiIngress.annotations" -}}
{{ .Values.apiIngress.annotations | toYaml }}
{{- end -}}

{{/*
Return the ingress hostname
*/}}
{{- define "minio.ingress.hostname" -}}
{{- tpl .Values.ingress.hostname $ -}}
{{- end -}}

{{/*
Return the api ingress hostname
*/}}
{{- define "minio.apiIngress.hostname" -}}
{{- tpl .Values.apiIngress.hostname $ -}}
{{- end -}}
