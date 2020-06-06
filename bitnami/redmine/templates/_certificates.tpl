{{/* Templates for certificates injection */}}

{{- define "certificates.initContainer" -}}
{{- if .Values.certificates.customCAs }}
- name: certificates
  image: "{{ .Values.certificates.image.repository }}:{{ .Values.certificates.image.tag }}"
  imagePullPolicy: {{ default .Values.image.pullPolicy .Values.certificates.image.pullPolicy }}
  imagePullSecrets:
  {{- range (default .Values.image.pullSecrets .Values.certificates.image.pullSecrets) }}
    - name: {{ . }}
  {{- end }}
  command:
  - sh
  - -c
  - apk add --no-cache ca-certificates openssl && update-ca-certificates \\
    && openssl req -new -x509 -days 3650 -nodes -sha256
       -subj "/CN=$(hostname)" -addext "subjectAltName = DNS:$(hostname)"
       -out  /etc/ssl/certs/ssl-cert-snakeoil.pem
       -keyout /etc/ssl/private/ssl-cert-snakeoil.key -extensions v3_req
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
{{- end -}}

{{- define "certificates.volumeMount" -}}
{{- if .Values.certificates.customCAs }}
- name: etc-ssl-certs
  mountPath: /etc/ssl/certs/
  readOnly: true
- name: etc-ssl-private
  mountPath: /etc/ssl/private/
  readOnly: true
- name: custom-ca-certificates
  mountPath: /usr/local/share/ca-certificates
  readOnly: true
{{- end -}}
{{- end -}}
