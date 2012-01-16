/**
 * 收款情况
 */
Ext.define('Mbfix.store.component.ComponentReceiptTypes',{
	extend : 'Ext.data.ArrayStore',
	fields : ['id','text'],
	data : [[1,'已收款'],[2, '未收款']],
	autoLoad : true
});