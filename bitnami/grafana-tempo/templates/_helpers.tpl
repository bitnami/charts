{{/*
Return the proper Grafana Tempo image name
*/}}
{{- define "grafana-tempo.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.tempo.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Tempo image name
*/}}
{{- define "grafana-tempo.queryImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.queryFrontend.query.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Tempo image name
*/}}
{{- define "grafana-tempo.vultureImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.vulture.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "grafana-tempo.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.tempo.image .Values.vulture.image .Values.queryFrontend.query.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "grafana-tempo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s-foo" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the Tempo configuration configmap.
*/}}
{{- define "grafana-tempo.tempoConfigmapName" -}}
{{- if .Values.tempo.existingConfigmap -}}
    {{- .Values.tempo.existingConfigmap -}}
{{- else }}
    {{- printf "%s-tempo" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the Tempo overrides  configmap.
*/}}
{{- define "grafana-tempo.overridesConfigmapName" -}}
{{- if .Values.tempo.existingOverridesConfigmap -}}
    {{- .Values.tempo.existingOverridesConfigmap -}}
{{- else }}
    {{- printf "%s-overrides" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the Tempo overrides  configmap.
*/}}
{{- define "grafana-tempo.queryConfigmapName" -}}
{{- if .Values.queryFrontend.query.existingConfigmap -}}
    {{- .Values.queryFrontend.query.existingConfigmap -}}
{{- else }}
    {{- printf "%s-query" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "grafana-tempo.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "grafana-tempo.validateValues.foo" .) -}}
{{- $messages := append $messages (include "grafana-tempo.validateValues.bar" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}
