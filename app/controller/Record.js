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