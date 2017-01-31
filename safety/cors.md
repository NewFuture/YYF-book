CORS 跨站请求
========

* [cors 跨域请求简介](#summary)
* [服务器端跨域配置](#server)
* [跨域cookie支持](#cookie)

cors 跨域请求简介 {#summary}
-------

HTML5 标准中，明确了针对浏览器(javascript中)跨域请求(CORS)的标准。

通过服务器特定的响应头来设置跨域内容。
其中必须包含的内容:

* `Access-Control-Allow-Origin`: 跨域请求来源，即前端网站地址)和
* `Access-Control-Allow-Methods`: 允许的请求方式

示例显示
```
Access-Control-Allow-Origin : your.domain
Access-Control-Allow-Methods : GET,POST,PUT,DELETE
Access-Control-Allow-Headers : x-requested-with,accept,content-type,session-id,token
```

提示： 浏览器端可使用yyfjs前端库方便处理跨域请求(优化跨域请求预处理，支持cookie)


服务器端跨域配置 {#server}
-----------------
YYF默认对跨域提供了支持，同时提供了方便的配置方便自由调整。
并允许生产环境和开发环境使用不同的配置

配置中即为CORS相关配置
```
cors.Access-Control-Allow-xxx
```

同时提供了**原生CORS协议不支持的方式**
* 多域名支持逗号分割: `Access-Control-Allow-Origin = "site1.your.domain,site2.your.domain"
* 泛域名cookie支持

提示: `*` 设置为允许的请求源,是不安全的方式，生产环境指明请求源最佳。


跨域cookie支持 {#cookie}
------------------------

### 服务器端

CORS请求默认不允许使用cookie(上传到服务器端),需要在服务器端设置
```
Access-Control-Allow-Credentials : true
```

才能开启cookie(虽然cors协议做此设置不支持泛域名`*`,但是YYF中响应时做了些`hack`支持此配置，)

### 客户端

`XMLHttpRequest`默认允许设置cookie。
需要设置参数`Credentials=true`才可。

当使用yyfjs时，如下配置即可自动使用cookie：
```javascript
YYF({
    cookie:true,
});
```
