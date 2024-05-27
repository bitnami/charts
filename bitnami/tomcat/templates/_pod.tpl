{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Pod Spec
*/}}
{{- define "tomcat.pod" -}}
{{- include "tomcat.imagePullSecrets" . }}
automountServiceAccountToken: {{ .Values.automountServiceAccountToken }}
{{- if .Values.hostAliases }}
hostAliases: {{- include "common.tplvalues.render" (dict "value" .Values.hostAliases "context" $) | nindent 2 }}
{{- end }}
{{- if .Values.affinity }}
affinity: {{- include "common.tplvalues.render" (dict "value" .Values.affinity "context" $) | nindent 2 }}
{{- else }}
{{- $podLabels := include "common.tplvalues.merge" ( dict "values" ( list .Values.podLabels .Values.commonLabels ) "context" . ) }}
affinity:
  podAffinity: {{- include "common.affinities.pods" (dict "type" .Values.podAffinityPreset "customLabels" $podLabels "context" $) | nindent 4 }}
  podAntiAffinity: {{- include "common.affinities.pods" (dict "type" .Values.podAntiAffinityPreset "customLabels" $podLabels "context" $) | nindent 4 }}
  nodeAffinity: {{- include "common.affinities.nodes" (dict "type" .Values.nodeAffinityPreset.type "key" .Values.nodeAffinityPreset.key "values" .Values.nodeAffinityPreset.values) | nindent 4 }}
{{- end }}
serviceAccountName: {{ include "tomcat.serviceAccountName" . }}
{{- if .Values.schedulerName }}
schedulerName: {{ .Values.schedulerName | quote }}
{{- end }}
{{- if .Values.nodeSelector }}
nodeSelector: {{- include "common.tplvalues.render" ( dict "value" .Values.nodeSelector "context" $) | nindent 2 }}
{{- end }}
{{- if .Values.tolerations }}
tolerations: {{- include "common.tplvalues.render" (dict "value" .Values.tolerations "context" .) | nindent 2 }}
{{- end }}
{{- if .Values.podSecurityContext.enabled }}
securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.podSecurityContext "context" $) | nindent 2 }}
{{- end }}
{{- if .Values.topologySpreadConstraints }}
topologySpreadConstraints: {{- include "common.tplvalues.render" (dict "value" .Values.topologySpreadConstraints "context" $) | nindent 2 }}
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
    resources: {{- toYaml .Values.volumePermissions.resources | nindent 6 }}
    {{- else if ne .Values.volumePermissions.resourcesPreset "none" }}
    resources: {{- include "common.resources.preset" (dict "type" .Values.volumePermissions.resourcesPreset) | nindent 6 }}
    {{- end }}
    volumeMounts:
      - name: data
        mountPath: /bitnami/tomcat
{{- end }}
{{- if .Values.initContainers }}
{{ include "common.tplvalues.render" (dict "value" .Values.initContainers "context" $) }}
{{- end }}
containers:
  - name: tomcat
    image: {{ template "tomcat.image" . }}
    imagePullPolicy: {{ .Values.image.pullPolicy | quote }}
    {{- if .Values.containerSecurityContext.enabled }}
    securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.containerSecurityContext "context" $) | nindent 6 }}
    {{- end }}
    {{- if .Values.command }}
    command: {{- include "common.tplvalues.render" (dict "value" .Values.command "context" $) | nindent 6 }}
    {{- end }}
    {{- if .Values.args }}
    args: {{- include "common.tplvalues.render" (dict "value" .Values.args "context" $) | nindent 6 }}
    {{- end }}
    env:
      - name: BITNAMI_DEBUG
        value: {{ ternary "true" "false" .Values.image.debug | quote }}
      - name: TOMCAT_USERNAME
        value: {{ .Values.tomcatUsername | quote }}
      - name: TOMCAT_PASSWORD
        valueFrom:
          secretKeyRef:
            name: {{ include "tomcat.secretName" . }}
            key: tomcat-password
      - name: TOMCAT_ALLOW_REMOTE_MANAGEMENT
        value: {{ .Values.tomcatAllowRemoteManagement | quote }}
      - name: TOMCAT_HTTP_PORT_NUMBER
        value: {{ .Values.containerPorts.http | quote }}
      {{- if or .Values.catalinaOpts .Values.metrics.jmx.enabled }}
      - name: CATALINA_OPTS
        value: {{ include "tomcat.catalinaOpts" . | quote }}
      {{- end }}
      {{- if .Values.extraEnvVars }}
      {{- include "common.tplvalues.render" (dict "value" .Values.extraEnvVars "context" $) | nindent 6 }}
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
    {{- if .Values.lifecycleHooks }}
    lifecycle: {{- include "common.tplvalues.render" (dict "value" .Values.lifecycleHooks "context" $) | nindent 6 }}
    {{- end }}
    ports:
      - name: http
        containerPort: {{ .Values.containerPorts.http }}
      {{- if .Values.containerExtraPorts }}
      {{- include "common.tplvalues.render" (dict "value" .Values.containerExtraPorts "context" $) | nindent 6 }}
      {{- end }}
    {{- if .Values.customLivenessProbe }}
    livenessProbe: {{- include "common.tplvalues.render" (dict "value" .Values.customLivenessProbe "context" $) | nindent 6 }}
    {{- else if .Values.livenessProbe.enabled }}
    livenessProbe:
      tcpSocket:
        port: http
        {{- include "common.tplvalues.render" (dict "value" (omit .Values.livenessProbe "enabled") "context" $) | nindent 6 }}
    {{- end }}
    {{- if .Values.customReadinessProbe }}
    readinessProbe: {{- include "common.tplvalues.render" (dict "value" .Values.customReadinessProbe "context" $) | nindent 6 }}
    {{- else if .Values.readinessProbe.enabled }}
    readinessProbe:
      httpGet:
        path: /
        port: http
      {{- include "common.tplvalues.render" (dict "value" (omit .Values.readinessProbe "enabled") "context" $) | nindent 6 }}
    {{- end }}
    {{- if .Values.customStartupProbe }}
    startupProbe: {{- include "common.tplvalues.render" (dict "value" .Values.customStartupProbe "context" $) | nindent 6 }}
    {{- else if .Values.startupProbe.enabled }}
    startupProbe:
      httpGet:
        path: /
        port: http
      {{- include "common.tplvalues.render" (dict "value" (omit .Values.startupProbe "enabled") "context" $) | nindent 6 }}
    {{- end }}
    {{- if .Values.resources }}
    resources: {{- toYaml .Values.resources | nindent 6 }}
    {{- else if ne .Values.resourcesPreset "none" }}
    resources: {{- include "common.resources.preset" (dict "type" .Values.resourcesPreset) | nindent 6 }}
    {{- end }}
    volumeMounts:
      - name: data
        mountPath: /bitnami/tomcat
      - name: empty-dir
        mountPath: /opt/bitnami/tomcat/temp
        subPath: app-tmp-dir
      - name: empty-dir
        mountPath: /opt/bitnami/tomcat/conf
        subPath: app-conf-dir
      - name: empty-dir
        mountPath: /opt/bitnami/tomcat/logs
        subPath: app-logs-dir
      - name: empty-dir
        mountPath: /opt/bitnami/tomcat/work
        subPath: app-work-dir
      - name: empty-dir
        mountPath: /tmp
        subPath: tmp-dir
      {{- if .Values.extraVolumeMounts }}
      {{- include "common.tplvalues.render" (dict "value" .Values.extraVolumeMounts "context" $) | nindent 6 }}
      {{- end }}
  {{- if .Values.metrics.jmx.enabled }}
  - name: jmx-exporter
    image: {{ template "tomcat.metrics.jmx.image" . }}
    imagePullPolicy: {{ .Values.metrics.jmx.image.pullPolicy | quote }}
    {{- if .Values.metrics.jmx.containerSecurityContext.enabled }}
    securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.metrics.jmx.containerSecurityContext "context" $) | nindent 12 }}
    {{- end }}
    command:
      - java
    args:
      - -XX:MaxRAMPercentage=100
      - -XshowSettings:vm
      - -jar
      - jmx_prometheus_httpserver.jar
      - {{ .Values.metrics.jmx.ports.metrics | quote }}
      - /etc/jmx-tomcat/jmx-tomcat-prometheus.yml
    ports:
    {{- range $key, $val := .Values.metrics.jmx.ports }}
      - name: {{ $key }}
        containerPort: {{ $val }}
    {{- end }}
    {{- if .Values.metrics.jmx.resources }}
    resources: {{- toYaml .Values.metrics.jmx.resources | nindent 6 }}
    {{- else if ne .Values.metrics.jmx.resourcesPreset "none" }}
    resources: {{- include "common.resources.preset" (dict "type" .Values.metrics.jmx.resourcesPreset) | nindent 6 }}
    {{- end }}
    volumeMounts:
      - name: jmx-config
        mountPath: /etc/jmx-tomcat
      - name: empty-dir
        mountPath: /tmp
        subPath: tmp-dir
  {{- end }}
  {{- if .Values.sidecars }}
  {{- include "common.tplvalues.render" ( dict "value" .Values.sidecars "context" $) | nindent 2 }}
  {{- end }}
volumes:
  - name: empty-dir
    emptyDir: {}
  {{- if (eq .Values.deployment.type "deployment") }}
  {{- if and .Values.persistence.enabled }}
  - name: data
    persistentVolumeClaim:
      claimName: {{ template "tomcat.pvc" . }}
  {{- else }}
  - name: data
    emptyDir: {}
  {{- end }}
  {{- end }}
  {{- if and .Values.metrics.jmx.enabled (or .Values.metrics.jmx.config .Values.metrics.jmx.existingConfigmap) }}
  - configMap:
      name: {{ include "tomcat.metrics.jmx.configmapName" . }}
    name: jmx-config
  {{- end }}
  {{- if .Values.extraVolumes }}
  {{- include "common.tplvalues.render" (dict "value" .Values.extraVolumes "context" $) | nindent 2 }}
  {{- end }}
{{- if .Values.extraPodSpec }}
{{- include "common.tplvalues.render" (dict "value" .Values.extraPodSpec "context" $) | nindent 0}}
{{- end }}
{{- end -}}
