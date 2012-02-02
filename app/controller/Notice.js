/**
* 公告管理相关控件器
*/
Ext.define('Mbfix.controller.Notice',{
	extend : 'Ext.app.Controller',
	
	views : ['Home', 'notice.NoticeAdmin'],
	stores : ['Users', 'Notices'],
	
	init : function(){
		this.control({
					'home #menuNoticeAdmin' : {
						click : this.noticeAdmin
					},
					'noticeadmin grid' : {
						edit : this.noticeUpdate
					},
					'noticeadmin button[action="noticeadd"]' : {
						click : this.noticeAdd
					},
					'noticeadmin button[action="noticedelete"]' : {
						click : this.noticeDelete
					},
					'noticeadmin button[action="notice_close"]' : {
						click : this.closeNoticeWin
					}
		});
	},
	
		
	/**
	* 公告管理
	*/
	noticeAdmin : function(button){
		var win = Ext.widget('noticeadmin');
		win.show();
		win.down('grid').getStore().loadPage(1, {
				callback : function(records, operation, success) {
					if (success) {
						;
					} else {
						var error = operation.getError();
						Ext.Msg.alert('错误', error.status + ' '
											+ error.statusText);
					}
				}
		});
	},

	/**
	* 关闭公告窗口，同时重新加载主页上的公告
	*/
	closeNoticeWin : function(button){
		button.up('window').close();
		Ext.getCmp('noticeGrid').getStore().loadPage(1);
	},
	
	/**
	* 编辑公告触发的事件
	* @param {Ext.grid.plugin.Editing} editor 编辑插件引用
	* @param {Ojbect} e 一个编辑事件参数
	* @param {Object} opts 其它事件参数
	*/
	noticeUpdate : function(editor, e, opts){
		editor.record.store.sync();
	},
	
	/**
	* 添加公告
	*/
	noticeAdd : function(button){
		var grid = button.up('window').down('grid'),
		store = grid.getStore(),
		notice = new Mbfix.model.Notice();
		notice.author = this.application.currentUser;
		store.insert(0, notice);
		var rowEditing = grid.getPlugin('noticeRowEditPlugin');
		rowEditing.cancelEdit();
		rowEditing.startEdit(0, 0);
	},
	
	/**
	* 删除公告按钮事件
	*/
	noticeDelete : function(button) {
		Ext.Msg.confirm('确认提示', '确定要删除当前公告?', function(result) {
			if (result == 'no')
				return false;
			var grid = button.up('window').down('grid');
			var rowEditing = grid.getPlugin('noticeRowEditPlugin');
			rowEditing.cancelEdit();
			var sm = grid.getSelectionModel();
			grid.getStore().remove(sm.getSelection());
			grid.getStore().sync();
			}, this);
	}
});