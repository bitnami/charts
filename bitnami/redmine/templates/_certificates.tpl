{{/* Templates for certificates injection */}}

{{/*
Return the proper Redmine image name
*/}}
{{- define "certificates.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.certificates.image "global" .Values.global) }}
{{- end -}}

{{- define "certificates.initContainer" -}}
{{- if .Values.certificates.customCAs }}
- name: certificates
  image: {{ template "certificates.image" . }}
  imagePullPolicy: {{ default .Values.image.pullPolicy .Values.certificates.image.pullPolicy }}
  imagePullSecrets:
  {{- range (default .Values.image.pullSecrets .Values.certificates.image.pullSecrets) }}
    - name: {{ . }}
  {{- end }}
  command:
  {{- if .Values.certificates.customCertificate.certificateSecret }}
  - sh
  - -c
  - install_packages ca-certificates openssl
  {{- else }}
  - sh
  - -c
  - install_packages ca-certificates openssl
    && openssl req -new -x509 -days 3650 -nodes -sha256
       -subj "/CN=$(hostname)" -addext "subjectAltName = DNS:$(hostname)"
       -out  /etc/ssl/certs/ssl-cert-snakeoil.pem
       -keyout /etc/ssl/private/ssl-cert-snakeoil.key -extensions v3_req
  {{- end }}
  {{- if .Values.certificates.extraEnvVars }}
  env:
  {{- tpl (toYaml .Values.certificates.extraEnvVars) $ | nindent 2 }}
  {{- end }}
  volumeMounts:
    - name: etc-ssl-certs
      mountPath: /etc/ssl/certs
      readOnly: false
    - name: etc-ssl-private
      mountPath: /etc/ssl/private
      readOnly: false
    - name: custom-ca-certificates
      mountPath: /usr/local/share/ca-certificates
      readOnly: true
{{- end }}
{{- end }}

{{- define "certificates.volumes" -}}
{{- if .Values.certificates.customCAs }}
- name: etc-ssl-certs
  emptyDir:
    medium: "Memory"
- name: etc-ssl-private
  emptyDir:
    medium: "Memory"
- name: custom-ca-certificates
  projected:
    defaultMode: 0400
    sources:
    {{- range $index, $customCA := .Values.certificates.customCAs }}
    - secret:
        name: {{ $customCA.secret }}
        # items not specified, will mount all keys
    {{- end }}
{{- end -}}
{{- if .Values.certificates.customCertificate.certificateSecret }}
- name: custom-certificate
  secret:
    secretName: {{ .Values.certificates.customCertificate.certificateSecret }}
{{- if .Values.certificates.customCertificate.chainSecret }}
- name: custom-certificate-chain
  secret:
    secretName: {{ .Values.certificates.customCertificate.chainSecret.name }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "certificates.volumeMount" -}}
{{- if .Values.certificates.customCAs }}
- name: etc-ssl-certs
  mountPath: /etc/ssl/certs/
  readOnly: false
- name: etc-ssl-private
  mountPath: /etc/ssl/private/
  readOnly: false
- name: custom-ca-certificates
  mountPath: /usr/local/share/ca-certificates
  readOnly: true
{{- end -}}
{{- if .Values.certificates.customCertificate.certificateSecret }}
- name: custom-certificate
  mountPath: {{ .Values.certificates.customCertificate.certificateLocation }}
  subPath: tls.crt
  readOnly: true
- name: custom-certificate
  mountPath: {{ .Values.certificates.customCertificate.keyLocation }}
  subPath: tls.key
  readOnly: true
{{- if .Values.certificates.customCertificate.chainSecret }}
- name: custom-certificate-chain
  mountPath: {{ .Values.certificates.customCertificate.chainLocation }}
  subPath: {{ .Values.certificates.customCertificate.chainSecret.key }}
  readOnly: true
{{- end }}
{{- end -}}
{{- end -}}
