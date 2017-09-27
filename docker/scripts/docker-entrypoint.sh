#/bin/sh

set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then

  echo "kafka-manager.offset-cache-thread-pool-size=$(nproc)"  >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.kafka-admin-client-thread-pool-size$(nproc)"  >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.broker-view-thread-pool-size=3" >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.broker-view-max-queue-size=50" >> /kafka-manager-${KM_VERSION}/conf/application.conf
  echo "kafka-manager.broker-view-update-seconds=3" >> /kafka-manager-${KM_VERSION}/conf/application.conf


  if [ ! -z $KM_USERNAME ] && [ ! -z $KM_PASSWORD ]; then
      sed -i.bak '/^basicAuthentication/d' /kafka-manager-${KM_VERSION}/conf/application.conf
      echo 'basicAuthentication.enabled=true' >> /kafka-manager-${KM_VERSION}/conf/application.conf
      echo "basicAuthentication.username=${KM_USERNAME}" >> /kafka-manager-${KM_VERSION}/conf/application.conf
      echo "basicAuthentication.password=${KM_PASSWORD}" >> /kafka-manager-${KM_VERSION}/conf/application.conf
      echo 'basicAuthentication.realm="Kafka-Manager"' >> /kafka-manager-${KM_VERSION}/conf/application.conf
  fi


  /kafka-manager-${KM_VERSION}/bin/kafka-manager -Dconfig.file=/kafka-manager-${KM_VERSION}/application.conf $@
else

	exec "$@"

fi
