/**
* 备件出库模型实体
*/
Ext.define('Mbfix.model.ComponentStockout',{
	extend : 'Ext.data.Model',
	fields : ['id','user','service_point','buyer_company',
		{name:'sell_for',type:'integer'},
		{name:'sell_type',type:'integer'},
		'record_no','store_house','component_brand','component_model',
		'component_name',
		'amount','unit','price','discount','receipt_type','receipt_account',
		'pay_type','receiver','notes',
		{name:'date',type:'date',dateFormat: 'U'}]
});