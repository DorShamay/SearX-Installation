#!/usr/bin/env bash

##################################################
# Creator: Dor Shamay                            #
# Version: 0.0.1                                 #
# Automation script for Searx Installation       #
##################################################

#check root

Checkroot()
{
if [ $(id -u) != "0" ]; then
		echo "You are not root , Exiting"
		exit 1;
	fi
}

Checkroot

#apt-get update
echo "Lets do some updates"
apt-get update -y

#Some dependencies that needed to be installed
Dependencies()
{
apt-get -y install software-properties-common python-software-properties
apt-get -y install git build-essential libxslt-dev python-dev python-virtualenv python-pybabel zlib1g-dev libffi-dev libssl-
FailCheck
Clonegit
FailCheck(Dependencies)
}

FailCheck(e)
{
if [ $? != "0" ]; then
		echo "Something went wrong with" (e)
    exit 1;
  fi
}

#Cd inside a local folder and clones the git project.
Clonegit()
{
  cd /usr/local
  git clone https://github.com/asciimoo/searx.git
  useradd searx -d /usr/local/searx
  sudo chown searx:searx -R /usr/local/searx
  Virtualenv
	FailCheck(Clonegit)
}

#Install all the misc on Virtualenv
Virtualenv()
{
sudo -u searx -i
cd /usr/local/searx
virtualenv searx-ve
../searx-ve/bin/activate
./manage.sh update_packages
sed -i -e "s/ultrasecretkey/`openssl rand -hex 16`/g" searx/settings.yml
exit
InstallDep
}

InstallDep()
{
  echo "Please Install some more Dependencies"
  apt-get -y install python-pip nano curl
  cd /usr/local/searx
  sudo pip install -r requirements.txt
  Test1
}

Test1()
{
  cd /usr/local/searx
  python searx/webapp.py
}
