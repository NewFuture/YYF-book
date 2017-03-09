使用Docker运行YYF
===================

YYF 提供了基于集成运行环境的超小docker镜像: [YYF-docker](https://github.com/NewFuture/YYF-docker)

如果使用docker或者系统支持docker可用采用此方法快速部署开发环境。

* [演示demo(13M)](#demo)
* [完整YYF环境(60M)](#full)
* [最小运行环境(12M)](#mini)

1. 演示demo {#demo}
-------------
demo中包含仓库代码(不一定最新)
```bash
docker run -it --rm -p 1122:80 newfuture/yyf:demo
```
访问 [localhost:1122](http://localhost:1122)即可看到demo效果.(可以将`1122`修改为其他端口)

2. 完整YYF开发环境 {#full}
-----------------

完整YYF docker除了上述的php环境，还集成下列服务了:
* redis
* memcached
* sqlite
* mariadb 和 mariadb-client

体积： 大约60M [![](https://images.microbadger.com/badges/image/newfuture/yyf.svg)](https://microbadger.com/images/newfuture/yyf "Get your own image badge on microbadger.com")

使用方式： 在项目目录下运行
> `sudo docker run -it --rm -p 1122:80 -v "$(pwd)":/yyf newfuture/yyf`

更多"食用方式“参看仓库地址：[https://github.com/NewFuture/YYF-docker](https://github.com/NewFuture/YYF-docker)


3. 最小YAF的docker环境 {#mini}
----------------
最小YAF的docker环境仅集成了YAF和php的基本环境，如果不包含数据等，可用使用此镜像开发或者演示。

基本的YAFdocker仅包含PHP和必要的扩展:
* YAF
* redis
* memcached
* PDO-*
* mcrypt
* curl
* gd

体积： 约12~13M [![](https://images.microbadger.com/badges/image/newfuture/yaf.svg)](https://microbadger.com/images/newfuture/yaf "Get your own image badge on microbadger.com")

使用方式: 在工程目录下运行
> `sudo docker run -it --rm -p 1122:80 -v "$(pwd)":/yaf newfuture/yaf`

更多"食用方式“参看仓库地址: [https://github.com/NewFuture/YAF-docker](https://github.com/NewFuture/YAF-docker)