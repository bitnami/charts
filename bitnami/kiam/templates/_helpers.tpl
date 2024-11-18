{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper kiam image name
*/}}
{{- define "kiam.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kiam.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use (server)
*/}}
{{- define "kiam.server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create -}}
    {{ default (printf "%s-server" (include "common.names.fullname" .)) .Values.server.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.server.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (agent)
*/}}
{{- define "kiam.agent.serviceAccountName" -}}
{{- if .Values.agent.serviceAccount.create -}}
    {{ default (printf "%s-agent" (include "common.names.fullname" .)) .Values.agent.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.agent.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Generate certificates for kiam agent and server
*/}}
{{- define "kiam.agent.gen-certs" -}}
{{- $ca := .ca | default (genCA "kiam-ca" 365) -}}
{{- $_ := set . "ca" $ca -}}
{{- $cert := genSignedCert "Kiam Agent" nil nil 365 $ca -}}
{{- $secretName := printf "%s-agent" (include "common.names.fullname" .) -}}
{{ .Values.agent.tlsCerts.certFileName }}: {{ include "common.secrets.lookup" (dict "secret" $secretName "key" .Values.agent.tlsCerts.certFileName "defaultValue" $cert.Cert "context" $) }}
{{ .Values.agent.tlsCerts.keyFileName }}: {{ include "common.secrets.lookup" (dict "secret" $secretName "key" .Values.agent.tlsCerts.keyFileName "defaultValue" $cert.Key "context" $) }}
{{ .Values.agent.tlsCerts.caFileName }}: {{ include "common.secrets.lookup" (dict "secret" $secretName "key" .Values.agent.tlsCerts.caFileName "defaultValue" $ca.Cert "context" $) }}
{{- end -}}

{{- define "kiam.server.gen-certs" -}}
{{- $altNames := list (printf "%s-server" (include "common.names.fullname" .)) (printf "%s-server:%d" (include "common.names.fullname" .) .Values.server.service.port ) (printf "127.0.0.1:%d" .Values.server.containerPort) -}}
{{- $ca := .ca | default (genCA "kiam-ca" 365) -}}
{{- $_ := set . "ca" $ca -}}
{{- $cert := genSignedCert "Kiam Server" (list "127.0.0.1") $altNames 365 $ca -}}
{{- $secretName := printf "%s-server" (include "common.names.fullname" .) -}}
{{ .Values.server.tlsCerts.certFileName }}: {{ include "common.secrets.lookup" (dict "secret" $secretName "key" .Values.server.tlsCerts.certFileName "defaultValue" $cert.Cert "context" $) }}
{{ .Values.server.tlsCerts.keyFileName }}: {{ include "common.secrets.lookup" (dict "secret" $secretName "key" .Values.server.tlsCerts.keyFileName "defaultValue" $cert.Key "context" $) }}
{{ .Values.server.tlsCerts.caFileName }}: {{ include "common.secrets.lookup" (dict "secret" $secretName "key" .Values.server.tlsCerts.caFileName "defaultValue" $ca.Cert "context" $) }}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "kiam.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "kiam.validateValues.ports" .) -}}
{{- $messages := append $messages (include "kiam.validateValues.nodeploy" .) -}}
{{- $messages := append $messages (include "kiam.validateValues.resourceType" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Kiam - ports */}}
{{- define "kiam.validateValues.ports" -}}
{{- if and .Values.server.enabled .Values.server.metrics.enabled (eq .Values.server.containerPort .Values.server.metrics.port) -}}
kiam: server-ports-conflict
    You enabled the metrics endpoint with the same port as the kiam server port, {{ .Values.server.containerPort }} == {{ .Values.server.metrics.port }}.
    Please use a different port by setting server.metrics.port and server.containerPort with different values.
{{- end -}}
{{- end -}}

{{/* Validate values of Kiam - no deployment */}}
{{- define "kiam.validateValues.nodeploy" -}}
{{- if and (not .Values.server.enabled) (not .Values.agent.enabled) -}}
kiam: nothing-deployed
    You did not deploy neither the server nor the agents. Please set at least one of the following values
        server.enabled=true
        agent.enabled=true
{{- end -}}
{{- end -}}

{{/* Validate values of Kiam - resource type */}}
{{- define "kiam.validateValues.resourceType" -}}
{{- if and (not (eq .Values.server.resourceType "daemonset")) (not (eq .Values.server.resourceType "deployment")) -}}
kiam: server-resource-type
    Server resource type {{ .Values.server.resourceType }} is not valid, only "daemonset" and "deployment" are allowed
{{- end -}}
{{- end -}}
