#!/bin/bash

#ssh -i ~/.ssh/ opc@152.67.52.116
#hostnamectl
#Operating System: CentOS Linux 7 (Core)
#CPE OS Name: cpe:/o:centos:centos:7
#Kernel: Linux 3.10.0-1127.19.1.el7.x86_64
#Architecture: x86-64
#sudo umount -f /mnt/fsphotopop

sudo yum -y install git

git clone git@github.com:photopopbr/ead.git

#install php  7.2
sudo yum -y install epel-release
sudo yum-config-manager --enable remi-php72
sudo yum -y update
sudo yum -y install php php-zip php72-php-pecl-zip.x86_64 php-pecl-zip.x86_64

#install php  7.0.33
#sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
#sudo yum -y install php70w php70w-curl php70w-gd php70w-intl php70w-ldap php70w-mysql php70w-pspell php70w-xml php70w-xmlrpc php70w-zip php70w-common php70w-opcache php70w-mbstring php70w-soap


#install and configure mysql
sudo rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo yum -y install mysql-server
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service 

mysql -u root -p
create database moodle;
SET GLOBAL innodb_file_format=Barracuda;
SET GLOBAL innodb_large_prefix=1;


grant all privileges on moodle.* to 'moodle'@'localhost' identified by 'redhat';

sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm 
sudo  yum -y --enablerepo=remi install httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service

cd /var/www/html
sudo wget http://sourceforge.net/projects/moodle/files/Moodle/stable39/moodle-latest-39.tgz
sudo tar -zxvf moodle-latest-39.tgz
#sudo wget https://download.moodle.org/stable36/moodle-3.6.3.tgz	
#sudo tar -zxvf moodle-3.6.3.tgz 
sudo chmod -R 755 /var/www/html/moodle
sudo chown -R apache.apache /var/www/html/moodle
sudo mkdir /var/www/html/moodledata
sudo chmod -R 777 /var/www/html/moodledata
sudo chown -R apache.apache /var/www/html/moodledata
sudo chcon -Rv --type=httpd_sys_rw_content_t /var/www/html/
sudo touch /etc/httpd/conf.d/moodle.ead.com.conf
sudo sh -c "echo -e '<VirtualHost *:80>\n\tServerName moodle.ead.com\n\tDocumentRoot /var/www/html/moodle\n\tErrorLog /var/log/httpd/moodle.ead.com_error_log\n\tCustomLog /var/log/httpd/moodle.ead.com_access_log combined\n\tDirectoryIndex index.html index.htm index.php index.php4 index.php5\n\t<Directory /var/www/html/moodle>\n\t\tOptions -Indexes +IncludesNOEXEC +SymLinksIfOwnerMatch\n\t\tAllow from all\n\t\tAllowOverride All Options=ExecCGI,Includes,IncludesNOEXEC,Indexes,MultiViews,SymLinksIfOwnerMatch\n\t</Directory>\n</VirtualHost>' >  /etc/httpd/conf.d/moodle.ead.com.conf"
sudo systemctl restart httpd

#Oracle Cloud
#https://stackoverflow.com/questions/54794217/opening-port-80-on-oracle-cloud-infrastructure-compute-node
#sudo firewall-cmd --zone=public --permanent --add-port=80/tcp
#sudo firewall-cmd --reload


