#!/usr/bin/env bash
#####################
## 自动编译安装YAF 开发环境[dev]
#####################
PHP_PATH=${PHP_PATH:=php}
TEMP_PATH=${TEMP_PATH:="/tmp/"}
ENVIRON="dev"
CACHE_CONIFG=0

#检查文件目录权限
CHECK_SUDO(){
if [ -w "$1" ]; then 
    SUDO="";
else
    echo "run as SUDO to write in $1 [以SUDO权限写入$1]"
    SUDO="sudo"
fi;
}

# 修改配置文件： 文件  键   值
# CHANGE_INI   $file $key $value
CHANGE_INI(){
if [ $(cat "$1" | grep -c "^\s*$2") -eq 0 ] ; then
   $SUDO bash -c "echo '$2=$3' >> '$1'"
else
   $SUDO sed -i.bak -e "s/^\s*$2.*$/$2=$3/" "$1"
fi;
}

# 修改断PHP配置
# 生产环境PHP配置
PHP_INI=$("$PHP_PATH" --ini|grep -m1 --only-matching --perl-regexp  "/.*php\.ini$"|sed -r -e 's/cli/*/')
echo "change php.ini for DEVELOPMENT environment in $PHP_INI [修改php配置为dev开发环境]"
PHP_INI=($PHP_INI) 
for ini in ${PHP_INI[@]};do
    CHECK_SUDO $ini 

    CHANGE_INI $ini display_errors 1
    CHANGE_INI $ini display_startup_errors 1
    CHANGE_INI $ini log_errors 1

    CHANGE_INI $ini assert.active 1	 
    CHANGE_INI $ini zend.assertions 1
done

# 获取PHP版本
# GET PHP version
PHP_VERSION=$("$PHP_PATH" -v|grep --only-matching --perl-regexp "\d\.\d+\.\d+"|head -1);
if [[ ${PHP_VERSION} == "7."* ]]; then
    YAF_VERSION=yaf-3.0.3 #php 7
else
    YAF_VERSION=yaf-2.3.5 #php 5 
fi;

# 下载解压yaf | download yaf
echo "downloading YAF ${YAF_VERSION} [下载解压 yaf] ..."
curl https://pecl.php.net/get/${YAF_VERSION}.tgz | tar zx -C "$TEMP_PATH"
# 编译YAF 
echo "compile YAF [编译 YAF] ..."
cd "${TEMP_PATH}/${YAF_VERSION}" && phpize;
PHP_CONFIG_PATH=$(command -v "${PHP_PATH}-config" 2>/dev/null)
if [ -z "$PHP_CONFIG_PATH" ]; then
    ./configure >"$TEMP_PATH/yaf.configure.log"
else
    ./configure --with-php-config="$PHP_CONFIG_PATH" >"$TEMP_PATH/yaf.configure.log"
fi;
make >>"$TEMP_PATH/yaf.configure.log"

# 复制到PHP扩展目录
PHP_LIB_PATH=$("$PHP_PATH" -i | grep -o -m1 "^extension_dir.*=>.*=>" | grep -m1 -o -P "(['\"](/+[^/\\\\:*?'\"<>=|\^]*)+/?['\"])|((/+[^/\\\\:*?'\"<>=|\s\^]*)+/?)" | tail -1)
echo "copye yaf.so to php extension dir ${PHP_LIB_PATH} [安装 YAF 到 ${PHP_LIB_PATH}] ..."
CHECK_SUDO $PHP_LIB_PATH
$SUDO mv "${TEMP_PATH}/${YAF_VERSION}/modules/yaf.so" "$PHP_LIB_PATH/"


## 创建yaf配置文件
## create temp yaf file
cat <<EOF>"$TEMP_PATH/yaf.ini"
extension=yaf.so
[yaf]
yaf.environ=$ENVIRON
yaf.cache_config=$CACHE_CONIFG
EOF
# 获取 PHP ini 配置目录
# Scan for additional .ini path
PHP_INI_PATH=$("$PHP_PATH" --ini|grep --only-matching --perl-regexp  "/.*\.d$"|sed -r -e 's/cli/*/')
# 复制配置文件到各个目录
echo "copy the configure to each file to $PHP_INI_PATH [复制yaf.ini到扩展配置目录]" 
CHECK_SUDO $PHP_INI_PATH
echo $PHP_INI_PATH | xargs -n 1 $SUDO cp "$TEMP_PATH/yaf.ini" 

# 删除临时文件
# remove temp ini
rm "$TEMP_PATH/yaf.ini"