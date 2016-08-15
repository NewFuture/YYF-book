数据库使用示例
================

SQL语句查询
----------
```php
//1
Db::query('SELECT * FROM user WHERE id=?',[1]);
//2
Db::execute('INSERT INTO user (name,org) VALUES (?, ?)',['future','NKU']);
/*等效操作*/
//3
Db::execute('INSERT INTO user (name,org) VALUES (:name, :org)',['name'=>'future','org'=>'NKU']);
```


数据库对象映射
-------------

```php
/*2，3，4，5，6操作等效*/
//4
Db::table('user')->insert(['name'=>'future','org'=>'NKU']);
//5
Db::table('user')->set(['name'=>'future','org'=>'NKU'])->add();

/*插入时使用别名*/
//6
$data=['username'=>'future','organization'=>'NKU'];
$user->field('name','username')
        ->field('org','organization')
        ->insert($data);

/*字段过滤和批量插入*/
//7
$data=[
    ['name'=>'test'],
    ['name'=>'test2'],
    ['id'=>1000,'name'=>'test3'],
    ['password'=>'xyz','name'=>'test4'],
    ['id'=>123]
];
$response =  UserModel::field('name')->insertAll($data);

/*查询*/
//7
$response =  Db::table('user')
                ->where('id','BETWEEN',5,8)
                ->select('id,name');

//8
$user = Db::table('user')->find(1);

//9
$username = Db::table('user')->where('id',1)->get('name');
//等效操作
$username = Db::table('user')->find(1)->name;

//10
$response=  Db::table('user')
            ->where('name','NOT LIKE','%future')
            ->where('id','in',[100,10,1])
            ->select();

//11
$response=  Db::table('user')
            ->where(['name'=>'future'])
            ->where('id','>',10)
            ->limt(5);
            ->select();
//12
Db::table('user')
            ->where()
            ->page(3,5)
            ->select();

/*修改*/
//13
Db::table('user')->where('id',1)->update(['name'=>'first user']);

//14
if($user =  Db::table('user')->find(2))
{
    $user->field('name')->set('name','second user')->save();
}


/*删除*/

Db::table('user')->delete(10);
//等效
Db::table('user')->where('id','=',10)->delete();

```

使用model
-----------
定义如下model `app/models/User.php`
```php
<?php class UserModel extends Model{}
```

```php
UserModel::set('name','yyf')->add();

$user=UserModel::find(1);

UserModel::page(2,10)->select('id,name');
```
    