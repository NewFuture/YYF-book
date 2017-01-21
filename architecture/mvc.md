MVC架构
==========

主要内容
--------

1. [MVC框架](#mvc)
2. [控制器Controller](#controller)
3. [数据模型Model](#model)
4. [视图模板View](#view)

MVC框架 {#mvc}
----------
WEB开发框架中，通常分为MVC三层。

* Model(M)数据模型层，对数据库操作进行封装;
* View(V)视图层,对数据渲染输出页面;
* Controller(C)是核心逻辑控制层.

在YYF框架中：(app下三个字目录)
**C** 控制层(controllers/)是必须，处理不同请求,同时对REST做了相应映射; 
**M** 数据模型层(models/),数据库底层核心库中，已做了简单封装;
**V** 视图模板层(views/),通常省略，因为API通常输出是JSON字符串。

控制器Controller {#controller}
----------
控制器是最核心和主要的部分，文件存放于`controllers`目录下，一个Controller又包含多个Action。
每个请求会映射到一个对应的Action，通常一个Action对应controller中的一个方法(method)。

在YYF中，需要从基类集成而来，可以选择从`REST`(YYF的REST控制器)，或从最底层`Yaf_Controller_Abstract`(Yaf的控制器基类)继承而来。
class名以controller为后缀结束,文件名不包含(controller)。


例如一个请求的URI `/Abc/xyz` 对应控制器`AbcController`的方法`xyzAction()`

```php
<?
/**
* 文件名 app/controllers/Abc.php
*/
class AbcController extends Rest
{
   function xyzAction(){
       $this->success('response success');
   }
}
```

通过`REST`控制器不仅可以将每个URI对应到不同的action方法上,还可以将不同的请求方式(`GET`,`POST`等)映射到action上
如`GET_xyzAction()`对应GET请求，`PUT_xyzAction()`对应PUT请求。


数据模型Model {#model}
----------
数据模型对数据库操作进行封装,yaf中没有提供对数据库的封装，YYF对常用的MySQL和SQLite进行了安全简单的封装(ORM),并提供了一致的操作接口。
详细接口参见[Orm](../database/orm.md)和[Model](../database/model.md)

YYF中提供两种方式处理数据模型
* 简单高效的，动态创建数据模型(Orm)使用`new Orm('name')`或者[`Db::table('name)`](/database/model.html#table)
* 优雅自定义，使用自定义Model继承自`Model`并保存于`app/models/`目录下。

视图模板View {#view}
----------
YYF中默认是关闭了视图渲染，因为作为API接口通常返回的数据是JSON等纯数据格式，不需要视图渲染。

而YAF中提供了最简单的模板，使用最原始的php语法解析(也是最高效的解析方式),存储文件为phtml。
文件名如下可自动对应`app/views/控制器/Action.phtml`

