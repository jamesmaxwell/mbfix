/**
 * 票据类型,1=物流单,2=收据,3=发票
 */
Ext.define('Mbfix.store.finance.TicketTypes',{
	extend : 'Ext.data.ArrayStore',
	fields : ['id','text'],
	data : [[1,'物流单'],[2, '收据'],[3,'发票']],
	autoLoad : true
});