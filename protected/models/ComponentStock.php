<?php

/**
 * This is the model class for table "{{component_stock}}".
 *
 * The followings are the available columns in table '{{component_stock}}':
 * @property integer $id
 * @property integer $component_id
 * @property integer $service_point_id
 * @property double $amount
 *
 * The followings are the available model relations:
 * @property Component $component
 * @property ServicePoint $servicePoint
 */
class ComponentStock extends CActiveRecord
{
	/**
	 * Returns the static model of the specified AR class.
	 * @return ComponentStock the static model class
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
		return '{{component_stock}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('component_id, service_point_id', 'required'),
			array('component_id, service_point_id', 'numerical', 'integerOnly'=>true),
			array('amount', 'numerical'),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, component_id, service_point_id, amount', 'safe', 'on'=>'search'),
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
			'component' => array(self::BELONGS_TO, 'Component', 'component_id'),
			'servicePoint' => array(self::BELONGS_TO, 'ServicePoint', 'service_point_id'),
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
			'service_point_id' => 'Service Point',
			'amount' => 'Amount',
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
		$criteria->compare('component_id',$this->component_id);
		$criteria->compare('service_point_id',$this->service_point_id);
		$criteria->compare('amount',$this->amount);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}
}