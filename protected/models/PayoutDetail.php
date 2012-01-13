<?php

/**
 * 费用支出明细模型类
 *
 * The followings are the available columns in table '{{payout_detail}}':
 * @property integer $id
 * @property integer $handler_user_id
 * @property integer $service_point_id
 * @property string $consume_content
 * @property double $amount
 * @property integer $ticket_type
 * @property string $ticket_no
 * @property string $notes
 * @property integer $date
 *
 * The followings are the available model relations:
 * @property User $handlerUser
 * @property ServicePoint $servicePoint
 */
class PayoutDetail extends CActiveRecord
{
	//1=物流单,2=收据,3=发票
	const TICKET_TYPE_WULIU = 1;
	const TICKET_TYPE_SHOUJU = 2;
	const TICKET_TYPE_FAPIAO = 3;
	
	/**
	 * Returns the static model of the specified AR class.
	 * @param string $className active record class name.
	 * @return PayoutDetail the static model class
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
		return '{{payout_detail}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('handler_user_id, service_point_id, consume_content, amount, ticket_type, ticket_no, date', 'required'),
			array('handler_user_id, service_point_id, ticket_type, date', 'numerical', 'integerOnly'=>true),
			array('amount', 'numerical'),
			array('consume_content', 'length', 'max'=>200),
			array('ticket_no', 'length', 'max'=>100),
			array('notes', 'length', 'max'=>300),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, handler_user_id, service_point_id, consume_content, amount, ticket_type, ticket_no, notes, date', 'safe', 'on'=>'search'),
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
			'handlerUser' => array(self::BELONGS_TO, 'User', 'handler_user_id'),
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
			'handler_user_id' => 'Handler User',
			'service_point_id' => 'Service Point',
			'consume_content' => 'Consume Content',
			'amount' => 'Amount',
			'ticket_type' => 'Ticket Type',
			'ticket_no' => 'Ticket No',
			'notes' => 'Notes',
			'date' => 'Date',
		);
	}
}