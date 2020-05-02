#!/bin/bash

echo "update packages ..."
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
apt-get autoremove -y

echo "install utilities ..."
apt-get -y install mc

echo "create new user ..."
useradd -m -s /bin/bash -G sudo,adm,cdrom,sudo,dip,plugdev,lxd websec
echo websec:websec | chpasswd
# passwd -e websec


echo "install webserver ..."
apt-get -y install apache2 php libapache2-mod-php mysql-server php-mysql

rm /var/www/html/index.html

# echo "install docker ..."
# apt-get install apt-transport-https ca-certificates curl software-properties-common
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# apt-get update
# apt-get install docker-ce
# systemctl start docker
# systemctl enable docker

cp -r /home/vagrant/websec /home/websec/websec_backup
mv /home/vagrant/websec /var/www/html/websec
# TODO: chmod to make database writeable

# copy authorized keys to new user
sudo -i
mkdir /home/websec/.ssh/
cp /home/vagrant/.ssh/authorized_keys /home/websec/.ssh/authorized_keys
chmod 600 /home/websec/.ssh/authorized_keys
chown websec:websec /home/websec/.ssh/authorized_keys

touch /etc/motd
echo "

 _    _  ____  ____  ___  ____  ___ 
( \/\/ )( ___)(  _ \/ __)( ___)/ __)
 )    (  )__)  ) _ <\__ \ )__)( (__ 
(__/\__)(____)(____/(___/(____)\___)...dev_server



Remember to change passwords for vagrant ('vagrant'),
root ('vagrant') and websec ('websec') as soon as possible!


" >> /etc/motd

echo "reboot ..."
reboot
