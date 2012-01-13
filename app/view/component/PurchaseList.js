/**
* 显示用户备件采购列表窗口
*/
Ext.define('Mbfix.view.component.PurchaseList',{
	extend : 'Ext.window.Window',
	alias : 'widget.purchaselist',
	title : '备件采购列表',
	width : 600,
	height : 400,
	modal : true,
	layout : 'fit',
	
	initComponent : function(){
		this.items = [{
			xtype : 'grid',
			store : 'ComponentPurchases',
			border : 0,
			autoScroll : true,
			columns : [{
				header : '采购人',
				dataIndex : 'user',
				width : 90
			},{
				header : '服务点',
				dataIndex : 'servicePoint',
				wdith : 90
			},{
				header : '采购数量',
				dataIndex : 'amount',
				width : 80
			},{
				header : '单位',
				dataIndex : 'unit',
				width :50
			},{
				header : '单价',
				dataIndex : 'price',
				width :50
			},{
				header : '付款情况',
				dataIndex : 'pay_state',
				width : 60,
				renderer : this.getPayState
			},{
				header : '付款方式',
				dataIndex : 'pay_type',
				width : 60
			},{
				header : '付款账户',
				dataIndex : 'pay_account',
				width : 100
			},{
				header : '供货单位',
				dataIndex : 'supply_company',
				width : 150
			},{
				header : '供货地址',
				dataIndex : 'supply_address',
				width :150
			},{
				header : '状态',
				dataIndex : 'state',
				width : 60,
				renderer : this.getPurchaseState
			},{
				xtype : 'datecolumn',
				header : '采购/入库 时间',
				dataIndex : 'date',
				width : 120,
				format : 'Y-m-d H:i'
			}],
			bbar : [{
					xtype : 'pagingtoolbar',
					store : 'ComponentPurchases',
					id : 'purchasePager',
					displayInfo : true,
					flex : 1
				}]
		}];
		
		this.buttons = [{
			text : '备件入库',
			action : 'accept'
		},{
			text : '取消',
			handler : function(button){
				button.up('window').close();
			}
		}];
		
		this.callParent();
	},
	
	/**
	*  读取备件付款状态
	*/
	getPayState : function(value, metaData, record){
		switch(value){
			case 1:
				return '已付款';
			case 2:
				return '未付款';
			default:
				return '未知';
		}
	},
	
	/**
	 * 返回采购是否已入库的状
	 */
	getPurchaseState : function(value, metaData, record){
		switch(value){
			case 1:
				return '未入库';
			case 2:
				return '已入库';
			default:
				return '未知';
		}
	}
});