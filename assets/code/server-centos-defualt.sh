#!/usr/bin/env bash

PROJECT_PATH="/var/www/YYF"
TEMP_PATH=$HOME
CONF_PATH="/etc/httpd/conf/httpd.conf"

# sudo yum -y update
# install httpd mysql and php
# 安装 apache mysql和php gcc和git
sudo yum install -y httpd \
mysql mysql-server mariadb mariadb-server \ 
php php-opcache php-pdo_mysql php-mcrypt php-mbstring php-curl \
php-devel gcc git

#判断yaf版本和php版本
PHP_VERSION=$($PHP_PATH -v|grep --only-matching --perl-regexp "\W\d\.\d+\.\d+");
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

# 编译安装 YAF
# compile and install YAF
cd ${TEMP_PATH}/${YAF_VERSION}; phpize;
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
sudo cp $CONF_PATH ${CONF_PATH}.back
sudo sed -i.back -e "s|\"/var/www/html\"|\"${PROJECT_PATH}/public\"|g" $CONF_PATH 

# clone YYF and initialize
# clone 代码  初始化
if [ ! -f $PROJECT_PATH ]; do
    sudo mkdir -p ${PROJECT_PATH}
fi;
sudo chmod 755 ${PROJECT_PATH}

git clone https://github.com/YunYinORG/YYF.git clone ${PROJECT_PATH}
echo 0 | ${PROJECT_PATH}/init.cmd 

sudo service httpd restart