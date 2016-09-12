Assert 断言
=======================

断言在框架中多出使用，以确保库被正确规范使用，减少开发过程中不必要的调用错误和编码错误。

在生产环境中，通过禁用系统断言以提高安全性和效率(PHP7生产环境可以对assert断言跳过编译完全0消耗)。

开启断言 {#open}
--------
默认情况必须开启断言才能正常运行; php5.x YYF会在开发环境自动开启断言。

自己安装的PHP7 需要手动开启(大概 1529行,可搜索`zend.assertions`)。
修改`zend.assertions`为`1`或者`0`;

```ini
zend.assertions = 1;或者0
```

关闭断言 {#close}
--------
生产环境关闭断言提高系统稳定性和性能。

```ini
;php 7完全关闭断言
zend.assertions = -1

;关闭断言处理
assert.active = 0
assert.quiet_eval = 1
```

使用断言 {#assert}
-------

可以使用如下方式进行断言[参PHP Manual](http://php.net/manual/zh/function.assert.php)
```php
assert('the assert code which should be TRUE','message on failed');
```

tips:
* 为了保证安全性和运行效率，assert断言务必使用单引号(`'`)包裹起来
* 由于php5.3不支持第二个参数，YYF对此进行了hack以支持第二个参数，但是性能会下降。

