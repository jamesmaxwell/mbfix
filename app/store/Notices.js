Ext.define('Mbfix.store.Notices', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.Notice',
	storeId : 'noticeStore',

	proxy : {
		type : 'ajax',
		api : {
			read : 'index.php?r=notice/list',
			create : 'index.php?r=notice/add',
			update : 'index.php?r=notice/update',
			destroy : 'index.php?r=notice/delete'
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
				Ext.Msg.alert('´íÎó', response.responseText);
			}
		}
	}
});