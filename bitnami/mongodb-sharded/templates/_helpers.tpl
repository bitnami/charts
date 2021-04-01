{{/* vim: set filetype=mustache: */}}

{{/*
Returns a ServiceAccount name for specified path or falls back to `common.serviceAccount.name`
if `common.serviceAccount.create` is set to true. Falls back to Chart's fullname otherwise.
Usage:
{{ include "mongodb-sharded.serviceAccountName" (dict "value" .Values.path.to.serviceAccount "context" $) }}
*/}}
{{- define "mongodb-sharded.serviceAccountName" -}}
{{- if .value.create }}
    {{- default (include "common.names.fullname" .context) .value.name | quote }}
{{- else if .context.Values.common.serviceAccount.create }}
    {{- default (include "common.names.fullname" .context) .context.Values.common.serviceAccount.name | quote }}
{{- else -}}
    {{- default "default" .value.name | quote }}
{{- end }}
{{- end }}

{{/*
Renders a ServiceAccount for specified name.
Usage:
{{ include "mongodb-sharded.serviceaccount" (dict "value" .Values.path.to.serviceAccount "context" $) }}
*/}}
{{- define "mongodb-sharded.serviceaccount" -}}
{{- if .value.create -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "mongodb-sharded.serviceAccountName" (dict "value" .value "context" .context) }}
  labels:
    {{- include "common.labels.standard" .context | nindent 4 }}
---
{{ end -}}
{{- end -}}

{{- define "mongodb-sharded.secret" -}}
  {{- if .Values.existingSecret -}}
    {{- .Values.existingSecret -}}
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
Create the name for the admin secret.
*/}}
{{- define "mongodb-sharded.adminSecret" -}}
    {{- if .Values.auth.existingAdminSecret -}}
        {{- .Values.auth.existingAdminSecret -}}
    {{- else -}}
        {{- include "common.names.fullname" . -}}-admin
    {{- end -}}
{{- end -}}

{{/*
Create the name for the key secret.
*/}}
{{- define "mongodb-sharded.keySecret" -}}
  {{- if .Values.auth.existingKeySecret -}}
      {{- .Values.auth.existingKeySecret -}}
  {{- else -}}
      {{- include "common.names.fullname" . -}}-keyfile
  {{- end -}}
{{- end -}}

{{/*
Returns the proper Service name depending if an explicit service name is set
in the values file. If the name is not explicitly set it will take the "common.names.fullname"
*/}}
{{- define "mongodb-sharded.serviceName" -}}
  {{- if .Values.service.name -}}
    {{ .Values.service.name }}
  {{- else -}}
    {{ include "common.names.fullname" .}}
  {{- end -}}
{{- end -}}

{{/*
Return the proper MongoDB(R) image name
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
  {{- $messages := append $messages (include "mongodb-sharded.validateValues.mongodbCustomDatabase" .) -}}
  {{- $messages := append $messages (include "mongodb-sharded.validateValues.externalCfgServer" .) -}}
  {{- $messages := append $messages (include "mongodb-sharded.validateValues.replicas" .) -}}
  {{- $messages := append $messages (include "mongodb-sharded.validateValues.config" .) -}}
  {{- $messages := without $messages "" -}}
  {{- $message := join "\n" $messages -}}

  {{- if $message -}}
    {{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
  {{- end -}}
{{- end -}}

{{/*
Validate values of MongoDB(R) - both mongodbUsername and mongodbDatabase are necessary
to create a custom user and database during 1st initialization
*/}}
{{- define "mongodb-sharded.validateValues.mongodbCustomDatabase" -}}
{{- if or (and .Values.mongodbUsername (not .Values.mongodbDatabase)) (and (not .Values.mongodbUsername) .Values.mongodbDatabase) }}
mongodb: mongodbUsername, mongodbDatabase
    Both mongodbUsername and mongodbDatabase must be provided to create
    a custom user and database during 1st initialization.
    Please set both of them (--set mongodbUsername="xxxx",mongodbDatabase="yyyy")
{{- end -}}
{{- end -}}

{{/*
Validate values of MongoDB(R) - If using an external config server, then both the host and the replicaset name should be set.
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
Validate values of MongoDB(R) - The number of shards must be positive, as well as the data node replicas
*/}}
{{- define "mongodb-sharded.validateValues.replicas" -}}
{{- if and (le (int .Values.shardsvr.dataNode.replicas) 0) (ge (int .Values.shards) 1) }}
mongodb: invalidShardSvrReplicas
    You specified an invalid number of replicas per shard. Please set shardsvr.dataNode.replicas with a positive number or set the number of shards to 0.
{{- end -}}
{{- if lt (int .Values.shardsvr.arbiter.replicas) 0 }}
mongodb: invalidShardSvrArbiters
    You specified an invalid number of arbiters per shard. Please set shardsvr.arbiter.replicas with a number greater or equal than 0
{{- end -}}
{{- if and (le (int .Values.configsvr.replicas) 0) (not .Values.configsvr.external.host) }}
mongodb: invalidConfigSvrReplicas
    You specified an invalid number of replicas per shard. Please set configsvr.replicas with a positive number or set the configsvr.external.host value to use
    an external config server replicaset
{{- end -}}
{{- end -}}

{{/*
Validate values of MongoDB(R) - Cannot use both .config and .configCM
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

{{/* Check if there are rolling tags in the images */}}
{{- define "mongodb-sharded.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- end -}}
