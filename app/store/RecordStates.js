/**
 * 服务单状态store 1=处理中,2=转修中,3=报价中,4=客户不修,5-待料,6=到料处理中,7=无法修复,8=已修复,9=已结案
 */
Ext.define('Mbfix.store.RecordStates', {
	extend : 'Ext.data.Store',	
	autoLoad : true,
	fields : [ 'name', {
		'name' : 'state',
		'type' : 'integer'
	} ],
	data : [ { name:'处理中', state:1 }, { name:'转修中', state: 2 }, { name:'报价中', state:3 }, {name: '客户不修',state: 4 },
			{ name:'待料', state:5 }, { name:'到料处理中', state:6 }, {name: '无法修复', state:7 }, { name:'已修复',state: 8 },
			{ name:'已结案', state:9 } ]
});