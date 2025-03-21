#! /bin/bash

sudo yum install git -y
sudo yum install docker -y
sudo systemctl start docker

if [ -d "addressbook" ]
then 
  echo "repo is already cloned"
  cd addressbook/
  git pull origin master 
else
    git clone https://github.com/nikhilk1234/addressbook.git
    cd addressbook/
fi
sudo docker build -t image /home/ec2-user/addressbook
