{{/*
Return the proper hub image name
*/}}
{{- define "jupyterhub.hub.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.hub.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper hub image name
*/}}
{{- define "jupyterhub.hub.name" -}}
{{- printf "%s-hub" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper hub image name
*/}}
{{- define "jupyterhub.proxy.name" -}}
{{- printf "%s-proxy" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper singleuser image name (to be set in the hub.configuration part). We cannot use common.images.image because of the tag
{{ include "jupyterhub.hubconfiguration.imageEntry" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "jupyterhub.hubconfiguration.imageEntry" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- if .global }}
    {{- if .global.imageRegistry }}
     {{- $registryName = .global.imageRegistry -}}
    {{- end -}}
{{- end -}}
{{- if $registryName }}
{{- printf "%s/%s" $registryName $repositoryName -}}
{{- else -}}
{{- printf "%s" $repositoryName -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper hub image name
*/}}
{{- define "jupyterhub.proxy.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.proxy.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper hub image name
*/}}
{{- define "jupyterhub.auxiliary.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.auxiliaryImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "jupyterhub.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.hub.image .Values.proxy.image .Values.auxiliaryImage) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jupyterhub.hubServiceAccountName" -}}
{{- if .Values.hub.serviceAccount.create -}}
    {{ default (printf "%s-hub" (include "common.names.fullname" .)) .Values.hub.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.hub.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jupyterhub.singleuserServiceAccountName" -}}
{{- if .Values.singleuser.serviceAccount.create -}}
    {{ default (printf "%s-singleuser" (include "common.names.fullname" .)) .Values.singleuser.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.singleuser.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "jupyterhub.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "jupyterhub.databaseSecretName" -}}
{{- if and (.Values.postgresql.enabled) (not .Values.postgresql.existingSecret) -}}
    {{- printf "%s" (include "jupyterhub.postgresql.fullname" .) -}}
{{- else if and (.Values.postgresql.enabled) (.Values.postgresql.existingSecret) -}}
    {{- printf "%s" .Values.postgresql.existingSecret -}}
{{- else }}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- printf "%s" .Values.externalDatabase.existingSecret -}}
    {{- else -}}
        {{ printf "%s-%s" .Release.Name "externaldb" }}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "jupyterhub.hubSecretName" -}}
{{- if .Values.hub.existingSecret -}}
    {{- .Values.hub.existingSecret -}}
{{- else }}
    {{- printf "%s-hub" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "jupyterhub.hubConfigmapName" -}}
{{- if .Values.hub.existingConfigmap -}}
    {{- .Values.hub.existingConfigmap -}}
{{- else }}
    {{- printf "%s-hub" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/* Validate values of JupyterHub - Database */}}
{{- define "jupyterhub.validateValues.database" -}}
{{- if and .Values.postgresql.enabled .Values.externalDatabase.host -}}
jupyherhub: Database
    You can only use one database.
    Please choose installing a PostgreSQL chart (--set postgresql.enabled=true) or
    using an external database (--set externalDatabase.host)
{{- end -}}
{{- if and (not .Values.postgresql.enabled) (not .Values.externalDatabase.host) -}}
jupyherhub: NoDatabase
    You did not set any database.
    Please choose installing a PostgreSQL chart (--set postgresql.enabled=true) or
    using an external database (--set externalDatabase.host)
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "jupyterhub.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "jupyterhub.validateValues.database" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}
