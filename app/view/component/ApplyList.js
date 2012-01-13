/**
 * 显示用户备件申请列表窗口
 */
Ext.define('Mbfix.view.component.ApplyList', {
			extend : 'Ext.window.Window',
			alias : 'widget.applylist',
			title : '备件申请列表',
			width : 600,
			height : 400,
			modal : true,
			layout : 'fit',

			initComponent : function() {
				this.items = [{
							xtype : 'grid',
							store : 'ComponentApplys',
							border : 0,
							autoScroll : true,
							columns : [{
										header : '备件名称',
										dataIndex : 'component_name',
										width : 150
									}, {
										header : '申请数量',
										dataIndex : 'amount',
										width : 80
									}, {
										header : '备注',
										dataIndex : 'notes',
										flex : 1
									}, {
										header : '状态',
										dataIndex : 'state',
										width : 100,
										renderer : this.getApplyState
									}],
							bbar : [{
										xtype : 'pagingtoolbar',
										store : 'ComponentApplys',
										id : 'componentApplyPager',
										displayInfo : true,
										flex : 1
									}]
						}];

				this.buttons = [{
							text : '采购确认',
							action : 'purchase'
						}, {
							text : '取消',
							handler : function(button) {
								button.up('window').close();
							}
						}];

				this.callParent();
			},

			/**
			 * 读取备件申请状态
			 */
			getApplyState : function(value, metaData, record) {
				switch (value) {
					case 0 :
						return '申请中';
					case 1 :
						return '已到料';
					case 2 :
						return '已采购';
					case 3 :
						return '已领料';
					default :
						return '未知';
				}
			}
		});