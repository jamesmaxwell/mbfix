<?php
/**
 *
 * 备件相关控制器，功能包括备件申请，备件采购，备件入库，备件出库和备件查询
 * @author junwei.hu
 *
 */
class ComponentApplyController extends Controller
{
	/**
	 * 用户查看备件申请列表
	 */
	public function actionList()
	{
		$user = Yii::app()->user;
		if($user->isGuest){
			echo JsonHelper::encode(false,'未登录');
			Yii::app()->end();
		}
		$userId = Yii::app()->user->getState('userId');
		$servicePoint = Yii::app()->user->getState('servicePoint');

		$limit = $_GET['limit'];
		$offset = $_GET['start'];
		$criteria = new CDbCriteria();
		$criteria->condition = 'user_id = :user_id and service_point_id = :service_point_id';
		$criteria->params = array(':user_id'=>$userId, ':service_point_id'=>$servicePoint);
		$criteria->with = array('component'=>array('select'=>'name'));
		//取得总记录数
		$total = ComponentApply::model()->count($criteria);

		$criteria->order = 't.date desc';
		$criteria->limit = $limit;
		$criteria->offset = $offset;

		$items = ComponentApply::model()->findAll($criteria);
		echo JsonHelper::encode(true,'',$items, array('id','amount','date','notes','state',
		array('name'=>'component_name','col'=>'component.name')),
		array('total'=>$total));
	}

	/**
	 * 创建备件申请单
	 * 如果指定 品牌,型号和名称的备件不存在,则先添加该备件信息,再添加申请记录
	 */
	public function actionApply()
	{
		$brand_id = $_POST['component_brand'];	//品牌
		$model_id = $_POST['component_model'];	//型号
		$name = $_POST['component_name'];		//名称
		$purchaseType = $_POST['purchase_type'];//采购类型
		$amount = $_POST['amount'];				//申请数量
		$notes = $_POST['notes'];				//备注
		if(!is_numeric($amount) || $amount < 1){
			echo JsonHelper::encode(false, '申请数量有误,请输入一个大于0的值');
			Yii::app()->end();
		}

		$cmpModel = RepairComponent::model()->find(
		'brand_id = :brand_id and model_id = :model_id and name = :name',
		array(':brand_id'=>$brand_id,
			':model_id'=>$model_id,
			':name'=>$name)
		);

		$service_point_id = Yii::app()->user->getState('servicePoint');

		//TODO: 用 事务 来处理..........
		//$trans = $cmpModel->dbConnection->beginTransaction();
		//try{
		//如果没找到,则先添加备件资料
		if($cmpModel == null){
			$cmpModel = new RepairComponent;
			$cmpModel->name = $name;
			$cmpModel->brand_id = $brand_id;
			$cmpModel->model_id = $model_id;
			$cmpModel->notes = '申请自动添加';
			if(!$cmpModel->save()){
				echo JsonHelper::encode(false, '申请时,添加新备件失败');
				Yii::app()->end();
			}else{
				//备件资料添加成功,则再添加库存信息
				$stockModel = new ComponentStock;
				$stockModel->component_id = $cmpModel->id;
				$stockModel->service_point_id = $service_point_id;
				$stockModel->amount = 0;
				if(!$stockModel->save()){
					echo JsonHelper::encode(false,'申请时,添加新备件库存记录失败');
					Yii::app()->end();
				}
			}
		}

		//添加备件申请记录
		$applyModel = new ComponentApply;
		$applyModel->component_id = $cmpModel->id;
		$applyModel->purchase_type = $purchaseType;
		$applyModel->amount = $amount;
		$applyModel->user_id = Yii::app()->user->getState('userId');
		$applyModel->service_point_id = $service_point_id;
		$applyModel->date = time();
		$applyModel->notes = $notes;
		if($applyModel->save()){

			//$trans->commit();

			echo JsonHelper::encode(true,'',array($applyModel),array('component_id'));
		}else{
			//}catch (Exception $e){
			//	Yii::log($e->getMessage());
			///	$trans->rollBack();
			echo JsonHelper::encode(false, '保存申请单失败');
		}
		//}
	}

