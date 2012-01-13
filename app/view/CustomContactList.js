/**
 * 客户联络详细信息窗口
 */
Ext.define('Mbfix.view.CustomContactList', {
			extend : 'Ext.window.Window',
			alias : 'widget.customcontact',
			width : 560,
			maxHeight : 400,
			minHeight : 100,
			modal : true,
			title : '客户联系记录',

			initComponent : function() {
				this.items = [{
							xtype : 'grid',
							border : 0,
							flex : 1,
							autoScroll : true,
							store : 'CustomContacts',
							columns : [{
										header : '联络类型',
										dataIndex : 'contact_type',
										width : 100
									}, {
										header : '联络内容',
										dataIndex : 'contact_content',
										flex : 1
									}, {
										xtype : 'datecolumn',
										header : '联络时间',
										dataIndex : 'contact_date',
										format : 'Y-m-d H:i',
										width : 120
									}]
						}];

				this.callParent();
			}
		});