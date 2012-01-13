<?php
/**
 * 服务网点控制器
 * @author junwei.hu
 *
 */
class ServicePointController extends CController
{
	public function actionList()
	{
		$points = array();
		$username = $_REQUEST['username'];
		//如果设置了查询的用户,则只返回当前用户所在的服务网站,否则返回全部
		if(isset($username)){
			$points = Yii::app()->db->createCommand()
			->select(array('c.id','c.name','c.short_name','c.desc'))
			->from('hx_user a')
			->join('hx_user_service_point b', 'b.user_id = a.id')
			->join('hx_service_point c','c.id = b.service_point_id')
			->where('a.name = :username', array(':username'=>$username))
			->queryAll();
		}else{
			$points = ServicePoint::model()->findAll();
		}
		echo JsonHelper::encode(true,'',$points,array('id','name','short_name','desc'));
		Yii::app()->end();
	}

	/**
	 * 添加服务点
	 */
	public function actionAdd(){
		//取得客户端POST过来的Raw data (JSON字符串)
		$newRecord = CJSON::decode(file_get_contents('php://input'));
		$model = new ServicePoint();
		$model->name = $newRecord['name'];
		$model->short_name = $newRecord['short_name'];
		$model->desc = $newRecord['desc'];
		if($model->save()){
			echo JsonHelper::encode(true,'添加成功',array($model),array('id','name','short_name','desc'));
		}else{
			echo JsonHelper::encode(false,'添加失败');
		}
	}
	
	/**
	 * 
	 * 更新服务点, POST过来的是 Request PayLoad
	 * 服务点的名称和简称都不能重复。这个由数据约束保证。
	 */
	public function actionUpdate(){
		$newRecords = CJSON::decode(file_get_contents('php://input'), true);
		if(is_array($newRecords)){
			//先转换成数组
			if(!is_array($newRecords[0]))
				$newRecords = array($newRecords);
			foreach($newRecords as $record){
				$model = ServicePoint::model()->find('id=:id',array(':id'=>$record['id']));
				if($model != null){
					$model->name = $record['name'];
					$model->short_name = $record['short_name'];
					$model->desc = $record['desc'];
					$model->save();
				}
			}
			echo JsonHelper::encode(true,'更新成功');
		}
	}
	
	/**
	 * 
	 * 删除服务点，如果该服务点包含了服务单时不能删除
	 */
	public function actionDelete(){
		$rowRecord = CJSON::decode(file_get_contents('php://input'));
		//这里考虑数据库的级联删除功能来限制是否可删除该记录
		$model = ServicePoint::model()->find('id=:id',array(':id'=>$rowRecord['id']));
		if($model == null){
			echo JsonHelper::encode(false, '服务点没找到,可能已被删除');
		}
		$serviceRecordCount = ServiceRecord::model()->count('service_point_id = :service_point_id',
			array(':service_point_id'=>$rowRecord['id']));
		if($serviceRecordCount > 0){
			throw new CHttpException(403,'该服务点已经包含服务单，不能删除');
		}
		if($model->delete()){
			echo JsonHelper::encode(true,'删除成功');
		}else{
			throw new CHttpException(403,'删除失败');
		}
	}
}