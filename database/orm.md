ORM 数据库操作对象
============

Object-Relational Mapping（对象关系映射）

数据库操作的对象核心封装

全部接口列表
---------
* [**select**](#select)
* [**find**](#find)
* [**get**](#get)
* [**insert**](#insert)
* [insertAll](#insertAll)
* [**add**](#add)
* [**update**](#update)
* [**save**](#save)
* [**put**](#put)
* [**increment**](#increment)
* [**decrement**](#decrement)
* [**delete**](#delete)
* [**where**](#where)
* [**orwhere**](#orwhere)
* [whereField](#whereField)
* [orWhereField](#orWhereField)
* [exists](#exists)
* [orExists](#orExists)
* [distinct](#distinct)
* [group](#group)
* [having](#having)
* [orhaving](#orHaving)
* [field](#field)
* [**order**](#order)
* [limit](#limit)
* [**page**](#page)
* [**count**](#count)
* [**sum**](#sum)
* [avg](#avg)
* [max](#max)
* [min](#min)
* [join](#join)
* [**has**](#has)
* [**belongs**](#belongs)
* [union](#union)
* [unionAll](#unionAll)
* [alias](#alias)
* [**set**](#set)
* [**clear**](#clear)
* [**transact**](#transact)
* [debug](#debug)
* [safe](#safe)
* [setDb](#setDb)



## 创建Orm {#create}

有三种方式创建一个ORM对象，所有说明都是基于此对象说明

### 1. new创建 {#new}
这是基本的创建方式如下
```php
$orm=new Orm('user');//为user表创建一个orm对象,默认使用id作为主键
```
`Orm`构造函数接受三个参数： `$table`, `$pk` , `$prefix`
- `$table`string    : 数据库表名
- `[$pk]`string     : 主键，默认"id" 
- `[$prefix]`string : 数据库表前缀,默认读取配置 

```php
$orm=new Orm('user','uid');//为user表创建一个orm对象，设定主键uid
```

### 2. Db类静态调用 {#db-table}
Db类提供静态方法`table`，创建一个orm对象
```php
$orm=new Db::table('user');//创建参数和Orm构造函数的一致
```

### 3. Model类创建 {#model}
通过`UserModel`来直接调用，参见 [Model一节](model.md#create)


## 基本操作 {#basic}

### 读取数据 \(query\) {#query}
读取数据提供`select`，`find`,`get` 三种方法
####  `select()`方法: 批量获取数据 {#select}

>```php
>array function select([string $fields=''])
>```

* 参数 `$fields`[可选] : 指定查询的字段 逗号`,`分隔符，别名用` AS `链接
* 返回 `array`多维数组
* 示例代码

```php
$list=$orm->select('*');//查询所有字段和所有数据
$list=$orm->select('id AS uid,time');//查询id和time，在返回的数据中id用uid表示
```

#### `find()` 方法: 单条数据读取 {#find}
find 方法会自动限制数据的条数

>```php
>object function find([mixed $id=null])
>```

* 参数 :
    - `int`|`string` :  数据的主键值
    - `array`: 查找的条件参看[where](#where)数组参数
    - `NULL`: 无参数使用where等设置查找

* 返回 `Orm` Object 指向调用的`Orm`对象自身(查询成功)或`null`(查询失败) 
* 示例代码

```php
/*主键find*/
$user=$orm->find(2);//查询id为2的数据

/*数组条件*/
$orm->find([
    'id'=>2,
    'status'=>1
]);//查询id为2，status为1的数据
```

#### `get()`方法：获取单条或者单个数据 {#get}
>```php
>mixed function get([string $key = '', boolean $auto_query = true])
>```

* 参数 `$key`[可选] : 要查询的数据键值,默认获取全部数据
* 参数 `$auto_query`[可选] : 数据不存在时是否自动查询数据库，默认自动查询
* 返回 `mixed` (`array`|基本类型)：查询的数据
* 示例代码

```php
/*获取全部数据，返回数组或者null*/
$user=$orm->where('id',2)->get();//查询id为2的全部数据数据
/*获取指定键的值*/
$username=$orm->get('name');//查询用户的姓名，自动同步数据库
```

### 添加数据 \(insert\) {#data-insert}
添加数据提供 `add`,`insert`,`insertAll` 三种方法。

#### `insert()`方法： 插入单条数据 {#insert}
>```php
>int function insert(array $data)
>```

* 参数 `$data`[必须] : 要插入的数据(键值对)
* 返回 `int` ： 插入成功的id(主键值)，适用于自增主键的数据表，操作失败返回`false`
* tips: 数据可以使用过滤`field()`对数据字段进行过滤
* tips: 之前set的数据对insert无影响
* 示例代码

```php
$uid=$orm->insert(['name'=>'future','org'=>'nku']);//插入一条数据
/*对于无自增主键的数据表，不会返回id，可如下===判断插入结果*/
if($orm->insert(['uid'=>1,'pid'=>2])===false){
    // 插入失败
}else{
    //插入成功
}
```

#### `insertAll()`方法: 批量插入数据 {#insertAll}
>```php
>int function insertAll(array $data)
>```

* 参数 `$data`[必须] : 要插入的数据二维数组
* 返回 `int` ： 插入成功的条数
* 数据可以使用过滤`field()`对数据字段进行过滤
* 示例代码

```php
$uid=$orm->insert(['name'=>'future','org'=>'nku']);//插入一条数据
```

#### `add()`方法: 插入已经设置的数据 {#add}
>```php
>object function add()
>```

* 无参数
* 返回 `Orm`对象或NULL： 操作成功返回自身，可以继续其他操作 
* 数据可以使用过滤`field()`对数据字段进行过滤
* tips： 与 insert的区别是会使用之前set的数据
* 示例代码

```php
$uid=$orm
      ->set('name','future')
      ->set('org','nku')
      ->add();//插入之前set的数据
```

### 跟新数据 \(update\) {#data-update}
更新数据提供 `update`，`save`两种方法

#### `update()`方法： 更新数据 {#update}
>```php
>int function update(array $data)
>```

* 参数 `$data`[必须] : 要跟新的数据二维数组
* 返回 `int` ： 跟新成功的条数
* 数据可以使用过滤`field()`对数据字段进行过滤
* tips:
  - 之前set的数据对update**无影响**,如果要保留使用 (save)[#save]
  - 可以跟新多条 `limit`限制最大条数
* 示例代码

```php
/*跟新全部是时间*/
$orm->update(['time'=>date('Y-m-d h:i:s')]);
/*字段过滤*/
$data=['id'=>2,'name'=>'changed name','password'=>'secret'];
$orm->where('id',1)
    ->field('name')
    ->update($data);//只有name字段被更新，其他被过滤
```


#### `save()`方法： 保存数据 {#save}
>```php
>object function save([string $id])
>```

* 参数 $id (可选): 保存的主键值
* 返回 `Orm`对象或者`NULL`： 操作成功返回自身，可以继续其他操作
* 数据可以使用`field()`对数据字段进行过滤
* tips： 与 insert的区别是会使用之前set的数据
* 示例代码

```php
/*字段过滤*/
$data=['id'=>2,'name'=>'changed name'];
$orm->field('name')//只有name字段被更新,其他被过滤
    ->set($data)
    ->save(1);//跟新主键为1的name
```


#### `put()`方法: 快速写入 {#put}

PUT 快速修改单个字段,会立即写入数据库

>```php
>  int function put(string $key,mixed $value)
>```

* 参数 string `$key`: 字段名称
* 参数 mixed `$value`: 对应的值
* 返回 `int`：影响的条数
* 数据可以使用`field()`对数据字段进行过滤和设置别名
* tips： 
* 示例代码

```php
/*把id为1的状态修改为1*/
$orm->where('id',1)->put('status',1);
```

#### `delete()`方法： 删除数据 {#delete}

>```php
>int function delete([string $id])
>```

* 参数 $id (可选): 删除的主键值
* 返回 `int` ： 删除成功的条数
* tips: 可以跟新多条 `limit`进行限制
* 示例代码

```php
$orm->delete(1);//删除id为1的
//where限制
$orm->where('id',1)->delete();
```

## 条件限制 (condition) {#condition}

### 条件查询（where）{#where-method}
支持where操作如下表

| 类型 | 表达式操作($op) | 值 |例子|
|:----:|-----|:----:|------|
| 值比较 |`=`,`<>`,`!=`,`>`,`>=`,`<`,`<=`| 基本类型 | `where($key,>,10)`|
| 空值比较 | `=`,`<>`,`IS`| `NULL` |`where($key,'<>',null)`|
| LIKE比较 |`[NOT ]LIKE`, `[NOT ]LIKE BINARY`| `string`|`where($key,'LIKE','head%')`|
| IN 比较 |`IN`，`NOT IN`|`array`|`where($key,'in',[1,3,5])`|
| BETWEEN |`BETWEEN`, `NOT BETWEEN`|`array`或跟两参数|`where($key,'BETWEEN',1,10)` , `where($key,'BETWEEN',[1,10])` |

#### `where()`方法： 添加选择条件 {#where}

>```php
>object function where(mixed $condition [...])
>```

* 参数支持多种方式: 
  - 三元比较: (参见wehre表) 
    >`where($field,$operator,$value)`
    >

      1. `string` 字段名(`$field`): 字段名如`name`,`user.id`(多表查询存在同名字段时，需要加上表名)
      2. `string` 比较符(`$oprater`): 支持 `=`,`<>`,`!=`,`>`,`>=`,`<`,`<=`,'LIKE`,`NOT LIKE`,等表中所有操作
      3. `mixed` 比较的值(`$value`) : 数值或者字符串或者NULL等,`in`和`between`操作可以是数组

  - 二元相当关系：(三元操作省略`"="`)
    >`where($field,$value)`
    >

      1. `string` 字段名(`$field`): 字段名，多表查询存在同名字段时，需要加上表名
      2. `scalar`(基本类型) 比较的值(`$value`) : 字段的值,`NULL`会被特殊处理变成IS NULL语句

  - 一元数组：(数组批量条件)
    >`where($array)`
    >

      1. 关联数组`array`(` $field=>$value`): 每一组键值对相当于二元相等条件
      2. 二维索引数组`array`(`[$condition1,$condition2,...]`):每组条件相当于一组where条件(不递归)
   
  - 四元区间比较：(BETWEEN条件)
    >`where($field,$BETWEEN,$min,$max)`
    >

      1. `string` 字段名(`$field`): 字段名，多表查询存在同名字段时，需要加上表名
      2. `string`(基本类型) 条件 : `BETWEEN`或者`NOT BETWEEN`
      3. `scalar`(基本类型) 最小值(`$min`) : 下界(或者上界)
      4. `scalar`(基本类型) 最大值(`$max`) : 上界(或者下界)

* 返回 `Object`(`Orm`对象) ： 返回$this继续操作 
* tips: 
    - `NULL`值(`NULL`类型,不是string`"NULL"`,后者会作字符串处理)会被特殊处理
    - 字段值不能是计算表达式,表达式计算用[having](#having)
    - 值不能是字段(会被字符串处理),多标联合可以用[join](#join)
    - 关闭`safe`模式可以在where中使用原生sql条件**不推荐使用**（不安全，也可能造成编译的sql出错，不利于sql缓存）
* 示例代码

```php
/*where 基本操作*/
$orm->where('status','>',0);//大于0： WHERE `status`>0
//null特殊处理
$orm->where('a.status','!=',null);//非空: WHERE `a`.`status` IS NOT NULL

/*where相等简化*/
//缺省等于
$orm->where('status',0);//status为0:W HERE `status`=0
$orm->where('data',null);//查找NULL值: WHERE `data` IS NULL
$orm->where('id',1)->where('status',1);//并列： WHERE `id`=1 AND `status`=1

/*数组参数型*/
//in array
$orm->where('type','IN',[1,3,7]);// 为1，3或者7 : WHERE `type` IN (1,3,7);
// between
//在不范围之内,status< 1或者status>3: WHERE `status` NOT BETWEEN 1 AND 3
$orm->where('status','NOT BETWEEN',[1,3]);

/*四元between*/
$orm->where('status','NOT BETWEEN',1,3);//同上

/*关联数组*/
$orm->where(['id'=>1,'status'=>1]);//WHERE `id`=1 AND `status`=1
/*二维索引数组*/
$condition=[
    ['status','>',0],
    ['name','LIKE','%future%'],
];
$orm->where($condition);//WHERE `status`>0 AND `name` LIKE "%future%"

```

#### `whereField()`方法： 字段比较条件 {#whereField}

由于`where`默认会将比较的值进行参数绑定，所以如果是字段会按照字符处理，`whereField`就是用来比较字段之间的关系，值会按照字段处理。

>```php
>object function whereField(mixed $condition [...])
>```

* 与[where](#where)用法一致
* 示例代码

```php
/*whereField 比较*/
$orm->whereField('up','>','dwon');//up字段值>down的值
```

#### `orWhere()`方法： OR条件  {#orWhere}
同where 连接条件变成OR

>```php
>object function orWhere(mixed $condition [...])
>```

示例代码

```php
/*where和orwhere限制*/
$orm->where('id','<',10)
    ->orWhere('id','>',1000)
    ->select('name');//查询id< 10或者id>1000的用户名
```

#### `orWhereField()`方法： 字段比较条件OR  {#orWhereField}
同where 连接条件一样

>```php
>object function orWhereField(mixed $condition [...])
>```

示例代码

```php
/*where和orwhere限制*/
$orm->where('id','<',100)
    ->orWhereField('regtime','logtime')
    ->select('idname');
```

### 子查询是否存在exists  {#exists-method}

#### `exists()`方法  {#exists}

判断子查询是否存在需要使用exist

>```php
>object function exists(Orm $query[, boolean $not=false,[ string $type='AND']])
>```

* 参数 (`Orm`)`$query`: 包含查询条件的`Orm`对象
* 参数 (`boolean`) `$not`: 为`true`时 查询 not exists,默认是 false
* 参数 (`string`) `$type`: 连接条件 `AND`或者`OR`
* 返回 `Orm Object` ： 返回$this
* 示例代码

```php
/*子查询*/
$subQuery=new $orm('user');
$subQuery->where('id',$id);
$orm->exists($subQuery)
    ->where('id',$id)
    ->select('id,content');
/*另一种方式*/
InfoModel::exists(
        Db::table('user')->where('id',$id)
    )->where('id',$id)
    ->select('id,content');
```

#### `orExists()`方法  {#orExists}
判断子查询是否存在需要使用exist，OR条件链接

>```php
>object function orExists(Orm $query[, boolean $not=false])
>```

用法同 [exists](#exists)


### 分组和去重 {#group}

#### `distinct()`方法: 去除相同的结果

数据库在查询的时候返回所有数据库,distinct 可以去除查询结果中重复的结果(同样的查询记录)

>```php
> object function distinct([boolean $is_distinct = true])
>```

* 参数 (`boolean`) `$is_distinct` : 设置是否去重,默认参数是`true`
* 返回 `Orm` 对象: 可以继续其他操作
* 示例代码

```php
/*查询所有的状态,每种状态显示一个*/
$orm->distinct()->select('status');
```

#### `group()`方法 : 查询结果分组{#group}

GROUP 可以按条件或者字段进行分组， 可以连续使用多个GROUP条件

>```php
> object function group(string $field [, string $operator, mixed $value])
>```

* 参数: 与[where](#where)相似但是不接收数组参数.
    - 一个参数：
        1. `string`(`$field`)[必须]: 分组的字段

    - 两个参数：
        1. `string`(`$field`)[必须]: 字段
        2. `string`(`$value`):  相等条件

    - 三个参数：
        1. `string`(`$field`)[必须]: 分组的字段
        2. `string`(`$operator`): 比较符 参照where
        3. `mixed`(`$value`): 比较值

* 返回 `orm`： 可以继续后续操作
* 示例代码：

```php
/*统计每种状态有多少*/
$orm->group('status')
    ->select('status,count(*) as count');
```


### 计算条件（having） {#having-method}

当查询条件需要使用聚合函数时,需要having函数。WHERE 关键字无法与聚和函数一起使用(sql 中where 先执行)。


#### `having()`方法： 添加选择条件 {#having}

HAVING AND链接的条件

>```php
>object function having(string $field,string $operator,string $value)
>```

* 参数: 与[where](#where)相似但是不接收数组参数.

    - 两个参数：
        1. `string`(`$field`)[必须]: 字段
        2. `string`(`$value`):  相等条件

    - 三个参数：
        1. `string`(`$field`)[必须]: 分组的字段
        2. `string`(`$operator`): 比较符 参照where
        3. `mixed`(`$value`): 比较值
        
* 返回 `orm`： 可以继续后续操作
* 示例代码：

```php
/*统计每种状态出现次数大于100的*/
$orm->group('status')
    ->having('count','>',100)//where 会报错
    ->select('status,count(*) as count');
```

#### `orHaving()`方法： having条件 or {#orHaving}
HAVING 条件 OR 关系，类似于 orWhere

>```php
>object function orHaving(string $field,string $operator,string $value)
>```

用法同 [having](#having)。 

### 字段 {#field}

修改数据或者读取数据时需要进行数据过滤,或者对字段名进行映射时，可以使用`field`方法

#### `field()`方法： 字段过滤和别名设置

>```php
>object function field(mixed $field [, string $alias])
>```

* 参数支持多种方式: 
  - 两个参数: (字段别名设置) 
    >`field($field,$alias)`
    >

      1. `string` 字段(`$field`): 字段名如`name`,`user.id`(多表查询存在同名字段时，需要加上表名)
      2. `string` 别名(`$alias`): 别名如`uid`

  - 数组参数:
    >`field($array)` [$field=>$alias]
    >

     关联数组`array`(` $field=>$value`): 每一组键值对是一组字段别名隐身

  - 字符串参数：(数组批量条件)
    >`field($string)`
    >

     * 多个字段用`,`隔开
     * 别名用`AS`链接 如 `'user.id AS id'`
   

* 返回 `Object`(`Orm`对象) ： 返回$this继续操作 
* tips: 
    - 字段值是聚合表达式时时 必须指定别名
    - 如果设置了field,[修改](#update),[插入](#insert)和[查询](#query)操作会对其过滤
* 示例代码

```php
/*field 二元参数设置别名*/
$orm->field('user_id','uid')
    ->field('name','user')
    ->select();

/*array*/
$orm->field([
        'user_id'=>'uid',
        'name'=>'user',
    ])->select();

/*字符串*/
$orm->field('user_id AS uid,name AS user')
    ->select();
//select 快捷方法
$orm->select('user_id AS uid,name AS user');

/*update过滤,只有name和info会被更新*/
$orm->field('name,info')->update($data);
```

### 排序 {#order}

#### `order()`方法： 设置位置和偏移
添加字段

>```php
>object function order(string $fields [, boolean $desc = false])
>```

* 最多两个参数: 
    1. `string`(`$field`) [必须] : 要排序的字段
    2. `bool`(`$desc`) [默认false]: 是否按照降序排列(默认升序排列)
* 返回 `Object`(`Orm`对象) ： 返回$this继续操作 
* tips: 排序通常和[limit](#limit)结合使用
* 示例代码

```php
/*order排序*/
$orm->order('name',true) // 按照name降序
    ->ordee('id') //再安装id升序(从小到大)
    ->select('name,id');

```

### 分页

#### `limit()`方法：限制读取条数和偏移 {#limit}

>```php
>object function limit( int $maxsize [, int $offset = 0])
>```

* 最多两个参数: 
    1. `int`(`$maxsize`) [必须] : 最大条数
    2. `int`(`$offset`) [默认0]: 偏移量(起始位置)
* 返回 `Object`(`Orm`对象) ： 返回$this继续操作 
* 示例代码

```php
/*limit 限制读取条数*/
$orm->limit(10) //读取10条数据
    ->select('name,id');

/*limit 设置偏移量*/
$orm->limit(10,12) //从12条开始读取10条(到22)
    ->select('name,id');

```

#### `page()`方法： 翻页 {#page}
实际应用中limit 操作通常用来快速翻页,page方法是用来翻页的快速操作

>```php
>object function page( int $number [, int $size = 10])
>```

* 最多两个参数: 
    1. `int`(`$number`) [必须] : 页码
    2. `int`(`$size`) [默认10]: 每页条数
* 返回 `Object`(`Orm`对象) ： 返回$this继续操作 
* 示例代码

```php
/*page 限制读取条数*/
$orm->page(1) //读取第一页(前10条数据)
    ->select('name,id');

/*page 设置偏移量*/
$orm->page(2,15) //每页15条，读取第二页
    ->select('name,id');

```

## 函数 {function}

Orm 中内置一些常用sql函数和操作

### 聚合函数

#### `count()`方法： 统计字段 {#count}
>```php
>int function count( [string $column_name='*', [, boolean $is_distinct = false]])
>```

* 最多两个参数: 
    1. `string`(`$column_name`) [默认*] : 要统计字段默认全部条数
    2. `bool`(`$is_distinct`) [默认false]: 是否去重
* 返回 `int` ： 统计的数目
* 示例代码

```php
/*统计总数*/
$orm->count();

/*统计不重复的字段*/
$orm->count('type',true);

```

#### `sum()`方法： 求和 {#sum}
>```php
>int function sum(string $column_name)
>```

* 参数: `string`(`$column_name`)要计算的字段
* 返回 `int` ： 求和结果
* 示例代码

```php
/*统计总数*/
$orm->sum('score');

```

#### `avg()`方法： 求均值 {#avg}
>```php
>int function avg(string $column_name)
>```

用法同sum

#### `max()`方法： 求最大值 {#max}
>```php
>int function max(string $column_name)
>```

用法同sum

#### `min()`方法： 求最小值 {#min}
>```php
>int function min(string $column_name)
>```

用法同sum


### 自增自减(写操作)

#### `increment()`方法：字段值自增 {#increment}

>```php
>int function increment(string $column_name [,int $step=1])
>```

* 参数：
    1. `string`($column_name): 自增的字段
    2. `int`($step) [可选] : 增加步长默认为1
* 返回： `int` 操作成功的条数
* 示例代码

```php
/*socre值+1*/
$orm->where('id',1)->increment('score');

/*socre值+5*/
$orm->where('id',1)->increment('score',5);
```

#### `decrement()`方法：字段值自减 {#decrement}
>```php
>int function decrement(string $column_name [,int $step=1])
>```

* 参数：
    1. `string`($column_name): 自减少的字段
    2. `int`($step) [可选] : 减少步长默认为1
* 返回： `int` 操作成功的条数
* 示例代码

```php
/*socre值-1 相当于 increment('score',-1)*/
$orm->where('id',1)->decrement('score');

/*socre值-5*/
$orm->where('id',1)->decrement('score',5);
```

## 多表操作

### 多表查询
join 可以链接多个数据库表 ，通常 [`has`方法](#has) 和 [`belongs`方法](#belongs)的封装可以满足绝大多数应用场景，推使用这两个方法。

#### `join()`方法 {#join}
>```php
>Object function join( string $type, string $table, mixed $on [, string  related_key= null])
>```

* 参数：
    - 四个参数简单join： `join($type,$table,string $table_key, string $related_key)`
        1. `string`($type): JOIN 类型 `INNER,LEFT,RIGHT,OUTER,FULL OUTER`等 
        2. `string`($table)： JOIN的表名，支持`AS` 别名
        3. `string`($on)： JOIN 表中的关联字段,不用加上表名或别名
        4. `string`($related_key)：主表获其他表与之相等的关联字段，通常要加上表名
   - 三个参数复杂逻辑(数组条件): `join($type,$table,array $on)`
        1. `string`($type): JOIN 类型
        2. `string`($table): JOIN的表名，支持`AS` 别名
        3. `array`($on) 三维数组: 对于多个条件或者复杂逻辑可以使用这种方式，每个数组包含一下内容
            * [必须]`on`=>array($field,$op,$value),参考[where](#where)表达式参数
            * [可选]`logic`=> 条件关系'AND'或者'OR'， 默认采用AND连接
            * [可选]`value`=>`NULL`或者`'VALUE'`,如果不设置或者为NULL，`on`条件中的值会按字段处理，否则按照值进行绑定

* 返回`Orm`对象：可以继续后续操作
* tips:
    - has或者belongs等操作比复杂条件效率更高也更容易理解
    - 复杂join的 on 条件可以考虑放到where条件
* 示例代码
    
```php
/*简单join关联user表的user.id和article表的user_id*/
$orm->join('INNER','article','user_id','user.id');

/*复杂关联*/
$response= Db::table('comment')
     ->field('from.id as from_id,from.name as from')
     ->field('to.id AS to_id,to.name as to')
     ->join('LEFT','article','id','comment.article_id')
     ->join('INNER','user as from',[// 评论发出的用户
         [
             'on'=>['from.id','=','comment.user_id'],
             'logic'=>'AND',//默认是AND可以省略
             'value'=>NULL,//value为NULL安装字段处理，可以省略
         ],
         [
             'on'=>['from.status','>',0],
             'logic'=>'AND',
             'value'=>'value',//值绑定,on的第三个参数“0” 会按照值处理，而不是字段
         ],
     ])->join('LEFT','user AS to',[//评论文章的作者
         [
             'on'=>['article.user_id','=','to.id'],
         ],
         [
             'on'=>['to.status','>',0],
             'value'=>'value',
         ]
     ])->select();
```

#### `has()`方法 {#has}

has 是对`LEFT JOIN`方法的快捷封装，表示 一个表在逻辑上“拥有”另一个表,比如 用户(user表) 拥有 文章(article表).
可以表示 $user->has('article'). 此时会使用article的外键关联user主键。

>```php
>Object function has(string $table [, string $table_fk = null [, string $related_key = null]])
>```

* 参数：
    1. `string`($table): 关联的表名，可以使用 AS 设置别名
    2. `string`($table_fk) [可选]: has 的 表中对应的外键，默认采用当前Orm对应的表名+'_id'
    3. `string`($related_key) [可选]: 默认是此表的主键，如果多表连接，不是当前表可以加上表名如'table.id'
* 返回`Orm`对象：可以继续后续操作
* 示例代码

```php
/*简单用法*/
$orm->has('article');

/*多级关联，用户有文章，文章有评论*/
$user->has('article')
     ->has('comment','article_id','article.id');

/*完整查询实例*/
$feed=Db::table('user')
    ->has('feedback AS fb')//用户有feedback 设置别名
    ->where('user.id',1)
    ->select('user.id,user.name,fb.title,fb.content as feedback');
```

#### `belongs()`方法 {#belongs}

belongs 是对 `INNER JOIN`方法的快捷封装，表示 一个表在逻辑上“从属”另一个表,于has相反。
比如 文章属于用户 (article 表的外键如 user_id 关联 user表的主键如id)。

>```php
>Object  belongs(string $table [, string $related_key = null [, string $primary_key = 'id']])
>```

* 参数：
    1. `string`($table): 关联的表名，可以使用 AS 设置别名
    2. `string`($related_key) [可选]: 与之关联的外键默认`$table_id`,如果是其他表可以加上表名 `table.fk_id`
    3. `string`($primary_key) [可选]: $table表的主键，默认是`id`

* 返回`Orm`对象：可以继续后续操作
* 示例代码

```php
/*简单用法*/
$article->belongs('user');

/*多级关联，文章属于用户，文章有评论*/
//与has的例子逻辑关系一样，但是查询的主表由user表变成article表
$article->belongs('user')
     ->has('comment');

/*多级关联，实例*/
Db::table('comment')
     ->belongs('user')//评论属于用户
     ->field('user.name','user')//用户名
     ->belongs('article')//评论属于文章
     ->field(['article.title'=>'article'])//选取article 标题
     ->belongs('user AS reply','article.user_id')//文章属于另一个用户
     ->field('reply.id AS rid,reply.name as reciever')//另一个用户的id和姓名
     ->select('comment.*');//comment的所有内容
```

### 合并查询

#### `union()`方法: 合并 {#union}
UNION 将结果合并在一起
>```php
>object function union(Orm $query [, boolean $is_all = false])
>```

* 参数 (`Orm`)`$query`: 包含查询条件的`Orm`对象，相当于执行`select`的结果
* 参数 (`boolean`) `$is_all` 默认false: 为`true`时 UNION ALL 
* 返回 `Orm Object` ： 返回$this
* 示例代码

```php
Db::table('student)
    ->field('id,name,number')
    ->union(
        Db::table('teacher')
            ->field('id,name,number')
    )->select();
```

#### `unionAll()`方法:全部合并 {#unionAll}
UNION 默认会去除相同的结果，UNION ALL 不去重
>```php
>object function union(Orm $query)
>```

* 参数 (`Orm`)`$query`: 包含查询条件的`Orm`对象，相当于执行`select`的结果
* 返回 `Orm Object`: 返回$this
* 用法与[union](#union)同
* 示例代码

```
$orm1->where('...')
    //更多设置
    ->field('...');
$orm->unionAll($orm1)
    ->select();
```

## 其他

#### `transact()`方法：处理事务 {#transact}
几个操作必须都成功执行的时候，需要使用事务.

更底层的事务参见[Database::tansaction](database.md#tansaction)

>```php
>function transact(callable $func) : mixed
>```

* 参数callable $func: 调用函数过程(可以是匿名函数)
   - $func 参数是当前对象(`$this`)
   - 返回值，如果是`false`(严格的false,null,0等控**不是false**),同样执行回滚
* 返回：
    - `false`(执行失败)
    - `$func`的回调值(执行成功)
* tips：
    - 执行过程中出错同样回滚
    - `$func`返回`false`会强制回滚
* 代码

```php
/*事务操作转积分*/
$Orm->transact(function ($user) {
 $user->where('id',1)
      ->increment('score',5);//id为1的用户积分+5
 $user->clear() //清空查询重用
      ->where('id',2)
      ->decrement('score',5);//id为2的积分-5
 return $user->get('score')>0;//判断加分是否为正,如果此时积分小于0依然回滚
});
```


### `debug()`方法: 开启调试输出 {#debug}
程序调试过程中，可能需要输出sql语句，debug开启之后。 对数据库的操作不会执行，而是直接返回sql语句和参数。
影响的操作包括一下操作(返回数组包含 `sql` 和 `param` )
* 查询: `select`,`find`,`get`,`count`,`min`,`max`,`avg`,`sum`
* 添加: `insert`,`add`,
* 修改：`update`,`save`,`put`,`increment`,`decrement`
* 删除：`delete`,

>```php
> object function debug([boolean $enable=true])
>```

* 参数 (`boolean`) `$enable` : 是否开启,默认参数是`true`，设为false时关闭调试
* 返回 `Orm Object` ： 返回$this，可以进行后续操作 
* 示例代码

```php
$query=Db::table('user')
        ->debug()
        ->count();
/*$query 结果如下
Array ( 
    [sql] => 'SELECT COUNT(*)FROM`user`',
    [param] => Array ( ) 
    ); 
*/
```


### `safe()`方法:安全模式 {#safe}
`Orm`在生成sql语句时，会对所有操作进行严格的格式检查，where和field等操作不能使用原生的sql语句或者复杂的查询条件。
必要时可以把safe模式关闭，从而关闭字段格式检查和包装。

警告：尽量**不要使用**此功能，它会降低安全性同时带来不确定因素！

>```php
> object function safe([boolean $enable=true])
>```

* 参数 (`boolean`) `$enable` : 是否开启,默认参数是`true`，设为false时关闭安全模式
* 返回 `Orm Object` ： 返回$this，可以进行后续操作 
* 示例代码

```php
/*各种统计性别人数*/
Db::table('user')->safe(false)//关闭安全模式
    ->field([
       'SUM(CASE WHEN sex = "m" THEN 1 ELSE 0 END)'=>'male', 
       'SUM(CASE WHEN sex = "f" THEN 1 ELSE 0 END)'=>'female' 
    ])->select();//默认情况会报错
```

### `clear()`方法: 清空设置和查询 {#clear}
清空之前此ORM所有的查询设置和数据。
但是 **别名`alias`** 和 **数据库设置** 不会清除。
通常用来放弃之前的操作或者重用对象。
>```php
>object function clear()
>```

* 返回 `Orm Object` ： 返回$this，可以进行后续操作
* 示例代码

```php
$orm->clear()->select();
```

### 设定数据库 {#database}

ORM 会根据配置自动链接数据库
* `_`(必须设置): 主数据库(没有额外设置会使用此数据库) 
* `_read`(可选): 从数据库(读操作数据库),设置此数据库后读操作默认使用此数据库  
* `_write`(可选): 写数据库,设置此数据库写操作优先使用此数据库  

#### `setDb()`方法:设定数据库 {#setDb}
设置数据之后,**当前Orm**对象,读写操作都会直接使用设定的数据库，覆盖默认行为。

>```php
>object function setDb(mixed $db)
>```

* 参数 `mixed` `$db`: 
  - `string` :  配置名称,后会自动使用此配置链接
  - `array` 键值对数组：数据库连接包含
    1. `$db['dsn']`必须: 数据库的DSN
    2. `$db['username']`可选: 数据库账号
    3. `$db['password']`可选： 数据库密码
  - `Database`对象： 直接使用已经建立连接的数据库对象
* 返回 `Orm Object` ： 返回$this，可以进行后续操作
* 示例代码

```php
/*配置名称*/
$orm->setDb('_');//强制使用默认数据库

/*数组配置*/
$orm->setDb([
    'dsn'=>'sqlite:/temp/databases/test.db'
]);//切换到此sqlite数据库

/*数据库对象*/
$db=Db::current();//获取默认数据库
$orm->setDb($db);
```

### `alias()` 方法：设置别名 {#alias}
多表操作有时为了方便需要使用别名设置。Alias 可以设置当前主表的别名。
>```php
>object function alias(string $alias)
>```
* 参数 `string` $alias: 数据表的别名
* 返回 `Orm Object` ： 返回$this，可以进行后续操作
* 示例代码

```php
$orm->alias('a')//数据库表别名设为a
    ->select('a.id');
```

## 数据操作

### 存取方法

#### `set()`方法：设置数据 {#set}
>```php
>object function set(mixed $key,mixed $value)
>```

* 参数可以是键值对或者数组: 
  - 两个参数 键值：
    1. `string` (`key`)键: 设置的字段
    2. `mixed` (`$value`): 设置值
  
  -  数组：
     - 一个参数 `array`: 批量设置键值对 

* 返回 `Orm Object` ： 返回$this，可以进行后续操作
* tips:
    - 后设置的值会覆盖之前的值
    - 只有进行写入操作(`add`,`save`)之后数据才会保存到数据库
* 示例代码

```php
/*设置参数*/
$orm->set('name','future')
    ->set('status',1)
    ->add();//添加数据
```

#### `get()`方法：获取数据 
 
 快速获取数据 [get](#get)

#### `put()`方法：快速修改 
 
 快速修改数据参看 [put](#put)

### Object操作

`Orm`实现了类的`__set()`和`__get()`方法，可以直接使用对象成员`->`操作符读取和设置数据
但是这种方式读取数据**不会读取或写入数据库**。

```php
/*修改数据*/
$orm->status=1;//与下面操作等效
$orm->set('status',1);

/*读取数据*/
$status=$orm->status;//与下面操作等效果
$status=$orm->get('status',false);
```

### Array接口
`Orm`也实现了数组接口可以直接使用 `[]`操作符读取和修改数据

```php
/*修改数据*/
$orm['status']=1;//与下面操作等效
$orm->set('status',1);

/*读取数据*/
$status=$orm['status'];//与下面操作等效果
$status=$orm->get('status',false);

```

### JSON序列化
可以对`Orm`对象直接进行`json_encode()`对其中的数据进行虚拟化。
因此可以**在YYF的REST控制器中可以**赋值给`response`,会直接虚拟化其中的数据。
```php
$orm->find(1);
echo json_encode($orm);
```
