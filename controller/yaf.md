Yaf\_Controller\_Abstract
========================

每个自定义controller都直接或者间接继承Yaf\_Controller\_Abstract。

无法定义`__construct`方法。但是可以使用`init()`方法初始化。


```php
public $actions ; //自定义Action映射
protected $_module ;//模块名
protected $_name ;//控制器名称
protected $_request ;//当前的请求实例
protected $_response ;//当前的响应实例
protected $_invoke_args ;//调用参数
protected $_view ;//试图引擎
```

方法接口
```php
public Yaf_Controller_Abstract::forward //  forward 
public Yaf_Controller_Abstract::getInvokeArg //  getInvokeArg 参数
public Yaf_Controller_Abstract::getInvokeArgs // getInvokeArgs 全部参赛
public Yaf_Controller_Abstract::getModuleName // 获取当前控制器所属的模块名

public Yaf_Controller_Abstract::getRequest // 获取当前的请求实例
public Yaf_Controller_Abstract::getResponse // 获取响应对象

public Yaf_Controller_Abstract::init // 控制器初始化

public Yaf_Controller_Abstract::redirect // 重定向
public Yaf_Controller_Abstract::initView // initView 
public Yaf_Controller_Abstract::getView // 获取当前的视图引擎
public Yaf_Controller_Abstract::getViewpath // 获取视图路径
public Yaf_Controller_Abstract::setViewpath //设置模板路径
public Yaf_Controller_Abstract::display // 显示输出
protected Yaf_Controller_Abstract::render // 渲染视图模板
```

更多参考[php手册](http://php.net/manual/class.yaf-controller-abstract.php)