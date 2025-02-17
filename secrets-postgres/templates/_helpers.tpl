{{/* vim: set filetype=mustache: */}}
{{/*
Generate secret name.

Usage:
{{ include "common.secrets.name" (dict "existingSecret" .Values.path.to.the.existingSecret "defaultNameSuffix" "mySuffix" "context" $) }}

Params:
  - existingSecret - ExistingSecret/String - Optional. The path to the existing secrets in the values_.yaml given by the user
    to be used instead of the default one. Allows for it to be of type String (just the secret name) for backwards compatibility.
    +info: https://github.com/bitnami/charts/tree/master/bitnami/common#existingsecret
  - defaultNameSuffix - String - Optional. It is used only if we have several secrets in the same deployment.
  - context - Dict - Required. The context for the template evaluation.
*/}}
{{- define "common.secrets.name" -}}
{{- $name := (include "common.names.fullname" .context) -}}

{{- if .defaultNameSuffix -}}
{{- $name = printf "%s-%s" $name .defaultNameSuffix | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- with .existingSecret -}}
{{- if not (typeIs "string" .) -}}
{{- with .name -}}
{{- $name = . -}}
{{- end -}}
{{- else -}}
{{- $name = . -}}
{{- end -}}
{{- end -}}

{{- printf "%s" $name -}}
{{- end -}}

{{/*
Generate secret key.

Usage:
{{ include "common.secrets.key" (dict "existingSecret" .Values.path.to.the.existingSecret "key" "keyName") }}

Params:
  - existingSecret - ExistingSecret/String - Optional. The path to the existing secrets in the values_.yaml given by the user
    to be used instead of the default one. Allows for it to be of type String (just the secret name) for backwards compatibility.
    +info: https://github.com/bitnami/charts/tree/master/bitnami/common#existingsecret
  - key - String - Required. Name of the key in the secret.
*/}}
{{- define "common.secrets.key" -}}
{{- $key := .key -}}

{{- if .existingSecret -}}
  {{- if not (typeIs "string" .existingSecret) -}}
    {{- if .existingSecret.keyMapping -}}
      {{- $key = index .existingSecret.keyMapping $.key -}}
    {{- end -}}
  {{- end }}
{{- end -}}

{{- printf "%s" $key -}}
{{- end -}}

{{/*
Generate secret password or retrieve one if already created.

Usage:
{{ include "common.secrets.passwords.manage" (dict "secret" "secret-name" "key" "keyName" "providedValues" (list "path.to.password1" "path.to.password2") "length" 10 "strong" false "chartName" "chartName" "context" $) }}

Params:
  - secret - String - Required - Name of the 'Secret' resource where the password is stored.
  - key - String - Required - Name of the key in the secret.
  - providedValues - List<String> - Required - The path to the validating value in the values_.yaml, e.g: "mysql.password". Will pick first parameter with a defined value.
  - length - int - Optional - Length of the generated random password.
  - strong - Boolean - Optional - Whether to add symbols to the generated random password.
  - chartName - String - Optional - Name of the chart used when said chart is deployed as a subchart.
  - context - Context - Required - Parent context.

The order in which this function returns a secret password:
  1. Already existing 'Secret' resource
     (If a 'Secret' resource is found under the name provided to the 'secret' parameter to this function and that 'Secret' resource contains a key with the name passed as the 'key' parameter to this function then the value of this existing secret password will be returned)
  2. Password provided via the values_.yaml
     (If one of the keys passed to the 'providedValues' parameter to this function is a valid path to a key in the values_.yaml and has a value, the value of the first key with a value will be returned)
  3. Randomly generated secret password
     (A new random secret password with the length specified in the 'length' parameter will be generated and returned)

*/}}
{{- define "common.secrets.passwords.manage" -}}

