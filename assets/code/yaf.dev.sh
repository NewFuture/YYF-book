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
# 开发环境PHP配置
PHP_INI=$("$PHP_PATH" --ini|grep -oPm1  "/.*php\.ini$"|sed -r -e 's/cli/*/')
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
PHP_VERSION=$("$PHP_PATH" -v|grep -oP "(?<=^PHP\W)\d\.\d\.\d+");
if [[ ${PHP_VERSION} == "7."* ]]; then
    YAF_VERSION=yaf-3.0.4 #php 7
else
    YAF_VERSION=yaf-2.3.5 #php 5 
fi;

# 下载解压yaf | download yaf
echo "downloading YAF ${YAF_VERSION} [下载解压 yaf] ..."
curl -#SL https://pecl.php.net/get/${YAF_VERSION}.tgz | tar zx -C "$TEMP_PATH"
# 编译YAF 
echo "compile YAF [编译 YAF] ..."
cd "${TEMP_PATH}${YAF_VERSION}" && phpize;
PHP_CONFIG_PATH=$(command -v "${PHP_PATH}-config" 2>/dev/null)
if [ -z "$PHP_CONFIG_PATH" ]; then
    ./configure >"${TEMP_PATH}yaf.configure.log"
    make >>"${TEMP_PATH}yaf.configure.log"
    # 复制到PHP扩展目录
    PHP_LIB_PATH=$("$PHP_PATH" -i|grep -oPm1 "(?<=^extension_dir\W=>\W)(['\"]?(/+[^/\\\\:*?'\"<>=|\^]*)+/?['\"]?)(?=\W=>)")
    echo "copye yaf.so to php extension dir ${PHP_LIB_PATH} [安装 YAF 到 ${PHP_LIB_PATH}] ..."
    CHECK_SUDO $PHP_LIB_PATH
    $SUDO cp "${TEMP_PATH}${YAF_VERSION}/modules/yaf.so" "$PHP_LIB_PATH"
else
    ./configure --with-php-config="$PHP_CONFIG_PATH" >"${TEMP_PATH}yaf.configure.log"
    make >>"${TEMP_PATH}yaf.configure.log"
    echo "install yaf"
    CHECK_SUDO $("$PHP_CONFIG_PATH" --extension-dir)
    $SUDO make install
fi;


#配置YAF
# 获取 PHP ini 配置目录
# Scan for additional .ini path
PHP_ADD_INI=$("$PHP_PATH" --ini|grep -oPm1 "(?<=Scan for additional \.ini files in:).*"|sed -r -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

if [ -d "$PHP_ADD_INI" ]; then
# use additional ini path

## 创建yaf配置文件
## create temp yaf file
cat <<EOF>"$TEMP_PATH/yaf.ini"
extension=yaf.so
[yaf]
yaf.environ=$ENVIRON
yaf.cache_config=$CACHE_CONIFG
EOF

    CHECK_SUDO $PHP_ADD_INI
    PHP_ADD_INI="$(sed -e 's/\/cli\//\/*\//' <<< ${PHP_ADD_INI})"
    # 复制配置文件到各个目录
    echo "copy the configure to each file to $PHP_ADD_INI [复制yaf.ini到扩展配置目录]" 
    echo $PHP_ADD_INI | xargs -n 1 $SUDO cp "${TEMP_PATH}yaf.ini" 
    # 删除临时文件
    # remove temp ini
    rm "${TEMP_PATH}yaf.ini"
else
# use single php.ini
    PHP_INI_PATH=$("$PHP_PATH" --ini|grep -oPm1 "(?<=Loaded Configuration File:).*"|sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    echo "configure yaf in $PHP_INI_PATH"
    CHECK_SUDO $PHP_INI_PATH
    if [ $(cat "$PHP_INI_PATH" | grep -c "^\s*extension\s*=\s*yaf.so") -eq 0 ] ; then 
       $SUDO bash -c "echo 'extension=yaf.so' >> '$PHP_INI_PATH'"
    fi;
    CHANGE_INI $PHP_INI_PATH yaf.environ $ENVIRON
    CHANGE_INI $PHP_INI_PATH yaf.cache_config $CACHE_CONIFG
fi;
