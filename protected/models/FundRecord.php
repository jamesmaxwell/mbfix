<?php

/**
 * 款项申请，审核模型类
 *
 * The followings are the available columns in table '{{fund_record}}':
 * @property integer $id
 * @property integer $apply_user_id
 * @property integer $apply_service_point_id
 * @property double $apply_amount
 * @property string $apply_reason
 * @property string $apply_notes
 * @property integer $apply_date
 * @property integer $verify_user_id
 * @property integer $verify_service_point_id
 * @property double $verify_amount
 * @property integer $pay_type
 * @property string $pay_account
 * @property string $receiver_account
 * @property string $receiver
 * @property string $verify_notes
 * @property integer $verify_date
 * @property integer $state
 *
 * The followings are the available model relations:
 * @property ServicePoint $verifyServicePoint
 * @property ServicePoint $applyServicePoint
 * @property User $applyUser
 * @property User $verifyUser
 */
class FundRecord extends CActiveRecord
{
	/**
	* 出款方式，淘宝
	*/
	const PAYTYPE_TAOBAO = 1;
	/**
	* 出款方式，现金
	*/
	const PAYTYPE_CASH = 2;
	/**
	* 出款方式，网银
	*/
	const PAYTYPE_BANKONLINE = 3;
	
	/*
	* 审核状态，等待审核
	*/
	const VERIFY_WAITING = 1;
		/*
	* 审核状态，审核通过
	*/
	const VERIFY_PASS = 2;
		/*
	* 审核状态，审核拒绝
	*/
	const VERIFY_DENY = 3;
	
	/**
	 * Returns the static model of the specified AR class.
	 * @param string $className active record class name.
	 * @return FundRecord the static model class
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
		return '{{fund_record}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('apply_user_id, apply_service_point_id, apply_amount, apply_reason, apply_notes, apply_date', 'required'),
			array('apply_user_id, apply_service_point_id, apply_date, verify_user_id, verify_service_point_id, pay_type, verify_date, state', 'numerical', 'integerOnly'=>true),
			array('apply_amount, verify_amount', 'numerical'),
			array('apply_reason, receiver', 'length', 'max'=>45),
			array('apply_notes, verify_notes', 'length', 'max'=>200),
			array('pay_account, receiver_account', 'length', 'max'=>100),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, apply_user_id, apply_service_point_id, apply_amount, apply_reason, apply_notes, apply_date, verify_user_id, verify_service_point_id, verify_amount, pay_type, pay_account, receiver_account, receiver, verify_notes, verify_date, state', 'safe', 'on'=>'search'),
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
			'verifyServicePoint' => array(self::BELONGS_TO, 'ServicePoint', 'verify_service_point_id'),
			'applyServicePoint' => array(self::BELONGS_TO, 'ServicePoint', 'apply_service_point_id'),
			'applyUser' => array(self::BELONGS_TO, 'User', 'apply_user_id'),
			'verifyUser' => array(self::BELONGS_TO, 'User', 'verify_user_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'apply_user_id' => 'Apply User',
			'apply_service_point_id' => 'Apply Service Point',
			'apply_amount' => 'Apply Amount',
			'apply_reason' => 'Apply Reason',
			'apply_notes' => 'Apply Notes',
			'apply_date' => 'Apply Date',
			'verify_user_id' => 'Verify User',
			'verify_service_point_id' => 'Verify Service Point',
			'verify_amount' => 'Verify Amount',
			'pay_type' => 'Pay Type',
			'pay_account' => 'Pay Account',
			'receiver_account' => 'Receiver Account',
			'receiver' => 'Receiver',
			'verify_notes' => 'Verify Notes',
			'verify_date' => 'Verify Date',
			'state' => 'State',
		);
	}
}