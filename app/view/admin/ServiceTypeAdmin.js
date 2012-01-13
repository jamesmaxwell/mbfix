/**
 * 服务类型管理视图
 */
Ext.define('Mbfix.view.admin.ServiceTypeAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.servicetypeadmin',
	title : '服务类型管理',

	initComponent : function() {
		this.setGridStore('ServiceTypes');

		this.callParent();
	}
});