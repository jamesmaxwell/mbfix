<?php
/**
 * 服务单 控制器
 * @author junwei.hu
 *
 */
class ServiceRecordController extends Controller
{
	/**
	 *
	 * 添加服务单(接修登案)
	 */
	public function actionAdd()
	{
		$user = User::model()->find('name=:name',array(':name'=>Yii::app()->user->name));
		$serviceRecord = new ServiceRecord();
		$serviceRecord->attributes = $_POST['Record'];
		$serviceRecord->service_point_id = Yii::app()->user->getState('servicePoint');
		$serviceRecord->user_id = $user->id;
		$serviceRecord->record_state = ServiceRecord::STATUS_INPROCESS;
		$serviceRecord->create_time = time();

		//因为工单号可以自己输入,所以要判断工单号是否有重复
		$sameRecords = ServiceRecord::model()->count('record_no = :record_no',array(':record_no'=>$serviceRecord->record_no));
		if($sameRecords > 0){
			echo JsonHelper::encode(false,'服务单有重复,请重新输入!');
			Yii::app()->end();
		}
		if($serviceRecord->save()){
			echo JsonHelper::encode(true,'success');
		}else{
			echo JsonHelper::encode(false,var_dump($serviceRecord->errors));
		}
		Yii::app()->end();
	}

	/**
	 * 读取当前用户可处理的待处理的维修列表
	 */
	public function actionList()
	{
		$user = Yii::app()->user;
		if($user->isGuest){
			echo JsonHelper::encode(false,'未登录');
		}else{
			$limit = $_POST['limit'];
			$criteria = new CDbCriteria;
			$criteria->join = 'join hx_user_service_point b on t.service_point_id = b.service_point_id';
			$criteria->with = array(
				'user'=>array('select'=>'name'),
				'servicePoint'=>array('select'=>'name'),
				'serviceType','warrantyType','customType',
				'machineBrand','machineType');
			$criteria->condition = 't.user_id = :userId';
			$criteria->params = array(':userId' => $user->getState('userId'));
			//begin 处理查询参数
			$recordNo = $_POST['recordNo'];
			$fixer = $_POST['fixer'];
			$beginDate = $_POST['beginDate'];
			$endDate = $_POST['endDate'];
			$recordState = $_POST['recordState'];
			//如果设置了工单号就不处理其它查询参数了
			if(!empty($recordNo)){
				$criteria->addCondition('t.record_no = \'' . $recordNo . '\'');
			}else{
				//维修员,用模糊查询方式去查询用户表
				if(!empty($fixer)){
					$criteria->addSearchCondition('user.name', $fixer);
				}
				if(!empty($beginDate)){
					$bDate = strtotime($beginDate);
					if($bDate != false){
						$criteria->addCondition('t.create_time >= '. $bDate);
					}
				}
				if(!empty($endDate)){
					$eDate = strtotime($endDate);
					if($eDate != false){
						$criteria->addCondition('t.create_time <= '. $eDate);
					}
				}
				if(!empty($recordState)){
					$criteria->addCondition('t.record_state = ' . $recordState);
				}
			}
				
			//end 处理查询参数
				
			$criteria->order = 't.create_time desc';
			//先取得总记录数
			$total = ServiceRecord::model()->count($criteria);
			//再添加分页参数
			$criteria->offset = $_POST['start'];
			$criteria->limit = $limit;
			$list = ServiceRecord::model()->findAll($criteria);
			echo JsonHelper::encode(true, '', $list, array('id', 'user_id', 'record_no','create_time',
				'custom_name','custom_sex','custom_mobile','custom_phone','custom_company','custom_address',
				'custom_postcode','custom_email','machine_model','machine_snid','disk_state','machine_look',
				'machine_attachment','error_desc','other_note',
			array('col'=>'user.name','name'=>'name'),
			array('col'=>'record_state','name'=>'record_state'),
			array('col'=>'servicePoint.name','name'=>'service_point'),
			array('col'=>'serviceType.text','name'=>'service_type'),
			array('col'=>'machineBrand.text','name'=>'machine_brand'),
			array('col'=>'machineType.text','name'=>'machine_type'),
			array('col'=>'warrantyType.text','name'=>'warranty_type'),
			array('col'=>'customType.text','name'=>'custom_type')
			),
			array('total'=>$total)
			);
		}
	}

	/**
	 *
	 * 服务单结案(客户取机流程)
	 */
	public function actionFinish(){
		$model = new CustomFetch;
		$model->record_id = $_POST['recordId'];
		$model->fetch_type = $_POST['fetch_type'];
		$model->logistics_type_id = $_POST['logistics_name'];
		$model->logistics_no = $_POST['logistics_no'];
		$model->pay_state = $_POST['pay_state'];
		$model->pay_type_id = $_POST['pay_type'];
		$model->pay_money = $_POST['pay_money'];
		$model->finish_date = time();
		$trans = $model->dbConnection->beginTransaction();
		try{
			$model->save();
			//保存成功后,再登录服务单记录的状态为'已结案'
			ServiceRecord::model()->updateByPk($model->record_id, array('record_state'=>ServiceRecord::FINISHED));
			
			$recordModel = ServiceRecord::model()->find('id=:id',array(':id'=>$model->record_id));
			//维修结案，增加营业性收入
			$incomeModel = new TurnoverIncome();
			$incomeModel->user_id = Yii::app()->user->userId;
			$incomeModel->service_point_id = Yii::app()->user->servicePoint;
			$incomeModel->pay_type = $model->pay_type_id;
			$incomeModel->pay_state = $model->pay_state;
			$incomeModel->money = $model->pay_money;
			$incomeModel->notes = '服务单结案自动生成。 工单号' . $recordModel->record_no;
			$incomeModel->save();
				
			$trans->commit();
		}catch(Exception $e){
			Yii::log($e->getMessage());
			$trans->rollBack();
				
			echo JsonHelper::encode(false, $e->getMessage());
			Yii::app()->end();
		}

		echo JsonHelper::encode(true);
	}
}