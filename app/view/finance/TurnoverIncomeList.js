/**
 * 营业款收入列表，用于财务核销
 */
Ext.define('Mbfix.view.finance.TurnoverIncomeList', {
			extend : 'Ext.window.Window',
			alias : 'widget.turnoverincomelist',
			title : '财务核销',
			modal : true,
			width : 850,
			layout : 'fit',

			initComponent : function() {
				this.items = [{
					xtype : 'container',
					layout : 'anchor',
					items : [{
						xtype : 'form',
						items : [{
						xtype : 'fieldset',
						title : '搜索',
						layout : 'hbox',
						margin : 4,
						defaults : {
							labelWidth : 60,
							labelAlign : 'right'
						},
						items : [{
									xtype : 'textfield',
									fieldLabel : '工单号',
									labelWidth : 50,
									name : 'finance_recordNo',
									itemId : 'finance_recordNo',
									width : 190
								}, {
									xtype : 'combo',
									fieldLabel : '网点',
									name : 'finance_service_point',
									labelWidth : 40,
									itemId : 'finance_service_point',
									store : 'ServicePoints',
									valueField : 'id',
									displayField : 'name',
									width : 100
								}, {
									xtype : 'datefield',
									labelWidth : 75,
									fieldLabel : '核销起始日',
									itemId : 'search_beginDate',
									format : 'Y-m-d',
									width : 160
								}, {
									xtype : 'datefield',
									labelWidth : 75,
									fieldLabel : '核销结束日',
									itemId : 'search_endDate',
									format : 'Y-m-d',
									width : 160
								}, {
									xtype : 'combo',
									itemId : 'finance_filter',
									fieldLabel : '状态',
									labelWidth : 40,
									queryMode : 'local',
									store : new Ext.data.ArrayStore({
												fields : ['id', 'text'],
												data : [[0, '全部'], [1, '应收款'],
														[2, '应付款'],
														[3, '其它营业款']]
											}),
									valueField : 'id',
									displayField : 'text',
									width : 110
								}, {
									xtype : 'button',
									text : '查询',
									flex : 1,
									margin : '0 0 0 5',
									itemId : 'search_button'
								}]
						}]
					}, {
						xtype : 'grid',
						border : 1,
						height : 330,
						store : 'finance.TurnoverIncomes',
						columns : [{
									header : '核销人',
									dataIndex : 'finance_user',
									width : 80
								}, {
									header : '核销状态',
									dataIndex : 'finance_state',
									width : 80,
									renderer : this.getFinanceState
								}, {
									header : '核销异常',
									dataIndex : 'finance_exception',
									width : 120
								}, {
									xtype : 'datecolumn',
									header : '核销时间',
									dataIndex : 'finance_date',
									width : 120,
									format : 'Y-m-d H:i'
								}, {
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
									width : 80
									,
								}, {
									header : '收款人',
									dataIndex : 'receiver',
									width : 80
								}, {
									header : '收款方式',
									dataIndex : 'pay_type',
									width : 80
								}, {
									header : '收款金额',
									dataIndex : 'money',
									width : 80
								}, {
									header : '单笔利润',
									dataIndex : 'profit',
									width : 80
								}, {
									header : '备注',
									dataIndex : 'notes',
									width : 120
								}, {
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
								}],
						bbar : [{
									xtype : 'pagingtoolbar',
									id : 'turnoverIncomeListPaging',
									store : 'finance.TurnoverIncomes',
									displayInfo : true,
									flex : 1
								}]
					}]
				}];

				this.buttons = [{
							text : '核销确认',
							action : 'finance_confirm'
						}, {
							text : '核销异常',
							action : 'finance_exception'
						}, {
							text : '取消',
							handler : function(button) {
								button.up('window').close();
							}
						}];

				this.callParent();
			},

			/**
			 * 取得票据类型,1＝已收款，2＝未收款
			 */
			getPayState : function(value) {
				switch (value) {
					case 1 :
						return '已收款';
					case 2 :
						return '未收款';
					default :
						return '未知';
				}
			},

			/*
			 * 核销状态 1＝已核销，2=核销异常
			 */
			getFinanceState : function(value) {
				switch (value) {
					case 0 :
						return "待核销";
					case 1 :
						return "<span style='color:#fa0'>已核销</span>";
					case 2 :
						return "<span style='color:red'>已核销(异)</span>";
					default :
						return "未知";
				}
			}
		});