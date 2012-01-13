/**
 * 配件型号管理页面
 */
Ext.define('Mbfix.view.admin.ComponentModelAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.componentmodeladmin',
	title : '配件型号管理',

	initComponent : function() {
		this.setGridStore('ComponentModels');

		this.callParent();
	}
});