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
	echo "Java 7 already installed - skipping"
fi


if [ ! -f /etc/init.d/jenkins ];
then
	echo "Installing Jenkins"

	# URL: http://localhost:6060
	# Home: /var/lib/jenkins
	# Start/Stop: /etc/init.d/jenkins
	# Config: /etc/default/jenkins
	# Jenkins log: /var/log/jenkins/jenkins.log
	#wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
	#sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
	sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
	sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
	sudo yum update
	sudo yum install -y jenkins

	sed -i 's/8080/6060/g' /etc/sysconfig/jenkins
	/etc/init.d/jenkins restart
else
	echo "Jenkins already installed - not Installing"
fi