{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "apisix.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.dashboard.image .Values.ingressController.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper APISIX Data-Plane image name
*/}}
{{- define "apisix.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper APISIX Data-Plane fullname
*/}}
{{- define "apisix.data-plane.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "data-plane" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper APISIX Data-Plane fullname (with namespace)
*/}}
{{- define "apisix.data-plane.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "data-plane" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "apisix.data-plane.tlsSecretName" -}}
{{- if .Values.dataPlane.tls.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.dataPlane.tls.existingSecret "context" $) -}}
{{- else -}}
    {{- printf "%s-tls" (include "apisix.data-plane.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (APISIX Data-Plane)
*/}}
{{- define "apisix.data-plane.serviceAccountName" -}}
{{- if .Values.dataPlane.serviceAccount.create -}}
    {{- default (include "apisix.data-plane.fullname" .) .Values.dataPlane.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.dataPlane.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Name of the data-plane ConfigMap
*/}}
{{- define "apisix.data-plane.defaultConfigmapName" -}}
{{- if .Values.dataPlane.existingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.dataPlane.existingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-default" (include "apisix.data-plane.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Name of the data-plane ConfigMap
*/}}
{{- define "apisix.data-plane.extraConfigmapName" -}}
{{- if .Values.dataPlane.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.dataPlane.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "apisix.data-plane.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper APISIX Control-Plane fullname
*/}}
{{- define "apisix.control-plane.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "control-plane" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper APISIX Control-Plane fullname (with namespace)
*/}}
{{- define "apisix.control-plane.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "control-plane" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use (APISIX Control-Plane)
*/}}
{{- define "apisix.control-plane.serviceAccountName" -}}
{{- if .Values.controlPlane.serviceAccount.create -}}
    {{- default (include "apisix.control-plane.fullname" .) .Values.controlPlane.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.controlPlane.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Name of the control-plane ConfigMap
*/}}
{{- define "apisix.control-plane.defaultConfigmapName" -}}
{{- if .Values.controlPlane.existingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.controlPlane.existingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-default" (include "apisix.control-plane.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Name of the control-plane ConfigMap
*/}}
{{- define "apisix.control-plane.extraConfigmapName" -}}
{{- if .Values.controlPlane.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.controlPlane.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "apisix.control-plane.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Name of the control-plane Secret
*/}}
{{- define "apisix.control-plane.secretName" -}}
{{- if .Values.controlPlane.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.controlPlane.existingSecret "context" $) -}}
{{- else -}}
    {{- printf "%s-api-token" (include "apisix.control-plane.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "apisix.control-plane.tlsSecretName" -}}
{{- if .Values.controlPlane.tls.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.controlPlane.tls.existingSecret "context" $) -}}
{{- else -}}
    {{- printf "%s-tls" (include "apisix.control-plane.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve control-plane admin token key
*/}}
{{- define "apisix.control-plane.adminTokenKey" -}}
{{- if .Values.controlPlane.existingSecretAdminTokenKey -}}
    {{- print .Values.controlPlane.existingSecretAdminTokenKey -}}
{{- else -}}
    {{- print "admin-token" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve control-plane viewer token key
*/}}
{{- define "apisix.control-plane.viewerTokenKey" -}}
{{- if .Values.controlPlane.existingSecretViewerTokenKey -}}
    {{- print .Values.controlPlane.existingSecretViewerTokenKey -}}
{{- else -}}
    {{- print "viewer-token" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper APISIX Ingress Controller image name
*/}}
{{- define "apisix.ingress-controller.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.ingressController.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper APISIX Ingress-Controller fullname
*/}}
{{- define "apisix.ingress-controller.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ingress-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper APISIX Ingress-Controller fullname (with namespace)
*/}}
{{- define "apisix.ingress-controller.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "ingress-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "apisix.ingress-controller.tlsSecretName" -}}
{{- if .Values.ingressController.tls.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.ingressController.tls.existingSecret "context" $) -}}
{{- else -}}
    {{- printf "%s-tls" (include "apisix.ingress-controller.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Create the name of the service account to use (APISIX Ingress-Controller)
*/}}
{{- define "apisix.ingress-controller.serviceAccountName" -}}
{{- if .Values.ingressController.serviceAccount.create -}}
    {{- default (include "apisix.ingress-controller.fullname" .) .Values.ingressController.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.ingressController.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Name of the ingress-controller ConfigMap
*/}}
{{- define "apisix.ingress-controller.defaultConfigmapName" -}}
{{- if .Values.ingressController.existingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.ingressController.existingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-default" (include "apisix.ingress-controller.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Name of the dashboard ConfigMap
*/}}
{{- define "apisix.ingress-controller.extraConfigmapName" -}}
{{- if .Values.ingressController.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.ingressController.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "apisix.ingress-controller.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper APISIX Dashboard image name
*/}}
{{- define "apisix.dashboard.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.dashboard.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper APISIX Dashboard fullname
*/}}
{{- define "apisix.dashboard.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "dashboard" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper APISIX Dashboard fullname (with namespace)
*/}}
{{- define "apisix.dashboard.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "dashboard" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use (APISIX Dashboard)
*/}}
{{- define "apisix.dashboard.serviceAccountName" -}}
{{- if .Values.dashboard.serviceAccount.create -}}
    {{- default (include "apisix.dashboard.fullname" .) .Values.dashboard.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.dashboard.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Name of the dashboard ConfigMap
*/}}
{{- define "apisix.dashboard.defaultConfigmapName" -}}
{{- if .Values.dashboard.existingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.dashboard.existingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-default" (include "apisix.dashboard.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Name of the control-plane ConfigMap
*/}}
{{- define "apisix.dashboard.extraConfigmapName" -}}
{{- if .Values.dashboard.extraConfigExistingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.dashboard.extraConfigExistingConfigMap "context" $) -}}
{{- else -}}
    {{- printf "%s-extra" (include "apisix.dashboard.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Name of the control-plane ConfigMap
*/}}
{{- define "apisix.dashboard.secretName" -}}
{{- if .Values.dashboard.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.dashboard.existingSecret "context" $) -}}
{{- else -}}
    {{- include "apisix.dashboard.fullname" . -}}
{{- end -}}
{{- end -}}

{{- define "apisix.dashboard.tlsSecretName" -}}
{{- if .Values.dashboard.tls.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.dashboard.tls.existingSecret "context" $) -}}
{{- else -}}
    {{- printf "%s-tls" (include "apisix.dashboard.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "apisix.dashboard.secretPasswordKey" -}}
{{- if .Values.dashboard.existingSecretPasswordKey -}}
    {{- print .Values.dashboard.existingSecretPasswordKey -}}
{{- else -}}
    {{- print "password" -}}
{{- end -}}
{{- end -}}

{{- define "apisix.wait-container.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.waitContainer.image "global" .Values.global) -}}
{{- end -}}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "apisix.prepareApisixInitContainer" -}}
# This init container renders and merges the APISIX configuration files, as well
# as preparing the Nginx server. We need to use a volume because we're working with
# ReadOnlyRootFilesystem
- name: prepare-apisix
  image: {{ template "apisix.image" .context }}
  imagePullPolicy: {{ .context.Values.image.pullPolicy }}
  {{- $block := "" }}
  {{- if eq .component "data-plane" }}
  {{- $block = index .context.Values "dataPlane" }}
  {{- else }}
  {{- $block = index .context.Values "controlPlane" }}
  {{- end }}
  {{- if $block.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" $block.containerSecurityContext "context" .context) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash
      cp -R /opt/bitnami/apisix/conf /usr/local/apisix
      ln -sf /opt/bitnami/apisix/deps /usr/local/apisix
      ln -sf /opt/bitnami/apisix/openresty/luajit/share/lua/*/apisix /usr/local/apisix
      mkdir -p /usr/local/apisix/logs
      # Build final config.yaml with the sections of the different files
      find /bitnami/apisix/conf -type f -name *.yaml -print0 | sort -z | xargs -0 yq eval-all '. as $item ireduce ({}; . * $item )' > /usr/local/apisix/conf/pre-render-config.yaml
      render-template /usr/local/apisix/conf/pre-render-config.yaml > /usr/local/apisix/conf/config.yaml
      rm /usr/local/apisix/conf/pre-render-config.yaml
      chmod 644 /usr/local/apisix/conf/config.yaml
      apisix init
      {{- if eq .component "control-plane" }}
      apisix init_etcd
      {{- end }}
      {{- if $block.tls.enabled }}
      # The path is hardcoded in the conf so we need to copy them to the server folder
      cp /bitnami/certs/{{ $block.tls.certFilename }} /usr/local/apisix/conf/cert/ssl_PLACE_HOLDER.crt
      cp /bitnami/certs/{{ $block.tls.certKeyFilename }} /usr/local/apisix/conf/cert/ssl_PLACE_HOLDER.key
      {{- end }}
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .context.Values.image.debug .context.Values.diagnosticMode.enabled) | quote }}
    - name: APISIX_ADMIN_API_TOKEN
      valueFrom:
        secretKeyRef:
          name: {{ include "apisix.control-plane.secretName" .context }}
          key: {{ include "apisix.control-plane.adminTokenKey" .context }}
    - name: APISIX_VIEWER_API_TOKEN
      valueFrom:
        secretKeyRef:
          name: {{ include "apisix.control-plane.secretName" .context }}
          key: {{ include "apisix.control-plane.viewerTokenKey" .context }}
    {{- if (include "apisix.etcd.authEnabled" .context) }}
    - name: APISIX_ETCD_USER
      value: {{ include "apisix.etcd.user" .context }}
    - name: APISIX_ETCD_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "apisix.etcd.secretName" .context }}
          key: {{ include "apisix.etcd.secretPasswordKey" .context }}
    {{- end }}
    {{- if $block.extraEnvVars }}
    {{- include "common.tplvalues.render" (dict "value" $block.extraEnvVars "context" .context) | nindent 4 }}
    {{- end }}
  envFrom:
    {{- if $block.extraEnvVarsCM }}
    - configMapRef:
        name: {{ include "common.tplvalues.render" (dict "value" $block.extraEnvVarsCM "context" .context) }}
    {{- end }}
    {{- if $block.extraEnvVarsSecret }}
    - secretRef:
        name: {{ include "common.tplvalues.render" (dict "value" $block.extraEnvVarsSecret "context" .context) }}
    {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /usr/local/apisix
      subPath: app-tmp-dir
    - name: config
      mountPath: /bitnami/apisix/conf/00_default
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    {{- if or $block.extraConfig $block.extraConfigExistingConfigMap }}
    - name: extra-config
      mountPath: /bitnami/apisix/conf/01_extra
    {{- end }}
    {{- if $block.tls.enabled }}
    - name: certs
      mountPath: /bitnami/certs
    {{- end }}
{{- end -}}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "apisix.waitForETCDInitContainer" -}}
- name: wait-for-etcd
  image: {{ template "apisix.wait-container.image" . }}
  imagePullPolicy: {{ .Values.waitContainer.image.pullPolicy }}
  {{- if .Values.waitContainer.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.waitContainer.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash
      retry_while() {
        local -r cmd="${1:?cmd is missing}"
        local -r retries="${2:-12}"
        local -r sleep_time="${3:-5}"
        local return_value=1

        read -r -a command <<< "$cmd"
        for ((i = 1 ; i <= retries ; i+=1 )); do
            "${command[@]}" && return_value=0 && break
            sleep "$sleep_time"
        done
        return $return_value
      }

      etcd_hosts=(
      {{- if .Values.etcd.enabled  }}
        "{{ ternary "https" "http" $.Values.etcd.auth.client.secureTransport }}://{{ printf "%s:%v" (include "apisix.etcd.fullname" $ ) ( include "apisix.etcd.port" $ ) }}"
      {{- else }}
      {{- range $node :=.Values.externalEtcd.servers }}
        "{{ ternary "https" "http" $.Values.externalEtcd.secureTransport }}://{{ printf "%s:%v" $node (include "apisix.etcd.port" $) }}"
      {{- end }}
      {{- end }}
      )

      check_etcd() {
          local -r etcd_host="${1:-?missing etcd}"
          if curl --max-time 5 "${etcd_host}/version" | grep etcdcluster; then
             return 0
          else
             return 1
          fi
      }

      for host in "${etcd_hosts[@]}"; do
          echo "Checking connection to $host"
          if retry_while "check_etcd $host"; then
              echo "Connected to $host"
          else
              echo "Error connecting to $host"
              exit 1
          fi
      done

      echo "Connection success"
      exit 0
{{- end -}}

{{/*
Init container definition for waiting for the database to be ready
*/}}
{{- define "apisix.waitForControlPlaneInitContainer" -}}
- name: wait-for-control-plane
  image: {{ template "apisix.wait-container.image" . }}
  imagePullPolicy: {{ .Values.waitContainer.image.pullPolicy }}
  {{- if .Values.waitContainer.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.waitContainer.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash
      retry_while() {
        local -r cmd="${1:?cmd is missing}"
        local -r retries="${2:-12}"
        local -r sleep_time="${3:-5}"
        local return_value=1

        read -r -a command <<< "$cmd"
        for ((i = 1 ; i <= retries ; i+=1 )); do
            "${command[@]}" && return_value=0 && break
            sleep "$sleep_time"
        done
        return $return_value
      }

      host="{{ ternary "https" "http" .Values.controlPlane.tls.enabled }}://{{ include "apisix.control-plane.fullname" . }}:{{ .Values.controlPlane.service.ports.adminAPI }}"

      check_control_plane() {
          if curl --max-time 5 -k -I "$host"; then
             return 0
          else
             return 1
          fi
      }

      echo "Checking connection to $host"
      if retry_while "check_control_plane"; then
          echo "Connected to $host"
      else
          echo "Error connecting to $host"
          exit 1
      fi

      echo "Connection success"
      exit 0
{{- end -}}

{{- define "apisix.etcd.authEnabled" }}
{{- if .Values.etcd.enabled -}}
    {{- if .Values.etcd.auth.rbac.create -}}
        {{- true -}}
    {{- end -}}
{{- else if .Values.externalEtcd.servers -}}
    {{- if or .Values.externalEtcd.existingSecret .Values.externalEtcd.password -}}
        {{- true -}}
    {{- end -}}
{{- end }}
{{- end }}

{{/*
Render configuration for the dashboard and ingress-controller components
*/}}
{{- define "apisix.renderConfInitContainer" -}}
# This init container renders and merges the APISIX configuration files, as well
# as preparing the Nginx server. We need to use a volume because we're working with
# ReadOnlyRootFilesystem
- name: render-conf
  image: {{ template "apisix.image" .context }}
  imagePullPolicy: {{ .context.Values.image.pullPolicy }}
  {{- $block := "" }}
  {{- if eq .component "ingress-controller" }}
  {{- $block = index .context.Values "ingressController" }}
  {{- else }}
  {{- $block = index .context.Values "dashboard" }}
  {{- end }}
  {{- if $block.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" $block.containerSecurityContext "context" .context) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash
      # Build final config.yaml with the sections of the different files
      find /bitnami/apisix/conf -type f -name *.yaml -print0 | sort -z | xargs -0 yq eval-all '. as $item ireduce ({}; . * $item )' > /bitnami/apisix/rendered-conf/pre-render-config.yaml
      render-template /bitnami/apisix/rendered-conf/pre-render-config.yaml > /bitnami/apisix/rendered-conf/config.yaml
      chmod 644 /bitnami/apisix/rendered-conf/config.yaml
      rm /bitnami/apisix/rendered-conf/pre-render-config.yaml
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .context.Values.image.debug .context.Values.diagnosticMode.enabled) | quote }}
    - name: APISIX_ADMIN_API_TOKEN
      valueFrom:
        secretKeyRef:
          name: {{ include "apisix.control-plane.secretName" .context }}
          key: {{ include "apisix.control-plane.adminTokenKey" .context }}
    - name: APISIX_VIEWER_API_TOKEN
      valueFrom:
        secretKeyRef:
          name: {{ include "apisix.control-plane.secretName" .context }}
          key: {{ include "apisix.control-plane.viewerTokenKey" .context }}
    {{- if (include "apisix.etcd.authEnabled" .context) }}
    - name: APISIX_ETCD_USER
      value: {{ include "apisix.etcd.user" .context }}
    - name: APISIX_ETCD_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "apisix.etcd.secretName" .context }}
          key: {{ include "apisix.etcd.secretPasswordKey" .context }}
    {{- end }}
    {{- if eq .component "dashboard" }}
    - name: APISIX_DASHBOARD_USER
      value: {{ $block.username | quote }}
    - name: APISIX_DASHBOARD_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "apisix.dashboard.secretName" .context }}
          key: {{ include "apisix.dashboard.secretPasswordKey" .context }}
    {{- end }}
    {{- if $block.extraEnvVars }}
    {{- include "common.tplvalues.render" (dict "value" $block.extraEnvVars "context" $) | nindent 4 }}
    {{- end }}
  envFrom:
    {{- if $block.extraEnvVarsCM }}
    - configMapRef:
        name: {{ include "common.tplvalues.render" (dict "value" $block.extraEnvVarsCM "context" .context) }}
    {{- end }}
    {{- if $block.extraEnvVarsSecret }}
    - secretRef:
        name: {{ include "common.tplvalues.render" (dict "value" $block.extraEnvVarsSecret "context" $) }}
    {{- end }}
  volumeMounts:
    - name: empty-dir
      mountPath: /bitnami/apisix/rendered-conf
      subPath: app-conf-dir
    - name: config
      mountPath: /bitnami/apisix/conf/00_default
    {{- if or $block.extraConfig $block.extraConfigExistingConfigMap }}
    - name: extra-config
      mountPath: /bitnami/apisix/conf/01_extra
    {{- end }}
    {{- if $block.tls.enabled }}
    - name: certs
      mountPath: /bitnami/certs
    {{- end }}
{{- end -}}

{{/*
Return etcd port
*/}}
{{- define "apisix.etcd.port" -}}
{{- if .Values.etcd.enabled -}}
    {{/* We are using the headless service so we need to use the container port */}}
    {{- print .Values.etcd.containerPorts.client -}}
{{- else -}}
    {{- print .Values.externalEtcd.port  -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "apisix.etcd.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "etcd" "chartValues" .Values.etcd "context" $) -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "apisix.etcd.headlessServiceName" -}}
{{-  printf "%s-headless" (include "apisix.etcd.fullname" .) -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "apisix.etcd.secretName" -}}
{{- if .Values.etcd.enabled -}}
    {{- print (include "apisix.etcd.fullname" .) -}}
{{- else if .Values.externalEtcd.existingSecret -}}
    {{- print .Values.externalEtcd.existingSecret -}}
{{- else -}}
    {{- printf "%s-external-etcd" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "apisix.etcd.secretPasswordKey" -}}
{{- if .Values.etcd.enabled -}}
    {{- print "etcd-root-password" -}}
{{- else -}}
    {{- print .Values.externalEtcd.existingSecretPasswordKey -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "apisix.etcd.user" -}}
{{- if .Values.etcd.enabled -}}
    {{- print "root" -}}
{{- else -}}
    {{- print .Values.externalEtcd.user -}}
{{- end -}}
{{- end -}}

{{/*
Validate values for APISIX.
*/}}
{{- define "apisix.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "apisix.validateValues.controllers" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the controller deployment
*/}}
{{- define "apisix.validateValues.controllers" -}}
{{- if not (or .Values.dataPlane.enabled .Values.controlPlane.enabled .Values.dashboard.enabled .Values.ingressController.enabled) -}}
apisix: Missing controllers. At least one controller should be enabled.
{{- end -}}
{{- end -}}
