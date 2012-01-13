/**
 * 角色管理窗口
 */
Ext.define('Mbfix.view.user.RoleAdmin', {
			extend : 'Ext.window.Window',
			alias : 'widget.user.roleadmin',
			title : '角色管理',
			width : 500,
			height : 300,
			layout : 'fit',

			initComponent : function() {
				this.items = [{
							xtype : 'grid',
							border : 0,
							store : 'Roles',
							columns : [{
										header : '编号',
										dataIndex : 'id',
										flex : 1
									}, {
										header : '角色',
										dataIndex : 'name',
										flex : 2,
										editor : {
											xtype : 'textfield',
											allowBlank : false
										}
									}, {
										header : '名称',
										dataIndex : 'show_name',
										editor : {
											xtype : 'textfield',
											allowBlank : false
										}
									}, {
										header : '说明',
										dataIndex : 'notes',
										width : 150,
										editor : {
											xtype : 'textfield'
										}
									}],
							tbar : [{
										text : '新增',
										iconCls : 'type_add',
										action : 'typeadd'
									}, {
										text : '删除',
										iconCls : 'type_delete',
										action : 'typedelete'
									}],
							plugins : [Ext.create('Ext.grid.plugin.RowEditing',
									{
										pluginId : 'rowEditPlugin',
										clicksToEdit : 0
									})]
						}];

				this.buttons = [{
							text : '关闭',
							action : 'close'
						}];

				this.callParent();
			}
		});