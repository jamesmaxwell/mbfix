<?php

/**
 * This is the model class for table "{{repair_record}}".
 *
 * The followings are the available columns in table '{{repair_record}}':
 * @property integer $id
 * @property string $record_id
 * @property integer $judge_result
 * @property integer $problem_type
 * @property integer $repair_type
 * @property string $problem_desc
 * @property double $fix_money
 * @property integer $custom_decide
 * @property string $refuse_reason
 * @property integer $operation_date
 * @property integer $state
 *
 * The followings are the available model relations:
 * @property ProblemType $problemType
 * @property RepairType $repairType
 * @property ServiceRecord $record
 */
class RepairRecord extends CActiveRecord
{
	const TEMP_SAVE = 0;
	const CONFIRM_SAVE = 1;
	
	const CUSTOM_AGREE = 1;		//客户要修
	const CUSTOM_REFUSE = 2;	//客户不修
	
	/**
	 * Returns the static model of the specified AR class.
	 * @return RepairRecord the static model class
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
		return '{{repair_record}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('record_id, judge_result, problem_desc, operation_date, state', 'required'),
			array('judge_result, problem_type, repair_type, custom_decide, operation_date, state', 'numerical', 'integerOnly'=>true),
			array('fix_money', 'numerical'),
			array('record_id', 'length', 'max'=>20),
			array('problem_desc', 'length', 'max'=>500),
			array('refuse_reason', 'length', 'max'=>200),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, record_id, judge_result, problem_type, repair_type, problem_desc, fix_money, custom_decide, refuse_reason, operation_date, state', 'safe', 'on'=>'search'),
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
			'problemType' => array(self::BELONGS_TO, 'ProblemType', 'problem_type'),
			'repairType' => array(self::BELONGS_TO, 'RepairType', 'repair_type'),
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
			'judge_result' => 'Judge Result',
			'problem_type' => 'Problem Type',
			'repair_type' => 'Repair Type',
			'problem_desc' => 'Problem Desc',
			'fix_money' => 'Fix Money',
			'custom_decide' => 'Custom Decide',
			'refuse_reason' => 'Refuse Reason',
			'operation_date' => 'Operation Date',
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
		$criteria->compare('record_id',$this->record_id,true);
		$criteria->compare('judge_result',$this->judge_result);
		$criteria->compare('problem_type',$this->problem_type);
		$criteria->compare('repair_type',$this->repair_type);
		$criteria->compare('problem_desc',$this->problem_desc,true);
		$criteria->compare('fix_money',$this->fix_money);
		$criteria->compare('custom_decide',$this->custom_decide);
		$criteria->compare('refuse_reason',$this->refuse_reason,true);
		$criteria->compare('operation_date',$this->operation_date);
		$criteria->compare('state',$this->state);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}
}