{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the service account to use
*/}}
{{- define "kubernetes-event-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create default config for leader election when replicaCount is greater than 1
*/}}
{{- define "kubernetes-event-exporter.leaderElectionConfig" -}}
  {{- if gt (int64 .Values.replicaCount) 1 -}}
leaderElection:
  enabled: true
  leaderElectionID: {{ include "common.names.fullname" . }}-leader-election
  {{- else -}}
leaderElection: {}
  {{- end -}}
{{- end -}}

{{/*
Create final config by merging user supplied config and default config
*/}}
{{- define "kubernetes-event-exporter.config" -}}
  {{- $leaderElectionConfig := fromYaml (include "kubernetes-event-exporter.leaderElectionConfig" .) -}}
  {{- toYaml (mergeOverwrite $leaderElectionConfig .Values.config) }}
{{- end -}}