{{- $password := "" }}
{{- $subchart := "" }}
{{- $chartName := default "" .chartName }}
{{- $passwordLength := default 10 .length }}
{{- $providedPasswordKey := include "common.utils.getKeyFromList" (dict "keys" .providedValues "context" $.context) }}
{{- $providedPasswordValue := include "common.utils.getValueFromKey" (dict "key" $providedPasswordKey "context" $.context) }}
{{- $secretData := (lookup "v1" "Secret" $.context.Release.Namespace .secret).data }}
{{- if and ($secretData) (hasKey $secretData .key) }}
  {{- $password = index $secretData .key }}
{{- else if $providedPasswordValue }}
  {{- $password = $providedPasswordValue | toString | b64enc }}
{{- else }}

  {{- if .context.Values.enabled }}
    {{- $subchart = $chartName }}
  {{- end -}}

  {{- $requiredPassword := dict "valueKey" $providedPasswordKey "secret" .secret "field" .key "subchart" $subchart "context" $.context -}}
  {{- $requiredPasswordError := include "common.validations.values.single.empty" $requiredPassword -}}
  {{- $passwordValidationErrors := list $requiredPasswordError -}}
  {{- if hasKey $secretData .key }}
    {{- include "common.errors.upgrade.passwords.empty" (dict "validationErrors" $passwordValidationErrors "context" $.context) -}}
  {{- end -}}

  {{- if .strong }}
    {{- $subStr := list (lower (randAlpha 1)) (randNumeric 1) (upper (randAlpha 1)) | join "_" }}
    {{- $password = randAscii $passwordLength }}
    {{- $password = regexReplaceAllLiteral "\\W" $password "@" | substr 5 $passwordLength }}
    {{- $password = printf "%s%s" $subStr $password | toString | shuffle | b64enc }}
  {{- else }}
    {{- $password = randAlphaNum $passwordLength | b64enc }}
  {{- end }}
{{- end -}}
{{- printf "%s" $password -}}
{{- end -}}

{{/*
Returns whether a previous generated secret already exists

Usage:
{{ include "common.secrets.exists" (dict "secret" "secret-name" "context" $) }}

Params:
  - secret - String - Required - Name of the 'Secret' resource where the password is stored.
  - context - Context - Required - Parent context.
*/}}
{{- define "common.secrets.exists" -}}
{{- $secret := (lookup "v1" "Secret" $.context.Release.Namespace .secret) }}
{{- if $secret }}
  {{- true -}}
{{- end -}}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Print instructions to get a secret value.
Usage:
{{ include "common.utils.secret.getvalue" (dict "secret" "secret-name" "field" "secret-value-field" "context" $) }}
*/}}
{{- define "common.utils.secret.getvalue" -}}
{{- $varname := include "common.utils.fieldToEnvVar" . -}}
export {{ $varname }}=$(kubectl get secret --namespace {{ .context.Release.Namespace | quote }} {{ .secret }} -o jsonpath="{.data.{{ .field }}}" | base64 --decode)
{{- end -}}

{{/*
Build env var name given a field
Usage:
{{ include "common.utils.fieldToEnvVar" dict "field" "my-password" }}
*/}}
{{- define "common.utils.fieldToEnvVar" -}}
  {{- $fieldNameSplit := splitList "-" .field -}}
  {{- $upperCaseFieldNameSplit := list -}}

  {{- range $fieldNameSplit -}}
    {{- $upperCaseFieldNameSplit = append $upperCaseFieldNameSplit ( upper . ) -}}
  {{- end -}}

  {{ join "_" $upperCaseFieldNameSplit }}
{{- end -}}

{{/*
Gets a value from .Values given
Usage:
{{ include "common.utils.getValueFromKey" (dict "key" "path.to.key" "context" $) }}
*/}}
{{- define "common.utils.getValueFromKey" -}}
{{- $splitKey := splitList "." .key -}}
{{- $value := "" -}}
{{- $latestObj := $.context.Values -}}
{{- range $splitKey -}}
  {{- if not $latestObj -}}
    {{- printf "please review the entire path of '%s' exists in values" $.key | fail -}}
  {{- end -}}
  {{- $value = ( index $latestObj . ) -}}
  {{- $latestObj = $value -}}
{{- end -}}
{{- printf "%v" (default "" $value) -}}
{{- end -}}

