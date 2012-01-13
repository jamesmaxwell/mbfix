<?php
return array (
  'readDic' => 
  array (
    'type' => 0,
    'description' => '读取字典信息，如客户类型，机器类别，维修方式等字典类。',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'createDic' => 
  array (
    'type' => 0,
    'description' => '新建字典信息',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'updateDic' => 
  array (
    'type' => 0,
    'description' => '更新字典信息',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'deleteDic' => 
  array (
    'type' => 0,
    'description' => '删除字典信息',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'DicAdmin' => 
  array (
    'type' => 1,
    'description' => '管理字典数据',
    'bizRule' => NULL,
    'data' => NULL,
    'children' => 
    array (
      0 => 'readDic',
      1 => 'createDic',
      2 => 'updateDic',
      3 => 'deleteDic',
    ),
  ),
  'readUser' => 
  array (
    'type' => 0,
    'description' => '查看用户列表',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'createUser' => 
  array (
    'type' => 0,
    'description' => '新建用户列表',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'updateUser' => 
  array (
    'type' => 0,
    'description' => '编辑用户列表',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'deleteUser' => 
  array (
    'type' => 0,
    'description' => '删除用户列表',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'updateOwnProfile' => 
  array (
    'type' => 1,
    'description' => '修改自己的用户信息',
    'bizRule' => 'Yii::app()->user->userId == $params["user"]->id;',
    'data' => NULL,
  ),
  'UserAdmin' => 
  array (
    'type' => 1,
    'description' => '管理用户',
    'bizRule' => NULL,
    'data' => NULL,
    'children' => 
    array (
      0 => 'readUser',
      1 => 'createUser',
      2 => 'updateUser',
      3 => 'deleteUser',
    ),
  ),
  'readServiceRecord' => 
  array (
    'type' => 0,
    'description' => '查看服务单',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'createServiceRecord' => 
  array (
    'type' => 0,
    'description' => '新建服务单',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'updateServiceRecord' => 
  array (
    'type' => 0,
    'description' => '编辑服务单',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'deleteServiceRecord' => 
  array (
    'type' => 0,
    'description' => '删除服务单',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'updateOwnServiceRecord' => 
  array (
    'type' => 1,
    'description' => '修改自己接修的服务单',
    'bizRule' => 'Yii::app()->user->userId == $params["serviceRecord"]->user_id;',
    'data' => NULL,
  ),
  'readComponentApply' => 
  array (
    'type' => 0,
    'description' => '查看申请的备件',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'createComponentApply' => 
  array (
    'type' => 0,
    'description' => '新建申请的备件',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'updateComponentApply' => 
  array (
    'type' => 0,
    'description' => '更新申请的备件',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'deleteComponentApply' => 
  array (
    'type' => 0,
    'description' => '删除申请的备件',
    'bizRule' => NULL,
    'data' => NULL,
  ),
  'updateOwnComponentApply' => 
  array (
    'type' => 1,
    'description' => '修改自己创建的备件申请单',
    'bizRule' => 'Yii::app()->user->userId == $params["Apply"]->user_id;',
    'data' => NULL,
  ),
  'deleteOwnComponentApply' => 
  array (
    'type' => 1,
    'description' => '删除自己创建的备件申请单',
    'bizRule' => 'Yii::app()->user->userId == $params["Apply"]->user_id;',
    'data' => NULL,
  ),
  'administrator' => 
  array (
    'type' => 2,
    'description' => '管理员',
    'bizRule' => NULL,
    'data' => NULL,
    'children' => 
    array (
      0 => 'DicAdmin',
      1 => 'UserAdmin',
    ),
    'assignments' => 
    array (
      'aee' => 
      array (
        'bizRule' => NULL,
        'data' => NULL,
      ),
    ),
  ),
  'fixer' => 
  array (
    'type' => 2,
    'description' => '维修员',
    'bizRule' => NULL,
    'data' => NULL,
    'children' => 
    array (
      0 => 'readServiceRecord',
      1 => 'createServiceRecord',
      2 => 'updateOwnServiceRecord',
      3 => 'createComponentApply',
      4 => 'updateOwnComponentApply',
      5 => 'deleteOwnComponentApply',
    ),
    'assignments' => 
    array (
      'maxwell' => 
      array (
        'bizRule' => NULL,
        'data' => NULL,
      ),
      'maxwell2' => 
      array (
        'bizRule' => NULL,
        'data' => NULL,
      ),
      'aliceu' => 
      array (
        'bizRule' => NULL,
        'data' => NULL,
      ),
      'alice' => 
      array (
        'bizRule' => NULL,
        'data' => NULL,
      ),
    ),
  ),
  'storekeeper' => 
  array (
    'type' => 2,
    'description' => '库房管理员',
    'bizRule' => NULL,
    'data' => NULL,
    'children' => 
    array (
      0 => 'readComponentApply',
    ),
    'assignments' => 
    array (
      'maxwell' => 
      array (
        'bizRule' => NULL,
        'data' => NULL,
      ),
      'maxwell2' => 
      array (
        'bizRule' => NULL,
        'data' => NULL,
      ),
    ),
  ),
  'accounter' => 
  array (
    'type' => 2,
    'description' => '账务',
    'bizRule' => NULL,
    'data' => NULL,
    'assignments' => 
    array (
      'maxwell2' => 
      array (
        'bizRule' => NULL,
        'data' => NULL,
      ),
    ),
  ),
);
