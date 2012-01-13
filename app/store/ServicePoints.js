/**
 * 服务点管理Store
 */
Ext.define('Mbfix.store.ServicePoints', {
			extend : 'Ext.data.Store',
			model : 'Mbfix.model.ServicePoint',
			autoLoad : true,

			proxy : {
				type : 'ajax',
				api : {
					read : 'index.php?r=servicePoint/list',
					create : 'index.php?r=servicePoint/add',
					update : 'index.php?r=servicePoint/update',
					destroy : 'index.php?r=servicePoint/delete'
				},
				reader : {
					type : 'json',
					root : 'results'
				},
				writer : {
					type : 'json'
				},
				listeners : {
					exception : function(proxy, response, operation, opts){
						Ext.Msg.alert('错误', response.responseText);
					}
				}
			},
			
			listeners : {
				//服务点同步操作后触发
				//datachanged : function(store, opts){
				//}
			}
		});