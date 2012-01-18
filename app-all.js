/*
Copyright(c) 2011 Company Name
*/
Ext.Loader.setConfig({
			enabled : true
		});

Ext.application({
			name : 'Mbfix',
			appFolder : 'app',
			autoCreateViewport : true,

			statics : {
				/**
				 * 自定义属性, 当前登录用户名
				 * 
				 * @type string
				 */
				currentUser : null,

				/**
				 * 自定义属性, 当前登录服务点中文
				 * 
				 * @type
				 */
				currentServicePoint : null,

				/**
				 * 全局保存当前服务单编号
				 * 
				 * @type Number
				 */
				currentRecordId : 0
			},

			controllers : ['Home', 'User', 'Record', 'TypeAdmin', 'Repair', 'Finance']
		});
/**
 * 账务相关控制器
 */
Ext.define('Mbfix.controller.Finance', {
	extend : 'Ext.app.Controller',

	views : ['Home', 'finance.FundApply', 'finance.FundApplyList',
			'finance.FundVerify', 'finance.Payout', 'finance.PayoutList',
			'finance.TurnoverIncome','finance.TurnoverIncomeList'],
	stores : ['finance.FundRecords', 'finance.FundApplyStates',
			'finance.FundPayTypes', 'finance.TicketTypes','finance.Payouts',
			'finance.TurnoverIncomes'],

	init : function() {
		this.control({
					'home #menuFundApply' : {
						click : this.showFundApply
					},
					'home #menuFundVerify' : {
						click : this.showFundApplyList
					},
					'home #menuPayout' : {
						click : this.showPayout
					},
					'home #menuPayoutDetail' : {
						click : this.showPayoutDetails
					},
					'home #menuTurnover':{
						click : this.showTurnover
					},
					'home #menuAccountVerify' : {
						click : this.turnoverIncomeList
					},
					'fundapply button[action="confirm_apply"]' : {
						click : this.confirmFundApply
					},
					'fundapplylist grid' : {
						itemdblclick : this.fundItemDbClick
					},
					'fundverify button[action="confirm_verify"]' : {
						click : this.confirmVerify
					},
					'payout button[action="confirm_payout"]' : {
						click : this.confirmPayout
					},
					'turnoverincome button[action="confirm_income"]' : {
						click : this.confirmTurnoverIncome
					}
				});
	},

	/**
	 * 款项申请窗口
	 */
	showFundApply : function(button) {
		var win = Ext.widget('fundapply');
		win.down('#user_id').setValue(this.application.currentUser);
		win.down('#service_point_id')
				.setValue(this.application.currentServicePoint);
		win.show();
	},

	/**
	 * 确定申请款项
	 */
	confirmFundApply : function(button) {
		button.up('window').down('form').getForm().submit({
					url : 'index.php?r=finance/fundApply',
					success : function(form, action) {
						Ext.Msg.alert('成功', '申请成功');
						button.up('window').close();
					},
					failure : function(form, action) {
						Ext.Msg.alert('失败', action.result.errors.message);
					}
				});
	},

	/**
	 * 显示款项申请列表
	 * 
	 * @param {}
	 *            button
	 */
	showFundApplyList : function(button) {
		var win = Ext.widget('fundapplylist');
		win.show();
		win.down('grid').getStore().loadPage(1, {
					scope : this,
					callback : function(records, response, opts) {
						;
					}
				});
	},

	fundItemDbClick : function(view, record, html, index, evt) {
		var data = record.data;
		var state = data.state;
		if (state == 1 || state == 2) {
			// 如果是等待审核状态=1或审核通过状态=2,则弹出审核款项窗口
			// 但审核通过状态时,不能修改
			var win = Ext.widget('fundverify');
			win.down('#fund_id').setValue(data.id);
			win.down('#user_id').setValue(this.application.currentUser);
			win.down('#service_point_id')
					.setValue(this.application.currentServicePoint);
			win.down('#verify_amount').setValue(data.apply_amount);
			win.down('#verify_amount').setMaxValue(data.apply_amount);
			if (state == 2) {
				win.down('#verify_amount').setValue(data.verify_amount);
				win.down('#pay_type').setValue(data.pay_type);
				win.down('#pay_account').setValue(data.pay_account);
				win.down('#receiver_account').setValue(data.receiver_account);
				win.down('#receiver').setValue(data.receiver);
				win.down('#verify_notes').setValue(data.verify_notes);
				win.down('button[action="confirm_verify"]').disable();
				Ext.Array.forEach(win.down('form').query('textfield'),
						function(field) {
							field.disable();
						});
			}
			win.show();
		} else if (state == 3) {
			// 如果是审核拒绝=3,则弹出审核信息
		} else {
			alert('未知审核状态');
		}
	},

	/**
	 * 确认审核通过
	 * 
	 * @param {}
	 *            button
	 */
	confirmVerify : function(button) {
		button.up('window').down('form').getForm().submit({
					url : 'index.php?r=finance/fundVerify',
					success : function(form, action) {
						Ext.Msg.alert('成功', '审核成功');
						button.up('window').close();
						Ext.getCmp('fundApplyListPaging').doRefresh();
					},
					failure : function(form, action) {
						Ext.Msg.alert('失败', action.result.errors.message);
					}
				});
	},

	/**
	 * 显示费用支出
	 */
	showPayout : function(button) {
		var win = Ext.widget('payout');
		win.down('#user_id').setValue(this.application.currentUser);
		win.down('#service_point_id')
				.setValue(this.application.currentServicePoint);
		Ext.Ajax.request({
			url : 'index.php?r=finance/availableFund',
			success : function(response) {
				var fund = response.responseText;
				win.down('#available_fund').setValue(fund);
				win.down('#payout_amount').setMaxValue(fund);
				win.show();
			},
			failure : function(response) {
				Ext.Msg.alert('错误',response.responseText);
			}
		});
	},

	/**
	 * 确认费用支出
	 * 
	 * @param {}
	 *            button
	 */
	confirmPayout : function(button) {
		button.up('window').down('form').getForm().submit({
					url : 'index.php?r=finance/payout',
					success : function(form, action) {
						Ext.Msg.alert('成功', '费用支出保存成功');
						button.up('window').close();
					},
					failure : function(form, action) {
						Ext.Msg.alert('失败', action.result.errors.message);
					}
				});
	},
	
	/**
	 * 显示费用支出明细
	 * @param {} button
	 */
	showPayoutDetails : function(button){
		var win = Ext.widget('payoutlist');
		win.show();
		win.down('grid').getStore().loadPage(1, {
					scope : this,
					callback : function(records, response, opts) {
						;
					}
				});
	},
	
	/**
	 * 显示增加营业款收入窗口
	 * @param {} button
	 */
	showTurnover : function(button){
		var win = Ext.widget('turnoverincome');
		win.down('#user_id').setValue(this.application.currentUser);
		win.down('#service_point_id')
				.setValue(this.application.currentServicePoint);
		win.show();
	},
	
	/**
	 * 确定增加营业款收入
	 * @param {} button
	 */
	confirmTurnoverIncome : function(button){
		button.up('window').down('form').getForm().submit({
					url : 'index.php?r=finance/turnoverIncome',
					success : function(form, action) {
						Ext.Msg.alert('成功', '营业款收入保存成功');
						button.up('window').close();
					},
					failure : function(form, action) {
						Ext.Msg.alert('失败', action.result.errors.message);
					}
				});
	},
	
	/**
	* 营业款收入列表(财务核销)窗口
	*/
	turnoverIncomeList : function(button){
		var win = Ext.widget('turnoverincomelist');
		win.show();
		win.down('grid').getStore().loadPage(1, {
					scope : this,
					callback : function(records, response, opts) {
						;
					}
				});
	}
});
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
					var menus = result.menus, i, j, menuItem, key, item, toolbar = Ext
							.getCmp('menuToolbar');
					// 添加维修菜单
					for (i = 0; i < menus.length; i++) {
						menuItem = {
							xtype : 'button',
							text : menus[i].text,
							menu : []
						};
						for (j = 0; j < menus[i].items.length; j++) {
							item = {};
							for (key in menus[i].items[j]) {
								item[key] = menus[i].items[j][key];
							}
							if (!item['xtype'])
								item['xtype'] = 'menuitem';

							menuItem.menu.push(item);
						}
						toolbar.add(menuItem);
					}
					controller.getNoticesStore().load();
				} else {
					Ext.widget('login').show();
				}
			},
			failure : function(response) {
				if (response.status == 500) {
					Ext.Msg.alert('错误', response.responseText);
				} else {
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
						// controller.getNoticesStore().load();
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
/**
 * 服务单主控件器
 */
Ext.define('Mbfix.controller.Record', {
	extend : 'Ext.app.Controller',

	views : ['Record', 'RecordList', 'Repair', 'FinishRecord', 'component.ApplyList'],
	stores : ['CustomTypes', 'ServiceRecords', 'ServicePoints', 'RecordStates', 'ComponentApplys'],

	init : function() {
		this.control({					
					'record button[action=comfirm]' : {
						click : this.recordConfirm
					},
					'record button[action=cancel]' : {
						click : this.recordCancel
					},
					'record button[action=serialCheck]' : {
						click : this.serialCheck
					},
					'recordlist grid' : {
						selectionchange : this.recordListSelected,
						itemdblclick : this.recordDoubleClick
					},					
					'finishrecord #fetch_type' : {
						select : this.fetchTypeChange
					},
					'finishrecord button[action="finish"]' : {
						click : this.finishClick
					}
				});
	},

	/**
	 * 确定 接修登案 窗口
	 */
	recordConfirm : function(button) {
		var controller = this;
		var form = button.up('window').down('form').getForm();
		var mobile =  button.up('window').down('#custom_mobile');
		var phone = button.up('window').down('#custom_phone');
		if(Ext.isEmpty(mobile.getValue()) && Ext.isEmpty(phone.getValue())){
			mobile.markInvalid('手机和固定电话两个必须填一个!');
			return;
		}
		var serialNumber = button.up('window').down('#serialNumber');
		var snid = button.up('window').down('#machine_snid');
		if(Ext.isEmpty(serialNumber.getValue()) && Ext.isEmpty(snid.getValue())){
			serialNumber.markInvalid('序列号和SNID两个必须填一个!');
			return;
		}
		form.submit({
					clientValidation : true,
					url : 'index.php?r=serviceRecord/add',
					success : function(form, action) {
						Ext.Msg.alert('成功', '添加服务单成功.', function() {
									button.up('window').close();
								});
					},
					failure : function(form, action) {
						Ext.Msg.alert('错误', action.result.errors.message);
					}
				});
	},

	/**
	 * 取消 接修改登案 窗口
	 */
	recordCancel : function(button) {
		button.up('window').down('form').getForm().reset();
		button.up('window').hide();
	},

	/**
	 * 点击'检测' 序列号的动作
	 * 
	 * @param {Button}
	 *            button
	 */
	serialCheck : function(button) {
		var serialNo = button.up('form').down('#serialNumber').getValue();
		alert(serialNo);
	},

	/**
	 * 待修列表选择事件
	 * 
	 * @param {Ext.selection.Model}
	 *            sm
	 * @param {Ext.data.Model}
	 *            selectedRecord
	 */
	recordListSelected : function(sm, selectedRecord) {
		if (selectedRecord.length) {
			var detailPanel = Ext.getCmp('detailRecordPanel');
			detailPanel.update(selectedRecord[0].data);
		}
	},

	/**
	 * 双击待修列表中服务单记录的事件
	 * 
	 * @param {}
	 *            view
	 * @param {Ext.data.Model}
	 *            record 当前被双击的记录模型
	 * @param {}
	 *            html
	 * @param {}
	 *            index
	 * @param {}
	 *            evt
	 */
	recordDoubleClick : function(view, record, html, index, evt) {
		this.application.currentRecordId = record.data.id; // 保存全局的服务号编号
		// 读取当前记录号的故障诊断信息,并初始化
		Ext.Ajax.request({
			url : 'index.php?r=repairRecord/item',
			params : {
				recordId : record.data.id
			},
			success : function(response, opts) {
				var obj = Ext.decode(response.responseText);
				if (obj.success) {
					// 8=已修复, 对于已修复的机器,弹出'客户取机'窗口而不是故障诊断窗口
					if (record.data.record_state == 8) {
						Ext.widget('finishrecord').show();
						return;
					}

					var repairWin = Ext.widget('repair');
					var result = obj.results[0];
					repairWin.down('#repair_judge')
							.setValue(result.judge_result);
					repairWin.down('#problem_type').getStore().load({
						callback : function(records, operation, success) {
							repairWin.down('#problem_type')
									.setValue(result.problem_type);
						}
					});
					repairWin.down('#repair_type').getStore().load({
						callback : function(records, operation, success) {
							repairWin.down('#repair_type')
									.setValue(result.repair_type);
						}
					});
					repairWin.down('#problem_desc')
							.setValue(result.problem_desc);
					repairWin.down('#repair_money').setValue(result.fix_money);
					repairWin.down('#contact_count').setValue(obj.contactCount);
					repairWin.down('#customChoice')
							.setValue(result.custom_decide);
					// 加入维修部件
					var cmpGrid = Ext.getCmp('needComponentGrid'), cmpGridStore = cmpGrid
							.getStore(), repairCmp;
					for (var i = 0; i < obj.repairComponents.length; i++) {
						repairCmp = obj.repairComponents[i];
						cmpGridStore.add({
									'id' : repairCmp.component_id,
									'component_brand' : repairCmp.brand_name,
									'component_model' : repairCmp.model_name,
									'name' : repairCmp.name,
									'amount' : repairCmp.component_amount,
									'state' : repairCmp.state
								});
					}

					if (result.custom_decide == 2) { // 客户不修
						repairWin.down('#noRepairReason').show();
						repairWin.down('#noRepairReason')
								.setValue(result.refuse_reason);
						cmpGrid.disable();
					}
					// 如果是客户不修(4),无法修复(7),已修复(8),已结案(9),不能进行保存操作
					if (record.data.record_state == 4
							|| record.data.record_state == 7
							|| record.data.record_state == 8
							|| record.data.record_state == 9) {
						repairWin.down('#searchParts').disable();
						repairWin.down('#tempSave').disable();
						repairWin.down('#confirm').disable();
						repairWin.down('#repair_judge').disable();
						repairWin.down('#customChoice').disable();
						repairWin.down('#contactAdd').disable();
						repairWin.down('#problem_type').disable();
						repairWin.down('#repair_type').disable();
						repairWin.down('#problem_desc').disable();
						repairWin.down('#repair_money').disable();
						repairWin.down('#contact_type').disable();
						repairWin.down('#contact_content').disable();
						cmpGrid.disable();
					}
					repairWin.show();
				} else {
					// 处理中的服务单
					if (record.data.record_state == 1) {
						Ext.widget('repair').show();
					} else {
						Ext.Msg.alert('错误', obj.errors.message);
					}
				}
			},
			failure : function(response, opts) {
				Ext.Msg.alert('错误', response.responseText);
				return false;
			}
		});
	},

	/**
	 * 客户取机类型变更
	 */
	fetchTypeChange : function(combo, records, opts) {
		if (records[0].data.id == 2) {
			combo.up('form').down('#logistics_fieldset').enable();
		} else {
			combo.up('form').down('#logistics_fieldset').disable();
		}
	},

	/**
	 * 客户结案按钮事件
	 */
	finishClick : function(button) {
		button.up('window').down('form').submit({
					url : 'index.php?r=serviceRecord/finish',
					params : {
						recordId : this.application.currentRecordId
					},
					success : function(form, action) {
						Ext.Msg.alert('成功', '结案成功');
						button.up('window').close();
						Ext.getCmp('recordListPaging').doRefresh(); // 刷新服务单记录列表
					},
					failure : function(form, action) {
						Ext.Msg.alert('错误', action.result.errors.message);
					}
				});
	},


});
/**
 * 维修信息控制器
 */
Ext.define('Mbfix.controller.Repair', {
	extend : 'Ext.app.Controller',

	views : ['Repair', 'ComponentSearch', 'ComponentApply', 'RecordList',
			'CustomContactList'],
	stores : ['RepairComponents', 'ComponentApplys', 'CustomContacts'],

	init : function() {
		this.control({
					'repair button[action="cancel"]' : {
						click : this.cancelRepair
					},
					'repair #customChoice' : {
						select : this.customChoiceSelect
					},
					'repair #repair_judge' : {
						select : this.repairJudgeSelect
					},
					'repair button[action="searchParts"]' : {
						click : this.componentQuery
					},
					'repair button[action="contactAdd"]' : {
						click : this.addCustomContact
					},
					'repair button[action="confirm"]' : {
						click : this.confirmRepair
					},
					'repair button[action="tempSave"]' : {
						click : this.confirmRepair
					},
					'repair button[action="viewContact"]' : {
						click : this.showCustomContact
					},
					'componentsearch button[action=search]' : {
						click : this.queryRepairComponent
					},
					'componentsearch button[action="close"]' : {
						click : this.closeComponentSearch
					},
					'componentsearch button[action="confirm"]' : {
						click : this.confirmComponentSearch
					},
					'componentsearch button[action="apply"]' : {
						click : this.showApplyComponentWindow
					},
					'componentapply button[action="close"]' : {
						click : this.closeApplyWindow
					},
					'componentapply button[action="apply"]' : {
						click : this.applyComponent
					}
				});
	},

	/**
	 * 取消按钮事件
	 */
	cancelRepair : function(button) {
		button.up('window').close();
	},

	/**
	 * 客户维修意愿选择事件
	 */
	customChoiceSelect : function(combo, records, opts) {
		var form = combo.up('form');
		// 如果用户选择不修,则必须填写不修原因
		if (records[0].data.id == 2) {
			form.down('#noRepairReason').show();
			form.down('#fieldsetParts').disable();
			form.up('window').down('button[action="searchParts"]').disable();
			form.up('window').down('button[action="tempSave"]').disable();
		} else {
			form.down('#noRepairReason').hide();
			form.down('#fieldsetParts').enable();
			form.up('window').down('button[action="searchParts"]').enable();
			form.up('window').down('button[action="tempSave"]').enable();
		}
	},

	/**
	 * 维修故障诊断下拉列表选择事件, 如果选择未发现故障,则后面的故障类别和维修方式可以不填写.
	 * 
	 * @param {Button}
	 *            button
	 */
	repairJudgeSelect : function(combo, records, opts) {
		var form = combo.up('form');
		if (records[0].data.id == 2) {
			// 选择'未发现故障-NTF'
			form.down('#fieldsetParts').disable();
			form.down('#problem_type').disable();
			form.down('#repair_type').disable();
		} else {
			// 发现故障
			form.down('#fieldsetParts').enable();
			form.down('#problem_type').enable();
			form.down('#repair_type').enable();
		}
	},

	/**
	 * 查询配件按钮事件
	 */
	componentQuery : function(button) {
		var queryWin = Ext.widget('componentsearch');
		queryWin.show();
	},

	/**
	 * 配件搜索窗口中的搜索按钮点击事件
	 */
	queryRepairComponent : function(button) {
		var form = button.up('form');
		var store = form.down('grid').getStore();
		var proxy = store.getProxy();

		proxy.extraParams.component_brand = form.down('#component_brand')
				.getValue();
		proxy.extraParams.component_model = form.down('#component_model')
				.getValue();
		proxy.extraParams.component_name = form.down('#component_name')
				.getValue();
		proxy.extraParams.service_point = form.down('#service_point').getValue();
		store.loadPage(1);
	},

	/**
	 * 关闭备件搜索窗口
	 */
	closeComponentSearch : function(button) {
		button.up('window').close();
	},

	/**
	 * 客户联系记录'加入'按钮事件
	 * 
	 * @param {}
	 *            button
	 */
	addCustomContact : function(button) {
		var objContactType = button.up('window').down('#contact_type');
		var objContactContent = button.up('window').down('#contact_content');
		var contactType = objContactType.getValue();
		var contactContent = objContactContent.getValue();
		var valid = true;
		if (Ext.isEmpty(contactType)) {
			objContactType.markInvalid('this field is required');
			valid = false;
		}
		if (Ext.isEmpty(contactContent)) {
			objContactContent.markInvalid('this field is required');
			valid = false;
		}
		if (valid) {
			var objContactCount = button.up('window').down('#contact_count');
			Ext.Ajax.request({
						url : 'index.php?r=customContact/add',
						scope : this,
						params : {
							record_id : this.application.currentRecordId, // 服务单编号
							contact_type : contactType, // 客户联系方式
							contact_content : contactContent
							// 客户联系内容
						},
						success : function(response, options) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								// 保存成功后，要给个反馈
								objContactCount.setValue(Ext.Number.from(
										objContactCount.getValue(), 0)
										+ 1);
								objContactCount.enable();
								button.up('window').down('#contact_show')
										.enable();
							} else {
								Ext.Msg.alert('错误', result.errors.message);
							}
						},
						failure : function(response, options) {
							Ext.Msg.alert('错误', response.responseText);
						}
					});
		}
	},

	/**
	 * 申请备件按钮事件
	 */
	showApplyComponentWindow : function(button) {
		var applyWin = Ext.widget('componentapply');
		Ext.ComponentQuery.query('componentapply #apply_user')[0]
				.setValue(this.application.currentUser);
		Ext.ComponentQuery.query('componentapply #apply_service_point')[0]
				.setValue(this.application.currentServicePoint);
		applyWin.show();
	},

	/**
	 * 关闭备件申请窗口
	 * 
	 * @param {}
	 *            button
	 */
	closeApplyWindow : function(button) {
		button.up('window').close();
	},

	/**
	 * 申请备件'申请'按钮事件
	 * 
	 * @param {}
	 *            button
	 */
	applyComponent : function(button) {
		var win = button.up('window'), form = win.down('form'), brandObj = form
				.down('#component_brand'), brand = brandObj
				.findRecordByValue(brandObj.getValue()).data['text'], modelObj = form
				.down('#component_model'), model = modelObj
				.findRecordByValue(modelObj.getValue()).data['text'], amount = form
				.down('#component_amount').getValue(), name = form
				.down('#component_name').getValue();

		win.down('form').getForm().submit({
			url : 'index.php?r=componentApply/apply',
			success : function(form, action) {
				Ext.Msg.alert('成功', '申请备件成功');
				var componentId = action.result.results[0].component_id;
				// 添加申请的备件记录
				var grid = Ext.getCmp('needComponentGrid');
				if (grid) {
					var compGridStore = grid.getStore();				
					var index = compGridStore.findBy(function(record, id) {
								if (id == 0
										&& brand == record.data.component_brand
										&& model == record.data.component_model
										&& name == record.data.name) {
									return true;
								}
							}, this);

					if (index == -1) {
						compGridStore.add({
									'id' : componentId,
									'component_brand' : brand,
									'component_model' : model,
									'name' : name,
									'amount' : amount,
									'state' : 1
								});
					} else {
						var existRecord = compGridStore.getAt(index);
						existRecord.set('amount', existRecord.get('amount')
										+ amount);
					}
				}
				win.close();
			},
			failure : function(form, action) {
				Ext.Msg.alert('申请失败', action.result.errors.message);
			}
		});
	},

	/**
	 * 备件搜索窗口确定按钮 TODO: 库存数量的问题,还需要加判断,比如在多用户环境下的并发问题
	 */
	confirmComponentSearch : function(button) {
		var selectedModel = button.up('window').down('grid')
				.getSelectionModel();
		if (selectedModel.getCount() == 0) {
			Ext.Msg.alert('选择错误', '请选择维修备件!');
		} else {
			var selCmp = selectedModel.selected.first().data;
			if (selCmp.amount == 0) {
				Ext.Msg.alert('数量错误', '当前备件库存不足,请先申请备件!');
				return;
			}
			var selectedComponent = Ext.clone(selCmp);
			var compGridStore = Ext.getCmp('needComponentGrid').getStore();
			var existRecord = compGridStore.findRecord('id',
					selectedComponent.id);
			if (!existRecord) {
				selectedComponent.amount = 1;
				selectedComponent.state = 0; // 有库存
				compGridStore.add(selectedComponent);
			} else {
				existRecord.set('amount', existRecord.get('amount') + 1);
			}
			selCmp.amount -= 1;
			button.up('window').hide();
		}
	},

	/**
	 * 确定或暂存故障诊断事件, 确定后不能再修改该故障诊断记录,暂存后可以修改.
	 * 
	 * @param {Button}
	 *            button
	 */
	confirmRepair : function(button) {
		var form = button.up('window').down('form');
		if (form.getForm().isValid()) {
			Ext.Msg.confirm('确认', '"确定"后不能再修改了, 如果接下来还要修改,请选择"暂存". 是否确定?',
					function(buttonId) {
						if (buttonId == 'yes') {
							var cmpStore = form.down('#needComponentGrid')
									.getStore(), cmpObj = [], item;
							for (var i = 0; i < cmpStore.getCount(); i++) {
								item = cmpStore.getAt(i);
								cmpObj.push(item.data.id + ':'
										+ item.data.amount + ':'
										+ item.data.state);
							}
							form.getForm().submit({
								url : 'index.php?r=repairRecord/save',
								params : {
									repairCmps : cmpObj.join(','),
									recordId : this.application.currentRecordId,
									buttonAction : button.action
								},
								success : function(form, action) {
									Ext.Msg.alert('成功', '保存成功', function() {
												button.up('window').close();
												Ext.getCmp('recordListPaging')
														.doRefresh(); // 刷新服务单记录列表
											}, this);
								},
								failure : function(form, action) {
									Ext.Msg.alert('保存失败',
											action.result.errors.message,
											function() {
												button.up('window').close();
											}, this);
								}
							});
						}
					}, this);
		}
	},

	/**
	 * 显示客户联络详细信息
	 * 
	 * @param {Button}
	 *            button
	 */
	showCustomContact : function(button) {
		var contactList = Ext.widget('customcontact');
		var store = contactList.down('grid').getStore();
		store.getProxy().extraParams.recordId = this.application.currentRecordId;
		store.load();
		contactList.show();
	}

});
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
/**
* 用户角色管理相关控件器
*/
Ext.define('Mbfix.controller.User',{
	extend : 'Ext.app.Controller',
	
	views : ['Home', 'user.UserAdmin'],
	stores : ['Users', 'Roles', 'ServicePoints'],
	
	init : function(){
		this.control({
				'home #menuRoleAdmin' : {
					click : this.roleAdmin
				},
				'home #menuUserAdmin' : {
					click : this.userAdmin
				},
				'useradmin grid' : {
					edit : this.userUpdate,
					afterrender : this.userAfterRender
				},
				'useradmin button[action="useradd"]' : {
					click : this.userAdd
				},
				'useradmin button[action="userdelete"]' : {
					click : this.userDelete
				}
		});
	},
	
	/**
	 * 编辑grid时，显示下拉框中选择的文本而不是值
	 * @param {Array} value 当前选中的值，可能多个
	 * @param {Ext.data.Store} store 要从哪个Store取原始值
	 * @param {string} findField 要从Store中查找的键名称
	 * @param {string} nameField 要显示的字段名称
	 * @return {string} 以','分隔的字符串
	 */
	/*
	_getComboValue : function(value, store,findField, nameField){
		var vals = [], record, values = Ext.isArray(value) ? value : [value];
		for (var i = 0; i < values.length; i++) {
			record = store.findRecord(findField, values[i]);
			if (record != null) {
				vals.push(record.data.nameField);
			} else {
				vals.push(values[i]);
			}
		}
		return vals.join(',');
	},
	*/
	
	/**
	 * 用户角色管理
	 * 
	 * @param {Button}
	 *            button
	 */
	roleAdmin : function(button) {
		Ext.widget('user.roleadmin').show();
	},

	/**
	 * 用户管理
	 * 
	 * @param {Button}
	 *            button
	 */
	userAdmin : function(button) {
		var win = Ext.widget('useradmin');
		win.show();
		var store = win.down('grid').getStore();
		store.loadPage(1, {
					scope : this,
					callback : function(records, response, opts) {
						// alert(response.responseText);
					}
				})
	},
	
	/**
	* 加载用户Grid控件后触发，显示后立即加载角色Store
	*/
	userAfterRender : function(cmp, opts){
		this.getRolesStore().load();
	},
	
	/**
	* 编辑用户触发的事件
	* @param {Ext.grid.plugin.Editing} editor 编辑插件引用
	* @param {Ojbect} e 一个编辑事件参数
	* @param {Object} opts 其它事件参数
	*/
	userUpdate : function(editor, e, opts){
		editor.record.store.sync();
	},
	
	/**
	* 添加用户
	*/
	userAdd : function(button){
		var grid = button.up('window').down('grid');
		var store = grid.getStore();
		store.insert(0, new Mbfix.model.User());
		var rowEditing = grid.getPlugin('userRowEditPlugin');
		rowEditing.cancelEdit();
		rowEditing.startEdit(0, 0);
	},
	
	/**
	* 删除按钮事件
	*/
	userDelete : function(button) {
		Ext.Msg.confirm('确认提示', '确定要删除当前用户?', function(result) {
			if (result == 'no')
				return false;
			var grid = button.up('window').down('grid');
			var rowEditing = grid.getPlugin('userRowEditPlugin');
			rowEditing.cancelEdit();
			var sm = grid.getSelectionModel();
			grid.getStore().remove(sm.getSelection());
			grid.getStore().sync();
			}, this);
	}
});
Ext.define('Mbfix.model.CommonType', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'text' ]
});
/**
 * 备件申请实体类
 */
