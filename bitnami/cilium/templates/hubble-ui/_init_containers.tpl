{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Returns an init-container that waits for Hubble Relay to be ready
*/}}
{{- define "cilium.hubble.ui.waitForHubbleRelay" -}}
- name: wait-for-hubble-relay
  image: {{ include "cilium.hubble.relay.image" . }}
  imagePullPolicy: {{ .Values.hubble.relay.image.pullPolicy }}
  {{- if .Values.hubble.ui.defaultInitContainers.waitForHubbleRelay.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.hubble.ui.defaultInitContainers.waitForHubbleRelay.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.hubble.ui.defaultInitContainers.waitForHubbleRelay.resources }}
  resources: {{- toYaml .Values.hubble.ui.defaultInitContainers.waitForHubbleRelay.resources | nindent 4 }}
  {{- else if ne .Values.hubble.ui.defaultInitContainers.waitForHubbleRelay.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.hubble.ui.defaultInitContainers.waitForHubbleRelay.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      set -o errexit
      set -o nounset
      set -o pipefail

      retry_while() {
          local cmd="${1:?cmd is missing}"
          local retries="${2:-12}"
          local sleep_time="${3:-5}"
          local return_value=1

          read -r -a command <<<"$cmd"
          for ((i = 1; i <= retries; i += 1)); do
              "${command[@]}" && return_value=0 && break
              sleep "$sleep_time"
          done
          return $return_value
      }

      exit_code=0
      if ! retry_while "grpc-health-probe -addr=${HUBBLE_RELAY_ENDPOINT} ${GRPC_FLAGS}"; then
          echo "hubble is not ready"
          exit_code=1
      else
          echo "hubble ready"
      fi

      exit "$exit_code"
  env:
    - name: HUBBLE_RELAY_ENDPOINT
      value: {{ printf "%s.%s.svc.%s:%d" (include "cilium.hubble.relay.fullname" .) (include "common.names.namespace" .) .Values.clusterDomain (int .Values.hubble.relay.service.ports.grpc) | quote }}
  {{- if not .Values.hubble.tls.enabled }}
    - name: GRPC_FLAGS
      value: "-rpc-timeout=2s"
  {{- else }}
    - name: GRPC_FLAGS
      value: "-rpc-timeout=2s -tls -tls-ca-cert=/certs/client/ca.crt -tls-client-cert=/certs/client/tls.crt -tls-client-key=/certs/client/tls.key"
  volumeMounts:
    - name: client-cert
      readOnly: true
      mountPath: /certs/client
  {{- end }}
{{- end -}}

{{/*
Returns an init-container that preserves the NGINX logs symlinks
*/}}
{{- define "cilium.hubble.ui.preserveLogLinks" -}}
- name: preserve-logs-symlinks
  image: {{ template "cilium.hubble.ui.frontend.image" . }}
  imagePullPolicy: {{ .Values.hubble.ui.frontend.image.pullPolicy }}
  {{- if .Values.hubble.ui.frontend.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.hubble.ui.frontend.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.hubble.ui.frontend.resources }}
  resources: {{- toYaml .Values.hubble.ui.frontend.resources | nindent 4 }}
  {{- else if ne .Values.hubble.ui.frontend.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.hubble.ui.frontend.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/libfs.sh

      # We copy the logs folder because it has symlinks to stdout and stderr
      if ! is_dir_empty /opt/bitnami/nginx/logs; then
        cp -r /opt/bitnami/nginx/logs /emptydir/nginx-logs-dir
      fi
  volumeMounts:
    - name: empty-dir
      mountPath: /emptydir
{{- end -}}
