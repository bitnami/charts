{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper haproxy image name
*/}}
{{- define "haproxy.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Get the configmap name
*/}}
{{- define "haproxy.configMapName" -}}
{{- if .Values.existingConfigmap -}}
  {{- printf "%s" .Values.existingConfigmap -}}
{{- else -}}
  {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "haproxy.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "haproxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "haproxy.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "haproxy.validateValues.ports" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{- define "haproxy.validateValues.ports" -}}
{{- if not .Values.containerPorts }}
haproxy: No container ports
    HAProxy should at least expose container ports. Please configure the containerPorts values using the following structure.
    containerPorts:
       - name: <NAME OF THE PORT>
         containerPort: <PORT NUMBER>
{{- end }}
{{- end }}
