<?php
/**
* 公告控制器
*/
class NoticeController extends Controller
{
	/**
	* 分页加载公告
	*/
	public function actionList(){
		$total = Notice::model()->count();
		$criteria = new CDbCriteria();
		$criteria->order = 't.id desc';
		$criteria->offset = $_REQUEST['start'];
		$criteria->limit = $_REQUEST['limit'];
		$list = Notice::Model()->findAll($criteria);
		echo JsonHelper::encode(true, '', $list, array('id','title','author','content','date'));
	}
	
	public function actionAdd(){
		$notice = CJSON::decode(file_get_contents('php://input'), true);
		$noticeModel = new Notice;
		$noticeModel->title = $notice['title'];
		$noticeModel->author = $notice['author'];
		$noticeModel->content = $notice['content'];
		$noticeModel->date = time();
		if($noticeModel->save()){
			echo JsonHelper::encode(true);
		}else{
			echo JsonHelper::encode(false,JsonHelper::encodeError($noticeModel->getErrors()));
		}
	}
	
	public function actionUpdate(){
		$notice = CJSON::decode(file_get_contents('php://input'), true);
		$id = $notice['id'];
		$noticeModel = Notice::model()->find('id=:id',array(':id'=>$id));
		if($noticeModel != null){
			$noticeModel->title = $notice['title'];
			$noticeModel->author = $notice['author'];
			$noticeModel->content = $notice['content'];
			$noticeModel->date = time();
			$noticeModel->save();
			
			echo JsonHelper::encode(true);
		}else{
			throw new CSysException('公告没找到');
		}
	}
	
	public function actionDelete(){
		$notice = CJSON::decode(file_get_contents('php://input'), true);
		$noticeModel = Notice::model()->find('id=:id',array(':id'=>$notice['id']));
		if($noticeModel != null){
			$noticeModel->delete();
			echo JsonHelper::encode(true);
		}
		echo JsonHelper::encode(false,'公告没找到');
	}
}