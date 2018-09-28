#########################################################################################
# This dockerfile is derived from loicmathieu/cloudera-cdh and will setup an edge node to
# works with the other cloudera containers.
# It also contains some pig/hive script and CSV test files to start with
#
#########################################################################################
FROM loicmathieu/cloudera-cdh:cdh-5.15.1

MAINTAINER Loic Mathieu <loicmathieu@free.fr>

#install pig, hive, flume and scoop 
RUN yum -y install pig hive flume-ng sqoop2 spark-worker && rm -rf /var/cache/yum/*

#copy test data and script
COPY cities.* /

#copy flume conf and start scripts
COPY flume/* /
RUN chmod +x /start_flume.sh

#create a staging disk to send/get data to/from the clusrer
RUN mkdir /staging

VOLUME /staging

CMD ["bash"]