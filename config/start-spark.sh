#!/bin/bash
echo -e "Creating yarn archive from spark"

# jar cv0f spark-archive.zip -c $SPARK_HOME/jars/.

# hadoop fs -mkdir -p /user/root

# hadoop fs -copyFromLocal -f spark-archive.zip

# rm -rf spark-archive.zip

hadoop fs -mkdir -p /user/root/sparkjars

hadoop fs -copyFromLocal -f $SPARK_HOME/jars/* /user/root/sparkjars

echo -e "Start all for spark\n"

$SPARK_HOME/sbin/start-all.sh

echo -e "Start history server for spark\n"

$SPARK_HOME/sbin/start-history-server.sh

echo -e "Spark is started.\n"

