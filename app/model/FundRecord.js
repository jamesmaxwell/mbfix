/**
* 申请，审核款项模型类
*/
Ext.define('Mbfix.model.FundRecord',{
	extend : 'Ext.data.Model',
	fields : ['id','apply_user','apply_service_point','apply_amount','apply_reason','apply_notes',
		'verify_user','verify_service_point','verify_amount','pay_type','pay_account','receiver_account','receiver',
		{name:'apply_date','type':'date',dateFormat: 'U'},
		{name:'verify_date','type':'date',dateFormat: 'U'},
		{name:'state',type:'integer'}]
});