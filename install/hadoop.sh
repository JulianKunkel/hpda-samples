#!/bin/bash

VERSION=hadoop-3.3.1

if [[ ! -e $VERSION ]] ; then
  wget https://downloads.apache.org/hadoop/common/$VERSION/$VERSION.tar.gz 
  tar -xf $VERSION*gz
fi

if [[ ! -e hadoop ]] ; then 
  echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/environment
  ln -s $PWD/$VERSION hadoop
fi

echo Configuring Hadoop
mkdir -p ../data/datanode
mkdir ../data/namenode
# See: https://tecadmin.net/install-hadoop-on-ubuntu-20-04/

cat > hadoop/etc/hadoop/core-site.xml << EOF
<configuration>
        <property>
                <name>fs.defaultFS</name>
                <value>hdfs://localhost:9000</value>
        </property>
</configuration>
EOF

cat > hadoop/etc/hadoop/hdfs-site.xml << EOF
<configuration>
        <property>
                <name>dfs.replication</name>
                <value>1</value>
        </property>
 
        <property>
                <name>dfs.name.dir</name>
                <value>file:///DIR/../data/namenode</value>
        </property>
 
        <property>
                <name>dfs.data.dir</name>
                <value>file:///DIR/../data/datanode</value>
        </property>
</configuration>
EOF
sed -i "s#DIR#$PWD#" hadoop/etc/hadoop/hdfs-site.xml

cat > hadoop/etc/hadoop/mapred-site.xml << EOF
<configuration>
        <property>
                <name>mapreduce.framework.name</name>
                <value>yarn</value>
        </property>
</configuration>
EOF

cat > hadoop/etc/hadoop/yarn-site.xml << EOF
<configuration>
        <property>
                <name>yarn.nodemanager.aux-services</name>
                <value>mapreduce_shuffle</value>
        </property>
</configuration>
EOF

hdfs namenode -format 
