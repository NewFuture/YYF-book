Yaf\_Controller\_Abstract
========================

每个自定义controller都直接或者间接继承Yaf\_Controller\_Abstract。

无法定义`__construct`方法。但是可以使用`init()`方法初始化。

```php
Yaf_Controller_Abstract::forward //  forward 
Yaf_Controller_Abstract::getInvokeArg //  getInvokeArg 参数
Yaf_Controller_Abstract::getInvokeArgs // getInvokeArgs 全部参赛
Yaf_Controller_Abstract::getModuleName // 获取当前控制器所属的模块名

Yaf_Controller_Abstract::getRequest // 获取请求对象
Yaf_Controller_Abstract::getResponse // 获取响应对象

Yaf_Controller_Abstract::init // 控制器初始化

Yaf_Controller_Abstract::redirect // 重定向
Yaf_Controller_Abstract::initView // initView 
Yaf_Controller_Abstract::getView // 获取当前的视图引擎
Yaf_Controller_Abstract::getViewpath // 获取视图路径
Yaf_Controller_Abstract::setViewpath //设置模板路径
Yaf_Controller_Abstract::display // 显示输出
Yaf_Controller_Abstract::render // 渲染视图模板
```

更多参考[php手册](http://php.net/manual/class.yaf-controller-abstract.php)