{{/*
Return the proper SonarQube image name
*/}}
{{- define "sonarqube.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "sonarqube.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper sysctl image name
*/}}
{{- define "sonarqube.sysctl.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.sysctl.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper sysctl image name
*/}}
{{- define "sonarqube.metrics.jmx.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.jmx.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Container Image Registry Secret Names
*/}}
{{- define "sonarqube.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image .Values.sysctl.image .Values.metrics.jmx.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "sonarqube.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s-foo" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for PostgreSQL
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "sonarqube.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the Database Hostname
*/}}
{{- define "sonarqube.database.host" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" (include "sonarqube.postgresql.fullname" .) -}}
{{- else -}}
    {{- .Values.externalDatabase.host  -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Port
*/}}
{{- define "sonarqube.database.port" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "5432" -}}
{{- else -}}
    {{- .Values.externalDatabase.port -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Name
*/}}
{{- define "sonarqube.database.name" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.postgresqlDatabase -}}
{{- else -}}
    {{- .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database User
*/}}
{{- define "sonarqube.database.username" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.postgresqlUsername -}}
{{- else -}}
    {{- .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Secret Name
*/}}
{{- define "sonarqube.database.secretName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.postgresql.existingSecret -}}
        {{- printf "%s" .Values.postgresql.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "sonarqube.postgresql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a SonarQube authentication credentials secret object should be created
*/}}
{{- define "sonarqube.createSecret" -}}
{{- if or (not .Values.existingSecret) (and (not .Values.smtpExistingSecret) .Values.smtpPassword) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the SonarQube Secret Name
*/}}
{{- define "sonarqube.secretName" -}}
{{- if .Values.existingSecret }}
    {{- printf "%s" (tpl .Values.existingSecret .) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the SMTP Secret Name
*/}}
{{- define "sonarqube.smtpSecretName" -}}
{{- if .Values.smtpExistingSecret }}
    {{- printf "%s" (tpl .Values.smtpExistingSecret .) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Sysctl set a property if less than a given value
*/}}
{{- define "sonarqube.sysctl.ifLess" -}}
CURRENT="$(sysctl -n {{ .key }})"
DESIRED="{{ .value }}"
if [[ "$DESIRED" -gt "$CURRENT" ]]; then
    sysctl -w {{ .key }}={{ .value }}
fi
{{- end -}}

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
*/}}
{{- define "sonarqube.ingress.certManagerRequest" -}}
{{ if or (hasKey . "cert-manager.io/cluster-issuer") (hasKey . "cert-manager.io/issuer") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "sonarqube.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "sonarqube.validateValues.database" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of SonarQube - Database */}}
{{- define "sonarqube.validateValues.database" -}}
{{- if and (not .Values.postgresql.enabled) (or (empty .Values.externalDatabase.host) (empty .Values.externalDatabase.port) (empty .Values.externalDatabase.database)) -}}
sonarqube: database
   You disable the PostgreSQL installation but you did not provide the required parameters
   to use an external database. To use an external database, please ensure you provide
   (at least) the following values:

       externalDatabase.host=DB_SERVER_HOST
       externalDatabase.port=DB_SERVER_PORT
       externalDatabase.database=DB_NAME
{{- end -}}
{{- end -}}
