/**
 * 质保类型管理页面
 */
Ext.define('Mbfix.view.admin.WarrantyTypeAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.warrantytypeadmin',
	title : '质保类型管理',

	initComponent : function() {
		this.setGridStore('WarrantyTypes');

		this.callParent();
	}
});