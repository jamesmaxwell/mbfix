<?php
/**
 * 财务相关的控制器
 */
class FinanceController extends Controller
{
	/**
	 *
	 * 添加申请款项
	 */
	public function actionFundApply(){
		$model = new FundRecord;
		$model->attributes = $_POST['Apply'];
		$model->apply_user_id = Yii::app()->user->userId;
		$model->apply_service_point_id = Yii::app()->user->servicePoint;
		$model->apply_date = time();
		$model->state = FundRecord::VERIFY_WAITING;	//等待审核中
		if($model->save()){
			echo JsonHelper::encode(true);
		}else{
			echo JsonHelper::encode(false,JsonHelper::encodeError($model->getErrors()));
		}
	}

	/**
	 *
	 * 款项审核通过
	 */
	public function actionFundVerify(){
		$fundId = $_POST['fund_id'];
		$servicePoint = Yii::app()->user->servicePoint;
		$model = FundRecord::model()->find('id=:id',array(':id'=>$fundId));
		if($model != null){
			$model->verify_user_id = Yii::app()->user->userId;
			$model->verify_service_point_id = $servicePoint;
			$model->verify_amount = $_POST['verify_amount'];
			$model->pay_type = $_POST['pay_type'];
			$model->pay_account = $_POST['pay_account'];
			$model->receiver_account = $_POST['receiver_account'];
			$model->receiver = $_POST['receiver'];
			$model->verify_notes = $_POST['verify_notes'];
			$model->verify_date = time();
			$model->state = FundRecord::VERIFY_PASS;
			$trans = $model->dbConnection->beginTransaction();
			try{
				if($model->save()){
					//通过审核后要同时更新服务网点中记录的款项总金额
					$servicePointModel = ServicePoint::model()->find('id=:id',array(':id'=>$servicePoint));
					if($servicePointModel != null){
						$servicePointModel->total_fund += $model->verify_amount;
						if(!$servicePointModel->save()){
							throw new CSysException('保存服务网点的金额失败.' . JsonHelper::encodeError($servicePointModel->getErrors()));
						}
					}else{
						throw new CSysException('没有找到编号为 '. $servicePoint . ' 的服务网点.');
					}
					echo JsonHelper::encode(true);
				}else{
					throw new CSysException(JsonHelper::encodeError($model->getErrors()));
				}
				$trans->commit();
			}catch(Exception $e){
				Yii::log($e->getMessage());
				$trans->rollBack();

				echo JsonHelper::encode(false, $e->getMessage());
				Yii::app()->end();
			}
		}else{
			throw new CHttpException(404,'没有找到款项申请记录');
		}
	}

	/**
	 * 款项申请列表
	 */
	public function actionFundList(){
		$limit = $_GET['limit'];
		$offset = $_GET['start'];
		$criteria = new CDbCriteria();
		$criteria->order = 't.state asc, t.apply_date desc';
		$total = FundRecord::model()->count($criteria);
		$criteria->with = array(
			'applyUser'=>array('select'=>'name'),
			'verifyUser'=>array('select'=>'name'),
			'applyServicePoint'=>array('select'=>name),
			'verifyServicePoint'=>array('select'=>name));
		$criteria->limit = $limit;
		$criteria->offset = $offset;
		$records = FundRecord::model()->findAll($criteria);
		if($records != null){
			echo JsonHelper::encode(true,'',$records,
			array('id','apply_amount','apply_reason','apply_notes','apply_date',
				'verify_amount','pay_type','pay_account','receiver_account','receiver',
				'verify_date','state',
				array('name'=>'apply_user','col'=>'applyUser.name'),
				array('name'=>'apply_service_point','col'=>'applyServicePoint.name'),
				array('name'=>'verify_user','col'=>'verifyUser.name'),
				array('name'=>'verify_service_point','col'=>'verifyServicePoint.name')),
			array('total'=>$total));
		}
	}

	/**
	 *
	 * 查询某网点的可用金额
	 */
	public function actionAvailableFund(){
		$model = ServicePoint::model()->find('id=:id',array(':id'=>Yii::app()->user->servicePoint));
		if($model != null){
			echo $model->total_fund;
		}else{
			echo '0';
		}
	}

	/**
	 *
	 * 保存费用支出
	 */
	public function actionPayout(){
		$servicePoint = Yii::app()->user->servicePoint;
		$model = new PayoutDetail();
		$model->attributes = $_POST['Payout'];
		$model->handler_user_id = Yii::app()->user->userId;
		$model->service_point_id = $servicePoint;
		$model->date = time();
		$trans = $model->dbConnection->beginTransaction();
		try{
			//保存费用支出记录,同时网点相应的可用金额也减少
			//首先判断可用金额是否足够
			$servicePointModel = ServicePoint::model()->find('id=:id',array(':id'=>$servicePoint));
			if($servicePointModel == null){
				throw new CSysException('网点编号 '. $servicePoint . ' 没有找到.');
			}
			if($servicePointModel->total_fund < $model->amount){
				throw new CSysException('网点可用金额不足.');
			}
			if($model->save()){
				$servicePointModel->total_fund -= $model->amount;
				if(!$servicePointModel->save()){
					throw new CSysException('更新网点可用金额出错');
				}
			}else{
				throw new CSysException(JsonHelper::encodeError($model->getErrors()));
			}
				
			$trans->commit();
		}catch(Exception $e){
			Yii::log($e->getMessage());
			$trans->rollBack();

			echo JsonHelper::encode(false, $e->getMessage());
			Yii::app()->end();
		}
	}

