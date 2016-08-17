快速开始
==============
介绍几个简单controller，体验一下YYF的运行流程.
以下示例不需要额外路由配置。

几个简单的例子
-----
1. [hello world](#helloworld)
2. [REST请求(GET POST)](#rest)
3. [id映射](#id)


1. hello world 示例 {#helloworld}
-------------
首先输出一个hello world! 

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

就能看到如下内容,就成功了
```
hello world!
```
这是经典MVC的控制器路由流程，请求`/`内部的的过程 `IndexController`(默认)`->` `indexAction`（默认）

2. REST请求 {#rest}
-------------
常用的请求如`GET`,`POST`,`PUT`,`DELETE`等,不同的请求使用不同的action来响应。

数据默认采用json来编码。



在建一个TestController `app/controllers/Test.php`

### 2.1. `GET`请求 {#GET}

 `app/controllers/Test.php`,内容如下

```php
<?php
class TestController extends Rest
{
    /*响应 GET /Test/demo*/
    public function GET_demoAction()
    {
        $this->response(1,'Hello,it is a GET request!');//响应数据
    }
    
    /*可以继续添加其他action*/
}
```

打开浏览器 `{测试主机}/Test/demo` (其中`{测试主机}`为`192.168.23.33`,`127.0.0.1:1122`或`localhost`)

会看到如下数据
```json
 {"status":1,"info":"Hello,it is a GET request!"}
```

浏览器默认打开URL是GET 请求， `GET /Test/demo` 被路由到 `TestController->GET_demoAction()`。

`response()`会直接把数据格式换成json输出。


### 2.2. `POST`请求 {#POST}

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

然后用curl命令(windows可以使用浏览器插件测试)模拟一个POST请求(`192.168.23.33`换成测试主机地址即可)
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

3. id参数映射 {#id}
------------
在`RESTful`的API设计中，URL 通常是这样的例如

1. `https://yyf.yunyin.org/products/1234` 获取id为1234的产品信息(非restful设计可能是这样的`https://yyf.yunyin.org/products/info?id=1234`)
2. `https://yyf.yunyin.org/products/1234/comments` 获取id为1234的产品评论(非restful设计可能是这样的`https://yyf.yunyin.org/comments/list?products_id=1234`)

建一个ProductsController `app/controllers/Products.php`

### 3.1. infoAction 

在`app/controllers/Products.php`中添加一个 `GET_infoAction`
```php
<?php
class ProductsController extends Rest
{
    /*响应 GET /Products/{id}*/
    public function GET_infoAction($id=0)
    {
        $product=['id'=>$id,'more'=>'products 详情'];
        $this->response(1,$product);//响应数据
        
        /* //实际上可能要查询数据库
        if($product=Db::table('product')->find(intval($id))){
            $this->response(1,$product);//响应数据
        }else{
            $this->response(0,'no such product');//无查询结果
        }
        */
    }
    
    /*可以继续添加其他action*/
}
```

`REST`默认会把数字1234绑定到参数`$id`上,并映射到默认的`infoAction`(名字可以在配置中修改)操作上。


浏览器打开`http://192.168.23.33/Products/123` (其中192.168.23.33换成你的测试地址)

```json
{
    "status": 1,
    "info": {
        "id": 123,
        "more": "products 详情"
    }
}
```


### 3.2 id参数绑定

继续在`app/controllers/Products.php`中添加一个 `GET_commentsAction`

```php
/*响应 GET /Products/{id}/comments*/
public function GET_commentsAction($id=0)
{
    $comments=[
        ['id'=>1,'product_id'=>$id,'content'=>'nice!',],
        ['id'=>3,'product_id'=>$id,'content'=>'',],
    ];
    /*  //实际可能需要查询数据库
        $comments=Db::table('comment')->where('product_id',$id)->select();
    */
    $this->response(1,$comments);//响应数据
}
```
数字123被绑定到参数`$id`上，映射到`commentsAction`。

浏览器打开`http://192.168.23.33/Products/123/comments` (其中192.168.23.33换成你的测试地址)

```json
{
    "status": 1,
    "info": [
        {"id": 1, "product_id": 123, "content": "nice!"},
        {"id": 3, "product_id": 123, "content": "" }
    ]
}
```

