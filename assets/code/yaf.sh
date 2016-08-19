#!/usr/bin/env bash

PHP_PATH=php
TEMP_PATH=$HOME

#####################
## 编译安装YAF
#####################
install_yaf(){
    # 获取PHP版本
    # GET PHP version
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
    curl https://pecl.php.net/get/${YAF_VERSION}.tgz | tar zx -C ~/
    cd ~/${YAF_VERSION}; phpize;

    # 编译安装 YAF
    # compile and install YAF
    ./configure && make && sudo make install


## 创建yaf配置文件
## create temp yaf file
cat <<EOF>$TEMP_PATH/yaf.ini
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
    rm $TEMP_PATH/yaf.ini
}


# YAF_MODULES=$($PHP_PATH -m|grep -c -w yaf)
# if $YAF_MODULES ; then
#     echo 'YAF already exists!' 
# else
#     install_yaf
# fi;

install_yaf




