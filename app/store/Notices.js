Ext.define('Mbfix.store.Notices', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.Notice',
	storeId : 'noticeStore',

	proxy : {
		type : 'ajax',
		url : 'data/notices.json',
		reader : {
			type : 'json',
			root : 'notices'
		}
	}
});