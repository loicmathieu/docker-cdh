# cloudera-cdh-yarnmaster
A container running Cloudera CDH HDFS Namenode and SecondaryNamenode

*Disclaimer : If you want a container shipped with all the Hadoop components in it, take a look at the cloudera/quickstart container. If you want to be able to run multiple container, each with a single hadoop role, use the loicmathieu.cloudera-cdh-<role> containers provided here*

This container is derived from loicmathieu/cloudera-cdh and will setup an HDFS Namenode and an HDFS SecondaryNamenode. To use it, you will need a Datanode that can be run with loicmathieu/cloudera-hdfs-datanode.

The Namenode will expose it's 8020 port, to use it, you will then need to start a Datanode and make sure the network stack is OK so that the Namenode and Datanode can communicate together. 

The container will use supervisor to start both the Namenode and the SecondaryNamenode.

The logs are located in the /var/log/hadoop-hdfs directory

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
2. start the namenode :
```
docker run -d --net hadoop --net-alias namenode \
-p 8020:8020 loicmathieu/cloudera-cdh-namenode
```
3. start the datanode :
```
docker run -d --net hadoop --net-alias datanode1 --link namenode \
-p 50020:50020 loicmathieu/cloudera-cdh-datanode
```

To test the installation, connect to the Namenode, check the logs and if everything is fine make some HDFS operation, for example : 
```
docker exec -ti <namenode_id> bash
hadoop fs -ls /
hadoop fs -put /var/log/hadoop-hdfs/* /
hadoop fs -ls /
```

**For a more complex cluster setup including HDFS, Yarn/MaprReduce, Hive, Pig, ... see loicmathieu/cloudera-cdh-edgenode that put all this together**
