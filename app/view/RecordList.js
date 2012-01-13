Ext.define('Mbfix.view.RecordList', {
	extend : 'Ext.window.Window',
	alias : 'widget.recordlist',
	width : 860,
	height : 550,
	modal : true,
	title : '待修列表',

	initComponent : function() {
		this.items = [{
			xtype : 'container',
			layout : 'anchor',
			items : [{
						xtype : 'fieldset',
						title : '搜索',
						layout : 'hbox',
						margin : 4,
						defaults : {
							labelWidth : 60,
							labelAlign : 'right'
						},
						items : [{
									xtype : 'textfield',
									fieldLabel : '工单号',
									labelWidth : 50,
									name : 'search_recordNo',
									itemId : 'search_recordNo',
									id : 'search_recordNo',
									width : 190
								},{
									xtype : 'textfield',
									fieldLabel : '接修员',
									name : 'search_fixer',
									labelWidth : 50,
									itemId : 'search_fixer',
									id : 'search_fixer',
									width : 130
								},{
									xtype : 'datefield',
									fieldLabel : '起始日期',
									itemId : 'search_beginDate',
									id : 'search_beginDate',
									format : 'Y-m-d',
									width : 160
								},{
									xtype : 'datefield',
									fieldLabel : '结束日期',
									itemId : 'search_endDate',
									id : 'search_endDate',
									format : 'Y-m-d',
									width : 160
								},{
									xtype : 'combo',
									id : 'search_state',
									itemId : 'search_state',
									fieldLabel : '状态',
									labelWidth : 40,
									queryMode : 'local',
									store : 'RecordStates',
									valueField : 'state',
									displayField : 'name',
									width : 110
								},{
									xtype : 'button',
									text : '查询',
									flex : 1,
									margin : '0 0 0 5',
									itemId : 'search_button'
								}]
					}, {
						xtype : 'grid',
						id : 'recordListGrid',
						store : 'ServiceRecords',
						border : 0,
						flex : 1,
						height : 350,
						autoScroll : true,
						columns : [{
									xtype : 'datecolumn',
									header : '创建时间',
									dataIndex : 'create_time',
									format : 'Y-m-d H:i',
									width : 120
								}, {
									header : '工单号',
									dataIndex : 'record_no',
									sortable : false,
									width : 170
								}, {
									header : '接修员',
									dataIndex : 'name',
									width : 70
								}, {
									header : '服务点',
									dataIndex : 'service_point',
									width : 60
								}, {
									header : '服务类型',
									dataIndex : 'service_type',
									sortable : false,
									width : 75
								}, {
									header : '机器信息',
									dataIndex : 'machine_brand',
									sortable : false,
									renderer : this.renderMachineInfo,
									width : 110
								}, {
									header : '质保类型',
									dataIndex : 'warranty_type',
									sortable : false,
									width : 65
								}, {
									header : '硬盘资料',
									dataIndex : 'disk_state',
									sortable : false,
									renderer : this.renderDiskState,
									width : 90
								}, {
									header : '状态',
									dataIndex : 'record_state',
									renderer : this.renderRecordState,
									flex : 1
								}],
						bbar : [{
									xtype : 'pagingtoolbar',
									id : 'recordListPaging',
									store : 'ServiceRecords',
									displayInfo : true,
									flex : 1
								}]
					}, {
						xtype : 'panel',
						id : 'detailRecordPanel',
						flex : 1,
						height : 105,
						margin : '4',
						tpl : [
								'<div class="recordDetail">',
								'<div><span>客户名称</span>: {custom_name}, <span>类型</span>: {custom_type}, <span>性别</span>: ',
								'<tpl if="custom_sex == 1">',
								'男',
								'</tpl>',
								'<tpl if="custom_sex == 0">',
								'女',
								'</tpl>',
								', <span>客户手机</span>: {custom_mobile}',
								'<tpl if="custom_phone">',
								', <span>客户固话</span>: {custom_phone}',
								'</tpl>',
								'</div>',
								'<div>',
								'<tpl if="custom_company">',
								'<span>客户单位</span>: {custom_company}',
								'</tpl>',
								'<tpl if="custom_address">',
								', <span>联系地址</span>: {custom_address}',
								'</tpl>',
								'<tpl if="custom_postcode">',
								', <span>邮编</span>: {custom_postcode}',
								'</tpl>',
								'<tpl if="custom_email">',
								', <span>EMail</span>: {custom_email}',
								'</tpl>',
								'</div>',
								'<div>',
								'<span>机器型号</span>: {machine_model}, <span>序列号</span>: {serial_number}',
								'<tpl if="machine_snid">',
								', <span>snid</span>: {machine_snid}',
								'</tpl>',
								'</div>',
								'<tpl if="machine_look">',
								'<div><span>机器外观</span>: {machine_look}, <span>随机附件</span>: {machine_attachment}</div>',
								'</tpl>',
								'<tpl if="error_desc">',
								'<div><span>故障描述</span>: {error_desc}, <span>其它备注</span>: {other_note}</div>',
								'</tpl>', 
								'</div>']
					}]
		}

		];
		this.callParent();
	},

	/**
	 * 机器信息自定义显示
	 */
	renderMachineInfo : function(value, p, record, rowIndex, colIndex) {
		return Ext.String.format('{0}({1})', value, record.data.machine_type);
	},

	/**
	 * 服务单状态自定义显示 1=处理中,2=转修中,3=报价中,4=客户不修,5-待料,6=到料处理中,7=无法修复,8=已修复,9=已结案
	 */
	renderRecordState : function(value, p, record) {
		var stateStore = Ext.getStore('RecordStates');	
		var index = stateStore.find('state',value);
		if(index != -1){
			return stateStore.getAt(index).data.name;
		}else{		
			return '未知';
		}
	},

	/**
	 * 硬盘资料的显示
	 */
	renderDiskState : function(value, p, record) {
		switch (value) {
			case 1 :
				return '已备份';
			case 2 :
				return '已取走';
			case 3 :
				return '数据不能清除';
			default :
				return '未知';
		}
	}
});