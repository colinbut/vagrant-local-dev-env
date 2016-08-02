#!/usr/bin/env bash

# upating yum first
sudo yum update

# installing 'Extra Packages for Enterprise Linux'
# yum package manager does not have all latest software on its default repository
sudo yum install -y epel-release
sudo yum install -y wget
sudo yum install -y unzip

echo "Downloading Sonar"
wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-5.6.zip

echo "Unpacking Sonar"
unzip sonarqube-5.6.zip

echo "Installing Sonar"
mv -v sonarqube-5.6 /opt/sonar

echo "Starting Sonar Server"
sudo /opt/sonar/bin/linux-x86-64/sonar.sh start