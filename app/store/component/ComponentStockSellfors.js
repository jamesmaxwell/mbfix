/**
 * 出库类型
 */
Ext.define('Mbfix.store.component.ComponentStockSellfors',{
	extend : 'Ext.data.ArrayStore',
	fields : ['id','text'],
	data : [[1,'销售'],[2, '维修']],
	autoLoad : true
});