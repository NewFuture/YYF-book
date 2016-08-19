#!/usr/bin/env bash
sudo apt install -y apache2 libapache2-mod-php mysql-server \
php php-mcrypt php-curl php-pdo-sqlite php-pdo-mysql \
php-dev gcc git

# httpd webroot
# 配置 apache 根目录
sudo tee /etc/apache2/sites-available/yyf.conf> /dev/null <<EOF
DocumentRoot /var/www/YYF/public
<Directory "/var/www/YYF/public"> 
Options FollowSymLinks 
AllowOverride all 
Require all granted  
</Directory>
EOF

./configure && make && make install
sudo a2ensite yyf.conf
sudo a2dissite  000-default.conf
sudo a2enmod php*
sudo a2enmod rewrite

#################################
### YAF EXTENTSION
################################

# 检查PHP版本
PHP_VERSION=$(php -v|grep --only-matching --perl-regexp "\W\d\.\d+\.\d+");
if [[ ${PHP_VERSION} == "5."* ]]; then 
    YAF_VERSION=yaf-2.3.5
else 
    YAF_VERSION=yaf-3.0.3
fi

# download yaf
# 下载解压yaf
curl https://pecl.php.net/get/${YAF_VERSION}.tgz | tar zx -C ~/
cd ~/${YAF_VERSION}; phpize;

# 编译安装 YAF
# compile and install YAF
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

# clone YYF and initialize
# clone 代码  初始化
sudo chmod 755 /var/www
git clone https://github.com/YunYinORG/YYF.git clone /var/www/YYF
echo 0 | /var/www/YYF/init.cmd 

sudo service apache2 restart