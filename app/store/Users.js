/**
 * 用户Store
 */
Ext.define('Mbfix.store.Users', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.User',

	proxy : {
		type : 'ajax',
		api : {
			read : 'index.php?r=admin/list',
			create : 'index.php?r=admin/add',
			update : 'index.php?r=admin/update',
			destroy : 'index.php?r=admin/delete'
		},
		actionMethods : {
			read : 'POST'
		},
		reader : {
			type : 'json',
			root : 'results'
		},
		writer : {
			type : 'json'
		},
		listener : {
			exception : function(proxy, response, operation) {
				Ext.Msg.alert('错误', response.responseText);
			}
		}
	}
});