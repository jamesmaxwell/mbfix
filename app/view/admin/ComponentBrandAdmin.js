/**
 * 配件品牌管理页面
 */
Ext.define('Mbfix.view.admin.ComponentBrandAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.componentbrandadmin',
	title : '配件品牌管理',

	initComponent : function() {
		this.setGridStore('ComponentBrands');

		this.callParent();
	}
});