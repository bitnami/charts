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
Validate values for Grafana.
*/}}
{{- define "grafana.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "grafana.validateValues.database" .) -}}
{{- $messages := append $messages (include "grafana.validateValues.configmapsOrSecrets" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the external database
*/}}
{{- define "grafana.validateValues.database" -}}
{{- $replicaCount := int .Values.replicaCount }}
{{- if gt $replicaCount 1 -}}
WARNING: Using more than one replica requires using an external database to share data between Grafana instances.
         By default Grafana uses an internal sqlite3 per instance but you can configure an external MySQL or PostgreSQL.
         Please, ensure you provide a configuration file configuring the external database to share data between replicas.
{{- end -}}
{{- end -}}

{{/*
Function to validate grafana confirmaps and secrets
*/}}
{{- define "grafana.validateValues.configmapsOrSecrets" -}}
{{- if and .Values.config.useGrafanaIniFile (not .Values.config.grafanaIniSecret) (not .Values.config.grafanaIniConfigMap) -}}
WARNING: You enabled config.useGrafanaIniFile but did not specify config.grafanaIniSecret nor config.grafanaIniConfigMap
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "common.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
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
Return the appropriate apiVersion for deployment.
*/}}
{{- define "grafana.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}
