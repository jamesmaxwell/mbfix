<?php
/**
 * 用于权限，角色管理的控制器
 * @author junwei.hu
 */
class AdminController extends CController
{
	//public function filters(){
	//return array('accessControl');
	//}

	public function accessRules(){
		//只有admin账号才能操作
		return array(
		array('allow','users'=>array('admin')),
		array('deny')
		);
	}

	protected function beforeAction($action){
		if(Yii::app()->user->isGuest){
			return false;
			//throw new CHttpException(403, '请先登录');
		}
		return true;
	}

	/**
	 *
	 * 显示用户列表
	 */
	public function actionList(){
		$limit = $_POST['limit'];
		$offset = $_POST['start'];

		$criteria = new CDbCriteria();
		$criteria->condition = 'deleted = 0';
		$criteria->order = 't.id';
		$criteria->with = array('userServicePoints'=>array('select'=>'service_point_id'));
		$count = User::model()->count($criteria);
		$criteria->limit = $limit;
		$criteria->offset = $offset;
		$users = User::model()->findAll($criteria);
		if($users != null){
			/* 已保存在 Roles 字段中, 就不用再从authManager中取了。
			 $auth = Yii::app()->authManager;
			 */
			foreach($users as &$user){
				//$roles = $auth->getAuthItems(2,$user->id); //2取role类型
				$user->roles = explode(',', $user->roles);
			}
				
			echo JsonHelper::encode(true, '', $users, array('id','name','notes','lastlogin','roles',
				array('name'=>'servicePoints','col'=>'userServicePoints')),
				array('total'=>$count));
		}else{
			echo JsonHelper::encode(false,'没有用户信息');
		}
	}

	/**
	 *
	 * 添加用户
	 */
	public function actionAdd(){
		$user = CJSON::decode(file_get_contents('php://input'), true);
		//判断用户是否重复
		$userModel = User::model()->find('name=:name',array(':name'=>$user['name']));
		if($userModel != null){
			echo JsonHelper::encode(false,'用户已存在');
			Yii::app()->end();
		}
		$userModel = new User;
		$userModel->name = $user['name'];
		$userModel->password = md5(User::DEFAULT_PASSWORD);
		$userModel->notes = $user['notes'];
		$userModel->roles = implode(',', $user['roles']);
		if($userModel->save()){
			//保存网点信息
			foreach($user['servicePoints'] as &$servicePointId){
				$userServicePoint = new UserServicePoint();
				$userServicePoint->user_id = $userModel->id;
				$userServicePoint->service_point_id = $servicePointId;
				$userServicePoint->save();
			}
			/*
			$auth = Yii::app()->authManager;
			//保存角色信息
			foreach($user['roles'] as &$role){
				$auth->assign($role, $userModel->name);
			}
			$auth->save();
			*/
			echo JsonHelper::encode(true);
		}else{
			echo JsonHelper::encode(false,JsonHelper::encodeError($userModel->getErrors()));
		}
	}

	/**
	 *
	 * 编辑用户
	 */
	public function actionUpdate(){
		$user = CJSON::decode(file_get_contents('php://input'), true);
		$id = $user['id'];
		$userModel = User::model()->find('id=:id',array(':id'=>$id));
		if($userModel != null){
			//TODO:判断用户名称是否重复
			//不修改密码
			$userModel->name = $user['name'];
			$userModel->notes = $user['notes'];
			$userModel->roles = implode(',', $user['roles']);
			$userModel->save();
			//保存服务点信息,先删除之前的信息
			UserServicePoint::model()->deleteAll('user_id=:user_id',array(':user_id'=>$id));
			foreach($user['servicePoints'] as &$servicePointId){
				$userServicePoint = new UserServicePoint();
				$userServicePoint->user_id = $id;
				$userServicePoint->service_point_id = $servicePointId;
				$userServicePoint->save();
			}
			//保存角色信息
			//TODO: check error
			/*
			$auth = Yii::app()->authManager;
			$roles = $auth->getRoles($userModel->name);
			foreach($roles as &$role){
				if($auth->isAssigned($role, $userModel->name)){
					$auth->revoke($role, $userModel->name);
				}
			}
			foreach($user['roles'] as &$role){
				$auth->assign($role, $userModel->name);
			}
			$auth->save();
			*/
			echo JsonHelper::encode(true);
		}else{
			throw new CSysException('用户没找到');
		}
	}

