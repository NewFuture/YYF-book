---
description: YYF 开发文档,一个高效 安全 简单的PHP RESTful 框架使用指南
---
YYF-book
==========
YYF 开发文档

Documentation for YUNYIN YAF Framework
* YYF框架: <https://github.com/YunYinORG/YYF/>
* 文档网址: [https://yyf.newfuture.cc](https://yyf.newfuture.cc)
* 文档源码: [https://github.com/NewFuture/yyf-book](https://github.com/NewFuture/yyf-book)
* PDF版下载: <https://www.gitbook.com/download/pdf/book/newfuture/yyf>
* ePub电子书: <https://www.gitbook.com/download/epub/book/newfuture/yyf>
* mobi电子书: <https://www.gitbook.com/download/mobi/book/newfuture/yyf>

![YunYin Logo](assets/img/logo.png)

YYF (Yunyin Yaf Framework)
---------------------------

基于PHP的YAF扩展构建的高效,安全,简单,优雅的 开源RESTful 框架。

**项目主页** [https://github.com/YunYinORG/YYF](https://github.com/YunYinORG/YYF/)

设计宗旨：以**生产环境下安全高效运行**为前提,尽量让**开发优雅方便**,尽力提高运行性能和开发便捷。

YYF最初是从第二版云印系统后端核心框架萃取和完善发展而来,在不同环境下提供简单一致的开发体验,并在服务器上快速部署和高效运行；
鉴于流行Laravel框架和使用较多的ThinkPHP框架的使用习惯, 以 yaf扩展作为底层框架提高整体性能，开发的RESTful后端PHP框架。


如果使用过Laraval或者Thinkphp等任何PHP框架,或者熟悉Rails等类似的web框架,可轻松上手YYF。

主要特点
---------

* 安全: 
    - 数据库完全采用PDO封装从底层防止SQL注入
    - 输入参数类型绑定，提供输入过滤封装
    - 高效封装常用加密库，包括云印系统的格式保留加密算法
    - 生产环境,对文件权限进行严格限制
    - CORS封装管理和限制跨域请求

* 高效: 
    - 使用YAF扩展(c编译)作为框架底层驱动;
    - 核心库保证安全和高效运行为前提，独立模块内部紧耦合，按需加载;
    - 底层框架配置文件常驻内存,减少文件IO;
    - 针对PHP7特性优化,在PHP7下性能更优

* 简单:
    - 自带跨平台的一键初始化和管理命令脚本(不需要PHP环境)
    - 对REST路由和输出采用配置管理,并可根据浏览器请求方便的配置跨站请求(CORS)
    - 对常用操作高效封装,并对数据库,邮件,微信，七牛云等常用服务进行高效定制封装
    - 开发环境自动进行性能统计，方便后期优化
    - 提供Chrome调试插件YYF-Debugger，在浏览器中查看调试信息
    
* 优雅:
    - 静态封装,对于常用操作进行静态封装,让开发代码更简洁
    - 开发环境调试注入,无需改动代码,自动根据系统配置切换环境
    - 不同环境和服务尽量提高一致的接口，
    - 开发环境自动header输出调试信息和日志

* 兼容: 
    - 支持PHP5.3及以上所有稳定版本，可自动根据版本安装YAF
    - 在各种服务器环境包括云平台之间平滑迁移和部署
    - 提供Vagrant虚拟机开发环境，为不同系统和使用习惯的开发者提供稳定一致的开发体验
    - 集成单元测试,与travis-ci无缝对接,可在不同环境自动测试和持续集成