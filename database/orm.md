# ORM

Object-Relational Mapping（对象关系映射）

数据库操作的核心封装

## 创建 {#create}

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
通过`UserModel`来直接调用，参见 [Model一节](model.md)


## 基本操作 {#basic}

### 读取数据 \(query\) {#data-select}
读取数据提供`select`，`find`,`get` 三种方法
####  `select()`方法: 批量获取数据 {#select}

```php
select([string $fields=''])
``` 
* 参数 `$fields`[可选] : 指定查询的字段 逗号`,`分隔符，别名用` AS `链接
* 返回 `array`多维数组
* 示例代码
```php
$list=$orm->select('*');//查询所有字段和所有数据
$list=$orm->select('id AS uid,time');//查询id和time，在返回的数据中id用uid表示
```

#### `find()` 方法: 单条数据读取 {#find}
```php
find([string $id=null])
```
* 参数 `$id`[可选,`int`|`string` ] :  数据的主键值
* 返回 `Orm` 指向调用的`Orm`对象自身(查询成功)或`null`(查询失败) 
* 示例代码
```php
$user=$orm->find(2);//查询id为2的数据
```

#### `get()`方法：获取单条或者单个数据 {#get}
```php
get([string $key = '', boolean $auto_query = true])
```
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
```php
insert(array $data)
```
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
```php
insertAll(array $data)
```
* 参数 `$data`[必须] : 要插入的数据二维数组
* 返回 `int` ： 插入成功的条数
* 数据可以使用过滤`field()`对数据字段进行过滤
* 示例代码
```php
$uid=$orm->insert(['name'=>'future','org'=>'nku']);//插入一条数据
```

#### `add()`方法: 插入已经设置的数据 {#add}
```php
add()
```
* 无参数
* 返回 `int` ： 数据的id（同`insert()`）
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
#### `save()`方法： 保存数据 {#save}


### 删除数据 \(delete\) {#data-delete}

#### `delete()`方法： 删除数据 {#delete}


## 条件限制 (condition) {#condition}

### 条件查询（where）
#### `where()`方法： 添加选择条件
#### `orWhere()`方法： OR条件
#### `exist` 子查询

### 结果分组（group by）
#### `group()`方法 

#### 计算条件（having）
#### `having()`方法： 添加选择条件
#### `orHaving()`方法： having条件 or 

### 字段
#### `field()`方法： 设置字段

### 排序
#### `order()`方法： 设置位置和偏移

### 分页
#### `limit()`方法： 设置位置和偏移
#### `page()`方法： 翻页



## 函数

### 聚合函数
#### `count()`方法： 设置字段
#### `sum()`方法： 设置字段
#### `avg()`方法： 设置字段
#### `max()`方法： 设置字段
#### `min()`方法： 设置字段


### 自增自减
#### `increment()`方法
#### `decrement()`方法

## 多表操作

### 多表查询
#### `join()`方法
#### `has()`方法
#### `belongs()`方法

### 子查询

### 合并查询
#### `union()`方法
#### `unionAll()`方法



## 多数据库

### 默认数据库

### 切换数据库
#### `setDb()`方法

## 安全和调试

### 安全模式
#### `safe()`方法

### 调试输出
#### `debug()`方法


## 数据操作
### 存取方法
#### `set()`方法
### Object操作
### JSON序列化
### Array接口