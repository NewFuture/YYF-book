Rest控制器
=========

* [init()初始化](#init)
* 响应输出
    - [$response 设置响应数据](#_response)
    - [$code 设置状态码](#code)
    - [response($status, $data,$code) 快速响应](#response)
    - [success() 快速响应成功操作](#success)
    - [fail() 快捷响应失败操作](#fail)
* 配置

init方法 {#init}
--------

当所有action都需要同样的操作可以使用`init`方式,

如果继承自Rest的控制器定义了init方法，会阻止父级(Rest)的初始化操作(参数绑定和跨域响应等)

如下

```php
class MyController extends Rest
{
  /*初始化操作*/
  protected function init()
  {
      parent::init();//完成REST初始化
      //do something
  }
}
```


输出响应 {#output}
-------

### $response {#_response}

```php
protected $response; //自动返回数据 array
```

可以通过设置 `$response` 设置输出

如
>`$this->response=['key'=>'value'];`

输出响应
>`{"key":"value"}`

### $code {#code}

```php
protected $code = 200; //响应状态码
```

响应状态码默认200

### response 方法 {#response}

```php
protected function response($status, $data = null, $code = null)
```

1. 参数int   $status 返回状态
2. 参数mixed $data   返回数据
3. 参数int   $code   可选参数，设置响应状态吗

如:
>`$this->response(1,'OK');`

输出:(状态码200)
>`{"status":1,"data":"OK"}`


### success方法 {#success}

```php
protected function success($data = null, $code = 200)
```
操作成功的操作(status为1)

如:
>`$this->success('OK');`

输出:(状态码200)
>`{"status":1,"data":"OK"}`

### fail方法 {#fail}
```php
protected function fail($data = null, $code = 200)
```
操作成功的操作(status为0)

>`$this->success('something wrong');`

输出:(状态码200)
>`{"status":0,"data":"something wrong"}`

## 配置 {#config}

`conf/app.ini`中可以对REST进行简单的配置，比如修改数据字段或者状态字段

* `rest.param`  : id形默认绑定参数 如 /User/123 =>绑定参数$id值未123
* `rest.action` : 默认绑定控制器如 /User/123 =>绑定到 infoAction
* `rest.none`  : 请求action不存在时调用控制器默认_404Action
* `rest.status`: 返回数据的状态码字段
* `rest.data`  : 返回数据的数据字段
* `rest.json` : json格式