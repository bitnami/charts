{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "etcd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "etcd.fullname" -}}
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
{{- define "etcd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "etcd.labels" -}}
app.kubernetes.io/name: {{ include "etcd.name" . }}
helm.sh/chart: {{ include "etcd.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "etcd.matchLabels" -}}
app.kubernetes.io/name: {{ include "etcd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
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
Return the proper Disaster Recovery PVC name
*/}}
{{- define "etcd.disasterRecovery.pvc.name" -}}
{{- if .Values.disasterRecovery.pvc.existingClaim -}}
{{- with .Values.disasterRecovery.pvc.existingClaim -}}
{{ tpl . $ }}
{{- end -}}
{{- else -}}
{{ template "etcd.fullname" . }}-snapshotter
{{- end -}}
{{- end -}}

{{/*
Return the proper etcdctl authentication options
*/}}
{{- define "etcd.authOptions" -}}
{{- $rbacOption := "--user root:$ETCD_ROOT_PASSWORD" -}}
{{- $certsOption := " --cert $ETCD_CERT_FILE --key $ETCD_KEY_FILE" -}}
{{- $autoCertsOption := " --cert /bitnami/etcd/data/fixtures/client/cert.pem --key /bitnami/etcd/data/fixtures/client/key.pem" -}}
{{- $caOption := " --cacert $ETCD_TRUSTED_CA_FILE" -}}
{{- if .Values.auth.rbac.enabled -}}
{{- printf "%s" $rbacOption -}}
{{- end -}}
{{- if and .Values.auth.client.secureTransport .Values.auth.client.useAutoTLS -}}
{{- printf "%s" $autoCertsOption -}}
{{- else if and .Values.auth.client.secureTransport (not .Values.auth.client.useAutoTLS) -}}
{{- printf "%s" $certsOption -}}
{{- if .Values.auth.client.enableAuthentication -}}
{{- printf "%s" $caOption -}}
{{- end -}}
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
{{- else if or .Values.image.pullSecrets .Values.volumePermissions.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.volumePermissions.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if or .Values.image.pullSecrets .Values.volumePermissions.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.volumePermissions.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "etcd.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "etcd.validateValues.startFromSnapshot.existingClaim" .) -}}
{{- $messages := append $messages (include "etcd.validateValues.startFromSnapshot.snapshotFilename" .) -}}
{{- $messages := append $messages (include "etcd.validateValues.disasterRecovery" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of etcd - an existing claim must be provided when startFromSnapshot is enabled */}}
{{- define "etcd.validateValues.startFromSnapshot.existingClaim" -}}
{{- if and .Values.startFromSnapshot.enabled (not .Values.startFromSnapshot.existingClaim) -}}
etcd: startFromSnapshot.existingClaim
    An existing claim must be provided when startFromSnapshot is enabled!!
    Please provide it (--set startFromSnapshot.existingClaim="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of etcd - the snapshot filename must be provided when startFromSnapshot is enabled */}}
{{- define "etcd.validateValues.startFromSnapshot.snapshotFilename" -}}
{{- if and .Values.startFromSnapshot.enabled (not .Values.startFromSnapshot.snapshotFilename) -}}
etcd: startFromSnapshot.snapshotFilename
    The snapshot filename must be provided when startFromSnapshot is enabled!!
    Please provide it (--set startFromSnapshot.snapshotFilename="xxxx")
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

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "etcd.volumePermissions.image" -}}
{{- $registryName := .Values.volumePermissions.image.registry -}}
{{- $repositoryName := .Values.volumePermissions.image.repository -}}
{{- $tag := .Values.volumePermissions.image.tag | toString -}}
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
Return the proper Storage Class
*/}}
{{- define "etcd.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.storageClass -}}
              {{- if (eq "-" .Values.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.storageClass -}}
        {{- if (eq "-" .Values.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "etcd.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "etcd.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
