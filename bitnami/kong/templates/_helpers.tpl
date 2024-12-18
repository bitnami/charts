{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper kong image name
*/}}
{{- define "kong.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper kong image name
*/}}
{{- define "kong.ingress-controller.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.ingressController.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper kong migration image name
*/}}
{{- define "kong.migration.image" -}}
{{- if .Values.migration.image -}}
    {{- include "common.images.image" (dict "imageRoot" .Values.migration.image "global" .Values.global) -}}
{{- else -}}
    {{- template "kong.image" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kong.imagePullSecrets" -}}
{{- if .Values.migration.image -}}
    {{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.ingressController.image .Values.migration.image) "global" .Values.global) -}}
{{- else -}}
    {{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.ingressController.image) "global" .Values.global) -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kong.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kong.cassandra.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "cassandra" "chartValues" .Values.cassandra "context" $) -}}
{{- end -}}

{{/*
Get Cassandra port
*/}}
{{- define "kong.cassandra.port" -}}
{{- ternary "9042" .Values.cassandra.external.port .Values.cassandra.enabled | quote -}}
{{- end -}}

{{/*
Get Cassandra contact points
*/}}
{{- define "kong.cassandra.contactPoints" -}}
{{- $global := . -}}
{{- if .Values.cassandra.enabled -}}
  {{- $replicas := int .Values.cassandra.replicaCount -}}
  {{- $domain := .Values.clusterDomain -}}
  {{- range $i, $e := until $replicas }}
    {{- include "kong.cassandra.fullname" $global }}-{{ $i }}.{{ include "kong.cassandra.fullname" $global }}-headless.{{ $global.Release.Namespace }}.svc.{{ $domain }}
    {{- if (lt ( add1 $i ) $replicas ) -}}
    ,
    {{- end -}}
  {{- end -}}
{{- else -}}
  {{- $replicas := len .Values.cassandra.external.hosts -}}
  {{- range $i, $e := until $replicas }}
    {{- index $global.Values.cassandra.external.hosts $i -}}
    {{- if (lt ( add1 $i ) $replicas ) -}}
    ,
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get PostgreSQL host
*/}}
{{- define "kong.postgresql.host" -}}
{{- ternary (include "kong.postgresql.fullname" .) .Values.postgresql.external.host .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Get PostgreSQL port
*/}}
{{- define "kong.postgresql.port" -}}
{{- ternary "5432" .Values.postgresql.external.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Get PostgreSQL user
*/}}
{{- define "kong.postgresql.user" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- coalesce .Values.global.postgresql.auth.username .Values.postgresql.auth.username | quote -}}
        {{- else -}}
            {{- .Values.postgresql.auth.username | quote -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.username | quote -}}
    {{- end -}}
{{- else -}}
    {{- .Values.postgresql.external.user | quote -}}
{{- end -}}
{{- end -}}

{{/*
Get Cassandra user
*/}}
{{- define "kong.cassandra.user" -}}
{{- if .Values.cassandra.enabled -}}
    {{- .Values.cassandra.dbUser.user | quote -}}
{{- else -}}
    {{- .Values.cassandra.external.user | quote -}}
{{- end -}}
{{- end -}}

