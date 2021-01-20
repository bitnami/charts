#!/bin/sh

GIT_ROOT="$(git rev-parse --show-toplevel)"

# shellcheck source=../../.env
. "${GIT_ROOT}/.env"

mkdir -p "${GIT_ROOT}/src/test/resources/import-files/exported-realm/${KEYCLOAK_VERSION}/"
touch "${GIT_ROOT}/src/test/resources/import-files/exported-realm/${KEYCLOAK_VERSION}/master-realm.json"

docker run --rm -ti \
  -v "${GIT_ROOT}/src/test/resources/import-files/exported-realm/${KEYCLOAK_VERSION}/:/tmp/export/" \
  -e KEYCLOAK_USER=admin \
  -e KEYCLOAK_PASSWORD=admin123 \
  "jboss/keycloak:${KEYCLOAK_VERSION}" \
  -Dkeycloak.migration.action=export \
  -Dkeycloak.migration.provider=dir \
  -Dkeycloak.migration.dir=/tmp/export \
  -Dkeycloak.migration.usersExportStrategy=REALM_FILE
