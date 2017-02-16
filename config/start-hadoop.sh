#!/bin/bash

echo -e "Starting dfs \n"

$HADOOP_HOME/sbin/start-dfs.sh

echo -e "Starting yarn\n"

$HADOOP_HOME/sbin/start-yarn.sh

echo -e "hadoop is started.\n"
