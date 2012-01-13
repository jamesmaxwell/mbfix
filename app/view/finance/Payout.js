/**
 * 费用支出窗口
 */
Ext.define('Mbfix.view.finance.Payout', {
			extend : 'Ext.window.Window',
			alias : 'widget.payout',
			title : '费用支出',
			modal : true,
			width : 250,
			layout : 'fit',

			initComponent : function() {
				this.items = [{
							xtype : 'form',
							bodyPadding : 5,
							border : 0,
							layout : 'anchor',
							fieldDefaults : {
								'labelAlign' : 'right',
								'labelWidth' : 60
							},
							items : [{
										xtype : 'displayfield',
										fieldLabel : '经手人',
										itemId : 'user_id',
										width : 200
									}, {
										xtype : 'displayfield',
										fieldLabel : '网点',
										itemId : 'service_point_id',
										width : 200
									}, {
										xtype : 'textfield',
										fieldLabel : '项目内容',
										name : 'Payout[consume_content]',
										width : 220,
										allowBlank : false
									}, {
										xtype : 'container',
										layout : 'hbox',
										items : [{
													xtype : 'numberfield',
													fieldLabel : '费用金额',
													name : 'Payout[amount]',
													itemId : 'payout_amount',
													allowBlank : false,
													minValue : 0,
													width : 120
												},{
													xtype : 'displayfield',
													fieldLabel : '可用额度',
													itemId : 'available_fund',
													width : 80
												}]
									}, {
										xtype : 'combo',
										fieldLabel : '票据类型',
										store : 'finance.TicketTypes',
										valueField : 'id',
										displayField : 'text',
										name : 'Payout[ticket_type]',
										allowBlank : false,
										width : 150
									}, {
										xtype : 'textfield',
										fieldLabel : '票据号',
										name : 'Payout[ticket_no]',
										allowBlank : false,
										width : 220
									}, {
										xtype : 'textarea',
										name : 'Payout[notes]',
										fieldLabel : '附加说明',
										width : 220
									}]
						}];

				this.buttons = [{
							text : '确认支出',
							action : 'confirm_payout'
						}, {
							text : '取消',
							handler : function(button) {
								button.up('window').close();
							}
						}];

				this.callParent();
			}
		});