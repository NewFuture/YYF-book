日志(Logger)
================

日志记录是重要的调试工具和排错依据。尤其在生产环境,日志记录几乎是最有效的debug信息。
YYF对系统日志进行轻量封装.完全兼容[PSR-3日子接口](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-3-logger-interface.md).

* 开发环境：(方便调试)
   - 开发模式默认使用文件(`file`)日志保存到`runtime\log\yy-mm-dd-TYPE.log` (每种类型一天一份)方便查看
   - 默认记录`EMERGENCY`,`ALERT`,`CRITICAL`,`ERROR`,`WARN`,`NOTICE`,`INFO`,`DEBUG`,`SQL`(数据库查询),`TRACER`(资源消耗统计)等信息
   - 为了方便调试，开发环境会对日志记录进行自动监视。

* 生产环境：(安全高效)
    - 默认发送到系统日志(`system`)(写入效率更高，尤其在高并发写入时)。
    - 默认记录`EMERGENCY`,`ALERT`,`CRITICAL`,`ERROR`,`WARN`等信息
    - 如果生产环境使用文件(`file`)日志,为保证数据安全文件权限会默认设为`600`

日志接口
---------------------
[**基础方法**](#basic)
* [Logger::log($level, $message [, $context])](#log)
* [Logger::write($msg, $level = 'NOTICE')](#write)
* [Logger::clear()](#clear)

[**PSR-3日志接口**](#psr3)
* Logger::emergency($message [,$context])
* Logger::alert($message [,$context])
* Logger::critical($message [,$context])
* Logger::error($message [,$context])
* Logger::warning($message [,$context])
* Logger::warn($message [,$context])
* Logger::notice($message [,$context])
* Logger::info($message [,$context])
* Logger::debug($message [,$context])

基础方法最底层接口 {#basic}
-------------

### `write()`快速写入 {#write}
快速写入会根据日志级别设置自动过滤日志level

>```php
>function write(string $message [,string $level="NOTICE"]):boolean
>```

* 参数：
    1. `string $message`[必填] :记录消息
    2. `string $level`[选填]: 日志级别 默认是 NOTICE(自动转成大写)
* 返回：`boolean` 日志是否写入成功
* 示例代码

```php
//快速查询
Logger::write('somae message');
Logger::write('error message','ERROR');
```



### `log()`写入日志 {#log}
对write的扩展,可以写入数组对象或者模板消息

>```php
>function log(string $level, mixed $message, [array context]):boolean
>```
* 参数：
    1. `string $level`[必填] :日志级别
    2. `string|mixed $message`[必须]: 日志内容，如果能转换字符串会进行json格式化
    3. `array $context` [可选]：模板消息替换,三个参数是第二个参数必须是字符串。模板用`{}`标记
* 返回：`boolean` 日志是否写入成功
* 注意：消息如果是`object`且实现了`__toString()`方法，可直接转字符串
* 示例代码

```php
//字符串写入
Logger::log('ERROR','error message');

//模板消息
Logger::log('WARN','login from {ip}',['ip'=>'12.34.56.78']);//实际消息"login from 12.34.56.78"
//数组对象
Logger::log('DEBUG',['name'=>'tester','info'=>'test']);//实际消息{"name":"tester","info":"test"}

//模板数组
Logger::log('INFO','post message {msg} at {time}',[
    'msg'=$_POST;
    'time'=time();
]);//其中{msg}会被 json_encode($_POST)替换;

````


### `clear()`清空日志 {#clear}

>```php
>function clear()
>```

清空所有日志文件.仅对文件模式`file`有效,(如果系统日志配置了日志文件也可清除).

其他 PSR-3日志接口 {#psr3}
-----
实现8中日志接口类型,对[`log`](#log)进行封装,方便快速高效写入日志
```php
function emergency($message [,$context]):boolean;

function alert($message [,$context]):boolean;

function critical($message [,$context]):boolean;

function error($message [,$context]):boolean;

function warning($message [,$context]):boolean;
function warn($message [,$context]):boolean;

function notice($message [,$context]):boolean;

function info($message [,$context]):boolean;

function debug($message [,$context]):boolean;
```

示例代码

```php
//字符串写入
Logger::error('error message');

//模板消息
Logger::warn('login from {ip}',['ip'=>'12.34.56.78']);
Logger::warning('login from {ip}',['ip'=>'12.34.56.78']);
//数组对象
Logger::debug(['name'=>'tester','info'=>'test']);//实际消息{"name":"tester","info":"test"}

//模板数组
Logger::info('post message {msg} at {time}',[
    'msg'=$_POST;
    'time'=time();
]);

````