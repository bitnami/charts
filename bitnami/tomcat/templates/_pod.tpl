{{/*
Pod Spec
*/}}
{{- define "tomcat.pod" -}}
{{- include "tomcat.imagePullSecrets" . }}
{{- if .Values.hostAliases }}
hostAliases: {{- include "common.tplvalues.render" (dict "value" .Values.hostAliases "context" $) | nindent 2 }}
{{- end }}
{{- if .Values.affinity }}
affinity: {{- include "common.tplvalues.render" (dict "value" .Values.affinity "context" $) | nindent 2 }}
{{- else }}
affinity:
  podAffinity: {{- include "common.affinities.pods" (dict "type" .Values.podAffinityPreset "context" $) | nindent 4 }}
  podAntiAffinity: {{- include "common.affinities.pods" (dict "type" .Values.podAntiAffinityPreset "context" $) | nindent 4 }}
  nodeAffinity: {{- include "common.affinities.nodes" (dict "type" .Values.nodeAffinityPreset.type "key" .Values.nodeAffinityPreset.key "values" .Values.nodeAffinityPreset.values) | nindent 4 }}
{{- end }}
{{- if .Values.nodeSelector }}
nodeSelector: {{- include "common.tplvalues.render" ( dict "value" .Values.nodeSelector "context" $) | nindent 2 }}
{{- end }}
{{- if .Values.tolerations }}
tolerations: {{- include "common.tplvalues.render" (dict "value" .Values.tolerations "context" .) | nindent 2 }}
{{- end }}
{{- if .Values.podSecurityContext.enabled }}
securityContext: {{- omit .Values.podSecurityContext "enabled" | toYaml | nindent 2 }}
{{- end }}
initContainers:
{{- if and .Values.volumePermissions.enabled .Values.persistence.enabled }}
- name: volume-permissions
  image: {{ template "tomcat.volumePermissions.image" . }}
  imagePullPolicy: {{ .Values.volumePermissions.image.pullPolicy | quote }}
  command:
  - /bin/bash
  - -ec
  - |
      chown -R {{ .Values.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }} /bitnami/tomcat
  securityContext:
  runAsUser: 0
  {{- if .Values.volumePermissions.resources }}
  resources: {{- toYaml .Values.volumePermissions.resources | nindent 4 }}
  {{- end }}
  volumeMounts:
  - name: data
    mountPath: /bitnami/tomcat
{{- end }}
{{- if .Values.initContainers }}
{{- include "common.tplvalues.render" (dict "value" .Values.initContainers "context" $) }}
{{- end }}
containers:
- name: tomcat
  image: {{ template "tomcat.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy | quote }}
  {{- if .Values.containerSecurityContext.enabled }}
  securityContext: {{- omit .Values.containerSecurityContext "enabled" | toYaml | nindent 4 }}
  {{- end }}
  {{- if .Values.command }}
  command: {{- include "common.tplvalues.render" (dict "value" .Values.command "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.args }}
  args: {{- include "common.tplvalues.render" (dict "value" .Values.args "context" $) | nindent 4 }}
  {{- end }}
  env:
  - name: BITNAMI_DEBUG
    value: {{ ternary "true" "false" .Values.image.debug | quote }}
  - name: TOMCAT_USERNAME
    value: {{ .Values.tomcatUsername | quote }}
  - name: TOMCAT_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ template "common.names.fullname" . }}
        key: tomcat-password
  - name: TOMCAT_ALLOW_REMOTE_MANAGEMENT
    value: {{ .Values.tomcatAllowRemoteManagement | quote }}
  {{- if .Values.extraEnvVars }}
  {{- include "common.tplvalues.render" (dict "value" .Values.extraEnvVars "context" $) | nindent 2 }}
  {{- end }}
  {{- if or .Values.extraEnvVarsCM .Values.extraEnvVarsSecret }}
  envFrom:
  {{- if .Values.extraEnvVarsCM }}
  - configMapRef:
      name: {{ include "common.tplvalues.render" (dict "value" .Values.extraEnvVarsCM "context" $) }}
  {{- end }}
  {{- if .Values.extraEnvVarsSecret }}
  - secretRef:
      name: {{ include "common.tplvalues.render" (dict "value" .Values.extraEnvVarsSecret "context" $) }}
  {{- end }}
  {{- end }}
  ports:
  - name: http
    containerPort: {{ .Values.containerPort }}
  {{- if .Values.containerExtraPorts }}
  {{- include "common.tplvalues.render" (dict "value" .Values.containerExtraPorts "context" $) | nindent 2 }}
  {{- end }}
  {{- if .Values.livenessProbe.enabled }}
  livenessProbe: {{- include "common.tplvalues.render" (dict "value" (omit .Values.livenessProbe "enabled") "context" $) | nindent 4 }}
  {{- else if .Values.customLivenessProbe }}
  livenessProbe: {{- include "common.tplvalues.render" (dict "value" .Values.customLivenessProbe "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.readinessProbe.enabled }}
  readinessProbe: {{- include "common.tplvalues.render" (dict "value" (omit .Values.readinessProbe "enabled") "context" $) | nindent 4 }}
  {{- else if .Values.customReadinessProbe }}
  readinessProbe: {{- include "common.tplvalues.render" (dict "value" .Values.customReadinessProbe "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.resources }}
  resources: {{- toYaml .Values.resources | nindent 4 }}
  {{- end }}
  volumeMounts:
  - name: data
    mountPath: /bitnami/tomcat
  {{- if .Values.extraVolumeMounts }}
  {{- include "common.tplvalues.render" (dict "value" .Values.extraVolumeMounts "context" $) | nindent 2 }}
  {{- end }}
{{- if .Values.sidecars }}
{{- include "common.tplvalues.render" ( dict "value" .Values.sidecars "context" $) }}
{{- end }}
volumes:
{{- if and .Values.persistence.enabled (eq .Values.deployment.type "deployment") }}
- name: data
  persistentVolumeClaim:
    claimName: {{ template "tomcat.pvc" . }}
{{- else if and .Values.persistence.enabled (eq .Values.deployment.type "statefulset") }}
# nothing
{{- else }}
- name: data
  emptyDir: {}
{{- end }}
{{- if .Values.extraVolumes }}
{{ include "common.tplvalues.render" (dict "value" .Values.extraVolumes "context" $) }}
{{- end }}
{{- end -}}
