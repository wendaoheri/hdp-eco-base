FROM centos:centos7

USER root

# install required software
RUN yum install -y openssh openssh-server openssh-clients wget which rsync python-setuptools git zip unzip ntp vim
    
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


RUN wget -q https://forensics.cert.org/centos/cert/7/x86_64/jdk-8u221-linux-x64.rpm && \
    rpm -ivh jdk-8u221-linux-x64.rpm && \
    rm -rf jdk-8u221-linux-x64.rpm

RUN wget -q -O /etc/yum.repos.d/cloudera-cdh5.repo https://archive.cloudera.com/cdh5/redhat/7/x86_64/cdh/cloudera-cdh5.repo

ENV JAVA_HOME /usr/java/latest

# install mysql

RUN wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm && \
    rpm -ivh mysql-community-release-el7-5.noarch.rpm && \
    yum update && \
    yum install -y mysql-server

ADD config/my.cnf /etc/my.cnf

RUN yum clean all