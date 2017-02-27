#!/bin/bash

echo -e "Starting dfs \n"

$HADOOP_HOME/sbin/start-dfs.sh

echo -e "Starting yarn\n"

$HADOOP_HOME/sbin/start-yarn.sh

echo -e "hadoop is started.\n"

echo -e "Starting job server on hadoop-slave2 \n"

ssh -t root@hadoop-slave2 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"

