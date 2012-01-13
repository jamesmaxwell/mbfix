/**
 * 客户联络方式管理页面
 */
Ext.define('Mbfix.view.admin.ContactTypeAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.contacttypeadmin',
	title : '客户联络方式管理',

	initComponent : function() {
		this.setGridStore('ContactTypes');

		this.callParent();
	}
});