{{/*
Get Cassandra secret
*/}}
{{- define "kong.cassandra.secretName" -}}
{{- if .Values.cassandra.enabled -}}
    {{- default (include "kong.cassandra.fullname" .) (tpl .Values.cassandra.dbUser.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-external-secret" ( include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "kong.cassandra.databaseSecretKey" -}}
{{- if .Values.cassandra.enabled -}}
    {{- print "cassandra-password" -}}
{{- else -}}
    {{- if .Values.cassandra.external.existingSecret -}}
        {{- if .Values.cassandra.external.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.cassandra.external.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "cassandra-password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "cassandra-password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get PostgreSQL secret
*/}}
{{- define "kong.postgresql.secretName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- if .Values.global.postgresql.auth.existingSecret }}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
               {{- default (include "kong.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "kong.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "kong.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- default (printf "%s-external-secret" (include "common.names.fullname" .)) (tpl .Values.postgresql.external.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "kong.postgresql.databaseSecretKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- if .Values.postgresql.external.existingSecret -}}
        {{- if .Values.postgresql.external.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.postgresql.external.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret for a external database should be created
*/}}
{{- define "kong.createExternalDBSecret" -}}
{{- if or (and (eq .Values.database "postgresql") (not .Values.postgresql.enabled) (not .Values.postgresql.external.existingSecret)) (and (eq .Values.database "cassandra") (not .Values.cassandra.enabled) (not .Values.cassandra.external.existingSecret)) -}}
  {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return database type
*/}}
{{- define "kong.database" -}}
{{- if eq .Values.database "postgresql" -}}
  {{- print "postgres" -}}
{{- else -}}
  {{- print .Values.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the configmap to be used for declarative configuration
*/}}
{{- define "kong.declarativeConfigMap" -}}
{{- if .Values.kong.declarativeConfigCM -}}
  {{- include "common.tplvalues.render" (dict "value" .Values.kong.declarativeConfigCM "context" $) -}}
{{- else if .Values.kong.declarativeConfig -}}
  {{- printf "%s-declarative-config" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-"  -}}
{{- end -}}
{{- end -}}

{{/*
Get proper service account
*/}}
{{- define "kong.ingressController.serviceAccountName" -}}
{{- if .Values.ingressController.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.ingressController.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.ingressController.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Validate values for kong.
*/}}
{{- define "kong.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "kong.validateValues.database" .) -}}
{{- $messages := append $messages (include "kong.validateValues.rbac" .) -}}
{{- $messages := append $messages (include "kong.validateValues.ingressController" .) -}}
{{- $messages := append $messages (include "kong.validateValues.daemonset" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the RBAC
*/}}
{{- define "kong.validateValues.rbac" -}}
{{- if and .Values.ingressController.enabled (not .Values.ingressController.serviceAccount.create) (not .Values.ingressController.serviceAccount.name) (not .Values.ingressController.rbac.create) -}}
INVALID RBAC: You enabled the Kong Ingress Controller sidecar without creating RBAC objects and not
specifying an existing Service Account. Specify an existing Service Account in ingressController.serviceAccount.name
or allow the chart to create the proper RBAC objects with ingressController.rbac.create
{{- end -}}
{{- end -}}

{{/*
Function to validate the external database
*/}}
{{- define "kong.validateValues.database" -}}

{{- if and (not (eq .Values.database "postgresql")) (not (eq .Values.database "cassandra")) (not (eq .Values.database "off")) -}}
INVALID DATABASE: The value "{{ .Values.database }}" is not allowed for the "database" value. It
must be one either "postgresql", "cassandra" or "off".
{{- end }}

{{- if and (eq .Values.database "off") (or (.Values.postgresql.enabled) (.Values.postgresql.external.host) .Values.cassandra.enabled .Values.cassandra.external.hosts) -}}
CONFLICT: You enabled the db-less mode but deployed a database. Ensure that postgresql.enabled=false and cassandra.enabled=false.
{{- end }}

{{- if and (eq .Values.database "postgresql") (not .Values.postgresql.enabled) (not .Values.postgresql.external.host) -}}
NO DATABASE: You disabled the Cassandra sub-chart but did not specify external Cassandra hosts. Either deploy the PostgreSQL sub-chart by setting cassandra.enabled=true or set a value for cassandra.external.hosts.
{{- end }}

{{- if and (eq .Values.database "postgresql") (not .Values.postgresql.enabled) (not .Values.postgresql.external.host) -}}
NO DATABASE: You disabled the PostgreSQL sub-chart but did not specify an external PostgreSQL host. Either deploy the PostgreSQL sub-chart by setting postgresql.enabled=true or set a value for postgresql.external.host.
{{- end }}

{{- if and (eq .Values.database "postgresql") .Values.postgresql.enabled .Values.postgresql.external.host -}}
CONFLICT: You specified to deploy the PostgreSQL sub-chart and also specified an external
PostgreSQL instance. Only one of postgresql.enabled (deploy sub-chart) and postgresql.external.host can be set
{{- end }}

{{- if and (eq .Values.database "cassandra") .Values.cassandra.enabled .Values.cassandra.external.hosts -}}
CONFLICT: You specified to deploy the Cassandra sub-chart and also specified external
Cassandra hosts. Only one of cassandra.enabled (deploy sub-chart) and cassandra.external.hosts can be set
{{- end -}}
{{- end -}}

{{/*
Function to validate the ingress controller
*/}}
{{- define "kong.validateValues.ingressController" -}}
{{- if (and (eq .Values.database "cassandra") .Values.ingressController.enabled) -}}
INGRESS AND CASANDRA: Cassandra-backed deployments of Kong managed by Kong Ingress Controller are no longer supported. You must migrate to a Postgres-backed deployment or disable Kong Ingress Controller.
{{- end -}}
{{- end -}}

{{/*
Function to validate incompatibilities with deploying Kong as a daemonset
*/}}
{{- define "kong.validateValues.daemonset" -}}
{{- if and .Values.useDaemonset (or .Values.pdb.create .Values.autoscaling.enabled) -}}
INVALID SETUP: Deploying a HorizontalPodAutoscaler or a PodDisruptionBudget is not compatible with deploying Kong as a daemonset.
{{- end -}}
{{- end -}}
