#!/usr/bin/env bash

# upating yum first
sudo yum update

# installing 'Extra Packages for Enterprise Linux'
# yum package manager does not have all latest software on its default repository
sudo yum install -y epel-release
sudo yum install -y wget
sudo yum install -y unzip

#Java
if [ ! -f /opt/jdk1.7.0_79/bin/java ];
then
	echo "Downloading Java 7"
	cd /opt/
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz"
	tar xzf jdk-7u79-linux-x64.tar.gz
	echo "Installing Java 7"
	cd /opt/jdk1.7.0_79/
	alternatives --install /usr/bin/java java /opt/jdk1.7.0_79/bin/java 2
	alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_79/bin/jar 2
	alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_79/bin/javac 2
 	alternatives --set jar /opt/jdk1.7.0_79/bin/jar
 	alternatives --set javac /opt/jdk1.7.0_79/bin/javac
else
	echo "Java 7 already installed - skippi/src/ng"
fi

echo "Downloading Nexus"
cd /tmp/
wget www.sonatype.org/downloads/nexus-2.1.2-bundle.tar.gz

mkdir -v /usr/lib/nexus
cd /usr/lib/nexus

echo "Extracting Nexus"
tar -xzvf /tmp/nexus-2.1.2-bundle.tar.gz nexus-2.1.2/

echo "Setting up Symbolic links"
ln -s nexus-2.1.2/ nexus

echo "Creating Nexus Repository"
sudo mkdir -pv /srv/nexus/main-repo

sed -i "s@nexus-work=${bundleBasedir}/../sonatype-work/nexus@nexus-work=/srv/nexus/main-repo@g" /usr/lib/nexus/nexus/conf/nexus.properties

sudo sed -i 's/NEXUS_HOME=".."/NEXUS_HOME="\/usr\/lib\/nexus\/nexus"/g' /etc/init.d/nexus

#Set PID dir
sudo sed -i 's/#PIDDIR="."/PIDDIR="\/var\/run"/g' /etc/init.d/nexus  
#Set RUN_AS user to root
sed -i 's/#RUN_AS_USER=/RUN_AS_USER=root/' /etc/init.d/nexus  




