/**
 * 所有类型管理的视图基类, 包含一个可编辑的gridpanel和一个关闭按钮
 */
Ext.define('Mbfix.view.admin.TypeAdminBase', {
	extend : 'Ext.window.Window',
	alias : 'widget.typeadmin',
	width : 400,
	height : 300,
	layout : 'fit',

	gridStore : null,

	initComponent : function() {
		this.items = [ {
			xtype : 'grid',
			border : 0,
			store : this.gridStore,
			columns : [ {
				header : '编号',
				dataIndex : 'id',
				flex : 1
			}, {
				header : '名称',
				dataIndex : 'text',
				flex : 2,
				editor : {
					xtype : 'textfield',
					allowBlank : false
				}
			} ],
			tbar : [ {
				text : '新增',
				iconCls : 'type_add',
				action : 'typeadd'
			}, {
				text : '删除',
				iconCls : 'type_delete',
				action : 'typedelete'
			} ],
			plugins : [ Ext.create('Ext.grid.plugin.RowEditing', {
				pluginId : 'rowEditPlugin',
				clicksToEdit : 0
			}) ]
		} ];

		this.buttons = [ {
			text : '关闭',
			action : 'close'
		} ];

		this.callParent();
	},

	setGridStore : function(store) {
		this.gridStore = store;
	}
});