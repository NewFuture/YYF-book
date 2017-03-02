运行生命周期
=============


YYF的生命周期和YAF的生命周期基本一致。

## Bootrap

Boostrap可以根据需要开启，最先执行，进行各种初始化工作。

比如添加自定义路由或者插件钩子?

开发环境，各种debug调试环境在此检查和初始化。

## 插件

[插件Plugins](http://php.net/manual/zh/class.yaf-plugin-abstract.php)可以加载各种钩子在不同适合执行

具体可以加载如下周期
* routerStartup
* routerShutdown
* dispatchLoopStartup
* preDispatch
* postDispatch
* dispatchLoopShutdown

## REST控制器

REST控制器验证请求，处理数据，二次路由

## Controller和Action

执行路由对应的Action，然后响应数据




