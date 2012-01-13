/**
 * 客户联络Store
 */
Ext.define('Mbfix.store.CustomContacts', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.CustomContact',

	proxy : {
		type : 'ajax',
		extraParams : {
			recordId : null
		},
		api : {
			read : 'index.php?r=customContact/list'
		},
		reader : {
			type : 'json',
			root : 'results'
		},
		listeners : {
			exception : function(proxy, response, operation, eOpts) {
				Ext.Msg.alert('更新失败', Ext.String.format(
						'服务端发生错误. status:{0}, {1}', response.status,
						response.statusText))
			}
		}
	}
});