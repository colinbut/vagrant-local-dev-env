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

#Git
if [ ! -f /usr/bin/git ];
then
	echo "Installing Git"
	sudo yum install -y git
else
	echo "Git already installed - skipping"
fi

#Apache Http Web Server
if [ ! -f /usr/lib/apache2/mpm-worker/apache2 ];
then
	echo "Installing Apache"
	sudo yum install -y httpd
else
	echo "Apache already installed - skipping"
fi

echo "Starting apache"
sudo apachectl start

#PHP 
# (dependency requirement for GitList)
echo "Installing PHP"
sudo yum install -y php

#GitList
# (A Git Repository Viewer)
echo "Downloading GitList"
sudo wget https://s3.amazonaws.com/gitlist/gitlist-0.5.0.tar.gz
echo "Extracting GitList"
sudo mv gitlist-0.5.0.tar.gz /var/www/html
cd /var/www/html/
sudo tar -xvzf gitlist-0.5.0.tar.gz
sudo rm gitlist-0.5.0.tar.gz

cd /var/www/html/gitlist
sudo mkdir cache
sudo chmod 777 cache

sudo mkdir /var/www/projects/

sudo mv config.ini-example config.ini
sudo sed 's%\/home\/git\/repositories%\/var\/www\/projects%g' config.ini

echo "Disabling SELinux"
sudo sed 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux


# At this point GitList should be installed 
# It is just a matter of configuration for use

# 1. Reboot VM after vagrant up - so vagrant up again after shutdown
# 2. Need to change /var/www/html's AllowOverride from None to All in the default Apache website config file
#    (CentOS this is /etc/httpd/conf/httpd.conf)
# 2. Restart Apache (sudo apachectl restart)




