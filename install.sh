#update & upgrade
apt update
apt -y upgrade
# install all dependencies required to build Asterisk on Ubuntu
add-apt-repository universe
apt -y install git curl wget libnewt-dev libssl-dev libncurses5-dev subversion libsqlite3-dev build-essential libjansson-dev libxml2-dev  uuid-dev
#download Asterisk 18 tarball
apt policy asterisk
#use wget command to download archive file
cd ~
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz
#Extract the file with tar
tar xvf asterisk-18-current.tar.gz
#Run the following command to download the mp3 decoder library into the source tree
cd asterisk-18*/
contrib/scripts/get_mp3_source.sh
#all dependencies are resolved
contrib/scripts/install_prereq install
#Build and Install Asterisk 18 on Ubuntu 22.04 & Run the configure script to satisfy build dependencies.
./configure
# select menu options
make menuselect
make
make install
make progdocs
# install configs and samples
make samples
make config
ldconfig
# For a sample basic PBX
make basic-pbx
# Create a separate user and group to run asterisk services
groupadd asterisk
useradd -r -d /var/lib/asterisk -g asterisk asterisk
usermod -aG audio,dialout asterisk
chown -R asterisk.asterisk /etc/asterisk
chown -R asterisk.asterisk /var/{lib,log,spool}/asterisk
chown -R asterisk.asterisk /usr/lib/asterisk
chmod -R 750 /var/{lib,log,run,spool}/asterisk /usr/lib/asterisk /etc/asterisk
#Uncomment AST_USER and AST_GROUP to look like below
 vim /etc/default/asterisk
The user & group to run as
vim /etc/asterisk/asterisk.conf
# Restart asterisk service after making the changes:
systemctl restart asterisk
# Enable asterisk service to start on system  boot:
systemctl enable asterisk
#Check service status
systemctl status asterisk
#connect to Asterisk Command Line interface.
asterisk -rvv
# If you have an active ufw firewall
ufw allow proto tcp from any to any port 5060,5061
