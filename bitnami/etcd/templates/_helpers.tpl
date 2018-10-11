{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "etcd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "etcd.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
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
{{- if .Values.global }}
    {{- if .Values.global.regristry }}
        {{- $registryName := .Values.global.registry -}}
    {{- end -}}
{{- end -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
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
{{- $rbacOption := "-u root:$ETCD_ROOT_PASSWORD" -}}
{{- $certsOption := " --cert-file $ETCD_CERT_FILE --key-file $ETCD_KEY_FILE" -}}
{{- $caOption := " --ca-file $ETCD_TRUSTED_CA_FILE" -}}
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
