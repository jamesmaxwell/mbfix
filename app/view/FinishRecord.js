/**
 * 客户取机窗口
 */
Ext.define('Mbfix.view.FinishRecord', {
			extend : 'Ext.window.Window',
			alias : 'widget.finishrecord',
			title : '客户取机',
			width : 450,
			modal : true,

			initComponent : function() {
				this.items = [{
					xtype : 'form',
					layout : 'anchor',
					border : 0,
					bodyPadding : 5,
					fieldDefaults : {
						'labelAlign' : 'right',
						'labelWidth' : 60
					},
					items : [{
						xtype : 'container',
						layout : 'hbox',
						items : [{
									xtype : 'combo',
									fieldLabel : '取机类型',
									name : 'fetch_type',
									itemId : 'fetch_type',
									store : new Ext.data.ArrayStore({
												fields : ['id', 'text'],
												data : [[1, '现场取机'],
														[2, '物流发货']]
											}),
									valueField : 'id',
									displayField : 'text',
									value : 1,
									width : 160
								}]
					}, {
						xtype : 'fieldset',
						title : '物流信息',
						layout : 'anchor',
						itemId : 'logistics_fieldset',
						disabled : true,
						items : [{
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'combo',
												fieldLabel : '物流单位',
												name : 'logistics_name',
												store : 'LogisticsTypes',
												valueField : 'id',
												displayField : 'text',
												allowBlank : false,
												width : 140
											}, {
												xtype : 'textfield',
												fieldLabel : '物流单号',
												name : 'logistics_no',
												allowBlank : false,
												flex : 1
											}]
								}]
					}, {
						xtype : 'fieldset',
						title : '收款信息',
						layout : 'anchor',
						items : [{
							xtype : 'container',
							layout : 'hbox',
							items : [{
										xtype : 'combo',
										fieldLabel : '收款情况',
										name : 'pay_state',
										store : new Ext.data.ArrayStore({
													fields : ['id', 'text'],
													data : [[1, '已收款'],
															[2, '未收款']]
												}),
										valueField : 'id',
										displayField : 'text',
										value : 1,
										width : 140
									}, {
										xtype : 'combo',
										fieldLabel : '收款方式',
										name : 'pay_type',
										store : 'PayTypes',
										valueField : 'id',
										displayField : 'text',
										width : 140,
										allowBlank : false
									}, {
										xtype : 'numberfield',
										fieldLabel : '收款金额',
										name : 'pay_money',
										allowBlank : false,
										value : 0,
										flex : 1
									}]
						}]
					}]
				}];

				this.buttons = [{
							text : '结案',
							action : 'finish'
						}];

				this.callParent();
			}
		});