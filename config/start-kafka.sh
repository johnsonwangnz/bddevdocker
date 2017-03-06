#!/bin/bash

echo -e "Starting kafka broker on hadoop-slave1 \n"

ssh -f root@hadoop-slave1 "sh -c 'nohup $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server-1.properties > kafka-console.out 2>kafka-console.err </dev/null &'"

echo -e "Starting kafka broker on hadoop-slave2 \n"
ssh -f root@hadoop-slave2 "sh -c 'nohup $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server-2.properties > kafka-console.out 2>kafka-console.err </dev/null &'"


echo -e " To test bin/kafka-console-producer.sh --broker-list localhost:9092 --topic telemetry-replicated"


