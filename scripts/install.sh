#!/bin/bash
#   
#   Installiert den Apache Web Server
#

# Install apache, MariaDB Database Server, php, ftp, powershell, markdown to HTML
# siehe https://websiteforstudents.com/install-apache2-mariadb-and-php-7-2-with-phpmyadmin-on-ubuntu-16-04-18-04-18-10-lamp-phpmyadmin/
sudo apt-get update && sudo apt-get dist-upgrade && sudo apt-get autoremove
sudo apt-get install debconf-utils
sudo apt-get install -y apache2 php libapache2-mod-php vsftpd markdown mariadb-server mariadb-client
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
# update to PHP 7.2-FPM
sudo apt-get update
sudo apt-get install php7.2-fpm php7.2-common php7.2-mbstring php7.2-xmlrpc php7.2-soap php7.2-gd php7.2-xml php7.2-intl php7.2-mysql php7.2-cli php7.2-zip php7.2-curl

sudo apt-get install php-mbstring php-zip php-gd

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
echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" | sudo debconf-set-selections

sudo apt-get install -y phpmyadmin php-mbstring php-gettext

sudo phpenmod mcrypt
sudo phpenmod mbstring
sudo systemctl apache2 restart

# Home Verzeichnis unter http://<host>/data/ verfuegbar machen
mkdir -p /home/ubuntu/data/
sudo ln -s /home/ubuntu/data /var/www/html/data

cat <<%EOF% >/home/ubuntu/data/index.html
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Testseite $(hostname)</title>
</head>
<body>
<h1>Testseite $(hostname)</h1>
</body>
</html>
%EOF%

if [ -f README.md ]
then

cat <<%EOF% | sudo tee /var/www/html/index.html
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>$(hostname) Web UI</title>
<link rel="shortcut icon" href="https://kubernetes.io/images/favicon.png">
<meta charset="utf-8" content="">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these 
        
    <!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
    integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"
    integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
</head>
<body>
    <div class="container">
        $(markdown README.md)
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js" type="text/javascript"></script>
        <!-- Latest compiled and minified JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"
            type="text/javascript"></script>
         <script>
        // strip / bei Wechsel Port
        document.addEventListener('click', function(event) {
          var target = event.target;
          if (target.tagName.toLowerCase() == 'a')
          {
              var port = target.getAttribute('href').match(/^:(\d+)(.*)/);
              if (port)
              {
                 target.href = port[2];
                 target.port = port[1];
              }
          }
        }, false);
        </script>
    </div>
</body>
</html>
%EOF%

fi

sudo chmod -R g=u,o=u /home/ubuntu/data/
