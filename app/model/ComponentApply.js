/**
 * 备件申请实体类
 */
Ext.define('Mbfix.model.ComponentApply', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'component_name', 'user_id', 'service_point_id', 
			'notes',
			{
				type : 'date',
				name : 'date',
				dateFormat : 'U'
			},{
				type : 'integer',
				name : 'amount'
			},{
				type : 'integer',
				name : 'state'
			}]
});