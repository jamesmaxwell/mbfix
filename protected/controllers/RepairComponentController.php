<?php
/**
 *
 * 配件管理控制器
 * @author Junwei.hu
 *
 */
class RepairComponentController extends Controller
{
	/**
	 * 搜索列表
	 */
	public function actionList()
	{
		$criteria=new CDbCriteria;

		$criteria->compare('t.name',$_POST['component_name'],true);
		$criteria->compare('brand_id',$_POST['component_brand']);
		$criteria->compare('model_id',$_POST['component_model']);
		//只列出当前网点的备件及库存信息
		//$criteria->compare('servicePoint.id', Yii::app()->user->getState('servicePoint'));
		//网点编号改由前台传递   2012-1-2 junwei.hu
		$criteria->compare('servicePoint.id', $_POST['service_point']);
		$criteria->with = array(
			array('name'=>'brand','select'=>'text'),
			array('name'=>'model','select'=>'text'),'componentStock','componentStock.servicePoint');
		
		$limit = $_POST['limit'];	//每页条数
		$total = RepairComponent::model()->count($criteria);	//记录总数


		$criteria->offset = $_POST['start'];	//第几页
		$criteria->limit = $limit;

		$list = RepairComponent::model()->findAll($criteria);

		echo JsonHelper::encode(true, '', $list,
		array('id', 'name' ,'notes',
			array('col'=>'brand.text','name'=>'component_brand'),
			array('col'=>'model.text','name'=>'component_model'),
			array('col'=>'componentStock.servicePoint.name','name'=>'service_point'),
			array('col'=>'componentStock.amount','name'=>'amount')
		),
		array('total'=>$total)
		);
	}
}