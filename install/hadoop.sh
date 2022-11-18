#!/bin/bash

if [ "$EUID" == 0 ]
  then echo "Must NOT run as root"
  exit
fi

# See: https://tecadmin.net/install-hadoop-on-ubuntu-20-04/
VERSION=hadoop-3.3.1

if [[ ! -e $VERSION.tar.gz ]] ; then
  wget https://downloads.apache.org/hadoop/common/$VERSION/$VERSION.tar.gz 
fi

if [[ ! -e hadoop ]] ; then 
  tar -xf $VERSION*gz
  mv $VERSION hadoop
  mkdir -p /home/$USER/hadoop/
  mv hadoop /home/$USER/hadoop/
  export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
  export HADOOP_HOME=/home/$USER/hadoop/hadoop
  export HADOOP_INSTALL=$HADOOP_HOME
  export HADOOP_MAPRED_HOME=$HADOOP_HOME
  export HADOOP_COMMON_HOME=$HADOOP_HOME
  export HADOOP_HDFS_HOME=$HADOOP_HOME
  export HADOOP_YARN_HOME=$HADOOP_HOME
  export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/
  export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
  export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
  export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native

  echo "HADOOP_HOME is $HADOOP_HOME"
  echo "Writing variables into /home/$USER/.bashrc"

  echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /home/$USER/.bashrc
  echo "export HADOOP_HOME=/home/$USER/hadoop/hadoop" >> /home/$USER/.bashrc
  echo "export HADOOP_INSTALL=$HADOOP_HOME" >> /home/$USER/.bashrc
  echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >> /home/$USER/.bashrc
  echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> /home/$USER/.bashrc
  echo "export HADOOP_HDFS_HOME=$HADOOP_HOME" >> /home/$USER/.bashrc
  echo "export HADOOP_YARN_HOME=$HADOOP_HOME" >> /home/$USER/.bashrc
  echo "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native" >> /home/$USER/.bashrc
  echo "export PATH=\$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin" >> /home/$USER/.bashrc
  echo "export HADOOP_OPTS=\"-Djava.library.path=$HADOOP_HOME/lib/native\"" >> /home/$USER/.bashrc
  echo "export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native" >> /home/$USER/.bashrc

  ln -s $HADOOP_HOME hadoop

  echo "Configuring Hadoop"
  mkdir -p $HADOOP_HOME/data/datanode
  mkdir $HADOOP_HOME/data/namenode

  echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

  cat > hadoop/etc/hadoop/core-site.xml << EOF
<configuration>
        <property>
                <name>fs.defaultFS</name>
                <value>hdfs://localhost:9000</value>
        </property>
</configuration>
EOF

  cat > hdfs-site.xml << EOF
<configuration>
        <property>
                <name>dfs.replication</name>
                <value>1</value>
        </property>

        <property>
                <name>dfs.name.dir</name>
                <value>file:///$HADOOP_HOME/data/namenode</value>
        </property>

        <property>
                <name>dfs.data.dir</name>
                <value>file:///$HADOOP_HOME/data/datanode</value>
        </property>
</configuration>
EOF

  envsubst < hdfs-site.xml > $HADOOP_HOME/etc/hadoop/hdfs-site.xml
  rm hdfs-site.xml
  #sed -i "s#DIR#$PWD#" hadoop/etc/hadoop/hdfs-site.xml


  cat > mapred-site.xml << EOF
<configuration>
        <property>
                <name>mapreduce.framework.name</name>
                <value>yarn</value>
        </property>
        <property>
          <name>yarn.app.mapreduce.am.env</name>
          <value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>
        </property>
        <property>
          <name>mapreduce.map.env</name>
          <value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>
        </property>
        <property>
          <name>mapreduce.reduce.env</name>
          <value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>
        </property>
        </configuration>
EOF

  envsubst < mapred-site.xml > $HADOOP_HOME/etc/hadoop/mapred-site.xml
  rm mapred-site.xml
  #sed -i "s#DIR#$PWD#" hadoop/etc/hadoop/mapred-site.xml


  cat > $HADOOP_HOME/etc/hadoop/yarn-site.xml << EOF
<configuration>
        <property>
                <name>yarn.nodemanager.aux-services</name>
                <value>mapreduce_shuffle</value>
        </property>
</configuration>
EOF

  export PATH=$PATH:$HADOOP_HOME/bin
  echo "PATH=\$PATH:/home/$USER/hadoop/hadoop/bin" >> /home/$USER/.bashrc
  echo "PATH=\$PATH:/home/$USER/hadoop/hadoop/sbin" >> /home/$USER/.bashrc

fi

hdfs namenode -format 

source /home/$USER/.bashrc

start-dfs.sh

start-yarn.sh

hadoop fs -mkdir -p /data