	/**
	 *
	 * 删除用户,只给用户添加删除标记，不真正删除用户
	 */
	public function actionDelete(){
		$user = CJSON::decode(file_get_contents('php://input'), true);
		$userModel = User::model()->find('id=:id',array(':id'=>$user['id']));
		if($userModel != null){
			$userModel->deleted = 1;
			$userModel->save();
			//删除用户服务点的信息
			UserServicePoint::model()->deleteAll('user_id=:user_id',array(':user_id'=>$userModel->id));
			echo JsonHelper::encode(true);
		}
		echo JsonHelper::encode(false,'用户没找到');
	}

	/**
	 * 初始化系统的默认角色。
	 * 调用该方法，首先会清除所有已有的角色设置，然后按照系统功能重建。
	 * 目前系统中包括：管理员，维修员，库房，账务四种。
	 * 管理员任务包括：字典管理，用户管理，服务点管理，以及维修员能做的所有事。
	 * 维修员任务包括：接修登案，维修，备件申请。
	 * 库房任务包括： 备件采购，备件出入库。
	 * 账务任务包括： （待定）
	 */
	public function actionRestDefaultRole(){
		$auth = Yii::app()->authManager;
		$auth->clearAll();	//清空之前保存的信息。note

		$auth->createOperation('readDic','读取字典信息，如客户类型，机器类别，维修方式等字典类。');
		$auth->createOperation('createDic','新建字典信息');
		$auth->createOperation('updateDic','更新字典信息');
		$auth->createOperation('deleteDic','删除字典信息');

		//字典管理任务
		$task = $auth->createTask('DicAdmin','管理字典数据');
		$task->addChild('readDic');
		$task->addChild('createDic');
		$task->addChild('updateDic');
		$task->addChild('deleteDic');

		$auth->createOperation('readUser','查看用户列表');
		$auth->createOperation('createUser','新建用户列表');
		$auth->createOperation('updateUser','编辑用户列表');
		$auth->createOperation('deleteUser','删除用户列表');

		$bizRule = 'Yii::app()->user->userId == $params["user"]->id;';
		$task = $auth->createTask('updateOwnProfile','修改自己的用户信息', $bizRule);

		//用户管理任务
		$task = $auth->createTask('UserAdmin','管理用户');
		$task->addChild('readUser');
		$task->addChild('createUser');
		$task->addChild('updateUser');
		$task->addChild('deleteUser');

		//能新建服务单，同时也能进行故障诊断等服务单相关的操作。
		$auth->createOperation('readServiceRecord','查看服务单');
		$auth->createOperation('createServiceRecord','新建服务单');
		$auth->createOperation('updateServiceRecord','编辑服务单');
		$auth->createOperation('deleteServiceRecord','删除服务单');

		$bizRule = 'Yii::app()->user->userId == $params["serviceRecord"]->user_id;';
		$task = $auth->createTask('updateOwnServiceRecord','修改自己接修的服务单', $bizRule);

		$auth->createOperation('readComponentApply','查看申请的备件');
		$auth->createOperation('createComponentApply','新建申请的备件');
		$auth->createOperation('updateComponentApply','更新申请的备件');
		$auth->createOperation('deleteComponentApply','删除申请的备件');
		$bizRule = 'Yii::app()->user->userId == $params["Apply"]->user_id;';
		$task = $auth->createTask('updateOwnComponentApply','修改自己创建的备件申请单',$bizRule);
		$task = $auth->createTask('deleteOwnComponentApply','删除自己创建的备件申请单',$bizRule);

		//创建角色
		$role = $auth->createRole('administrator','管理员');
		$role->addChild('DicAdmin');
		$role->addChild('UserAdmin');

		$role = $auth->createRole('fixer','维修员');
		$role->addChild('readServiceRecord');
		$role->addChild('createServiceRecord');
		$role->addChild('updateOwnServiceRecord');
		$role->addChild('createComponentApply');
		$role->addChild('updateOwnComponentApply');
		$role->addChild('deleteOwnComponentApply');

		$role = $auth->createRole('storekeeper','库房管理员');
		$role->addChild('readComponentApply');


		$role = $auth->createRole('accounter','财务');

		$auth->save();

		foreach($auth->roles as $r){
			echo 'name: ' . $r->name . ' desc:' . $r->description;
		}
	}
}