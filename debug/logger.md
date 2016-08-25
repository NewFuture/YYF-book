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

>```php
>function write(string $message [,string $level="NOTICE"]):boolean
>```
