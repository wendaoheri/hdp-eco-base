FROM centos:centos7

USER root

# install required software
RUN yum install -y openssh openssh-server openssh-clients wget which rsync python-setuptools git zip unzip nodejs && \
    yum clean all
RUN easy_install supervisor
# config ssh 
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -P '' && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -P '' && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -P '' && \
    ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    
ADD config/ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config && \
    chown root:root /root/.ssh/config


# download jdk
RUN wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz" && \
    tar -xf jdk-8u191-linux-x64.tar.gz -C /opt && \
    ln -s /opt/jdk1.8.0_191 /opt/jdk && \
    rm -rf jdk-8u191-linux-x64.tar.gz

# downlad scala
RUN wget -q https://downloads.lightbend.com/scala/2.11.12/scala-2.11.12.tgz && \
    tar -xf scala-2.11.12.tgz -C /opt && \
    ln -s /opt/scala-2.11.12 /opt/scala && \
    rm -rf scala-2.11.12.tgz

# download hadoop
RUN wget -q https://archive.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz && \
    tar -xf hadoop-2.7.3.tar.gz -C /opt && \
    ln -s /opt/hadoop-2.7.3 /opt/hadoop && \
    rm -rf hadoop-2.7.3.tar.gz
# download hive
RUN wget -q https://archive.apache.org/dist/hive/hive-1.2.2/apache-hive-1.2.2-bin.tar.gz && \
    tar -xf apache-hive-1.2.2-bin.tar.gz -C /opt && \
    ln -s /opt/apache-hive-1.2.2-bin /opt/hive && \
    rm -rf apache-hive-1.2.2-bin.tar.gz
# download hbase
RUN wget -q https://archive.apache.org/dist/hbase/1.2.7/hbase-1.2.7-bin.tar.gz && \
    tar -xf hbase-1.2.7-bin.tar.gz -C /opt && \
    ln -s /opt/hbase-1.2.7 /opt/hbase && \
    rm -rf hbase-1.2.7-bin.tar.gz

# download spark
RUN wget -q https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz && \
    tar -xf spark-2.4.0-bin-hadoop2.7.tgz -C /opt && \
    ln -s /opt/spark-2.4.0-bin-hadoop2.7 /opt/spark && \
    rm -rf  spark-2.4.0-bin-hadoop2.7.tgz

# download zookeeper
RUN wget -q https://archive.apache.org/dist/zookeeper/stable/zookeeper-3.4.12.tar.gz && \
    tar -xf zookeeper-3.4.12.tar.gz -C /opt && \
    ln -s /opt/zookeeper-3.4.12 /opt/zookeeper && \
    rm -rf zookeeper-3.4.12.tar.gz

# download kafka
RUN wget -q https://archive.apache.org/dist/kafka/2.1.0/kafka_2.11-2.1.0.tgz && \
    tar -xf kafka_2.11-2.1.0.tgz -C /opt && \
    ln -s /opt/kafka_2.11-2.1.0 /opt/kafka && \
    rm -rf kafka_2.11-2.1.0.tgz

# download maven
RUN wget -q https://archive.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz && \
    tar -xf apache-maven-3.6.0-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.6.0 /opt/maven && \
    rm -rf apache-maven-3.6.0-bin.tar.gz

# download alluxio
RUN wget -q http://downloads.alluxio.org/downloads/files//1.8.1/alluxio-1.8.1-hadoop-2.7-bin.tar.gz && \
    tar -xf alluxio-1.8.1-hadoop-2.7-bin.tar.gz -C /opt && \
    ln -s /opt/alluxio-1.8.1-hadoop-2.7 /opt/alluxio && \
    rm -rf alluxio-1.8.1-hadoop-2.7-bin.tar.gz

# download phoenix
RUN wget -q https://archive.apache.org/dist/phoenix/apache-phoenix-4.14.1-HBase-1.2/bin/apache-phoenix-4.14.1-HBase-1.2-bin.tar.gz && \
    tar -xf apache-phoenix-4.14.1-HBase-1.2-bin.tar.gz -C /opt && \
    ln -s /opt/apache-phoenix-4.14.1-HBase-1.2-bin /opt/phoenix && \
    rm -rf apache-phoenix-4.14.1-HBase-1.2-bin.tar.gz

# download flink
RUN wget -q https://archive.apache.org/dist/flink/flink-1.6.2/flink-1.6.2-bin-hadoop27-scala_2.11.tgz && \
    tar -xf flink-1.6.2-bin-hadoop27-scala_2.11.tgz -C /opt && \
    ln -s /opt/flink-1.6.2 /opt/flink && \
    rm -rf flink-1.6.2-bin-hadoop27-scala_2.11.tgz

# download typesafe activator
RUN wget -q https://downloads.typesafe.com/typesafe-activator/1.3.12/typesafe-activator-1.3.12.zip && \
    unzip -d /opt typesafe-activator-1.3.12.zip && \
    ln -s /opt/activator-dist-1.3.12 /opt/activator && \
    rm -rf typesafe-activator-1.3.12.zip

# install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm -rf get-pip.py

## install inspyred
RUN pip install inspyred

# install nodejs
RUN curl --silent --location https://rpm.nodesource.com/setup_10.x | bash - && \
    yum install -y nodejs && \
    yum clean all