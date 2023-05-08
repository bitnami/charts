{{/*
Return the proper image name
*/}}
{{- define "prometheus.server.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.server.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name
*/}}
{{- define "prometheus.alertmanager.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.alertmanager.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name
*/}}
{{- define "prometheus.server.thanosImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.server.thanos.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "prometheus.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "prometheus.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.server.image .Values.volumePermissions.image .Values.server.thanos.image .Values.alertmanager.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "prometheus.server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.server.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.server.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
*/}}
{{- define "prometheus.server.ingress.certManagerRequest" -}}
{{ if or (hasKey . "cert-manager.io/cluster-issuer") (hasKey . "cert-manager.io/issuer") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "prometheus.server.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "prometheus.server.validateValues.thanosObjectStorageConfig" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Validate thanos objectStorageConfig.
*/}}
{{- define "prometheus.server.validateValues.thanosObjectStorageConfig" -}}
{{- if (and .Values.server.thanos.objectStorageConfig (or (not (hasKey .Values.server.thanos.objectStorageConfig "secretKey")) (not (hasKey .Values.server.thanos.objectStorageConfig "secretName")) ))}}
    {{- printf "'server.thanos.objectStorageConfig.secretKey' and 'server.thanos.objectStorageConfi.secretName' are mandatory" }}
{{- end }}
{{- end }}

{{/*
Get the Prometheus configuration configmap.
*/}}
{{- define "prometheus.server.configmapName" -}}
{{- if .Values.server.existingConfigmap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.server.existingConfigmap "context" .) -}}
{{- else }}
    {{- printf "%s" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the Prometheus configuration configmap key.
*/}}
{{- define "prometheus.server.configmapKey" -}}
{{- if .Values.server.existingConfigmapKey -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.server.existingConfigmapKey "context" .) -}}
{{- else }}
    {{- printf "prometheus.server.yaml" -}}
{{- end -}}
{{- end -}}

{{/*
Get the Prometheus Alertmanager configuration configmap key.
*/}}
{{- define "prometheus.alertmanager.configmapKey" -}}
{{- if .Values.alertmanager.existingConfigmapKey -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.alertmanager.existingConfigmapKey "context" .) -}}
{{- else }}
    {{- printf "alertmanager.yaml" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use in alertmanager
*/}}
{{- define "prometheus.alertmanager.serviceAccountName" -}}
{{- if .Values.alertmanager.serviceAccount.create -}}
    {{ default (include "prometheus.alertmanager.fullname" .) .Values.alertmanager.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.alertmanager.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return Thanos sidecar service/ingress name
*/}}
{{- define "prometheus.thanos-sidecar.fullname" -}}
    {{- printf "%s-thanos" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Return Alertmanager name
*/}}
{{- define "prometheus.alertmanager.fullname" -}}
    {{- printf "%s-alertmanager" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Get the Alertmanager configuration configmap.
*/}}
{{- define "prometheus.alertmanager.configmapName" -}}
{{- if .Values.alertmanager.existingConfigmap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.alertmanager.existingConfigmap "context" .) -}}
{{- else }}
    {{- printf "%s" (include "prometheus.alertmanager.fullname" . ) -}}
{{- end -}}
{{- end -}}