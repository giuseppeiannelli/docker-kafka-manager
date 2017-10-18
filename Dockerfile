FROM java:8u111-jdk

ENV KM_VERSION=1.3.3.14
ENV KM_USERNAME admin
ENV KM_PASSWORD password
ENV ZK_HOSTS zookeeper:2181
ENV KAFKA_NUMBER_OF_BROKERS 1
ENV KAFKA_TOTAL_PARTITIONS_NUMBER 1000

WORKDIR /tmp

RUN curl https://codeload.github.com/yahoo/kafka-manager/tar.gz/${KM_VERSION} > kafka-manager-${KM_VERSION}.tar.gz

RUN tar xzf kafka-manager-${KM_VERSION}.tar.gz

WORKDIR /tmp/kafka-manager-${KM_VERSION}

RUN ./sbt clean dist

RUN unzip -d / ./target/universal/kafka-manager-${KM_VERSION}.zip

RUN rm -rf /tmp/* /root/.sbt /root/.ivy2 /var/lib/apt/lists/*

COPY docker/scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 9000

WORKDIR /kafka-manager-${KM_VERSION}

ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]
CMD ["-Dhttp.port=9000"]