/**
 * 维修方式管理页面
 */
Ext.define('Mbfix.view.admin.RepairTypeAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.repairtypeadmin',
	title : '维修方式管理',

	initComponent : function() {
		this.setGridStore('RepairTypes');

		this.callParent();
	}
});