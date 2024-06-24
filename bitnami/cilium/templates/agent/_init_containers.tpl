{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Returns an init-container that copies some dirs to an empty dir volume to make them writable
*/}}
{{- define "cilium.agent.defaultInitContainers.prepareWriteDirs" -}}
- name: prepare-write-dirs
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.defaultInitContainers.prepareWriteDirs.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.defaultInitContainers.prepareWriteDirs.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.defaultInitContainers.prepareWriteDirs.resources }}
  resources: {{- toYaml .Values.agent.defaultInitContainers.prepareWriteDirs.resources | nindent 4 }}
  {{- else if ne .Values.agent.defaultInitContainers.prepareWriteDirs.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.defaultInitContainers.prepareWriteDirs.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      . /opt/bitnami/scripts/liblog.sh

      info "Copying writable dirs to empty dir"
      # In order to not break the application functionality we need to make some
      # directories writable, so we need to copy it to an empty dir volume
      cp -r --preserve=mode /opt/bitnami/cilium/var/lib/bpf /emptydir/bpf-lib-dir
      info "Copy operation completed"
  volumeMounts:
    - name: empty-dir
      mountPath: /emptydir
{{- end -}}

{{/*
Returns an init-container that generate the Cilium configuration
*/}}
{{- define "cilium.agent.defaultInitContainers.buildConfig" -}}
- name: build-config
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.defaultInitContainers.buildConfig.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.defaultInitContainers.buildConfig.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.defaultInitContainers.buildConfig.resources }}
  resources: {{- toYaml .Values.agent.defaultInitContainers.buildConfig.resources | nindent 4 }}
  {{- else if ne .Values.agent.defaultInitContainers.buildConfig.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.defaultInitContainers.buildConfig.resourcesPreset) | nindent 4 }}
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
{{- define "cilium.agent.defaultInitContainers.installCniPlugin" -}}
- name: install-cni-plugin
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.defaultInitContainers.installCniPlugin.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.defaultInitContainers.installCniPlugin.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.defaultInitContainers.installCniPlugin.resources }}
  resources: {{- toYaml .Values.agent.defaultInitContainers.installCniPlugin.resources | nindent 4 }}
  {{- else if ne .Values.agent.defaultInitContainers.installCniPlugin.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.defaultInitContainers.installCniPlugin.resourcesPreset) | nindent 4 }}
  {{- end }}
  args:
    - /opt/bitnami/scripts/cilium/install-cni-plugin.sh
    - /host
  env:
    - name: HOST_CNI_BIN_DIR
      value: {{ .Values.agent.cniPlugin.hostCNIBinDir }}
  volumeMounts:
    - name: host-cni-bin
      mountPath: {{ printf "/host%s" .Values.agent.cniPlugin.hostCNIBinDir }}
{{- end -}}

{{/*
Returns an init-container that mount bpf fs in the host
*/}}
{{- define "cilium.agent.defaultInitContainers.mountBpf" -}}
- name: host-mount-bpf
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.defaultInitContainers.mountBpf.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.defaultInitContainers.mountBpf.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.defaultInitContainers.mountBpf.resources }}
  resources: {{- toYaml .Values.agent.defaultInitContainers.mountBpf.resources | nindent 4 }}
  {{- else if ne .Values.agent.defaultInitContainers.mountBpf.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.defaultInitContainers.mountBpf.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - bash
  args:
    - -ec
    - |
      mount | grep "{{ .Values.agent.bpf.hostRoot }} type bpf" || mount -t bpf bpf {{ .Values.agent.bpf.hostRoot }}
  volumeMounts:
    - name: bpf-maps
      mountPath: {{ .Values.agent.bpf.hostRoot }}
      mountPropagation: Bidirectional
{{- end -}}

{{/*
Returns an init-container that mount cgroup2 filesystem in the host
*/}}
{{- define "cilium.agent.defaultInitContainers.mountCgroup2" -}}
- name: host-mount-cgroup2
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.defaultInitContainers.mountCgroup2.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.defaultInitContainers.mountCgroup2.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.defaultInitContainers.mountCgroup2.resources }}
  resources: {{- toYaml .Values.agent.defaultInitContainers.mountCgroup2.resources | nindent 4 }}
  {{- else if ne .Values.agent.defaultInitContainers.mountCgroup2.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.defaultInitContainers.mountCgroup2.resourcesPreset) | nindent 4 }}
  {{- end }}
  args:
    - /opt/bitnami/scripts/cilium/mount-cgroup2.sh
    - /host
    - {{ .Values.agent.cgroup2.hostRoot }}
  env:
    - name: HOST_CNI_BIN_DIR
      value: {{ .Values.agent.cniPlugin.hostCNIBinDir }}
  volumeMounts:
    - name: host-cni-bin
      mountPath: {{ printf "/host%s" .Values.agent.cniPlugin.hostCNIBinDir }}
    - name: host-proc
      mountPath: /host/proc
{{- end -}}

{{/*
Returns an init-container that cleans up the Cilium state
*/}}
{{- define "cilium.agent.defaultInitContainers.cleanState" -}}
- name: clean-state
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.defaultInitContainers.cleanState.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.defaultInitContainers.cleanState.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.defaultInitContainers.cleanState.resources }}
  resources: {{- toYaml .Values.agent.defaultInitContainers.cleanState.resources | nindent 4 }}
  {{- else if ne .Values.agent.defaultInitContainers.cleanState.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.defaultInitContainers.cleanState.resourcesPreset) | nindent 4 }}
  {{- end }}
  command:
    - bash
  args:
    - -ec
    - |
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
    - name: host-cgroup-root
      mountPath: {{ .Values.agent.cgroup2.hostRoot }}
      mountPropagation: HostToContainer
{{- end -}}

{{/*
Returns an init-container that waits for kube-proxy to be ready
*/}}
{{- define "cilium.agent.defaultInitContainers.waitForKubeProxy" -}}
- name: wait-for-kube-proxy
  image: {{ include "cilium.agent.image" . }}
  imagePullPolicy: {{ .Values.agent.image.pullPolicy }}
  {{- if .Values.agent.defaultInitContainers.waitForKubeProxy.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.agent.defaultInitContainers.waitForKubeProxy.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.agent.defaultInitContainers.waitForKubeProxy.resources }}
  resources: {{- toYaml .Values.agent.defaultInitContainers.waitForKubeProxy.resources | nindent 4 }}
  {{- else if ne .Values.agent.defaultInitContainers.waitForKubeProxy.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.agent.defaultInitContainers.waitForKubeProxy.resourcesPreset) | nindent 4 }}
  {{- end }}
  args:
    - /opt/bitnami/scripts/cilium/wait-for-kube-proxy.sh
{{- end -}}
