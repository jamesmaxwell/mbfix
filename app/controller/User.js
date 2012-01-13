/**
* 用户角色管理相关控件器
*/
Ext.define('Mbfix.controller.User',{
	extend : 'Ext.app.Controller',
	
	views : ['Home', 'user.UserAdmin'],
	stores : ['Users', 'Roles', 'ServicePoints'],
	
	init : function(){
		this.control({
				'home #menuRoleAdmin' : {
					click : this.roleAdmin
				},
				'home #menuUserAdmin' : {
					click : this.userAdmin
				},
				'useradmin grid' : {
					edit : this.userUpdate,
					afterrender : this.userAfterRender
				},
				'useradmin button[action="useradd"]' : {
					click : this.userAdd
				},
				'useradmin button[action="userdelete"]' : {
					click : this.userDelete
				}
		});
	},
	
	/**
	 * 编辑grid时，显示下拉框中选择的文本而不是值
	 * @param {Array} value 当前选中的值，可能多个
	 * @param {Ext.data.Store} store 要从哪个Store取原始值
	 * @param {string} findField 要从Store中查找的键名称
	 * @param {string} nameField 要显示的字段名称
	 * @return {string} 以','分隔的字符串
	 */
	/*
	_getComboValue : function(value, store,findField, nameField){
		var vals = [], record, values = Ext.isArray(value) ? value : [value];
		for (var i = 0; i < values.length; i++) {
			record = store.findRecord(findField, values[i]);
			if (record != null) {
				vals.push(record.data.nameField);
			} else {
				vals.push(values[i]);
			}
		}
		return vals.join(',');
	},
	*/
	
	/**
	 * 用户角色管理
	 * 
	 * @param {Button}
	 *            button
	 */
	roleAdmin : function(button) {
		Ext.widget('user.roleadmin').show();
	},

	/**
	 * 用户管理
	 * 
	 * @param {Button}
	 *            button
	 */
	userAdmin : function(button) {
		var win = Ext.widget('useradmin');
		win.show();
		var store = win.down('grid').getStore();
		store.loadPage(1, {
					scope : this,
					callback : function(records, response, opts) {
						// alert(response.responseText);
					}
				})
	},
	
	/**
	* 加载用户Grid控件后触发，显示后立即加载角色Store
	*/
	userAfterRender : function(cmp, opts){
		this.getRolesStore().load();
	},
	
	/**
	* 编辑用户触发的事件
	* @param {Ext.grid.plugin.Editing} editor 编辑插件引用
	* @param {Ojbect} e 一个编辑事件参数
	* @param {Object} opts 其它事件参数
	*/
	userUpdate : function(editor, e, opts){
		editor.record.store.sync();
	},
	
	/**
	* 添加用户
	*/
	userAdd : function(button){
		var grid = button.up('window').down('grid');
		var store = grid.getStore();
		store.insert(0, new Mbfix.model.User());
		var rowEditing = grid.getPlugin('userRowEditPlugin');
		rowEditing.cancelEdit();
		rowEditing.startEdit(0, 0);
	},
	
	/**
	* 删除按钮事件
	*/
	userDelete : function(button) {
		Ext.Msg.confirm('确认提示', '确定要删除当前用户?', function(result) {
			if (result == 'no')
				return false;
			var grid = button.up('window').down('grid');
			var rowEditing = grid.getPlugin('userRowEditPlugin');
			rowEditing.cancelEdit();
			var sm = grid.getSelectionModel();
			grid.getStore().remove(sm.getSelection());
			grid.getStore().sync();
			}, this);
	}
});