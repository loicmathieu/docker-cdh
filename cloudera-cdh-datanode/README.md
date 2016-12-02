# loicmathieu/cloudera-cdh-datanode

A container running Cloudera Hadoop CDH HDFS Datanode and Yarn NodeManager

*Disclaimer : If you want a container shipped with all the Hadoop components in it, take a look at the cloudera/quickstart container. If you want to be able to run multiple container, each with a single hadoop role, use the loicmathieu.cloudera-cdh-<role> containers provided here*

This container is derived from loicmathieu/cloudera-cdh and will setup an HDFS datanode and a Yarn NodeManager.

A full example of how to use it with the other Hadoop component can be found in the edgenode documentation : https://hub.docker.com/r/loicmathieu/cloudera-cdh-edgenode/

The datanode will expose it's  50020 and 50075 ports, to use it, you first need to start a namenode
(using loicmathieu/cloudera-hdfs-namenode) and make sure the network stack is OK so that the namenode and datanode can communicate together. 

The nodemanager will expose it's 8042 port. If you want to use it, you also need to start a loicmathieu/cloudera-cdh-yarnmaster container and you need to configure the hostname of your container (using the docker run -h option) because communication between the nodemanger and the ressourcemanager are based on the hostname.

The container will use supervisor to start both the Datanode and the NodeManager.

The Datanode logs are in /var/log/hadoop-hdfs and the NodeManager logs are in /var/log/hadoop-yarn

**Running the container**
```
docker pull loicmathieu/cloudera-cdh-datanode
docker run -d -p 50020:50020 -p 50075:50075 -p 8042:8042 -h datanode1 loicmathieu/cloudera-cdh-datanode
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
3. start the yarn manager :
```
docker run -d --net hadoop --net-alias yarnmaster \
-p 8032:8032 -p 8088:8088 loicmathieu/cloudera-cdh-yarnmaster
```
4. start the datanode :
```
docker run -d --net hadoop --net-alias datanode1 -h datanode1 --link namenode --link yarnmaster \
-p 50020:50020 -p 50075:50075 -p 8042:8042 loicmathieu/cloudera-cdh-datanode
```

To test the installation, connect to the namenode or the yarnmaster, check the logs and if everything is fine make some HDFS operation, for example : 
```
docker exec -ti <namenode_id> bash
hadoop fs -ls /
hadoop fs -put /var/log/hadoop-hdfs/* /
hadoop fs -ls /
```

or some Yarn/MapReduce operation
```
hadoop fs -put /var/log/hadoop-hdfs/* /
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar \
wordcount /hadoop-hdfs* /wordcount
hadoop fs -ls /wordcount
```

**For a more complex cluster setup including HDFS, Yarn/MaprReduce, Hive, Pig, Spark, ... see loicmathieu/cloudera-cdh-edgenode that put all this together**
