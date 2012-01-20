/**
 * 账务相关控制器
 */
Ext.define('Mbfix.controller.Finance', {
	extend : 'Ext.app.Controller',

	views : ['Home', 'finance.FundApply', 'finance.FundApplyList',
			'finance.FundVerify', 'finance.Payout', 'finance.PayoutList',
			'finance.TurnoverIncome','finance.TurnoverIncomeList',
			'finance.ConfirmFinanceVerify'],
	stores : ['finance.FundRecords', 'finance.FundApplyStates',
			'finance.FundPayTypes', 'finance.TicketTypes','finance.Payouts',
			'finance.TurnoverIncomes','ServicePoints'],

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
					'home #menuFundSearch' : {
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
					},
					'turnoverincomelist button[action="finance_confirm"]' : {
						click : this.confirmFinanceVerify
					},
					'turnoverincomelist button[action="finance_exception"]' : {
						click : this.confirmFinanceVerify
					},
					'turnoverincomelist #search_button' : {
						click : this.financeSearch
					},
					'confirmfinanceverify button[action="submit"]' : {
						click : this.submitFinanceVerify
					},
					'confirmfinanceverify #finance_state' : {
						change : this.financeStateChange
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
						if(action.result.success){
							Ext.Msg.alert('成功', '费用支出保存成功');
							button.up('window').close();
						}else{
							Ext.Msg.alert('失败', action.result.errors.message);
						}
					},
					failure : function(form, action) {						
						Ext.Msg.alert('失败', action.response.responseText);
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
						if(action.result.success){
							Ext.Msg.alert('成功', '营业款收入保存成功');
							button.up('window').close();
						}else{
							Ext.Msg.alert('失败', action.result.errors.message);
						}
					},
					failure : function(form, action) {
						Ext.Msg.alert('失败', action.response.responseText);
					}
				});
	},
		
	/**
	 * 重置款项 Proxy 的其它参数
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
	* 加载财务核销记录
	*/
	_loadTurnoverIncomeList : function(store){
		store.loadPage(1, {
			scope : this,
			callback : function(records, response, opts) {
				;
			}
		});
	},
	
	/**
	* 营业款收入列表(财务核销)窗口
	*/
	turnoverIncomeList : function(button){
		var win = Ext.widget('turnoverincomelist'),
			store = win.down('grid').getStore();
		win.show();
		this._clearExtraParams(store.getProxy());
		this._loadTurnoverIncomeList(store);
	},
	
	/**
	 * 财务核销，确认核销或核销异常
	 */
	confirmFinanceVerify : function(button){
		//判断是否有选中记录
		var win = Ext.widget('confirmfinanceverify');
		var selModel = button.up('window').down('grid').getSelectionModel();
		if(selModel.getCount() == 0){
			Ext.Msg.alert('提示','请选择一行要核销的记录');
			win.destroy();
			return false;
		}
		var form = win.down('form');
		var record = selModel.getSelection()[0].data;
		if(record.finance_state != 0){
			Ext.Msg.alert('提示','该记录已核销，不能再操作了。');
			win.destroy();
			return false;
		}
		form.down('#finance_id').setValue(selModel.getSelection()[0].data.id);
		win.show();	
		if(button['action'] == 'finance_confirm'){
			form.down('#finance_state').setValue({'verify':1});
			form.down('#finance_exception').disable();
		}else{
			form.down('#finance_state').setValue({'verify':2});
			form.down('#finance_exception').enable();
		}
	},
	
	/**
	 * 核销操作，状态变更事件
	 */
	financeStateChange : function(field, newValue, oldValue){
		var val = newValue['verify'];
		if(val == 1){
			field.up('form').down('#finance_exception').disable();
		}else{
			field.up('form').down('#finance_exception').enable();
		}
	},
	
	/**
	 * 确定核销事件
	 */
	submitFinanceVerify : function(button){
		button.up('window').down('form').getForm().submit({
			url : 'index.php?r=finance/financeVerify',
			success : function(form, action) {
				if(action.result.success){
					Ext.Msg.alert('成功', '财务核销保存成功');
					button.up('window').close();
					Ext.getCmp('turnoverIncomeListPaging').doRefresh();
				}else{
					Ext.Msg.alert('失败', action.result.errors.message);
				}
			},
			failure : function(form, action) {
				Ext.Msg.alert('失败', action.response.responseText);
			}
		});
	},
	
	/**
	 * 款项综合查询
	 */
	financeSearch : function(button){
		var store = Ext.getStore('finance.TurnoverIncomes');
		var proxy = store.getProxy();
		this._clearExtraParams(proxy); // 先重置参数
		var form = button.up('window').down('form');
		var recordNo = form.down('#finance_recordNo').getValue(),
			servicePoint = form.down('#finance_service_point').getValue(),
			beginDate = form.down('#search_beginDate').getValue(),
			endDate = form.down('#search_endDate').getValue(),
			financeFilter = form.down('#finance_filter').getValue();
		if (!Ext.isEmpty(recordNo)) {
			proxy.extraParams.recordNo = recordNo;
		}
		if (!Ext.isEmpty(servicePoint)) {
			proxy.extraParams.servicePoint = servicePoint;
		}
		if (!Ext.isEmpty(beginDate)) {
			proxy.extraParams.beginDate = beginDate;
		}
		if (!Ext.isEmpty(endDate)) {
			proxy.extraParams.endDate = endDate;
		}
		if (!Ext.isEmpty(financeFilter)) {
			proxy.extraParams.financeFilter = financeFilter;
		}
		this._loadTurnoverIncomeList(store);
	}
});