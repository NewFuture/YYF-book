缓存(Cache)
================

缓存存储提供快速一致的缓存服务接口(缓存可能会被清理)。支持存储类型:(配置中指明类型即可)
* memcached 内存缓存
* redis 能键值对缓存服务
* file  文件存储磁盘存储
* memcache memcache内存缓存(包括sae)

存储接口
----------------
* [Cache::set()存储值](#set)
* [Cache::get()读取](#get)
* [Cache::del()删除](#del)
* [Cache::flush()清空](#flush)
* [Cache::handler()获取当前Kv底层存储对象](#handler)


`set`保存 {#set}
----------
set快速存储键值

>```php
>function set(string $key, string $value, int $expire=0):boolean;
>function set(array $data, int $expire=0):boolean
>```

* 双参数：
    1. `string` $key：获取的键值
    2. `string` $value：值字符串
* 数组参数： 关联数组多组键值同时设置
    
* 返回： boolean 

*  tips: 使用redis会调用`mset`相当于数据库中的事务，只有都写入成功才继续。

```php
Cache::set('test_key','some value',60);

Cache::set([
    'key1'=>'value1',
    'key2'=>'value2'
],60);
```

`get`获取 {#get}
----------
get快速获取存储

>```php
>function get(string $key, string $defualt=false):boolean|string;
>function get(string $array):array;
>```

* 双参数：
    1. `string` $key：获取的键值
    2. `string` $defualt:默认值
* 数组参数： 返回array
    
```php
Cache::get('test_key');
Cache::get('no_key');//false
Cache::get('no_key','default');//返回'default'

Cache::get(['key1','key2']);//返回数组['key1'=>'value1','key2'=>'value2']
Cache::get(['key1','key2','no_key']);//返回数组['key1'=>'value1','key2'=>'value2','no_key'=>false]
```

`del`删除 {#del}
----------
del快速删除

>```php
>function del(string $key):boolean;
>```

* 参数 `string` $key：键值


```php
Cache::del('test_key');
```


`flush`清空 {#flush}
----------
清空全部数据
>```php
>function flush();
>```

```php
Cache::flush();
```


`handler`清空 {#handler}
----------
获取处理方式
>```php
>function handler();
>```

```php
$handler=Cache::handler();
```