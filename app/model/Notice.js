Ext.define('Mbfix.model.Notice', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'title', 'author', {name:'date',type:'date',dateFormat:'U'}, 'content' ]
});