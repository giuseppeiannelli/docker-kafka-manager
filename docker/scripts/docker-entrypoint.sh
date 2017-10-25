#/bin/sh

set -e
if [ "${1#-}" != "$1" ]
then
  echo "[INFO] Set value into /kafka-manager-${KM_VERSION}/conf/application.conf"

  echo "kafka-manager.offset-cache-thread-pool-size=$((2+nproc))"  >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.offset-cache-thread-pool-size=$((10+nproc))"  >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.kafka-admin-client-thread-pool-size=$((2+nproc))" >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.logkafka-update-period-seconds=$((10+nproc))" >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.broker-view-thread-pool-size=$(( ${KAFKA_NUMBER_OF_BROKERS} * 3))" >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.broker-view-thread-pool-size=$(( ${KAFKA_NUMBER_OF_BROKERS} * 3))" >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.broker-view-max-queue-size=$(( ${KAFKA_TOTAL_PARTITIONS_NUMBER} * ${KAFKA_NUMBER_OF_BROKERS} ))" >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.broker-view-update-seconds=$(( ${KAFKA_TOTAL_PARTITIONS_NUMBER} * ${KAFKA_NUMBER_OF_BROKERS} / 10 * ${KAFKA_NUMBER_OF_BROKERS} ))" >> /kafka-manager-${KM_VERSION}/conf/application.conf

  if [ ! -z $KM_USERNAME ] && [ ! -z $KM_PASSWORD ]; then
    sed -i.bak '/^basicAuthentication/d' /kafka-manager-${KM_VERSION}/conf/application.conf
    echo 'basicAuthentication.enabled=true' >> /kafka-manager-${KM_VERSION}/conf/application.conf
    echo "basicAuthentication.username=${KM_USERNAME}" >> /kafka-manager-${KM_VERSION}/conf/application.conf
    echo "basicAuthentication.password=${KM_PASSWORD}" >> /kafka-manager-${KM_VERSION}/conf/application.conf
    echo 'basicAuthentication.realm="Kafka-Manager"' >> /kafka-manager-${KM_VERSION}/conf/application.conf
  fi

  echo "[INFO] Start kafka-manager"
  /kafka-manager-${KM_VERSION}/bin/kafka-manager -Dconfig.file=/kafka-manager-${KM_VERSION}/conf/application.conf $@
else
  $@
fi