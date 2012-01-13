/**
 * 备件入库窗口
 */
Ext.define('Mbfix.view.component.ComponentAccept', {
			extend : 'Ext.window.Window',
			alias : 'widget.componentaccept',
			title : '备件入库',
			width : 230,
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
										xtype : 'hidden',
										itemId : 'purchase_id',
										name : 'Accept[purchase_id]'
									},{
										xtype : 'displayfield',
										fieldLabel : '经手人',
										itemId : 'user',
										width : 150
									}, {
										xtype : 'displayfield',
										fieldLabel : '网点',
										itemId : 'service_point',
										width : 150
									}, {
										xtype : 'textfield',
										fieldLabel : '收货仓库',
										itemId : 'store_house',
										name : 'Accept[store_house]',
										allowBlank : false,
										width : 150
									}, {
										xtype : 'displayfield',
										fieldLabel : '采购数量',
										itemId : 'purchase_amount',
										allowBlank : false,
										width : 150
									}, {
										xtype : 'numberfield',
										fieldLabel : '入库数量',
										itemId : 'real_amount',
										name : 'Accept[amount]',
										allowBlank : false,
										width : 150
									}, {
										xtype : 'textarea',
										fieldLabel : '附加说明',
										name : 'Accept[notes]',
										width : 200
									}]
						}];

				this.buttons = [{
							text : '确认入库',
							action : 'accept'
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