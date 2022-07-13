puzzle run goss \
  -p resources.url=file:///Users/alukic/Documents/Code/charts/.vib/odoo \
  -p config.remote.host=odoo-85cf6bc6f8-8hvtg  \
  -p config.remote.namespace=default \
  -p config.remote.credentials=$(cat ~/.kube/config | base64)
