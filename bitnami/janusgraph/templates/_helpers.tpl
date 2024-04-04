{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper JanusGraph image name
*/}}
{{- define "janusgraph.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "janusgraph.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper image name (for the sidecar JMX exporter image)
*/}}
{{- define "janusgraph.metrics.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.metrics.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "janusgraph.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "janusgraph.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Returns true if a storage backend has been configured
*/}}
{{- define "janusgraph.storage.enabled" -}}
{{- if .Values.storage.cassandra.enabled -}}
{{- true -}}
{{- else if .Values.storage.berkeleyje.enabled -}}
{{- true -}}
{{- else if .Values.storage.external.backend -}}
{{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns the configured storage backend
*/}}
{{- define "janusgraph.storage.backend" -}}
{{- if .Values.storage.cassandra.enabled -}}
{{- print "cql" -}}
{{- else if .Values.storage.berkeleyje.enabled -}}
{{- print "berkeleyje" -}}
{{- else if .Values.storage.external.backend -}}
{{- printf "%s" .Values.storage.external.backend -}}
{{- end -}}
{{- end -}}

{{/*
Returns the hostname of the configured storage backend
*/}}
{{- define "janusgraph.storage.hostname" -}}
{{- if .Values.storage.cassandra.enabled -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "cassandra" "chartValues" .Values.storage.cassandra "context" $) -}}
{{- else if .Values.storage.external.hostname -}}
{{- printf "%s" .Values.storage.external.hostname -}}
{{- end -}}
{{- end -}}

{{/*
Returns the port of the configured storage backend
*/}}
{{- define "janusgraph.storage.port" -}}
{{- if .Values.storage.cassandra.enabled }}
{{- printf "%d" (int .Values.cassandra.service.ports.cql) -}}
{{- else if .Values.storage.external.port -}}
{{- printf "%d" (int .Values.storage.external.port) -}}
{{- end -}}
{{- end -}}

{{/*
Create the storage password secret name
*/}}
{{- define "janusgraph.storage.username" -}}
    {{- if .Values.storage.cassandra.enabled -}}
        {{- printf "%s" (default "cassandra" .Values.cassandra.dbUser.user) -}}
    {{- else if .Values.storage.external.username -}}
        {{- .Values.storage.external.username -}}
    {{- end -}}
{{- end -}}

{{/*
Create the storage password secret name
*/}}
{{- define "janusgraph.storage.password.secretName" -}}
    {{- if .Values.storage.cassandra.enabled -}}
        {{- printf "%s-cassandra" (include "common.names.fullname" .) -}}
    {{- else if .Values.storage.external.existingSecret -}}
        {{- .Values.storage.external.existingSecret -}}
    {{- end -}}
{{- end -}}

{{/*
Create the storage password secret key
*/}}
{{- define "janusgraph.storage.password.secretKey" -}}
    {{- if .Values.storage.cassandra.enabled -}}
        cassandra-password
    {{- else if .Values.storage.external.existingSecretPasswordKey -}}
        {{- .Values.storage.external.existingSecretPasswordKey -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if a index management backend has been configured
*/}}
{{- define "janusgraph.index.enabled" -}}
{{- if .Values.index.lucene.enabled -}}
{{- true -}}
{{- else if .Values.index.external.backend -}}
{{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns the configured index management backend
*/}}
{{- define "janusgraph.index.backend" -}}
{{- if .Values.index.lucene.enabled -}}
{{- print "lucene" -}}
{{- else if .Values.index.external.backend -}}
{{- printf "%s" .Values.index.external.backend -}}
{{- end -}}
{{- end -}}

{{/*
Returns the hostname of the configured index management backend
*/}}
{{- define "janusgraph.index.hostname" -}}
{{- if .Values.index.external.hostname -}}
{{- printf "%s" .Values.index.external.hostname -}}
{{- end -}}
{{- end -}}

{{/*
Returns the port of the configured index management backend
*/}}
{{- define "janusgraph.index.port" -}}
{{- if .Values.index.external.port -}}
{{- printf "%s" .Values.index.external.port -}}
{{- end -}}
{{- end -}}

{{/*
Returns the Janusgraph JVM Java options for the conteiner
*/}}
{{- define "janusgraph.javaOpts" -}}
{{- if .Values.metrics.enabled -}}
{{ printf "%s -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=%d" .Values.javaOptions (int .Values.containerPorts.jmx) }}
{{- else -}}
{{ printf "%s" .Values.javaOptions }}
{{- end -}}
{{- end -}}

{{/*
Return the JanusGraph configuration configmap
*/}}
{{- define "janusgraph.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.existingConfigmap "context" $) -}}
{{- else -}}
    {{ printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the JanusGraph metrics configuration configmap
*/}}
{{- define "janusgraph.metrics.configmapName" -}}
{{- if .Values.metrics.existingConfigmap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.metrics.existingConfigmap "context" $) -}}
{{- else -}}
    {{ printf "%s-jmx-configuration" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
*/}}
{{- define "janusgraph.ingress.certManagerRequest" -}}
{{ if or (hasKey . "cert-manager.io/cluster-issuer") (hasKey . "cert-manager.io/issuer") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "janusgraph.validateValues" -}}
{{- $messages := list -}}
{{/*
{{- $messages := append $messages (include "janusgraph.validateValues.foo" .) -}}
{{- $messages := append $messages (include "janusgraph.validateValues.bar" .) -}}
*/}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}
