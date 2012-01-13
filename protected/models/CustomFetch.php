<?php

/**
 * 客户取机结案模型类
 *
 * The followings are the available columns in table '{{custom_fetch}}':
 * @property integer $id
 * @property string $record_id
 * @property integer $fetch_type
 * @property integer $logistics_type_id
 * @property string $logistics_no
 * @property integer $pay_state
 * @property integer $pay_type_id
 * @property double $pay_money
 * @property integer $finish_date
 *
 * The followings are the available model relations:
 * @property LogisticsType $logisticsType
 * @property PayType $payType
 * @property ServiceRecord $record
 */
class CustomFetch extends CActiveRecord
{
	/**
	 * Returns the static model of the specified AR class.
	 * @return CustomFetch the static model class
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
		return '{{custom_fetch}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('record_id, fetch_type, pay_state, pay_type_id, pay_money', 'required'),
			array('fetch_type, logistics_type_id, pay_state, pay_type_id, finish_date', 'numerical', 'integerOnly'=>true),
			array('pay_money', 'numerical'),
			array('record_id', 'length', 'max'=>20),
			array('logistics_no', 'length', 'max'=>100),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, record_id, fetch_type, logistics_type_id, logistics_no, pay_state, pay_type_id, pay_money, finish_date', 'safe', 'on'=>'search'),
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
			'logisticsType' => array(self::BELONGS_TO, 'LogisticsType', 'logistics_type_id'),
			'payType' => array(self::BELONGS_TO, 'PayType', 'pay_type_id'),
			'record' => array(self::BELONGS_TO, 'ServiceRecord', 'record_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'record_id' => 'Record',
			'fetch_type' => 'Fetch Type',
			'logistics_type_id' => 'Logistics Type',
			'logistics_no' => 'Logistics No',
			'pay_state' => 'Pay State',
			'pay_type_id' => 'Pay Type',
			'pay_money' => 'Pay Money',
			'finish_date' => 'Finish Date',
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
		$criteria->compare('record_id',$this->record_id,true);
		$criteria->compare('fetch_type',$this->fetch_type);
		$criteria->compare('logistics_type_id',$this->logistics_type_id);
		$criteria->compare('logistics_no',$this->logistics_no,true);
		$criteria->compare('pay_state',$this->pay_state);
		$criteria->compare('pay_type_id',$this->pay_type_id);
		$criteria->compare('pay_money',$this->pay_money);
		$criteria->compare('finish_date',$this->finish_date);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}
}