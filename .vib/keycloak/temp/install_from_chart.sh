#!/bin/sh

#UPDATE
helm repo update

#INSTALL
helm install keycloak -f chart-values.yaml bitnami/keycloak


