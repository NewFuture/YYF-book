Model 数据库模型 
================

数据库模型的核心

## 创建一个Model {#create}

### 一句话的的Model

在目录`app/models/`下新建`User.php`
文件中写入如下代码
```php
class UserModel extends Model{}
```
然后就可以在其他地方，如controller里面通过`UserModel`来调用了
```php
$user=UserModel::find(2);
$name=UserModel::where('id',2)->get('name');
```

注意：上面的这种方式，依赖于_数据库命名小写和`id`作为主键的_的命名规范。

如果数据库中user表不是`user`而是`User`（大写）甚至是`UserData`
这种方式需要制定数据表名称

### 设置Model的配置

如果数据库中用户表命名为`User`,主键为`user_id`，可以如下定义

```php
class UserModel extends Model
{
    protected $_name = 'User'; //数据库表
    protected $_pk = 'user_id'; //主键 
}
```