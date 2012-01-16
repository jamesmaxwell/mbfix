/**
 * 营业款收入列表，用于财务核销
 */
Ext.define('Mbfix.view.finance.TurnoverIncomeList', {
	extend : 'Ext.window.Window',
	alias : 'widget.turnoverincomelist',
	title : '财务核销',
	modal : true,
	width : 600,
	height : 400,
	layout : 'fit',

	initComponent : function() {
		this.items = [ {
			xtype : 'grid',
			border : 0,
			store : 'finance.TurnoverIncomes',
			columns : [ {
				header : '经手人',
				dataIndex : 'user',
				width : 60
			}, {
				header : '网点',
				dataIndex : 'service_point',
				width : 60
			}, {
				header : '工单号',
				dataIndex : 'record_no',
				width : 120
			}, {
				header : '客户类型',
				dataIndex : 'custom_type',
				width : 80
			}, {
				header : '客户名称',
				dataIndex : 'custom_name',
				width : 80,
			},{
				header : '收款人',
				dataIndex : 'receiver',
				width : 80
			},{
				header : '收款方式',
				dataIndex : 'pay_type',
				width : 80
			},{
				header : '收款金额',
				dataIndex : 'money',
				width : 80
			},{
				header : '单笔利润',
				dataIndex : 'profit',
				width : 80
			},{
				header : '备注',
				dataIndex : 'notes',
				width : 80
			},{
				xtype : 'datecolumn',
				header : '产生时间',
				dataIndex : 'date',
				format : 'Y-m-d H:i',
				width : 120
			}, {
				header : '收款状态',
				dataIndex : 'pay_state',
				width : 80,
				renderer : this.getPayState
			},{
				header : '核销状态',
				dataIndex : 'finance_state',
				width : 80,
				renderer : this.getFinanceState
			},{
				header : '核销异常',
				dataIndex : 'finance_exception',
				width : 100
			}],
			bbar : [ {
				xtype : 'pagingtoolbar',
				id : 'payoutListPaging',
				store : 'finance.TurnoverIncomes',
				displayInfo : true,
				flex : 1
			} ]
		} ];

		this.buttons = [ {
			text : '核销确认',
			action : 'finance_confirm'
		},{
			text : '取消',
			handler : function(button) {
				button.up('window').close();
			}
		} ];

		this.callParent();
	},

	/**
	 * 取得票据类型,1＝已收款，2＝未收款
	 */
	getPayState : function(value) {
		switch (value) {
		case 1:
			return '已收款';
		case 2:
			return '未收款';
		default:
			return '未知';
		}
	},
	
	/*
	* 核销状态 1＝已核销，2=核销异常
	*/
	getFinanceState : function(value){
		switch(value){
		case 1:
			return "已核销";
		case 2:
			return "已核销(异)";
		default:
			return "未知";
		}
	}
});