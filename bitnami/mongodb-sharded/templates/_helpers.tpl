{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Returns a ServiceAccount name for specified path or falls back to `common.serviceAccount.name`
if `common.serviceAccount.create` is set to true. Falls back to Chart's fullname otherwise.
Usage:
{{ include "mongodb-sharded.serviceAccountName" (dict "component" "mongos" "value" .Values.path.to.serviceAccount "context" $) }}
*/}}
{{- define "mongodb-sharded.serviceAccountName" -}}
{{- if .value.create }}
    {{- default (printf "%s-%s" (include "common.names.fullname" .context) .component) .value.name | quote }}
{{- else if .context.Values.common.serviceAccount.create }}
    {{- default (printf "%s-%s" (include "common.names.fullname" .context) .component) .context.Values.common.serviceAccount.name | quote }}
{{- else -}}
    {{- default "default" .value.name | quote }}
{{- end }}
{{- end }}

{{- define "mongodb-sharded.secret" -}}
  {{- if .Values.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.auth.existingSecret $) -}}
  {{- else }}
    {{- include "common.names.fullname" . -}}
  {{- end }}
{{- end -}}

{{- define "mongodb-sharded.configServer.primaryHost" -}}
  {{- if .Values.configsvr.external.host -}}
  {{- .Values.configsvr.external.host }}
  {{- else -}}
  {{- printf "%s-configsvr-0.%s-headless.%s.svc.%s" (include "common.names.fullname" . ) (include "common.names.fullname" .) .Release.Namespace .Values.clusterDomain -}}
  {{- end -}}
{{- end -}}

{{- define "mongodb-sharded.configServer.rsName" -}}
  {{- if .Values.configsvr.external.replicasetName -}}
    {{- .Values.configsvr.external.replicasetName }}
  {{- else }}
    {{- printf "%s-configsvr" ( include "common.names.fullname" . ) -}}
  {{- end }}
{{- end -}}

{{- define "mongodb-sharded.mongos.configCM" -}}
  {{- if .Values.mongos.configCM -}}
    {{- .Values.mongos.configCM -}}
  {{- else }}
    {{- printf "%s-mongos" (include "common.names.fullname" .) -}}
  {{- end }}
{{- end -}}

{{- define "mongodb-sharded.shardsvr.dataNode.configCM" -}}
  {{- if .Values.shardsvr.dataNode.configCM -}}
    {{- .Values.shardsvr.dataNode.configCM -}}
  {{- else }}
    {{- printf "%s-shardsvr-data" (include "common.names.fullname" .) -}}
  {{- end }}
{{- end -}}

{{- define "mongodb-sharded.shardsvr.arbiter.configCM" -}}
  {{- if .Values.shardsvr.arbiter.configCM -}}
    {{- .Values.shardsvr.arbiter.configCM -}}
  {{- else }}
    {{- printf "%s-shardsvr-arbiter" (include "common.names.fullname" .) -}}
  {{- end }}
{{- end -}}

{{- define "mongodb-sharded.configsvr.configCM" -}}
  {{- if .Values.configsvr.configCM -}}
    {{- .Values.configsvr.configCM -}}
  {{- else }}
    {{- printf "%s-configsvr" (include "common.names.fullname" .) -}}
  {{- end }}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "mongodb-sharded.initScriptsSecret" -}}
  {{- printf "%s" (include "common.tplvalues.render" (dict "value" .Values.common.initScriptsSecret "context" $)) -}}
{{- end -}}

{{/*
Get the initialization scripts configmap name.
*/}}
{{- define "mongodb-sharded.initScriptsCM" -}}
  {{- printf "%s" (include "common.tplvalues.render" (dict "value" .Values.common.initScriptsCM "context" $)) -}}
{{- end -}}

