#!/usr/bin/env bash

#yaf版本
YAF_VERSION=yaf-2.3.5

# install httpd mysql and php
# 安装 apache mysql和php gcc和git
sudo yum install -y httpd mysql mysql-server \ 
php php-opcache php-pdo_mysql php-mcrypt php-mbstring php-curl \
php-devel gcc git

# download yaf
# 下载解压yaf
curl https://pecl.php.net/get/${YAF_VERSION}.tgz | tar zx -C ./

# 编译安装 YAF
# compile and install YAF
cd ${YAF_VERSION}; phpize;
./configure && make && sudo make install

# 配置yaf
# configure yaf
sudo tee /etc/php.d/yaf.ini> /dev/null <<EOF
extension=yaf.so
[yaf]
# product environ in server
yaf.environ=product
# cache the config file
yaf.cache_config = 1
EOF

# configure the apache(httpd)
# 配置apache
sudo systemctl start httpd.service
sudo systemctl enable httpd
sudo firewall-cmd --permanent --add-service=http

# httpd webroot
# 配置 apache 根目录
sudo tee /etc/httpd/conf.d/yyf.conf> /dev/null <<EOF
DocumentRoot /var/www/YYF/public
<Directory "/var/www/YYF/public"> 
Options FollowSymLinks 
AllowOverride all 
# Require all granted  # for apache 2.4
</Directory>
EOF

# clone YYF
sudo chmod 755 /var/www
git clone https://github.com/YunYinORG/YYF.git clone /var/www/YYF
echo 0 | /var/www/YYF/init.cmd 

sudo service httpd restart