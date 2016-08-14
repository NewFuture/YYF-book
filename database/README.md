数据库（Database）
=========

数据库是MVC 中 M层处理的核心业务。

整个框架中数据库这一层提供致力于提供一个安全,高效,简单的数据操作接口。


数据库设计命名基本规范 {#design}
------

数据设计如果满足前三条，在使用模型和关联时大部分细节时候可以自动完成

1. 数据库表名小写下划线(或者全部小写)如 : `user`,`user_info`,`admin_log`(推荐下划线)或者`amdinlog`
2. 数据库表的主键:`id` (建议所有表均设置一个自增主键)
3. 数据库表的外键`${table}_id`如:信息表`info`有个用户表(`user`)的外键,则信息表中的外键为`user_id`,

其他无特殊要求根据团队习惯尽量保持一致即可。

如果不满可以通过配置和参数达到同样目的。


数据库配置 {#config}
------
数据库配置在`secret`配置文件开发环境和生产环境使用不同的配置文件


```ini
[database]
;数据库配置
prefix    = '';数据库表前缀
exception = 0 ;sql执行出错是否抛出异常，可以try catch

;默认数据库(主库)
db._.dsn      = "mysql:host=localhost;port=3306;dbname=yyf;charset=utf8"
db._.username = 'root'
db._.password = ''
;读数据库(从库)
db._read.dsn       = "sqlite:/temp/databases/mydb.sq3"; 以sqlite配置为例
db._read.username  = 'username'
db._read.password  = ''

```

需要添加数据库是在`db`后继续追加 ：
* `db.{name}.dsn`(数据库DSN);
* `db.{name}.username`(数据库账号 可选)
* `db.{name}.password`(数据库密码可选)

其中`{name}`为数据库配置名称

数据库相关类库 {#class}
----------------

### 快捷辅助类
* [Db 数据库操作管理类](db.md)
* [Model 数据模型封装](model.md)

### 核心类
* [Database 数据库连接类](database.md)
* [Orm 数据库对象关系映射类](orm.md)
