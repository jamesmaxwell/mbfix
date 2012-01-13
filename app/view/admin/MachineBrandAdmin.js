/**
 * 机器品牌管理页面
 */
Ext.define('Mbfix.view.admin.MachineBrandAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.machinebrandadmin',
	title : '机器品牌管理',

	initComponent : function() {
		this.setGridStore('MachineBrands');

		this.callParent();
	}
});