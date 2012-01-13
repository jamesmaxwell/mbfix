/**
 * 备件出库窗口
 */
Ext.define('Mbfix.view.component.ComponentStockout', {
			extend : 'Ext.window.Window',
			alias : 'widget.componentstockout',
			title : '备件出库',
			modal : true,
			width : 300,
			layout : 'fit',

			initComponent : function() {
				this.items = [{
							xtype : 'form',
							bodyPadding : 5,
							border : 0,
							layout : 'anchor',
							fieldDefaults : {
								labelWidth : 60,
								labelAlign : 'right'
							},
							items : [{
										xtype : 'hidden',
										itemId : 'component_id',
										name : 'Stockout[component_id]'
									}, {
										xtype : 'displayfield',
										fieldLabel : '经手人',
										itemId : 'user'
									}, {
										xtype : 'displayfield',
										fieldLabel : '网点',
										itemId : 'service_point'
									}, {
										xtype : 'textfield',
										fieldLabel : '购买单位',
										name : 'Stockout[buyer_company]',
										width : 270,
										allowBlank : false
									}, {
										xtype : 'combo',
										fieldLabel : '出库类型',
										itemId : 'sell_for',
										queryMode : 'local',
										store : 'component.ComponentStockSellfors',
										value : 2,
										valueField : 'id',
										displayField : 'text',
										width : 160,
										name : 'Stockout[sell_for]',
										allowBlank : false
									}, {
										xtype : 'combo',
										fieldLabel : '出库方式',
										queryMode : 'local',
										store : 'component.ComponentStockSellTypes',
										value : 1,
										valueField : 'id',
										displayField : 'text',
										width : 160,
										name : 'Stockout[sell_type]',
										allowBlank : false
									}, {
										xtype : 'textfield',
										fieldLabel : '工单号',
										name : 'Stockout[record_no]',
										itemId : 'record_no',
										width : 230,
										allowBlank : false
									}, {
										xtype : 'textfield',
										fieldLabel : '发货仓库',
										name : 'Stockout[store_house]',
										width : 180,
										allowBlank : false
									}, {
										xtype : 'container',
										layout : 'hbox',
										items : [{
													xtype : 'numberfield',
													fieldLabel : '出库数量',
													itemId : 'stockout_amount',
													name : 'Stockout[amount]',
													minValue : 1,
													value : 1,
													width : 180,
													allowBlank : false
												}, {
													xtype : 'textfield',
													fieldLabel : '单位',
													labelWidth : 40,
													name : 'Stockout[unit]',
													width : 80,
													allowBlank : false
												}]
									}, {
										xtype : 'numberfield',
										fieldLabel : '出库单价',
										itemId : 'stockout_price',
										name : 'Stockout[price]',
										width : 180,
										minValue : 0,
										allowBlank : false
									}, {
										xtype : 'container',
										layout : 'hbox',
										items : [{
													xtype : 'numberfield',
													fieldLabel : '优惠金额',
													itemId : 'stockout_discount',
													name : 'Stockout[discount]',
													minValue : 0,
													width : 180,
													value : 0,
													allowBlank : false
												}, {
													xtype : 'displayfield',
													fieldLabel : '总价',
													labelWidth : 40,
													itemId : 'stockout_allprice',
													width : 150
												}]
									}, {
										xtype : 'combo',
										fieldLabel : '收款情况',
										itemId : 'receipt_type',
										store : 'component.ComponentReceiptTypes',
										queryMode : 'local',
										valueField : 'id',
										displayField : 'text',
										value : 2,
										name : 'Stockout[receipt_type]',
										allowBlank : false,
										width : 180
									}, {
										xtype : 'combo',
										fieldLabel : '收款方式',
										itemId : 'pay_type',
										store : 'PayTypes',
										name : 'Stockout[pay_type]',
										valueField : 'id',
										displayField : 'text',
										allowBlank : false,
										width : 180
									}, {
										xtype : 'textfield',
										fieldLabel : '收款人',
										itemId : 'receiver',
										name : 'Stockout[receiver]',
										allowBlank : false,
										width : 180
									}, {
										xtype : 'textfield',
										fieldLabel : '收款账号',
										itemId : 'receipt_account',
										name : 'Stockout[receipt_account]',
										value : '无',
										allowBlank : false,
										width : 270
									}, {
										xtype : 'textarea',
										fieldLabel : '附加说明',
										name : 'Stockout[notes]',
										width : 270
									}]
						}];

				this.buttons = [{
							text : '确认出库',
							action : 'confirm_stockout'
						}, {
							text : '取消',
							handler : function(button) {
								button.up('window').close();
							}
						}];

				this.callParent();
			}
		});