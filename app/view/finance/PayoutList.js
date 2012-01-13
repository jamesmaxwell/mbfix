/**
 * 费用支出明细
 */
Ext.define('Mbfix.view.finance.PayoutList', {
	extend : 'Ext.window.Window',
	alias : 'widget.payoutlist',
	title : '费用支出列表',
	modal : true,
	width : 600,
	height : 400,
	layout : 'fit',

	initComponent : function() {
		this.items = [ {
			xtype : 'grid',
			border : 0,
			store : 'finance.Payouts',
			columns : [ {
				header : '经手人',
				dataIndex : 'handler_user',
				width : 60
			}, {
				header : '网点',
				dataIndex : 'service_point',
				width : 60
			}, {
				header : '项目内容',
				dataIndex : 'consume_content',
				width : 120
			}, {
				header : '费用金额',
				dataIndex : 'amount',
				width : 80
			}, {
				header : '票据类型',
				dataIndex : 'ticket_type',
				width : 80,
				renderer : this.getTicketType
			},{
				header : '票据号',
				dataIndex : 'ticket_no',
				width : 120
			}, {
				xtype : 'datecolumn',
				header : '产生时间',
				dataIndex : 'date',
				format : 'Y-m-d H:i',
				width : 120
			}, {
				header : '附加说明',
				dataIndex : 'notes',
				width : 200
			} ],
			bbar : [ {
				xtype : 'pagingtoolbar',
				id : 'payoutListPaging',
				store : 'finance.Payouts',
				displayInfo : true,
				flex : 1
			} ]
		} ];

		this.buttons = [ {
			text : '取消',
			handler : function(button) {
				button.up('window').close();
			}
		} ];

		this.callParent();
	},

	/**
	 * 取得票据类型,1=物流单,2=收据,3=发票
	 */
	getTicketType : function(value) {
		switch (value) {
		case 1:
			return '物流单';
		case 2:
			return '收据';
		case 3:
			return '发票';
		default:
			return '未知';
		}
	}
});