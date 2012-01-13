/**
 * 故障诊断页面
 */
Ext.define('Mbfix.view.Repair', {
			extend : 'Ext.window.Window',
			alias : 'widget.repair',
			width : 600,
			height : 490,
			title : '故障诊断',

			initComponent : function() {
				this.items = [{
					xtype : 'form',
					bodyPadding : 5,
					border : 0,
					layout : 'anchor',
					fieldDefaults : {
						'labelAlign' : 'right',
						'labelWidth' : 65
					},
					items : [{
						xtype : 'fieldset',
						title : '故障信息',
						layout : 'anchor',
						items : [{
							xtype : 'container',
							layout : 'hbox',
							items : [{
								xtype : 'combo',
								fieldLabel : '诊断结果',
								itemId : 'repair_judge',
								width : 200,
								name : 'repair_judge',
								editable : false,
								queryMode : 'local',
								value : 1,
								store : new Ext.data.ArrayStore({
											fields : ['id', 'text'],
											data : [[1, '发现故障-维修'],
													[2, '未发现故障-NTF']]
										}),
								valueField : 'id',
								displayField : 'text'
							}, {
								xtype : 'combo',
								fieldLabel : '故障类别',
								width : 160,
								name : 'problem_type',
								itemId : 'problem_type',
								editable : false,
								allowBlank : false,
								store : 'ProblemTypes',
								valueField : 'id',
								displayField : 'text'
							}, {
								xtype : 'combo',
								fieldLabel : '维修方式',
								width : 160,
								name : 'repair_type',
								itemId : 'repair_type',
								editable : false,
								allowBlank : false,
								store : 'RepairTypes',
								valueField : 'id',
								displayField : 'text'
							}]
						}, {
							xtype : 'container',
							layout : 'hbox',
							items : [{
										xtype : 'textarea',
										fieldLabel : '诊断描述',
										name : 'problem_desc',
										itemId : 'problem_desc',
										allowBlank : false,
										flex : 1,
										height : 35
									}]
						}, {
							xtype : 'container',
							layout : 'hbox',
							items : [{
										xtype : 'numberfield',
										fieldLabel : '维修费(元)',
										name : 'repair_money',
										itemId : 'repair_money',
										allowBlank : false,
										width : 160
									}]
						}]
					}, {
						xtype : 'fieldset',
						title : '客户联络记录',
						layout : 'anchor',
						items : [{
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'combo',
												fieldLabel : '联络类别',
												name : 'contact_type',
												itemId : 'contact_type',
												editable : false,
												store : 'ContactTypes',
												valueField : 'id',
												displayField : 'text',
												width : 160
											}, {
												xtype : 'button',
												text : '加入',
												action : 'contactAdd',
												itemId : 'contactAdd',
												width : 50,
												margin : '0 0 0 10'
											},{
												xtype : 'displayfield',
												fieldLabel : '联络记录数',
												labelWidth : 80,
												itemId : 'contact_count',
												width : 100,
												value : 0
											},{
												xtype : 'button',
												text : '查看联络记录',
												action : 'viewContact',
												itemId : 'contact_show',
												margin : '0 0 0 10'
											}]
								}, {
									xtype : 'container',
									layout : 'hbox',
									items : [{
												xtype : 'textarea',
												fieldLabel : '联络内容',
												name : 'contact_content',
												itemId : 'contact_content',
												flex : 1,
												height : 35
											}]
								}]
					}, {
						xtype : 'fieldset',
						title : '客户维修意愿',
						layout : 'anchor',
						items : [{
							xtype : 'container',
							layout : 'hbox',
							items : [{
										xtype : 'combo',
										itemId : 'customChoice',
										name : 'repair_custom_choice',
										fieldLabel : '维修意愿',
										width : 150,
										editable : false,
										queryMode : 'local',
										store : new Ext.data.ArrayStore({
													fields : ['id', 'text'],
													data : [[1, '确认维修'],
															[2, '客户不修']]
												}),
										value : 1,
										valueField : 'id',
										displayField : 'text'
									}, {
										xtype : 'textfield',
										name : 'refuse_reason',
										itemId : 'noRepairReason',
										fieldLabel : '不修原因',
										hidden : true,
										flex : 1
									}]
						}]
					}, {
						xtype : 'fieldset',
						title : '故障部件',
						itemId : 'fieldsetParts',
						layout : 'anchor',
						items : [{
									xtype : 'grid',
									id : 'needComponentGrid',
									margin : '5 0 0 5',
									flex : 1,
									autoScroll : true,
									height : 100,
									draggable : false,
									store : new Ext.data.ArrayStore({
												fields : ['id',
														'component_brand',
														'component_model',
														'name', 'amount']
											}),
									columns : [{
												header : '品牌',
												dataIndex : 'component_brand',
												width : 110
											}, {
												header : '型号',
												dataIndex : 'component_model',
												width : 110
											}, {
												header : '名称',
												dataIndex : 'name',
												flex : 1
											}, {
												header : '数量',
												dataIndex : 'amount',
												width : 60
											},{
												header : '状态',
												dataIndex : 'state',
												width : 80,
												renderer : function(value){
													if(value == 0)
														return '预约中';
													else if(value == 1){
														return '申请中';
													}else if(value == 2){
														return '已领料';
													}else{
														return 'unknow';
													}
												}
											},{
												xtype : 'actioncolumn',
												width : 40,
												align : 'center',
												items:[{
													icon : 'images/icons/delete.gif',
													tooltip : '删除',
													handler : function(grid, rowIndex, colIndex){
														//TODO:删除后要加回库存
														grid.getStore().remove(grid.getStore().getAt(rowIndex));
													}
												}]
											}]
								},{
									xtype : 'component',
									html : '&nbsp;'
								}]
					}]
				}];

				this.buttons = [{
							text : '备件查询',
							action : 'searchParts',
							itemId : 'searchParts'
						}, {
							text : '暂存',
							action : 'tempSave',
							itemId : 'tempSave'
						}, {
							text : '确定',
							action : 'confirm',
							itemId : 'confirm'
						}, {
							text : '取消',
							action : 'cancel',
							itemId : 'cancel'
						}];

				this.callParent();
			}
		});