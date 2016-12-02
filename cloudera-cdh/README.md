# loicmathieu/cloudera-cdh

Base image with Cloudera CDH installed on it.

It's purpose is to be the base to make more specific CDH container, so don't use it directly but instead use
- loicmathieu/cloudera-cdh-namenode : will launch an HDFS namenode and an HDFS secondarynamenode
- loicmathieu/cloudera-cdh-datanode : will launch and HDFS datanode

But if you really want to use it, OK, you can :
```
docker pull loicmathieu/cloudera-cdh
docker run -ti loicmathieu/cloudera-cdh
```

This should print out the Hadoop version (hadoop version command will be launched)