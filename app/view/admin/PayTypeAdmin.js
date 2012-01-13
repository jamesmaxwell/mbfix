/**
 * 收款管理页面
 */
Ext.define('Mbfix.view.admin.PayTypeAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.paytypeadmin',
	title : '收款管理',

	initComponent : function() {
		this.setGridStore('PayTypes');

		this.callParent();
	}
});