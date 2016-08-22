Config 配置读取
=================
提供一个高效的数据读取接口

接口列表
-----------

* [Config::get($key,$default)读取当前应用配置](#get)
* [Config::getSecret($name,$key)读取私密配置](#getSecret)


`get`获取配置 {#get}
----------

get方法用于快速读取`conf/app.ini`中的配置(当前如果)。

>```php
>function get(string $key [, mixed $default=null]):mixed
>```

* 参数：
    1. `string $key`：获取的键值
    2. `mixed $default`(可选)：默认值，如果读取的值不存在返回此值(默认为null)
* 返回： mixed ，位设置默认值时字符串或Object或者null
    - objec(`Yaf_Config_Ini`):如果是多级配置,返回配置只读，可以使用`toArray`转为array
    - `string`: 如果是最后一项(完整的键) 数字等配置也是string；
*  tips: 如果要转成可写的数组可以使用`toArray`创建一个数组副本；


```php
//获取配置
Config::get('version');

//设置默认值
Config::get('log.type','file');

//多级参数
Config::get('application')->num_param;

//数组方式
Config::get('cors')['Access-Control-Allow-Origin'];

//转换数组
$cors=Config::get('cors')->toArray();
```



`getSecret`获取配置 {#getSecret}
----------

getSecret方法用于快速读取`conf/secret.comment.ini`(生产环境为`conf/secret.product.ini`)中的配置。

>```php
>function getSecret(string $name [, mixed $key=null]):mixed
>```

* 参数：
    1. `string $name`：配置项如`database`,`wechat`
    2. `string $key`(可选)：默认值读取的字段,默认返回整个配置对象
* 返回： mixed ，位设置默认值时字符串或Object或者null
    - objec(`Yaf_Config_Ini`):如果是多级配置,返回配置只读，可以使用`toArray`转为array
    - `string`: 如果是最后一项(完整的键) 数字等配置也是string；
*  tips: 如果要转成可写的数组可以使用`toArray`创建一个数组副本；


```php
//获取配置项
Config::getSecret('wechat');

//获取值
Config::getSecret('database','prefix');

```