	/**
	 *
	 * 保存采购信息
	 */
	public function actionPurchase(){
		$userId = Yii::app()->user->userId;
		$servicePointId = Yii::app()->user->servicePoint;
		$model = new ComponentPurchase();
		$model->attributes = $_POST['Purchase'];
		$model->user_id = $userId;
		$model->service_point_id = $servicePointId;
		$model->date = time();
		$trans = $model->dbConnection->beginTransaction();
		try{
			//根据申请id，得到申请备件表中的备件id
			$applyModel = ComponentApply::model()->find('id=:id',array(':id'=>$model->apply_id));
			if($applyModel != null){
				$model->component_id = $applyModel->component_id;

				if($model->save()){
					//更新备件申请表中的状态为 3=已采购
					$applyModel->state = ComponentApply::PURCHASED;
					$applyModel->save();
					//保存后同时记录到费用支出明细列表中
					$payoutModel = new PayoutDetail();
					$payoutModel->handler_user_id = $userId;
					$payoutModel->service_point_id = $servicePointId;
					$payoutModel->date = time();
					$payoutModel->consume_content = '备件采购时自动产生';
					$payoutModel->ticket_type = PayoutDetail::TICKET_TYPE_WULIU;
					$payoutModel->ticket_no = '';
					$payoutModel->notes = '备件采购单号:' . $model->id;
					if(!$payoutModel->save()){
						throw new CSysException('备件采购保存费用明细时出错。'. JsonHelper::encodeError($payoutModel->getErrors()));
					}
					echo JsonHelper::encode(true);
				}else{
					throw new CHttpException(500, var_dump($model->getErrors()));
				}
			}else{
				throw new CSysException('没有找到备件申请信息,不能采购');
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
	 * 显示备件采购列表
	 */
	public function actionPurchaseList(){
		$limit = $_GET['limit'];
		$offset = $_GET['start'];
		$criteria = new CDbCriteria();
		$criteria->with = array('user','servicePoint','payType');
		$criteria->order = 't.state asc,t.date desc';
		$count = ComponentPurchase::model()->count($criteria);
		$criteria->limit = $limit;
		$criteria->offset = $offset;
		$records = ComponentPurchase::model()->findAll($criteria);
		echo JsonHelper::encode(true,'',$records,array('id','supply_company','supply_address','amount','unit',
			'price','pay_state','pay_account','date','notes','state',
		array('name'=>'user','col'=>'user.name'),
		array('name'=>'servicePoint','col'=>'servicePoint.name'),
		array('name'=>'pay_type','col'=>'payType.text')));
	}

	/**
	 *
	 * 采购入库动作
	 */
	public function actionAccept(){
		$model = new ComponentAccept;
		$model->attributes = $_POST['Accept'];
		$model->user_id = Yii::app()->user->userId;
		$model->service_point = Yii::app()->user->servicePoint;
		$model->date = time();
		$trans = $model->dbConnection->beginTransaction();
		try{
			//保存入库记录
			if($model->save()){
				//更新采购记录的状态为已入库
				$purchaseModel = ComponentPurchase::model()->find('id=:id',array(':id'=>$model->purchase_id));
				$purchaseModel->state = ComponentPurchase::INSTOCK;	//更新为已入库
				$purchaseModel->date = time();	//更新入库时间
				if($purchaseModel->save()){
					//更新库存表中的库存数量
					$stock = ComponentStock::model()->find('component_id=:component_id and service_point_id=:service_point_id',
					array(':component_id'=>$purchaseModel->component_id,':service_point_id'=>$model->service_point));
					$stock->amount += $model->amount;
					$stock->save();
				}
			}
			$trans->commit();
		}catch(Exception $e){
			Yii::log($e->getMessage());
			$trans->rollBack();

			echo JsonHelper::encode(false, $e->getMessage());
			Yii::app()->end();
		}
		echo JsonHelper::encode(true);
	}

	/**
	 *
	 * 备件出库确认
	 */
	public function actionStockout(){
		$userId = Yii::app()->user->userId;
		$servicePoint = Yii::app()->user->servicePoint;
		$model = new ComponentStockout();
		$model->attributes = $_POST['Stockout'];
		$model->user_id = $userId;
		$model->service_point_id = $servicePoint;
		$model->date = time();
		$trans = $model->dbConnection->beginTransaction();
		try{
			//如果出库类型是’维修‘，则要判断输入的工单号是否存在
			if($model->sell_for == ComponentStockout::SELLFORREPAIR){
				$recordModel = ServiceRecord::model()->find('record_no=:record_no',array(':record_no'=>$model->record_no));
				if($recordModel == null){
					throw new CDbException('工单号 '. $model->record_no . '　不存在.');
				}
				//只有’待料‘中的服务单才能作为维修出库用
				if($recordModel->record_state != ServiceRecord::WAIT_COMPONENT){
					throw new CDbException('服务单 '. $model->record_no . ' 状态不是"待料"，无法作为维修出库用。');
				}
			}
			//判断库存是否足够,当前网点
			$stockModel = ComponentStock::model()->find('component_id=:component_id and service_point_id=:service_point_id',
			array(':component_id'=>$model->component_id,':service_point_id'=>$servicePoint));
			if($stockModel == null){
				throw new CDbException('没有找到库存记录');
			}
			if($stockModel->amount < $model->amount){
				throw new CDbException('库存不足');
			}
			//保存出库记录
			if(!$model->save()){
				throw new CSysException('保存出库记录失败.' . JsonHelper::encodeError($model->getErrors()));
			}
			//出库同时，更新库存
			$stockModel->amount -= $model->amount;
			$stockModel->save(true,array('amount'));
			//如果是销售类型的出库，则保存营业款收入明细,只在以销售类型的出库进添加
			if($model->sell_for == ComponentStockout::SELLFORSELL){
				$incomeModel = new TurnoverIncome();
				$incomeModel->user_id = $userId;
				$incomeModel->service_point_id = $servicePoint;
				$incomeModel->pay_type = $model->pay_type;
				//收入金额＝数量*单价－优惠
				$incomeModel->money = $model->amount * $model->price - $model->discount;
				$incomeModel->notes = '备件出库自动生成，出库编号为 ' . $model->id;
				$incomeModel->save();
			}
			$trans->commit();
		}catch(Exception $e){
			Yii::log($e->getMessage());
			$trans->rollBack();

			echo JsonHelper::encode(false, $e->getMessage());
			Yii::app()->end();
		}
		echo JsonHelper::encode(true);
	}

	/**
	 * 备件出库列表
	 */
	public function actionStockoutList(){
		$limit = $_GET['limit'];
		$offset = $_GET['start'];

		$criteria = new CDbCriteria();
		$criteria->order = 't.date desc';
		//总记录数
		$total = ComponentStockout::model()->count($criteria);

		$criteria->with = array('user'=>array('select'=>'name'),
			'servicePoint'=>array('select'=>'name'),
			'payType'=>array('select'=>'text'),
			'component'=>array('select'=>'name'),
			'component.brand'=>array('select'=>'text'),
			'component.model'=>array('select'=>'text'));
		$criteria->limit = $limit;
		$criteria->offset = $offset;

		$records = ComponentStockout::model()->findAll($criteria);
		echo JsonHelper::encode(true,'',$records, array('id','buyer_company','sell_for','sell_type',
			'record_no','store_house','amount','unit','price','discount','receipt_type','receipt_account',
			'pay_type','receiver','notes','date',
		array('name'=>'user','col'=>'user.name'),
		array('name'=>'component_brand','col'=>'component.brand.text'),
		array('name'=>'component_modal','col'=>'component.model.text'),
		array('name'=>'component_name','col'=>'component.name'),
		array('name'=>'servicePoint','col'=>'servicePoint.name'),
		array('name'=>'pay_type','col'=>'payType.text')));
	}
}