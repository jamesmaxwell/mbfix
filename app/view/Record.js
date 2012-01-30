Ext.define('Mbfix.view.Record', {
	extend : 'Ext.window.Window',
	alias : 'widget.record',
	title : '接修登案',
	modal : true,
	closeAction : 'hide',
	width : 650,
	itemId : 'record',

	initComponent : function() {
		this.items = [{
			xtype : 'form',
			bodyPadding : 5,
			fieldDefaults : {
				'labelAlign' : 'right',
				'labelWidth' : 60
			},
			layout : 'anchor',
			items : [{
						xtype : 'container',
						padding : 10,
						layout : 'hbox',
						items : [{
									xtype : 'displayfield',
									fieldLabel : '工程师',
									itemId : 'currentUser',									
									width : 140
								}, {
									xtype : 'displayfield',
									fieldLabel : '区域',
									itemId : 'currentServicePoint',									
									width: 180
								}, {
									xtype : 'textfield',
									fieldLabel : '工单号',
									name : 'Record[record_no]',
									itemId : 'recordNo',
									allowBlank : false,
									width : 280
								}]
					}, {
						xtype : 'fieldset',
						title : '客户信息',
						layout : 'anchor',
						items : [{
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'textfield',
												fieldLabel : '客户姓名',
												name : 'Record[custom_name]',
												allowBlank : false,
												width : 160
											}, {
												xtype : 'combo',
												fieldLabel : '客户类型',
												name : 'Record[custom_type]',
												store : 'CustomTypes',
												editable : false,
												allowBlank : false,
												valueField : 'id',
												displayField : 'text',
												width : 150
											}, {
												xtype : 'combo',
												fieldLabel : '客户性别',
												width : 120,
												name : 'Record[custom_sex]',
												queryMode : 'local',
												editable : false,
												value : 1,
												store : new Ext.data.ArrayStore(
														{
															fields : ['id',
																	'text'],
															data : [[1, '男'],
																	[2, '女']]
														}),
												valueField : 'id',
												displayField : 'text'
											}, {
												xtype : 'textfield',
												fieldLabel : '手机号码',
												name : 'Record[custom_mobile]',
												itemId : 'custom_mobile',
												flex : 1
											}]
								}, {
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'textfield',
												fieldLabel : '固定电话',
												name : 'Record[custom_phone]',
												itemId : 'custom_phone',
												width : 160
											}, {
												xtype : 'textfield',
												fieldLabel : '单位名称',
												name : 'Record[custom_company]',
												flex : 1
											}]
								}, {
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'textfield',
												fieldLabel : '联系地址',
												name : 'Record[custom_address]',
												flex : 1
											}]
								}, {
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'textfield',
												fieldLabel : '邮编',
												name : 'Record[custom_postcode]',
												width : 160
											}, {
												xtype : 'textfield',
												fieldLabel : 'E-Mail',
												name : 'Record[custom_email]',
												vtype : 'email',
												width : 260
											}]
								}]
					}, {
						xtype : 'fieldset',
						title : '产品及故障信息',
						layout : 'anchor',
						items : [{
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'combo',
												fieldLabel : '服务类型',
												name : 'Record[service_type]',
												store : 'ServiceTypes',
												valueField : 'id',
												displayField : 'text',
												editable : false,
												allowBlank : false,
												width : 160
											}, {
												xtype : 'combo',
												fieldLabel : '机器品牌',
												name : 'Record[machine_brand]',
												store : 'MachineBrands',
												editable : false,
												allowBlank : false,
												valueField : 'id',
												displayField : 'text',
												width : 160
											}, {
												xtype : 'combo',
												fieldLabel : '机器类别',
												name : 'Record[machine_type]',
												store : 'MachineTypes',
												valueField : 'id',
												displayField : 'text',
												editable : false,
												allowBlank : false,
												width : 140
											}, {
												xtype : 'textfield',
												fieldLabel : '机器型号',
												name : 'Record[machine_model]',
												allowBlank : false,
												flex : 1
											}]
								}, {
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'textfield',
												fieldLabel : '序列号',
												name : 'Record[serial_number]',
												itemId : 'serialNumber',
												width : 200
											}, {
												xtype : 'button',
												text : '检查',
												action : 'serialCheck',
												margin : '0 0 0 5'
											}, {
												xtype : 'displayfield',
												itemId : 'serialCheck_result',
												margin : '0 0 0 5',
												flex : 1
											}]
								}, {
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'textfield',
												fieldLabel : 'SNID',
												name : 'Record[machine_snid]',
												itemId : 'machine_snid',
												width : 160
											}, {
												xtype : 'combo',
												fieldLabel : '质保类型',
												name : 'Record[warranty_type]',
												store : 'WarrantyTypes',
												editable : false,
												valueField : 'id',
												displayField : 'text',
												allowBlank : false,
												width : 160
											}, {
												xtype : 'combo',
												fieldLabel : '硬盘资料',
												name : 'Record[disk_state]',
												store : new Ext.data.ArrayStore(
														{
															fields : ['id',
																	'text'],
															data : [
																	[1, '已备份'],
																	[2, '已取走'],
																	[3,
																			'数据不能清除']]
														}),
												valueField : 'id',
												displayField : 'text',
												editable : false,
												allowBlank : false,
												width : 160
											}]
								}, {
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'textfield',
												fieldLabel : '机器外观',
												name : 'Record[machine_look]',
												allowBlank : false,
												flex : 1
											}, {
												xtype : 'textfield',
												fieldLabel : '随机附件',
												name : 'Record[machine_attachment]',
												allowBlank : false,
												flex : 1
											}]
								}, {
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'textarea',
												fieldLabel : '故障描述',
												name : 'Record[error_desc]',
												allowBlank : false,
												flex : 1
											}]
								}, {
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'textarea',
												fieldLabel : '其他备注',
												name : 'Record[other_note]',
												flex : 1
											}]
								}]
					}]
		}];

		this.buttons = [{
					text : '确定',
					type : 'submit',
					action : 'comfirm'
				}, {
					text : '取消',
					action : 'cancel'
				}];

		this.callParent(arguments);
	}
});