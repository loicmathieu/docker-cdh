# loicmathieu/cloudera-cdh-edgenode

A container installed with Cloudera Hadoop CDH and aims to be a client for HDFS and Yarn/Mapreduce.

This container is linked to the other loicmathieu/cloudera-cdh-* containers and aims to be the edge node so the entry point to send files, launch scripts and jobs, etc. to the cluster.

This container contains the following Hadoop client : hdfs, yarn, mapreduce v2, pig, hive, spark, sqoop, flume.

**Some example of how to run it :**

0. If not done already, pull all the needed images
```
docker pull loicmathieu/cloudera-cdh-namenode
docker pull loicmathieu/cloudera-cdh-yarnmaster
docker pull loicmathieu/cloudera-cdh-datanode
docker pull loicmathieu/cloudera-cdh-edgenode
```

1. First, setup a network for the cluster
```
docker network create hadoop
```

2. Then start the HDFS and Yarn master containers
```
docker run -d --net hadoop --net-alias namenode \
-p 8020:8020 loicmathieu/cloudera-cdh-namenode
docker run -d --net hadoop --net-alias yarnmaster \
-p 8032:8032 -p 8088:8088 loicmathieu/cloudera-cdh-yarnmaster
```

3. Then start a datanode, warning : the hostname of the datanode needs to be specified in order yarn RessourceManager to be able to communicate with it (use of the -h docker run option).
```
docker run -d --net hadoop --net-alias datanode1 -h datanode1 \
--link namenode --link yarnmaster -p 50020:50020 -p 50075:50075 -p 8042:8042 \
loicmathieu/cloudera-cdh-datanode
```

4. Finally launch the edge node and connect to it
```
docker run -ti --net hadoop --net-alias edgenode --link namenode --link yarnmaster \
loicmathieu/cloudera-cdh-edgenode bash
```

Optionnaly, you can mount the /staging volume to be able to easily send/get data to/from the cluster. It can facilitate putting stuff on HDFS or sending JAR files to Yarn.

**Some example of how to run it :**
The container include test data and scripts to test the cluster, here is a small snippet of what can be done :

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

**Spark (local) :**
```
spark-shell
val cities = sc.textFile("hdfs:///cities");
cities.count();
exit;
```

**Spark (yarn) :**
```
spark-shell --master yarn
val cities = sc.textFile("hdfs:///cities");
cities.count();
exit;
```

**Flume :**  
There's an embeded flume tests that can be used with the loicmathieu/apache-httpd-flume container (https://hub.docker.com/r/loicmathieu/apache-httpd-flume). This container contains and apache httpd webserver and a flume agent that will tail the apache access log and send it to a flume collector edgenode:9000. You can see the configuration file /flume_httpd.conf

On the edgenode, the flume conf is also in /flume_httpd.conf and there is a /start_flume.sh script that will launch an agent that will listen on port 9000 and write to hdfs://users/root/collector the data written to it.

Here are the step to test it :
```
docker pull loicmathieu/apache-httpd-flume
docker run -d --net hadoop --net-alias flume -p 80:80 loicmathieu/apache-httpd-flume
docker run -ti --net hadoop --net-alias edgenode --link namenode --link yarnmaster loicmathieu/cloudera-cdh-edgenode bash
start_flume.sh
```
Here, I forward the port 80 of the loicmathieu/apache-httpd-flume container to the port 80 of the host, accessing it via a browser will write lines to the apache httpd access logs that will be send to the flume agent of the edgenode and written to HDFS
```
hadoop fs -ls /user/root/collector
```

**Sqoop2 :**  
It's installed, use it with scoop2 from the shell ...
