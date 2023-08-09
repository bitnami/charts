#!/bin/bash
#
# Script to help you generate the helloworld.war file using the bitnami/java:11 docker image
#
MAVEN_VERSION=3.8.6
APP_VERSION=${1:-}
if [ -z "${APP_VERSION}" ]; then
    echo "Usage: $(basename "$0") APP_VERSION"
    exit 1
fi

cd /opt/bitnami
install_packages curl ca-certificates
curl -L "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" -o /opt/bitnami/maven.tar.gz
tar -xzf /opt/bitnami/maven.tar.gz
export PATH="/opt/bitnami/apache-maven-${MAVEN_VERSION}/bin:$PATH"
curl -L "https://github.com/wildfly/quickstart/archive/refs/tags/${APP_VERSION}.Final.tar.gz" -o /opt/bitnami/wildfly-quickstart.tar.gz
tar -xzf /opt/bitnami/wildfly-quickstart.tar.gz
cd /opt/bitnami/quickstart-${APP_VERSION}.Final/helloworld
mvn clean package
cp "/opt/bitnami/quickstart-${APP_VERSION}.Final/helloworld/target/helloworld.war" "/app/helloworld.war"
