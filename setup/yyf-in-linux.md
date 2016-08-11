Linux 上配置YYF环境
===================

以ubuntu 16.04 为例；
包括三个步骤:

1. [安装PHP](#php)
2. [编译配置YAF](#yaf)
3. [clone YYF源码运行](#yyf)

## 安装PHP {#php}

安装PHP和必要扩展(其中php-dev和gcc是编译yaf所需).扩展名称在不同系统名称可能有所不同

```bash
sudo apt install -y php php-mcrypt php-curl php-pdo-sqlite php-pdo-mysql php-dev gcc
```

## 编译和配置yaf {#yaf}

可以在[https://pecl.php.net/package/yaf](https://pecl.php.net/package/yaf)选择最新稳定版yaf编译(php7使用yaf 3.x版本,**php5使用 2.x版本**)

* Ubuntu 16.04默认使用PHP7，使用 __yaf-3.0.3__ 为例,可以根据需要换成对应版本号
* Ubuntu 16.04默认PHP扩展配置路径`/etc/php/7.0/cli/conf.d/`其他系统不一样，最后

```bash
#下载YAF,不同版本
curl https://pecl.php.net/get/yaf-3.0.3.tgz | tar zx -C ~/
#编译yaf
cd ~/yaf-3.0.3/; phpize;
./configure
make
# 安装yaf
sudo make install
#添加yaf.ini到PHP配置中，不同系统路径不同
sudo sh -c "echo 'extension=yaf.so\n[yaf]\nyaf.environ=dev'>/etc/php/7.0/cli/conf.d/yaf.ini"
```

## clone YYF源码和运行 {#yyf}

1. clone最新代码到工作目录,当然也可以直接下载zip解压

```bash
git clone https://github.com/YunYinORG/YYF.git
```

2.  执行`init.cmd`,配置环境

切换到项目目录执行
```bash
./init.cmd
```

正常情况,配置和清理完成后会出现如下选项
>
>select which development environment you want to use?
>  1) Use virtual Machine with vagrant;
>  2) Use local development (with PHP);
>  0) Exit;
>
>Input your choice (default[ENTER] is 1):
>

输入`2`回车(选择本地开发环境)即可配置和启动PHP测试服务器。


3. 快速启动脚本

初始化完成后会自动生成 `server.cmd`, 以后只需运行此脚本即可快速启用php测试服务器。

当然如果使用`apache`或者`nginx`作为服务器可以将web根目录设置为 `项目目录/public/` 即可

4. 测试服务

完成后浏览器打开 [127.0.0.1:1122](http://127.0.0.1:1122) 如果显示类似与[https://yyf.yunyin.org/](https://yyf.yunyin.org/)就配置OK了！