服务器上配置YYF生产环境
===================

"一键部署"
----------------------

* [Centos (rpm系列)](#centos): `curl -#L http://yyf.newfuture.cc/assets/code/server-centos.sh |bash`
* [Ubuntu (deb系列)](#ubuntu): `curl -#L http://yyf.newfuture.cc/assets/code/server-ubuntu.sh |bash`

对于“裸机”可以直接选择对应的系统运行后面的命令自动安装和配置(包括 apache,php,mysql或mariadb,和yaf扩展)。

注意: 服务器上使用生产环境(product)配置,同时配置文件会一直缓存在内存中(更新配置需重启PHP进程)。

1. Centos 上默认配置 {#centos}
------------------------

```bash
curl http://yyf.newfuture.cc/assets/code/server-centos.sh | bash
```
使用系统默源进行安装httpd和php和数据库,不同版本系统安装的结果会不一样。

组件 | centos 6.x | centos 7.x |
------|:---------:|:---------:|
httpd(apache) | 2.2 | 2.4 |
PHP 版本 | <=5.4   | 5.5 或5.6 |
数据库| mysql | mariadb  |



如果代码有误[可以在GITHUB上修改](https://github.com/NewFuture/yyf-book/edit/master/assets/code/server-centos.sh)

[import,server-centos.sh,lang-bash](../assets/code/server-centos.sh)


2. Ubuntu 上默认配置 {#ubuntu}
------------------------

```bash
curl http://yyf.newfuture.cc/assets/code/server-ubuntu.sh | bash
```

使用系统默源进行安装apache,msyql和PHP (ubuntu 16.04及以上会自动安装php7)


如果代码有误[可以在GITHUB上修改](https://github.com/NewFuture/yyf-book/edit/master/assets/code/server-ubuntu.sh)

[include,server-ubuntu.sh](../assets/code/server-ubuntu.sh)
