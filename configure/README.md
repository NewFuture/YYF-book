# 配置说明

* [配置格式](#style)
* [应用配置app.ini](#app.ini)
* [私密配置secret.*.ini](#secret.ini)

## 配置格式 {#style}

整个框架配置文件为`ini`格式,在生产环境下，可以通过缓存配置提高部分性能。


```ini
;逗号至行末为注释
key = "string"
;数组
sub.index = 1234
```

其中支持PHP常量

可以通过不同节([section])区分不同环境

## 应用配置 app.ini {#app.ini}

应用配置文件为 `conf/app.ini`

* \[common\] 下为公用的系统配置
* \[dev\] 下为开发环境下采用的配置，方便调试和快速开发环境兼容为主
* \[product\] 为生产环境采用的配置，安全高性能为主

`dev`和`product`可以覆盖公用配置

通过不同环境配置可以不用修改任何代码和配置同步跟新和实时部署。


## 私密配置 secret.*.ini {#secret.ini}

与账号API授权相关的私密内容(如数据库账号密码)放置于`secret.*.ini`中

可以通过设置app.ini中的`secret_path`来修改文件位置，这样不同环境可以方便的使用不同配置

* secret.commont.ini 配置样例
* secret.dev.ini 此配置不会同步，可以修改secret_path来设置不同的开发配置，适合多人协作
* secret.product.ini 生产环境配置，不同步，仅在服务器上使用

