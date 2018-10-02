#########################################################################################
# This dockerfile is derived from loicmathieu/cloudera-cdh and will setup an edge node to
# works with the other cloudera containers.
# It also contains some pig/hive script and CSV test files to start with
#
#########################################################################################
FROM loicmathieu/cloudera-cdh:cdh-6.0.0

MAINTAINER Loic Mathieu <loicmathieu@free.fr>

#install pig, hive, flume and scoop 
RUN yum -y install pig hive flume-ng sqoop spark-core && rm -rf /var/cache/yum/*

#copy test data and script
COPY cities.* /

#copy flume conf and start scripts
COPY flume/* /
RUN chmod +x /start_flume.sh

#there is an issue with hive, we need to recrete the db
RUN rm -rf /var/lib/hive/metastore/metastore_db
RUN /usr/lib/hive/bin/schematool -dbType derby -initSchema

#create a staging disk to send/get data to/from the clusrer
RUN mkdir /staging

VOLUME /staging

CMD ["bash"]