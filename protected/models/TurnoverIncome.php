<?php

/**
 * 营业款收入明细模型类
 *
 * The followings are the available columns in table '{{turnover_income}}':
 * @property integer $id
 * @property integer $user_id
 * @property integer $service_point_id
 * @property string $record_no
 * @property integer $custom_type
 * @property string $custom_name
 * @property string $receiver
 * @property integer $pay_type
 * @property double $money
 * @property double $profit
 * @property string $notes
 * @property integer $date
 * @property integer $pay_state
 * @property integer $finance_state
 * @property string $finance_exception
 * @property integer $finance_date
 * @property integer $finance_user_id
 *
 * The followings are the available model relations:
 * @property PayType $payType
 * @property ServicePoint $servicePoint
 * @property User $user
 */
class TurnoverIncome extends CActiveRecord
{
	/**
	 * 已付款
	 */
	const PAYSTATE_PAID = 1;
	
	/**
	 * 未付款
	 */
	const PAYSTATE_NOTPAY = 2;
	
	/**
	 * 待核销状态
	 */
	const FINANCE_UNVIEWED = 0;
	
	/**
	 * 财务已核销
	 */
	const FINANCE_CHECKED = 1;
	
	/**
	 * 财务核销异常
	 */
	const FINANCE_NOTCHECKED = 2;
	
	/**
	 * Returns the static model of the specified AR class.
	 * @param string $className active record class name.
	 * @return TurnoverIncome the static model class
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
		return '{{turnover_income}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('user_id, service_point_id, money', 'required'),
			array('user_id, service_point_id, custom_type,pay_state, finance_user_id,finance_state, pay_type, date,finance_date', 'numerical', 'integerOnly'=>true),
			array('money, profit', 'numerical'),
			array('record_no, custom_name', 'length', 'max'=>45),
			array('receiver', 'length', 'max'=>20),
			array('notes, finance_exception', 'length', 'max'=>300),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, user_id, service_point_id, record_no, custom_type, custom_name, receiver,finance_date,finance_user_id, pay_type,finance_exception, pay_state, finance_state,money, profit, notes, date', 'safe', 'on'=>'search'),
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
			'payType' => array(self::BELONGS_TO, 'PayType', 'pay_type'),
			'servicePoint' => array(self::BELONGS_TO, 'ServicePoint', 'service_point_id'),
			'user' => array(self::BELONGS_TO, 'User', 'user_id'),
			'customType' => array(self::BELONGS_TO, 'CustomType','custom_type'),
			'financeUser' => array(self::BELONGS_TO, 'User', 'finance_user_id'),
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
			'record_no' => 'Record No',
			'custom_type' => 'Custom Type',
			'custom_name' => 'Custom Name',
			'receiver' => 'Receiver',
			'pay_type' => 'Pay Type',
			'pay_state' => 'Pay State',
			'finance_user_id' => 'Finance User',
			'finance_state' => 'Finance State',
			'finance_exception' => 'Finance Exception',
			'finance_date' => 'Finance Date',
			'money' => 'Money',
			'profit' => 'Profit',
			'notes' => 'Notes',
			'date' => 'Date',
		);
	}
}