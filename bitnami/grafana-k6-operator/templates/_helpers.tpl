{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "grafana-k6-operator.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list  .Values.image .Values.runnerImage .Values.starterImage .Values.metrics.authProxy.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Grafana k6 Operator image name
*/}}
{{- define "grafana-k6-operator.operator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana k6 image name
*/}}
{{- define "grafana-k6-operator.runner.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.runnerImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana k6 Operator Sidecar image name
*/}}
{{- define "grafana-k6-operator.starter.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.starterImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper kube-auth-proxy image name
*/}}
{{- define "grafana-k6-operator.authProxy.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.authProxy.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "grafana-k6-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Validate values for Grafana k6 Operator
*/}}
{{- define "grafana-k6-operator.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "grafana-k6-operator.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Grafana k6 Operator - Incorrect extra volume settings
*/}}
{{- define "grafana-k6-operator.validateValues.extraVolumes" -}}
{{- if and .Values.extraVolumes (not .Values.extraVolumeMounts) -}}
grafana-k6-operator: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them. Please set
    the extraVolumeMounts value
{{- end -}}
{{- end -}}

