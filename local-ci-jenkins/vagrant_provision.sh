#!/usr/bin/env bash

# upating yum first
sudo yum update

# installing 'Extra Packages for Enterprise Linux'
# yum package manager does not have all latest software on its default repository
sudo yum install -y epel-release
sudo yum install -y wget
sudo yum install -y unzip

if [ ! -f /etc/init.d/jenkins ];
then
	echo "Installing Jenkins"

	# URL: http://localhost:6060
	# Home: /var/lib/jenkins
	# Start/Stop: /etc/init.d/jenkins
	# Config: /etc/default/jenkins
	# Jenkins log: /var/log/jenkins/jenkins.log
	wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
	sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
	sudo yum update
	sudo yum install -y jenkins

	sed -i 's/8080/6060/g' /etc/default/jenkins
	/etc/init.d/jenkins restart
else
	echo "Jenkins already installed - not Installing"
fi