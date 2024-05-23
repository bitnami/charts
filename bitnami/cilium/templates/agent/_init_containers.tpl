{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Returns an init-container that generate the Cilium configuration
*/}}
{{- define "cilium.agent.initContainers.buildConfig" -}}
- name: build-config
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.initContainerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.initContainerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.initContainerResources }}
  resources: {{- toYaml .Values.agent.initContainerResources | nindent 4 }}
  {{- else if ne .Values.agent.initContainerResourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.initContainerResourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - cilium-dbg
  args:
    - build-config
    - --dest
    - /config
    - --source
    - {{ printf "config-map:%s/%s" (include "common.names.namespace" .) (include "cilium.configmapName" .) }}
  env:
    - name: K8S_NODE_NAME
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: spec.nodeName
    - name: CILIUM_K8S_NAMESPACE
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.namespace
  volumeMounts:
    - name: empty-dir
      mountPath: /config
      subPath: config-dir
{{- end -}}

{{/*
Returns an init-container that installs Cilium CNI plugin in the host
*/}}
{{- define "cilium.agent.initContainers.installCniPlugin" -}}
- name: install-cni-plugin
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.initContainerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.initContainerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.initContainerResources }}
  resources: {{- toYaml .Values.agent.initContainerResources | nindent 4 }}
  {{- else if ne .Values.agent.initContainerResourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.initContainerResourcesPreset) | nindent 4 }}
  {{- end }}
  args:
    - /opt/bitnami/scripts/cilium/install-cni-plugin.sh
    - /host
  env:
    - name: HOST_CNI_BIN_DIR
      value: {{ .Values.agent.cniPlugin.hostCNIBinDir }}
  volumeMounts:
    - name: hostCniBin
      mountPath: {{ printf "/host%s" .Values.agent.cniPlugin.hostCNIBinDir }}
{{- end -}}

{{/*
Returns an init-container that mount bpf fs in the host
*/}}
{{- define "cilium.agent.initContainers.mountBpf" -}}
- name: host-mount-bpf
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.initContainerSecurityContext.enabled }}
  # Force running as a privileged container since bidirectional mount propagation
  # requires it
  {{- $securityContex := .Values.agent.initContainerSecurityContext | merge (dict "privileged" true) }}
  {{- $securityContex := unset $securityContex "seLinuxOptions" }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" $securityContex "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.initContainerResources }}
  resources: {{- toYaml .Values.agent.initContainerResources | nindent 4 }}
  {{- else if ne .Values.agent.initContainerResourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.initContainerResourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - bash
  args:
    - -ec
    - |
      #!/bin/bash

      mount | grep "{{ .Values.agent.bpf.hostRoot }} type bpf" || mount -t bpf bpf {{ .Values.agent.bpf.hostRoot }}
  volumeMounts:
    - name: bpf-maps
      mountPath: {{ .Values.agent.bpf.hostRoot }}
      mountPropagation: Bidirectional
{{- end -}}

{{/*
Returns an init-container that mount cgroup2 filesystem in the host
*/}}
{{- define "cilium.agent.initContainers.mountCgroup2" -}}
- name: host-mount-cgroup2
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.initContainerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.initContainerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.initContainerResources }}
  resources: {{- toYaml .Values.agent.initContainerResources | nindent 4 }}
  {{- else if ne .Values.agent.initContainerResourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.initContainerResourcesPreset) | nindent 4 }}
  {{- end }}
  args:
    - /opt/bitnami/scripts/cilium/mount-cgroup2.sh
    - /host
    - {{ .Values.agent.cgroup2.hostRoot }}
  env:
    - name: HOST_CNI_BIN_DIR
      value: {{ .Values.agent.cniPlugin.hostCNIBinDir }}
  volumeMounts:
    - name: hostCniBin
      mountPath: {{ printf "/host%s" .Values.agent.cniPlugin.hostCNIBinDir }}
    - name: hostProc
      mountPath: /host/proc
{{- end -}}

{{/*
Returns an init-container that cleans up the Cilium state
*/}}
{{- define "cilium.agent.initContainers.cleanState" -}}
- name: clean-state
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.initContainerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.initContainerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.initContainerResources }}
  resources: {{- toYaml .Values.agent.initContainerResources | nindent 4 }}
  {{- else if ne .Values.agent.initContainerResourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.initContainerResourcesPreset) | nindent 4 }}
  {{- end }}
  command:
  command:
    - bash
  args:
    - -ec
    - |
      #!/bin/bash

      if [[ "$CLEAN_CILIUM_BPF_STATE" = "true" ]]; then
          cilium-dbg post-uninstall-cleanup -f --bpf-state
      fi
      if [[ "$CLEAN_CILIUM_STATE" = "true" ]]; then
          cilium-dbg post-uninstall-cleanup -f --all-state
      fi
  env:
    - name: CLEAN_CILIUM_STATE
      valueFrom:
        configMapKeyRef:
          name: {{ template "cilium.configmapName" . }}
          key: clean-cilium-state
          optional: true
    - name: CLEAN_CILIUM_BPF_STATE
      valueFrom:
        configMapKeyRef:
          name: {{ template "cilium.configmapName" . }}
          key: clean-cilium-bpf-state
          optional: true
    - name: WRITE_CNI_CONF_WHEN_READY
      valueFrom:
        configMapKeyRef:
          name: {{ template "cilium.configmapName" . }}
          key: write-cni-conf-when-ready
          optional: true
  volumeMounts:
    {{- if .Values.agent.bpf.autoMount }}
    - name: bpf-maps
      mountPath: {{ .Values.agent.bpf.hostRoot }}
    {{- end }}
    - name: cilium-run
      mountPath: /opt/bitnami/cilium/var/run
    - name: hostCgroupRoot
      mountPath: {{ .Values.agent.cgroup2.hostRoot }}
      mountPropagation: HostToContainer
{{- end -}}

{{/*
Returns an init-container that waits for kube-proxy to be ready
*/}}
{{- define "cilium.agent.initContainers.waitForKubeProxy" -}}
- name: wait-for-kube-proxy
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.initContainerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.initContainerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.initContainerResources }}
  resources: {{- toYaml .Values.agent.initContainerResources | nindent 4 }}
  {{- else if ne .Values.agent.initContainerResourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.initContainerResourcesPreset) | nindent 4 }}
  {{- end }}
  args:
    - /opt/bitnami/scripts/cilium/wait-for-kube-proxy.sh
{{- end -}}
