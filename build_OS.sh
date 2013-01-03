#!/bin/bash

##############################
#####  Pre-Fabric Stuff  #####
##############################
# Add $(hostname) to /etc/hosts
sudo sed -i -e "s/localhost/localhost $(hostname)/" /etc/hosts
##############################

#############################
########  CBL Stuff  ########
#############################
cd /mnt
sudo mkdir CBL_build
sudo chown ubuntu CBL_build
cd CBL_build
mkdir tmp
export TMPDIR=/mnt/CBL_build/tmp
cd
ln -s /mnt/CBL_build/tmp/
cd /mnt/CBL_build


sudo apt-get update
sudo apt-get -y install python-setuptools python-dev ssh git-core
sudo easy_install fabric pyyaml
git config --global url."http://".insteadOf git://
#git clone git://github.com/chapmanb/cloudbiolinux.git
git clone https://github.com/nathanhaigh/cloudbiolinux.git
cd cloudbiolinux

# install some R/BioC dependencies which don't build via CRAN
sudo apt-get -y install r-cran-rgl r-cran-rmysql
# AMOS dependencies
sudo apt-get -y install libqt4-dev libstatistics-descriptive-perl libdbi-perl

# Allow password SSH - required for fabric script
sudo sed -i -e 's@PasswordAuthentication no@PasswordAuthentication yes@' /etc/ssh/sshd_config
sudo service ssh reload

# ensure the current user (ubuntu) has a password set - needed for running the fabric script
# sudo passwd
# Add the ngstrainee user
# sudo adduser ngstrainee

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/boost/lib  # required to run cufflinks-dev and tophat-dev
export NETCDF_INCLUDE=/usr/include/                     # required for building ncdf R package
fab -f fabfile.py -H localhost -c contrib/ngs_workshop/fabricrc.txt install_biolinux:packagelist=contrib/ngs_workshop/main.yaml
#############################


###############################
#####  Post-Fabric Stuff  #####
###############################
# Install the FreeNX Server and update the default configuration
# Any user with SSH access can use NX into the machine
sudo ~/configure_freenx.sh
sudo ssh-keygen -f "/var/lib/nxserver/home/.ssh/known_hosts" -R 127.0.0.1
sudo sed -i -e 's/^.\(ENABLE_SSH_AUTHENTICATION\)="."$/\1="1"/' /etc/nxserver/node.conf
sudo sed -i -e 's/^.\(NX_LOG_LEVEL\)=.$/\1=6/' /etc/nxserver/node.conf
sudo sed -i -e 's/^#\(NX_LOGFILE\)/\1/' /etc/nxserver/node.conf
sudo sed -i -e "s/^#\(COMMAND_START_GNOME='gnome-session --session gnome-fallback'\)/\1/" /etc/nxserver/node.conf
# types of sessions available can be see in /usr/share/gnome-session/sessions

sudo service ssh reload
sudo nxserver --restart

sudo apt-get install dos2unix pigz pbzip2
