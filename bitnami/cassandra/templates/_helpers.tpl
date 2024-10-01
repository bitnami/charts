{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Cassandra image name
*/}}
{{- define "cassandra.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper metrics image name
*/}}
{{- define "cassandra.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "cassandra.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "cassandra.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "cassandra.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the list of Cassandra seed nodes
*/}}
{{- define "cassandra.seeds" -}}
{{- $seeds := list }}
{{- $fullname := include "common.names.fullname" .  }}
{{- $releaseNamespace := include "common.names.namespace" . }}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $seedCount := .Values.cluster.seedCount | int }}
{{- range $e, $i := until $seedCount }}
{{- $seeds = append $seeds (printf "%s-%d.%s-headless.%s.svc.%s" $fullname $i $fullname $releaseNamespace $clusterDomain) }}
{{- end }}
{{- range .Values.cluster.extraSeeds }}
{{- $seeds = append $seeds . }}
{{- end }}
{{- join "," $seeds }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "cassandra.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "cassandra.validateValues.seedCount" .) -}}
{{- $messages := append $messages (include "cassandra.validateValues.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Cassandra - Number of seed nodes */}}
{{- define "cassandra.validateValues.seedCount" -}}
{{- $replicaCount := int .Values.replicaCount }}
{{- $seedCount := int .Values.cluster.seedCount }}
{{- if or (lt $seedCount 1) (gt $seedCount $replicaCount) }}
cassandra: cluster.seedCount

    Number of seed nodes must be greater or equal than 1 and less or
    equal to `replicaCount`.
{{- end -}}
{{- end -}}

{{/* Validate values of Cassandra - Tls enabled */}}
{{- define "cassandra.validateValues.tls" -}}
{{- if and (include "cassandra.tlsEncryption" .) (not .Values.tls.autoGenerated) (not .Values.tls.existingSecret) (not .Values.tls.certificatesSecret) }}
cassandra: tls.enabled
    In order to enable TLS, you also need to provide
    an existing secret containing the Keystore and Truststore or
    enable auto-generated certificates.
{{- end -}}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Return  the proper Commit Storage Class
{{ include "cassandra.commitstorage.class" ( dict "persistence" .Values.path.to.the.persistence "global" $) }}
*/}}
{{- define "cassandra.commitstorage.class" -}}
{{- $storageClass := default .persistence.commitStorageClass | default (.global).defaultStorageClass | default "" -}}

{{- if $storageClass -}}
  {{- if (eq "-" $storageClass) -}}
      {{- printf "storageClassName: \"\"" -}}
  {{- else }}
      {{- printf "storageClassName: %s" $storageClass -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if encryption via TLS for client connections should be configured
*/}}
{{- define "cassandra.client.tlsEncryption" -}}
{{- if (or .Values.tls.clientEncryption .Values.cluster.clientEncryption) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if encryption via TLS for internode communication connections should be configured
*/}}
{{- define "cassandra.internode.tlsEncryption" -}}
{{- if (ne .Values.tls.internodeEncryption "none") -}}
    {{- printf "%s" .Values.tls.internodeEncryption -}}
{{- else -}}
    {{- printf "none" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if encryption via TLS should be configured
*/}}
{{- define "cassandra.tlsEncryption" -}}
{{- if or (include "cassandra.client.tlsEncryption" . ) ( ne "none" (include "cassandra.internode.tlsEncryption" . )) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Convert memory to M
Usage:
{{ include "cassandra.memory.convertToM" (dict "value" "3Gi") }}
*/}}
{{- define "cassandra.memory.convertToM" -}}
{{- $res := 0 -}}
{{- if regexMatch "G" .value -}}
{{- /* Multiply by 1000 if it is Gigabytes */ -}}
{{- $res = regexFind "[0-9.]+" .value | float64 | mulf 1000 | int -}}
{{- else -}}
{{- /* Assume M for the rest, so simply extract the number and convert to int */ -}}
{{- $res = regexFind "[0-9]+" .value | int -}}
{{- end -}}
{{- $res -}}
{{- end -}}

{{/*
Return memory limit if resources or resourcesPreset has been set (in M)
*/}}
{{- define "cassandra.memory.getLimitInM" -}}
{{- $res := "" -}}
{{- if .Values.resources -}}
    {{- /* We need to go step by step to avoid nil pointer exceptions */ -}}
    {{- if .Values.resources.limits -}}
        {{- if .Values.resources.limits.memory -}}
            {{- $res = .Values.resources.limits.memory -}}
        {{- end -}}
    {{- end }}
{{- else if (ne .Values.resourcesPreset "none") -}}
    {{- $preset := include "common.resources.preset" (dict "type" .Values.resourcesPreset) | fromYaml -}}
    {{- $res = $preset.limits.memory -}}
{{- end -}}
{{- if $res -}}
    {{- /* Convert to M */ -}}
    {{- include "cassandra.memory.convertToM" (dict "value" $res) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate Max Heap Size based on the given values
*/}}
{{- define "cassandra.memory.calculateMaxHeapSize" -}}
{{- if .Values.jvm.maxHeapSize -}}
{{- /* Honor value explicitly set */ -}}
{{- print .Values.jvm.maxHeapSize -}}
{{- else -}}
{{- /* Calculate based on resources set */ -}}
{{- /* Reference: https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gc-ergonomics.html */ -}}
{{- $res := include "cassandra.memory.getLimitInM" . -}}
{{- $res = div $res 4 | min 1000 -}}
{{- printf "%vM" $res -}}
{{- end -}}
{{- end -}}

{{/*
Calculate New Heap Size based on the given values
*/}}
{{- define "cassandra.memory.calculateNewHeapSize" -}}
{{- if .Values.jvm.newHeapSize -}}
{{- /* Honor value explicitly set */ -}}
{{- print .Values.jvm.newHeapSize -}}
{{- else -}}
{{- /* Calculate based on resources set */ -}}
{{- /* Reference: https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gc-ergonomics.html */ -}}
{{- $res := include "cassandra.memory.getLimitInM" . -}}
{{- $res = div $res 64 | max 256 -}}
{{- printf "%vM" $res -}}
{{- end -}}
{{- end -}}

{{/*
Return the Cassandra TLS    credentials secret
*/}}
{{- define "cassandra.tlsSecretName" -}}
{{- $secretName := coalesce .Values.tls.existingSecret .Values.tls.tlsEncryptionSecretName -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "cassandra.createTlsSecret" -}}
{{- if and (include "cassandra.tlsEncryption" .) .Values.tls.autoGenerated (not .Values.tls.existingSecret) (not .Values.tls.tlsEncryptionSecretName) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "cassandra.tlsPasswordsSecret" -}}
{{- $secretName := coalesce .Values.tls.passwordsSecret .Values.tls.tlsEncryptionSecretName -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-tls-pass" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get the password to use to access Cassandra
*/}}
{{- define "cassandra.password" -}}
    {{- if (and (empty .Values.dbUser.password) .Values.dbUser.forcePassword) }}
        {{ required "A Cassandra Password is required!" .Values.dbUser.password }}
    {{- else }}
        {{- include "common.secrets.passwords.manage" (dict "secret" (include "common.names.fullname" .) "key" "cassandra-password" "providedValues" (list "dbUser.password") "context" $) -}}
    {{- end }}
{{- end -}}

{{/*
Get the metrics config map name.
*/}}
{{- define "cassandra.metricsConfConfigMap" -}}
    {{- printf "%s-metrics-conf" (include "common.names.fullname" . ) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Print warning if jvm memory not set
*/}}
{{- define "cassandra.warnings.jvm" -}}
{{- if not .Values.jvm.maxHeapSize }}
WARNING: JVM Max Heap Size not set in value jvm.maxHeapSize. When not set, the chart will calculate the following size:
     MIN(Memory Limit (if set) / 4, 1024M)
{{- end }}
{{- if not .Values.jvm.maxHeapSize }}
WARNING: JVM New Heap Size not set in value jvm.newHeapSize. When not set, the chart will calculate the following size:
     MAX(Memory Limit (if set) / 64, 256M)
{{- end }}
{{- end -}}
