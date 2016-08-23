日志(Logger)

日志接口
---------------------
* Logger::write($msg, $level = 'NOTICE')
* Logger::log($level, $message [, $context])
* Logger::clear()
* Logger::emergency($message [,$context])
* Logger::alert($message [,$context])
* Logger::critical($message [,$context])
* Logger::error($message [,$context])
* Logger::warning($message [,$context])
* Logger::warn($message [,$context])
* Logger::notice($message [,$context])
* Logger::info($message [,$context])
* Logger::debug($message [,$context])