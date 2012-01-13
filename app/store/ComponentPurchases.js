/**
 * 备件采购模型Store
 */
Ext.define('Mbfix.store.ComponentPurchases', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.ComponentPurchase',

	proxy : {
		type : 'ajax',
		api : {
			read : 'index.php?r=componentApply/purchaseList'
		},
		reader : {
			type : 'json',
			root : 'results'
		}
	}
});