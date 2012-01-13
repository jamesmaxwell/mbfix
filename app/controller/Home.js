/**
 * 主界面控制器
 */
Ext.define('Mbfix.controller.Home', {
	extend : 'Ext.app.Controller',

	views : ['Home', 'Login', 'RecordList', 'user.RoleAdmin', 'user.UserAdmin',
			'admin.ServicePointAdmin', 'ComponentApply', 'component.ApplyList',
			'component.ComponentAccept', 'component.ComponentPurchase',
			'component.PurchaseList', 'ComponentSearch',
			'component.ComponentStockout', 'component.ComponentSotckoutList'],
	stores : ['Users', 'Notices', 'ServiceRecords', 'RecordStates', 'Roles',
			'ServicePoints', 'ComponentApplys', 'ComponentPurchases',
			'PayTypes', 'RepairComponents', 'component.ComponentStockSellfors',
			'component.ComponentStockSellTypes',
			'component.ComponentReceiptTypes', 'component.ComponentStockouts'],

	init : function() {
		this.control({
					'home button[action=record]' : {
						click : this.recordManager
					},
					'home button[action=repair]' : {
						click : this.repairList
					},
					'home button[action="search"]' : {
						click : this.repairList
					},
					'home #menuRecord' : {
						click : this.recordManager
					},
					'home #menuRepairList' : {
						click : this.repairList
					},
					'home #menuSearch' : {
						click : this.repairList
					},
					'home #menuApplyList' : {
						click : this.applyList
					},
					'home #menuStockManager' : {
						click : this.stockManager
					},
					'home #menuServicePointAdmin' : {
						click : this.servicePointAdmin
					},
					'home #menuComponentApply' : {
						click : this.applyComponent
					},
					'home #menuPurchaseList' : {
						click : this.purchaseList
					},
					'home #menuStockoutList' : {
						click : this.stockoutList
					},
					'home button[action=exit]' : {
						click : this.userLogout
					},
					'login button[action=login]' : {
						click : this.userLogin
					},
					'login button[action=reset]' : {
						click : this.resetForm
					},
					'login #servicePoint' : {
						beforequery : this.beforeServicePointQuery
					},
					'recordlist #search_button' : {
						click : this.recordSearch
					},
					'servicepointadmin grid' : {
						edit : this.servicePointSave
					},
					'servicepointadmin button[action=typeadd]' : {
						click : this.servicePointAdd
					},
					'servicepointadmin button[action=typedelete]' : {
						click : this.servicePointDelete
					},
					'componentpurchase button[action="purchase"]' : {
						click : this.submitComponentPurchase
					},
					'purchaselist button[action="accept"]' : {
						click : this.componentAccept
					},
					'componentaccept button[action="accept"]' : {
						click : this.submitComponentAccept
					},
					'applylist button[action="purchase"]' : {
						click : this.purchaseComponent
					},
					'componentsearch button[action="stock_out"]' : {
						click : this.componentStockout
					},
					'componentstockout button[action="confirm_stockout"]' : {
						click : this.confirmStockout
					},
					'componentstockout #sell_for' : {
						select : this.stockoutSellForChange
					},
					'componentstockout #receipt_type' : {
						select : this.stockoutReceiptTypeChange
					},
					'componentstockout #stockout_price' : {
						change : this.stockoutMoneyChange
					},
					'componentstockout #stockout_amount' : {
						change : this.stockoutMoneyChange
					},
					'componentstockout #stockout_discount' : {
						change : this.stockoutMoneyChange
					}
				});
	},

	/**
	 * 页面加载后马上进行用户是否登录的判断,如果没有登录,则要求立即登录.
	 */
	onLaunch : function(app) {
		var controller = this;
		Ext.Ajax.request({
			url : 'index.php?r=user/currentUser',
			success : function(response) {
				var result = Ext.JSON.decode(response.responseText);
				if (result.success) {
					// 如果成功,则把当前登录服务点保存下来.
					controller.application.currentUser = result.results[0].name;
					controller.application.currentServicePoint = result.results[0].servicePoint;
					var menus = result.menus, i, j, menuItem, 
						toolbar = Ext.getCmp('menuToolbar');
					// 添加维修菜单
					for(i=0; i<menus.length; i++){
						menuItem = { xtype : 'button', text : menus[i].text, menu : []};
						for(j=0; j<menus[i].items.length; j++){
							menuItem.menu.push({
								xtype : menus[i].items[j].xtype || 'menuitem',
								text : menus[i].items[j].text,
								itemId : menus[i].items[j].itemId
							});							
						}
						toolbar.add(menuItem);
					}
					controller.getNoticesStore().load();
				} else {
					Ext.widget('login').show();
				}
			},
			failure : function(response) {
				if(response.status == 500){
					Ext.Msg.alert('错误',response.responseText);
				}else{
					Ext.widget('login').show();
				}
			}
		});
	},

	/**
	 * 用户登录事件
	 */
	userLogin : function(button) {
		var formPanel = button.up('form');
		var controller = this;
		formPanel.getForm().submit({
					url : 'index.php?r=user/login',
					success : function(form, action) {
						formPanel.up('login').close();
						// 加载公告
						//controller.getNoticesStore().load();
						window.location.reload(true);
					},
					failure : function(form, action) {
						Ext.Msg.alert('登录失败', action.result.errors.message);
					}
				});
	},

	/**
	 * 保存服务点信息的更改
	 */
	servicePointSave : function(editor, e) {
		editor.record.store.sync();
	},

	/**
	 * 添加服务点按钮事件
	 * 
	 * @param {Button}
	 *            button
	 */
	servicePointAdd : function(button) {
		var grid = button.up('window').down('grid');
		var store = grid.getStore();
		store.insert(0, new Mbfix.model.ServicePoint());
		var rowEditing = grid.getPlugin('rowEditPlugin');
		rowEditing.cancelEdit();
		rowEditing.startEdit(0, 0);
	},

	/**
	 * 删除服务点按钮事件
	 * 
	 * @param {Button}
	 *            button
	 */
	servicePointDelete : function(button) {
		Ext.Msg.confirm('确认提示', '确定要删除当前服务点?', function(result) {
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
	 * 服务点管理
	 * 
	 * @param {Button}
	 *            button
	 */
	servicePointAdmin : function(button) {
		var view = Ext.widget('servicepointadmin');
		view.show();
		var store = this.getServicePointsStore();
		store.loadPage(1, {
					scope : this,
					callback : function(records, operation, success) {
						if (success) {
							;
						} else {
							var error = operation.getError();
							Ext.Msg.alert('错误', error.status + ' '
											+ error.statusText);
						}
					}
				});
	},

	/**
	 * 重置登录表单
	 */
	resetForm : function(button) {
		button.up('form').getForm().reset();
	},

	/**
	 * 登录界面,所在区域加载前事件
	 * 
	 * @param {Object}
	 *            qe queryEvent
	 * @param {Object}
	 *            opts other event options
	 */
	beforeServicePointQuery : function(qe, opts) {
		var username = Ext.ComponentQuery.query('#userName')[0].getValue();
		if (!Ext.isEmpty(username)) {
			qe.query = username;
		} else {
			Ext.Msg.alert('输入错误', '请先输入用户名!');
			qe.cancel = true;
		}
	},

	/**
	 * 申请备件菜单事件
	 */
	applyComponent : function(button) {
		var win = Ext.widget('componentapply');
		Ext.ComponentQuery.query('componentapply #apply_user')[0]
				.setValue(this.application.currentUser);
		Ext.ComponentQuery.query('componentapply #apply_service_point')[0]
				.setValue(this.application.currentServicePoint);
		win.show();
	},

	/**
	 * 备件采购列表
	 * 
	 * @param {Button}
	 *            button
	 */
	purchaseList : function(button) {
		var win = Ext.widget('purchaselist');
		win.down('grid').getStore().loadPage(1, {
			scope : this,
			callback : function(records, operation, success) {
				if (success) {
					win.down('grid').getSelectionModel().select(this
							.getComponentPurchasesStore().first());
				} else {
					var error = operation.getError();
					Ext.Msg.alert('错误', error.status + ' ' + error.statusText);
				}
			}
		});
		win.show();
	},

	/**
	 * 备件入库
	 * 
	 * @param {Button}
	 *            button
	 */
	componentAccept : function(button) {
		var win = Ext.widget('componentaccept');
		Ext.ComponentQuery.query('componentaccept #user')[0]
				.setValue(this.application.currentUser);
		Ext.ComponentQuery.query('componentaccept #service_point')[0]
				.setValue(this.application.currentServicePoint);
		var selModel = button.up('window').down('grid').getSelectionModel()
				.getSelection();
		if (selModel && selModel.length > 0) {
			var data = selModel[0].data;
			if (data.state != 1) {
				Ext.Msg.alert('提示', '该采购记录已入库!');
				return false;
			}
			Ext.ComponentQuery.query('componentaccept #purchase_id')[0]
					.setValue(data.id);
			Ext.ComponentQuery.query('componentaccept #store_house')[0]
					.setValue(this.application.currentServicePoint);
			Ext.ComponentQuery.query('componentaccept #purchase_amount')[0]
					.setValue(data.amount);
			Ext.ComponentQuery.query('componentaccept #real_amount')[0]
					.setValue(data.amount);
		} else {
			Ext.Msg.alert('提示', '请选择要入库的采购记录');
		}
		win.show();
	},

	/**
	 * 确认采购入库
	 * 
	 * @param {Button}
	 *            button
	 */
	submitComponentAccept : function(button) {
		button.up('window').down('form').getForm().submit({
					url : 'index.php?r=componentApply/accept',
					success : function(form, action) {
						Ext.Msg.alert('成功', '入库成功');
						button.up('window').close();
						Ext.getCmp('purchasePager').doRefresh();
					},
					failure : function(form, action) {
						Ext.Msg.alert('入库失败', action.result.errors.message);
					}
				});
	},

	/**
	 * 备件采购窗口’采购‘按钮事件
	 * 
	 * @param {Button}
	 *            button
	 */
	submitComponentPurchase : function(button) {
		button.up('window').down('form').getForm().submit({
					url : 'index.php?r=componentApply/purchase',
					success : function(form, action) {
						Ext.Msg.alert('成功', '保存成功');
						button.up('window').close();
						Ext.getCmp('componentApplyPager').doRefresh();
					},
					failure : function(form, action) {
						Ext.Msg.alert('保存失败', action.result.errors.message);
					}
				});
	},

	/**
	 * 接修登案管理界面
	 */
	recordManager : function(button) {
		if (!this.win) {
			this.win = Ext.widget('record');
		}
		var win = this.win;
		var controller = this;
		Ext.Ajax.request({
			url : 'index.php?r=common/recordNo',
			success : function(response) {
				var recordNo = response.responseText;
				if (Ext.isEmpty(recordNo)) {
					Ext.Msg.alert('错误', '工单号生成失败');
				} else {
					controller.application.currentRecordId = recordNo; // 保存当前工单号
					win.down('#recordNo').setValue(recordNo);
					win.down('#currentUser')
							.setValue(controller.application.currentUser);
					win
							.down('#currentServicePoint')
							.setValue(controller.application.currentServicePoint);
					win.show();
				}
			}
		});
	},

	/**
	 * 重置 Proxy 的其它参数
	 * 
	 * @param {Ext.data.Proxy}
	 *            proxy
	 */
	_clearExtraParams : function(proxy) {
		for (var key in proxy.extraParams) {
			proxy.extraParams[key] = null;
		}
	},

	/**
	 * 搜索服务单记录
	 * 
	 * @param {Ext.data.Store}
	 *            store 服务单Store
	 * @param {Function}
	 *            afterCallback 加载成功后的回调
	 */
	_loadRecordList : function(store, afterCallback) {
		store.loadPage(1, {
					scope : this,
					callback : function(records, operation, success) {
						if (success) {
							// 执行回调
							if (Ext.isFunction(afterCallback))
								afterCallback.call(this);
						} else {
							var error = operation.getError();
							Ext.Msg.alert('错误', error.status + ' '
											+ error.statusText);
						}
					}
				});
	},

	/**
	 * 点击'待修列表'的查询按钮事件,根据条件加载服务单
	 * 
	 * @param {Button}
	 *            button 查询按钮
	 */
	recordSearch : function(button) {
		var store = this.getServiceRecordsStore();
		var proxy = store.getProxy();
		this._clearExtraParams(proxy); // 先重置参数
		var recordNo = Ext.getCmp('search_recordNo').getValue();
		// 因为工单号是唯一的,所有当有该值时不进行其它值处理
		if (!Ext.isEmpty(recordNo)) {
			proxy.extraParams.recordNo = recordNo;
			this._loadRecordList(store);
			return;
		}
		var fixer = Ext.getCmp('search_fixer').getValue(), beginDate = Ext
				.getCmp('search_beginDate').getValue(), endDate = Ext
				.getCmp('search_endDate').getValue(), recordState = Ext
				.getCmp('search_state').getValue();
		if (!Ext.isEmpty(fixer)) {
			proxy.extraParams.fixer = fixer;
		}
		if (!Ext.isEmpty(beginDate)) {
			proxy.extraParams.beginDate = beginDate;
		}
		if (!Ext.isEmpty(endDate)) {
			proxy.extraParams.endDate = endDate;
		}
		if (!Ext.isEmpty(recordState)) {
			proxy.extraParams.recordState = recordState;
		}
		this._loadRecordList(store);
	},

	/**
	 * 点击'待修列表' 按钮事件, 弹出待修列表窗口
	 * 
	 * @param {Button}
	 *            button 待修列表按钮或综合查询按钮
	 */
	repairList : function(button) {
		var repairWin = Ext.widget('recordlist');
		// 如果是待修列表,则加载'处理中'的服务单,否则不加载
		var store = this.getServiceRecordsStore();
		this._clearExtraParams(store.getProxy()); // 重置置参数
		if (button.action == 'repair') {
			var recordStates = this.getRecordStatesStore();
			var inProcessIndex = recordStates.find('name', '处理中');
			if (inProcessIndex != -1) {
				var state = recordStates.getAt(inProcessIndex).data.state;
				Ext.getCmp('search_state').setValue(state);
				store.getProxy().extraParams.recordState = state;
			}
			this._loadRecordList(store, function() {
						// 选中第一行
						repairWin.down('grid').getSelectionModel().select(this
								.getServiceRecordsStore().first());
					});

		} else {
			store.removeAll();
		}
		repairWin.show();
	},

	/**
	 * 备件申请车列表
	 */
	applyList : function(button) {
		var win = Ext.widget('applylist');
		win.show();
		this.getComponentApplysStore().loadPage(1, {
			scope : this,
			callback : function(records, operation, success) {
				if (success) {
					win.down('grid').getSelectionModel().select(this
							.getComponentApplysStore().first());
				} else {
					var error = operation.getError();
					Ext.Msg.alert('错误', error.status + ' ' + error.statusText);
				}
			}
		});
	},

	/**
	 * 采购记录确认，按钮事件,显示备件采购窗口
	 * 
	 * @param {Button}
	 *            button
	 */
	purchaseComponent : function(button) {
		var win = Ext.widget('componentpurchase');
		var selModel = button.up('window').down('grid').getSelectionModel()
				.getSelection();
		if (selModel && selModel.length > 0) {
			var data = selModel[0].data;
			// 只有在‘申请中’状态的申请才能进行采购，否则表示已经采购了
			// 0=申请中
			if (data.state != 0) {
				Ext.Msg.alert('提示', '只有状态为申请中的申请单才能进行采购动作');
				return false;
			}
			win.down('#apply_amount').setValue(data.amount);
			win.down('#apply_id').setValue(data.id);
			Ext.ComponentQuery.query('componentpurchase #buyer')[0]
					.setValue(this.application.currentUser);
			Ext.ComponentQuery.query('componentpurchase #service_point')[0]
					.setValue(this.application.currentServicePoint);
		} else {
			Ext.Msg.alert('提示', '请选择申请列表中的记录再确认采购!');
			return false;
		}
		win.show();
	},

	/**
	 * 库房管理
	 */
	stockManager : function(button) {
		var win = Ext.widget('componentsearch');
		// 菜单中的‘库存查询’不需要显示‘选择’按钮
		win.down('#confirm').hide();
		win.down('#stock_out').show();
		win.show();
	},

	/**
	 * 备件出库列表
	 */
	stockoutList : function(button) {
		var win = Ext.widget('componentstockoutlist');
		win.show();
		win.down('grid').getStore().loadPage(1, {
					scope : this,
					callback : function(records, operation, success) {
						if (success) {
							;
						} else {
							var error = operation.getError();
							Ext.Msg.alert('错误', error.status + ' '
											+ error.statusText);
						}
					}
				});
	},

	/**
	 * 备件出库窗口
	 * 
	 * @param {Button}
	 *            button
	 */
	componentStockout : function(button) {
		var grid = button.up('window').down('grid');
		var selection = grid.getSelectionModel().getSelection();
		if (selection.length == 0) {
			Ext.Msg.alert('错误', '先选择要出库的备件!');
			return false;
		}
		if (selection[0].data.amount <= 0) {
			Ext.Msg.alert('错误', '备件库存不足，无法出库');
			return false;
		}
		var data = selection[0].data;
		var win = Ext.widget('componentstockout');
		win.down('#component_id').setValue(data.id);
		win.down('#stockout_amount').setMaxValue(data.amount);
		win.down('#user').setValue(this.application.currentUser);
		win.down('#service_point')
				.setValue(this.application.currentServicePoint);
		win.show();
	},

	/**
	 * 确认备件出库
	 * 
	 * @param {Button}
	 *            button
	 */
	confirmStockout : function(button) {
		button.up('window').down('form').getForm().submit({
					url : 'index.php?r=componentApply/stockout',
					success : function(form, action) {
						Ext.Msg.alert('成功', '保存成功');
						button.up('window').close();
						Ext.getCmp('repair_component_pager').doRefresh();
					},
					failure : function(form, action) {
						Ext.Msg.alert('保存失败', action.result.errors.message);
					}
				});
	},

	/**
	 * 备件出库中的出库类型变更。当选择’销售‘时，可以不输入’工单号‘，’维修‘时必须输入。
	 * 
	 * @param {}
	 *            combo
	 * @param {}
	 *            records
	 */
	stockoutSellForChange : function(combo, records) {
		var form = combo.up('form');
		var id = records[0].data.id;
		if (id == 1) {
			// 1=销售
			form.down('#record_no').disable();
		} else if (id == 2) {
			// 2=维修
			form.down('#record_no').enable();
		} else {
			alert('没有相关处理方法')
		}
	},

	/**
	 * 收款情况状态变更，’未收款‘时可以不填写，’收款方式‘，’收款人‘及’收款账户‘的信息。
	 * 
	 * @param {}
	 *            combo
	 * @param {}
	 *            records
	 */
	stockoutReceiptTypeChange : function(combo, records) {
		var form = combo.up('form');
		var id = records[0].data.id;
		if (id == 1) {
			// 1=未收款
			form.down('#receiver').disable();
			form.down('#pay_type').disable();
			form.down('#receipt_account').disable();
		} else if (id == 2) {
			// 2=已收款
			form.down('#receiver').enable();
			form.down('#pay_type').enable();
			form.down('#receipt_account').enable();
		} else {
			alert('未实现');
		}
	},

	/**
	 * 出库单价，出库数量和优惠金额字段的变更时，都要计算总价
	 * 
	 * @param {}
	 *            field
	 * @param {}
	 *            newValue
	 * @param {}
	 *            oldValue
	 */
	stockoutMoneyChange : function(field, newValue, oldValue) {
		var form = field.up('form');
		var allPriceField = form.down('#stockout_allprice'), price = form
				.down('#stockout_price').getValue(), amount = form
				.down('#stockout_amount').getValue(), discount = form
				.down('#stockout_discount').getValue();
		if (price) {
			allPriceField.setValue(price * amount - discount);
		}
	},

	/**
	 * 用户退出事件
	 */
	userLogout : function(button) {
		Ext.Ajax.request({
					url : 'index.php?r=user/logout',
					success : function(response) {
						// ֱ直接刷新页面
						window.location.reload(true);
					}
				});
	}
});