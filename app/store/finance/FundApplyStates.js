/**
 * 款项申请状态,1=等待审核，2=审核通过，3=审核拒绝
 */
Ext.define('Mbfix.store.finance.FundApplyStates',{
	extend : 'Ext.data.ArrayStore',
	fields : ['id','text'],
	data : [[1,'等待审核'],[2, '审核通过'],[3,'审核拒绝']],
	autoLoad : true
});