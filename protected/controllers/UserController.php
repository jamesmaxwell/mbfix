<?php
/**
 *
 * 用户管理控制器
 * @author junwei.hu
 *
 */
class UserController extends CController
{
	/**
	 *
	 * 根据用户角色取得当前用户菜单列表
	 * @param User $user
	 */
	private function getUserMenus($user){
		$menus = array();
		if($user == null) return $menus;
		$roles = explode(',',$user->roles);
		if(is_array($roles)){
			$repair = array('text'=>'维修','items'=>array());		//维修菜单
			$component = array('text'=>'备件','items'=>array());	//备件菜单
			$account = array('text'=>'财务','items'=>array());	//财务菜单
			$dicAdmin = array('text'=>'系统管理','items'=>array());	//字典管理菜单
			$userAdmin = array('text'=>'用户管理','items'=>array());	//用户管理菜单
			//只有维修员有接修的权限
			if(self::hasRole($roles, User::ROLE_FIXER)){
				array_push($repair['items'],array('itemId'=>'menuRecord','text'=>'接修登案'));
				array_push($repair['items'],array('itemId'=>'menuRepairList','text'=>'待修列表'));
			}
			//任何人都可以查询
			array_push($repair['items'],array('itemId'=>'menuSearch','text'=>'综合查询'));

			if(self::hasRole($roles, User::ROLE_FIXER)){
				array_push($component['items'],array('itemId'=>'menuApplyList','text'=>'申请车'));
				array_push($component['items'],array('itemId'=>'menuComponentApply','text'=>'备件申请'));
			}

			if(self::hasRole($roles, User::ROLE_STOCKKEEPER)){
				array_push($component['items'],array('itemId'=>'menuPurchaseList','text'=>'采购列表'));
				array_push($component['items'],array('itemId'=>'menuStockManager','text'=>'库存查询'));
				array_push($component['items'],array('itemId'=>'menuStockoutList','text'=>'出库查询'));
			}
				
			if(self::hasRole($roles, User::ROLE_FIXER)){
				array_push($account['items'], array('itemId'=>'menuFundApply','text'=>'款项申请'));
				array_push($account['items'], array('itemId'=>'menuPayout','text'=>'费用支出'));
				array_push($account['items'], array('itemId'=>'menuPayoutDetail','text'=>'支出明细'));
			}
			if(self::hasRole($roles, User::ROLE_ACCOUNTER)){
				array_push($account['items'], array('itemId'=>'menuFundVerify','text'=>'款项审核'));
				array_push($account['items'], array('itemId'=>'menuAccountVerify','text'=>'账务核销'));
			}
			if(self::hasRole($roles, User::ROLE_ACCOUNTER) || self::hasRole($roles, User::ROLE_ADMIN)){
				array_push($account['items'], array('itemId'=>'menuTurnover','text'=>'营业款收入'));
				array_push($account['items'], array('itemId'=>'menuFundSearch','text'=>'款项综合查询'));
			}
			if(self::hasRole($roles, User::ROLE_ADMIN)){
				array_push($account['items'], array('itemId'=>'menuAccountReceivable','text'=>'应收款'));
				array_push($account['items'], array('itemId'=>'menuAccountPayable','text'=>'应付款'));
			}
				
			if(self::hasRole($roles, User::ROLE_ADMIN)){
				array_push($userAdmin['items'], array('itemId'=>'menuUserAdmin','text'=>'用户管理'));
				array_push($userAdmin['items'], array('itemId'=>'menuServicePointAdmin','text'=>'服务点管理'));
				//添加字典管理项
				array_push($dicAdmin['items'], array('itemId'=>'menuCustomType','text'=>'客户类型管理','viewName'=>'customtypeadmin'));
				array_push($dicAdmin['items'], array('itemId'=>'menuServiceType','text'=>'服务类型管理','viewName'=>'servicetypeadmin'));
				array_push($dicAdmin['items'], array('itemId'=>'menuMachineBrand','text'=>'机器品牌管理','viewName'=>'machinebrandadmin'));
				array_push($dicAdmin['items'], array('itemId'=>'menuMachineType','text'=>'机器类型管理','viewName'=>'machinetypeadmin'));
				array_push($dicAdmin['items'], array('itemId'=>'menuWarrantyType','text'=>'质保类型管理','viewName'=>'warrantytypeadmin'));
				array_push($dicAdmin['items'], array('xtype'=>'menuseparator'));
				array_push($dicAdmin['items'], array('itemId'=>'menuProblemType','text'=>'故障类别管理','viewName'=>'problemtypeadmin'));
				array_push($dicAdmin['items'], array('itemId'=>'menuRepairType','text'=>'维修方式管理','viewName'=>'repairtypeadmin'));
				array_push($dicAdmin['items'], array('itemId'=>'menuContactType','text'=>'客户联络方式管理','viewName'=>'contacttypeadmin'));
				array_push($dicAdmin['items'], array('xtype'=>'menuseparator'));
				array_push($dicAdmin['items'], array('itemId'=>'menuComponentBrand','text'=>'配件品牌管理','viewName'=>'componentbrandadmin'));
				array_push($dicAdmin['items'], array('itemId'=>'menuComponentModel','text'=>'配件型号管理','viewName'=>'componentmodeladmin'));
				array_push($dicAdmin['items'], array('itemId'=>'menuPurchaseType','text'=>'采购类型管理','viewName'=>'purchasetypeadmin'));
				array_push($dicAdmin['items'], array('xtype'=>'menuseparator'));
				array_push($dicAdmin['items'], array('itemId'=>'menuPayType','text'=>'收款方式管理','viewName'=>'paytypeadmin'));
				array_push($dicAdmin['items'], array('itemId'=>'menuLogisticsType','text'=>'物流单位管理','viewName'=>'logisticstypeadmin'));
			}
				
			//添加有子项的菜单
			if(count($repair['items']) > 0){
				array_push($menus, $repair);
			}
			if(count($component['items']) > 0){
				array_push($menus,$component);
			}
			if(count($account['items']) > 0){
				array_push($menus, $account);
			}
			if(count($dicAdmin['items']) > 0){
				array_push($menus, $dicAdmin);
			}
			if(count($userAdmin['items']) > 0){
				array_push($menus, $userAdmin);
			}

		}
		return $menus;
	}

