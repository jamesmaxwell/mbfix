/**
 * 备件采购窗口
 */
Ext.define('Mbfix.view.component.ComponentPurchase', {
			extend : 'Ext.window.Window',
			alias : 'widget.componentpurchase',
			title : '备件采购',
			width : 300,
			modal : true,
			layout : 'fit',

			initComponent : function() {
				this.items = [{
							xtype : 'form',
							bodyPadding : 5,
							border : 0,
							layout : 'anchor',
							fieldDefaults : {
								labelAlign : 'right',
								labelWidth : 60
							},
							items : [{
										xtype : 'displayfield',
										fieldLabel : '采购人',
										itemId : 'buyer',
										width : 150
									}, {
										xtype : 'displayfield',
										fieldLabel : '网点',
										itemId : 'service_point',
										width : 150
									}, {
										xtype : 'numberfield',
										fieldLabel : '申请数量',
										itemId : 'apply_amount',
										width : 150,
										disabled :true
									},{
										xtype : 'hidden',
										name : 'Purchase[apply_id]',
										itemId : 'apply_id'
									}, {
										xtype : 'textfield',
										fieldLabel : '供货单位',
										name : 'Purchase[supply_company]',
										allowBlank : false,
										width : 260
									}, {
										xtype : 'textfield',
										fieldLabel : '供货地址',
										name : 'Purchase[supply_address]',
										allowBlank : false,
										width : 260
									}, {
										xtype : 'container',
										layout : 'hbox',
										items : [{
													xtype : 'numberfield',
													fieldLabel : '采购数量',
													name : 'Purchase[amount]',
													width : 130,
													allowBlank : false
												}, {
													xtype : 'textfield',
													fieldLabel : '单位',
													name : 'Purchase[unit]',
													width : 100,
													labelWidth : 50,
													allowBlank : false
												}]
									}, {
										xtype : 'container',
										layout : 'hbox',
										items : [{
													xtype : 'numberfield',
													fieldLabel : '采购单价',
													name : 'Purchase[price]',
													width : 130,
													allowBlank : false
												}, {
													xtype : 'displayfield',
													fieldLabel : '合计',
													labelWidth : 50,
													width : 100
												}]
									}, {
										xtype : 'combo',
										fieldLabel : '付款情况',
										name : 'Purchase[pay_state]',
										store : new Ext.data.ArrayStore({
													fields : ['id', 'text'],
													data : [[1, '已付款'],
															[2, '未付款']]
												}),
										value : 1,
										valueField : 'id',
										displayField : 'text',
										allowBlank : false,
										width : 150
									}, {
										xtype : 'combo',
										fieldLabel : '付款方式',
										name : 'Purchase[pay_type]',
										allowBlank : false,
										store : 'PayTypes',
										valueField : 'id',
										displayField : 'text',
										width : 150
									}, {
										xtype : 'textfield',
										fieldLabel : '付款账户',
										name : 'Purchase[pay_account]',
										value : '无',
										allowBlank : false,
										width : 260
									},{
										xtype : 'textarea',
										fieldLabel : '备注',
										name : 'Purchase[notes]',
										width : 260
									}]
						}];

				this.buttons = [{
							text : '采购确认',
							action : 'purchase'
						}, {
							text : '取消',
							action : 'close',
							handler : function(button) {
								button.up('window').close();
							}
						}];

				this.callParent();
			}
		});