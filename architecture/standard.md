格式规范
==========

YYF 基本遵循 [PSR-2](http://www.php-fig.org/psr/psr-2/) 格式规范，部分地方有修改和加强,具有可参照此项目的`PHP_CS`配置[.php_sc.dist](https://github.com/YunYinORG/YYF/blob/master/.php_cs.dist)。根据团队或者项目的实际情况使用自己的格式规范。


## 文件编码 {encode}

为了保持一致性和兼容性所有PHP文件使用 `UTF-8`并且`去BOM信息头`(windows下开发可能需要注意)的格式保持。

tips: 通常,这些工作，编辑器可以轻易的帮你完成!


## 文件命名和class名 {filename}

为了正确方便的自动加载，所有`文件名`和`class`名以`大写驼峰`的方式命名如`MyClass.php`
文件夹名，出了库中文件夹大写驼峰(与namespace一致)，其他通常小写。

* 库文件名： 文件名和class名一致
* controller: 文件名省略`Controller`如 `Index.php`对应类`IndexController`
* models: 文件名省略`Model`如 `User.php`对应类`UserModel`
* 模板文件后缀为`.phtml`

## 类成员

* 方法名`小写驼峰`：如`getDetail()`
* 私有方法**推荐**`_小写驼峰`：如`_privateMethod()`
* 变量名`小写驼峰`：如`userName`
* 私有变量**推荐**`_小写驼峰`：如`_privateData`
* 常量和宏常量`全大写`:如`CONST_VAR`

## 数据库

全部`小写下划线`如：`my_table`

详细转到[数据库设计](/database/#design)
