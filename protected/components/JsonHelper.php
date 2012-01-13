<?php
/**
 *  用于ExtJS请求的结果JSON序列化类
 */
class JsonHelper{
	/**
	 * 用JSON格式编辑结果
	 * @param Success 要求返回成功或失败的结果
	 * @param Message 当失败时,显示的错误信息
	 * @param Records CActiveRecord 类型的数组
	 * @param Columns 要返回的字段名的数组
	 * @param OtherProperty 其它返回的参数
	 * @return 按 Columns 要求的字段的json列表
	 */
	public static function encode($success, $message = null, $records = null, $columns = null, $otherProperty = null){
		$result = array();
		if($success === true){
			//成功,则返回记录
			$items = JsonHelper::itemEncode($records, $columns);
			
			$result['success'] = true;
			$result['results'] = $items;
		}else{
			//失败,输出错误信息
			$result['success'] = false;
			$result['errors'] = array('message' => ($message === null ? '发生错误' : $message));
		}
		if($otherProperty != null && is_array($otherProperty)){
			foreach($otherProperty as $key=>&$property){
				$result[$key] = $property;
			}
		}
		return CJSON::encode($result);
	}

	/**
	 *
	 * JSON序列化一个对象
	 */
	public static function itemEncode($records, $columns){
		$items = array();
		//TODO: $records 接收 ActiveRecord 类型的集合
		if($records != null){
			foreach($records as &$record){
				$item = array();
				foreach($columns as &$column){
					$col = $column;		//取列值的字符串
					$name = $column;	//返回的列名
					if(is_array($column)){
						$col = $column['col'];
						$name = $column['name'];

						//如果有取关联表字段,则中间以.分隔
						$colItems = explode('.',$col);
						$colCount = count($colItems);
						if($colCount > 1){
							$i = 1;
							$temp = $record[$colItems[0]];
							while($i < $colCount){
								$temp = $temp[$colItems[$i++]];
							}
							$item[$name] = $temp;
						}else{
							$item[$name] = $record[$col];
						}
					}
					else{
						$item[$name] = $record[$col];
					}
				}
				if(count($item) > 0)
				$items[] = $item;
			}
		}
		return $items;
	}
	
	/**
	* 序列化模型返回的错误信息。
	* @param $errors ActiveRecord的方法 getErrors() 返回的结果。
	*/
	public static function encodeError($errors){
		$errArr = array();
		if(is_array($errors)){
			foreach($errors as $key => &$error){
				$errArr[] = $key;
				foreach($error as &$errorItem){
					$errArr[] = $errorItem;
				}
			}
		}
		return implode('<br/>',$errArr);
	}
}