{{/*
Returns first .Values key with a defined value or first of the list if all non-defined
Usage:
{{ include "common.utils.getKeyFromList" (dict "keys" (list "path.to.key1" "path.to.key2") "context" $) }}
*/}}
{{- define "common.utils.getKeyFromList" -}}
{{- $key := first .keys -}}
{{- $reverseKeys := reverse .keys }}
{{- range $reverseKeys }}
  {{- $value := include "common.utils.getValueFromKey" (dict "key" . "context" $.context ) }}
  {{- if $value -}}
    {{- $key = . }}
  {{- end -}}
{{- end -}}
{{- printf "%s" $key -}}
{{- end -}}


{{- define "common.validations.values.single.empty" -}}
  {{- $value := include "common.utils.getValueFromKey" (dict "key" .valueKey "context" .context) }}
  {{- $subchart := ternary "" (printf "%s." .subchart) (empty .subchart) }}

  {{- if not $value -}}
    {{- $varname := "my-value" -}}
    {{- $getCurrentValue := "" -}}
    {{- if and .secret .field -}}
      {{- $varname = include "common.utils.fieldToEnvVar" . -}}
      {{- $getCurrentValue = printf " To get the current value:\n\n        %s\n" (include "common.utils.secret.getvalue" .) -}}
    {{- end -}}
    {{- printf "\n    '%s' must not be empty, please add '--set %s%s=$%s' to the command.%s" .valueKey $subchart .valueKey $varname $getCurrentValue -}}
  {{- end -}}
{{- end -}}

{{- define "common.errors.upgrade.passwords.empty" -}}
  {{- $validationErrors := join "" .validationErrors -}}
  {{- if and $validationErrors .context.Release.IsUpgrade -}}
    {{- $errorString := "\nPASSWORDS ERROR: You must provide your current passwords when upgrading the release." -}}
    {{- $errorString = print $errorString "\n                 Note that even after reinstallation, old credentials may be needed as they may be kept in persistent volume claims." -}}
    {{- $errorString = print $errorString "\n                 Further information can be obtained at https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues/#credential-errors-while-upgrading-chart-releases" -}}
    {{- $errorString = print $errorString "\n%s" -}}
    {{- printf $errorString $validationErrors | fail -}}
  {{- end -}}
{{- end -}}

{{/*
Function to get full image names from a pipeline manifest
*/}}

{{- define "secrets.image.name" -}}
{{- range .globals }}
{{- if eq .image $.name -}}
{{ .repository | default $.repo}}{{ .project }}{{ .image }}:{{ .version }}
{{- end }}
{{- end }}
{{- end }}

{{- define "secrets.kubectl.image.name" -}}
{{- include "secrets.image.name" (dict "name" "kubectl" "globals" .Values.global.components "repo" .Values.global.repository) -}}
{{- end -}}

{{- define "helper.vault.image.name" -}}
{{- range .globals }}
{{- if eq .image $.name }}
- image: "{{ .repository | default $.repo }}{{ .project }}{{ .image }}:{{ .version }}"
{{- end }}
{{- end }}
{{- end }}

{{- define "logLevel.configMap.volume" }}
{{- if .Values.global.logLevel}}
{{- if and .Values.global.logLevel.enabled .Values.global.logLevel.configMap }}
- name: log-level-configmap-volume
  configMap:
    name: {{ .Values.global.logLevel.configMap.name }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "logLevel.configMap.mount" }}
{{- if .Values.global.logLevel}}
{{- if and .Values.global.logLevel.enabled .Values.global.logLevel.configMap }}
- name: log-level-configmap-volume
  mountPath: {{ .Values.global.logLevel.configMap.mountDir }}
  readOnly: true
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "FetchFqdnHistoryFromSecret" }}
{{- $secretName := "fqdn-history-secret" }}
{{- $oldSecret := lookup "v1" "Secret" $.namespace $secretName }}
{{- $fqdnHistoryList := "" }}
  {{- if and ($oldSecret) ($oldSecret.data) }}
  {{- $fqdnHistoryList = ($oldSecret.data.history | b64dec) }}
  {{- end }}
{{- $fqdnHistoryList }}
{{- end }}

