/**
* 费用支出模型类
*/
Ext.define('Mbfix.model.Payout',{
	extend : 'Ext.data.Model',
	fields : ['id','handler_user','service_point','consume_content','amount','ticket_no','notes',
		{name:'ticket_type','type':'integer'},
		{name:'date','type':'date',dateFormat: 'U'}]
});