{{/*
Returns the proper Service name depending if an explicit service name is set
in the values file. If the name is not explicitly set it will take the "common.names.fullname"
*/}}
{{- define "mongodb-sharded.serviceName" -}}
  {{- if .Values.service.name -}}
    {{ .Values.service.name }}
  {{- else -}}
    {{ include "common.names.fullname" . }}
  {{- end -}}
{{- end -}}

{{/*
Return the proper MongoDB&reg; image name
*/}}
{{- define "mongodb-sharded.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "mongodb-sharded.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "mongodb-sharded.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mongodb-sharded.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "mongodb-sharded.validateValues" -}}
  {{- $messages := list -}}
  {{- $messages := append $messages (include "mongodb-sharded.validateValues.externalCfgServer" .) -}}
  {{- $messages := append $messages (include "mongodb-sharded.validateValues.replicaCount" .) -}}
  {{- $messages := append $messages (include "mongodb-sharded.validateValues.clusterIPListLength" .) -}}
  {{- $messages := append $messages (include "mongodb-sharded.validateValues.nodePortListLength" .) -}}
  {{- $messages := append $messages (include "mongodb-sharded.validateValues.loadBalancerIPListLength" .) -}}
  {{- $messages := append $messages (include "mongodb-sharded.validateValues.config" .) -}}
  {{- $messages := without $messages "" -}}
  {{- $message := join "\n" $messages -}}

  {{- if $message -}}
    {{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
  {{- end -}}
{{- end -}}

{{/*
Validate values of MongoDB&reg; - If using an external config server, then both the host and the replicaset name should be set.
*/}}
{{- define "mongodb-sharded.validateValues.externalCfgServer" -}}
{{- if and .Values.configsvr.external.replicasetName (not .Values.configsvr.external.host) -}}
mongodb: invalidExternalConfigServer
    You specified a replica set name for the external config server but not a host. Set both configsvr.external.replicasetName and configsvr.external.host
{{- end -}}
{{- if and (not .Values.configsvr.external.replicasetName) .Values.configsvr.external.host -}}
mongodb: invalidExternalConfigServer
    You specified a host for the external config server but not the replica set name. Set both configsvr.external.replicasetName and configsvr.external.host
{{- end -}}
{{- if and .Values.configsvr.external.host (not .Values.configsvr.external.rootPassword) -}}
mongodb: invalidExternalConfigServer
    You specified a host for the external config server but not the root password. Set the configsvr.external.rootPassword value.
{{- end -}}
{{- if and .Values.configsvr.external.host (not .Values.configsvr.external.replicasetKey) -}}
mongodb: invalidExternalConfigServer
    You specified a host for the external config server but not the replica set key. Set the configsvr.external.replicasetKey value.
{{- end -}}
{{- end -}}

{{/*
Validate values of MongoDB&reg; - The number of shards must be positive, as well as the data node replicaCount
*/}}
{{- define "mongodb-sharded.validateValues.replicaCount" -}}
{{- if and (le (int .Values.shardsvr.dataNode.replicaCount) 0) (ge (int .Values.shards) 1) }}
mongodb: invalidShardSvrReplicas
    You specified an invalid number of replicas per shard. Please set shardsvr.dataNode.replicaCount with a positive number or set the number of shards to 0.
{{- end -}}
{{- if lt (int .Values.shardsvr.arbiter.replicaCount) 0 }}
mongodb: invalidShardSvrArbiters
    You specified an invalid number of arbiters per shard. Please set shardsvr.arbiter.replicaCount with a number greater or equal than 0
{{- end -}}
{{- if and (le (int .Values.configsvr.replicaCount) 0) (not .Values.configsvr.external.host) }}
mongodb: invalidConfigSvrReplicas
    You specified an invalid number of replicas per shard. Please set configsvr.replicaCount with a positive number or set the configsvr.external.host value to use
    an external config server replicaset
{{- end -}}
{{- end -}}

{{/*
Validate values of MongoDB&reg; - Cannot use both .config and .configCM
*/}}
{{- define "mongodb-sharded.validateValues.config" -}}
{{- if and .Values.shardsvr.dataNode.configCM .Values.shardsvr.dataNode.config }}
mongodb: shardDataNodeConflictingConfig
    You specified both shardsvr.dataNode.configCM and shardsvr.dataNode.config. You can only set one
{{- end -}}
{{- if and .Values.shardsvr.arbiter.configCM .Values.shardsvr.arbiter.config }}
mongodb: arbiterNodeConflictingConfig
    You specified both shardsvr.arbiter.configCM and shardsvr.arbiter.config. You can only set one
{{- end -}}
{{- if and .Values.mongos.configCM .Values.mongos.config }}
mongodb: mongosNodeConflictingConfig
    You specified both mongos.configCM and mongos.config. You can only set one
{{- end -}}
{{- if and .Values.configsvr.configCM .Values.configsvr.config }}
mongodb: configSvrNodeConflictingConfig
    You specified both configsvr.configCM and configsvr.config. You can only set one
{{- end -}}
{{- end -}}

{{/* Validate values of MongoDB&reg; - number of replicas must be the same as NodePort list */}}
{{- define "mongodb-sharded.validateValues.nodePortListLength" -}}
{{- $replicaCount := int .Values.mongos.replicaCount }}
{{- $nodePortListLength := len .Values.mongos.servicePerReplica.nodePorts }}
{{- if and .Values.mongos.useStatefulSet .Values.mongos.servicePerReplica.enabled (not (eq $replicaCount $nodePortListLength )) (eq .Values.mongos.servicePerReplica.type "NodePort") -}}
mongodb: .Values.mongos.servicePerReplica.nodePorts
    Number of mongos.replicaCount and mongos.servicePerReplica.nodePorts array length must be the same. Currently: replicaCount = {{ $replicaCount }} and nodePorts = {{ $nodePortListLength }}
{{- end -}}
{{- end -}}

{{/* Validate values of MongoDB&reg; - number of replicas must be the same as clusterIP list */}}
{{- define "mongodb-sharded.validateValues.clusterIPListLength" -}}
{{- $replicaCount := int .Values.mongos.replicaCount }}
{{- $clusterIPListLength := len .Values.mongos.servicePerReplica.clusterIPs }}
{{- if and (gt $clusterIPListLength 0) .Values.mongos.useStatefulSet .Values.mongos.servicePerReplica.enabled (not (eq $replicaCount $clusterIPListLength )) (eq .Values.mongos.servicePerReplica.type "ClusterIP") -}}
mongodb: .Values.mongos.servicePerReplica.clusterIPs
    Number of mongos.replicaCount and mongos.servicePerReplica.clusterIPs array length must be the same. Currently: replicaCount = {{ $replicaCount }} and clusterIPs = {{ $clusterIPListLength }}
{{- end -}}
{{- end -}}

{{/* Validate values of MongoDB&reg; - number of replicas must be the same as loadBalancerIP list */}}
{{- define "mongodb-sharded.validateValues.loadBalancerIPListLength" -}}
{{- $replicaCount := int .Values.mongos.replicaCount }}
{{- $loadBalancerIPListLength := len .Values.mongos.servicePerReplica.loadBalancerIPs }}
{{- if and (gt $loadBalancerIPListLength 0) .Values.mongos.useStatefulSet .Values.mongos.servicePerReplica.enabled (not (eq $replicaCount $loadBalancerIPListLength )) (eq .Values.mongos.servicePerReplica.type "LoadBalancer") -}}
mongodb: .Values.mongos.servicePerReplica.loadBalancerIPs
    Number of mongos.replicaCount and mongos.servicePerReplica.loadBalancerIPs array length must be the same. Currently: replicaCount = {{ $replicaCount }} and loadBalancerIPs = {{ $loadBalancerIPListLength }}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "mongodb-sharded.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}
