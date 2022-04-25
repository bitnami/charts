puzzle run goss \
  -p resources.url=file:///Users/alukic/Documents/Code/charts/.vib/keycloak/ \
  -p config.remote.host=keycloak-0  \
  -p config.remote.namespace=default \
  -p config.remote.credentials=$(cat ~/.kube/config | base64)


