日志(Logger)

日志记录是重要的调试工具和排错依据。尤其在生产环境,日志记录几乎是最有效的debug信息。
YYF对系统日志进行轻量封装,方便开发调试，并保证生产环境高性能和文件安全。

* 开发环境
   - 开发模式默认保存到日志文本方便查看。`runtime\log\y-m-d-TYPE.log`
   - 默认记录`EMERGENCY,ALERT,CRITICAL,ERROR,WARN,NOTICE,INFO,DEBUG,SQL,TRACER`等信息(所有数据)

* 生产环境：
    - 默认发送到系统日志(效率更高，尤其在高并发写入时)。
    - 默认记录`EMERGENCY,ALERT,CRITICAL,ERROR,WARN`等信息


日志接口
---------------------
* [Logger::log($level, $message [, $context])](#log)
* [Logger::write($msg, $level = 'NOTICE')](#write)
* [Logger::clear()](#clear)
* Logger::emergency($message [,$context])
* Logger::alert($message [,$context])
* Logger::critical($message [,$context])
* Logger::error($message [,$context])
* Logger::warning($message [,$context])
* Logger::warn($message [,$context])
* Logger::notice($message [,$context])
* Logger::info($message [,$context])
* Logger::debug($message [,$context])