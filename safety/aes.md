AES 加解密库
==========

AES对对称加密(加密和解密密码相同)进行封装，需要openssl扩展,并提供对电话和邮箱的格式保留加密.


方法列表
-----------
* [Aes::base64Encode($str) 路径安全的改进base64编码](#base64)
* [Aes::base64Decode($str) 路径安全的改进base64解码](#base64)
* [Aes::encrypt($data, $key, $safe64) AES加密](#aes)
* [Aes::decrypt($data, $key, $safe64) AES解密](#aes)


## Base64 加解密 {#base64}

对base64的特殊字符进行简单替换，可以用作`路径`(`文件`名或者`URL`中)以及变量的key。

>```php
>Aes::base64Encode(string $str):string
>Aes::base64Decode(string $str):string
>```

特殊替换表
| BASE64中的字符 | 替换字符 | 
| :---:| :---: | 
| = | _ |
| + | - |
| / | . |


Example
```php
//= 替换
Aes::base64Encode('YYF Encrypt');//WVlGIEVuY3J5cHQ_
Aes::base64Decode('WVlGIEVuY3J5cHQ_'); //YYF Encrypt

//+ 替换
Aes::base64Encode('测试字符串');//5rWL6K+V5a2X56ym5Liy
Aes::base64Decode('5rWL6K-V5a2X56ym5Liy'); //测试字符串

// 无特殊字符时 与 base64_encode()结果一致
Aes::base64Encode('YYF');//WVlG
Aes::base64Decode('WVlG');//YYF
```

## AES 加解密 {#aes}

对高级可逆加密算法进行封装。

>```php
>Aes::encrypt(string $data, string $key, bool $safe64 = false):string
>Aes::decrypt(string $cipher, string $key, bool $safe64 = false):string
>```
参数：
* `$key`：密码
* `$safe64`: 是否对加密结果进行*安全BASE64*编码

注意：
**相同的密码和密文每次加密的结果一般不同**


Example
```php
//raw
$cipher = Aes::encrypt('YYF AES','secretkey');
Aes::decrypt($cipher,'secretkey');

//安全64编码
$cipher = Aes::encrypt('YYF AES','secretkey',true);
Aes::decrypt($cipher,'secretkey',true);
```
