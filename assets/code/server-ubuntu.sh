#!/bin/bash
sudo apt install -y apache2 libapache2-mod-php php

sudo tee /etc/apache2/sites-available/yyf.conf> /dev/null <<EOF
DocumentRoot /var/www/YYF/public
<Directory "/var/www/YYF/public"> 
Options FollowSymLinks 
AllowOverride all 
Require all granted  
</Directory>
EOF

sudo a2ensite yyf.conf
# sudo a2dissite  000-default.conf

sudo a2enmod php*
sudo a2enmod rewrite
sudo service apache2 restart