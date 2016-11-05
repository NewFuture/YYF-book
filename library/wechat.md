Wechat 微信常用操作静态封装
===========

`Wechat` 类:
对微信登录和JS签名等进行快捷封装,只需调用指定的方法，会自动生成和验证。

使用前保证账号具有相应权限，并在微信上正确配置相关域名。

(正确配置后此接口会自动生成验证state和缓存签名授权)

接口和方法列表 {#interface}
-------------
- 方法接口
    * [Wechat::getAuthUrl()](#getAuthUrl) 获取微信内端认证跳转链接
    * [Wechat::checkCode()](#checkCode) 静默认证验证
    * [Wechat::getUserInfo()](#getUserInfo) 获取用户相信信息
    * [Wechat::signJs()](#signJs) 对URL进行JS签名数据生成
    * [Wechat::loginConfig()](#loginConfig) web端微信登录JS配置生成
    * [Wechat::state()](#state) 设置或者读取state设置

- 相关配置(secret.*.ini中`[wechat]`相关配置)
    * `appid`: 微信开发应用ID
    * `secret`: 微信开发APPKEY
    * `state`: 回调自动验证state方式防止重复 'cookie' 或这 'session'，为空['']不进行自动验证
    * `redirect_base`: 微信内静默授权回调 snsapi_base (不弹出授权页面，直接跳转，只能获取用户openid）
    * `redirect_userinfo`: 微信内授权回调URL ;snsapi_userinfo （弹出授权页面，可通过openid拿到昵称、性别、所在地）
    * `redirect_login`: 微信网页登录回调URL 开发者接口 ;snsapi_login (网页端登录)
    * `js.*`: 生成签名配置时的附加参数如`js.debug=1`开启微信JS调试

微信类接口
--------------

### getAuthUrl生成 {#getAuthUrl}
```php
function getAuthUrl($scope = 'userinfo', $redirect = null): string
```
* 参数 $scope string: 授权类型
    1. `userinfo`(获取详细信息,默认)
    2. `base`(静默授权)
* 参数$redirect string: 回调url，默认读取配置
* 返回：string 重定向URL
* 代码

```php
//根据配置生成获取详细信息url
$url=Wechat::getAuthUrl();

//微信内静默授权 
$url=Wechat::getAuthUrl('base');

//在controller中可以直接重定向
$this->redirect($url);
```

### checkCode验证微信返回的code {#checkCode}
获取用户openid或者token通常配合静默授权使用
```php
function checkCode($key = 'openid', $code = false): mixed
```

* 参数$key, string: 指定获取的内容
    1. `openid`,默认获取openid
    2. `access_token`,获取授权token
    3. `null`或者false返回整个数组
* 参数$code, string: 验证的code,默认读取`GET`参数
* 返回:
    - 验证失败：返回false
    - 验证成功返回 对应的值（string或者array）
* 代码

```php
//微信回调操作,配合 Wechat::getAuthUrl('base')使用
$openid=Wechat::checkCode();
```

### getUserInfo微信详细信息回掉 {#getUserInfo}
获取用户的详细信息
```php
function getUserInfo($code = false): array
```

* 参数$code, string: 微信回调code，默认自动读取get参数
* 返回:
    - 验证失败：返回false或者null(code无效返回null)
    - 验证成功返回 array包括{openid,nickname,headimgurl,sex,language,city,province,country,privilege}
* 代码

```php
//微信回调操作,配合 Wechat::getAuthUrl('userinfo')使用
$info=Wechat::getUserInfo();

```

### signJs JS授权签名 {#signJs}
微信分享等接口需要使用JS签名
```php
function signJs($url = false): array
```

* 参数$url, string: 签名的url,如果未设置默认自动读取请求的refer
* 返回:
    - 验证失败：返回null
    - 验证成功返回 array包括{appId,timestamp,nonceStr,signature}
* tips： 授权返回数据可直接返回到客户端进行签名验证
* tips： 如果没有此即可任何跨域限制和授权验证，请务必制定url防止接口被其他网站调用
* 代码

```php
$data=Wechat::signJs();//自动获取访问url签名
$data=Wechat::signJs('http://yyf.yunyin.org/h5.html');//对指定url签名
echo json_encode($data);
```

### loginConfig 生成网页端登录的配置 {#loginConfig}
网页端调用微信登录API
```php
function loginConfig($redirect  = false): array
```
* 参数$redirect string: 回调url，默认读取配置
* 返回配置数组：{'appid','scope','redirect_uri'}
* 代码
```php
$config=Wechat::loginConfig();
```

### state 自定义状态设置或者读取 {#state}
微信验证中，有一个get参数`state`供回调验证,默认生成随机字符验证.

也可以通过state()方法动态设置state或获取参数

```php
function state([$state]): mixed
```
* 无参数时，返回当前设置的state状态
* 有参数时，返回当前实例可继续操作

```php
$state=Wechat::state();//获取当前的state设置

//使用指定的state生成跳转url
$url=Wechat::state('specail_state_string')->getAuthUrl();
//等效操作
Wechat::state('specail_state_string')
$url=Wechat::getAuthUrl()

//使用指定的state进行验证
$info=Wechat::state('specail_state_string')->getUserInfo();
//等效操作
Wechat::state('specail_state_string');
$info=Wechat::getUserInfo();

//临时关闭,验证
$openid=Wechat::state(FALSE)->checkCode();
```
