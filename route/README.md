默认路由
===============

默认路由(无需任何配置)会自动将请求(`http://your.domain/index.php/REQUEST_PATH`)路由到不同action操作上:

缺省Action为`index`,缺省Controller为`index`。

* [基本路由 /Controller/Action](#basic)
* [REST路由 /Controller/Action](#basic)
* [ID参数路由 /Controller/:id/Action](#id)
* [多模块路由 /Module/Controller/Action](#module)

基本路由 {#basic}
---------

```
/Controller/Action
```

最基本的根据控制器和action映射到对应的操作上.

如请求：`/C/a`,对应到`CController`的`aAction()`方法上

REST路由 {#rest}
--------------

针对不同的请求方式`$METHOD`(如`GET`,`POST`,`PUT`,`DELETE`等)，会映射到`$METHOD`_actionAction上

如GET请求：`/C/a`,对应到`CController`的`GET_aAction()`方法上

注: YYF的REST控制器种 rest路由的优先级高于basic优先级，当`METHOD_NAMEAction`不存在时，尝试调用`NAMEAction`。

ID参数路由 {#id}
----------------
```
/Controller/:id/Action
```
特殊的，包含数字(id)的请求,会做特殊映射，此数字会绑定到`Action`的参数`$id`上，

如GET请求：`/C/123/a`,对应到`CController`的`aAction($id)`方法上并绑定参数`$id=123`

注：REST路由，同样适用。

多模块路由 {#module}
--------
```
/Module/Controller/Action
```

当启用多模块支持时，模块名作为前导。

