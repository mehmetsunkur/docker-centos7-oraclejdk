FROM centos
MAINTAINER Mehmet Sunkur, mehmetsunkur@gmail.com

# Upgrading system and install required additional packages for installation
RUN     yum -y update && \
    yum -y install wget tar.x86_64 bzip2 fontconfig && \
    yum clean all

# Download and extract phantomjs
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar jxf phantomjs-2.1.1-linux-x86_64.tar.bz2

# Extract latest Oracle JDK download link into jdk.url.txt
ADD OracleJdkDownload.js OracleJdkDownload.js
RUN ./phantomjs-2.1.1-linux-x86_64/bin/phantomjs OracleJdkDownload.js

# Download and install Oracle jdk
RUN wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" -i jdk.url.txt -O /tmp/jdk-linux-x64.rpm
RUN yum -y localinstall /tmp/jdk-linux-x64.rpm

# Clean up
RUN rm /tmp/jdk-linux-x64.rpm
RUN rm -rf phantomjs-2.1.1-linux-x86_64*

# Set java
RUN alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000

ENV JAVA_HOME /usr/java/latest

RUN java -version
CMD echo "Jdk ready.."
