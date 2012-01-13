Ext.define('Mbfix.view.Login', {
	extend : 'Ext.window.Window',
	alias : 'widget.login',
	modal : true,
	closable : false,
	width : 350,
	height : 230,
	title : '用户登录',
	itemId : 'login',

	initComponent : function() {
		this.items = [{
			xtype : 'container',
			layout : 'hbox',
			items : [{
						xtype : 'component',
						width : 138,
						padding : '20 5 0 5',
						html : '<img src="images/system_login.png" alt="login"/>'
					}, {
						xtype : 'form',
						flex : 1,
						bodyPadding : 10,
						margin : '2',
						layout : 'anchor',
						closable : false,
						fieldDefaults : {
							labelAlign : 'top'
						},
						items : [{
									xtype : 'textfield',
									fieldLabel : '用户名',
									itemId : 'userName',
									name : 'username',
									allowBlank : false
								}, {
									xtype : 'textfield',
									fieldLabel : '密码',
									inputType : 'password',
									name : 'password',
									allowBlank : false
								}, {
									xtype : 'combo',
									fieldLabel : '所在区域',
									name : 'servicePoint',
									itemId : 'servicePoint',
									allowBlank : false,
									editable : false,
									store : 'ServicePoints',
									queryParam : 'username',
									valueField : 'id',
									displayField : 'name'
								}],
						buttons : [{
									text : '登录',
									formBind : true,
									disabled : true,
									action : 'login'
								}, {
									text : '重置',
									action : 'reset'
								}]
					}]
		}]

		this.callParent();
	}
});