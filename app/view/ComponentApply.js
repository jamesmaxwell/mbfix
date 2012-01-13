/**
 * 备件申请窗口
 */
Ext.define('Mbfix.view.ComponentApply', {
			extend : 'Ext.window.Window',
			alias : 'widget.componentapply',
			width : 250,
			modal : true,
			title : '备件申请',

			initComponent : function() {
				this.items = [{
							xtype : 'form',
							bodyPadding : 5,
							border : 0,
							layout : 'anchor',
							fieldDefaults : {
								labelAlign : 'right',
								labelWidth : 60
							},
							items : [{
										xtype : 'displayfield',
										fieldLabel : '申请人',
										itemId : 'apply_user'
									}, {
										xtype : 'displayfield',
										fieldLabel : '网点',
										itemId : 'apply_service_point'
									}, {
										xtype : 'combo',
										fieldLabel : '采购类型',
										itemId : 'purchase_type',
										name : 'purchase_type',
										store : 'PurchaseTypes',
										editable : false,
										allowBlank : false,
										valueField : 'id',
										displayField : 'text',
										width : 160
									},{
										xtype : 'combo',
										fieldLabel : '品牌',
										name : 'component_brand',
										itemId : 'component_brand',
										allowBlank : false,
										editable : false,
										store : 'ComponentBrands',
										valueField : 'id',
										displayField : 'text',
										width : 160
									}, {
										xtype : 'combo',
										fieldLabel : '型号',
										name : 'component_model',
										itemId : 'component_model',
										allowBlank : false,
										editable : false,
										store : 'ComponentModels',
										valueField : 'id',
										displayField : 'text',
										width : 160
									}, {
										xtype : 'textfield',
										fieldLabel : '名称',
										name : 'component_name',
										itemId : 'component_name',
										allowBlank : false,
										flex : 1,
										itemId : 'component_name'
									}, {
										xtype : 'numberfield',
										fieldLabel : '数量',
										name : 'amount',
										itemId : 'component_amount',
										allowBlank : false,
										value : 1,
										minValue : 1,
										width : 150
									},{
										xtype : 'textarea',
										fieldLabel : '备注',
										name : 'notes',
										flex : 1,
										maxLength : 200
									}]
						}];

				this.buttons = [{
							text : '申请',
							action : 'apply'
						}, {
							text : '取消',
							action : 'close'
						}];

				this.callParent();
			}
		});