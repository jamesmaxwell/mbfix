<?php
/**
 * 
 * 用户角色控制器
 * @author junwei.hu
 *
 */
class RoleController extends Controller
{
	/**
	 * 
	 * 返回当前系统中的用户角色列表
	 */
	public function actionList(){
		$auth = Yii::app()->authManager;
		$roles = array();
		foreach($auth->roles as &$role){
			$roles[] = array('name'=>$role->name,'show_name'=>$role->description);
		}
		echo JsonHelper::encode(true, '', $roles, array('name','show_name'));
	}
}