#######################################################################################################################
# This dockerfile is derived from loicmathieu/cloudera-cdh and will setup an HDFS datanode
#
# The datanode will expose it's 50020, 50075 and 8042 ports, to use it, you first need to start a namenode
# (using loicmathieu/cloudera-hdfs-namenode) and make sure the netword stack is OK so that the namenode and datanode
# can communicate together
#######################################################################################################################
FROM loicmathieu/cloudera-cdh:cdh-5.15.1

MAINTAINER Loic Mathieu <loicmathieu@free.fr>

#init datanode directory
RUN mkdir -p /hdfs/data

#setup supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#expose port
EXPOSE 50020 50075 8042

#define HDFS volume to enable to persist datanode data (hdfs files) between restart
VOLUME /hdfs

#start the supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
