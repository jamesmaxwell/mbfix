<?php

/**
 * This is the model class for table "{{service_point}}".
 * 服务点模型类
 * The followings are the available columns in table '{{service_point}}':
 * @property integer $id
 * @property string $name
 * @property string $short_name
 * @property string $desc
 * @property double @total_fund
 *
 * The followings are the available model relations:
 * @property ServiceRecord[] $serviceRecords
 * @property UserServicePoint[] $userServicePoints
 */
class ServicePoint extends CActiveRecord
{
	/**
	 * Returns the static model of the specified AR class.
	 * @return ServicePoint the static model class
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
		return '{{service_point}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('name, short_name', 'required'),
			array('name', 'length', 'max'=>45),
			array('short_name', 'length', 'max'=>2),
			array('desc', 'length', 'max'=>200),
			array('total_fund','numerical'),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, name, short_name, desc, total_fund', 'safe', 'on'=>'search'),
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
			'serviceRecords' => array(self::HAS_MANY, 'ServiceRecord', 'service_point_id'),
			'userServicePoints' => array(self::HAS_MANY, 'UserServicePoint', 'service_point_id'),
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
			'short_name' => 'Short Name',
			'desc' => 'Desc',
			'total_fund' => 'Total Fund',
		);
	}
}