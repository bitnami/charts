#!/bin/sh

{{- if or .Values.postgresql.enabled (eq .Values.externalDatabase.type "pgsql") }}
DB_PORT={{ ternary "5432" (default 5432 .Values.externalDatabase.port) .Values.postgresql.enabled | quote }}
{{- else if or .Values.mysql.enabled (eq .Values.externalDatabase.type "mysql") }}
DB_PORT={{ ternary "3306" (default 3306 .Values.externalDatabase.port) .Values.mysql.enabled | quote }}
{{- end }}

database_isready() {
  if [ "$DATASOURCE_DIALECT" = "pgsql" ]; then
    pg_isready --host=$DATASOURCE_HOST --port=$DB_PORT --username=$DATASOURCE_USERNAME --quiet
  elif [ "$DATASOURCE_DIALECT" = "mysql" ]; then
    mysqladmin ping --host=$DATASOURCE_HOST --port=$DB_PORT --user=$DATASOURCE_USERNAME --silent
  else
    echo "ERROR: DATASOURCE_DIALECT is neither pgsql nor mysql. Please confirm the variable."
    exit 1
  fi
  
  if [ $? -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

c=1
while [ "$c" -le 6 ]; do
  if database_isready; then
    echo "INFO: Database is ready. End of init container"
    break
  else
    if [ "$c" -eq 6 ]; then
      echo "ERROR: Database is still not ready for 5 times retry. Suspend following progress."
      exit 1
    else
      echo "WARNING: Database is not ready. Retry in $((30 + 5 * $c)) seconds."
      sleep $((30 + 5 * $c))
    fi
  fi
  c=$((c+1))
done