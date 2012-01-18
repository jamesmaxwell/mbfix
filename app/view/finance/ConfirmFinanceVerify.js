Ext.define('Mbfix.view.finance.ConfirmFinanceVerify',{
	extend : 'Ext.window.Window',
	alias : 'widget.confirmfinanceverify',
	title : '核销操作',
	width : 260,
	layout : 'fit',
	
	initComponent : function(){
		this.items = [{
			xtype : 'form',
			bodyPadding : 5,
			fieldDefaults : {
				labelWidth : 65,
				labelAlign : 'right'
			},
			items : [{
				xtype : 'radiogroup',
				fieldLabel : '核销操作',
				itemId : 'finance_state',
				name : 'finance_state',
				items : [
				  {boxLabel : '确认', name : 'verify', inputValue : 1},
				  {boxLabel : '异常', name : 'verify', inputValue : 2}
				]
			},{
				xtype : 'textarea',
				fieldLabel : '异常说明',
				allowBlank : false,
				itemId : 'finance_exception',
				name : 'finance_exception'
			},{
				xtype : 'hidden',
				name : 'finance_id',
				itemId : 'finance_id'
			}]
		}];
		
		this.buttons = [{
			text : '确定',
			action : 'submit'
		},{
			text : '取消',
			handler : function(button){
				button.up('window').close();
			}
		}];
		
		this.callParent();
	}
});