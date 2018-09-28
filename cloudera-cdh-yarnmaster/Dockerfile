#######################################################################################################################
# This dockerfile is derived from loicmathieu/cloudera-cdh and will setup a  Yarn ressource manager and an MapReducev2 HistoryServer
#
# The ressource manager will expose it's 8032 port, to use it, you first need to start a datanode 
# (using loicmathieu/cloudera-hdfs-datanode) and make sure the netword stack is OK so that the ressource manager and datanode 
# can communicate together
#
# The container will use supervisor to start both components.
#######################################################################################################################
FROM loicmathieu/cloudera-cdh:cdh-5.15.1

MAINTAINER Loic Mathieu <loicmathieu@free.fr>

#setup supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#expose ressourcemanager port
EXPOSE 8032 8080

#start the supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
