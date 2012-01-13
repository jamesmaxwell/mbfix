/**
 * 角色Store
 */
Ext.define('Mbfix.store.Roles', {
			extend : 'Ext.data.Store',
			model : 'Mbfix.model.Role',
			autoLoad : true,

			proxy : {
				type : 'ajax',
				api : {
					read : 'index.php?r=role/list'
					//create : 'index.php?r=role/add',
					//update : 'index.php?r=role/update',
					//destroy : 'index.php?r=role/destroy'
				},
				reader : {
					type : 'json',
					root : 'results'
				},
				writer : {
					type : 'json'
				}
			}
		});