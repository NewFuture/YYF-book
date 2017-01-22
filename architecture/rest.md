RESTful 风格设计
==========

RESTful API 设计用不同的URI地址表示不同的资源(通常是名词)，用不同的请求方式表示不同的操作。

请求方式
-----------
REST风格设计中，通常使用不同的请求方式对应不同的操作。

常见的请求方式:
* `GET` 获取或者查询
* `POST` 创建或者新增
* `PUT` 修改内容
* `DELETE` 删除(delete通常无额外参数，因此不会对参数进行解析)
* 其他(如`PATCH`等)

YYF 中可以将不同的请求方式映射到不同的Action上进行处理

URI地址
-----------
RESTful URI表示资源

实际中常用的表示方式:`资源组/id标识[/属性]`(如`User/1/address`)或者`资源组/属性`(如`Setting/banner`)

YYF框架中对id(数字)映射做了特殊处理`Controller/:id/Action`会映射到Controller控制器的Action方法上并绑定参数`:id`到`$id`


RESTful 请求举例
--------
以对项目资源(Project)的操作为例

```bash
#获取项目列表(ProjectController::GET_indexAction())
GET /Project/

#创建项目(ProjectController::POST_indexAction())
POST /Project/

#获取项目id为1的详细信息(ProjectController::GET_infoAction($id))
GET /Project/1
#修改id为1的项目内容(ProjectController::PUT_infoAction($id))
PUT /Project/1
#删除id为1的项目(ProjectController::DELETE_infoAction($id))
DELETE /Project/1
#获取项目id为1的贡献者(ProjectController::GET_contributorsAction($id))
GET /Project/1/contributors
```
