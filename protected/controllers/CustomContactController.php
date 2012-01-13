<?php
/**
 *
 * 客户联系记录控制器
 * @author junwei.hu
 *
 */
class CustomContactController extends Controller
{
	/**
	 * 
	 * 添加客户联络记录
	 */
	public function actionAdd()
	{
		$record_id = $_POST['record_id'];
		$contact_type = $_POST['contact_type'];
		$contact_content = $_POST['contact_content'];

		if(!is_numeric($record_id) || !isset($contact_type) || !isset($contact_content)){
			echo JsonHelper::encode(false, '参数错误,服务单编号，客户联系内容和客户联系方式都不能为空！');
			Yii::app()->end();
		}

		$model = new CustomContact;
		$model->record_id = $record_id;
		$model->contact_type_id = $contact_type;
		$model->contact_content = $contact_content;
		$model->contact_date = time();
		if(!$model->save()){
			echo JsonHelper::encode(false, '保存客户联系记录失败');
		}else{
			echo JsonHelper::encode(true);
		}
	}
	
	/**
	 * 
	 * 根据服务单号读取客户联络记录
	 */
	public function actionList(){
		$recordId = $_GET['recordId'];
		if(isset($recordId)){
			$model = CustomContact::model()->findAll(array(
				'condition'=>'record_id = :record_id',
				'params'=>array(':record_id'=>$recordId),
				'order'=>'t.contact_date desc',
				'with'=>array('contactType')
			));
			echo JsonHelper::encode(true, '', $model, array('id','contact_content','contact_date',
				array('name'=>'contact_type','col'=>'contactType.text')));
		}else{
			throw new CHttpException(403,'参数错误');
		}
	}
}