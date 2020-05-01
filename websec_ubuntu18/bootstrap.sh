#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get -y install mc

useradd -m -s /bin/bash -G sudo,adm,cdrom,sudo,dip,plugdev,lxd websec
echo websec:websec | chpasswd
passwd -e websec

mv /home/vagrant/cleanup.sh /home/websec/cleanup.sh
mv /home/vagrant/packages_websec.txt /home/websec/packages_websec.txt

apt-get -y install apache2 php libapache2-mod-php mysql-server php-mysql

rm /var/www/html/index.html

# apt-get install apt-transport-https ca-certificates curl software-properties-common
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# apt-get update
# apt-get install docker-ce
# systemctl start docker
# systemctl enable docker

mv /home/vagrant/websec /var/www/html/websec
# change mod to make database writeable

touch /etc/motd

echo "


 (  (               )                
 )\))(   '   (   ( /(        (       
((_)()\ )   ))\  )\()) (    ))\  (   
_(())\_)() /((_)((_)\  )\  /((_) )\  
\ \((_)/ /(_))  | |(_)((_)(_))  ((_) 
 \ \/\/ / / -_) | '_ \(_-</ -_)/ _|  
  \_/\_/  \___| |_.__//__/\___|\__|  


" >> /etc/motd

reboot
