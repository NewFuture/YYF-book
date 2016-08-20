#!/usr/bin/env bash

PROJECT_PATH="/var/www/YYF"
TEMP_PATH="/tmp/"

echo " UPDATE..."
sudo apt update  
#&>$TEMP_PATH/yyf_install.log

#################################
###[LAMP]
### 安装 apache php
################################

#apache 
echo "INSTALL apache"
sudo apt-get -y install apache2 gcc git &>>$TEMP_PATH/yyf_install.log

echo "INSTALL php"
#php7
sudo apt-get -y install php php-mcrypt php-curl php-pdo-sqlite php-pdo-mysql php-dev libapache2-mod-php &>>$TEMP_PATH/yyf_install.log
#php5
sudo apt-get -y install php5 php5-mcrypt php5-curl php5-sqlite php5-mysql php5-dev libpcre3-dev &>>$TEMP_PATH/yyf_install.log


# httpd webroot
sudo tee /etc/apache2/sites-available/yyf.conf> /dev/null <<EOF
DocumentRoot "${PROJECT_PATH}/public"
<Directory "${PROJECT_PATH}/public"> 
Options FollowSymLinks 
AllowOverride all 
Require all granted  
</Directory>
EOF

sudo a2ensite yyf.conf
sudo a2dissite  000-default.conf
sudo a2enmod php*
sudo a2enmod rewrite

#################################
###[YAF_EXTENTSION]
################################
# check PHP version
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
# 编译安装 YAF
# compile and install YAF
cd $TEMP_PATH${YAF_VERSION} && phpize
./configure && make && sudo make install


## 创建yaf配置文件(product 环境)
## create temp yaf conifg with product environment
cat <<EOF>${TEMP_PATH}yaf.ini
extension=yaf.so
[yaf]
yaf.environ=product
yaf.cache_config = 1
EOF

# 获取 PHP ini 配置目录
# Scan for additional .ini path
PHP_INI_PATH=$(php --ini|grep --only-matching --perl-regexp  "/.*\.d$")
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
if [ ! -f $PROJECT_PATH ]; then
    sudo mkdir -p ${PROJECT_PATH}
fi;

sudo chown $UID ${PROJECT_PATH}
git clone https://github.com/YunYinORG/YYF.git ${PROJECT_PATH}
echo 0 | ${PROJECT_PATH}/init.cmd

#重启apache服务器
#restart apache
sudo service apache2 restart

MYSQL_SERVER=$(dpkg -l | grep -c "mysql-server")
if [ ${MYSQL_SERVER} -gt 1 ]  ;then
    echo "mysql-server was installed"
else
    echo "INSTALL mysql-server"
    # 静默安装mysql,不显示密码框
    echo mysql-server mysql-server/root_password password | sudo debconf-set-selections
    echo mysql-server mysql-server/root_password_again password | sudo debconf-set-selections
    sudo apt install -y  mysql-server
fi;