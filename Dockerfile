FROM ubuntu:14.04

MAINTAINER Johnson Wang <johnsonwangnz@gmail.com>

WORKDIR /root

# set environment variable
ENV TZ=Pacific/Auckland
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV ZOOKEEPER_HOME=/usr/local/zookeeper
ENV HBASE_HOME=/usr/local/hbase
ENV SPARK_HOME=/usr/local/spark
ENV HIVE_HOME=/usr/local/hive
ENV DERBY_HOME=/usr/local/derby
ENV PIG_HOME=/usr/local/pig
ENV KAFKA_HOME=/usr/local/kafka
ENV ZEPPELIN_HOME=/usr/local/zeppelin
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin

#set the timezone
RUN echo $TZ | tee /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata


#install openssh-server, openjdk-7-jdk wget
RUN apt-get update && apt-get install -y openssh-server openjdk-7-jdk wget

# install hadoop 2.7.3
RUN wget http://www-eu.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz && \
    tar -xzvf hadoop-2.7.3.tar.gz && \
    mv hadoop-2.7.3 /usr/local/hadoop && \
    rm hadoop-2.7.3.tar.gz

# install zookeeper 3.4.9
RUN wget http://www-eu.apache.org/dist/zookeeper/stable/zookeeper-3.4.9.tar.gz && \
    tar -xzvf zookeeper-3.4.9.tar.gz && \
    mv zookeeper-3.4.9 /usr/local/zookeeper && \
    rm zookeeper-3.4.9.tar.gz


# install hbase 1.2.4
RUN wget http://www-eu.apache.org/dist/hbase/1.2.4/hbase-1.2.4-bin.tar.gz && \
    tar -xzvf  hbase-1.2.4-bin.tar.gz && \
    mv hbase-1.2.4 /usr/local/hbase && \
    rm hbase-1.2.4-bin.tar.gz

# install derby database which is needed by hive
RUN wget http://archive.apache.org/dist/db/derby/db-derby-10.10.2.0/db-derby-10.10.2.0-bin.tar.gz && \
    tar -xzvf db-derby-10.10.2.0-bin.tar.gz && \
    mv db-derby-10.10.2.0-bin /usr/local/derby && \
    rm db-derby-10.10.2.0-bin.tar.gz

# install hive 2.1.1
RUN wget http://www-eu.apache.org/dist/hive/hive-2.1.1/apache-hive-2.1.1-bin.tar.gz && \
    tar -xzvf  apache-hive-2.1.1-bin.tar.gz && \
    mv apache-hive-2.1.1-bin  /usr/local/hive && \
    rm apache-hive-2.1.1-bin.tar.gz

# install pig 0.16.0
RUN wget http://www-eu.apache.org/dist/pig/pig-0.16.0/pig-0.16.0.tar.gz && \
    tar -xzvf  pig-0.16.0.tar.gz && \
    mv pig-0.16.0  /usr/local/pig && \
    rm pig-0.16.0.tar.gz

 
# install Spark 2.1.0
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz && \
    tar -xzvf  spark-2.1.0-bin-hadoop2.7.tgz && \
    mv spark-2.1.0-bin-hadoop2.7 /usr/local/spark && \
    rm spark-2.1.0-bin-hadoop2.7.tgz

# install Kafka 0.10.2.0
RUN wget http://www-eu.apache.org/dist/kafka/0.10.2.0/kafka_2.11-0.10.2.0.tgz && \
    tar -xzvf  kafka_2.11-0.10.2.0.tgz && \
    mv kafka_2.11-0.10.2.0 /usr/local/kafka && \
    rm kafka_2.11-0.10.2.0.tgz

# install zeppelin 0.7.0 
RUN wget http://www-eu.apache.org/dist/zeppelin/zeppelin-0.7.0/zeppelin-0.7.0-bin-all.tgz && \
    tar -xzvf zeppelin-0.7.0-bin-all.tgz && \
    mv zeppelin-0.7.0-bin-all /usr/local/zeppelin && \
    rm zeppelin-0.7.0-bin-all.tgz

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/zoo.cfg $ZOOKEEPER_HOME/conf/zoo.cfg && \
    mkdir /var/zookeeper_data && \
    mv /tmp/start-zookeeper.sh ~/start-zookeeper.sh && \
    mv /tmp/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh && \
    #mv /tmp/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml
    #mv /tmp/hbase-site-pseudo.xml $HBASE_HOME/conf/hbase-site.xml && \
    mv /tmp/regionservers $HBASE_HOME/conf/regionservers && \
    mv /tmp/hbase-site-full.xml $HBASE_HOME/conf/hbase-site.xml && \
    #mv /tmp/backup-masters $HBASE_HOME/conf/backup-masters && \
    mv /tmp/start-hbase.sh ~/start-hbase.sh && \
    mv /tmp/hive-env.sh $HIVE_HOME/conf/hive-env.sh && \
    mv /tmp/hive-site.xml $HIVE_HOME/conf/hive-site.xml && \
    cp $DERBY_HOME/lib/derbyclient.jar $HIVE_HOME/lib && \
    cp $DERBY_HOME/lib/derbytools.jar $HIVE_HOME/lib && \
    mv /tmp/install-hive.sh ~/install-hive.sh && \
    mv /tmp/start-hive.sh ~/start-hive.sh && \ 
    mv /tmp/spark-env.sh $SPARK_HOME/conf/spark-env.sh && \
    mv /tmp/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf && \
    mv /tmp/spark-slaves $SPARK_HOME/conf/slaves && \
    mv /tmp/spark-log4j.properties $SPARK_HOME/conf/log4j.properties  && \
    mkdir /tmp/spark-events && \
    mv /tmp/spark-hive-site.xml $SPARK_HOME/conf/hive-site.xml && \
    mv /tmp/start-spark.sh ~/start-spark.sh && \
    # kafka installation
    mv /tmp/kafka-server-1.properties $KAFKA_HOME/config/server-1.properties && \
    mv /tmp/kafka-server-2.properties $KAFKA_HOME/config/server-2.properties && \
    mv /tmp/start-kafka.sh ~/start-kafka.sh && \
    # zeppelin installation
    mv /tmp/zeppelin-env.sh $ZEPPELIN_HOME/conf && \
    mv /tmp/start-zeppelin.sh ~/start-zeppelin.sh
 

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x ~/start-hbase.sh && \
    chmod +x ~/install-hive.sh && \
    chmod +x ~/start-hive.sh && \
    chmod +x ~/start-spark.sh && \
    chmod +x ~/start-zookeeper.sh && \
    chmod +x ~/start-kafka.sh && \
    chmod +x ~/start-zeppelin.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x $HBASE_HOME/bin/start-hbase.sh && \
    chmod +x $SPARK_HOME/sbin/start-all.sh 

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format



CMD [ "sh", "-c", "service ssh start; bash"]
