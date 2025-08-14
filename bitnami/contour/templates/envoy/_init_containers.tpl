{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Returns an init-container that bootstraps Envoy configuration so it's ready to be consumed by Envoy "main" container
*/}}
{{- define "contour.envoy.defaultInitContainers.initConfig" -}}
- name: envoy-initconfig
  image: {{ include "common.images.image" ( dict "imageRoot" .Values.contour.image "global" .Values.global) }}
  imagePullPolicy: {{ .Values.contour.image.pullPolicy }}
  {{- if .Values.envoy.defaultInitContainers.initConfig.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.envoy.defaultInitContainers.initConfig.containerSecurityContext "context" .) | nindent 4 }}
  {{- end }}
  {{- if .Values.envoy.defaultInitContainers.initConfig.resources }}
  resources: {{- toYaml .Values.envoy.defaultInitContainers.initConfig.resources | nindent 4 }}
  {{- else if ne .Values.envoy.defaultInitContainers.initConfig.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.envoy.defaultInitContainers.initConfig.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - contour
  args:
    - bootstrap
    - /config/envoy.json
    - --xds-address={{ include "common.names.fullname" . }}
    - --xds-port={{ .Values.contour.service.ports.xds }}
    - --resources-dir=/config/resources
    - --envoy-cafile=/certs/ca.crt
    - --envoy-cert-file=/certs/tls.crt
    - --envoy-key-file=/certs/tls.key
    {{- if .Values.contour.overloadManager.enabled }}
    - --overload-max-heap={{ int .Values.contour.overloadManager.maxHeapBytes }}
    {{- end }}
  env:
    - name: CONTOUR_NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
    {{- if .Values.contour.extraEnvVars }}
      {{- include "common.tplvalues.render" (dict "value" .Values.contour.extraEnvVars "context" $) | nindent 4 }}
    {{- end }}
  {{- if or .Values.contour.extraEnvVarsCM .Values.contour.extraEnvVarsSecret }}
  envFrom:
    {{- if .Values.contour.extraEnvVarsCM }}
    - configMapRef:
        name: {{ tpl .Values.contour.extraEnvVarsCM . }}
    {{- end }}
    {{- if .Values.contour.extraEnvVarsSecret }}
    - secretRef:
        name: {{ tpl .Values.contour.extraEnvVarsSecret . }}
    {{- end }}
  {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /config
      subPath: app-conf-dir
    - name: envoycert
      mountPath: /certs
      readOnly: true
    - name: empty-dir
      mountPath: /admin
      subPath: app-admin-dir
{{- end -}}
