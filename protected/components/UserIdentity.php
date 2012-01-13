<?php

/**
 * UserIdentity represents the data needed to identity a user.
 * It contains the authentication method that checks if the provided
 * data can identity the user.
 */
class UserIdentity extends CUserIdentity
{
	private $_id;
	
	//public function getId(){
	//	return $_id;	
	//}
	
	/**
	 * Authenticates a user.
	 * @return boolean whether authentication succeeds.
	 */
	public function authenticate()
	{
		//只取未被删除的
		$user = User::model()->find(
			'name=:name and password=:password and deleted = 0',
			array(':name'=>$this->username,':password'=>md5($this->password))
		);

		if($user === null){
			$this->errorCode=self::ERROR_UNKNOWN_IDENTITY;
		}else{
			$_id = $user->id;
			$this->errorCode=self::ERROR_NONE;
		}
		return !$this->errorCode;
	}
}