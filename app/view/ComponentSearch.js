/**
 * 备件查询窗口
 */
Ext.define('Mbfix.view.ComponentSearch', {
			extend : 'Ext.window.Window',
			alias : 'widget.componentsearch',
			title : '备件查询',
			layout : 'anchor',
			modal : true,
			width : 600,
			height : 400,

			initComponent : function() {
				this.items = [{
							xtype : 'form',
							border : 0,
							layout : 'anchor',
							fieldDefaults : {
								'labelAlign' : 'right',
								'labelWidth' : 40
							},
							items : [{
										xtype : 'fieldset',
										title : '搜索条件',
										margin : '0 2',
										layout : 'hbox',
										items : [{
													xtype : 'combo',
													fieldLabel : '网点',
													name : 'service_point',
													itemId : 'service_point',
													editable : false,
													store : 'ServicePoints',
													valueField : 'id',
													displayField : 'name',
													width : 110
												}, {
													xtype : 'combo',
													fieldLabel : '品牌',
													name : 'component_brand',
													itemId : 'component_brand',
													editable : false,
													store : 'ComponentBrands',
													valueField : 'id',
													displayField : 'text',
													width : 110
												}, {
													xtype : 'combo',
													fieldLabel : '型号',
													name : 'component_model',
													itemId : 'component_model',
													editable : false,
													store : 'ComponentModels',
													valueField : 'id',
													displayField : 'text',
													width : 110
												}, {
													xtype : 'textfield',
													fieldLabel : '名称',
													name : 'component_name',
													flex : 1,
													itemId : 'component_name'
												}, {
													xtype : 'button',
													text : '搜索',
													action : 'search',
													margin : '0 5 0 5'
												}]
									}, {
										xtype : 'grid',
										margin : '8 0 0 0',
										flex : 1,
										height : 285,
										store : 'RepairComponents',
										columns : [{
													header : '品牌',
													dataIndex : 'component_brand',
													width : 80
												}, {
													header : '型号',
													dataIndex : 'component_model',
													width : 80
												}, {
													header : '名称',
													dataIndex : 'name',
													width : 100
												}, {
													header : '网点',
													dataIndex : 'service_point',
													width : 70
												}, {
													header : '库存',
													dataIndex : 'amount',
													width : 60
												}, {
													header : '备注',
													dataIndex : 'notes',
													flex : 1
												}],
										bbar : [{
													xtype : 'pagingtoolbar',
													store : 'RepairComponents',
													id : 'repair_component_pager',
													displayInfo : true,
													flex : 1
												}]
									}]
						}];

				this.buttons = [{
							text : '备件申请',
							action : 'apply'
						}, {
							text : '备件出库',
							action : 'stock_out',
							itemId : 'stock_out',
							hidden : true
						}, {
							text : '选择',
							itemId : 'confirm',
							action : 'confirm'
						}, {
							text : '关闭',
							action : 'close'
						}];

				this.callParent();
			}
		});