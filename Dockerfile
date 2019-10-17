FROM centos:centos7

USER root

# install required software
RUN yum install -y openssh openssh-server openssh-clients wget which rsync python-setuptools git zip unzip && \
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


RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn/java/jdk/8u231-b11/5b13a193868b4bf28bcb45c792fce896/jdk-8u231-linux-x64.rpm?AuthParam=1571307866_6d0e3e7aaced850887b9efd395607ea9 && \
    rpm -ivh jdk-8u231-linux-x64.rpm && \
    rm -rf jdk-8u231-linux-x64.rpm