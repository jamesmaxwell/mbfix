/**
 * 服务点管理窗口
 */
Ext.define('Mbfix.view.admin.ServicePointAdmin', {
			extend : 'Ext.window.Window',
			alias : 'widget.servicepointadmin',
			title : '服务点管理',
			width : 500,
			height : 300,
			modal : true,
			layout : 'fit',

			initComponent : function() {
				this.items = [{
							xtype : 'grid',
							border : 0,
							store : 'ServicePoints',
							columns : [{
										header : '编号',
										dataIndex : 'id',
										width : 60
									}, {
										header : '名称',
										dataIndex : 'name',
										width : 130,
										editor : {
											xtype : 'textfield',
											allowBlank : false
										}
									}, {
										header : '英文简称',
										dataIndex : 'short_name',
										width : 80,
										editor : {
											xtype : 'textfield',
											vtype : 'alpha',
											allowBlank : false
										}
									}, {
										header : '说明',
										dataIndex : 'desc',
										flex : 1,
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
							action : 'close',
							handler : function(button) {
								button.up('window').close();
							}
						}];

				this.callParent();
			}
		});