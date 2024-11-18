{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Returns an init-container that waits for Hubble to be ready
*/}}
{{- define "cilium.hubble.relay.waitForHubble" -}}
- name: wait-for-hubble-peers
  image: {{ include "cilium.hubble.relay.image" . }}
  imagePullPolicy: {{ .Values.hubble.relay.image.pullPolicy }}
  {{- if .Values.hubble.relay.defaultInitContainers.waitForHubble.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.hubble.relay.defaultInitContainers.waitForHubble.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.hubble.relay.defaultInitContainers.waitForHubble.resources }}
  resources: {{- toYaml .Values.hubble.relay.defaultInitContainers.waitForHubble.resources | nindent 4 }}
  {{- else if ne .Values.hubble.relay.defaultInitContainers.waitForHubble.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.hubble.relay.defaultInitContainers.waitForHubble.resourcesPreset) | nindent 4 }}
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
      if ! retry_while "grpc-health-probe -addr=${HUBBLE_PEERS_ENDPOINT} ${GRPC_FLAGS}"; then
          echo "hubble is not ready"
          exit_code=1
      else
          echo "hubble ready"
      fi

      exit "$exit_code"
  env:
    - name: HUBBLE_PEERS_ENDPOINT
      value: {{ printf "%s.%s.svc.%s:%d" (printf "%s-hubble-peers" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-") (include "common.names.namespace" .) .Values.clusterDomain (int .Values.hubble.peers.service.port) | quote }}
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
