Ext.define('Mbfix.view.Home', {
	extend : 'Ext.container.Container',
	alias : 'widget.home',

	initComponent : function() {
		this.items = [ {
			xtype : 'container',
			frame : false,
			layout : 'hbox',
			items : [ {
				xtype : 'component',
				flex : 1
			}, {
				xtype : 'panel',
				frame : false,
				border : 0,
				width : 900,
				dockedItems : [ {
					xtype : 'container',
					dock : 'top',
					layout : 'anchor',
					items : [ {
						xtype : 'toolbar',
						id : 'menuToolbar',
						frame : false,
						items : []
					}, {
						xtype : 'container',
						layout : 'hbox',
						padding : '1',
						style : {
							backgroundColor : '#D3E1F1'
						},
						items : [ {
							xtype : 'button',
							text : '接修登案',
							scale : 'large',
							iconCls : 'ico_record',
							action : 'record'
						}, {
							xtype : 'tbspacer'
						}, {
							xtype : 'button',
							text : '待修列表',
							scale : 'large',
							iconCls : 'ico_repair',
							action : 'repair'
						}, {
							xtype : 'tbspacer'
						}, {
							xtype : 'button',
							text : '综合查询',
							scale : 'large',
							iconCls : 'ico_search',
							action : 'search'
						}, {
							xtype : 'tbspacer'
						}, {
							xtype : 'tbfill'
						}, {
							xtype : 'button',
							text : '退出',
							scale : 'large',
							iconCls : 'ico_exit',
							action : 'exit'
						} ]
					} ]
				} ]
			}, {
				xtype : 'component',
				flex : 1
			} ]
		}, {
			xtype : 'container',
			layout : 'hbox',
			items : [ {
				xtype : 'component',
				flex : 1
			}, {
				xtype : 'container',
				width : 900,
				items : [ {
					xtype : 'grid',
					title : '公告',
					store : 'Notices',
					id : 'noticeGrid',
					padding : '20 40 20 150',
					width : 800,
					columns : [ {
						header : '标题',
						dataIndex : 'title',
						width : 150
					}, {
						header : '发布人',
						dataIndex : 'author',
						width : 60
					}, {
						xtype : 'datecolumn',
						header : '发布日期',
						dataIndex : 'date',
						format : 'Y-m-d',
						width : 80
					},{
						header : '内容',
						dataIndex : 'content',
						flex : 1
					}]
				} ]
			}, {
				xtype : 'component',
				flex : 1
			} ]
		}, {
			xtype : 'container',
			layout : 'hbox',
			items : [ {
				xtype : 'component',
				flex : 1
			}, {
				xtype : 'component',
				width : 900,
				padding : '10 0 10 200',
				html : '<div>待修: <a href="#">2</a></div>'
			}, {
				xtype : 'component',
				flex : 1
			} ]
		} ];

		this.callParent();
	}
});