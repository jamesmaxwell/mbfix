/**
 * 备件实体
 */
Ext.define('Mbfix.model.RepairComponent', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'name', 'component_brand', 'component_model', 'notes',
			'service_point', {
				type : 'integer',
				name : 'amount'
			}, {
				type : 'integer',
				name : 'state'
			} ]
});