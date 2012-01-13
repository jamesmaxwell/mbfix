<?php

/**
 * 系统用户模型类
 *
 * The followings are the available columns in table '{{user}}':
 * @property integer $id
 * @property string $name
 * @property string $password
 * @property integer $lastlogin
 * @property string $notes
 * @property string $loginkey
 * @property string $roles		//以','分隔的方式保存用户角色列表，目前系统角色不能自定义
 * @property integer $deleted
 *
 * The followings are the available model relations:
 * @property ComponentApply[] $componentApplys
 * @property ServiceRecord[] $serviceRecords
 * @property UserRole[] $userRoles
 * @property UserServicePoint[] $userServicePoints
 */
class User extends CActiveRecord
{
	/**
	 * 维修员角色
	 */
	const ROLE_FIXER = 'fixer';
	
	/**
	 * 管理员角色
	 */
	const ROLE_ADMIN = 'administrator';
	
	/**
	 * 财务角色
	 */
	const ROLE_ACCOUNTER = 'accounter';
	
	/**
	 * 库房管理员角色
	 */
	const ROLE_STOCKKEEPER = 'storekeeper';
	
	/**
	* 默认用户密码
	*/
	const DEFAULT_PASSWORD = 'mbfix.com';
	
	//用户角色列表
	public $roles;
	
	/**
	 * Returns the static model of the specified AR class.
	 * @return User the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}

	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return '{{user}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('name, password', 'required'),
			array('lastlogin, deleted', 'numerical', 'integerOnly'=>true),
			array('name', 'length', 'max'=>50),
			array('loginkey', 'length', 'max'=>13),
			array('password', 'length', 'max'=>32),
			array('roles', 'length', 'max'=>200),
			array('notes', 'length', 'max'=>300),
			array('deleted','length', 'is'=>1),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, name, password, lastlogin, notes, roles, deleted', 'safe', 'on'=>'search'),
		);
	}

	/**
	 * @return array relational rules.
	 */
	public function relations()
	{
		// NOTE: you may need to adjust the relation name and the related
		// class name for the relations automatically generated below.
		return array(
			'componentApplys' => array(self::HAS_MANY, 'ComponentApply', 'user_id'),
			'serviceRecords' => array(self::HAS_MANY, 'ServiceRecord', 'user_id'),
			/*'userRoles' => array(self::HAS_MANY, 'UserRole', 'user_id'),*/
			'userServicePoints' => array(self::HAS_MANY, 'UserServicePoint', 'user_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'name' => 'Name',
			'password' => 'Password',
			'lastlogin' => 'Lastlogin',
			'notes' => 'Notes',
			'loginkey' => 'LoginKey',
			'roles' => 'Roles',
			'deleted' => 'Deleted',
		);
	}
}