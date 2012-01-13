/**
 * 类型管理控制器
 */
Ext.define('Mbfix.controller.TypeAdmin', {
			extend : 'Ext.app.Controller',

			views : ['admin.TypeAdminBase', 'admin.CustomTypeAdmin',
					'admin.ServiceTypeAdmin', 'admin.MachineBrandAdmin',
					'admin.MachineTypeAdmin', 'admin.WarrantyTypeAdmin',
					'admin.ProblemTypeAdmin', 'admin.RepairTypeAdmin',
					'admin.ContactTypeAdmin', 'admin.ComponentBrandAdmin',
					'admin.ComponentModelAdmin', 'admin.PayTypeAdmin',
					'admin.LogisticsTypeAdmin','admin.PurchaseTypeAdmin'],
			stores : ['CustomTypes', 'MachineBrands', 'MachineTypes',
					'ServiceTypes', 'WarrantyTypes', 'MachineBrands',
					'MachineTypes', 'WarrantyTypes', 'ProblemTypes',
					'RepairTypes', 'ContactTypes', 'ComponentBrands',
					'ComponentModels', 'PayTypes', 'LogisticsTypes','PurchaseTypes'],

			init : function() {
				this.control({
							'home #menuCustomType' : {
								click : this.adminType
							},
							'home #menuServiceType' : {
								click : this.adminType
							},
							'home #menuMachineBrand' : {
								click : this.adminType
							},
							'home #menuMachineType' : {
								click : this.adminType
							},
							'home #menuWarrantyType' : {
								click : this.adminType
							},
							'home #menuProblemType' : {
								click : this.adminType
							},
							'home #menuRepairType' : {
								click : this.adminType
							},
							'home #menuContactType' : {
								click : this.adminType
							},
							'home #menuComponentBrand' : {
								click : this.adminType
							},
							'home #menuComponentModel' : {
								click : this.adminType
							},
							'home #menuPurchaseType' : {
								click : this.adminType
							},
							'home #menuPayType' : {
								click : this.adminType
							},
							'home #menuLogisticsType' : {
								click : this.adminType
							},
							'typeadmin button[action=close]' : {
								click : this.closeGridWindow
							},
							'typeadmin grid' : {
								edit : this.editGridRecord
							},
							'typeadmin button[action=typeadd]' : {
								click : this.addType
							},
							'typeadmin button[action=typedelete]' : {
								click : this.deleteType
							}
						});
			},

			/**
			 * 显示类型管理窗口
			 * 
			 * @param {Menu}
			 *            item 被点击的菜单
			 * @param {Object}
			 *            e 点击事件
			 */
			adminType : function(item, e) {
				var view = Ext.widget(item.viewName);
				view.down('grid').getStore().load();
				view.show();
			},

			/**
			 * 编辑类型时的更新动作
			 */
			editGridRecord : function(editor, e) {
				editor.record.store.sync();
			},

			/**
			 * 添加按钮事件
			 * 
			 * @param {Button}
			 *            button
			 */
			addType : function(button) {
				var grid = button.up('window').down('grid');
				var store = grid.getStore();
				store.insert(0, new Mbfix.model.CommonType());
				var rowEditing = grid.getPlugin('rowEditPlugin');
				rowEditing.cancelEdit();
				rowEditing.startEdit(0, 0);
			},

			/**
			 * 删除按钮事件
			 * 
			 * @param {Button}
			 *            button
			 */
			deleteType : function(button) {
				Ext.Msg.confirm('确认提示', '确定要删除当前记录?', function(result) {
							if (result == 'no')
								return false;
							var grid = button.up('window').down('grid');
							var rowEditing = grid.getPlugin('rowEditPlugin');
							rowEditing.cancelEdit();
							var sm = grid.getSelectionModel();
							grid.getStore().remove(sm.getSelection());
							grid.getStore().sync();
						}, this);
			},

			/**
			 * 关闭按钮事件
			 * 
			 * @param {Button}
			 *            button
			 */
			closeGridWindow : function(button) {
				button.up('window').destroy();
			}
		});