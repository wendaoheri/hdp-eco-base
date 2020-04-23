FROM centos:centos7

USER root

# install required software
RUN yum install -y openssh openssh-server openssh-clients wget which rsync python-setuptools git zip unzip ntp vim sudo
    
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

# install jdk
RUN wget -q https://forensics.cert.org/centos/cert/7/x86_64/jdk-8u221-linux-x64.rpm && \
    rpm -ivh jdk-8u221-linux-x64.rpm && \
    rm -rf jdk-8u221-linux-x64.rpm

ENV JAVA_HOME /usr/java/latest

RUN yum clean all

COPY config/supervisord.conf /etc/
COPY config/supervisor.d/* /etc/supervisor.d/
COPY wait-for-it.sh /

RUN chmod +x /wait-for-it.sh
RUN mkdir -p /var/log/supervisor/

EXPOSE 22 9001

ENTRYPOINT [ "supervisord", "-c" , "/etc/supervisord.conf" ]