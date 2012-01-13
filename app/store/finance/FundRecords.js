/**
* 申请，审核款项使用的是款项Store
*/
Ext.define('Mbfix.store.finance.FundRecords',{
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.FundRecord',
	
	proxy : {
		type : 'ajax',
		api : {
			read : 'index.php?r=finance/fundList'
		},
		reader : {
			type : 'json',
			root : 'results'
		},
		listeners : {
			exception : function(proxy, response, operation, eOpts) {
				Ext.Msg.alert('操作失败', Ext.String.format(
						'服务端发生错误. status:{0}, {1}', response.status,
						response.statusText));
			}
		}
	}
});