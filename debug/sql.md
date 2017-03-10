数据库调试
=============

* [配置](#config)
* [日志](#log)
* [响应头](#header)

配置 {#config}
------

为了，方便调试数据库查询，和快速定位bug，框架中可以方便的记录所有的SQL查询

并可通过以下两项进行配置(**仅仅在开发模式有效**)
```
debug.sql.output = 'LOG,HEADER';//sql统计输出
debug.sql.result = 0;//是否在header中输出结果
```

日志 {#log}
---------

开发环境下，所有的SQL查询会记录在`runtime/log/YY-MM-dd-SQL.log`中

格式如下
```
[02-Mar-2017 22:11:44 Asia/Shanghai] (/api.php/Admin) 
  [SQL001] SELECT `id`FROM`admin`WHERE(`account`= :0)AND(`password`= :1) LIMIT :2 OFFSET :3
  [PARAMS] {":0":"account",":1":"8e0bb8de5b28c0f55abbe516f7b9f89b",":2":1,":3":0}
  [RESULT] 1
  [INFORM] 81.717967987061 ms (column)
```

响应头 {#header}
--------
上述头在开发环境下，也会输出到http的响应header中

```
Yyf-Sql-1: {"T":65.899,"Q":"SELECT `id`FROM`admin`WHERE(`account`= :0)AND(`password`= :1) LIMIT :2 OFFSET :3","P":{":0":"account",":1":"8e0bb8de5b28c0f55abbe516f7b9f89b",":2":1,":3":0},"R":1}
```


如果前端(客户端)是浏览器,可以使用[chrome插件](http://debugger.newfuture.c)进行方便的查看所有的SQL查询

![](http://debugger.newfuture.cc/images/sql.png)

