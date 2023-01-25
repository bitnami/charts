{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Jenkins image name
*/}}
{{- define "jenkins.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "jenkins.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "jenkins.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jenkins.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
When using Ingress, it will be set to the Ingress hostname.
*/}}
{{- define "jenkins.host" -}}
{{- if .Values.ingress.enabled }}
{{- .Values.ingress.hostname | default "" -}}
{{- else -}}
{{- .Values.jenkinsHost | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
When using Ingress, it will be set to the Ingress hostname.
*/}}
{{- define "jenkins.configAsCodeCM" -}}
{{- if .Values.configAsCode.existingConfigmap -}}
{{- .Values.configAsCode.existingConfigmap -}}
{{- else -}}
{{- printf "%s-casc" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Returns kubernetes pod template configuration as code
*/}}
{{- define "jenkins.agent.podTemplate" -}}
- name: {{ printf "%s-agent" (include "common.names.fullname" .) }}
  namespace: {{ template "common.names.namespace" . }}
  id: "agent-template"
  {{- if or .Values.agent.annotations }}
  annotations:
    {{- range $key, $value := .Values.commonAnnotations }}
    - key: {{ $key }}
      value: {{ $value | quote }}
    {{- end }}
    {{- range $key, $value := .Values.agent.annotations }}
    - key: {{ $key }}
      value: {{ $value | quote }}
    {{- end }}
  {{- end }}
  containers:
    - name: jenkins
      alwaysPullImage: {{ ternary "true" "false" (eq .Values.image.pullPolicy "Always") }}
      {{- if .Values.agent.command }}
      command: {{- include "common.tplvalues.render" (dict "value" .Values.agent.command "context" $) | nindent 12 }}
      {{- end }}
      {{- if .Values.agent.args }}
      args: {{- include "common.tplvalues.render" (dict "value" .Values.agent.args "context" $) | nindent 12 }}
      {{- end }}
      envVars:
        - envVar:
            key: JENKINS_SKIP_BOOTSTRAP
            value: "true"
      image: {{ include "jenkins.image" . }}
      {{- if .Values.agent.resources.limits.cpu }}
      resourceLimitCpu: {{ .Values.agent.resources.limits.cpu }}
      {{- end}}
      {{- if .Values.agent.resources.limits.memory }}
      resourceLimitMemory: {{ .Values.agent.resources.limits.memory }}
      {{- end}}
      {{- if .Values.agent.resources.requests.cpu }}
      resourceRequestCpu: {{ .Values.agent.resources.requests.cpu }}
      {{- end}}
      {{- if .Values.agent.resources.requests.memory }}
      resourceRequestMemory: {{ .Values.agent.resources.requests.memory }}
      {{- end}}
      {{- if .Values.agent.containerSecurityContext.enabled }}
      privileged: {{ .Values.agent.containerSecurityContext.privileged }}
      runAsUser: {{ .Values.agent.containerSecurityContext.runAsUser }}
      runAsGroup: {{ .Values.agent.containerSecurityContext.runAsGroup }}
      {{- end }}
    {{- if .Values.agent.sidecars }}
    {{- include "common.tplvalues.render" ( dict "value" .Values.agent.sidecars "context" $) | nindent 4 }}
    {{- end }}
  {{- if .Values.agent.extraEnvVars }}
  envVars: {{- include "common.tplvalues.render" (dict "value" .Values.agent.extraEnvVars "context" $) | nindent 4 }}
  {{- end }}
  {{- include "jenkins.imagePullSecrets" . | nindent 2 }}
  {{- if .Values.agent.extraAgentTemplate }}
  {{- include "common.tplvalues.render" ( dict "value" .Values.agent.extraAgentTemplate "context" $) | nindent 2 }}
  {{- end }}
{{- end -}}

{{/*
Return the Jenkins TLS secret name
*/}}
{{- define "jenkins.tlsSecretName" -}}
{{- $secretName := .Values.tls.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Jenkins JKS password secret name
*/}}
{{- define "jenkins.tlsPasswordsSecret" -}}
{{- $secretName := .Values.tls.passwordsSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-tls-pass" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}


{{/*
Check if there are rolling tags in the images
*/}}
{{- define "jenkins.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- end -}}

{{- define "jenkins.validateValues.tls" -}}
{{- if and .Values.tls.enabled (not .Values.tls.autoGenerated) (not .Values.tls.existingSecret) }}
jenkins: tls.enabled
    In order to enable TLS, you also need to provide
    an existing secret containing the JKS keystore or
    enable auto-generated certificates.
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "jenkins.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "jenkins.validateValues.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
