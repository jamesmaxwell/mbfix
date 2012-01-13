Ext.define('Mbfix.store.ServiceTypes', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.CommonType',

	proxy : {
		type : 'ajax',
		extraParams : {
			'typename' : 'ServiceType'
		},
		api: {
			read : 'index.php?r=common/readCommonType',
			create : 'index.php?r=common/newCommonType',
			update : 'index.php?r=common/updateCommonType',
			destroy : 'index.php?r=common/deleteCommonType'
		},
		reader : {
			type : 'json',
			root : 'results'
		},
		writer : {
			type : 'json'
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