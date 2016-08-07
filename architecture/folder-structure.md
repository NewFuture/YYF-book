YYF 文件目录结构
==========

整体目录文件结构
----------
>
```
│  .htaccess    Apache开发环境重新url
│  config.yaml  SAE配置和URL重定向
|  init.cmd     开发环境初始化脚本 
│  LICENSE
│  README.MD
|  server.cmd   启动php server 调试 
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
│  │  Log.php      日志管理类
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
└─temp 缓存日志临时文件夹【可写权限】
```
>

网站根目录
-----------
`public` 


应用目录
----------
`app`

 