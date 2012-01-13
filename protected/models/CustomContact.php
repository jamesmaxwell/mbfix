<?php

/**
 * This is the model class for table "{{custom_contact}}".
 *
 * The followings are the available columns in table '{{custom_contact}}':
 * @property integer $id
 * @property string $record_id
 * @property integer $contact_type_id
 * @property string $contact_content
 * @property integer $contact_date
 *
 * The followings are the available model relations:
 * @property ServiceRecord $record
 * @property ContactType $contactType
 */
class CustomContact extends CActiveRecord
{
	/**
	 * Returns the static model of the specified AR class.
	 * @return CustomContact the static model class
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
		return '{{custom_contact}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('record_id, contact_type_id, contact_content, contact_date', 'required'),
			array('id, contact_type_id, contact_date', 'numerical', 'integerOnly'=>true),
			array('record_id', 'length', 'max'=>11),
			array('contact_content', 'length', 'max'=>300),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, record_id, contact_type_id, contact_content, contact_date', 'safe', 'on'=>'search'),
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
			'record' => array(self::BELONGS_TO, 'ServiceRecord', 'record_id'),
			'contactType' => array(self::BELONGS_TO, 'ContactType', 'contact_type_id'),
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
			'contact_type_id' => 'Contact Type',
			'contact_content' => 'Contact Content',
			'contact_date' => 'Contact Date',
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
		$criteria->compare('contact_type_id',$this->contact_type_id);
		$criteria->compare('contact_content',$this->contact_content,true);
		$criteria->compare('contact_date',$this->contact_date);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}
}