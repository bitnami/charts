helm install orangehrm bitnami/orangehrm --version 8.0.0 --set service.type=ClusterIP --set orangehrmPassword=Bitnami.12345 --set image.tag=4.3.4-0-debian-10-r30

export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default orangehrm-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default orangehrm-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
helm upgrade orangehrm . --set service.type=ClusterIP --set orangehrmPassword=Bitnami.12345 --set image.tag=dev --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD

helm upgrade orangehrm . --set service.type=ClusterIP --set orangehrmPassword=Bitnami.12345 --set image.tag=dev --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set volumePermissions.enabled=true
