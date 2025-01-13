{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{- /*
    Returns given number of random Hex characters.

    - randNumeric 4 | atoi generates a random number in [0, 10^4)
      This is a range range evenly divisble by 16, but even if off by one,
      that last partial interval offsetting randomness is only 1 part in 625.
    - mod N 16 maps to the range 0-15
    - printf "%x" represents a single number 0-15 as a single hex character
*/}}
{{- define "jupyterhub.randHex" -}}
    {{- $result := "" }}
    {{- range $i := until . }}
        {{- $rand_hex_char := mod (randNumeric 4 | atoi) 16 | printf "%x" }}
        {{- $result = print $result $rand_hex_char }}
    {{- end }}
    {{- $result }}
{{- end }}

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
Return the cookie_secret value
*/}}
{{- define "jupyterhub.hub.config.JupyterHub.cookie_secret" -}}
    {{ $hubConfiguration := include "common.tplvalues.render" ( dict "value" .Values.hub.configuration "context" $ ) | fromYaml }}
    {{- if ($hubConfiguration | dig "hub" "config" "JupyterHub" "cookie_secret" "") }}
        {{- $hubConfiguration.hub.config.JupyterHub.cookie_secret }}
    {{- else if ($hubConfiguration | dig "hub" "cookieSecret" "") }}
        {{- $hubConfiguration.hub.cookieSecret }}
    {{- else }}
        {{- $secretData := (lookup "v1" "Secret" $.Release.Namespace ( include "jupyterhub.hub.name" . )).data }}
        {{- if hasKey $secretData "hub.config.JupyterHub.cookie_secret" }}
            {{- index $secretData "hub.config.JupyterHub.cookie_secret" | b64dec }}
        {{- else }}
            {{- include "jupyterhub.randHex" 64 }}
        {{- end }}
    {{- end }}
{{- end }}

{{/*
Return the CryptKeeper value
*/}}
{{- define "jupyterhub.hub.config.CryptKeeper.keys" -}}
    {{ $hubConfiguration := include "common.tplvalues.render" ( dict "value" .Values.hub.configuration "context" $ ) | fromYaml }}
    {{- if ($hubConfiguration | dig "hub" "config" "CryptKeeper" "keys" "") }}
        {{- $hubConfiguration.hub.config.CryptKeeper.keys | join ";" }}
    {{- else }}
        {{- $secretData := (lookup "v1" "Secret" $.Release.Namespace ( include "jupyterhub.hub.name" . )).data }}
        {{- if hasKey $secretData "hub.config.CryptKeeper.keys" }}
            {{- index $secretData "hub.config.CryptKeeper.keys" | b64dec }}
        {{- else }}
            {{- include "jupyterhub.randHex" 64 }}
        {{- end }}
    {{- end }}
{{- end }}

