Linux 上配置YYF环境
===================

1. 安装PHP

  sudo apt install -y php php-mcrypt php-curl php-pdo-sqlite php-pdo-mysql php-dev

2. 编译和配置yaf

    sudo apt install -y gcc
    
    curl -o yaf.tgz https://pecl.php.net/get/yaf-3.0.3.tgz
    
    tar zxvf yaf.tgz
    
    cd yaf-3.0.3/
    
    phpize
    
    ./configure
    
    make
    
    sudo make install
  
    \#add yaf to php.ini
    
    sudo sh -c "echo 'extension=yaf.so\n[yaf]\nyaf.environ=product'>/etc/php/7.0/cli/conf.d/yaf.ini"

3. clone 源码和运行

    git clone https://github.com/YunYinORG/YYF.git
    
    \#进入项目目录
    
    ./init.cmd

    ./server.cmd

    访问：127.0.0.1:1122