	/**
	 *
	 * 确认某个角色是否包含在一个角色列表中
	 * @param Array $roles
	 * @param String $role
	 */
	private function hasRole($roles, $role){
		if(!is_array($roles))
		return false;
		return in_array($role, $roles);
	}

	/**
	 *
	 * 读取当前用户登录状态
	 * @throws CHttpException
	 */
	public function actionCurrentUser()
	{
		$user = Yii::app()->user;
		if(!$user->isGuest){
			$servicePointName = Yii::app()->user->getState('servicePointName');
			if(!isset($servicePointName)){
				throw new CHttpException(403, '登录过期,请重新登录.');
			}
			$userModel = User::model()->find('name=:name',array(':name'=>$user->name));
			//成功时返回用户可用的菜单列表
			$menus = self::getUserMenus($userModel);

			echo JsonHelper::encode(true, '',
			array(array('name'=>$user->name,'servicePoint'=>$servicePointName)),
			array('name','servicePoint'),
			array('menus'=>$menus));
		}else{
			throw new CHttpException(403, '请登录');
			//echo JsonHelper::encode(false,'请登录');
		}
		Yii::app()->end();
	}

	/**
	 *
	 * 用户登录
	 */
	public function actionLogin(){
		$model = new LoginForm();

		$model->username = $_POST['username'];
		$model->password = $_POST['password'];
		$model->rememberMe = true;

		$servicePoint = $_POST['servicePoint'];

		if($model->validate() && $model->login()){
			Yii::app()->user->setState('servicePoint', $servicePoint);
			$point = ServicePoint::model()->find('id=:id',array(':id'=>$servicePoint));
			$user = User::model()->find('name=:name',array(':name'=>$model->username));
			Yii::app()->user->setState('userId', $user->id);
			Yii::app()->user->setState('servicePointName', $point->name);
			Yii::app()->user->setState('servicePointShortName', $point->short_name);
			//保存用户最后登录时间
			$user->lastlogin = time();
			$user->save();
			echo JsonHelper::encode(true);
		}else{
			echo JsonHelper::encode(false,$model->getError('message'));
		}
		Yii::app()->end();
	}

	/**
	 *
	 * 用户退出
	 */
	public function actionLogout(){
		Yii::app()->user->logout();
		Yii::app()->end();
	}
}