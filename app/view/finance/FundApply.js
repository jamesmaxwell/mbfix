/**
* 款项申请窗口
*/
Ext.define('Mbfix.view.finance.FundApply',{
	extend : 'Ext.window.Window',
	alias : 'widget.fundapply',
	title : '款项申请',
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
				fieldLabel : '申请人',
				itemId : 'user_id',
				width : 200
			},{
				xtype : 'displayfield',
				fieldLabel : '网点',
				itemId : 'service_point_id',
				width : 200
			},{
				xtype : 'numberfield',
				fieldLabel : '申请金额',
				name : 'Apply[apply_amount]',
				allowBlank : false,
				minValue : 0,
				width : 150
			},{
				xtype : 'textfield',
				fieldLabel : '款项用途',
				name : 'Apply[apply_reason]',
				allowBlank : false,
				width : 200
			},{
				xtype : 'textarea',
				name : 'Apply[apply_notes]',
				fieldLabel : '附加说明'
			}]
		}];
		
		this.buttons = [{
			text : '确认申请',
			action : 'confirm_apply'
		},{
			text : '取消',
			handler : function(button){
				button.up('window').close();
			}
		}];
		
		this.callParent();
	}
});