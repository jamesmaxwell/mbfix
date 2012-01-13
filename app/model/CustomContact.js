/**
 * 客户联络模型类
 */
Ext.define('Mbfix.model.CustomContact', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'contact_type', 'contact_content', {
		name : 'contact_date',
		type : 'date',
		dateFormat : 'U'
	} ]
});