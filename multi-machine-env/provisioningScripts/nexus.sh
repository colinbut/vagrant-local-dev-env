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
cd /usr/local/
sudo wget www.sonatype.org/downloads/nexus-2.13.0-01-bundle.zip

echo "Extracting Nexus"
sudo unzip nexus-2.13.0-01-bundle.zip

sudo ln -s nexus-2.13.0-01 nexus

echo "Adding Nexus User"
sudo useradd nexus
sudo chown -R nexus:nexus nexus
sudo chown -R nexus:nexus nexus-2.13.0-01
sudo chown -R nexus:nexus sonatype-work

echo "Configuring Nexus script to have correct environment properties"
sudo sed -i 's/NEXUS_HOME=".."/NEXUS_HOME="\/usr\/local\/nexus"/g' /usr/local/nexus/bin/nexus
sudo sed -i 's/#RUN_AS_USER=/RUN_AS_USER=nexus/' /usr/local/nexus/bin/nexus

echo "Removing nexus download zip"
sudo rm nexus-2.13.0-01-bundle.zip

echo "Starting Nexus"
sudo /usr/local/nexus/bin/nexus start




