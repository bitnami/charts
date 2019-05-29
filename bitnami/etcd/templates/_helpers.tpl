{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "etcd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "etcd.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "etcd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper etcd image name
*/}}
{{- define "etcd.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper etcd peer protocol
*/}}
{{- define "etcd.peerProtocol" -}}
{{- if .Values.auth.peer.secureTransport -}}
{{- print "https" -}}
{{- else -}}
{{- print "http" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper etcd client protocol
*/}}
{{- define "etcd.clientProtocol" -}}
{{- if .Values.auth.client.secureTransport -}}
{{- print "https" -}}
{{- else -}}
{{- print "http" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper etcd data dir
*/}}
{{- define "etcd.dataDir" -}}
{{- if .Values.persistence.enabled -}}
{{- print "/bitnami/etcd/data" -}}
{{- else -}}
{{- print "/opt/bitnami/etcd/data" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper etcdctl authentication options
*/}}
{{- define "etcd.authOptions" -}}
{{- $rbacOption := "--user root:$ETCD_ROOT_PASSWORD" -}}
{{- $certsOption := " --cert=\"$ETCD_CERT_FILE\" --key=\"$ETCD_KEY_FILE\"" -}}
{{- $caOption := " --cacert=\"$ETCD_TRUSTED_CA_FILE\"" -}}
{{- if .Values.auth.rbac.enabled -}}
{{- printf "%s" $rbacOption -}}
{{- end -}}
{{- if .Values.auth.client.secureTransport -}}
{{- printf "%s" $certsOption -}}
{{- end -}}
{{- if .Values.auth.client.enableAuthentication -}}
{{- printf "%s" $caOption -}}
{{- end -}}
{{- end -}}

{{/*
Return the etcd env vars ConfigMap name
*/}}
{{- define "etcd.envVarsCM" -}}
{{- printf "%s" .Values.envVarsConfigMap -}}
{{- end -}}

{{/*
Return the etcd env vars ConfigMap name
*/}}
{{- define "etcd.configFileCM" -}}
{{- printf "%s" .Values.configFileConfigMap -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "etcd.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "etcd.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "etcd.validateValues.disasterRecovery" .) -}}
{{- $messages := append $messages (include "etcd.validateValues.podAntiAffinity" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of etcd - persistence must be enabled when disasterRecovery is enabled */}}
{{- define "etcd.validateValues.disasterRecovery" -}}
{{- if and .Values.disasterRecovery.enabled (not .Values.persistence.enabled) -}}
etcd: disasterRecovery
    Persistence must be enabled when disasterRecovery is enabled!!
    Please enable persistence (--set persistence.enabled=true)
{{- end -}}
{{- end -}}

{{/* Validate values of etcd - must provide a valid podAntiAffinity ("soft" or "hard") */}}
{{- define "etcd.validateValues.podAntiAffinity" -}}
{{- if and (ne .Values.podAntiAffinity "soft") (ne .Values.podAntiAffinity "hard") -}}
etcd: mode
    Invalid podAntiAffinity selected. Valid values are "soft" and
    "hard". Please set a valid mode (--set podAntiAffinity="xxxx")
{{- end -}}
{{- end -}}
