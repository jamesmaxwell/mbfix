/**
 * 款项审核窗口
 */
Ext.define('Mbfix.view.finance.FundVerify', {
	extend : 'Ext.window.Window',
	alias : 'widget.fundverify',
	title : '款项审核',
	modal : true,
	width : 250,
	layout : 'fit',

	initComponent : function() {
		this.items = [ {
			xtype : 'form',
			bodyPadding : 5,
			border : 0,
			fieldDefaults : {
				'labelAlign' : 'right',
				'labelWidth' : 60
			},
			layout : 'anchor',
			items : [ {
				xtype : 'hidden',
				name : 'fund_id',
				itemId : 'fund_id'
			}, {
				xtype : 'displayfield',
				fieldLabel : '审核人',
				itemId : 'user_id',
				width : 200
			}, {
				xtype : 'displayfield',
				fieldLabel : '网点',
				itemId : 'service_point_id',
				width : 200
			}, {
				xtype : 'numberfield',
				fieldLabel : '批准金额',
				name : 'verify_amount',
				itemId : 'verify_amount',
				allowBlank : false,
				minValue : 0,
				width : 150
			}, {
				xtype : 'combo',
				fieldLabel : '出款方式',
				itemId : 'pay_type',
				store : 'finance.FundPayTypes',
				name : 'pay_type',
				valueField : 'id',
				displayField : 'text',
				editable : false,
				allowBlank : false,
				width : 120
			}, {
				xtype : 'textfield',
				fieldLabel : '出款账号',
				itemId : 'pay_account',
				name : 'pay_account',
				allowBlank : false,
				width : 220
			}, {
				xtype : 'textfield',
				fieldLabel : '收款账号',
				itemId : 'receiver_account',
				name : 'receiver_account',
				allowBlank : false,
				width : 220
			}, {
				xtype : 'textfield',
				fieldLabel : '收款人',
				itemId : 'receiver',
				name : 'receiver',
				allowBlank : false,
				width : 150
			}, {
				xtype : 'textarea',
				name : 'verify_notes',
				itemId : 'verify_notes',
				fieldLabel : '附加说明',
				width : 220
			} ]
		} ];

		this.buttons = [ {
			text : '审核通过',
			action : 'confirm_verify'
		}, {
			text : '取消',
			handler : function(button) {
				button.up('window').close();
			}
		} ];

		this.callParent();
	}
});