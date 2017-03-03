#!/bin/bash

echo -e "Starting zookeeper on hadoop-slave1 \n"

ssh -t root@hadoop-slave1 "$ZOOKEEPER_HOME/bin/zkServer.sh start"

echo -e "Starting zookeeper on hadoop-slave2 \n"
ssh -t root@hadoop-slave2 "$ZOOKEEPER_HOME/bin/zkServer.sh start"


echo -e " To test connectiont to zookeeper $ZOOKEEPER_HOME/bin/zkCli.sh -server hadoop-slave1:2181"


