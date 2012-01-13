/**
 * 故障类别管理页面
 */
Ext.define('Mbfix.view.admin.ProblemTypeAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.problemtypeadmin',
	title : '故障类别管理',

	initComponent : function() {
		this.setGridStore('ProblemTypes');

		this.callParent();
	}
});