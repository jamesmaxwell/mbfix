/**
 * 客户类型管理视图
 */
Ext.define('Mbfix.view.admin.CustomTypeAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.customtypeadmin',
	title : '客户类型管理',

	initComponent : function() {
		this.setGridStore('CustomTypes');

		this.callParent();
	}
});