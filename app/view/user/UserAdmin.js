/**
 * 用户管理窗口
 */
Ext.define('Mbfix.view.user.UserAdmin', {
	extend : 'Ext.window.Window',
	alias : 'widget.useradmin',
	title : '用户管理',
	width : 550,
	height : 400,
	modal : true,
	layout : 'fit',

	initComponent : function() {
		this.items = [{
					xtype : 'grid',
					border : 0,
					store : 'Users',
					columns : [{
								header : '编号',
								dataIndex : 'id',
								width : 50
							}, {
								header : '用户名',
								dataIndex : 'name',
								width : 100,
								editor : {
									xtype : 'textfield',
									allowBlank : false
								}
							}, {
								header : '角色',
								dataIndex : 'roles',
								width : 160,
								renderer : this.getRoles,
								editor : {
									xtype : 'combo',
									itemId : 'role_combo',
									allowBlank : false,
									multiSelect : true,
									store : 'Roles',
									valueField : 'name',
									displayField : 'show_name'
								}
							}, {
								header : '网点',
								dataIndex : 'servicePoints',
								width : 130,
								renderer : this.getServicePoints,
								editor : {
									xtype : 'combo',
									itemId : 'service_point_combo',
									allowBlank : false,
									multiSelect : true,
									store : 'ServicePoints',
									valueField : 'id',
									displayField : 'name'
								}
							}, {
								header : '备注',
								dataIndex : 'notes',
								flex : 1,
								editor : {
									xtype : 'textfield'
								}
							}],
					tbar : [{
								text : '新增',
								iconCls : 'type_add',
								action : 'useradd'
							}, {
								text : '删除',
								iconCls : 'type_delete',
								action : 'userdelete'
							}, '-', {
								xtype : 'tbspacer',
								width : 50
							}, {
								xtype : 'displayfield',
								value : '新用户默认密码为: mbfix.com'
							}],
					bbar : [{
								xtype : 'pagingtoolbar',
								id : 'userListPaging',
								store : 'Users',
								displayInfo : true,
								flex : 1
							}],
					plugins : [Ext.create('Ext.grid.plugin.RowEditing', {
								pluginId : 'userRowEditPlugin',
								clicksToEdit : 0
							})]
				}];

		this.buttons = [{
					text : '关闭',
					action : 'close',
					handler : function(button) {
						button.up('window').close();
					}
				}];

		this.callParent();
	},
	


	/**
	 * 显示角色的中文名称，而不是英文
	 */
	getRoles : function(value) {
		var vals = [], record, values = Ext.isArray(value) ? value : [value],
		store = Ext.getStore('Roles');
		for (var i = 0; i < values.length; i++) {
			record = store.findRecord('name', values[i]);
			if (record != null) {
				vals.push(record.data.show_name);
			} else {
				vals.push(values[i]);
			}
		}
		return vals.join(',');
	},
	
	/**
	 * 显示服务点的中文名称，而不是英文
	 */
	getServicePoints : function(value){
		var vals = [], record, values = Ext.isArray(value) ? value : [value];
		var store = Ext.getStore('ServicePoints');
		for (var i = 0; i < values.length; i++) {
			record = store.findRecord('id', values[i]['service_point_id'] || values[i]);
			if (record != null) {
				vals.push(record.data.name);
			} else {
				vals.push(values[i]['service_point_id'] || values[i]);
			}
		}
		return vals.join(',');
	}
});