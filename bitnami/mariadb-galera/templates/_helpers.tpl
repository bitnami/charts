{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mariadb-galera.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mariadb-galera.fullname" -}}
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

{{- define "mariadb-galera.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mariadb-galera.labels" -}}
app.kubernetes.io/name: {{ include "mariadb-galera.name" . }}
helm.sh/chart: {{ include "mariadb-galera.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.podLabels }}
{{ toYaml .Values.podLabels -}}
{{- end }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "mariadb-galera.matchLabels" -}}
app.kubernetes.io/name: {{ include "mariadb-galera.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return the proper MariaDB Galera image name
*/}}
{{- define "mariadb-galera.image" -}}
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
Return the proper metrics image name
*/}}
{{- define "mariadb-galera.metrics.image" -}}
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
Get the configuration ConfigMap name.
*/}}
{{- define "mariadb-galera.configurationCM" -}}
{{- if .Values.configurationConfigMap -}}
{{- printf "%s" (tpl .Values.configurationConfigMap $) -}}
{{- else -}}
{{- printf "%s-configuration" (include "mariadb-galera.fullname" .) -}}
{{- end -}}
{{- end -}}

{{ template "mariadb-galera.initdbScriptsCM" . }}
{{/*
Get the initialization scripts ConfigMap name.
*/}}
{{- define "mariadb-galera.initdbScriptsCM" -}}
{{- if .Values.initdbScriptsConfigMap -}}
{{- printf "%s" .Values.initdbScriptsConfigMap -}}
{{- else -}}
{{- printf "%s-init-scripts" (include "mariadb-galera.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "mariadb-galera.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "mariadb-galera.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mariadb-galera.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- else if or .Values.image.pullSecrets .Values.metrics.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- range .Values.metrics.image.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- end -}}
{{- else if or .Values.image.pullSecrets .Values.metrics.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- range .Values.metrics.image.pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "mariadb-galera.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "mariadb-galera.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "mariadb-galera.validateValues.rootPassword" .) -}}
{{- $messages := append $messages (include "mariadb-galera.validateValues.password" .) -}}
{{- $messages := append $messages (include "mariadb-galera.validateValues.mariadbBackupPassword" .) -}}
{{- $messages := append $messages (include "mariadb-galera.validateValues.ldap" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of MariaDB Galera - must provide passwords when forced */}}
{{- define "mariadb-galera.validateValues.rootPassword" -}}
{{- if and .Values.rootUser.forcePassword (empty .Values.rootUser.password) -}}
mariadb-galera: rootUser.password
    A MariaDB Database Root Password is required ("rootUser.forcePassword=true" is set)
    Please set a password (--set rootUser.password="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of MariaDB Galera - must provide passwords when forced */}}
{{- define "mariadb-galera.validateValues.password" -}}
{{- if and .Values.db.forcePassword (empty .Values.db.password) -}}
mariadb-galera: db.password
    A MariaDB Database Password is required ("db.forcePassword=true" is set)
    Please set a password (--set db.password="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of MariaDB Galera - must provide passwords when forced */}}
{{- define "mariadb-galera.validateValues.mariadbBackupPassword" -}}
{{- if and .Values.galera.mariabackup.forcePassword (empty .Values.galera.mariabackup.password) -}}
mariadb-galera: galera.mariabackup.password
    A MariaBackup Password is required ("galera.mariabackup.forcePassword=true" is set)
    Please set a password (--set galera.mariabackup.password="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of MariaDB Galera - must provide mandatory LDAP paremeters when LDAP is enabled */}}
{{- define "mariadb-galera.validateValues.ldap" -}}
{{- if and .Values.ldap.enabled (or (empty .Values.ldap.uri) (empty .Values.ldap.base) (empty .Values.ldap.binddn) (empty .Values.ldap.bindpw)) -}}
mariadb-galera: LDAP
    Invalid LDAP configuration. When enabling LDAP support, the parameters "ldap.uri",
    "ldap.base", "ldap.binddn", and "ldap.bindpw" are mandatory. Please provide them:

    $ helm install {{ .Release.Name }} bitnami/mariadb-galera \
      --set ldap.enabled=true \
      --set ldap.uri="ldap://my_ldap_server" \
      --set ldap.base="dc=example,dc=org" \
      --set ldap.binddn="cn=admin,dc=example,dc=org" \
      --set ldap.bindpw="admin"
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert file.
*/}}
{{- define "mariadb-galera.tlsCert" -}}
{{- printf "/bitnami/mariadb/certs/%s" .Values.tls.certFilename -}}
{{- end -}}

{{/*
Return the path to the cert key file.
*/}}
{{- define "mariadb-galera.tlsCertKey" -}}
{{- printf "/bitnami/mariadb/certs/%s" .Values.tls.certKeyFilename -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "mariadb-galera.tlsCACert" -}}
{{- printf "/bitnami/mariadb/certs/%s" .Values.tls.certCAFilename -}}
{{- end -}}

{{/*
Return the proper Storage Class
*/}}
{{- define "mariadb-galera.storageClass" -}}
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
        {{- if .Values.persistence.storageClass -}}
              {{- if (eq "-" .Values.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.storageClass -}}
        {{- if (eq "-" .Values.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "mariadb-galera.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "mariadb-galera.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
