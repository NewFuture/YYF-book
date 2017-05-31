RSA 加密存取
==========

RSA是非对称加密，`Rsa`对其简单封装(需要openssl扩展),并对密钥进行管理.


接口方法
-----------
* [Rsa::encrypt($string, $id=null) Rsa加密](#encrypt)
* [Rsa::decrypt($string, $id=null) Rsa解密](#decrypt)
* [Rsa::pubKey($id=null) 获取对应的公钥](#pubKey)


`encrypt` 加密 {#encrypt}
----------
Rsa加密

>```php
>function encrypt(string $str, string $id=null);
>```

```php
Rsa::encrypt('someidstring');
Rsa::encrypt('someidstring',123456);
```

`decrypt` 解密 {#decrypt}
----------
Rsa解密

>```php
>function decrypt(string $str, string $id=null);
>```

```php
Rsa::decrypt('xxxxx');
Rsa::decrypt('xxxx','my_rsa');
```

`pubKey` 获取公钥 {#pubKey}
----------
获取加密公钥 Rsa 公钥

>```php
>function pubKey(string $id=null);
>```

```php
Rsa::pubKey();//默认公钥
Rsa::pubKey('myrsa');//相同参数对应相对的公钥私钥对 
```
