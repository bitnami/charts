{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb-sharded.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mongodb-sharded.labels" -}}
app.kubernetes.io/name: {{ include "mongodb-sharded.name" . }}
helm.sh/chart: {{ include "mongodb-sharded.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "mongodb-sharded.matchLabels" -}}
app.kubernetes.io/name: {{ include "mongodb-sharded.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "mongodb-sharded.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "mongodb-sharded.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongodb-sharded.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mongodb-sharded.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mongodb-sharded.secret" -}}
  {{- if .Values.existingSecret -}}
    {{- .Values.existingSecret -}}
  {{- else }}
    {{- include "mongodb-sharded.fullname" . -}}
  {{- end }}
{{- end -}}

{{- define "mongodb-sharded.configServer.primaryHost" -}}
  {{- if .Values.configsvr.external.host -}}
  {{- .Values.configsvr.external.host }}
  {{- else -}}
  {{- printf "%s-configsvr-0.%s-headless.%s.svc.%s" (include "mongodb-sharded.fullname" . ) (include "mongodb-sharded.fullname" .) .Release.Namespace .Values.clusterDomain -}}
  {{- end -}}
{{- end -}}

{{- define "mongodb-sharded.configServer.rsName" -}}
  {{- if .Values.configsvr.external.replicasetName -}}
    {{- .Values.configsvr.external.replicasetName }}
  {{- else }}
    {{- printf "%s-configsvr" ( include "mongodb-sharded.fullname" . ) -}}
  {{- end }}
{{- end -}}

{{- define "mongodb-sharded.mongos.configCM" -}}
  {{- if .Values.mongos.configCM -}}
    {{- .Values.mongos.configCM -}}
  {{- else }}
    {{- printf "%s-mongos" (include "mongodb-sharded.fullname" .) -}}
  {{- end }}
{{- end -}}

{{- define "mongodb-sharded.shardsvr.dataNode.configCM" -}}
  {{- if .Values.shardsvr.dataNode.configCM -}}
    {{- .Values.shardsvr.dataNode.configCM -}}
  {{- else }}
    {{- printf "%s-shardsvr-data" (include "mongodb-sharded.fullname" .) -}}
  {{- end }}
{{- end -}}

{{- define "mongodb-sharded.shardsvr.arbiter.configCM" -}}
  {{- if .Values.shardsvr.arbiter.configCM -}}
    {{- .Values.shardsvr.arbiter.configCM -}}
  {{- else }}
    {{- printf "%s-shardsvr-arbiter" (include "mongodb-sharded.fullname" .) -}}
  {{- end }}
{{- end -}}

{{- define "mongodb-sharded.configsvr.configCM" -}}
  {{- if .Values.configsvr.configCM -}}
    {{- .Values.configsvr.configCM -}}
  {{- else }}
    {{- printf "%s-configsvr" (include "mongodb-sharded.fullname" .) -}}
  {{- end }}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "mongodb-sharded.initScriptsSecret" -}}
  {{- printf "%s" (include "mongodb-sharded.tplValue" (dict "value" .Values.common.initScriptsSecret "context" $)) -}}
{{- end -}}

{{/*
Get the initialization scripts configmap name.
*/}}
{{- define "mongodb-sharded.initScriptsCM" -}}
  {{- printf "%s" (include "mongodb-sharded.tplValue" (dict "value" .Values.common.initScriptsCM "context" $)) -}}
{{- end -}}

{{/*
Create the name for the admin secret.
*/}}
{{- define "mongodb-sharded.adminSecret" -}}
    {{- if .Values.auth.existingAdminSecret -}}
        {{- .Values.auth.existingAdminSecret -}}
    {{- else -}}
        {{- include "mongodb-sharded.fullname" . -}}-admin
    {{- end -}}
{{- end -}}

{{/*
Create the name for the key secret.
*/}}
{{- define "mongodb-sharded.keySecret" -}}
  {{- if .Values.auth.existingKeySecret -}}
      {{- .Values.auth.existingKeySecret -}}
  {{- else -}}
      {{- include "mongodb-sharded.fullname" . -}}-keyfile
  {{- end -}}
{{- end -}}

{{/*
Return the proper MongoDB image name
*/}}
{{- define "mongodb-sharded.image" -}}
  {{- $registryName := .Values.image.registry -}}
  {{- $repositoryName := .Values.image.repository -}}
  {{- $tag := .Values.image.tag | toString -}}
  {{/*
  Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
  but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
  Also, we can't use a single if because lazy evaluation is not an option
  */}}
  {{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
      {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
      {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
  {{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
  {{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "mongodb-sharded.metrics.image" -}}
  {{- $registryName := .Values.metrics.image.registry -}}
  {{- $repositoryName := .Values.metrics.image.repository -}}
  {{- $tag := .Values.metrics.image.tag | toString -}}
  {{/*
  Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
  but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
  Also, we can't use a single if because lazy evaluation is not an option
  */}}
  {{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
      {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
      {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
  {{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
  {{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mongodb-sharded.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- $imagePullSecrets := coalesce .Values.global.imagePullSecrets .Values.image.pullSecrets .Values.volumePermissions.image.pullSecrets .Values.metrics.image.pullSecrets -}}
{{- if $imagePullSecrets }}
imagePullSecrets:
{{- range $imagePullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "mongodb-sharded.volumePermissions.image" -}}
  {{- $registryName := .Values.volumePermissions.image.registry -}}
  {{- $repositoryName := .Values.volumePermissions.image.repository -}}
  {{- $tag := .Values.volumePermissions.image.tag | toString -}}
  {{/*
  Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
  but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
  Also, we can't use a single if because lazy evaluation is not an option
  */}}
  {{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
      {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
      {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
  {{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
  {{- end -}}
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
Validate values of MongoDB - both mongodbUsername and mongodbDatabase are necessary
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
Validate values of MongoDB - If using an external config server, then both the host and the replicaset name should be set.
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
Validate values of MongoDB - The number of shards must be positive, as well as the data node replicas
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
Validate values of MongoDB - Cannot use both .config and .configCM
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

{{/*
Return  the proper Storage Class
*/}}
{{- define "mongodb-sharded.shardsvr.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.shardsvr.persistence.storageClass -}}
              {{- if (eq "-" .Values.shardsvr.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.shardsvr.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.shardsvr.persistence.storageClass -}}
        {{- if (eq "-" .Values.shardsvr.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.shardsvr.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "mongodb-sharded.configsvr.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.configsvr.persistence.storageClass -}}
              {{- if (eq "-" .Values.configsvr.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.configsvr.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.configsvr.persistence.storageClass -}}
        {{- if (eq "-" .Values.configsvr.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.configsvr.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Returns the proper Service name depending if an explicit service name is set
in the values file. If the name is not explicitly set it will take the "mongodb-sharded.fullname"
*/}}
{{- define "mongodb-sharded.serviceName" -}}
  {{- if .Values.service.name -}}
    {{ .Values.service.name }}
  {{- else -}}
    {{ include "mongodb-sharded.fullname" .}}
  {{- end -}}
{{- end -}}
