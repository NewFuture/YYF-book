# Header 浏览器调试输出

API调试过程中为了方便查看中间变量或者查看运行状态,将调试写入响应头中
(不会破坏后端输出是完整的JSON数据)

为了方便查看和显示，提供chrome插件在浏览器中显示


扩展和接口
==========
* [YYF-Debugger扩展](#YYFDebugger)
* [dump](#dump)
* [SQL记录查询](#sql)
* [Tracer资源消耗统计](#tracer)

## YYF-Debugger (#YYF-Debugger) {#YYFDebugger}
[YYF-Debugger扩展](http://debugger.newfuture.cc/)
[![YYF-Debugger](http://debugger.newfuture.cc/images/console.png)](http://debugger.newfuture.cc/)

安装此扩展可自动解析header调试信息显示在chrome console中


## dump 输出数据 {#dump}

>```php
>function Debug::header([mixed $data]):Header;
>```

将数据dump到header中而不影响输出,可以通过插件显示在console中

```php
Debug::header($data);//$data写如header或者浏览器console,变量名为`dump`

Debug::header()->something($data);//变量名为`something`

支持连续输出
Debug::header('quick dump')
    ->s1('with special name s1')
    ->a1([1,2,'3'])
    ->i1(2333);
```

## SQL查询 {#sql}
开发环境默认会监听所有的sql查询,会详细记录查询过程和结果

```ini
debug.sql.* = 关闭或者设置相关输出
```

```json
Yyf-Sql-[id]:
    {
        "T":"查询耗时",
        "Q":"带参数的查询语句",
        "P":"查询参数",
        "E":"查询错误",
        "R":"result"
    }
```
通过扩展插件可以格式化显示到浏览器控制台


## Tracer资源统计 {#tracer}
自动统计和记录当前请求的资源消耗:内存,时间，文件

tips: 生产环境不会加载调试相关工具和启用配置缓存，内存和时间消耗都会降低许多
