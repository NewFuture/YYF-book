键值对存储(Kv)
================

高效字符串键值对存储提供快速一致的`永久存储服务`(理论上是可靠不会被清理的))接口。支持存储类型:(配置中指明类型即可)
* redis 高性能键值对存储服务
* file  文件存储磁盘存储
* sae   sae KVDB键值对存储

存储接口
----------------
* [Kv::set()存储值](#set)
* [Kv::get()读取](#get)
* [kv::del()删除](#del)
* [Kv::flush()清空](#flush)
* [Kv::handler()获取当前Kv底层存储对象](#handler)



`set`保存 {#set}
----------
set快速存储键值

>```php
>function set(string $key, string $value):boolean;
>function set(array $data):boolean
>```

* 双参数：
    1. `string` $key：获取的键值
    2. `string` $value：值字符串
* 数组参数： 关联数组多组键值同时设置
    
* 返回： boolean 

*  tips: 使用redis会调用`mset`相当于数据库中的事务，只有都写入成功才继续。

```php
Kv::set('test_key','some value');

Kv::set([
    'key1'=>'value1',
    'key2'=>'value2'
]);
```

`get`获取 {#get}
----------
get快速获取存储

>```php
>function get(string $key, string $defualt=false):boolean|string;
>function get(string $data):array;
>```

* 双参数：
    1. `string` $key：获取的键值
    2. `string` $defualt:默认值
* 数组参数： 返回array
    
```php
Kv::get('test_key');
Kv::get('no_key');//false
Kv::get('no_key','default');//返回'default'

Kv::get(['key1','key2']);//返回数组['key1'=>'value1','key2'=>'value2']
Kv::get(['key1','key2','no_key']);//返回数组['key1'=>'value1','key2'=>'value2','no_key'=>false]
```

`del`删除 {#del}
----------
del快速删除

>```php
>function del(string $key):boolean;
>```

* 参数：`string` $key：键值

```php
Kv::del('test_key');
```


`flush`清空 {#flush}
----------
清空全部数据
>```php
>function flush();
>```

```php
Kv::flush();
```


`handler`清空 {#handler}
----------
获取处理方式
>```php
>function handler();
>```

```php
$handler=Kv::handler();
```