<?php

/**
 * 备件信息实体
 * This is the model class for table "{{component}}".
 *
 * The followings are the available columns in table '{{component}}':
 * @property integer $id
 * @property string $name
 * @property integer $brand_id
 * @property integer $model_id
 * @property string $notes
 *
 * The followings are the available model relations:
 * @property ComponentBrand $brand
 * @property ComponentModel $model
 * @property ComponentStock[] $componentStocks
 */
class RepairComponent extends CActiveRecord
{
	/**
	 * Returns the static model of the specified AR class.
	 * @return RepairComponent the static model class
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
		return '{{component}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('name, brand_id, model_id', 'required'),
			array('brand_id, model_id', 'numerical', 'integerOnly'=>true),
			array('name', 'length', 'max'=>45),
			array('notes', 'length', 'max'=>500),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, name, brand_id, model_id, notes', 'safe', 'on'=>'search'),
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
			'brand' => array(self::BELONGS_TO, 'ComponentBrand', 'brand_id'),
			'model' => array(self::BELONGS_TO, 'ComponentModel', 'model_id'),
			'componentStock' => array(self::HAS_ONE, 'ComponentStock', 'component_id'),
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
			'brand_id' => 'Brand',
			'model_id' => 'Model',
			'notes' => 'Notes',
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
		$criteria->compare('name',$this->name,true);
		$criteria->compare('brand_id',$this->brand_id);
		$criteria->compare('model_id',$this->model_id);
		$criteria->compare('notes',$this->notes,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}
}