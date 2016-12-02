# loicmathieu/cloudera-cdh-yarnmaster
A container running Cloudera CDH HDFS Namenode and SecondaryNamenode

*Disclaimer : If you want a container shipped with all the Hadoop components in it, take a look at the cloudera/quickstart container. If you want to be able to run multiple container, each with a single hadoop role, use the loicmathieu.cloudera-cdh-<role> containers provided here*

This container is derived from loicmathieu/cloudera-cdh and will setup a Yarn ResourceManager and a HDFS  MaprReduce 2 HistoryServer. To use it, you will need a Datanode that can be run with loicmathieu/cloudera-hdfs-datanode.

A full example of how to use it with the other Hadoop component can be found in the edgenode documentation : https://hub.docker.com/r/loicmathieu/cloudera-cdh-edgenode/

The ResourceManager will expose it's 8032 port, to use it, you will then need to start a Datanode and make sure the network stack is OK so that the ResourceManager and the Datanode can communicate together. 

The History server will expose it's 8080 port.

The container will use supervisor to start both the ResourceManager and the HistoryServer.

The logs are located in the /var/log/hadoop-yarn directory for the ResourceManager and the /var/log/hadoop-mapreduce directoy for the HistoryServer

**Running the container**
```
docker pull loicmathieu/cloudera-cdh-yarnmaster
docker run -d -p 8032:8032 -p 8088:8088 loicmathieu/cloudera-cdh-yarnmaster
```

**Running the cluster**

1. create a network :
```
docker network create hadoop
```
2. start the yarn master :
```
docker run -d --net hadoop --net-alias yarnmaster \
-p 8032:8032 -p 8088:8088 loicmathieu/cloudera-cdh-yarnmaster
```
3. start the datanode :
```
docker run -d --net hadoop --net-alias datanode1 -h datanode1 --link yarnmaster \
-p 50020:50020 -p 50075:50075 -p 8042:8042 loicmathieu/cloudera-cdh-datanode
```

To test the installation, connect to the ResourceManager, check the logs and if everything is fine make some Yarn operation, for example : 
```
docker exec -ti <yarnmaster_id> bash
hadoop fs -put /var/log/hadoop-yarn/* /
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount \
hadoop-yarn* /wordcount
hadoop fs -ls /wordcount
```

**For a more complex cluster setup including HDFS, Yarn/MaprReduce, Hive, Pig, Spark, ... see loicmathieu/cloudera-cdh-edgenode that put all this together**
