{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Compactor pod template. Shared between Cronjob and deployment
*/}}
{{- define "thanos.compactor.podTemplate" -}}
metadata:
  {{- $podLabels := include "common.tplvalues.merge" ( dict "values" ( list .Values.compactor.podLabels .Values.commonLabels ) "context" . ) }}
  labels: {{- include "common.labels.standard" ( dict "customLabels" $podLabels "context" $ ) | nindent 4 }}
    app.kubernetes.io/component: compactor
  {{- if or .Values.compactor.podAnnotations (include "thanos.createObjstoreSecret" .) }}
  annotations:
    {{- if (include "thanos.createObjstoreSecret" .) }}
    checksum/objstore-configuration: {{ include "thanos.objstoreConfig" . | sha256sum }}
    {{- end }}
    {{- if .Values.compactor.podAnnotations }}
    {{- include "common.tplvalues.render" (dict "value" .Values.compactor.podAnnotations "context" $) | nindent 4 }}
    {{- end }}
  {{- end }}
spec:
  {{- include "thanos.imagePullSecrets" . | nindent 2 }}
  serviceAccountName: {{ include "thanos.compactor.serviceAccountName" . }}
  automountServiceAccountToken: {{ .Values.compactor.automountServiceAccountToken }}
  {{- if .Values.compactor.hostAliases }}
  hostAliases: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.hostAliases "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.compactor.affinity }}
  affinity: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.affinity "context" $) | nindent 4 }}
  {{- else }}
  affinity:
    podAffinity: {{- include "common.affinities.pods" (dict "type" .Values.compactor.podAffinityPreset "component" "compactor" "customLabels" $podLabels "context" $) | nindent 6 }}
    podAntiAffinity: {{- include "common.affinities.pods" (dict "type" .Values.compactor.podAntiAffinityPreset "component" "compactor" "customLabels" $podLabels "context" $) | nindent 6 }}
    nodeAffinity: {{- include "common.affinities.nodes" (dict "type" .Values.compactor.nodeAffinityPreset.type "key" .Values.compactor.nodeAffinityPreset.key "values" .Values.compactor.nodeAffinityPreset.values) | nindent 6 }}
  {{- end }}
  {{- if .Values.compactor.dnsConfig }}
  dnsConfig: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.dnsConfig "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.compactor.dnsPolicy }}
  dnsPolicy: {{ .Values.compactor.dnsPolicy | quote }}
  {{- end }}
  {{- if .Values.compactor.nodeSelector }}
  nodeSelector: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.nodeSelector "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.compactor.tolerations }}
  tolerations: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.tolerations "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.compactor.priorityClassName }}
  priorityClassName: {{ .Values.compactor.priorityClassName | quote }}
  {{- end }}
  {{- if .Values.compactor.schedulerName }}
  schedulerName: {{ .Values.compactor.schedulerName }}
  {{- end }}
  {{- if .Values.compactor.podSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.compactor.podSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.compactor.topologySpreadConstraints }}
  topologySpreadConstraints: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.topologySpreadConstraints "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.compactor.restartPolicy }}
  restartPolicy: {{ .Values.compactor.restartPolicy }}
  {{- else if .Values.compactor.cronJob.enabled }}
  restartPolicy: Never
  {{- end }}
  {{- if or .Values.compactor.initContainers (and .Values.volumePermissions.enabled .Values.compactor.persistence.enabled) }}
  initContainers:
    {{- if and .Values.volumePermissions.enabled .Values.compactor.persistence.enabled }}
    - name: init-chmod-data
      image: {{ include "thanos.volumePermissions.image" . }}
      imagePullPolicy: {{ .Values.volumePermissions.image.pullPolicy | quote }}
      command:
        - sh
        - -c
        - |
          mkdir -p /data
          chown -R "{{ .Values.compactor.containerSecurityContext.runAsUser }}:{{ .Values.compactor.podSecurityContext.fsGroup }}" /data
      securityContext:
        runAsUser: 0
      volumeMounts:
        - name: data
          mountPath: /data
    {{- end }}
    {{- if .Values.compactor.initContainers }}
    {{- include "common.tplvalues.render" (dict "value" .Values.compactor.initContainers "context" $) | nindent 4 }}
    {{- end }}
  {{- end }}
  containers:
    {{- if .Values.compactor.sidecars }}
    {{- include "common.tplvalues.render" (dict "value" .Values.compactor.sidecars "context" $) | nindent 4 }}
    {{- end }}
    - name: compactor
      image: {{ include "thanos.image" . }}
      imagePullPolicy: {{ .Values.image.pullPolicy | quote }}
      {{- if .Values.compactor.containerSecurityContext.enabled }}
      securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.compactor.containerSecurityContext "context" $) | nindent 8 }}
      {{- end }}
      {{- if .Values.compactor.command }}
      command: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.command "context" $) | nindent 8 }}
      {{- end }}
      args:
        {{- if .Values.compactor.args }}
        {{- include "common.tplvalues.render" (dict "value" .Values.compactor.args "context" $) | nindent 8 }}
        {{- else }}
        - compact
        - --log.level={{ .Values.compactor.logLevel }}
        - --log.format={{ .Values.compactor.logFormat }}
        - --http-address=0.0.0.0:{{ .Values.compactor.containerPorts.http }}
        - --data-dir=/data
        - --retention.resolution-raw={{ .Values.compactor.retentionResolutionRaw }}
        - --retention.resolution-5m={{ .Values.compactor.retentionResolution5m }}
        - --retention.resolution-1h={{ .Values.compactor.retentionResolution1h }}
        - --consistency-delay={{ .Values.compactor.consistencyDelay }}
        - --objstore.config-file=/conf/objstore.yml
        {{- if (include "thanos.httpConfigEnabled" .) }}
        - --http.config=/conf/http/http-config.yml
        {{- end }}
        {{- if .Values.compactor.extraFlags }}
        {{- .Values.compactor.extraFlags | toYaml | nindent 8 }}
        {{- end }}
        {{- if not .Values.compactor.cronJob.enabled }}
        - --wait
        {{- end }}
        {{- end }}
      {{- if .Values.compactor.extraEnvVars }}
      env: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.extraEnvVars "context" $) | nindent 8 }}
      {{- end }}
      {{- if or .Values.compactor.extraEnvVarsCM .Values.compactor.extraEnvVarsSecret }}
      envFrom:
        {{- if .Values.compactor.extraEnvVarsCM }}
        - configMapRef:
            name: {{ include "common.tplvalues.render" (dict "value" .Values.compactor.extraEnvVarsCM "context" $) }}
        {{- end }}
        {{- if .Values.compactor.extraEnvVarsSecret }}
        - secretRef:
            name: {{ include "common.tplvalues.render" (dict "value" .Values.compactor.extraEnvVarsSecret "context" $) }}
        {{- end }}
      {{- end }}
      ports:
        - name: http
          containerPort: {{ .Values.compactor.containerPorts.http }}
          protocol: TCP
      {{- if .Values.compactor.customLivenessProbe }}
      livenessProbe: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.customLivenessProbe "context" $) | nindent 8 }}
      {{- else if .Values.compactor.livenessProbe.enabled }}
      livenessProbe: {{- include "common.tplvalues.render" (dict "value" (omit .Values.compactor.livenessProbe "enabled") "context" $) | nindent 8 }}
        tcpSocket:
          port: http
      {{- end }}
      {{- if .Values.compactor.customReadinessProbe }}
      readinessProbe: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.customReadinessProbe "context" $) | nindent 8 }}
      {{- else if .Values.compactor.readinessProbe.enabled }}
      readinessProbe: {{- include "common.tplvalues.render" (dict "value" (omit .Values.compactor.readinessProbe "enabled") "context" $) | nindent 8 }}
        {{- if not .Values.auth.basicAuthUsers }}
        httpGet:
          path: /-/ready
          port: http
          scheme: {{ ternary "HTTPS" "HTTP" .Values.https.enabled }}
        {{- else }}
        tcpSocket:
          port: http
        {{- end }}
      {{- end }}
      {{- if .Values.compactor.customStartupProbe }}
      startupProbe: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.customStartupProbe "context" $) | nindent 8 }}
      {{- else if .Values.compactor.startupProbe.enabled }}
      startupProbe: {{- include "common.tplvalues.render" (dict "value" (omit .Values.compactor.startupProbe "enabled") "context" $) | nindent 8 }}
        {{- if not .Values.auth.basicAuthUsers }}
        httpGet:
          path: /-/ready
          port: http
          scheme: {{ ternary "HTTPS" "HTTP" .Values.https.enabled }}
        {{- else }}
        tcpSocket:
          port: http
        {{- end }}
      {{- end }}
      {{- if .Values.compactor.lifecycleHooks }}
      lifecycle: {{- include "common.tplvalues.render" (dict "value" .Values.compactor.lifecycleHooks "context" $) | nindent 8 }}
      {{- end }}
      {{- if .Values.compactor.resources }}
      resources: {{- toYaml .Values.compactor.resources | nindent 8 }}
      {{- else if ne .Values.compactor.resourcesPreset "none" }}
      resources: {{- include "common.resources.preset" (dict "type" .Values.compactor.resourcesPreset) | nindent 8 }}
      {{- end }}
      volumeMounts:
        - name: objstore-config
          mountPath: /conf
        {{- if (include "thanos.httpConfigEnabled" .) }}
        - name: http-config
          mountPath: /conf/http
        {{- if .Values.https.enabled }}
        - name: http-certs
          mountPath: /certs
        {{- end }}
        {{- end }}
        - name: data
          mountPath: /data
        {{- if .Values.compactor.extraVolumeMounts }}
        {{- include "common.tplvalues.render" (dict "value" .Values.compactor.extraVolumeMounts "context" $) | nindent 8 }}
        {{- end }}
  volumes:
    - name: objstore-config
      secret:
        secretName: {{ include "thanos.objstoreSecretName" . }}
        {{- if .Values.existingObjstoreSecretItems }}
        items: {{- toYaml .Values.existingObjstoreSecretItems | nindent 10 }}
        {{- end }}
    {{- if (include "thanos.httpConfigEnabled" .) }}
    - name: http-config
      secret:
        secretName: {{ include "thanos.httpConfigSecretName" . }}
    {{- if .Values.https.enabled }}
    - name: http-certs
      secret:
        secretName: {{ include "thanos.httpCertsSecretName" . }}
    {{- end }}
    {{- end }}
    {{- if or .Values.compactor.persistence.enabled .Values.compactor.persistence.defaultEmptyDir }}
    - name: data
      {{- if .Values.compactor.persistence.enabled }}
      {{- if .Values.compactor.persistence.ephemeral }}
      ephemeral:
        volumeClaimTemplate:
          metadata:
            {{- $labels := include "common.tplvalues.merge" ( dict "values" ( list .Values.compactor.persistence.labels .Values.commonLabels ) "context" . ) }}
            labels: {{- include "common.labels.standard" ( dict "customLabels" $labels "context" $ ) | nindent 14 }}
              app.kubernetes.io/component: compactor
            {{- if or .Values.compactor.persistence.annotations .Values.commonAnnotations }}
            {{- $annotations := include "common.tplvalues.merge" ( dict "values" ( list .Values.compactor.persistence.annotations .Values.commonAnnotations ) "context" . ) }}
            annotations: {{- include "common.tplvalues.render" ( dict "value" $annotations "context" $) | nindent 14 }}
            {{- end }}
          spec:
            accessModes:
            {{- range .Values.compactor.persistence.accessModes }}
              - {{ . | quote }}
            {{- end }}
            {{- include "common.storage.class" (dict "persistence" .Values.compactor.persistence "global" .Values.global) | nindent 12 }}
            resources:
              requests:
                storage: {{ .Values.compactor.persistence.size | quote }}
      {{- else }}
      persistentVolumeClaim:
        claimName: {{ include "thanos.compactor.pvcName" . }}
      {{- end }}
      {{- else }}
      emptyDir: {}
      {{- end }}
    {{- end }}
    {{- if .Values.compactor.extraVolumes }}
    {{- include "common.tplvalues.render" (dict "value" .Values.compactor.extraVolumes "context" $) | nindent 4 }}
    {{- end }}
{{- end -}}
