#!/bin/bash

echo -e "Start all for spark\n"

$SPARK_HOME/sbin/start-all.sh

echo -e "Start history server for spark\n"

$SPARK_HOME/sbin/start-history-server.sh

echo -e "Spark is started.\n"

