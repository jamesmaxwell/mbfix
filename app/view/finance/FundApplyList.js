/**
 * 款项申请列表
 */
Ext.define('Mbfix.view.finance.FundApplyList', {
			extend : 'Ext.window.Window',
			alias : 'widget.fundapplylist',
			title : '款项申请列表',
			modal : true,
			width : 600,
			height : 400,
			layout : 'fit',

			initComponent : function() {
				this.items = [{
							xtype : 'grid',
							border : 0,
							store : 'finance.FundRecords',
							columns : [{
										header : '申请人',
										dataIndex : 'apply_user',
										width : 60
									}, {
										header : '申请网点',
										dataIndex : 'apply_service_point',
										width : 60
									}, {
										header : '申请金额',
										dataIndex : 'apply_amount',
										width : 80
									}, {
										header : '款项用途',
										dataIndex : 'apply_reason',
										width : 100
									}, {
										header : '附加说明',
										dataIndex : 'apply_notes',
										flex : 1
									}, {
										xtype : 'datecolumn',
										header : '申请时间',
										dataIndex : 'apply_date',
										format : 'Y-m-d H:i',
										width : 120
									}, {
										header : '申请状态',
										dataIndex : 'state',
										width : 80,
										renderer : this.getApplyState
									}],
							bbar : [{
										xtype : 'pagingtoolbar',
										id : 'fundApplyListPaging',
										store : 'finance.FundRecords',
										displayInfo : true,
										flex : 1
									}]
						}];

				this.buttons = [
						/*
						 * { text : '审核拒绝', action : 'verify_deny' },
						 */
						{
					text : '取消',
					handler : function(button) {
						button.up('window').close();
					}
				}];

				this.callParent();
			},

			/**
			 * 取得申请状态
			 */
			getApplyState : function(value) {
				switch (value) {
					case 1 :
						return '等待审核';
					case 2 :
						return '审核通过';
					case 3 :
						return '审核拒绝';
					default :
						return '未知';
				}
			}
		});