{{- define "GetFqdnHistoryList" -}}
{{- $historyList := (include "FetchFqdnHistoryFromSecret" (dict "namespace" $.namespace)) }}
{{- $historyListLen := len $historyList }}
{{- $historyList = splitList "," $historyList }}
{{- $resultList := list }}
{{- $fqdn := ($.fqdn | toString) }}
{{- if le $historyListLen 0 }}
  {{- $resultList = append $resultList $fqdn }}
{{- else }}
  {{- $resultList = $historyList }}
  {{- $lastIndex := sub (len $historyList) 1 }}
  {{- $lastElem := index $historyList $lastIndex }}
  {{- if ne $fqdn $lastElem -}}
    {{- $resultList = append $resultList $fqdn }}
  {{- end }}
{{- end }}
{{- join "," $resultList }}
{{- end }}

{{- define "isFQDN" -}}
{{- $value := . -}}
{{- $length := (len $value) }}
{{- if and (lt $length 254) (regexMatch "^([a-zA-Z0-9-]{1,63}\\.)+[a-zA-Z]{2,63}$" $value) -}}
true
{{- else -}}
false
{{- end -}}
{{- end -}}

{{- define "GetMTLSHost" -}}
  {{- $fqdnHistory := (include "GetFqdnHistoryList" (dict "fqdn" $.fqdn "namespace" $.namespace)) }}
  {{- $fqdnHistoryList := splitList "," ($fqdnHistory | trim) }}
  {{- $lastIndex := sub (len $fqdnHistoryList) 1 }}
  {{- $lastFQDN := index $fqdnHistoryList $lastIndex | trim -}}

  {{- $customHost := printf "%s%s" $.prefix $lastFQDN }}
  {{- if (empty $lastFQDN) -}}
    {{- $customHost = printf "%s%s" $.prefix $.fqdn -}}
  {{- end -}}

  {{- $defaultHost := printf "%s"  (join "," $.default) }}
  {{- $lastHost := "" -}}
  {{- if eq (include "isFQDN" $lastFQDN) "true" -}}
    {{ $customHost }}
  {{- else -}}
    {{ $defaultHost }}
  {{- end -}}
{{- end -}}


{{/* Return the proper imagePullSecrets */}}
{{- define "images.pullSecrets" -}}
{{- if (.Values.global).imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Return nodeSelector for pod (specified for microservice or global)
{{ include "pods.nodeSelector" ( list .Values.path.to.microservice.section $ ) }}
*/}}
{{- define "pods.nodeSelector" -}}
{{- $msRoot := index . 0 -}}
{{- $ := index . 1 -}}
{{- if hasKey $msRoot "nodeSelector" -}}
    {{- $msRoot.nodeSelector | toYaml | nindent 0  -}}
{{- else if hasKey $.Values.global "nodeSelector" -}}
    {{- $.Values.global.nodeSelector | toYaml | nindent 0 -}}
{{- end -}}
{{- end -}}

{{/*
Return tolerations for pod (specified for microservice or global)
{{ include "pods.tolerations" ( list .Values.path.to.microservice.section $ ) }}
*/}}
{{- define "pods.tolerations" -}}
{{- $msRoot := index . 0 -}}
{{- $ := index . 1 -}}
{{- if hasKey $msRoot "tolerations" -}}
    {{- $msRoot.tolerations | toYaml | nindent 0 -}}
{{- else if hasKey $.Values.global "tolerations" -}}
    {{- $.Values.global.tolerations | toYaml | nindent 0 -}}
{{- end -}}
{{- end -}}

{{/*
Return affinity for pod (merged global and specified for microservice)
{{ include "pods.affinity" ( list .Values.path.to.microservice.section $ ) }}
*/}}
{{- define "pods.affinity" -}}
{{- $msRoot := index . 0 -}}
{{- $ := index . 1 -}}
{{- if and $.Values.global.affinity $msRoot.affinity -}}
  {{- merge $.Values.global.affinity $msRoot.affinity | toYaml | nindent 0 -}}
{{- else if and (not $.Values.global.affinity) $msRoot.affinity -}}
  {{- $msRoot.affinity | toYaml | nindent 0 -}}
{{- else if and $.Values.global.affinity (not $msRoot.affinity) -}}
  {{- $.Values.global.affinity | toYaml | nindent 0 -}}
{{- end -}}
{{- end -}}