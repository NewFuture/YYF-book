#!/usr/bin/env bash

PROJECT_PATH="/var/www/YYF"
TEMP_PATH="/tmp/"

#################################
###[LAMP]
### 安装 apache php mysql
################################


sudo apt install -y apache2 libapache2-mod-php \ #apache
php php-mcrypt php-curl  \ #php
mysql-server php-pdo-sqlite php-pdo-mysql \ # mysql
php-dev gcc git # php扩展

# httpd webroot
# 配置 apache 根目录
sudo tee /etc/apache2/sites-available/yyf.conf> /dev/null <<EOF
DocumentRoot "${PROJECT_PATH}/public"
<Directory "${PROJECT_PATH}/public"> 
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
###[YAF_EXTENTSION]
### 安装 yaf
################################
# 获取PHP版本
# GET PHP version
PHP_VERSION=$(php -v|grep --only-matching --perl-regexp "\W\d\.\d+\.\d+");
if [[ ${PHP_VERSION} == "7."* ]]; then
    #php 7
    YAF_VERSION=yaf-3.0.3
else
    #php 5 
    YAF_VERSION=yaf-2.3.5
fi;

# download yaf
# 下载解压yaf
curl https://pecl.php.net/get/${YAF_VERSION}.tgz | tar zx -C $TEMP_PATH
cd $TEMP_PATH${YAF_VERSION}; phpize;

# 编译安装 YAF
# compile and install YAF
./configure && make && sudo make install


## 创建yaf配置文件
## create temp yaf file
cat <<EOF>${TEMP_PATH}yaf.ini
extension=yaf.so
[yaf]
# product environ in server
yaf.environ=product
# cache the config file
yaf.cache_config = 1
EOF
# 获取 PHP ini 配置目录
# Scan for additional .ini path
PHP_INI_PATH=$($PHP_PATH --ini|grep --only-matching --perl-regexp  "/.*\.d$")
PHP_INI_PATH=$(echo $PHP_INI_PATH | sed -r -e 's/cli/*/')
# 复制配置文件到各个目录
# cp the yaf configure to each file 
echo $PHP_INI_PATH | xargs -n 1 sudo cp $TEMP_PATH/yaf.ini 
# 删除临时文件
# remove temp ini
rm ${TEMP_PATH}yaf.ini

#################################
###[YYF]
### 下载YYF
################################
# clone YYF and initialize
# clone 代码  初始化
sudo chmod 755 /var/www
git clone https://github.com/YunYinORG/YYF.git ${PROJECT_PATH}
echo 0 | {$PROJECT_PATH}/init.cmd 
#重启apache服务器
#restart apache
sudo service apache2 restart