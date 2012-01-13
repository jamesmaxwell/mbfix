/**
 * 备件采购实体类
 */
Ext.define('Mbfix.model.ComponentPurchase', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'user', 'servicePoint', 'supply_company',
			'supply_address', 'amount', 'unit', 'price', 'pay_state',
			'pay_type', 'pay_account', 'notes', {
				type : 'date',
				name : 'date',
				dateFormat : 'U'
			}, {
				type : 'integer',
				name : 'pay_state'
			},{
				//是否已入库，1=未入库，2=已入库
				type : 'integer',
				name : 'state'
			} ]
});