/**
* 营业款收入模型(同时作为财务核销，应收款，应付款使用的模型)
*/
Ext.define('Mbfix.model.TurnoverIncome',{
	extend : 'Ext.data.Model',
	fields : ['id','user','service_point','record_no','custom_type','custom_name','receiver','pay_type'
		,'money','profit','notes','finance_exception','finance_user',
		{name:'date',type:'date',dateFormat:'U'},
		{name:'pay_state',type:'integer'},
		{name:'finance_state',type:'integer'},
		{name:'finance_date',type:'date',dateFormat:'U'}
		]
});