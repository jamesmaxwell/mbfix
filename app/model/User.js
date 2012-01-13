/**
 * 用户模型类
 */
Ext.define('Mbfix.model.User', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'name', 'password', 'notes','roles','servicePoints', {
		name : 'lastlogin',
		type : 'date',
		format : 'U'
	} ]
});