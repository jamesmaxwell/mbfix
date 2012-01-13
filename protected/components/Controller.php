<?php
/**
 * Controller is the customized base controller class.
 * All controller classes for this application should extend from this base class.
 */
class Controller extends CController
{
	public  $userId;
	protected  $servicePoint;
	
	/**
	 * @var string the default layout for the controller view. Defaults to '//layouts/column1',
	 * meaning using a single column layout. See 'protected/views/layouts/column1.php'.
	 */
	//public $layout='//layouts/column1';
	/**
	 * @var array context menu items. This property will be assigned to {@link CMenu::items}.
	 */
	//public $menu=array();
	/**
	 * @var array the breadcrumbs of the current page. The value of this property will
	 * be assigned to {@link CBreadcrumbs::links}. Please refer to {@link CBreadcrumbs::links}
	 * for more details on how to specify this property.
	 */
	//public $breadcrumbs=array();
	
	/**
	 * 
	 * 执行Action之前的动作
	 * @see CController::beforeAction()
	 */
	 protected function beforeAction($action){
	 	//TODO: 判断用户是否登录，并且有权限
	 	//$userId = Yii::app()->user->userId;
	 	//$servicePoint = Yii::app()->user->servicePoint;
	 	
	 	return true;
	 }
	
	/**
	 * 继承该类的控制器将只适用于ajax之类的请求,因为动作执行完后直接返回了,没有加载视图的动作.
	 * @see CController::afterAction()
	 */
	protected function afterAction($action)
	{
		Yii::app()->end();
	}
}