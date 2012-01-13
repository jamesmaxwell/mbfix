<?php

/**
 * This is the model class for table "{{service_record}}".
 * 服务单模型
 * The followings are the available columns in table '{{service_record}}':
 * @property string $id
 * @property integer $user_id	用户编号
 * @property integer $service_point_id	网点编号
 * @property string $record_no	服务单号
 * @property string $custom_name	客户姓名
 * @property integer $custom_type	客户类型编号
 * @property integer $custom_sex	客户性别
 * @property string $custom_mobile	客户手机
 * @property string $custom_phone	客户固话
 * @property string $custom_company	客户单位
 * @property string $custom_address	客户地址
 * @property string $custom_postcode	客户邮编
 * @property string $custom_email	客户email
 * @property integer $service_type	服务类型
 * @property integer $machine_brand	机器品牌
 * @property integer $machine_type	机器类型
 * @property string $machine_model	机器型号
 * @property string $machine_snid	机器SNID编号
 * @property string $serial_number	机器序列号
 * @property integer $warranty_type	质保类型
 * @property string $disk_state		硬盘状态
 * @property string $machine_look	机器外观
 * @property string $machine_attachment	机器附件
 * @property string $error_desc		故障描述
 * @property string $other_note		其它备注
 * @property integer $record_state	服务单状态
 * @property integer $create_time	服务单录入时间
 *
 * The followings are the available model relations:
 * @property CustomType $customType
 * @property MachineBrand $machineBrand
 * @property MachineType $machineType
 * @property ServicePoint $servicePoint
 * @property ServiceType $serviceType
 * @property User $user
 * @property WarrantyType $warrantyType
 */
class ServiceRecord extends CActiveRecord
{
	//1=处理中,2=转修中,3=报价中,4=客户不修,5-待料,6=到料处理中,7=无法修复,8=已修复,9=已结案
	//服务单状态常量
	const STATUS_INPROCESS = 1;	//处理中
	const TRANSFER = 2;			//转修中
	const PRICEING = 3;			//报价中
	const CUSTOM_REFUSE = 4;	//客户不修
	const WAIT_COMPONENT = 5;	//待料
	const RECEIVE_COMPONENT = 6;//到料处理中
	const CANNOT_FIX = 7;		//无法修复
	const FIXED = 8;			//已修复
	const FINISHED = 9;			//已结案
	
	/**
	 * 返回中文服务单状态
	 * @param integer $record_state 状态
	 */
	public static function getRecordState($record_state)
	{
		switch ($status){
			case ServiceRecord::STATUS_INPROCESS:
				return '处理中';
			default:
				return  '未知';
		}
	}
	
	/**
	 * Returns the static model of the specified AR class.
	 * @return ServiceRecord the static model class
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
		return '{{service_record}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('user_id, service_point_id, record_no, custom_name, custom_type, custom_sex, custom_mobile, service_type, machine_brand, machine_type, machine_model, serial_number, warranty_type, disk_state, record_state', 'required'),
			array('user_id, service_point_id, custom_type, custom_sex, service_type, machine_brand, machine_type, warranty_type, record_state', 'numerical', 'integerOnly'=>true),
			array('record_no', 'length', 'max'=>50),
			array('disk_state', 'length', 'max'=>15),
			array('custom_name, custom_company, custom_email, machine_model, machine_snid, serial_number, machine_look', 'length', 'max'=>45),
			array('custom_mobile, custom_phone', 'length', 'max'=>20),
			array('custom_address, machine_attachment, error_desc, other_note', 'length', 'max'=>100),
			array('custom_postcode', 'length', 'max'=>10),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, user_id, service_point_id, record_no, custom_name, custom_type, custom_sex, custom_mobile, custom_phone, custom_company, custom_address, custom_postcode, custom_email, service_type, machine_brand, machine_type, machine_model, machine_snid, serial_number, warranty_type, disk_state, machine_look, machine_attachment, error_desc, other_note, record_state', 'safe', 'on'=>'search'),
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
			'customType' => array(self::BELONGS_TO, 'CustomType', 'custom_type'),
			'machineBrand' => array(self::BELONGS_TO, 'MachineBrand', 'machine_brand'),
			'machineType' => array(self::BELONGS_TO, 'MachineType', 'machine_type'),
			'servicePoint' => array(self::BELONGS_TO, 'ServicePoint', 'service_point_id'),
			'serviceType' => array(self::BELONGS_TO, 'ServiceType', 'service_type'),
			'user' => array(self::BELONGS_TO, 'User', 'user_id'),
			'warrantyType' => array(self::BELONGS_TO, 'WarrantyType', 'warranty_type'),
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
			'custom_name' => 'Custom Name',
			'custom_type' => 'Custom Type',
			'custom_sex' => 'Custom Sex',
			'custom_mobile' => 'Custom Mobile',
			'custom_phone' => 'Custom Phone',
			'custom_company' => 'Custom Company',
			'custom_address' => 'Custom Address',
			'custom_postcode' => 'Custom Postcode',
			'custom_email' => 'Custom Email',
			'service_type' => 'Service Type',
			'machine_brand' => 'Machine Brand',
			'machine_type' => 'Machine Type',
			'machine_model' => 'Machine Model',
			'machine_snid' => 'Machine SNID',
			'serial_number' => 'Serial Number',
			'warranty_type' => 'Warranty Type',
			'disk_state' => 'Disk State',
			'machine_look' => 'Machine Look',
			'machine_attachment' => 'Machine Attachment',
			'error_desc' => 'Error Desc',
			'other_note' => 'Other Note',
			'record_state' => 'Record State',
			'create_time' => 'Create Time',
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

		$criteria->compare('id',$this->id,true);
		$criteria->compare('user_id',$this->user_id);
		$criteria->compare('service_point_id',$this->service_point_id);
		$criteria->compare('record_no',$this->record_no,true);
		$criteria->compare('custom_name',$this->custom_name,true);
		$criteria->compare('custom_type',$this->custom_type);
		$criteria->compare('custom_sex',$this->custom_sex);
		$criteria->compare('custom_mobile',$this->custom_mobile,true);
		$criteria->compare('custom_phone',$this->custom_phone,true);
		$criteria->compare('custom_company',$this->custom_company,true);
		$criteria->compare('custom_address',$this->custom_address,true);
		$criteria->compare('custom_postcode',$this->custom_postcode,true);
		$criteria->compare('custom_email',$this->custom_email,true);
		$criteria->compare('service_type',$this->service_type);
		$criteria->compare('machine_brand',$this->machine_brand);
		$criteria->compare('machine_type',$this->machine_type);
		$criteria->compare('machine_snid',$this->machine_snid);
		$criteria->compare('machine_model',$this->machine_model,true);
		$criteria->compare('serial_number',$this->serial_number,true);
		$criteria->compare('warranty_type',$this->warranty_type);
		$criteria->compare('disk_state',$this->disk_state,true);
		$criteria->compare('machine_look',$this->machine_look,true);
		$criteria->compare('machine_attachment',$this->machine_attachment,true);
		$criteria->compare('error_desc',$this->error_desc,true);
		$criteria->compare('other_note',$this->other_note,true);
		$criteria->compare('record_state',$this->record_state);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}
}