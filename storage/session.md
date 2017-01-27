Session 加密存取
==========

YYF中提供对session的便捷操作。
可根据需要自动启动session。

接口方法
-----------
* [Session::set($name,$value)保存session](#set)
* [Session::get($name,$default)读取](#get)
* [Session::del()删除](#del)
* [Session::flush()清空](#flush)
* [Session::start()指定ID](#start)

## set设置Session {#set}

set快速保存session

>```php
>function set(string $name, $value)
>```

- 参数
    * $name `string` : 存储的session键值名
    * $value `mixed` : 存储的session值，可以是任意类型

- 返回Session对象

```php
Session::set('key','some value');
```

## get设置Session {#get}

get快速保存session

>```php
>function get(string $name, $default = null)
>```

- 参数
    * $name `string` : 存储的session键值名
    * $default `mixed` : 存储的session值，可以是任意类型

- 返回mixed session值

```php
Session::get('key');
Session::get('key2','default value');
```

``

`del`删除 {#del}
----------
del快速删除

>```php
>function del(string $key):boolean;
>```

* 参数：`string` $key：键值

```php
Session::del('test_key');
```

`flush`清空 {#flush}
----------

清空全部数据

>```php
>function flush();
>```

```php
Session::flush();
```

`start` 启动 {#start}
----------
启动session

>```php
>function start( string $id=null);
>```

```php
Session::start();
Session::start('someidstring');
```
