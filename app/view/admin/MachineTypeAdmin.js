/**
 * 机器类型管理页面
 */
Ext.define('Mbfix.view.admin.MachineTypeAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.machinetypeadmin',
	title : '机器类型管理',

	initComponent : function() {
		this.setGridStore('MachineTypes');

		this.callParent();
	}
});