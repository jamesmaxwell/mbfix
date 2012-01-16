/**
* 营业款收入模型(同时作为财务核销，应收款，应付款使用的模型)
*/
Ext.define('Mbfix.model.TurnoverIncome',{
	extend : 'Ext.data.Model',
	fields : ['id','user','service_point','record_no','custom_type','custom_name','receiver','pay_type'
		,'money','profit','notes','pay_state','finance_state','finance_exception',
		{name:'date',type:'date',dataFormat:'U'}]
});