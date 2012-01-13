/**
 * 客户类型
 */
Ext.define('Mbfix.store.CustomTypes', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.CommonType',
	storeId : 'customTypeStore',

	proxy : {
		type : 'ajax',
		extraParams : {
			'typename' : 'CustomType'
		},
		api : {
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