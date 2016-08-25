Database 底层数据库连接
===========

`Service/Database` 类:
* 实现对底层[PDO](http://php.net/manual/zh/book.pdo.php)的继承和轻量封装，提供数据库访问接口.
* 执行出错会Log记录ERROR信息
* 开发环境默认会记录所有的SQL查询请求和结果以及耗时统计

通常你并不需要直接使用此类, [Orm](orm.md)和[Model](model.md)在数据连接时会自动的处理此类。

**不建议使用原生SQL语句除非有200%的把握**(对自己100%和对其他修改代码的人100%把握). 
此框架中的`Orm`对sql语句的生成非常安全高效，建议使用对象函数时的方式来查询，采用完全参数化封装防止SQL注入.

接口和方法列表 {#interface}
-------------
- 方法接口
    * [Database::exec($sql,$params)](#exec) 执行一条SQL(写),并返回受影响的行数
    * [Database::query($sql,$params)](#query) 查询一条SQL(读),并返回执行结果
    * [Database::column($sql,$params)](#column)(查询一条SQL(读),并返回一个值
    * [Database::errorInfo()](#errorInfo) 获取出错信息
    * [Database::errorCode()](#errorCode) 获取错误码
    * [Database::transact($func)](#transact) 执行事务
- 全局接口
    * [Database::$before](#before) 数据库请求处理之前调用
    * [Database::$after](#after) 数据库操作完成后调用
    * [Database::$debug](#debug) 调试输出,参数执行出错dump出结果
- 继承自[PDO](http://php.net/manual/zh/book.pdo.php)(下面链接均为PHP文档)
    * [PDO::beginTransaction()](http://php.net/manual/zh/pdo.begintransaction.php)— 启动一个事务
    * [PDO::commit()](http://php.net/manual/zh/pdo.commit.php) — 提交一个事务
    * [PDO::rollBack()](http://php.net/manual/zh/pdo.rollback.php) — 回滚一个事务
    * [PDO::lastInsertId()](http://php.net/manual/zh/pdo.lastinsertid.php) — 返回最后插入行的ID或序列值
    * [PDO::prepare($sql)](http://php.net/manual/zh/pdo.prepare.php) —  查询预处理
    * [PDO::setAttribute($key,$value)](http://php.net/manual/zh/pdo.setattribute.php) — 设置属性
    * 其他全部的PDO接口


创建数据库连接
--------------

1. 构造函数

如果希望使用数据原生对象可以直接使用下列方式
```php
$db= new Service\Database($dsn [, $username=null, $password=null, array $options=null]); 
```

2. 使用`Db`辅助类自动创建

[Db类](db.md)对数据库对象进行了封装，可以根据需要自动创建数据库对象和重用。
```php
$db=Db::connect();
```

方法接口
-------------------

### sql查询和执行方法
对于SQL语句的处理，做了简化和优化：
* 有参数时，对sql进行预处理和参数绑定保证sql执行的安全性,同时会自动根据参数的类型绑定数据库类型(`1`绑定数值,`'1'`绑定字符串,`true`绑定bool型)
* 无参数时(比如统计全表信息)直接查询或者执行,提高执行速度。
* 操作出错返回的数据统一`false`(可以`$result===false`判断是否成功)

#### Database::exec() 方法:执行sql命令，返回修改结果 {#exec}
>```php
>function exec(string $sql [, array $params = null]): int
>```

* 参数：
    1. string $sql: SQL 写操作处理语句(`UPDATE`,`INSERT`,`DELETE`),(select 语句使用[query](#query)或者[column](#column)查询)
    2. array $params: 查询参数数组，索引数组(对应`?`参数)或者键值对数组(对应`:xx`型参数，如果参数无`:`会自动补全)
* 返回：执行影响的条数
* tips：插入操作可以使用`lastInsertId()`方法获取查入的ID
* 代码

```php
/*参数绑定*/
//?索引型
$db->query('DELETE FROM user WHERE id =?',[1]);
//:键值对型
$db->query('DELETE FROM user WHERE id =:id',[':id'=>1]);
//:省略型
$db->query('DELETE FROM user WHERE id =:id',['id'=>1]);
```

#### Database::query() 方法 查询一条SQL(读),并返回执行结果 {#query}
>```php
>function query(string $sql [, array $params = null [, boolean $fetchAll= true [, $fetchmode = \PDO::FETCH_ASSOC]]])：array
>```

* 参数：
    1. string $sql: SQL 写操作处理语句(`UPDATE`,`INSERT`,`DELETE`),(select 语句使用[query](#query)或者[column](#column)查询)
    2. array $params: 查询参数数组，索引数组(对应`?`参数)或者键值对数组(对应`:xx`型参数，如果参数无`:`会自动补全)
    3. boolean $fetchAll: 结果读取方式 默认 fetchAll 全部二维数组， `false`时 使用fetch 一维数组
    4. $fetchmode: 结果返回方式
* 返回：$fetchmode 确定，默认二维数组
* 代码

```php
/*无参数*/
$db->query('SELECT * FROM user');

/*参数绑定*/
//返回二维数组或者null或者false
$db->query('SELECT * FROM user WHERE id=? AND status>?',[1,0]);
/*参数绑定*/
$db->query('SELECT * FROM user WHERE id=:id AND status>:status',
        [
            ':id'=>1,
            ':status'=>0,
        ]);
$db->query('SELECT * FROM user WHERE id=:id AND status>:status',['id'=>1,'status'=>0]);
```



#### Database::column() 方法 查询一条SQL(读),并返回一个值 {#column}
>```php
>function column(string $sql [, array $params = null]): scalar
>```

* 参数：
    1. string $sql: SQL 写操作处理语句(`UPDATE`,`INSERT`,`DELETE`),(select 语句使用[query](#query)或者[column](#column)查询)
    2. array $params: 查询参数数组，索引数组(对应`?`参数)或者键值对数组(对应`:xx`型参数，如果参数无`:`会自动补全)
* 返回：基本类型
* 代码：

```php
/*与query用法基本相同*/
$name=$db->column('SELECT name FROM user WHERE id=?',[1]);//返回的是字符串
```

#### 获取错误信息

可以在[database]的配置中配置`exception=1`来开启异常，(执行出错抛出,异常，可以使用`try`,`catch`处理)

获取错误或者执行是否出错或者粗出结果可以使用

* Database::errorCode() 获取错误码 {#errorCode}
    - 返回字符串，
    - 无错误时返回"000"或者"00000"与驱动有关，可以使用 `$db->errorCode()==0`判断
* Database::errorInfo() 获取出错信息
    - 返回数组，一般三个值
    - 第一个值错误码
    - 第二个错误的代码
    - 第三个错误原因

### 事务 {#tansaction}

几个操作必须都成功执行的时候，需要使用事务

可以使用PDO相关的接口执行事务也可以使用`transact`方法来处理：
* [PDO::beginTransaction()](http://php.net/manual/zh/pdo.begintransaction.php)— 启动一个事务
* [PDO::commit()](http://php.net/manual/zh/pdo.commit.php) — 提交一个事务
* [PDO::rollBack()](http://php.net/manual/zh/pdo.rollback.php) — 回滚一个事务
* Database::transact($func) 快捷事务

#### `transact()`方法：处理事务 {#transact}
>```php
>function transact(callable $func)
>```

* 参数callable $func: 调用函数过程(可以是匿名函数)
    - $func 参数是当前对象(`$this`)
    - 返回值，如果是`false`(严格的false,null,0等**不是false**),同样执行回滚
* 返回：`false`(执行失败)或者$func的返回值(执行成功)
* tips： 如果$func 无返回值，执行出错同样回滚
* 代码

```php
/*简单事务操作*/
$db->transact(function ($DB) {
    $DB->exec('DELETE FROM article WHERE user_id =?',[1]);
    //更多操作...
    $DB->exec('DELETE FROM user WHERE id =?',[1]);
});

/*等效实务操作*/
try{
    $db->beginTransaction();
    $db->exec('DELETE FROM article WHERE user_id =?',[1]);
    //更多操作...
    $db->exec('DELETE FROM user WHERE id =?',[1]);
    $db->commit();
}catch(Exception $e){
    $db->rollBack();
}

/*实例*/
$id=1;
if($db->transact(function ($DB) use ($id) {
    $DB->exec('DELETE FROM article WHERE user_id =?',[$id]);
    return $DB->exec('DELETE FROM user WHERE id =?',[$id]);
})!==false){
    echo "删除成功!";
}else{
    echo "删除出错失败";
}
```

全局接口
------

### `$before` 数据库请求处理之前调用 {#before}

可以注册**一个**数据处理接口来拦截请求数据

```php
before(string &$sql, array &$params, string name);
```
before 包含三个参数执行的：
* `$sql`: sql语句,在注册的函数中可以对其修改
* `$params`： 执行参数，支持引用传参可以被修改
* `string`: 当前调用的入口名称(`query`,`exec`,`column`)

调试的SQL记录日志采用此接口实现.

### `$after` 数据库请求处理之前调用 {#after}
```php
after(Database &$this, mixed &$result, string name);
```
after 回调包含三个参数执行的：
* `$this`: 当前查询对象,在注册的函数中可以对其修改和获取其状态码
* `$result`： 返回的结果，支持引用传参可以被修改
* `string`: 当前调用的入口名称(`query`,`exec`,`column`)


### `$debug` 调试输出 {#debug}

调试时，PDO参数出错,直接dump传入参数。**请勿在生产环境使用**。

开发环境可以使用debug的一项配置开启。

```php
/*手动开启*/
\Service\Database::$debug=true;
/*手动关闭*/
\Service\Database::$debug=false;
```
