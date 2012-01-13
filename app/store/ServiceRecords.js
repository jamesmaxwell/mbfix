Ext.define('Mbfix.store.ServiceRecords', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.ServiceRecord',
	pageSize : 13,

	proxy : {
		type : 'ajax',
		extraParams : {
			recordNo : null,
			fixer : null,
			beginDate : null,
			endDate : null,
			recordState : null
		},
		api : {
			read : 'index.php?r=serviceRecord/list',
			update : 'index.php?r=serviceRecord/update'
		},
		actionMethods : {
			read : 'POST'
		},
		reader : {
			type : 'json',
			root : 'results'
		},
		writer : {
			type : 'json'
		}
	}
});