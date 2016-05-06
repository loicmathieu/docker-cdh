# cloudera-cdh-edgenode

A container installed with Cloudera CDH and aims to be a client for HDFS and Yarn/Mapreduce.

This container is linked to the other loicmathieu/cloudera-cdh-* containers and aims to be the edge node so the entry point to send files, launch scripts and jobs, etc. to the cluster.

This container contains the following Hadoop client : hdfs, yarn, mapreduce v2, pig, hive, sqoop, flume.

**Some example of how to run it :**
0. If not done already, pull all the needed images
```
docker pull loicmathieu/cloudera-cdh-namenode
docker pull loicmathieu/cloudera-cdh-yarnmaster
docker pull loicmathieu/cloudera-cdh-datanode
docker pull loicmathieu/cloudera-cdh-edgenode
```
1. First, setup a cluster
```
docker network create hadoop
```

2. Then start the HDFS and Yarn master containers
```
docker run -d --net hadoop --net-alias namenode \
-p 8020:8020 loicmathieu/cloudera-cdh-namenode
docker run -d --net hadoop --net-alias yarnmaster --link datanode \
-p 8032:8032 -p 8088:8088 loicmathieu/cloudera-cdh-yarnmaster
```

3. Then start a datanode, warning : the hostname of the datanode needs to be specified in order yarn RessourceManager to be able to communicate with it (use of the -h docker run option).
```
docker run -d --net hadoop --net-alias datanode1 -h datanode1 --link namenode --link yarnmaster \
-p 50020:50020 -p 50075:50075 -p 8042:8042 loicmathieu/cloudera-cdh-datanode
```

4. Finally launch the edge node and connect to it
```
docker run -ti --net hadoop --net-alias edgenode --link namenode --link yarnmaster \
loicmathieu/cloudera-cdh-edgenode bash
```

**Some example of how to run it :**
The container include test data and scripts to test the cluster, here is a small snippet of whant can be done :

**HDFS & MapReduce :**
```
 hadoop fs -mkdir /cities
 hadoop fs -put cities.csv /cities
 hadoop fs -cat /cities/cities.csv
 hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar \
 wordcount /cities/cities.csv /wordcount
 hadoop fs -ls /wordcount
 ```

 **Pig :**
```
 pig cities.pig
 hadoop fs -ls /data_by_department
 hadoop fs -cat /data_by_department/part-r-00000
 ```

**Hive :**
```
 beeline -u jdbc:hive2:// -f cities.hql
 beeline -u jdbc:hive2://
 select * from cities limit 10;
 select * from cities where department = '82' limit 10;
 ```

** Sqoop2 :**  It's installed, use it with scoop2 from the shell
 
** Flume :**  It's installed, use it with flume-ng from the shell
