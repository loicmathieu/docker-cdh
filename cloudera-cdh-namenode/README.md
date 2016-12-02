# loicmathieu/cloudera-cdh-namenode
A container running Cloudera CDH HDFS Namenode and SecondaryNamenode

*Disclaimer : If you want a container shipped with all the Hadoop components in it, take a look at the cloudera/quickstart container. If you want to be able to run multiple container, each with a single hadoop role, use the loicmathieu/cloudera-cdh-<role> containers provided here*

This container is derived from loicmathieu/cloudera-cdh and will setup an HDFS Namenode and a HDFS  SecondaryNamenode. To use it, you will need a Datanode that can be run with loicmathieu/cloudera-hdfs-datanode.

A full example of how to use it with the other Hadoop component can be found in the edgenode documentation : https://hub.docker.com/r/loicmathieu/cloudera-cdh-edgenode/

The Namenode will expose it's 8020 port, to use it, you will then need to start a Datanode and make sure the network stack is OK so that the Namenode and the Datanode can communicate together. 

The container will use supervisor to start both the Namenode and the SecondaryNamenode.

The logs are located in the /var/log/hadoop-hdfs directory for both the Namenode and the SecondaryNamenode.

**Running the container**
```
docker pull loicmathieu/cloudera-cdh-namenode
docker run -d -p 8020:8020 loicmathieu/cloudera-cdh-namenode
```

**Running the cluster**

1. create a network :
```
docker network create hadoop
```
2. start the yarn master :
```
docker run -d --net hadoop --net-alias namenode \
-p 8020:8020 loicmathieu/cloudera-cdh-namenode
```
3. start the datanode :
```
docker run -d --net hadoop --net-alias datanode1 --link namenode \
-p 50020:50020 loicmathieu/cloudera-cdh-datanode
```

To test the installation, connect to the namenode container, check the logs and if everything is fine make some HDFS operations, for example : 
```
docker exec -ti <namenode_id> bash
hadoop fs -put /var/log/hadoop-hdfs/* /
hadoop fs -ls /
```

**For a more complex cluster setup including HDFS, Yarn/MaprReduce, Hive, Pig, Spark, ... see loicmathieu/cloudera-cdh-edgenode that put all this together**
