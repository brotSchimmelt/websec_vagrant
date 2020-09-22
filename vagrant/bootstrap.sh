#!/bin/bash

#########################################################################################
#   Purpose: Set up a webserver in the VM with the porject files.                       #
#   Test: Tested under Ubuntu 18 LTS                                                    #
#   Note: Not yet tested under Ubuntu 20 LTS                                            #
#                                                                                       #
#   Update packages and install better file explorer                                    #
#   Add new websec user                                                                 #
#   Either install Apache locally or isntall docker                                     #
#   Copy project files to home folder                                                   #
#   Add shh keys                                                                        #
#########################################################################################

echo "update packages ..."
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
apt-get autoremove -y

echo "install utilities ..."
apt-get -y install mc

echo "create new user ..."
useradd -m -s /bin/bash -G sudo,adm,cdrom,sudo,dip,plugdev,lxd websec
echo websec:websec | chpasswd

echo "copy authorized keys to new user ..."
sudo -i
mkdir /home/websec/.ssh/
cp /home/vagrant/.ssh/authorized_keys /home/websec/.ssh/authorized_keys
chmod 600 /home/websec/.ssh/authorized_keys
chown websec:websec /home/websec/.ssh/authorized_keys

echo "copy project files ..."
cp /home/vagrant/websec.tar /home/websec/websec.tar
mv /home/vagrant/websec.tar /home/websec/hacking_platform_backup.tar
tar -C /home/websec/ -xvf /home/websec/websec.tar
sleep 5
rm /home/websec/websec.tar

#########################################################################
#                                                                       #
#       Uncomment if apache should run locally in the VM (XOR)          #    
#                                                                       #
#########################################################################
# echo "install local apache webserver ..."
# apt-get -y install apache2 php libapache2-mod-php mysql-server php-mysql php7.2-mbstring

# echo "install sMTP ..."
# apt-get update && apt-get install msmtp -y

# echo "copy config files ..."
# mv /home/websec/websec/apache_php/msmtprc /etc/msmtprc
# chmod 600 /etc/msmtprc
# chown www-data:www-data /etc/msmtprc

# echo "copy projects files to /var/www/html ..."
# rm /var/www/html/index.html
# mv /home/websec/websec/www/* /var/www/html/
# rm -r /home/websec/websec
# chown www-data /var/www/html/data

# echo "set new document root ..."
# sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf
# sed -ri -e 's!/var/www/!/var/www/html/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# echo "configure php.ini ..."
# # Set mSMTP as the default MTA in the php.ini
# sed -i 's!;sendmail_path =!sendmail_path = /usr/bin/msmtp -t!g' /etc/php/7.2/apache2/php.ini
# # Make sure the PHP session cookie can not be accidently changed by JavaScript in the XSS challenge
# sed -i 's!session.cookie_httponly =!session.cookie_httponly =1!g' /etc/php/7.2/apache2/php.ini

# echo "restart apache ..."
# systemctl stop apache2
# sleep 5
# systemctl start apache2

# motdNote="Do not forget to configure a MySQL DB! You can use the SQL files in the docker version as a template."
##### END: apache section #####

#########################################################################
#                                                                       #
#       Uncomment if apache should run in a docker container (XOR)      #    
#                                                                       #
#########################################################################
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

echo "copy project files for apache docker container ..."
mv /home/websec/websec /home/websec/hacking_platform
# the www-data user needs to have ownership over the 'data' folder in order to create the SQLite DBs
chown www-data /home/websec/hacking_platform/www/data

echo "add user to group docker ..."
groupadd docker
usermod -aG docker websec

echo "instal docker compose ..."
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
motdNote="--> If you choose to install the webserver within docker, follow these steps:
1. $ cd hacking_platform
2. $ setup_docker.sh (only for the first setup)
3. $ docker-compose up -d"
##### END: docker section #####

touch /etc/motd
echo "
 _    _  ____  ____  ___  ____  ___ 
( \/\/ )( ___)(  _ \/ __)( ___)/ __)
 )    (  )__)  ) _ <\__ \ )__)( (__ 
(__/\__)(____)(____/(___/(____)\___)...test_server



Remember to change passwords for vagrant ('vagrant'),
root ('vagrant') and websec ('websec') as soon as possible!

$motdNote


" >> /etc/motd

echo "reboot ..."
reboot
