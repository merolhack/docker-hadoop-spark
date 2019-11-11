FROM openjdk:8-alpine

ARG SPARK_VERSION=2.4.4
ARG HADOOP_VERSION=2.7

COPY start-master.sh /start-master.sh
COPY start-worker.sh /start-worker.sh

RUN echo "* Installing Spark version: ${SPARK_VERSION}"
RUN echo "* Installing Hadoop version: ${HADOOP_VERSION}"

RUN apk --update add wget tar bash
RUN wget http://apache.mirror.anlx.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

RUN chmod +x /start-master.sh
RUN chmod +x /start-worker.sh

WORKDIR /spark
