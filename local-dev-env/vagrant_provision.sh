#!/usr/bin/env bash

# upating yum first
sudo yum update

# installing 'Extra Packages for Enterprise Linux'
# yum package manager does not have all latest software on its default repository
sudo yum install -y epel-release
sudo yum install -y wget

#Apache Http Web Server
if [ ! -f /usr/lib/apache2/mpm-worker/apache2 ];
then
	echo "Installing Apache"
	sudo yum install -y httpd
else
	echo "Apache already installed - skipping"
fi

echo "Starting apache"
sudo service httpd start

#Tomcat
if [ ! -f /etc/init.d/tomcat ];
then
	echo "Installing Tomcat"
	sudo yum install -y tomcat
	echo "Installing Tomcat docs"
	sudo yum install -y tomcat-docs-webapp
	echo "Installing Tomcat administration web apps"
	sudo yum install -y tomcat-admin-webapp
else
	echo "Tomcat already installed - skipping"
fi

echo "Starting Tomcat"
sudo systemctl start tomcat

echo "Enabling Tomcat service"
sudo systemctl enable tomcat


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

#Maven
if [ ! -f /usr/share/maven/bin/mvn ];
then
	echo "Installing Maven"
	sudo yum install -y maven
else
	echo "Maven already installed - skipping"
fi

#Git
if [ ! -f /usr/bin/git ];
then
	echo "Installing Git"
	sudo yum install -y git
else
	echo "Git already installed - skipping"
fi

#NGINX
if [ ! -f /usr/sbin/nginx ];
then
	echo "Installing NGINX"
	sudo yum install -y nginx
	echo "Starting NGINX"
	sudo /etc/init.d/nginx start
else
	echo "NGINX already installed - skipping"
fi

echo "Setting up MySQL Community Repo"
sudo rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm

#MySQL Server
if [ ! -f /usr/sbin/mysqld ];
then
	echo "Installing MySQL Server"
	sudo yum install -y mysql-server
	sudo /sbin/service mysqld start
else
	echo "Mysql server already installed - skipping"
fi


