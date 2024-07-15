{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Pod Spec
*/}}
{{- define "argocd.pod" -}}
serviceAccountName: {{ include "argocd.application-controller.serviceAccountName" . }}
{{ include "argocd.imagePullSecrets" . }}
automountServiceAccountToken: {{ .Values.controller.automountServiceAccountToken }}
{{- if .Values.controller.hostAliases }}
hostAliases: {{- include "common.tplvalues.render" (dict "value" .Values.controller.hostAliases "context" $) | nindent 2 }}
{{- end }}
{{- if .Values.controller.affinity }}
affinity: {{- include "common.tplvalues.render" ( dict "value" .Values.controller.affinity "context" $) | nindent 2 }}
{{- else }}
affinity:
  {{- $podLabels := include "common.tplvalues.merge" ( dict "values" ( list .Values.controller.podLabels .Values.commonLabels ) "context" . ) }}
  podAffinity: {{- include "common.affinities.pods" (dict "type" .Values.controller.podAffinityPreset "component" "controller" "customLabels" $podLabels "context" $) | nindent 4 }}
  podAntiAffinity: {{- include "common.affinities.pods" (dict "type" .Values.controller.podAntiAffinityPreset "component" "controller" "customLabels" $podLabels "context" $) | nindent 4 }}
  nodeAffinity: {{- include "common.affinities.nodes" (dict "type" .Values.controller.nodeAffinityPreset.type "key" .Values.controller.nodeAffinityPreset.key "values" .Values.controller.nodeAffinityPreset.values) | nindent 4 }}
{{- end }}
{{- if .Values.controller.nodeSelector }}
nodeSelector: {{- include "common.tplvalues.render" ( dict "value" .Values.controller.nodeSelector "context" $) | nindent 2 }}
{{- end }}
{{- if .Values.controller.tolerations }}
tolerations: {{- include "common.tplvalues.render" (dict "value" .Values.controller.tolerations "context" .) | nindent 2 }}
{{- end }}
{{- if .Values.controller.schedulerName }}
schedulerName: {{ .Values.controller.schedulerName }}
{{- end }}
{{- if .Values.controller.shareProcessNamespace }}
shareProcessNamespace: {{ .Values.controller.shareProcessNamespace }}
{{- end }}
{{- if .Values.controller.topologySpreadConstraints }}
topologySpreadConstraints: {{- include "common.tplvalues.render" (dict "value" .Values.controller.topologySpreadConstraints "context" .) | nindent 2 }}
{{- end }}
{{- if .Values.controller.priorityClassName }}
priorityClassName: {{ .Values.controller.priorityClassName | quote }}
{{- end }}
{{- if .Values.controller.runtimeClassName }}
runtimeClassName: {{ .Values.controller.runtimeClassName }}
{{- end }}
{{- if .Values.controller.podSecurityContext.enabled }}
securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.controller.podSecurityContext "context" $) | nindent 2 }}
{{- end }}
initContainers:
  {{- if .Values.redisWait.enabled }}
  - name: wait-for-redis
    image: {{ include "argocd.redis.image" . }}
    imagePullPolicy: {{ .Values.redis.image.pullPolicy | quote }}
    {{- if .Values.redisWait.securityContext }}
    # Deprecated: use redisWait.containerSecurityContext
    securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.redisWait.securityContext "context" $) | nindent 6 }}
    {{- else if .Values.redisWait.containerSecurityContext.enabled }}
    securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.redisWait.containerSecurityContext "context" $) | nindent 6 }}
    {{- end }}
    command:
      - /bin/bash
    args:
      - -ec
      - |
          #!/bin/bash

          set -o errexit
          set -o nounset
          set -o pipefail

          . /opt/bitnami/scripts/libos.sh
          . /opt/bitnami/scripts/liblog.sh

          check_redis_connection() {
            local result="$(redis-cli -h {{ include "argocd.redisHost" . }} -p {{ include "argocd.redisPort" . }} {{ .Values.redisWait.extraArgs }} PING)"
            if [[ "$result" != "PONG" ]]; then
              false
            fi
          }

          info "Checking redis connection..."
          if ! retry_while "check_redis_connection"; then
              error "Could not connect to the Redis server"
              return 1
          else
              info "Connected to the Redis instance"
          fi
    {{- if include "argocd.redis.auth.enabled" . }}
    env:
      - name: REDISCLI_AUTH
        valueFrom:
          secretKeyRef:
            name: {{ include "argocd.redis.secretName" . }}
            key: {{ include "argocd.redis.secretPasswordKey" . }}
    {{- end }}
  {{- end }}
  {{- if .Values.controller.initContainers }}
  {{- include "common.tplvalues.render" (dict "value" .Values.controller.initContainers "context" $) | nindent 2 }}
  {{- end }}
