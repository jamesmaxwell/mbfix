/**
 * 备件申请Store
 */
Ext.define('Mbfix.store.ComponentApplys', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.ComponentApply',

	proxy : {
		type : 'ajax',
		api : {
			read : 'index.php?r=componentApply/list',
			update : 'index.php?r=componentApply/save'
		},
		reader : {
			type : 'json',
			root : 'results'
		}
	}
});