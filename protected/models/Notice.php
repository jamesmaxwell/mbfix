<?php

/**
 * 公告模型类
 * This is the model class for table "{{notice}}".
 *
 * The followings are the available columns in table '{{notice}}':
 * @property integer $id
 * @property string $title
 * @property string $author
 * @property string $content
 * @property integer $date
 */
class Notice extends CActiveRecord
{
	/**
	 * Returns the static model of the specified AR class.
	 * @param string $className active record class name.
	 * @return Notice the static model class
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
		return '{{notice}}';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('title, author, content, date', 'required'),
			array('date', 'numerical', 'integerOnly'=>true),
			array('title', 'length', 'max'=>200),
			array('author', 'length', 'max'=>50),
			array('content', 'length', 'max'=>1000),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, title, author, content, date', 'safe', 'on'=>'search'),
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
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'title' => 'Title',
			'author' => 'Author',
			'content' => 'Content',
			'date' => 'Date',
		);
	}
}