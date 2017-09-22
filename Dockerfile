FROM centos
MAINTAINER Mehmet Sunkur, mehmetsunkur@gmail.com


# Upgrading system
RUN     yum -y update && \
    yum -y install wget && \
    yum install -y tar.x86_64 unzip.x86_64 lsof.x86_64 git.x86_64 && \
    yum clean all
RUN wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm -O /tmp/jdk-8-linux-x64.rpm

RUN yum -y localinstall /tmp/jdk-8-linux-x64.rpm
RUN rm /tmp/jdk-8-linux-x64.rpm

RUN alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000

ENV JAVA_HOME /usr/java/latest

CMD echo "Jdk ready.."
