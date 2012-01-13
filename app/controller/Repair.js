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