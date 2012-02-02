/**
* 公告管理
*/
Ext.define('Mbfix.view.notice.NoticeAdmin',{
	extend : 'Ext.window.Window',
	alias : 'widget.noticeadmin',
	title : '公告管理',
	width : 550,
	height : 400,
	modal : true,
	layout : 'fit',
	
	initComponent : function() {
		this.items = [{
					xtype : 'grid',
					border : 0,
					store : 'Notices',
					columns : [{
								header : '编号',
								dataIndex : 'id',
								width : 40
							}, {
								header : '标题',
								dataIndex : 'title',
								width : 150,
								editor : {
									xtype : 'textfield',
									allowBlank : false
								}
							}, {
								header : '发布者',
								dataIndex : 'author',
								width : 60,
								editor : {
									xtype : 'textfield',
									allowBlank : false
								}
							}, {
								header : '内容',
								dataIndex : 'content',
								flex : 1,
								editor : {
									xtype : 'textfield',
									allowBlank : false
								}
							}],
					tbar : [{
								text : '新增',
								iconCls : 'type_add',
								action : 'noticeadd'
							}, {
								text : '删除',
								iconCls : 'type_delete',
								action : 'noticedelete'
							}],
					bbar : [{
								xtype : 'pagingtoolbar',
								id : 'noticeListPaging',
								store : 'Notices',
								displayInfo : true,
								flex : 1
							}],
					plugins : [Ext.create('Ext.grid.plugin.RowEditing', {
								pluginId : 'noticeRowEditPlugin',
								clicksToEdit : 0
							})]
				}];

		this.buttons = [{
					text : '关闭',
					action : 'notice_close'
				}];

		this.callParent();
	}
});