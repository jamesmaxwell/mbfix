Ext.define('Mbfix.view.Viewport', {
	extend : 'Ext.container.Viewport',

	layout : 'anchor',

	requires : [ 'Mbfix.view.Home', 'Mbfix.view.Record' ],

	initComponent : function() {
		this.items = [ {
			xtype : 'container',

			layout : 'hbox',
			items : [ {
				xtype : 'component',
				flex : 1
			}, {
				xtype : 'component',
				height : 70,
				width : 900,
				padding : '5 0 5 10',
				cls : 'mbfix_logo',
				html : '<img src="images/logo.gif" alt="mbfix"/><div></div>'
			}, {
				xtype : 'component',
				flex : 1
			} ]
		}, {
			xtype : 'home',
			height : 500
		}, {
			xtype : 'container',
			layout : 'hbox',
			items : [ {
				xtype : 'component',
				flex : 1
			}, {
				xtype : 'component',
				height : 70,
				width : 900,
				padding : '5',
				cls : 'mbfix_footer',
				html : '<div>copyright &copy 2011   正修电子维修管理系统</div>'
			}, {
				xtype : 'component',
				flex : 1
			} ]
		} ];

		this.callParent(arguments);
	}
});