<?php
/**
 *
 * 故障诊断控制器
 * @author junwei.hu
 *
 */
class RepairRecordController extends Controller
{
	/**
	 * 
	 * 根据服务单id,读取故障诊断信息
	 */
	public function actionItem(){
		$recordId = $_POST['recordId'];
		if(isset($recordId)){
			$repairModel = RepairRecord::model()->find('record_id = :record_id',array(':record_id'=>$recordId));
			if($repairModel == null){
				echo JsonHelper::encode(false,'服务单 ' . $recordId . ' 的故障诊断信息没找到');
			}else{
				$contactCount = CustomContact::model()->count('record_id=:record_id',array(':record_id'=>$recordId));
				$repairCmpModel = RecordComponent::model()->findAll(array(
					'condition'=>'record_id=:record_id',
				  	'params'=>array(':record_id'=>$recordId),
					'with'=>array('component','component.brand','component.model')
				));
				echo JsonHelper::encode(true,'',array($repairModel),array('id','record_id','judge_result',
					'problem_type','repair_type','problem_desc','fix_money','custom_decide','refuse_reason','state'),
				  array(
					'contactCount'=>$contactCount,
					'repairComponents'=>JsonHelper::itemEncode($repairCmpModel,
				  		array('id', 'component_id', 'component_amount','state',
				  			array('name'=>'name','col'=>'component.name'),
				  			array('name'=>'brand_name','col'=>'component.brand.text'),
				  			array('name'=>'model_name','col'=>'component.model.text')))
				  ));
			}
		}else{
			echo JsonHelper::encode(false,'参数错误');
		}
	}
	
	/**
	 * 
	 * 保存故障诊断信息
	 * @throws CHttpException
	 * @throws CException
	 */
	public function actionSave()
	{
		$recordId = $_POST['recordId'];		//服务单号
		$repairJudge = $_POST['repair_judge'];	//诊断结果
		$problemType = $_POST['problem_type'];	//故障类型
		$repairType = $_POST['repair_type'];	//维修方式
		$problemDesc = $_POST['problem_desc'];	//故障描述
		$repairMoney = $_POST['repair_money'];	//维修费
		$customChoice = $_POST['repair_custom_choice'];	//维修意愿
		$refuseReason = $_POST['refuse_reason'];	//不修原因
		$repairCmps = $_POST['repairCmps'];		//故障部件
		$buttonAction = $_POST['buttonAction'];	//暂存(tempSave)或确定(confirm),

		$model = RepairRecord::model()->find('record_id = :record_id', array(':record_id'=>$recordId));
		if(!isset($model->id)){
			$model = new RepairRecord;
		}
		$model->record_id = $recordId;
		$model->judge_result = $repairJudge;
		$model->problem_type = $problemType;
		$model->repair_type = $repairType;
		$model->problem_desc = $problemDesc;
		$model->fix_money = $repairMoney;
		$model->custom_decide = $customChoice;
		$model->refuse_reason = $refuseReason;
		$model->operation_date = time();
		//保存是暂存或确定,确定后不能再修改了
		if($buttonAction == 'tempSave'){
			$model->state = RepairRecord::TEMP_SAVE;
		}else if($buttonAction == 'confirm'){
			$model->state = RepairRecord::CONFIRM_SAVE;
		}else{
			$model->state = RepairRecord::CONFIRM_SAVE;
		}

		/**
		 * 用户可能点击'暂存'或'确定', 如果是'暂存',则先把可能使用的故障备件先删除,再按确定的方式处理.
		 * 对于库存量的处理,用户'暂存'或'确定'的时候不更新库存表, 当要取真正的库存时,要把那些预约中的备件数量减去.
		 * 当库房管理人员入库或审核后,更新库存表,并把维修备件表中的相应记录状态改为已领料.
		 */

		$trans = $model->dbConnection->beginTransaction();
		try{
			$servicePoint = Yii::app()->user->getState('servicePoint');	//网点
			if(!isset($servicePoint)){
				throw new CHttpException(403,'请先登录');
			}
			//如果是客户不修,则直接保存,并把服务单状态改为'客户不修'
			if($customChoice == RepairRecord::CUSTOM_REFUSE){
				$model->state = RepairRecord::CONFIRM_SAVE;
				//更新服务单状态
				ServiceRecord::model()->updateByPk($recordId, array('record_state'=>ServiceRecord::CUSTOM_REFUSE));
			}else{
				//如果是'暂存',则先删除之前的维修备件记录
				if($model->state == RepairRecord::TEMP_SAVE){
					RecordComponent::model()->deleteAll('record_id = :record_id',array(':record_id'=>$recordId));
					//暂存时,把服务单状态改为'报价中',如果下面有申请备件的记录,则状态会被覆盖为'待料'
					ServiceRecord::model()->updateByPk($recordId, array('record_state'=>ServiceRecord::PRICEING));
				}

				$waitComponent = false;	//是否有待料备件
				//只在是'确定'按钮并且有备件信息时处理
				if(isset($repairCmps)){
					$criteria = new CDbCriteria();
					$criteria->condition = 'component_id = :component_id and service_point_id = :service_point_id';

					$items = explode(',',$repairCmps);	//处理参数
					foreach($items as $item){
						$pair = explode(':', $item);
						if(count($pair) == 3){
							$cmpId = $pair[0];		//备件id
							$cmpAmount = $pair[1];	//备件使用数量
							$cmpState = $pair[2];	//备件状态,预约或申请

							if($cmpAmount < 1){
								throw new CException('备件数量参数错误');
							}

							//如果是申请备件状态,就不需要再判断库存和重复记录了
							if($cmpState != RecordComponent::APPLY_STOCK){
								//判断当前数量是否足够
								$criteria->params = array(':component_id'=>$cmpId,':service_point_id'=>$servicePoint);
								$cmpStock = ComponentStock::model()->find($criteria);
								if($cmpStock == null || $cmpStock->amount < $cmpAmount){
									throw new CException(($cmpStock==null ? '无库存记录': '库存不足') . 'component_id:'. $cmpId);
								}
							}
							if($cmpState == RecordComponent::APPLY_STOCK){
								$waitComponent = true;
							}
							//保存该备件
							$cmpModel = new RecordComponent;
							$cmpModel->record_id = $recordId;
							$cmpModel->component_id = $cmpId;
							$cmpModel->component_amount = $cmpAmount;
							$cmpModel->state = $cmpState;	//预约中或申请
							$cmpModel->save();
						}
					}
				}
				if($waitComponent){
					//如果有待料,则更新服务单状态为待料
					ServiceRecord::model()->updateByPk($recordId, array('record_state'=>ServiceRecord::WAIT_COMPONENT));
				}else{
					if($model->state == RepairRecord::CONFIRM_SAVE){
						//如果是确定,则表示已修复
						ServiceRecord::model()->updateByPk($recordId, array('record_state'=>ServiceRecord::FIXED));
					}
				}
			}
			//保存故障维修记录
			$model->save();

			//commit
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