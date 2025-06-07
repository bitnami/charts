FROM busybox:latest as busybox
WORKDIR /
RUN mkdir /mysql-connector \
 && wget -O mysql-connector.tar.gz https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-9.3.0.tar.gz \
 && tar -zxvf mysql-connector.tar.gz -C /mysql-connector --strip-components=1

FROM apache/flink:1.17.2 as flink-1.17
FROM apache/flink:1.18.1 as flink-1.18
FROM apache/flink:1.19.1 as flink-1.19

FROM apache/streampark:2.1.5
COPY --from=busybox /mysql-connector/mysql-*.jar /streampark/lib
COPY --from=flink-1.17 /opt/flink /streampark/flink-1.17
COPY --from=flink-1.18 /opt/flink /streampark/flink-1.18
COPY --from=flink-1.19 /opt/flink /streampark/flink-1.19
