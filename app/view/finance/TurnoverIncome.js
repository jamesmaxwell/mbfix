/**
* 营业款收入窗口
*/
Ext.define('Mbfix.view.finance.TurnoverIncome',{
	extend : 'Ext.window.Window',
	alias : 'widget.turnoverincome',
	title : '营业款收入',
	modal : true,
	width : 250,
	layout : 'fit',
	
	initComponent : function(){
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
				fieldLabel : '登记人',
				itemId : 'user_id',
				width : 200
			},{
				xtype : 'displayfield',
				fieldLabel : '网点',
				itemId : 'service_point_id',
				width : 200
			},{
				xtype : 'combo',
				fieldLabel : '客户类型',
				store : 'CustomTypes',
				name : 'Turnover[custom_type]',
				valueField : 'id',
				displayField : 'text',
				width : 180,
				allowBlank : false
			},{
				xtype : 'textfield',
				fieldLabel : '客户名称',
				name : 'Turnover[custom_name]',
				width : 220,
				allowBlank : false
			},{
				xtype : 'textfield',
				fieldLabel : '收款人',
				name : 'Turnover[receiver]',
				width : 200,
				allowBlank : false
			},{
				xtype : 'combo',
				fieldLabel : '收款方式',
				name : 'Turnover[pay_type]',
				width : 150,
				store : 'PayTypes',
				valueField : 'id',
				displayField : 'text',
				allowBlank : false
			},{
				xtype : 'numberfield',
				fieldLabel : '收款金额',
				name : 'Turnover[money]',
				allowBlank : false,
				minValue : 0,
				width : 150
			},{
				xtype : 'textarea',
				fieldLabel : '收款备注',
				name : 'Turnover[notes]',
				width : 220
			}]
		}];
		
		this.buttons = [{
			text : '确定收入',
			action : 'confirm_income'
		},{
			text : '取消',
			handler : function(button){
				button.up('window').close();
			}
		}];
		
		this.callParent();
	}
});