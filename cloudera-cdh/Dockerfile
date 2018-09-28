#############################################################################################
# This dockerfile will make some basic CDH related installation.
#
# It's purpose is to be the base to make more specific CDH container, so don't use it 
# directly but instead use one of the following :
# - loicmathieu/cloudera-cdh-namenode : will launch an HDFS namenode and a secondarynamenode
# - loicmathieu/cloudera-cdh-yarnmaster : will launch a Yarn ResourceManager 
#	and a MapReduce HistoryServer
# - loicmathieu/cloudera-cdh-datanode : will launch and HDFS datanode and a Yarn NodeManager
# - loicmathieu/cloudera-cdh-edgenode : will launch a client container to HDFS/Yarn cluster
############################################################################################
FROM loicmathieu/openjdk

MAINTAINER Loic Mathieu <loicmathieu@free.fr>

ENV CDH_VER 5.15.1

#copy cloudera CDH repo
COPY cloudera-cdh.repo /etc/yum.repos.d

#Install epel repo because supervisor isn't in the base repo
RUN yum -y install epel-release && rm -rf /var/cache/yum/*

#Install hadoop and supervisor so that the derived images will not be too fat
RUN yum -y install hadoop supervisor &&  rm -rf /var/cache/yum/*

#copy hadoop conf
COPY config/* /usr/lib/hadoop/etc/hadoop/

#set HADOOP_* environement variables
ENV HADOOP_HOME /usr/lib/hadoop
ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV HADOOP_COMMON_HOME /usr/lib/hadoop
ENV HADOOP_HDFS_HOME /usr/lib/hadoop-hdfs
ENV HADOOP_YARN_HOME /usr/lib/hadoop-yarn
ENV HADOOP_MAPRED_HOME /usr/lib/hadoop-mapreduce

CMD ["hadoop", "version"]