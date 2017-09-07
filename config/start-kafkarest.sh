#!/bin/bash

echo -e "Starting kafka rest schema-registry on hadoop-slave2 \n"

ssh -f root@hadoop-slave2 "sh -c 'nohup $KAFKAREST_HOME/bin/schema-registry-start $KAFKAREST_HOME/etc/schema-registry/schema-registry.properties > schema-registry-console.out 2>shcema-registry-console.err </dev/null &'"

echo -e "Starting kafka-rest on hadoop-master  \n"
ssh -f root@hadoop-master "sh -c 'nohup $KAFKAREST_HOME/bin/kafka-rest-start $KAFKAREST_HOME/etc/kafka-rest/kafka-rest.properties > kafka-rest-console.out 2>kafka-rest-console.err </dev/null &'"


echo -e " To test kafka rest proxy , post data to hadoop-master:18082"
