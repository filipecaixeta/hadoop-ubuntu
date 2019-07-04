FROM ubuntu:18.04

USER root

RUN apt-get update

RUN apt-get install openjdk-8-jdk openjdk-8-jre -y
RUN apt-get install openssh-server openssh-client -y

RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz
RUN tar -xzvf hadoop-2.8.5.tar.gz
RUN cp -r hadoop-2.8.5/* .

RUN apt-get install nano -y

RUN echo "export HADOOP_HOME=\nexport HADOOP_INSTALL=$HADOOP_HOME\nexport HADOOP_MAPRED_HOME=$HADOOP_HOME\nexport HADOOP_COMMON_HOME=$HADOOP_HOME\nexport HADOOP_HDFS_HOME=$HADOOP_HOME\nexport YARN_HOME=$HADOOP_HOME\nexport HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native\nexport PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin\nexport HADOOP_OPTS=\"-Djava.library.path=$HADOOP_HOME/lib/native\"\nexport HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop\nexport JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\n" >> ~/.bashrc

COPY core-site.xml /etc/hadoop/core-site.xml
RUN mkdir hadooptmpdata

COPY hdfs-site.xml /etc/hadoop/hdfs-site.xml
RUN mkdir -p hdfs/namenode
RUN mkdir -p hdfs/datanode

COPY mapred-site.xml /etc/hadoop/mapred-site.xml

COPY yarn-site.xml /etc/hadoop/yarn-site.xml

RUN sed -i 's/\${JAVA_HOME}/\${JAVA_HOME:-\/usr\/lib\/jvm\/java-8-openjdk-amd64}/' etc/hadoop/hadoop-env.sh

RUN hdfs namenode -format 

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh
CMD ["/etc/bootstrap.sh", "-d"]

EXPOSE 50070
EXPOSE 8088
