/**
 * 收款情况
 */
Ext.define('Mbfix.store.component.ComponentReceiptTypes',{
	extend : 'Ext.data.ArrayStore',
	fields : ['id','text'],
	data : [[1,'未收款'],[2, '已收款']],
	autoLoad : true
});