Ext.define('Mbfix.model.ComponentApply', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'component_name', 'user_id', 'service_point_id', 
			'notes',
			{
				type : 'date',
				name : 'date',
				dateFormat : 'U'
			},{
				type : 'integer',
				name : 'amount'
			},{
				type : 'integer',
				name : 'state'
			}]
});
/**
 * 备件采购实体类
 */
Ext.define('Mbfix.model.ComponentPurchase', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'user', 'servicePoint', 'supply_company',
			'supply_address', 'amount', 'unit', 'price', 'pay_state',
			'pay_type', 'pay_account', 'notes', {
				type : 'date',
				name : 'date',
				dateFormat : 'U'
			}, {
				type : 'integer',
				name : 'pay_state'
			},{
				//是否已入库，1=未入库，2=已入库
				type : 'integer',
				name : 'state'
			} ]
});
/**
* 备件出库模型实体
*/
Ext.define('Mbfix.model.ComponentStockout',{
	extend : 'Ext.data.Model',
	fields : ['id','user','service_point','buyer_company',
		{name:'sell_for',type:'integer'},
		{name:'sell_type',type:'integer'},
		'record_no','store_house','component_brand','component_model',
		'component_name',
		'amount','unit','price','discount','receipt_type','receipt_account',
		'pay_type','receiver','notes',
		{name:'date',type:'date',dateFormat: 'U'}]
});
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
/**
* 申请，审核款项模型类
*/
Ext.define('Mbfix.model.FundRecord',{
	extend : 'Ext.data.Model',
	fields : ['id','apply_user','apply_service_point','apply_amount','apply_reason','apply_notes',
		'verify_user','verify_service_point','verify_amount','pay_type','pay_account','receiver_account','receiver',
		{name:'apply_date','type':'date',dateFormat: 'U'},
		{name:'verify_date','type':'date',dateFormat: 'U'},
		{name:'state',type:'integer'}]
});
Ext.define('Mbfix.model.Notice', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'title', 'author', 'publish_date' ]
});
/**
* 费用支出模型类
*/
Ext.define('Mbfix.model.Payout',{
	extend : 'Ext.data.Model',
	fields : ['id','handler_user','service_point','consume_content','amount','ticket_no','notes',
		{name:'ticket_type','type':'integer'},
		{name:'date','type':'date',dateFormat: 'U'}]
});
/**
 * 备件实体
 */
