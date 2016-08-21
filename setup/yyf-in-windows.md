Windows 上配置YYF环境
===================

1. [下载PHP](#php)
2. [配置YAF](#yaf)
3. [下载配置YYF](#yyf)

## 1. 下载PHP {#php}

如果已有PHP或者安装了`WAMP`,可以跳过此步骤。

Windows版PHP下载地址：[http://windows.php.net/download](http://windows.php.net/download). 选择对应版本下载解压即可。


## 2. 配置YAF {#yaf}

YAF下载地址：[https://pecl.php.net/package/yaf](https://pecl.php.net/package/yaf)

对照PHP版本以及下载对应YAF，dll文件。 将dll文件放入相应PHP目录的ext文件夹下

并在`php.ini`文件(位于PHP目录,如果没有将`php.ini-development`改成`php.ini`)中加入

```ini
extension = php_yaf.dll

yaf.environ = dev;开发环境是dev,服务器生产环境使用production
```

## 3. 下载YYF {#yyf}

1.clone [https://github.com/YunYinORG/YYF.git](https://github.com/YunYinORG/YYF.git) 或者下载zip解压

2.双击`init.cmd`

正常情况,配置和清理完成后会出现如下选项：


>select which development environment you want to use?
>
>  1) Use virtual Machine with vagrant;
>
>  2) Use local development (with PHP);
>
>  0) Exit;
>
>
>Input your choice (default[ENTER] is 1):


输入`2`回车(选择本地开发环境).

如果php在系统目录下会自动创建启动脚本,否则需要`输入PHP的路径`(可以直接将php.exe拖拽到命令行:)

即可配置和启动PHP测试服务器。

3.快速启动脚本

初始化完成后会自动生成 `server.cmd`, 以后只需运行此脚本即可快速启用php测试服务器。

(当然如果使用`apache`或者`IIS`等作为服务器可以将,YYF 放于web根目录下即可。)

4.测试服务

完成后浏览器打开 [localhost:1122](http://localhost:1122) 如果显示类似与[https://yyf.yunyin.org/](https://yyf.yunyin.org/)就配置OK了！
