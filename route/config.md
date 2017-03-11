路由配置
=============

YYF中支持YAF的所有路由方式，可以通过修改配置，快速设置路由。
(为了提高性能，生成环境默认关闭了自定义路由，需要[修改默认配置](#bootstrap))

* [启用路由配置](#config)
* [rewrite路由](#rewrite)
* [正则路由](#regex)


启用路由配置 {#config}
-----------

需要在配置项中设置加载启动项(bootstrap),路由配置才会生效

### 1. 添加bootstrap启动加载 {#bootstrap}

修改配置,取消生产环境的bootstrap 注释
```ini
[product:common];
;...省略
;application.bootstrap = APP_PATH "/library/Bootstrap/product.php"
```
改为
```ini
[product:common];
;...省略
application.bootstrap = APP_PATH "/library/Bootstrap/product.php"
```

#### 2. 添加路由配置

在公共配置中添加`routes.{路由名称}`配置路由。

| 字段 | 说明 | 值 |
| --- | --- | --- |
|`routes.{路由名称}.type` | 路由类型【必须】 | `rewrite`，`regex`，`simple`，`supervar`或`map` |
|`routes.{路由名称}.match` | 匹配模式 | 字符串|
|`routes.{路由名称}.route.controller`| 对控制器有效 | 控制器名，rewrite 模式可以为变量|
|`routes.{路由名称}.route.action`| 对指定Action有效 | action名 |
|`routes.{路由名称}.route.module`| 模块| 默认 index |
|`routes.{路由名称}.map.{数字编号}`| 正则参数映射| string变量名 |

可以配置多个路由，但是**优先匹配后面的**。

[示例](http://php.net/manual/yaf-router.addconfig.php#refsect1-yaf-router.addconfig-examples)
```ini
[common];
;...省略

;the order is very important, the prior one will be called first

;添加一个名为rewrite的路由协议,也可以叫其他名字
;a rewrite route match request /product/*/*
routes.rewrite.type="rewrite"
routes.rewrite.match="/product/:name/:value"
routes.rewrite.route.controller=product
routes.rewrite.route.action=info


;添加一个名为regex的路由协议
;a rewrite route match request /product/*/*
routes.regex.type="regex"
routes.regex.match="#^/list/([^/]*)/([^/]*)#"
routes.regex.route.controller=Index
routes.regex.route.action=action
routes.regex.map.1=name
routes.regex.map.2=value

;添加一个名为simple的路由协议
;a simple route match /**?c=controller&a=action&m=module
routes.simple.type="simple"
routes.simple.controller=c
routes.simple.module=m
routes.simple.action=a

;添加一个名为supervar的路由协议
;a simple router match /**?r=PATH_INFO
routes.supervar.type="supervar"
routes.supervar.varname=r


;a map route match any request to controller
routes.route_name4.type="map"
routes.route_name4.controllerPrefer=TRUE
routes.route_namer.delimiter="#!"
```

路由配置可参考,[YunYinService 路由配置](https://github.com/YunYinORG/YunYinService/blob/master/conf/app.ini#L14-L24)


rewrite路由 {#rewrite}
-----

`type=rewrite` 的路由方式

此方式相对简单，解析相对高效(比正则高效)

如
```
routes.rewrite.type="rewrite"
routes.rewrite.match="/product/:name/:value"
routes.rewrite.route.controller=product
routes.rewrite.route.action=info
```
相当于`/product/xxx/yyy`请求对应到 `/product/info/name/xxxx/value/yyy`

(infoAction，绑定xxx到参数变量$name，yyy到参数变量$value)

rewrite模式也支持将controller或者action设置为match对应的变量


正则路由 {#regex}
-------

最灵活的路由方式

可以通过map来映射参数名，如
```
routes.regex.type="regex"
routes.regex.match="#^/list/([^/]*)/([^/]*)#"
routes.regex.route.controller=Index
routes.regex.route.action=action
routes.regex.map.1=name
routes.regex.map.2=value
```
相当于`/list/name/xxx/value/xxxx)`的请求方式

