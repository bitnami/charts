{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Grafana image name
*/}}
{{- define "grafana.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Grafana Image Renderer image name
*/}}
{{- define "grafana.imageRenderer.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.imageRenderer.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "grafana.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.imageRenderer.image) "global" .Values.global) -}}
{{- end }}

{{/*
Return  the proper Storage Class
*/}}
{{- define "grafana.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence "global" .Values.global) -}}
{{- end -}}

{{/*
Return the Grafana admin credentials secret
*/}}
{{- define "grafana.adminSecretName" -}}
{{- if .Values.admin.existingSecret -}}
    {{- printf "%s" (tpl .Values.admin.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-admin" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Grafana admin password key
*/}}
{{- define "grafana.adminSecretPasswordKey" -}}
{{- if and .Values.admin.existingSecret .Values.admin.existingSecretPasswordKey -}}
    {{- printf "%s" (tpl .Values.admin.existingSecretPasswordKey $) -}}
{{- else -}}
    {{- printf "GF_SECURITY_ADMIN_PASSWORD" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "grafana.createAdminSecret" -}}
{{- if not .Values.admin.existingSecret }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the Grafana SMTP credentials secret
*/}}
{{- define "grafana.smtpSecretName" -}}
{{- if .Values.smtp.existingSecret }}
    {{- printf "%s" (tpl .Values.smtp.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-smtp" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Grafana SMTP user key
*/}}
{{- define "grafana.smtpSecretUserKey" -}}
{{- if and .Values.smtp.existingSecret .Values.smtp.existingSecretUserKey -}}
    {{- printf "%s" (tpl .Values.smtp.existingSecretUserKey $) -}}
{{- else -}}
    {{- printf "GF_SMTP_USER" -}}
{{- end -}}
{{- end -}}

{{/*
Return the Grafana SMTP password key
*/}}
{{- define "grafana.smtpSecretPasswordKey" -}}
{{- if and .Values.smtp.existingSecret .Values.smtp.existingSecretPasswordKey -}}
    {{- printf "%s" (tpl .Values.smtp.existingSecretPasswordKey $) -}}
{{- else -}}
    {{- printf "GF_SMTP_PASSWORD" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "grafana.createSMTPSecret" -}}
{{- if and .Values.smtp.enabled (not .Values.smtp.existingSecret) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either common.names.fullname if serviceAccount.create
is true or default otherwise.
*/}}
{{- define "grafana.serviceAccountName" -}}
    {{- if .Values.serviceAccount.create -}}
        {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
    {{- else -}}
        {{ default "default" .Values.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{/*
Validate values for Grafana.
*/}}
{{- define "grafana.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "grafana.validateValues.database" .) -}}
{{- $messages := append $messages (include "grafana.validateValues.configmapsOrSecrets" .) -}}
{{- $messages := append $messages (include "grafana.validateValues.ldap.configuration" .) -}}
{{- $messages := append $messages (include "grafana.validateValues.ldap.configmapsecret" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana - Requirements to use an external database */}}
{{- define "grafana.validateValues.database" -}}
{{- $replicaCount := int .Values.replicaCount }}
{{- if gt $replicaCount 1 -}}
grafana: replicaCount
        Using more than one replica requires using an external database to share data between Grafana instances.
        By default Grafana uses an internal sqlite3 per instance but you can configure an external MySQL or PostgreSQL.
        Please, ensure you provide a configuration file configuring the external database to share data between replicas.
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana - A ConfigMap or Secret name must be provided when loading a custom grafana.ini file */}}
{{- define "grafana.validateValues.configmapsOrSecrets" -}}
{{- if and .Values.config.useGrafanaIniFile (not .Values.config.grafanaIniSecret) (not .Values.config.grafanaIniConfigMap) -}}
grafana: config.useGrafanaIniFile config.grafanaIniSecret and config.grafanaIniConfigMap
        You enabled config.useGrafanaIniFile but did not specify config.grafanaIniSecret nor config.grafanaIniConfigMap
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana - A custom ldap.toml file must be provided when enabling LDAP */}}
{{- define "grafana.validateValues.ldap.configuration" -}}
{{- if and .Values.ldap.enabled (empty .Values.ldap.configuration) (empty .Values.ldap.configMapName) (empty .Values.ldap.secretName) -}}
grafana: ldap.enabled ldap.configuration ldap.configMapName and ldap.secretName
        You must provide the content of your custom ldap.toml file when enabling LDAP (--set ldap.configuration="xxx")
        As an alternative, you can set the name of an existing ConfigMap (--set ldap.configMapName="yyy") or
        an an existing Secret (--set ldap.secretName="zzz") containging the custom ldap.toml file.
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana - Only a ConfigMap or Secret name must be provided when loading a custom ldap.toml file */}}
{{- define "grafana.validateValues.ldap.configmapsecret" -}}
{{- if and .Values.ldap.enabled (not (empty .Values.ldap.configMapName)) (not (empty .Values.ldap.secretName)) -}}
grafana: ldap.enabled ldap.configMapName and ldap.secretName
        You cannot load a custom ldap.toml file both from a ConfigMap and a Secret simultaneously
{{- end -}}
{{- end -}}
