<?php

/**
 * This is the model class for table "{{component_apply}}".
 *
 * The followings are the available columns in table '{{component_apply}}':
 * @property integer $id
 * @property integer $component_id
 * @property double $amount
 * @property integer $user_id
 * @property integer $service_point_id
 * @property integer $purchase_type
 * @property integer $date
 * @property string $notes
 * @property integer $state
 *
 * The followings are the available model relations:
 * @property Component $component
 * @property User $user
 * @property ServicePoint $servicePoint
 */
class ComponentApply extends CActiveRecord
{
	//申请中
	const APPLYING = 0;
	//已到料
	const INSTOCK = 1;
	//已采购
	const PURCHASED = 2;
	//已领料
	const FETCHED = 3;

	
	/**
	 * Returns the static model of the specified AR class.
	 * @return ComponentApply the static model class
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
		return '{{component_apply}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('component_id, amount, user_id, service_point_id, date', 'required'),
			array('id, component_id, user_id, purchase_type, service_point_id, date, state', 'numerical', 'integerOnly'=>true),
			array('amount', 'numerical'),
			array('notes', 'length', 'max'=>200),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, component_id, amount, user_id, service_point_id, date, notes, state', 'safe', 'on'=>'search'),
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
			'component' => array(self::BELONGS_TO, 'RepairComponent', 'component_id'),
			'user' => array(self::BELONGS_TO, 'User', 'user_id'),
			'servicePoint' => array(self::BELONGS_TO, 'ServicePoint', 'service_point_id'),
			'purchaseType' => array(self::BELONGS_TO, 'PurchaseType', 'purchase_type'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'component_id' => 'Component',
			'amount' => 'Amount',
			'user_id' => 'User',
			'service_point_id' => 'Service Point',
			'date' => 'Date',
			'notes' => 'Notes',
			'state' => 'State',
			'purchase_type' => 'PurchaseType',
		);
	}
}