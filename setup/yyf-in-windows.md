Windows 上配置YYF环境
===================

1. 下载安装PHP
2. 下载配置YAF
3. 下载配置YYF

## 安装PHP

Windows版PHP下载地址：http://windows.php.net/download


## 配置YAF

YAF下载地址：https://pecl.php.net/package/yaf
对照PHP版本以及Thread Safety下载对应YAF dll文件
将dll文件放入相应PHP目录的ext文件夹下
在php.ini文件中加入 
```bash
extension=php_yaf.dll
```

## 配置YYF

1.下载zip解压

2.执行`init.cmd`,配置环境

正常情况,配置和清理完成后会出现如下选项：

>
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
>

输入`2`回车(选择本地开发环境)即可配置和启动PHP测试服务器。

3.快速启动脚本

初始化完成后会自动生成 `server.cmd`, 以后只需运行此脚本即可快速启用php测试服务器。

当然如果使用`apache`或者`nginx`作为服务器可以将web根目录设置为 `项目目录/public/` 即可

4.测试服务

完成后浏览器打开 [127.0.0.1:1122](http://127.0.0.1:1122) 如果显示类似与[https://yyf.yunyin.org/](https://yyf.yunyin.org/)就配置OK了！
