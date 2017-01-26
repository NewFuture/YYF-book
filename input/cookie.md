Cookie 加密存取
==========

YYF中提供了对cookie加密存储和读取的方式(使用AES服务器端加密),可以通过cookie方式调用。

此方法设置可以防止客户端(浏览器)和中间人获取和修改cookie的真实内容。


接口方法
-----------
* [Cookie::set($name,$value)设置cookie](#set)
* [Cookie::get($name)读取](#get)
* [Cookie::del()删除](#del)
* [Cookie::flush()清空](#flush)

## set设置cookie {#set}

set快速保存cookie

>```php
>function set(string $name, $value, $path = '', $expire = null, $domain = null)
>```

- 参数
    * $name `string` : 存储的cookie键值名
    * $value `mixed` : 存储的cookie值，可以是任意类型
    * $path `string` : 存储路径，默认读取配置
    * $expire `int` : cookie过期时间，默认读取配置
    * $domain `string` : Cookie保存域名，默认读取配置

- 返回Cookie对象

```php
Cookie::set('test_cookie','something');
```


## get设置cookie {#get}

set快速保存cookie

>```php
>function get(string $name, mixed $default = null):mixed
>```

- 参数
    * $name `string` : 存储的cookie键值名
    * $default `mixed` : 可选默认值，可以是任意类型

- 返回cookie的值或者默认值

```php
Cookie::get('test_cookie');
Cookie::get('test_cookie2','default string');
```

`del`删除 {#del}
----------
del快速删除

>```php
>function del(string $key):boolean;
>```

* 参数：`string` $key：键值

```php
Cookie::del('test_key');
```

`flush`清空 {#flush}
----------

清空全部数据

>```php
>function flush();
>```

```php
Cookie::flush();
```