containers:
  - name: controller
    image: {{ include "argocd.image" . }}
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    {{- if .Values.controller.lifecycleHooks }}
    lifecycle: {{- include "common.tplvalues.render" (dict "value" .Values.controller.lifecycleHooks "context" $) | nindent 6 }}
    {{- end }}
    {{- if .Values.controller.containerSecurityContext.enabled }}
    securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.controller.containerSecurityContext "context" $) | nindent 6 }}
    {{- end }}
    {{- if .Values.controller.command }}
    command: {{- include "common.tplvalues.render" (dict "value" .Values.controller.command "context" $) | nindent 6 }}
    {{- end }}
    {{- if .Values.controller.args }}
    args: {{- include "common.tplvalues.render" (dict "value" .Values.controller.args "context" $) | nindent 6 }}
    {{- else }}
    args:
      - argocd-application-controller
      - --status-processors
      - {{ .Values.controller.defaultArgs.statusProcessors | quote }}
      - --operation-processors
      - {{ .Values.controller.defaultArgs.operationProcessors | quote }}
      - --app-resync
      - {{ .Values.controller.defaultArgs.appResyncPeriod | quote }}
      - --self-heal-timeout-seconds
      - {{ .Values.controller.defaultArgs.selfHealTimeout | quote }}
      - --repo-server
      - {{ include "argocd.repo-server" . }}:{{ coalesce .Values.repoServer.service.port .Values.repoServer.service.ports.repoServer }}
      - --logformat
      - {{ .Values.controller.logFormat | quote }}
      - --loglevel
      - {{ .Values.controller.logLevel | quote }}
      - --metrics-port={{ .Values.controller.containerPorts.metrics }}
      # TODO(miguelaeh): Test the chart using redis sentinel enabled: https://github.com/argoproj/argo-cd/blob/2a410187565e15633b6f2a8c8d8da22cf02b257d/util/cache/cache.go#L40
      - --redis
      - {{ include "argocd.redisHost" . }}:{{ include "argocd.redisPort" . }}
      {{- if .Values.controller.extraArgs }}
      {{- include "common.tplvalues.render" (dict "value" .Values.controller.extraArgs "context" $) | nindent 6 }}
      {{- end }}
    {{- end }}
    ports:
      - name: metrics
        containerPort: {{ .Values.controller.containerPorts.metrics }}
        protocol: TCP
    env:
      - name: ARGOCD_APPLICATION_CONTROLLER_NAME
        value: {{ include "argocd.application-controller" . }}
      {{- if gt (int .Values.server.replicaCount) 1 }}
      - name: ARGOCD_CONTROLLER_REPLICAS
        value: {{ .Values.controller.replicaCount | quote }}
      {{- end }}
      {{- if .Values.controller.dynamicClusterDistribution.enabled }}
      - name: ARGOCD_ENABLE_DYNAMIC_CLUSTER_DISTRIBUTION
        value: "true"
      {{- if .Values.controller.dynamicClusterDistribution.heartbeatDuration }}
      - name: ARGOCD_CONTROLLER_HEARTBEAT_TIME
        value: {{ .Values.controller.dynamicClusterDistribution.heartbeatDuration | quote }}
      {{- end }}
      {{- end }}
      {{- if and .Values.redis.enabled (include "argocd.redis.auth.enabled" .) }}
      - name: REDIS_PASSWORD
        valueFrom:
          secretKeyRef:
            name: {{ include "argocd.redis.secretName" . }}
            key: {{ include "argocd.redis.secretPasswordKey" . }}
      {{- else if .Values.externalRedis.enabled }}
      - name: REDIS_PASSWORD
        {{- if not ( eq "" .Values.externalRedis.password ) }}
        value: {{ .Values.externalRedis.password }}
        {{- else }}
        valueFrom:
          secretKeyRef:
            name: {{ .Values.externalRedis.existingSecret }}
            key: {{ .Values.externalRedis.existingSecretPasswordKey }}
        {{- end }}
      {{- end }}
      {{- if .Values.controller.extraEnvVars }}
      {{- include "common.tplvalues.render" (dict "value" .Values.controller.extraEnvVars "context" $) | nindent 6 }}
      {{- end }}
    envFrom:
      {{- if .Values.controller.extraEnvVarsCM }}
      - configMapRef:
          name: {{ include "common.tplvalues.render" (dict "value" .Values.controller.extraEnvVarsCM "context" $) }}
      {{- end }}
      {{- if .Values.controller.extraEnvVarsSecret }}
      - secretRef:
          name: {{ include "common.tplvalues.render" (dict "value" .Values.controller.extraEnvVarsSecret "context" $) }}
      {{- end }}
    {{- if .Values.controller.resources }}
    resources: {{- toYaml .Values.controller.resources | nindent 6 }}
    {{- else if ne .Values.controller.resourcesPreset "none" }}
    resources: {{- include "common.resources.preset" (dict "type" .Values.controller.resourcesPreset) | nindent 6 }}
    {{- end }}
    {{- if .Values.controller.customStartupProbe }}
    startupProbe: {{- include "common.tplvalues.render" (dict "value" .Values.controller.customStartupProbe "context" $) | nindent 6 }}
    {{- else if .Values.controller.startupProbe.enabled }}
    startupProbe:
      httpGet:
        path: /healthz
        port: metrics
      initialDelaySeconds: {{ .Values.controller.startupProbe.initialDelaySeconds }}
      periodSeconds: {{ .Values.controller.startupProbe.periodSeconds }}
      timeoutSeconds: {{ .Values.controller.startupProbe.timeoutSeconds }}
      successThreshold: {{ .Values.controller.startupProbe.successThreshold }}
      failureThreshold: {{ .Values.controller.startupProbe.failureThreshold }}
    {{- end }}
    {{- if .Values.controller.customLivenessProbe }}
    livenessProbe: {{- include "common.tplvalues.render" (dict "value" .Values.controller.customLivenessProbe "context" $) | nindent 6 }}
    {{- else if .Values.controller.livenessProbe.enabled }}
    livenessProbe:
      httpGet:
        path: /healthz
        port: metrics
      initialDelaySeconds: {{ .Values.controller.livenessProbe.initialDelaySeconds }}
      periodSeconds: {{ .Values.controller.livenessProbe.periodSeconds }}
      timeoutSeconds: {{ .Values.controller.livenessProbe.timeoutSeconds }}
      successThreshold: {{ .Values.controller.livenessProbe.successThreshold }}
      failureThreshold: {{ .Values.controller.livenessProbe.failureThreshold }}
    {{- end }}
    {{- if .Values.controller.customReadinessProbe }}
    readinessProbe: {{- include "common.tplvalues.render" (dict "value" .Values.controller.customReadinessProbe "context" $) | nindent 6 }}
    {{- else if .Values.controller.readinessProbe.enabled }}
    readinessProbe:
      tcpSocket:
        port: metrics
      initialDelaySeconds: {{ .Values.controller.readinessProbe.initialDelaySeconds }}
      periodSeconds: {{ .Values.controller.readinessProbe.periodSeconds }}
      timeoutSeconds: {{ .Values.controller.readinessProbe.timeoutSeconds }}
      successThreshold: {{ .Values.controller.readinessProbe.successThreshold }}
      failureThreshold: {{ .Values.controller.readinessProbe.failureThreshold }}
    {{- end }}
    volumeMounts:
      # Mounting into a path that will be read by Argo CD.
      # This secret will be autogenerated by Argo CD repo server unless it already exists. Users can create its own certificate to override it.
      # Ref: https://argoproj.github.io/argo-cd/operator-manual/tls/#inbound-tls-certificates-used-by-argocd-repo-sever
      - mountPath: /app/config/server/tls
        name: argocd-repo-server-tls
      - name: empty-dir
        mountPath: /tmp
        subPath: tmp-dir
      {{- if .Values.controller.extraVolumeMounts }}
      {{- include "common.tplvalues.render" (dict "value" .Values.controller.extraVolumeMounts "context" $) | nindent 6 }}
      {{- end }}
  {{- if .Values.controller.sidecars }}
  {{- include "common.tplvalues.render" ( dict "value" .Values.controller.sidecars "context" $) | nindent 2 }}
  {{- end }}
volumes:
  - name: empty-dir
    emptyDir: {}
  - name: argocd-repo-server-tls
    secret:
      items:
        - key: tls.crt
          path: tls.crt
        - key: tls.key
          path: tls.key
        - key: ca.crt
          path: ca.crt
      optional: true
      secretName: argocd-repo-server-tls
  {{- if .Values.controller.extraVolumes }}
  {{- include "common.tplvalues.render" (dict "value" .Values.controller.extraVolumes "context" $) | nindent 2 }}
  {{- end }}
  {{- end }}
