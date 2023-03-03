{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "oracle.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oracle.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "oracle.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

## 是否为自定义的集群模式
{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "oracle.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "oracle.createConfigmap" -}}
{{- if empty .Values.existingConfigmap }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "oracle.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Oracle image name
*/}}
{{- define "oracle.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "oracle.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

---
{{/*
Return the oracle sid name
*/}}
{{- define "oracle.envs.sid" -}}
{{- default "LIGHTCORE" .Values.master.containerEnvs.dbSid }}
{{- end -}}

{{/*
Return the oracle pdb name
*/}}
{{- define "oracle.envs.pdb" -}}
{{- default "LIGHTCORE1" .Values.master.containerEnvs.dbPdb }}
{{- end -}}

{{/*
Return the oracle character name
*/}}
{{- define "oracle.envs.char" -}}
{{- default "AL32UTF8" .Values.master.containerEnvs.dbChar }}
{{- end -}}

{{/*
Return the oracle domain name
*/}}
{{- define "oracle.envs.domain" -}}
{{- default "local" .Values.master.containerEnvs.dbDomain }}
{{- end -}}

{{/*
Return the oracle memory
*/}}
{{- define "oracle.envs.memory" -}}
{{- default "2Gi" .Values.master.containerEnvs.dbMemory }}
{{- end -}}

{{/*
Return the oracle sql container port name
*/}}
{{- define "oracle.ports.containerPort" -}}
{{- default "1521" .Values.master.service.ports.oracleContainerPort }}
{{- end -}}

{{/*
Return the oracle sql host port number
*/}}
{{- define "oracle.ports.targetPort" -}}
{{- default "1521" .Values.master.service.ports.oracleTargetPort }}
{{- end -}}

{{/*
Return the oracle em container port number
*/}}
{{- define "oracle.ports.emContainerPort" -}}
{{- default "5500" .Values.master.service.ports.emOracleContainerPort }}
{{- end -}}

{{/*
Return the oracle em host port number
*/}}
{{- define "oracle.ports.emTargetPort" -}}
{{- default "2Gi" .Values.master.service.ports.emOracleTargetPort }}
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
Return Oracle&trade; password
*/}}
{{- define "oracle.password" -}}
{{- if not (empty .Values.global.oracle.password) }}
    {{- .Values.global.oracle.password -}}
{{- else if not (empty .Values.auth.password) -}}
    {{- .Values.auth.password -}}
{{- else -}}
    {{- include "getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (include "common.names.fullname" .) "Length" 10 "Key" "oracle-password")  -}}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "oracle.secretName" -}}
{{- if .Values.auth.existingSecret -}}
{{- printf "%s" .Values.auth.existingSecret -}}
{{- else -}}
{{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password key to be retrieved from Oracle&trade; secret.
*/}}
{{- define "oracle.secretPasswordKey" -}}
{{- if and .Values.auth.existingSecret .Values.auth.existingSecretPasswordKey -}}
{{- printf "%s" .Values.auth.existingSecretPasswordKey -}}
{{- else -}}
{{- printf "oracle-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "oracle.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}
