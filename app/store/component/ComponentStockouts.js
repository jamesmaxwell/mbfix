/**
* 备件出库Store
*/
Ext.define('Mbfix.store.component.ComponentStockouts',{
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.ComponentStockout',
	
	proxy : {
		type : 'ajax',
		api : {
			read : 'index.php?r=componentApply/stockoutList'
		},
		reader : {
			type : 'json',
			root : 'results'
		}
	}
});