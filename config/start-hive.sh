
echo -e "Starting remote metastore service"

ssh -f root@hadoop-slave1 "sh -c 'nohup $HIVE_HOME/bin/hive --service metastore > metastore-console.out 2>metastore-console.err </dev/null &'"

echo -e "Start to use hive using $HIVE_HOME/bin/hive shell"
