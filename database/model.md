Model 数据库模型 
================

数据库模型的核心,当需要在不同地方需要重复使用相同的数据设定时可以考虑创建`Model`。

Model在性能上会比直接创建[`Orm`](orm.md)或者使用[`Db::table()`](db.md#table)心里要低，但是在代码易读性和重用上较好。

接口 {#interface}
------
### 属性接口
* [$name](#name) 表面名
* [$pk](#pk) 主键
* [$fields](#fields) 字段
* [$prefix](#prefix) 表前缀
* [$dbname](#dbname) 限制数据库

### 方法接口
* [getOrm](#getOrm) 获取对应的ORM
* [ORM方法](#orm)静态调用


## 创建一个Model {#create}

一句话的的Model

在目录`app/models/`下新建`User.php`
文件中写入如下代码

```php
<?php class UserModel extends Model{}
```

然后就可以在其他地方，如controller里面通过`UserModel`来调用了

```php
/*快速调用*/
UserModel::Insert(['name'=>'future']);
$name=UserModel::where('id',2)->get('name');

/*实例化,可以接收一个数组参数预设数据,重复使用时可以clear*/
$user=new UserModel($data);
```

注意：上面的这种方式，依赖于_数据库命名小写下划线链接和`id`作为主键的_的命名规范。

如果`数据库`中user表不是`user`而是`User`（大写）甚至是`驼峰式命名`。
这种方式需要制定数据表名称


## 设置Model的属性 {#properties}

### `name` 表名 {#name}

>`string $name`

数据库表名，默认为当前class名称小写下划线链接,

如 `UserModel` 映射==>`user`表，`UserInfoModel`映射==>`user_info`表

如果数据库不是按照此方式命名为，比如用户表命名为`User`,
```php
<?php
class UserModel extends Model
{
    protected $name = 'User'; //数据库表
}
```


### `pk` 主键 {#pk}

> `string $pk` 

默认主键为`id`。

如果主键为`user_id`，可以如下定义。

```php
<?php
class UserModel extends Model
{
    protected $pk = 'user_id'; //主键 
}
```

### `$fields` 字段设置 {#fields}

>`mixed $fields`

字段，预知字段过滤或者别名设置, 参见[Orm的field()方法](orm.md#field)。

写入时进行字段过滤或者读取时指定字段和别名。
可以使用[`clear`](orm.md#field)清除这个设置，或者使用[`field`](orm.md#field)继续设置字段。

支持字符串(简洁)和数组(清晰)方式进行设置：

* 字符串(string): 使用`,`分割,`AS`设置别名

```php
protected $fields='id,name AS username';
```

* 数组: 可以使用键值对 `=>`指定别名

```php
protected $fields=[
        'id',
        'name'=>'username',
    ];
```


```php

/* 定义在文件 app/models/User.php */
<?php
class UserModel extends Model
{
    protected $fields='id,name AS username';
}
?>

/*调用*/
$user=UserModel::find(1);//$user中包含字段`id`和`username`

$user_list=UserModel::limit(100)
            ->select();//选出100个用户的'id'和'username'(字段对应`name`)

UserModel::where('id',1)->update([
    'username'=>'future',//别名username会自动转成`name`字段
    'password'=>'hihi',//这个字段不在fields中会被过滤掉
]);//最终只有user表中'name'被改成future


UserModel::insert([
    'username'=>'future',//别名username会自动转成`name`字段
    'password'=>'hihi',//这个字段不在fields中会被过滤掉
]);//最终插入数据为 [`name`=>'future'];


```


### `prefix` 前缀 {#prefix}

> `string $prefix` 

默认主键使用配置中的prefix。

如果要覆盖掉可自行设置`prefix`设置为空串(`''`)将不使用前缀。

```php
<?php
class UserModel extends Model
{
    protected $prefix = 'yyf_'; //设置数据表前缀 
}
```

### `dbname` 数据库设定 {#dbname}

> `string $dbname` 

使用[database]配置中db数据库的配置。

```ini
;若干设置
;conf/secret.common.ini
[database]
;数据库配置
;...若干设置
db.data.dsn  = "sqlite:/temp/databases/data.db"; 以sqlite配置为例
db.data.username  = ""

```
配置
```php
<?php
class UserModel extends Model
{
    protected $dbname = 'data'; //使用配置名为`data`的数据库 
}
```

## Model的方法接口 {#method}

这里的`Model`本质上是对`Orm`增强和再次封装的外观模式(Facade Design)

### `toArray()`获取Orm {#toArray}
获取Model中数据，以数组的方式返回

### `toJson()`获取Orm {#toJson}
```php
function toJson($type=JSON_UNESCAPED_UNICODE):string
```
获取Model中数据，以json的方式返回,参数为编码方式

### `getOrm()`获取Orm {#getOrm}

`getOrm`返回当前model中的的ORM对象

### 所有`Orm`接口 {#orm}

Model 可以以静态和动态的方式调用所有Orm的接口。