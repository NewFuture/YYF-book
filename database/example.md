
Db::table('user')->insert(['name'=>'future']);

$user=new Orm('user');
$data=['username'=>'test','uid'=>100];
$user->field('name','username')
        ->field('id','uid')
        ->insert($data);

UserModel::set('name','yyf')->add();


   $data=[
    ['name'=>'test'],
    ['name'=>'test2'],
    ['id'=>1000,'name'=>'test3'],
    ['password'=>'xyz','name'=>'test4'],
    ['id'=>123]
];

$response=  UserModel::field('name')->insertAll($data);

$response=  Db::table('user')->where('id','BETWEEN',5,8)->select();

$response=  Db::table('user')->where('name','NOT LIKE','%future')->where('id','in',[100,10,1])->select();

$response=  Db::table('user')
            ->where(['name'=>'future'])
            ->where('id','>',10)
            ->limt(5);
            ->select();

Db::table('user')
            ->where()
            ->page(3,5)
            ->select();


Db::table('user')->where('id',1)->update(['name'=>'first user']);
 if($user =  Db::table('user')->find(2))
  {
      $user->field('name')->set('id',2000)->set('name','second user')->save();
  }


  Db::table('user')->delete(10);
  Db::table('user')
    ->where('id',100)
    ->where('name','test')
    ->delete();

    