/**
 * 采购类型管理页面
 */
Ext.define('Mbfix.view.admin.PurchaseTypeAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.purchasetypeadmin',
	title : '采购类型管理',

	initComponent : function() {
		this.setGridStore('PurchaseTypes');

		this.callParent();
	}
});