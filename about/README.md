
快速开始
==============

快速开始
-----
1. [hello world](#helloworld)
2. [REST请求(GET POST)](#rest)
3. [id映射](#id)


1. hello world 示例 {#helloworld}
-------------
首先经典的hello world! 

首先新建一个`app/controllers/Index.php`(实际上已经存在了，可以打开直接修改！)

```php
<?php
class IndexController extends Rest
{
	/*首页*/
    public function indexAction()
    {
        echo 'hello world!';
    }
}

```

然后打开浏览器 输入你的调试地址`192.168.23.33`(YYF虚拟机),`127.0.0.1:1122`(PHP测试服务器)或者`localhost`(本机)

就能看到如下内容,就成功了(这是经典的MVC流程，请求`/`内部的的过程 `IndexController`(默认)`->` `indexAction`（默认）)
```
hello world!
```

2. REST请求 {#rest}
-------------
常用的请求如`GET`,`POST`,`PUT`,`DELETE`等,不同的请求使用不同的action来响应。

通常数据采用json来编码。


### 2.1. `GET`请求 {#GET}

在建一个Controller `app/controllers/Test.php`,内容如下

```php
<?php
class TestController extends Rest
{
    /*响应 GET /Test/demo*/
    public function GET_demoAction()
    {
        $this->response(1,'Hello,it is a GET request!');//响应数据
    }
        /*响应 POST /Test/demo*/
    public function POST_demoAction()
    {
        $info['method']='POST';
        Input::post('msg',$info['msg']);//获取POST数据
        
        $this->response['status'] = 1;//响应状态
        $this->response['info']   = $info;//响应数据
    }
}
```

打开浏览器 `{测试主机}/Test/demo` (其中`{测试主机}`为`192.168.23.33`,`127.0.0.1:1122`或`localhost`)

会看到如下数据
```json
 {"status":1,"info":"Hello,it is a GET request!"}
```

浏览器默认打开URL是GET 请求， `GET /Test/demo` 被路由到 `TestController->GET_demoAction()`。

`response()`会直接把数据格式换成json输出。


### 2.1. `POST`请求 {#POST}

接着在`app/controllers/Test.php`添加一个新的action `POST_demoAction`,如下

```php
    /*响应 POST /Test/demo*/
    public function POST_demoAction()
    {
        $info['method']='POST';
        Input::post('msg',$info['msg']);//获取POST数据赋值到$info['msg']
        
        $this->response['status'] = 1;//响应状态
        $this->response['info']   = $info;//响应数据
    }
```

然后用curl命令(windows可以使用使用浏览器插件测试)模拟一个POST请求(`192.168.23.33`换成测试主机地址即可)
```bash
curl -X POST -d "msg=这是一条POST请求!" 192.168.23.33/Test/demo 
```
返回数据如下(为了方便阅读json数据已经格式化)
```json
{
    "status":1,
    "info":
    {
        "method":"POST",
        "msg":"这是一条POST请求!"
    }
}
```

`POST /Test/demo`=>`TestController->POST_demoAction()`进行响应

3. id参数映射 
------------

id