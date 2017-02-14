FROM ubuntu:14.04

MAINTAINER Johnson Wang <johnsonwangnz@gmail.com>

WORKDIR /root

# set environment variable
ENV TZ=Pacific/Auckland
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV HBASE_HOME=/usr/local/hbase
ENV SPARK_HOME=/usr/local/spark
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

# install hbase 1.2.4
RUN wget http://www-eu.apache.org/dist/hbase/1.2.4/hbase-1.2.4-bin.tar.gz && \
    tar -xzvf  hbase-1.2.4-bin.tar.gz && \
    mv hbase-1.2.4 /usr/local/hbase && \
    rm hbase-1.2.4-bin.tar.gz


# install Spark 2.1.0
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz && \
    tar -xzvf  spark-2.1.0-bin-hadoop2.7.tgz && \
    mv spark-2.1.0-bin-hadoop2.7 /usr/local/spark && \
    rm spark-2.1.0-bin-hadoop2.7.tgz


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
    mv /tmp/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh && \
    #mv /tmp/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml
    #mv /tmp/hbase-site-pseudo.xml $HBASE_HOME/conf/hbase-site.xml && \
    mv /tmp/regionservers $HBASE_HOME/conf/regionservers && \
    mv /tmp/hbase-site-full.xml $HBASE_HOME/conf/hbase-site.xml && \
    #mv /tmp/backup-masters $HBASE_HOME/conf/backup-masters && \
    mv /tmp/start-hbase.sh ~/start-hbase.sh && \
    mv /tmp/spark-env.sh $SPARK_HOME/conf/spark-env.sh && \
    mv /tmp/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf && \
    mv /tmp/spark-slaves $SPARK_HOME/conf/slaves && \
    mv /tmp/start-spark.sh ~/start-spark.sh 

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x ~/start-hbase.sh && \
    chmod +x ~/start-spark.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x $HBASE_HOME/bin/start-hbase.sh && \
    chmod +x $SPARK_HOME/sbin/start-all.sh 

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format



CMD [ "sh", "-c", "service ssh start; bash"]
