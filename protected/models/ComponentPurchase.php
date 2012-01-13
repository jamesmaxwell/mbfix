<?php

/**
 * 备件采购模型类
 *
 * The followings are the available columns in table '{{component_purchase}}':
 * @property integer $id
 * @property integer $user_id
 * @property integer $service_point_id
 * @property integer $component_id
 * @property integer $apply_id
 * @property string $supply_company
 * @property string $supply_address
 * @property double $amount
 * @property string $unit
 * @property double $price
 * @property integer $pay_state
 * @property integer $pay_type
 * @property string $pay_account
 * @property integer $date
 * @property string $notes
 * @property integer $state
 *
 * The followings are the available model relations:
 * @property User $user
 * @property ServicePoint $servicePoint
 * @property PayType $payType
 */
class ComponentPurchase extends CActiveRecord
{
	/**
	 *
	 * 未入库
	 */
	const NOTINSTOCK = 1;

	/**
	 *
	 * 已入库
	 */
	const INSTOCK = 2;
	/**
	 * Returns the static model of the specified AR class.
	 * @return ComponentPurchase the static model class
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
		return '{{component_purchase}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
		array('user_id, service_point_id, supply_company, unit, price, pay_state, pay_type, pay_account, date', 'required'),
		array('user_id, service_point_id,apply_id, component_id, state, pay_state, pay_type, date', 'numerical', 'integerOnly'=>true),
		array('amount, price', 'numerical'),
		array('supply_company, pay_account', 'length', 'max'=>100),
		array('supply_address', 'length', 'max'=>200),
		array('unit', 'length', 'max'=>10),
		array('notes', 'length', 'max'=>500),
		// The following rule is used by search().
		// Please remove those attributes that should not be searched.
		array('id, user_id, service_point_id, state, supply_company, supply_address, amount, unit, price, pay_state, pay_type, pay_account, date, notes', 'safe', 'on'=>'search'),
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
			'user' => array(self::BELONGS_TO, 'User', 'user_id'),
			'servicePoint' => array(self::BELONGS_TO, 'ServicePoint', 'service_point_id'),
			'payType' => array(self::BELONGS_TO, 'PayType', 'pay_type'),
			'applyComponent' => array(self::BELONGS_TO, 'ComponentApply','apply_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'user_id' => 'User',
			'service_point_id' => 'Service Point',
			'component_id' => 'componentId',
			'apply_id' => 'ApplyId',
			'supply_company' => 'Supply Company',
			'supply_address' => 'Supply Address',
			'amount' => 'Amount',
			'unit' => 'Unit',
			'price' => 'Price',
			'pay_state' => 'Pay State',
			'pay_type' => 'Pay Type',
			'pay_account' => 'Pay Account',
			'date' => 'Date',
			'notes' => 'Notes',
			'state' => 'State',
		);
	}

	/**
	 * Retrieves a list of models based on the current search/filter conditions.
	 * @return CActiveDataProvider the data provider that can return the models based on the search/filter conditions.
	 */
	public function search()
	{
		// Warning: Please modify the following code to remove attributes that
		// should not be searched.

		$criteria=new CDbCriteria;

		$criteria->compare('id',$this->id);
		$criteria->compare('user_id',$this->user_id);
		$criteria->compare('service_point_id',$this->service_point_id);
		$criteria->compare('supply_company',$this->supply_company,true);
		$criteria->compare('supply_address',$this->supply_address,true);
		$criteria->compare('amount',$this->amount);
		$criteria->compare('unit',$this->unit,true);
		$criteria->compare('price',$this->price);
		$criteria->compare('pay_state',$this->pay_state);
		$criteria->compare('pay_type',$this->pay_type);
		$criteria->compare('pay_account',$this->pay_account,true);
		$criteria->compare('date',$this->date);
		$criteria->compare('notes',$this->notes,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}
}