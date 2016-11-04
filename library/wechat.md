Wechat 微信常用操作静态封装
===========

`Wechat` 类:
对微信登录和JS签名等进行快捷封装,使用前保证账号具有相应权限，并在微信上正确配置相关域名。

接口和方法列表 {#interface}
-------------
- 方法接口
    * [Wechat::getAuthUrl()](#getAuthUrl) 获取微信内端认证跳转链接
    * [Wechat::checkCode()](#checkCode) 静默认证验证
    * [Wechat::getUserInfo()](#getUserInfo) 获取用户相信信息
    * [Wechat::signJs()](#signJs) 对URL进行JS签名数据生成
    * [Wechat::loginConfig()](#loginConfig) web端微信登录JS配置生成
    * [Wechat::state()](#transstateact) 设置或者读取state设置

- 相关配置(secret.*.ini中`[wechat]`相关配置)
    * `appid`: 微信开发应用ID
    * `secret`: 微信开发APPKEY
    * `state`: 回调自动验证方式 'cookie' 或这 'session'，为空['']不进行自动验证
    * `redirect_base`: 微信内静默授权回调 snsapi_base (不弹出授权页面，直接跳转，只能获取用户openid）
    * `redirect_userinfo`: 微信内授权回调URL ;snsapi_userinfo （弹出授权页面，可通过openid拿到昵称、性别、所在地）
    * `redirect_login`: 微信网页登录回调URL 开发者接口 ;snsapi_login (网页端登录)

微信类接口
--------------

### getAuthUrl生成 {#getAuthUrl}
>```php
>getAuthUrl($scope = 'userinfo', $redirect = null): string
>```
* 参数：
    1. string $scope:授权类型 `base`(静默授权)或者`userinfo`(获取详细信息)
    2. string $redirect: 回调url默认读取配置
* 返回：重定向URL
* 代码

```php
//根据配置生成获取详细信息url
$url=Wechat::getAuthUrl();

//微信内静默授权 
$url=Wechat::getAuthUrl('base');

//在controller中可以直接重定向
$this->redirect($url);
```
