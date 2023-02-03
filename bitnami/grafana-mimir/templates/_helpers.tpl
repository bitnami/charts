{{/*
Return the proper Grafana Mimir image name
*/}}
{{- define "grafana-mimir.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.mimir.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Mimir gateway image name
*/}}
{{- define "grafana-mimir.gateway.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.gateway.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Mimir compactor fullname
*/}}
{{- define "grafana-mimir.compactor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "compactor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir distributor fullname
*/}}
{{- define "grafana-mimir.distributor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "distributor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir ingester fullname
*/}}
{{- define "grafana-mimir.ingester.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ingester" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir querier fullname
*/}}
{{- define "grafana-mimir.querier.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "querier" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir query-frontend fullname
*/}}
{{- define "grafana-mimir.query-frontend.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-frontend" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir store-gateway fullname
*/}}
{{- define "grafana-mimir.store-gateway.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "store-gateway" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir gateway fullname
*/}}
{{- define "grafana-mimir.gateway.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "gateway" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir ruler fullname
*/}}
{{- define "grafana-mimir.ruler.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ruler" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir ruler fullname
*/}}
{{- define "grafana-mimir.gossip-ring.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "gossip-ring" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir alertmanager fullname
*/}}
{{- define "grafana-mimir.alertmanager.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "alertmanager" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir overrides-exporter fullname
*/}}
{{- define "grafana-mimir.overrides-exporter.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "overrides-exporter" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir query-scheduler fullname
*/}}
{{- define "grafana-mimir.query-scheduler.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-scheduler" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Alertmanager http prefix
*/}}
{{- define "grafana-mimir.alertmanager.httpPrefix" -}}
{{- print "/alertmanager" -}}
{{- end -}}


{{/*
Prometheus http prefix
*/}}
{{- define "grafana-mimir.prometheus.httpPrefix" -}}
{{- print "/prometheus" -}}
{{- end -}}


{{/*
Get the Grafana Mimir configuration configmap.
*/}}
{{- define "grafana-mimir.mimir.configmapName" -}}
{{- if .Values.mimir.existingConfigmap -}}
    {{- .Values.mimir.existingConfigmap -}}
{{- else }}
    {{- printf "%s" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "grafana-mimir.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "grafana-mimir.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.mimir.image .Values.gateway.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "grafana-mimir.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
*/}}
{{- define "grafana-mimir.ingress.certManagerRequest" -}}
{{ if or (hasKey . "cert-manager.io/cluster-issuer") (hasKey . "cert-manager.io/issuer") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "grafana-mimir.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.mimir.image }}
{{- include "common.warnings.rollingTag" .Values.gateway.image }}
{{- end }}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "grafana-mimir.validateValues" -}}
{{- $messages := list -}}
{{/* $messages := append $messages (include "grafana-mimir.validateValues.foo" .) -}}
{{- $messages := append $messages (include "grafana-mimir.validateValues.bar" .) */}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO(TM) fullname
*/}}
{{- define "grafana-mimir.minio.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "minio" "chartValues" .Values.minio "context" $) -}}
{{- end -}}


{{/*
Return the S3 credentials secret name
*/}}
{{- define "grafana-mimir.minio.secretName" -}}
    {{- if .Values.minio.auth.existingSecret -}}
    {{- print .Values.minio.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "grafana-mimir.minio.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 access key id inside the secret
*/}}
{{- define "grafana-mimir.minio.accessKeyIDKey" -}}
    {{- print "root-user"  -}}
{{- end -}}

{{/*
Return the S3 secret access key inside the secret
*/}}
{{- define "grafana-mimir.minio.secretAccessKeyKey" -}}
    {{- print "root-password"  -}}
{{- end -}}


