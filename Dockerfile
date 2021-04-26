FROM ubuntu:latest

ENV HADOOP_HOME /opt/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_FILE hadoop-3.3.0

RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime
RUN apt-get update
RUN apt-get install -y --reinstall build-essential
RUN apt-get install -y --no-install-recommends ssh wget rsync net-tools libxml2-dev libkrb5-dev libffi-dev libssl-dev python-lxml libgmp3-dev libsasl2-dev openjdk-8-jre python2.7-dev && rm -rf /var/lib/apt/lists/* && apt-get clean

RUN if [ ! -e /usr/bin/python ]; then ln -s /usr/bin/python2.7 /usr/bin/python; fi

RUN \
    wget https://apachemirror.sg.wuchna.com/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz && \
    tar xzf $HADOOP_FILE.tar.gz

RUN \
    mv $HADOOP_FILE $HADOOP_HOME && \
    for user in hadoop hdfs yarn mapred; do \
      useradd -U -M -d /opt/hadoop/ --shell /bin/bash ${user}; \
    done && \
    for user in root hdfs yarn mapred; do \
      usermod -G hadoop ${user}; \
    done && \
    echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#    echo "export HDFS_DATANODE_SECURE_USER=hdfs" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc && \
    rm $HADOOP_FILE.tar.gz

WORKDIR /

RUN \
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

ADD *xml $HADOOP_HOME/etc/hadoop/

ADD ssh_config /root/.ssh/config

ADD start-all.sh start-all.sh

EXPOSE 8088 9870 9864 19888 8042

CMD bash start-all.sh
