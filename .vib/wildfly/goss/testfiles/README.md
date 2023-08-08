# How to update this folder

* Build the helloworld.war file by executing these commands

```bash
cd .vib/wildfly/goss/testfiles
docker run --rm --entrypoint=/bin/bash -v .:/app bitnami/java:11 /app/helloworld.sh WILDFLY_VERSION
```
