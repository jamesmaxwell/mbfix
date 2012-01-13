<?php

/**
 * 备件出库模型类
 *
 * The followings are the available columns in table '{{component_stockout}}':
 * @property integer $id
 * @property integer $user_id
 * @property integer $service_point_id
 * @property string $buyer_company
 * @property integer $sell_for
 * @property integer $sell_type
 * @property string $record_no
 * @property string $store_house
 * @property integer $component_id
 * @property double $amount
 * @property string $unit
 * @property double $price
 * @property double $discount
 * @property integer $receipt_type
 * @property string $receipt_account
 * @property integer $pay_type
 * @property string $receiver
 * @property string $notes
 * @property integer $date
 *
 * The followings are the available model relations:
 * @property User $user
 * @property ServicePoint $servicePoint
 * @property Component $component
 */
class ComponentStockout extends CActiveRecord
{
	/**
	 * 出库类型，销售
	 */
	const SELLFORSELL = 1;
	/**
	 * 出库类型，维修
	 */
	const SELLFORREPAIR = 2;
	
	/**
	 * Returns the static model of the specified AR class.
	 * @return ComponentStockout the static model class
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
		return '{{component_stockout}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('user_id, service_point_id, buyer_company, sell_for, sell_type, store_house, component_id, amount, unit, price, discount, date', 'required'),
			array('user_id, service_point_id, sell_for, sell_type, component_id, receipt_type, pay_type, date', 'numerical', 'integerOnly'=>true),
			array('amount, price, discount', 'numerical'),
			array('buyer_company', 'length', 'max'=>100),
			array('record_no, store_house, unit, receipt_account, receiver', 'length', 'max'=>45),
			array('notes', 'length', 'max'=>300),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, user_id, service_point_id, buyer_company, sell_for, sell_type, record_no, store_house, component_id, amount, unit, price, discount, receipt_type, receipt_account, pay_type, receiver, notes, date', 'safe', 'on'=>'search'),
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
			'component' => array(self::BELONGS_TO, 'RepairComponent', 'component_id'),
			'payType' => array(self::BELONGS_TO, 'PayType', 'pay_type'),
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
			'buyer_company' => 'Buyer Company',
			'sell_for' => 'Sell For',
			'sell_type' => 'Sell Type',
			'record_no' => 'Record No',
			'store_house' => 'Store House',
			'component_id' => 'Component',
			'amount' => 'Amount',
			'unit' => 'Unit',
			'price' => 'Price',
			'discount' => 'Discount',
			'receipt_type' => 'Receipt Type',
			'receipt_account' => 'Receipt Account',
			'pay_type' => 'Pay Type',
			'receiver' => 'Receiver',
			'notes' => 'Notes',
			'date' => 'Date',
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
		$criteria->compare('buyer_company',$this->buyer_company,true);
		$criteria->compare('sell_for',$this->sell_for);
		$criteria->compare('sell_type',$this->sell_type);
		$criteria->compare('record_no',$this->record_no,true);
		$criteria->compare('store_house',$this->store_house,true);
		$criteria->compare('component_id',$this->component_id);
		$criteria->compare('amount',$this->amount);
		$criteria->compare('unit',$this->unit,true);
		$criteria->compare('price',$this->price);
		$criteria->compare('discount',$this->discount);
		$criteria->compare('receipt_type',$this->receipt_type);
		$criteria->compare('receipt_account',$this->receipt_account,true);
		$criteria->compare('pay_type',$this->pay_type);
		$criteria->compare('receiver',$this->receiver,true);
		$criteria->compare('notes',$this->notes,true);
		$criteria->compare('date',$this->date);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}
}