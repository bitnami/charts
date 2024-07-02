{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper neo4j image name
*/}}
{{- define "neo4j.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "neo4j.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "neo4j.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "neo4j.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the secret name
*/}}
{{- define "neo4j.secretName" -}}
{{- if .Values.auth.existingSecret -}}
  {{- printf "%s" .Values.auth.existingSecret -}}
{{- else -}}
  {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
*/}}
{{- define "neo4j.ingress.certManagerRequest" -}}
{{ if or (hasKey . "cert-manager.io/cluster-issuer") (hasKey . "cert-manager.io/issuer") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the user defined LoadBalancerIP for this release.
Note, returns 127.0.0.1 if using ClusterIP.
*/}}
{{- define "neo4j.serviceIP" -}}
{{- if eq .Values.service.type "ClusterIP" -}}
127.0.0.1
{{- else -}}
{{- .Values.service.loadBalancerIP | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
If not using ClusterIP, or if a host or LoadBalancerIP is not defined, the value will be empty.
When using Ingress, it will be set to the Ingress hostname.
*/}}
{{- define "neo4j.host" -}}
{{- if and .Values.ingress.enabled .Values.ingress.hostname }}
{{- print .Values.ingress.hostname  -}}
{{- else if .Values.advertisedHost -}}
{{- print .Values.advertisedHost  -}}
{{- else -}}
{{- print (include "neo4j.serviceIP" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Neo4j configuration configmap.
*/}}
{{- define "neo4j.configMapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- print (tpl .Values.existingConfigmap $) -}}
{{- else -}}
    {{- print (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "neo4j.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}