Ext.define('Mbfix.model.RepairComponent', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'name', 'component_brand', 'component_model', 'notes',
			'service_point', {
				type : 'integer',
				name : 'amount'
			}, {
				type : 'integer',
				name : 'state'
			} ]
});
/**
 * 角色模型类
 */
Ext.define('Mbfix.model.Role',{
	extend :'Ext.data.Model',
	fields : ['name','show_name']
});
/**
 * 服务点模型
 */
Ext.define('Mbfix.model.ServicePoint', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'name', 'short_name', 'desc', 'total_fund' ]
});
Ext.define('Mbfix.model.ServiceRecord', {
	extend : 'Ext.data.Model',
	fields : [ {
				name : 'id',
				type : 'int'
			}, {
				name : 'user_id',
				type : 'int'
			}, {
				name : 'record_state',
				type : 'int'
			}, {
				name : 'create_time',
				type : 'date',
				dateFormat : 'U'
			}, {
				name : 'disk_state',
				type : 'int'
			},
			'name', 'service_point', 'record_no', 'custom_name', 'custom_type',
			'custom_sex', 'custom_mobile', 'custom_phone', 'custom_company',
			'custom_address', 'custom_postcode', 'custom_email',
			'service_type', 'machine_brand', 'machine_type', 'machine_model',
			'machine_snid', 'serial_number', 'warranty_type',
			'machine_look', 'machine_attachment', 'error_desc', 'other_note' ]
});
/**
* 营业款收入模型(同时作为财务核销，应收款，应付款使用的模型)
*/
Ext.define('Mbfix.model.TurnoverIncome',{
	extend : 'Ext.data.Model',
	fields : ['id','user','service_point','record_no','custom_type','custom_name','receiver','pay_type'
		,'money','profit','notes','pay_state','finance_state','finance_exception',
		{name:'date',type:'date',dataFormat:'U'}]
});
/**
 * 用户模型类
 */
