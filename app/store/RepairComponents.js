/**
 * 配件 Store
 */
Ext.define('Mbfix.store.RepairComponents',{
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.RepairComponent',
	
	proxy : {
		type : 'ajax',
		extraParams : {
			component_brand : '',
			component_model : '',
			component_name : '',
			service_point : ''
		},
		api : {
			read : 'index.php?r=repairComponent/list'
		},
		actionMethods : {
			read : 'POST'
		},
		reader : {
			type : 'json',
			root : 'results'
		}
	}
	
});