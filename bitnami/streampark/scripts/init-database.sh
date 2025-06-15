#!/bin/sh

{{- if or .Values.postgresql.enabled (eq .Values.externalDatabase.type "pgsql") }}
DB_PORT={{ ternary "5432" (default 5432 .Values.externalDatabase.port) .Values.postgresql.enabled | quote }}
export PGPASSWORD=$DATASOURCE_PASSWORD
psql -h $DATASOURCE_HOST -p $DB_PORT -U $DATASOURCE_USERNAME -d streampark -f /tmp/init.sql
{{- else if or .Values.mysql.enabled (eq .Values.externalDatabase.type "mysql") }}
DB_PORT={{ ternary "3306" (default 3306 .Values.externalDatabase.port) .Values.mysql.enabled | quote }}
mysql --host=$DATASOURCE_HOST --port=$DB_PORT --user=$DATASOURCE_USERNAME --password=$DATASOURCE_PASSWORD streampark  < /tmp/init.sql
{{- else }}
echo "INFO: There is no any database should be initialized."
{{- end }}
