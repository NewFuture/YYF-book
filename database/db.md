Db 数据库辅助类
=================

`Db`类提供封装和简化了数据库相关操作的调用，提高简单的静态调用接口


## Database 静态方式调用 {#database}
Db 类会根据需要自动创建数据库连接，并在生命周期类保存这些了连接资源


### 执行sql语句查询
可以调用Database的接口执行原生或者带参数的SQL语句。
但是**不推荐**这么使用,因为这样容易造成潜在的SQL注入风险。


```php
//原生sql查询
$list=Db::query('select id,name from user');
//键值对参数绑定查询
$data=Db::query('select * from user where id=:id',['id'=>2]);
//执行sql语句,参数绑定
Db::exec('UPDATE`user`SET(`time`=?)WHERE(`id`=?)',[date('Y-m-d h:i:s'),2]);

//预处理方式查询
Db::prepare('UPDATE`user`SET(`time`=?)WHERE(`id`=?)')
    ->execute([date('Y-m-d h:i:s'),2]);
```

### 错误查询
可以直接查询`Database`的错误码

```php
Db::errorCode();//获取查询的错误码
$error=Db::errorInfo();//获取出错信息，返回数组
```


### 原生事务
注意:对于*多数据库*的情况,事务调用过程中**不能切换数据库**！
对ORM或者model的操作，建议使用`orm`封装的事物操作transaction()
```php
Db::beginTransaction();//开始事物
try{
    Db::exec('do something ...');
    Db::query('do something ...');
    Db::exec('do something ...');
    /*更多查询...*/
    Db::commit();//事物完成提交
} catch (Exception $e) {
    Db::rollBack();//出错回滚
}
```

## 创建ORM对象  {#orm}
可以通过`table`方法创建一个Orm对象，快速查询。
table方法返回的是一个[`Orm`对象](orm.md)

### `table`方法快速查询
```php
//快速查询
$name=Db::table('user')->where('id',2)->get('name');
//添加数据使用field进行字段过滤和别名设置
Db::table('feedback')
    ->field('user','name')
    ->field('content,call AS phone')
    ->insert($_POST);
```


## 数据库管理  {#db}
Db 默认会自动使用配置中的默认的数据库进行调用
不会自动的进行读写分离或者切换。


### `current`方法:获取当前数据库 {#db-current}

```php
Database current()
```
`current`返回当前正在使用的数据库对象

```php
$db=Db::current();
//切换数据库，等各种操作
//继续原来的$db
$db->query('some thing');
```

### `use`方法：设定切换数据库 {#db-use}
`use`方法手动切换Db方式调用的默认数据库，调用之后默认数据会采用此数据库

注意： 此方法**不会影响** model和orm中数据的调用

```php
Databse use(mixed $config,[string $username,[string $password]])
```
* 参数 `$config` (必填)： 可以是下列三项之一
  - string 数据库`配置名称`如 "_read","mydb",只要在[database] 下配置了即可; 
  - string dsn设置 如： "sqlite:/tmp/sql.db";
  - array  数据库链接配置，包括dsn，username，password;
* 参数 `$username` string: 数据库账号 (当$cofnig为dsn时选填）
* 参数 `$password` string: 数据库密码 (当$cofnig为dsn时选填）
* 返回 ： 数据库对象
* 示例代码

```php
/*配置名称切换数据库,'_','_read','_write'三个是保留数据库名*/
Db::use('_read')->query('query something');//切换到读数据库
Db::use('mydb')->exec($sql);//执行
/*dsn*/
Db::use('sqlite:/tmp/sql.db')->query($sql);
Db::user('mysql:host=localhost;port=3306;dbname=yyf;charset=utf8','root','root');
/*array*/
Db::use([
   'dsn'=>'mysql:host=localhost;port=3306;dbname=yyf;charset=utf8',
   'username'=>'root'
 ]);
```