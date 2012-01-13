/**
* 费用支出Store
*/
Ext.define('Mbfix.store.finance.Payouts',{
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.Payout',
	
	proxy : {
		type : 'ajax',
		api : {
			read : 'index.php?r=finance/payoutList'
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