{{/*
Return the API token for a hub service
Usage:
{{ include "jupyterhub.hub.services.get_api_token" ( dict "serviceKey" "my-service" "context" $) }}
*/}}
{{- define "jupyterhub.hub.services.get_api_token" -}}
    {{- $services := .context.Values.hub.services }}
    {{- $explicitly_set_api_token := or (dig .serviceKey "api_token" "" $services) (dig .serviceKey "apiToken" "" $services) }}
    {{- if $explicitly_set_api_token }}
        {{- $explicitly_set_api_token }}
    {{- else }}
        {{- $k8s_state := lookup "v1" "Secret" .context.Release.Namespace (include "jupyterhub.hub.name" .context) | default (dict "data" (dict)) }}
        {{- $k8s_secret_key := printf "hub.services.%s.apiToken" .serviceKey }}
        {{- if hasKey $k8s_state.data $k8s_secret_key }}
            {{- index $k8s_state.data $k8s_secret_key | b64dec }}
        {{- else }}
            {{- include "jupyterhub.randHex" 64 }}
        {{- end }}
    {{- end }}
{{- end }}

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
Return the proper Docker Image Registry Secret Names
{{ include "jupyterhub.imagePullSecretsList" ( dict "images" (list .Values.path.to.the.image1, .Values.path.to.the.image2) "global" .Values.global) }}
*/}}
{{- define "jupyterhub.imagePullSecretsList" -}}
  {{- $pullSecrets := list }}

  {{- if .global }}
    {{- range .global.imagePullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}

  {{- range .images -}}
    {{- range .pullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}

  {{- if (not (empty $pullSecrets)) }}
    {{- range $pullSecrets }}
  - {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names list
*/}}
{{- define "jupyterhub.imagePullSecrets.list" -}}
{{- include "jupyterhub.imagePullSecretsList" (dict "images" (list .Values.hub.image .Values.proxy.image .Values.auxiliaryImage) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jupyterhub.imagePullerServiceAccountName" -}}
{{- if .Values.hub.serviceAccount.create -}}
    {{ default (printf "%s-image-puller" (include "common.names.fullname" .)) .Values.imagePuller.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.imagePuller.serviceAccount.name }}
{{- end -}}
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
{{- define "jupyterhub.proxyServiceAccountName" -}}
{{- if .Values.proxy.serviceAccount.create -}}
    {{ default (printf "%s-proxy" (include "common.names.fullname" .)) .Values.proxy.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.proxy.serviceAccount.name }}
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
Return  the proper Storage Class (adapted to the Jupyterhub configuration format)
{{ include "jupyterhub.storage.class" ( dict "persistence" .Values.path.to.the.persistence "global" $) }}
*/}}
{{- define "jupyterhub.storage.class" -}}
{{- $storageClass := (.global).storageClass | default .persistence.storageClass | default (.global).defaultStorageClass | default "" -}}
{{- if $storageClass -}}
  {{- if (eq "-" $storageClass) -}}
      {{- printf "storageClass: \"\"" -}}
  {{- else }}
      {{- printf "storageClass: %s" $storageClass -}}
  {{- end -}}
{{- end -}}

{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "jupyterhub.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "jupyterhub.databaseSecretName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- if .Values.global.postgresql.auth.existingSecret }}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "jupyterhub.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "jupyterhub.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "jupyterhub.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- default (printf "%s-externaldb" .Release.Name) (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "jupyterhub.databaseSecretKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "db-password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "db-password" -}}
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

{{/* Convert Kubernetes CPU to float. This is necessary for the case we're using fractions of a CPU. i.e: 750m */}}
{{- define "jupyterhub.singleuser.convertCPUToFloat" -}}
{{- if .value -}}
    {{- $res := .value -}}
    {{- if regexMatch "m" .value -}}
        {{- $res = divf (regexReplaceAll "[A-Za-z]+" $res "") 1000 -}}
    {{- end -}}
    {{- print $res -}}
{{- end -}}
{{- end -}}

{{/*
 We need to replace the Kubernetes memory/cpu terminology (e.g. 10Gi, 10Mi) with one compatible with Python (10G, 10M)
*/}}
{{- define "jupyterhub.singleuser.resources" -}}
{{ $resources := (dict "limits" (dict) "requests" (dict)) }}
{{- if .Values.singleuser.resources -}}
    {{ $resources = .Values.singleuser.resources -}}
{{- else if ne .Values.singleuser.resourcesPreset "none" -}}
    {{ $resources = include "common.resources.preset" (dict "type" .Values.singleuser.resourcesPreset) | fromYaml -}}
{{- end -}}
cpu:
  limit: {{ include "jupyterhub.singleuser.convertCPUToFloat" (dict "value" $resources.limits.cpu) }}
  guarantee: {{ include "jupyterhub.singleuser.convertCPUToFloat" (dict "value" $resources.requests.cpu) }}
memory:
  limit: {{ regexReplaceAll "([A-Za-z])i" (default "" $resources.limits.memory) "${1}" }}
  guarantee: {{ regexReplaceAll "([A-Za-z])i" (default "" $resources.requests.memory) "${1}" }}
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
