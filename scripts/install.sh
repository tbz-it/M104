#!/bin/bash
#   
#   Installiert den Apache Web Server
#

# Install apache, MariaDB Database Server, php, ftp, powershell, markdown to HTML
# siehe https://websiteforstudents.com/install-apache2-mariadb-and-php-7-2-with-phpmyadmin-on-ubuntu-16-04-18-04-18-10-lamp-phpmyadmin/
sudo apt-get update && sudo apt-get dist-upgrade && sudo apt-get autoremove
sudo apt-get install debconf-utils
sudo apt-get install -y apache2 vsftpd markdown 
# php libapache2-mod-php 

sudo apt-get install mariadb-server mariadb-client

sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl enable apache2.service

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php

sudo apt-get update
sudo apt-get install php7.2-fpm php7.2-common php7.2-mbstring php7.2-xmlrpc php7.2-soap php7.2-gd php7.2-xml php7.2-intl php7.2-mysql php7.2-cli php7.2-zip php7.2-curl
sudo apt-get install php-mbstring php-gettext

# identical passwords to make handling easier
APP_PASS="passw0rd"
ROOT_PASS="passw0rd"
APP_DB_PASS="passw0rd"

echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASS" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ROOT_PASS" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections

# nötig?
# echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" | sudo debconf-set-selections

sudo apt-get install -y phpmyadmin 

cat <<%EOF% | sudo tee /etc/apache2/sites-available/m104.conf
<VirtualHost *:8080>
    DocumentRoot /data
    ErrorLog ${APACHE_LOG_DIR}/m104-error.log
    CustomLog ${APACHE_LOG_DIR}/m104-access.log combined
</VirtualHost>
%EOF%

a2dissite 000-default
a2ensite bticino
service apache2 reload
#sudo systemctl apache2 restart

# Introseite (= README dieses Repository)
bash -x /opt/lernmaas/helper/intro