Ext.define('Mbfix.model.User', {
	extend : 'Ext.data.Model',
	fields : [ 'id', 'name', 'password', 'notes','roles','servicePoints', {
		name : 'lastlogin',
		type : 'date',
		format : 'U'
	} ]
});
/**
 * 备件申请Store
 */
Ext.define('Mbfix.store.ComponentApplys', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.ComponentApply',

	proxy : {
		type : 'ajax',
		api : {
			read : 'index.php?r=componentApply/list',
			update : 'index.php?r=componentApply/save'
		},
		reader : {
			type : 'json',
			root : 'results'
		}
	}
});
Ext.define('Mbfix.store.ComponentBrands', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.CommonType',

	proxy : {
		type : 'ajax',
		extraParams : {
			'typename' : 'ComponentBrand'
		},
		api: {
			read : 'index.php?r=common/readCommonType',
			create : 'index.php?r=common/newCommonType',
			update : 'index.php?r=common/updateCommonType',
			destroy : 'index.php?r=common/deleteCommonType'
		},
		reader : {
			type : 'json',
			root : 'results'
		},
		writer : {
			type : 'json'
		},
		listeners : {
			exception : function(proxy, response, operation, eOpts) {
				Ext.Msg.alert('更新失败', Ext.String.format(
						'服务端发生错误. status:{0}, {1}', response.status,
						response.statusText))
			}
		}
	}
});
Ext.define('Mbfix.store.ComponentModels', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.CommonType',

	proxy : {
		type : 'ajax',
		extraParams : {
			'typename' : 'ComponentModel'
		},
		api: {
			read : 'index.php?r=common/readCommonType',
			create : 'index.php?r=common/newCommonType',
			update : 'index.php?r=common/updateCommonType',
			destroy : 'index.php?r=common/deleteCommonType'
		},
		reader : {
			type : 'json',
			root : 'results'
		},
		writer : {
			type : 'json'
		},
		listeners : {
			exception : function(proxy, response, operation, eOpts) {
				Ext.Msg.alert('更新失败', Ext.String.format(
						'服务端发生错误. status:{0}, {1}', response.status,
						response.statusText))
			}
		}
	}
});
/**
 * 备件采购模型Store
 */
