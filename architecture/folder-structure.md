YYF 文件目录结构
==========
主要内容
--------

1. [整体目录文件结构](#folder)
2. [public(网站根目录)](#public)
3. [运行时目录(数据存储位置)](#runtime)
4. [app应用目录](#app)


整体目录文件结构 {#folder}
----------

```
│  .htaccess    Apache开发环境重新url
│  config.yaml  SAE配置和URL重定向
|  init.cmd     统一初始化脚本 
│  LICENSE
│  README.MD
│  
├─app  
│  │  Bootstrap.php     生产环境入口 
│  │  Bootstrap.dev.php 开发环境入口
│  │  README.MD
│  │  
│  ├─controllers     控制器目录【添加代码的主战场】
│  │      Error.php  默认错误
│  │      Index.php  DEMO控制器
│  │      
│  ├─email           邮件模板目录
│  │      verify.tpl 默认验证邮件模板示例
│  │      
│  ├─models          模型目录
│  │      README.md
│  │      
│  ├─plugins         插件目录
│  │      Tracer.php 调试信息统计插件
│  │      
│  └─views           视图目录
│      └─index
│              index.phtml
│              
├─conf      配置目录
│      app.ini       基础配置
│      secret.common.ini  示例私密配置
│      secret.product.ini 生产环境私密配置
│ 
├─library   库目录
│  │  Cache.php    缓存管理类
│  │  Config.php   配置读取类
│  │  Cookie.php   安全Cookie接口
|  |  Db.php       数据库操作封装
│  │  Encrypt.php  加密库
│  │  Head.php     调试header输出库
│  │  Input.php    输入过滤接口
│  │  Kv.php       key-value存取类
│  │  Logger.php      日志管理类
│  │  Mail.php     邮件发送
│  │  Model.php    基础model
|  |  Orm.php      ORM数据库对象映射
│  │  Random.php   随机字符生成类
│  │  README.md
│  │  Rest.php     基础REST类
│  │  Rsa.php      RSA加密类
│  │  Safe.php     安全统计类
│  │  Session.php  session管理接口
│  │  Validate.php 类型验证类
│  │  Wechat.php   微信登录接口库类
│  │  
│  ├─Parse 格式解析
│  │      Filter.php
│  │      Xml.php
│  │      
│  │          
│  ├─Service 系统基础服务
│  │      Api.php
│  │      Database.php
│  │      Message.php
│  │      Qiniu.php
│  │      README.MD
│  │      Smtp.php
│  │      Ucpaas.php
│  │      
│  └─Storage 存储服务
│          File.php
│          
├─public 公共目录【前端资源目录，生产环境根目录】
│      .htaccess     url重写
│      favicon.ico
│      index.php    入口文件
│      robots.txt
│      
└─runtime 运行时数据存储文件夹【可以放在其他位置读写权限】
```


网站根目录 {#public}
-----------
`public` 前端目录(用户唯一可以访问的目录)

* 前端资源目录：静态资源css,js等放置于此目录
* web根目录：生产环境时作为网站的根目录


运行时目录
-----------
`runtime` 文件缓存等数据会存于此目录，保证程序对目录可读写权限；

可以配置`conf/app.ini`中`runtime`指向系统的其他位置。

注意生产环生成的存储文件会设置为**700权限**，保证安全性。


应用目录 {#app}
----------
`app` 应用

 多模块是添加到 `app/modules/`目录下

 如添加一个admin目录`app/modules/admin/controllers/Index.php`