Db 数据库辅助类
=================

`Db`类提供封装和简化了数据库相关操作的调用，提高简单的静态调用接口。

接口和方法列表 {#interface}
-------------
- 常用方法接口
    * [current()](#current) 获取当前数据库连接
    * [connect()](#connect) 连接数据库
    * [set()](#set) 设定数据库
    * [table()](#table) 快速创建数据库表
    * [query()](#query) 查询sql语句
    * [exec()](#exec) 执行sql命令
    * [execute()](#execute) exec 别名

- [Database接口调用](#database)
    * [Database::exec($sql,$params)](database.md#exec) 执行一条SQL(写),并返回受影响的行数
    * [Database::query($sql,$params)](database.md#query) 查询一条SQL(读),并返回执行结果
    * [Database::column($sql,$params)](database.md#column)(查询一条SQL(读),并返回一个值
    * [Database::errorInfo()](database.md#errorInfo) 获取出错信息
    * [Database::isOk()](database.md#isOk) 上次查询是否出错
    * [Database::transact($func)](database.md#transact) 执行事务
- 继承自[PDO](http://php.net/manual/zh/book.pdo.php)(下面链接均为PHP文档)
    * [PDO::beginTransaction()](http://php.net/manual/zh/pdo.begintransaction.php)— 启动一个事务
    * [PDO::commit()](http://php.net/manual/zh/pdo.commit.php) — 提交一个事务
    * [PDO::rollBack()](http://php.net/manual/zh/pdo.rollback.php) — 回滚一个事务
    * [PDO::lastInsertId()](http://php.net/manual/zh/pdo.lastinsertid.php) — 返回最后插入行的ID或序列值
    * [PDO::prepare($sql)](http://php.net/manual/zh/pdo.prepare.php) —  查询预处理
    * [PDO::setAttribute($key,$value)](http://php.net/manual/zh/pdo.setattribute.php) — 设置属性
    * 其他全部的PDO接口


## 快速创建ORM对象  {#orm}
可以通过`table`方法创建一个Orm对象，映射到数据库表,快速查询。
table方法返回的是一个[`Orm`对象](orm.md)

### `table()`方法快速查询 {#table}

>```php
>function table(string $name [,string $pk, [string $prefix]]):Orm
>```

* 参数：
    1. `string $name`[必填] :数据库表名
    2. `string $pk`[选填]: 主键值，默认orm而定为`id`
    3. `string $prefix`[选填]： 前缀，默认读取配置
* 返回：`Orm` 对象
* 如果需要对同一张表进行多次操作,可以创建赋值给一个变量，每次调用此变量提高性能

```php
//快速查询
$name=Db::table('user')->where('id',2)->get('name');

//添加数据使用field进行字段过滤和别名设置
Db::table('feedback')
    ->field('user','name')
    ->field('content,call AS phone')
    ->insert($_POST);//快速插入数据,只是示例,对于写入用户数据进行检查是必要的
```


## 数据库管理  {#db}
Db 类会根据需要自动创建数据库连接，并在生命周期类保存这些了连接资源。
单数据库默认不需要使用数据库管理和切换操作。

Db 操作同时提供多数据库操作接口。

Db 默认会自动使用配置中的默认的数据库进行调用，不会自动的进行读写分离或者切换。

**Db切换数据库不会影响Model或者Orm中数据库的调用**,`table()`方法使用的数据会按照[Orm数据库切换规则](orm.md#database)切换。


### `current()`方法:获取当前数据库 {#current}

`current`返回当前正在使用的数据库对象

>```php
>function current() :Database
>```

* 返回当前数据连接对象
* 示例代码

```php
$db=Db::current();
//切换数据库，等各种操作
//继续原来的$db
$db->query('some thing');
```

### `set()`方法：设定并切换数据库 {#set}

`set`方法手动切换设置数据库。

此方法不会影响直接查询对数据库的选择，但是会影响

注意：如果修改保留名称，此方法会**影响** [Model](model.md)和[Orm](orm.md)中默认读写数据库的调用.

>```php
>function $name(string $name,mixed $config,[string $username,[string $password]]) :Database
>```

* 参数 `$name`(string): 数据库配置名称如果无则创建，有则覆盖 
* 参数 `$config` (必填)： 可以是下列三项之一
  - string 数据库`配置名称`如 "_read","mydb",只要在[database] 下配置了即可; 
  - string dsn设置 如： "sqlite:/tmp/sql.db";
  - array  数据库链接配置，包括dsn，username，password;
* 参数 `$username` string: 数据库账号 (当$cofnig为dsn时选填）
* 参数 `$password` string: 数据库密码 (当$cofnig为dsn时选填）
* tips :
    -  当 `$name`为 `_` 会修改 `Db`,[Model](model.md)和[Orm](orm.md) 等数据库操作使用的默认数据库
    -  当 `$name`为 `_read`会修改 `Db`, [Model](model.md)和[Orm](orm.md) 等数据库**读取操作**的数据库
    -  当 `$name`为 `_write`会修改 `Db`, [Model](model.md)和[Orm](orm.md) 等数据库**写入操作**的数据库

* 返回 ： 数据库对象
* 示例代码

```php

/*配置名称切换数据库,'_','_read','_write'三个是保留数据库名*/
Db::set('_','_read')->query('query something');//切换到读数据库
Db::set('_write','mydb')->exec($sql);//执行

Db::exec($sql2);//此时仍然使用mydb写

/*dsn*/
Db::set('temp','sqlite:/tmp/sql.db')->query($sql);
/*多参数设置*/
Db::set('_write','mysql:host=localhost;port=3306;dbname=yyf;charset=utf8','root','root');
/*array*/
Db::set('test',[
   'dsn'=>'mysql:host=localhost;port=3306;dbname=yyf;charset=utf8',
   'username'=>'root'
 ]);
```

### `connect()`方法：建立数据库 {#connect}

`connect`方法建立数据库，而不影响之后或者其他的数据调用

注意： 此方法为**临时**调用，不会影响之后数据库切换

>```php
>function connect(mixed $config):Database
>```

* 参数 `$config` (必填)： 可以是下列两项之一
   - string 数据库`配置名称`如 "_read","mydb",只要在[database] 下配置了即可;
   - array 数据库链接配置，包括dsn，username，password;
* 返回： 数据库[Database](database.md)对象
* tips: 此方法不会影响之后数据库调用使用的数据库连接 
* 示例代码

```php
/*配置名称连接*/
Db::use('_read')->query('query something');//切换到读数据库

/*新建一个数据库连接*/
Db::connect('mysql:host=localhost;port=3306;dbname=yyf;charset=utf8','root','root');
/*array方式连接*/
Db::connect([
    'dsn'=>'mysql:host=localhost;port=3306;dbname=yyf;charset=utf8',
    'username'=>'root'
 ])->exec($sql);

//使用默认数据库
Db::query($sql);//此时任然是_read数据库
```


## sql语句查询

`Db`根据需要自动建立数据库连接,可以调用[`Database`](database.md)的所有方法接口

可以直接执行或者调用sql语句.但是对于新手或者对安全不太了解的，**不推荐**这么使用,因为这样容易造成潜在的SQL注入风险,如果确实要这么做,**务必使用参数分离**的方式进行查询。

同时，常用的数据方法使用静态方式加速,并自动读写分离.

### `query()`查询sql语句(读)：{#query}

数据库读取(select)查询，是对 [Database::query()](database.md#query)的快速调用。

示例代码

```php
//原生sql查询
$list=Db::query('select id,name from user');
//键值对参数分离
$data=Db::query('select * from user where id=:id',['id'=>2]);
```

### `column()`查询sql语句(读)：{#column}

数据库单条读取(select)查询，是对 [Database::column()](database.md#column)的快速调用。

示例代码

```php
//键值对参数分离
$name=Db::column('select name from user where id=?',[123]);
```

### `execute()`执行sql语句: {#execute}
execute是[`exec`](#exec)的别名,用来覆盖Db方法的私有方法execute。

建议尽量[`exec`](#exec)来调用,因为`Database`提供了`exec`接口而不是execute。

如 `Db::execute($sql)`可以执行,等效`Db::exec($sql)`;

但是`Db::current()->execute($sql)`会出错,应该使用``Db::current()->exec($sql)`;


### `exec()`执行sql语句(写): {#exec}

数据库写操作执行，是对 [Database::exec()](database.md#exec)的快速调用。

示例代码：
```php
//执行sql语句,参数绑定
Db::exec('UPDATE`user`SET(`time`=?)WHERE(`id`=?)',[date('Y-m-d h:i:s'),2]);
```


## Database 静态方式调用 {#database}
Db 类会根据需要自动创建数据库连接，并在生命周期类保存这些了连接资源

支持所有[`Database`接口](#database.md#interface)


如预处理：

```php
//预处理方式查询
Db::prepare('UPDATE`user`SET(`time`=?)WHERE(`id`=?)')
    ->execute([date('Y-m-d h:i:s'),2]);
```


如原生事务：

```php
Db::beginTransaction();//开始事务
try{
    Db::exec('do something ...');
    Db::query('do something ...');
    Db::exec('do something ...');
    /*更多查询...*/
    Db::commit();//事务成提交
} catch (Exception $e) {
    Db::rollBack();//出错回滚
}
```

注意:对于*多数据库*的情况,事务调用过程中**不能切换数据库**！

对ORM或者model的操作，建议使用`orm`封装的事务操作[`transact()`](orm.md#transact);

或者使用[数据库`transact`方法](database.md#transact)。
