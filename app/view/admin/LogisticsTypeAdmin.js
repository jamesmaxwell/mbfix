/**
 * 物流单位管理视图
 */
Ext.define('Mbfix.view.admin.LogisticsTypeAdmin', {
	extend : 'Mbfix.view.admin.TypeAdminBase',
	alias : 'widget.logisticstypeadmin',
	title : '物流单位管理',

	initComponent : function() {
		this.setGridStore('LogisticsTypes');

		this.callParent();
	}
});