	/**
	 *
	 * 费用支出明细列表
	 */
	public function actionPayoutList(){
		$limit = $_GET['limit'];
		$offset = $_GET['start'];
		$criteria = new CDbCriteria();
		$criteria->order = 't.date desc';
		$total = PayoutDetail::model()->count($criteria);
		$criteria->with = array(
			'handlerUser'=>array('select'=>'name'),
			'servicePoint'=>array('select'=>'name'));
		$criteria->limit = $limit;
		$criteria->offset = $offset;
		$records = PayoutDetail::model()->findAll($criteria);
		if($records != null){
			echo JsonHelper::encode(true,'',$records,
			array('id','consume_content','amount','ticket_no','notes','ticket_type','date',
				array('name'=>'handler_user','col'=>'handlerUser.name'),
				array('name'=>'service_point','col'=>'servicePoint.name')),
			array('total'=>$total));
		}
	}
	
	/**
	 * 
	 * 保存营业款收入
	 */
	public function actionTurnoverIncome(){		
		$model = new TurnoverIncome();
		$model->attributes = $_POST['Turnover'];
		$model->user_id = Yii::app()->user->userId;
		$model->service_point_id = Yii::app()->user->servicePoint;
		$model->date = time();
		if($model->save()){
			echo JsonHelper::encode(true);
		}else{
			echo JsonHelper::encode(false,JsonHelper::encodeError($model->getErrors()));
		}
	}
	
	/**
	* 营业款收入列表，用于财务核销
	*/
	public function actionTurnoverIncomeList(){
		$limit = $_POST['limit'];
		$offset = $_POST['start'];
		//处理可能的查询条件
		$recordNo = $_POST['recordNo'];
		$servicePoint = $_POST['servicePoint'];
		$beginDate = $_POST['beginDate'];
		$endDate = $_POST['endDate'];
		$financeFilter = $_POST['financeFilter'];
		
		$criteria = new CDbCriteria();
		$criteria->order = 't.date desc';
		if(!empty($recordNo)){
			$criteria->addCondition('t.record_no = \'' . $recrodNo . '\'');
		}
		if(!empty($servicePoint)){
			$criteria->addCondition('t.service_point_id = ' . $servicePoint);
		}
		if(!empty($beginDate)){
			$bDate = strtotime($beginDate);
			if($bDate != false){
				$criteria->addCondition('t.date >= '. $bDate);
			}
		}
		if(!empty($endDate)){
			$eDate = strtotime($endDate);
			if($eDate != false){
				$criteria->addCondition('t.date <= '. $eDate);
			}
		}
		if(!empty($financeFilter)){
			// [0, '全部'], [1, '应收款'],[2, '应付款'],[3, '其它营业款']
			//TODO: 如何来正确区别'应收款','应付款'--------------------------------
			//$criteria->addCondition('t.pay_state = ' . $financeFilter);
		}
		
		//取总记录数
		$total = TurnoverIncome::model()->count($criteria);
		$criteria->with = array(
			'payType'=>array('select'=>'text'),
			'user'=>array('select'=>'name'),
			'servicePoint'=>array('select'=>'name'),
			'customType'=>array('select'=>'text'),
			'financeUser'=>array('select'=>'name'));
		$criteria->limit = $limit;
		$criteria->offset = $offset;
		$records = TurnoverIncome::model()->findAll($criteria);
		if($records != null){
			echo JsonHelper::encode(true,'',$records,
			array('id','record_no','custom_name','receiver','pay_type','money','profit',
				'notes','pay_state','finance_state','finance_exception','date','finance_date',
				array('name'=>'pay_type','col'=>'payType.text'),
				array('name'=>'user','col'=>'user.name'),
				array('name'=>'service_point','col'=>'servicePoint.name'),
				array('name'=>'custom_type','col'=>'customType.text'),
				array('name'=>'finance_user','col'=>'financeUser.name')),
			array('total'=>$total));
		}
	}
	
	/**
	 * 
	 * 确认财务核销动作
	 */
	public function actionFinanceVerify(){
		$verifyResult = $_POST['verify'];
		$financeId = $_POST['finance_id'];
		$financeException = $_POST['finance_exception'];
		$model = TurnoverIncome::model()->find('id=:id',array(':id'=>$financeId));
		if($model == null){
			throw new CSysException('没有要核销的记录');
		}
		$model->finance_user_id = Yii::app()->user->userId;
		//1=核销确认，2=核销异常
		if($verifyResult == 1){
			$model->finance_state = TurnoverIncome::FINANCE_CHECKED;
		}else if($verifyResult == 2){
			$model->finance_state = TurnoverIncome::FINANCE_NOTCHECKED;
			$model->finance_exception = $financeException;
		}else{
			throw new CSysException('核销状态有误');
		}
		$model->finance_date = time();
		if(!$model->save()){
			echo JsonHelper::encode(false,JsonHelper::encodeError($model->getErrors()));
			Yii::app()->end();
		}
		echo JsonHelper::encode(true);
	}
}