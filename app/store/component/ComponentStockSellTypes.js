/**
 * 出库方式
 */
Ext.define('Mbfix.store.component.ComponentStockSellTypes',{
	extend : 'Ext.data.ArrayStore',
	fields : ['id','text'],
	data : [[1,'现场'],[2, '邮寄'],[3,'自用']],
	autoLoad : true
});