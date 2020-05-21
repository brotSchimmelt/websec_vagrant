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
# passwd -e websec # websec needs to change password on first login

# # only needed if apache should run directly in the vm
# echo "install webserver ..."
# apt-get -y install apache2 php libapache2-mod-php mysql-server php-mysql
# rm /var/www/html/index.html
# mv /home/vagrant/websec /var/www/html/websec
# chown www-data /var/www/html/websec/databases

echo "install docker ..."
DEBIAN_FRONTEND=noninteractive apt-get install apt-transport-https ca-certificates curl software-properties-common -yq
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install docker-ce -yq
systemctl start docker
systemctl enable docker

echo "wait for docker ..."
sleep 30

echo "add user to group docker ..."
groupadd docker
usermod -aG docker websec

echo "instal docker compose ..."
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "copy files for webserver ..."
cp -r /home/vagrant/websec /home/websec/websec_backup
cp -r /home/vagrant/docker /home/websec/docker_backup
mv /home/vagrant/docker /home/websec/docker
mv /home/vagrant/websec /home/websec/docker/www

echo "copy authorized keys to new user ..."
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

--> Start the webserver with:
1. $ cd docker
2. $ docker-compose up -d


" >> /etc/motd

echo "reboot ..."
reboot
