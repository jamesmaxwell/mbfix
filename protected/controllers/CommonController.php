<?php
class CommonController extends Controller
{
	/**
	 * 取得唯一的工单号, 工单号的生成规则是 21位, 前两位是网点英文简称如 HZ
	 * 后6位是日期如 111201 表示 2011.12.01,后13位是UUID生成的唯一串
	 */
	public function actionRecordNo()
	{
		$user = Yii::app()->user;
		if($user->isGuest){
			echo '';
		}else{
			//读取服务点简称
			$servicePointId = $user->getState('servicePoint');
			$servicePoint = ServicePoint::model()->find('id=:id',array(':id'=>$servicePointId));
			if($servicePoint == null){
				echo '';
			}else{
				//网点简称只取两位,默认为'__'
				$shortName = $servicePoint->short_name;
				$namelen = mb_strlen($shortName);
				if($namelen == 0){
					$shortName = '__';
				}else if($namelen > 2){
					$shortName = mb_substr($shortName, 0, 2);
				}
				echo strtoupper($shortName . date('ymd') . uniqid());	//返回21位工单号
			}
		}
	}
	/**
	 * 通用的读取类型列表的接口
	 * 如 读取客户类型,服务类型, 机器品牌,机器类型,质保类型等
	 */
	public function actionReadCommonType()
	{
		$typename = $_GET['typename'];	//具体类型名称
		//TODO: 检查类型是否合法
		//注: 用变量直接调用静态方法的用法只在 php5.3之后可用.
		$types = $typename::model()->findAll();
		echo JsonHelper::encode(true,'',$types,array('id','text'));
		Yii::app()->end();
	}
	
	/**
	 * 通用的更新类型类的接口.
	 */
	public function actionUpdateCommonType()
	{
		$typename = $_GET['typename'];	//具体类型名称
		//取得客户端POST过来的Raw data (JSON字符串)
		$newRecords = CJSON::decode(file_get_contents('php://input'), true);
		if(is_array($newRecords)){
			//先转换成数组
			if(!is_array($newRecords[0]))
				$newRecords = array($newRecords);
			foreach($newRecords as $record){
				$model = $typename::model()->find('id<>:id and text=:text',array(':id'=>$record['id'],':text'=>$record['text']));
				//名称不能重复
				if($model != null){
					echo JsonHelper::encode(false,'名称不能重复');
					Yii::app()->end();
					break;
				}
				$model = $typename::model()->findByPk($record['id']);
				if($model != null){
					$model->text = $record['text'];
					$model->save();
				}
			}
			echo JsonHelper::encode(true,'更新成功');
		}
	}
	
	/**
	 * 通用的添加类型类的接口
	 */
	public function actionNewCommonType()
	{
		$typename = $_GET['typename'];
		//取得客户端POST过来的Raw data (JSON字符串)
		$newRecord = CJSON::decode(file_get_contents('php://input'));
		$model = new $typename;
		$model->text = $newRecord['text'];
		$checkModel = $typename::model()->find('text=:text',array(':text'=>$newRecord['text']));
		if($checkModel != null){
			echo JsonHelper::encode(false,'名称不能重复');
			Yii::app()->end();
		}
		if($model->save()){
			echo JsonHelper::encode(true,'添加成功',array($model),array('id','text'));
		}else{
			echo JsonHelper::encode(false,'添加失败');
		}
	}
	
	/**
	 * 通用的删除类型类的接口
	 */
	public function actionDeleteCommonType()
	{
		$typename = $_GET['typename'];
		$rowRecord = CJSON::decode(file_get_contents('php://input'));
		//这里考虑数据库的级联删除功能来限制是否可删除该记录
		$model = new $typename;
		$record = $model->findByPk($rowRecord['id']);
		if($record->delete()){
			echo JsonHelper::encode(true,'删除成功');
		}else{
			echo JsonHelper::encode(false,'删除失败');
		}
	}
}