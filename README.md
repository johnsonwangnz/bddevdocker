# bddevdocker

This is big data development docker image.

Following applications are installed:
Hadoop, hbase, hive,pig,and spark

It has three nodes:

##hadoop-master
ResourceManager, NameNode, SecondaryNamenode, HMaster(HBase), HQuorumPeer(HBase), Master(spark), Worker(spark)

##hadoop-slave1
DataNode, HQuorumPeer(HBase), HRegionServer(HBase), NetworkServerControl(derby server for Hive meta store), Worker(spark)

##hadoop-slave2
DataNode, HQuorumPeer(HBase), HRegionServer(HBase), JobHistoryServer(Hadoop), worker(spark) 


# To start all docker containers
sudo docker-compose up -d

# To log into bash
sudo docker exec -it hadoop-master

# To start hadoop
./start-hadoop.sh

# To start hbase
./start-hbase.sh

# To use hbase
$HBASE_HOME/bin/hbase

# To install hive
./install-hive.sh
This only need to be run once when first time you initialize hive meta store

# To use hive 
$HIVE_HOME/bin/hive

# To use pig
$PIG_HOME/bin/pig

# To start spark
./start-spark.sh

# To use pyspark  
$SPARK_HOME/bin/pyspark --master spark://hadoop-master:7077

# Mounted volume:
~/shared ==> /data on host
 
