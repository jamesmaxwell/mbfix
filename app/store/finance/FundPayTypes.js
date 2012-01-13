/**
 * 款项申请状态,1=淘宝，2=现金，3=网银
 */
Ext.define('Mbfix.store.finance.FundPayTypes',{
	extend : 'Ext.data.ArrayStore',
	fields : ['id','text'],
	data : [[1,'淘宝'],[2, '现金'],[3,'网银']],
	autoLoad : true
});