#!/bin/bash

echo -e "Start zeppelin \n"

ssh -t root@hadoop-slave2 "$ZEPPELIN_HOME/bin/zeppelin-daemon.sh start"

echo -e "Start to use Zeppelin notebook from http://hadoop-slave2:8082 \n"

