RSA 加密存取
==========

RSA是非对称加密，`Rsa`对其简单封装(需要rsa扩展),可以放到加密和解密.


接口方法
-----------
* [Rsa::encode($string,$id=null) Rsa加密](#encode)
* [Rsa::decode($string,$id=null) Rsa解密](#decode)
* [Rsa::pubKey($id=null) 获取对应的公钥](#pubKey)


`encode` 加密 {#encode}
----------
Rsa加密

>```php
>function encode( string $id=null);
>```

```php
Rsa::encode('someidstring');
Rsa::encode('someidstring',123456);
```

`decode` 解密 {#decode}
----------
Rsa解密

>```php
>function decode( string $id=null);
>```

```php
Rsa::decode('xxxxx');
Rsa::decode('xxxx',123456);
```

`pubKey` 获取公钥 {#pubKey}
----------
获取加密公钥 Rsa 公钥

>```php
>function pubKey( string $id=null);
>```

```php
Rsa::pubKey();
Rsa::pubKey(123456);
```
