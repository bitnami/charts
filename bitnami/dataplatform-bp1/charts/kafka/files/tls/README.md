# TLS certificates

You can copy here your JKS or PEM certificates.

Find more info in [this section](https://github.com/bitnami/charts/tree/master/bitnami/kafka#enable-security-for-kafka-and-zookeeper) of the README.md file.

## Java Key Stores

You can copy here your Java Key Stores (JKS) files so a secret is created including them. Remember to use a truststore (`kafka.truststore.jks`) and one keystore (`kafka.keystore.jks`) per Kafka broker you have in the cluster. For instance, if you have 3 brokers you need to copy here the following files:

- kafka.truststore.jks
- kafka-0.keystore.jks
- kafka-1.keystore.jks
- kafka-2.keystore.jks

## PEM certificates

You can copy here your PEM certificates so a secret is created including them. Remember to use a CA (`kafka.truststore.pem`) and one certificate (`kafka.keystore.pem`) and key (`kafka.keystore.key`) per Kafka broker you have in the cluster. For instance, if you have 3 brokers you need to copy here the following files:

- kafka.truststore.pem
- kafka-0.keystore.pem
- kafka-0.keystore.key
- kafka-1.keystore.pem
- kafka-1.keystore.key
- kafka-2.keystore.pem
- kafka-2.keystore.key