Ext.define('Mbfix.store.ComponentPurchases', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.ComponentPurchase',

	proxy : {
		type : 'ajax',
		api : {
			read : 'index.php?r=componentApply/purchaseList'
		},
		reader : {
			type : 'json',
			root : 'results'
		}
	}
});
/**
 * 客户联络方式Store
 */
Ext.define('Mbfix.store.ContactTypes', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.CommonType',

	proxy : {
		type : 'ajax',
		extraParams : {
			'typename' : 'ContactType'
		},
		api : {
			read : 'index.php?r=common/readCommonType',
			create : 'index.php?r=common/newCommonType',
			update : 'index.php?r=common/updateCommonType',
			destroy : 'index.php?r=common/deleteCommonType'
		},
		reader : {
			type : 'json',
			root : 'results'
		},
		writer : {
			type : 'json'
		},
		listeners : {
			exception : function(proxy, response, operation, eOpts) {
				Ext.Msg.alert('更新失败', Ext.String.format(
						'服务端发生错误. status:{0}, {1}', response.status,
						response.statusText))
			}
		}
	}
});
/**
 * 客户联络Store
 */
Ext.define('Mbfix.store.CustomContacts', {
	extend : 'Ext.data.Store',
	model : 'Mbfix.model.CustomContact',

	proxy : {
		type : 'ajax',
		extraParams : {
			recordId : null
		},
		api : {
			read : 'index.php?r=customContact/list'
		},
		reader : {
			type : 'json',
			root : 'results'
		},
		listeners : {
			exception : function(proxy, response, operation, eOpts) {
				Ext.Msg.alert('更新失败', Ext.String.format(
						'服务端发生错误. status:{0}, {1}', response.status,
						response.statusText))
			}
		}
	}
});

