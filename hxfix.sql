/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50517
Source Host           : localhost:3306
Source Database       : hxfix

Target Server Type    : MYSQL
Target Server Version : 50517
File Encoding         : 65001

Date: 2012-01-20 10:21:55
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `hx_component`
-- ----------------------------
DROP TABLE IF EXISTS `hx_component`;
CREATE TABLE `hx_component` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL COMMENT '备件名称',
  `brand_id` int(45) NOT NULL COMMENT '备件品牌',
  `model_id` int(45) NOT NULL COMMENT '备件型号',
  `notes` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `pk_brand` (`brand_id`) USING BTREE,
  KEY `pk_model` (`model_id`) USING BTREE,
  CONSTRAINT `hx_component_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `hx_component_brand` (`id`),
  CONSTRAINT `hx_component_ibfk_2` FOREIGN KEY (`model_id`) REFERENCES `hx_component_model` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='配件表';

-- ----------------------------
-- Records of hx_component
-- ----------------------------
INSERT INTO `hx_component` VALUES ('3', '北桥', '1', '1', '2011年新品');
INSERT INTO `hx_component` VALUES ('4', 'BIOS', '1', '1', null);
INSERT INTO `hx_component` VALUES ('8', 'X900主板', '2', '2', '申请自动添加');
INSERT INTO `hx_component` VALUES ('9', '示波器', '1', '1', '申请自动添加');
INSERT INTO `hx_component` VALUES ('10', 'xo', '1', '1', '申请自动添加');
INSERT INTO `hx_component` VALUES ('11', 'eeee', '1', '1', '申请自动添加');
INSERT INTO `hx_component` VALUES ('12', 'fdfd', '1', '2', '申请自动添加');
INSERT INTO `hx_component` VALUES ('13', 'aaa', '1', '1', '申请自动添加');
INSERT INTO `hx_component` VALUES ('14', 'bbb', '1', '1', '申请自动添加');
INSERT INTO `hx_component` VALUES ('15', '如果爱', '2', '2', '申请自动添加');
INSERT INTO `hx_component` VALUES ('16', '如果不爱', '2', '2', '申请自动添加');
INSERT INTO `hx_component` VALUES ('17', 'd', '1', '1', '申请自动添加');
INSERT INTO `hx_component` VALUES ('18', 'mx', '1', '1', '申请自动添加');
INSERT INTO `hx_component` VALUES ('19', 'sdf', '1', '1', '申请自动添加');

-- ----------------------------
-- Table structure for `hx_component_accept`
-- ----------------------------
DROP TABLE IF EXISTS `hx_component_accept`;
CREATE TABLE `hx_component_accept` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户编号',
  `service_point` int(11) NOT NULL COMMENT '网点编号',
  `store_house` varchar(45) NOT NULL COMMENT '收货仓库',
  `purchase_id` int(11) NOT NULL COMMENT '对应备件采购的id',
  `amount` double NOT NULL COMMENT '实际入库数量',
  `date` int(11) NOT NULL COMMENT '入库时间',
  `notes` varchar(300) DEFAULT NULL COMMENT '附加说明',
  PRIMARY KEY (`id`),
  KEY `pk_user_id_accept` (`user_id`),
  KEY `pk_service_point_accept` (`service_point`),
  KEY `pk_purchase_id` (`purchase_id`),
  CONSTRAINT `pk_purchase_id` FOREIGN KEY (`purchase_id`) REFERENCES `hx_component_purchase` (`id`),
  CONSTRAINT `pk_service_point_accept` FOREIGN KEY (`service_point`) REFERENCES `hx_service_point` (`id`),
  CONSTRAINT `pk_user_id_accept` FOREIGN KEY (`user_id`) REFERENCES `hx_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='备件入库表';

-- ----------------------------
-- Records of hx_component_accept
-- ----------------------------
INSERT INTO `hx_component_accept` VALUES ('4', '1', '1', '杭州', '3', '150', '1325513519', '无');

-- ----------------------------
-- Table structure for `hx_component_apply`
-- ----------------------------
DROP TABLE IF EXISTS `hx_component_apply`;
CREATE TABLE `hx_component_apply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component_id` int(11) NOT NULL COMMENT '备件编号',
  `amount` double NOT NULL COMMENT '备件申请数量',
  `user_id` int(11) NOT NULL COMMENT '申请人',
  `service_point_id` int(11) NOT NULL COMMENT '申请所在网点',
  `purchase_type` int(11) NOT NULL COMMENT '采购类型',
  `date` int(11) NOT NULL COMMENT '申请时间',
  `notes` varchar(200) DEFAULT NULL COMMENT '备注',
  `state` int(11) DEFAULT '0' COMMENT '申请备件状态，0=申请中，1=已到料，2=已采购, 3=已领料',
  PRIMARY KEY (`id`),
  KEY `component_id` (`component_id`),
  KEY `user_id` (`user_id`),
  KEY `service_point_id` (`service_point_id`),
  KEY `pk_purchase_type` (`purchase_type`),
  CONSTRAINT `hx_component_apply_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `hx_component` (`id`),
  CONSTRAINT `hx_component_apply_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `hx_user` (`id`),
  CONSTRAINT `hx_component_apply_ibfk_3` FOREIGN KEY (`service_point_id`) REFERENCES `hx_service_point` (`id`),
  CONSTRAINT `pk_purchase_type` FOREIGN KEY (`purchase_type`) REFERENCES `hx_purchase_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of hx_component_apply
-- ----------------------------
INSERT INTO `hx_component_apply` VALUES ('3', '8', '1', '1', '1', '1', '1324219887', '全新', '0');
INSERT INTO `hx_component_apply` VALUES ('4', '9', '1', '1', '1', '1', '1324653725', '要最好', '0');
INSERT INTO `hx_component_apply` VALUES ('5', '10', '1', '1', '1', '1', '1324655124', '', '0');
INSERT INTO `hx_component_apply` VALUES ('6', '11', '1', '1', '1', '1', '1324656155', '', '0');
INSERT INTO `hx_component_apply` VALUES ('7', '12', '2', '1', '1', '1', '1324657121', 'xdfd', '0');
INSERT INTO `hx_component_apply` VALUES ('8', '13', '2', '1', '1', '1', '1324657233', 'aaa', '0');
INSERT INTO `hx_component_apply` VALUES ('9', '14', '2', '1', '1', '1', '1324657330', '', '0');
INSERT INTO `hx_component_apply` VALUES ('10', '15', '1', '1', '1', '1', '1324735441', '', '0');
INSERT INTO `hx_component_apply` VALUES ('11', '16', '1', '1', '1', '1', '1324735471', '', '0');
INSERT INTO `hx_component_apply` VALUES ('12', '17', '1', '1', '1', '1', '1325388362', '', '0');
INSERT INTO `hx_component_apply` VALUES ('13', '17', '1', '1', '1', '1', '1325388395', '', '0');
INSERT INTO `hx_component_apply` VALUES ('14', '18', '1', '1', '1', '3', '1325400102', 'm8->m9->mx', '0');
INSERT INTO `hx_component_apply` VALUES ('15', '18', '1', '1', '1', '3', '1325400175', 'm8->m9->mx', '0');
INSERT INTO `hx_component_apply` VALUES ('16', '19', '1', '1', '1', '2', '1325400299', 'sdf', '2');

-- ----------------------------
-- Table structure for `hx_component_brand`
-- ----------------------------
DROP TABLE IF EXISTS `hx_component_brand`;
CREATE TABLE `hx_component_brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='配件品牌表';

-- ----------------------------
-- Records of hx_component_brand
-- ----------------------------
INSERT INTO `hx_component_brand` VALUES ('1', 'Intel');
INSERT INTO `hx_component_brand` VALUES ('2', '华硕');

-- ----------------------------
-- Table structure for `hx_component_model`
-- ----------------------------
DROP TABLE IF EXISTS `hx_component_model`;
CREATE TABLE `hx_component_model` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='配件型号表';

-- ----------------------------
-- Records of hx_component_model
-- ----------------------------
INSERT INTO `hx_component_model` VALUES ('1', 'EX-21');
INSERT INTO `hx_component_model` VALUES ('2', 'IE98DD');

-- ----------------------------
-- Table structure for `hx_component_purchase`
-- ----------------------------
DROP TABLE IF EXISTS `hx_component_purchase`;
CREATE TABLE `hx_component_purchase` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '当前采购用户',
  `service_point_id` int(11) NOT NULL COMMENT '当前网点',
  `apply_id` int(11) NOT NULL COMMENT '备件申请表中的id',
  `component_id` int(11) NOT NULL COMMENT '备件id',
  `supply_company` varchar(100) NOT NULL COMMENT '供货单位',
  `supply_address` varchar(200) DEFAULT NULL COMMENT '供货地址',
  `amount` double NOT NULL DEFAULT '0' COMMENT '采购数量',
  `unit` varchar(10) NOT NULL COMMENT '数量单位',
  `price` double NOT NULL COMMENT '采购单价',
  `pay_state` int(11) NOT NULL COMMENT '付款方式，1已付款，2未付款',
  `pay_type` int(11) NOT NULL COMMENT '付款方式',
  `pay_account` varchar(100) NOT NULL COMMENT '付款账户',
  `date` int(11) NOT NULL COMMENT '采购时间',
  `notes` varchar(500) DEFAULT NULL COMMENT '备注',
  `state` int(11) NOT NULL DEFAULT '1' COMMENT '是否已入库，1=未入库，2=已入库',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `service_point_id` (`service_point_id`),
  KEY `pay_type` (`pay_type`),
  KEY `pk_component_id_purchase` (`component_id`),
  KEY `pk_apply_id` (`apply_id`),
  CONSTRAINT `hx_component_purchase_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `hx_user` (`id`),
  CONSTRAINT `hx_component_purchase_ibfk_2` FOREIGN KEY (`service_point_id`) REFERENCES `hx_service_point` (`id`),
  CONSTRAINT `hx_component_purchase_ibfk_3` FOREIGN KEY (`pay_type`) REFERENCES `hx_pay_type` (`id`),
  CONSTRAINT `pk_apply_id` FOREIGN KEY (`apply_id`) REFERENCES `hx_component_apply` (`id`),
  CONSTRAINT `pk_component_id_purchase` FOREIGN KEY (`component_id`) REFERENCES `hx_component` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of hx_component_purchase
-- ----------------------------
INSERT INTO `hx_component_purchase` VALUES ('3', '1', '1', '16', '19', '杭州天格科技', '塔林路5030号', '150', '个', '1.5', '1', '1', '无', '1325512112', '', '2');

-- ----------------------------
-- Table structure for `hx_component_stock`
-- ----------------------------
DROP TABLE IF EXISTS `hx_component_stock`;
CREATE TABLE `hx_component_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component_id` int(11) NOT NULL COMMENT '备件编号',
  `service_point_id` int(11) NOT NULL COMMENT '网点编号',
  `amount` double NOT NULL DEFAULT '0' COMMENT '备件库存数量',
  PRIMARY KEY (`id`,`component_id`,`service_point_id`),
  KEY `pk_component_id` (`component_id`),
  KEY `pk_service_point` (`service_point_id`),
  CONSTRAINT `pk_component_id` FOREIGN KEY (`component_id`) REFERENCES `hx_component` (`id`),
  CONSTRAINT `pk_service_point` FOREIGN KEY (`service_point_id`) REFERENCES `hx_service_point` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='备件库存表';

-- ----------------------------
-- Records of hx_component_stock
-- ----------------------------
INSERT INTO `hx_component_stock` VALUES ('1', '3', '1', '1');
INSERT INTO `hx_component_stock` VALUES ('2', '4', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('3', '8', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('4', '9', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('5', '10', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('6', '11', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('7', '12', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('8', '13', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('9', '14', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('10', '15', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('11', '16', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('12', '17', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('13', '18', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('14', '19', '1', '146');

-- ----------------------------
-- Table structure for `hx_component_stockout`
-- ----------------------------
DROP TABLE IF EXISTS `hx_component_stockout`;
CREATE TABLE `hx_component_stockout` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `service_point_id` int(11) NOT NULL,
  `buyer_company` varchar(100) NOT NULL COMMENT '购买单位',
  `sell_for` int(11) NOT NULL COMMENT '出库类型，1=销售，2=维修',
  `sell_type` int(11) NOT NULL COMMENT '出库方式，1=现场，2=邮寄，3=自用',
  `record_no` varchar(45) DEFAULT NULL COMMENT '工单号',
  `store_house` varchar(45) NOT NULL COMMENT '发货仓库',
  `component_id` int(11) NOT NULL COMMENT '备件id',
  `amount` double NOT NULL COMMENT '出库数量',
  `unit` varchar(45) NOT NULL COMMENT '数量单位',
  `price` double NOT NULL COMMENT '出库单价',
  `discount` double NOT NULL COMMENT '优惠金额',
  `receipt_type` int(11) NOT NULL COMMENT '收款情况，1=已收款，2=未收款',
  `receipt_account` varchar(45) DEFAULT NULL COMMENT '收款账号',
  `pay_type` int(11) DEFAULT NULL COMMENT '收款方式，hx_pay_type表的外键',
  `receiver` varchar(45) DEFAULT NULL COMMENT '收款人',
  `notes` varchar(300) DEFAULT NULL COMMENT '附加说明',
  `date` int(11) NOT NULL COMMENT '出库时间',
  PRIMARY KEY (`id`),
  KEY `pk_user_id_out` (`user_id`),
  KEY `pk_service_point_out` (`service_point_id`),
  KEY `pk_component_id_out` (`component_id`),
  KEY `pk_pay_type_stockout` (`pay_type`),
  CONSTRAINT `pk_component_id_out` FOREIGN KEY (`component_id`) REFERENCES `hx_component` (`id`),
  CONSTRAINT `pk_pay_type_stockout` FOREIGN KEY (`pay_type`) REFERENCES `hx_pay_type` (`id`),
  CONSTRAINT `pk_service_point_out` FOREIGN KEY (`service_point_id`) REFERENCES `hx_service_point` (`id`),
  CONSTRAINT `pk_user_id_out` FOREIGN KEY (`user_id`) REFERENCES `hx_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of hx_component_stockout
-- ----------------------------
INSERT INTO `hx_component_stockout` VALUES ('1', '1', '1', '杭州天格科技', '2', '1', 'asdf', '杭州', '3', '1', '个', '160', '10', '1', 'sdfsdfsdf', '1', 'sefff', '月结', '1325598604');
INSERT INTO `hx_component_stockout` VALUES ('2', '1', '1', '德声', '1', '1', null, '杭州', '19', '4', '个', '5.5', '2', '2', '无', '1', '小王', '', '1326014398');

-- ----------------------------
-- Table structure for `hx_contact_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_contact_type`;
CREATE TABLE `hx_contact_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='客户联络方式';

-- ----------------------------
-- Records of hx_contact_type
-- ----------------------------
INSERT INTO `hx_contact_type` VALUES ('1', '报价');
INSERT INTO `hx_contact_type` VALUES ('2', '回访');
INSERT INTO `hx_contact_type` VALUES ('3', '约定上门');

-- ----------------------------
-- Table structure for `hx_custom_contact`
-- ----------------------------
DROP TABLE IF EXISTS `hx_custom_contact`;
CREATE TABLE `hx_custom_contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_id` bigint(11) NOT NULL COMMENT '客户联系所在的工单号',
  `contact_type_id` int(11) NOT NULL COMMENT '客户联系方式id',
  `contact_content` varchar(300) NOT NULL COMMENT '客户联系内容',
  `contact_date` int(11) NOT NULL COMMENT '客户联系时间',
  PRIMARY KEY (`id`),
  KEY `pk_contact_type_id` (`contact_type_id`),
  KEY `pk_record_id` (`record_id`),
  CONSTRAINT `pk_contact_type_id` FOREIGN KEY (`contact_type_id`) REFERENCES `hx_contact_type` (`id`),
  CONSTRAINT `pk_record_id` FOREIGN KEY (`record_id`) REFERENCES `hx_service_record` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of hx_custom_contact
-- ----------------------------
INSERT INTO `hx_custom_contact` VALUES ('1', '5', '1', '正常报价.', '1324304754');
INSERT INTO `hx_custom_contact` VALUES ('2', '6', '2', '上门的', '1324305430');
INSERT INTO `hx_custom_contact` VALUES ('3', '6', '2', '上门的', '1324305471');
INSERT INTO `hx_custom_contact` VALUES ('4', '6', '3', '约定上门....', '1324305614');
INSERT INTO `hx_custom_contact` VALUES ('5', '6', '1', '....................', '1324305815');
INSERT INTO `hx_custom_contact` VALUES ('6', '6', '2', '...........se', '1324305860');
INSERT INTO `hx_custom_contact` VALUES ('7', '6', '1', 'ok..............', '1324305912');
INSERT INTO `hx_custom_contact` VALUES ('8', '5', '1', 'xeee', '1324306095');
INSERT INTO `hx_custom_contact` VALUES ('9', '5', '1', '...................sdfa', '1324306262');
INSERT INTO `hx_custom_contact` VALUES ('10', '6', '1', '报价---', '1324629839');
INSERT INTO `hx_custom_contact` VALUES ('11', '8', '1', '报价...', '1325067035');

-- ----------------------------
-- Table structure for `hx_custom_fetch`
-- ----------------------------
DROP TABLE IF EXISTS `hx_custom_fetch`;
CREATE TABLE `hx_custom_fetch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_id` bigint(20) NOT NULL COMMENT '服务单编号',
  `fetch_type` int(11) NOT NULL COMMENT '取机类型,1=现场取机,2=物流发货',
  `logistics_type_id` int(11) DEFAULT NULL COMMENT '物流单位id',
  `logistics_no` varchar(100) DEFAULT NULL COMMENT '物流单号',
  `pay_state` smallint(6) NOT NULL COMMENT '付款情况,1=已付款,2=未付款',
  `pay_type_id` int(11) NOT NULL COMMENT '付款方式id',
  `pay_money` double NOT NULL COMMENT '付款金额',
  `finish_date` int(11) DEFAULT NULL COMMENT '结案时间',
  PRIMARY KEY (`id`),
  KEY `record_id` (`record_id`),
  KEY `pk_logistics_type_id` (`logistics_type_id`) USING BTREE,
  KEY `pk_pay_type_id` (`pay_type_id`) USING BTREE,
  CONSTRAINT `hx_custom_fetch_ibfk_1` FOREIGN KEY (`logistics_type_id`) REFERENCES `hx_logistics_type` (`id`),
  CONSTRAINT `hx_custom_fetch_ibfk_2` FOREIGN KEY (`pay_type_id`) REFERENCES `hx_pay_type` (`id`),
  CONSTRAINT `hx_custom_fetch_ibfk_3` FOREIGN KEY (`record_id`) REFERENCES `hx_service_record` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='客户取机,结案表';

-- ----------------------------
-- Records of hx_custom_fetch
-- ----------------------------
INSERT INTO `hx_custom_fetch` VALUES ('1', '6', '2', '2', '89883928374', '1', '1', '100', '1324826281');
INSERT INTO `hx_custom_fetch` VALUES ('2', '5', '1', null, null, '2', '6', '0', '1324827008');
INSERT INTO `hx_custom_fetch` VALUES ('3', '8', '1', null, null, '1', '1', '10', '1325067657');

-- ----------------------------
-- Table structure for `hx_custom_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_custom_type`;
CREATE TABLE `hx_custom_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '客户类型,如直接客户,经销商等',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='客户类型';

-- ----------------------------
-- Records of hx_custom_type
-- ----------------------------
INSERT INTO `hx_custom_type` VALUES ('1', '直接客户');
INSERT INTO `hx_custom_type` VALUES ('2', '经销商');
INSERT INTO `hx_custom_type` VALUES ('3', '企业客户');
INSERT INTO `hx_custom_type` VALUES ('4', '邮寄客户');
INSERT INTO `hx_custom_type` VALUES ('8', '扔仍3');
INSERT INTO `hx_custom_type` VALUES ('9', '五和');
INSERT INTO `hx_custom_type` VALUES ('10', '胡手');

-- ----------------------------
-- Table structure for `hx_fund_record`
-- ----------------------------
DROP TABLE IF EXISTS `hx_fund_record`;
CREATE TABLE `hx_fund_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `apply_user_id` int(11) NOT NULL COMMENT '申请人编号',
  `apply_service_point_id` int(11) NOT NULL COMMENT '申请人网点',
  `apply_amount` double NOT NULL COMMENT '申请金额',
  `apply_reason` varchar(45) NOT NULL COMMENT '款项用途，申请原因',
  `apply_notes` varchar(200) NOT NULL COMMENT '附加说明',
  `apply_date` int(11) NOT NULL COMMENT '申请时间',
  `verify_user_id` int(11) DEFAULT NULL COMMENT '审核人编号',
  `verify_service_point_id` int(11) DEFAULT NULL COMMENT '审核人网点',
  `verify_amount` double DEFAULT NULL COMMENT '批准金额',
  `pay_type` int(11) DEFAULT NULL COMMENT '出款方式，1=淘宝，2=现金，3=网银',
  `pay_account` varchar(100) DEFAULT NULL COMMENT '出款账号',
  `receiver_account` varchar(100) DEFAULT NULL COMMENT '收款人账号',
  `receiver` varchar(45) DEFAULT NULL COMMENT '收款人',
  `verify_notes` varchar(200) DEFAULT NULL COMMENT '审核备注',
  `verify_date` int(11) DEFAULT NULL COMMENT '审核时间',
  `state` int(11) DEFAULT NULL COMMENT '审核结果，1=等待审核，2=审核通过，3=审核拒绝',
  PRIMARY KEY (`id`),
  KEY `pk_apply_user_id` (`apply_user_id`),
  KEY `pk_apply_service_point_id` (`apply_service_point_id`),
  KEY `pk_verify_user_id` (`verify_user_id`),
  KEY `pk_verify_service_point_id` (`verify_service_point_id`),
  CONSTRAINT `pk_apply_service_point_id` FOREIGN KEY (`apply_service_point_id`) REFERENCES `hx_service_point` (`id`),
  CONSTRAINT `pk_apply_user_id` FOREIGN KEY (`apply_user_id`) REFERENCES `hx_user` (`id`),
  CONSTRAINT `pk_verify_service_point_id` FOREIGN KEY (`verify_service_point_id`) REFERENCES `hx_service_point` (`id`),
  CONSTRAINT `pk_verify_user_id` FOREIGN KEY (`verify_user_id`) REFERENCES `hx_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='款项申请表';

-- ----------------------------
-- Records of hx_fund_record
-- ----------------------------
INSERT INTO `hx_fund_record` VALUES ('1', '1', '1', '100', '备件 ', '备件 ', '1325943736', '1', '1', '100', '2', 'ttrr44522334', 'sfwwer323', '江沈', '二3枯苛二', '1325988928', '2');

-- ----------------------------
-- Table structure for `hx_logistics_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_logistics_type`;
CREATE TABLE `hx_logistics_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '物流公司',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='物流单位';

-- ----------------------------
-- Records of hx_logistics_type
-- ----------------------------
INSERT INTO `hx_logistics_type` VALUES ('1', '申通');
INSERT INTO `hx_logistics_type` VALUES ('2', '天天');
INSERT INTO `hx_logistics_type` VALUES ('3', '圆通');

-- ----------------------------
-- Table structure for `hx_machine_brand`
-- ----------------------------
DROP TABLE IF EXISTS `hx_machine_brand`;
CREATE TABLE `hx_machine_brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '品牌名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='机器品牌';

-- ----------------------------
-- Records of hx_machine_brand
-- ----------------------------
INSERT INTO `hx_machine_brand` VALUES ('1', '联想');
INSERT INTO `hx_machine_brand` VALUES ('2', 'IBM');
INSERT INTO `hx_machine_brand` VALUES ('3', 'Acer');

-- ----------------------------
-- Table structure for `hx_machine_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_machine_type`;
CREATE TABLE `hx_machine_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '类别名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='机器类型表';

-- ----------------------------
-- Records of hx_machine_type
-- ----------------------------
INSERT INTO `hx_machine_type` VALUES ('1', '笔记本');
INSERT INTO `hx_machine_type` VALUES ('2', '显示器');
INSERT INTO `hx_machine_type` VALUES ('3', '电源');

-- ----------------------------
-- Table structure for `hx_payout_detail`
-- ----------------------------
DROP TABLE IF EXISTS `hx_payout_detail`;
CREATE TABLE `hx_payout_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `handler_user_id` int(11) NOT NULL COMMENT '费用登记人',
  `service_point_id` int(11) NOT NULL COMMENT '网点id',
  `consume_content` varchar(200) NOT NULL COMMENT '消费项目内容',
  `amount` double NOT NULL COMMENT '费用金额',
  `ticket_type` int(11) NOT NULL COMMENT '票据类型,1=物流单,2=收据,3=发票',
  `ticket_no` varchar(100) NOT NULL COMMENT '票据号',
  `notes` varchar(300) DEFAULT NULL COMMENT '附加说明',
  `date` int(11) NOT NULL COMMENT '费用发生时间',
  PRIMARY KEY (`id`),
  KEY `pk_handler_user_id` (`handler_user_id`),
  KEY `pk_consume_service_point_id` (`service_point_id`),
  CONSTRAINT `pk_consume_service_point_id` FOREIGN KEY (`service_point_id`) REFERENCES `hx_service_point` (`id`),
  CONSTRAINT `pk_handler_user_id` FOREIGN KEY (`handler_user_id`) REFERENCES `hx_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='费用支出表';

-- ----------------------------
-- Records of hx_payout_detail
-- ----------------------------
INSERT INTO `hx_payout_detail` VALUES ('1', '1', '1', '买椅子', '100', '3', '9983Hidieu-393', '五把椅子', '1326002084');

-- ----------------------------
-- Table structure for `hx_pay_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_pay_type`;
CREATE TABLE `hx_pay_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '付款方式',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='收款方式表';

-- ----------------------------
-- Records of hx_pay_type
-- ----------------------------
INSERT INTO `hx_pay_type` VALUES ('1', '现金');
INSERT INTO `hx_pay_type` VALUES ('2', '转账支票');
INSERT INTO `hx_pay_type` VALUES ('3', '现金支票');
INSERT INTO `hx_pay_type` VALUES ('4', '网银转账');
INSERT INTO `hx_pay_type` VALUES ('5', '对公汇款');
INSERT INTO `hx_pay_type` VALUES ('6', '月结');

-- ----------------------------
-- Table structure for `hx_problem_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_problem_type`;
CREATE TABLE `hx_problem_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of hx_problem_type
-- ----------------------------
INSERT INTO `hx_problem_type` VALUES ('1', 'CPU');
INSERT INTO `hx_problem_type` VALUES ('2', '内存');
INSERT INTO `hx_problem_type` VALUES ('3', '主板');
INSERT INTO `hx_problem_type` VALUES ('4', 'BIOS');

-- ----------------------------
-- Table structure for `hx_purchase_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_purchase_type`;
CREATE TABLE `hx_purchase_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL COMMENT '采购类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='采购类型表';

-- ----------------------------
-- Records of hx_purchase_type
-- ----------------------------
INSERT INTO `hx_purchase_type` VALUES ('1', '维修');
INSERT INTO `hx_purchase_type` VALUES ('2', '销售');
INSERT INTO `hx_purchase_type` VALUES ('3', '库存');

-- ----------------------------
-- Table structure for `hx_record_component`
-- ----------------------------
DROP TABLE IF EXISTS `hx_record_component`;
CREATE TABLE `hx_record_component` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_id` bigint(20) NOT NULL COMMENT '服务单编号',
  `component_id` int(11) NOT NULL COMMENT '使用的备件id',
  `component_amount` double NOT NULL DEFAULT '1' COMMENT '使用的备件数量',
  `state` smallint(6) DEFAULT NULL COMMENT '0有库存预约中,1无库存申请中,2已领料',
  PRIMARY KEY (`id`),
  KEY `record_id` (`record_id`),
  KEY `component_id` (`component_id`),
  CONSTRAINT `hx_record_component_ibfk_1` FOREIGN KEY (`record_id`) REFERENCES `hx_service_record` (`id`),
  CONSTRAINT `hx_record_component_ibfk_2` FOREIGN KEY (`component_id`) REFERENCES `hx_component` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='维修使用备件表';

-- ----------------------------
-- Records of hx_record_component
-- ----------------------------
INSERT INTO `hx_record_component` VALUES ('2', '5', '3', '1', '0');
INSERT INTO `hx_record_component` VALUES ('3', '4', '15', '1', '1');
INSERT INTO `hx_record_component` VALUES ('4', '4', '16', '1', '1');
INSERT INTO `hx_record_component` VALUES ('5', '5', '3', '1', '0');
INSERT INTO `hx_record_component` VALUES ('6', '8', '3', '1', '0');

-- ----------------------------
-- Table structure for `hx_repair_record`
-- ----------------------------
DROP TABLE IF EXISTS `hx_repair_record`;
CREATE TABLE `hx_repair_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_id` bigint(20) NOT NULL COMMENT '服务单编号',
  `judge_result` smallint(6) NOT NULL COMMENT '诊断结果,0发现故障,1未发现故障NTF',
  `problem_type` int(11) DEFAULT NULL COMMENT '故障类别',
  `repair_type` int(11) DEFAULT NULL COMMENT '维修方式',
  `problem_desc` varchar(500) NOT NULL COMMENT '诊断描述',
  `fix_money` double NOT NULL DEFAULT '0' COMMENT '维修费',
  `custom_decide` smallint(6) NOT NULL DEFAULT '0' COMMENT '客户维修意愿,0表示要维修,1表示不修',
  `refuse_reason` varchar(200) DEFAULT NULL COMMENT '如果客户选择不修,则填写不修原因.',
  `operation_date` int(11) NOT NULL COMMENT '故障诊断最后操作日期',
  `state` smallint(6) NOT NULL COMMENT '0暂存状态,1已处理完毕',
  PRIMARY KEY (`id`),
  KEY `record_id` (`record_id`),
  KEY `pk_problem_type` (`problem_type`) USING BTREE,
  KEY `pk_repair_type` (`repair_type`) USING BTREE,
  CONSTRAINT `hx_repair_record_ibfk_1` FOREIGN KEY (`problem_type`) REFERENCES `hx_problem_type` (`id`),
  CONSTRAINT `hx_repair_record_ibfk_2` FOREIGN KEY (`repair_type`) REFERENCES `hx_repair_type` (`id`),
  CONSTRAINT `hx_repair_record_ibfk_3` FOREIGN KEY (`record_id`) REFERENCES `hx_service_record` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='故障诊断表';

-- ----------------------------
-- Records of hx_repair_record
-- ----------------------------
INSERT INTO `hx_repair_record` VALUES ('4', '6', '2', null, null, '正常', '2', '2', '无故障', '1324734140', '1');
INSERT INTO `hx_repair_record` VALUES ('5', '5', '1', '1', '2', '无法开机', '300', '1', '', '1324826970', '1');
INSERT INTO `hx_repair_record` VALUES ('6', '4', '1', '2', '2', '是中国; 苛地城脸欠有', '24', '1', '', '1324735490', '1');
INSERT INTO `hx_repair_record` VALUES ('7', '8', '1', '2', '2', '花屏', '0', '1', '', '1325067060', '1');

-- ----------------------------
-- Table structure for `hx_repair_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_repair_type`;
CREATE TABLE `hx_repair_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of hx_repair_type
-- ----------------------------
INSERT INTO `hx_repair_type` VALUES ('1', '加焊');
INSERT INTO `hx_repair_type` VALUES ('2', '更换');
INSERT INTO `hx_repair_type` VALUES ('3', '除尘');
INSERT INTO `hx_repair_type` VALUES ('4', '软件');

-- ----------------------------
-- Table structure for `hx_role`
-- ----------------------------
DROP TABLE IF EXISTS `hx_role`;
CREATE TABLE `hx_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL COMMENT '角色的英文名称',
  `showname` varchar(45) NOT NULL COMMENT '角色中文名称',
  `notes` varchar(500) NOT NULL COMMENT '权限列表，以‘控制器:值，...’这样的格式保存',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of hx_role
-- ----------------------------
INSERT INTO `hx_role` VALUES ('1', 'common', '维修员', 'x');

-- ----------------------------
-- Table structure for `hx_service_point`
-- ----------------------------
DROP TABLE IF EXISTS `hx_service_point`;
CREATE TABLE `hx_service_point` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `short_name` char(2) NOT NULL COMMENT '网点名称简称,必须是英文,如杭州的简称为HZ',
  `desc` varchar(200) DEFAULT NULL COMMENT '描述',
  `total_fund` double DEFAULT '0' COMMENT '网点当前的所有款项总金额',
  PRIMARY KEY (`id`,`name`,`short_name`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='维修服务点表';

-- ----------------------------
-- Records of hx_service_point
-- ----------------------------
INSERT INTO `hx_service_point` VALUES ('1', '杭州', 'HZ', '杭州颐高', '500');
INSERT INTO `hx_service_point` VALUES ('2', '宁波', 'NB', '天一路18号', '0');

-- ----------------------------
-- Table structure for `hx_service_record`
-- ----------------------------
DROP TABLE IF EXISTS `hx_service_record`;
CREATE TABLE `hx_service_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户编号',
  `service_point_id` int(11) NOT NULL COMMENT '网点编号',
  `record_no` varchar(50) NOT NULL COMMENT '工单号(默认21位),HZ111130xxxxx, 前两位是网点简称,后面是日期,最后13位是不重复的序列号. 也可以手工输入',
  `custom_name` varchar(45) NOT NULL COMMENT '客户名称',
  `custom_type` int(11) NOT NULL COMMENT '机器类型编号',
  `custom_sex` bit(1) NOT NULL COMMENT '性别, 1男,2女',
  `custom_mobile` varchar(20) NOT NULL COMMENT '客户手机号码',
  `custom_phone` varchar(20) DEFAULT NULL COMMENT '客户固定电话',
  `custom_company` varchar(45) DEFAULT NULL COMMENT '客户单位名称',
  `custom_address` varchar(100) DEFAULT NULL COMMENT '客户联系地址',
  `custom_postcode` varchar(10) DEFAULT NULL COMMENT '客户邮编',
  `custom_email` varchar(45) DEFAULT NULL COMMENT '客户email',
  `service_type` int(11) NOT NULL COMMENT '服务类型,如客户送修,上门自取等',
  `machine_brand` int(11) NOT NULL COMMENT '机器品牌',
  `machine_type` int(11) NOT NULL COMMENT '机器类型,如显示器,笔记本等',
  `machine_model` varchar(45) NOT NULL COMMENT '机器型号',
  `machine_snid` varchar(45) DEFAULT NULL COMMENT 'snid编号',
  `serial_number` varchar(45) NOT NULL COMMENT '机器序列号',
  `warranty_type` int(11) NOT NULL COMMENT '质保类型,如保内,送修等',
  `disk_state` int(15) NOT NULL COMMENT '硬盘资料状态,如已备份,已取走等',
  `machine_look` varchar(45) DEFAULT NULL COMMENT '机器外观',
  `machine_attachment` varchar(100) DEFAULT NULL COMMENT '随机附件',
  `error_desc` varchar(100) DEFAULT NULL COMMENT '故障描述',
  `other_note` varchar(100) DEFAULT NULL COMMENT '其他备注',
  `record_state` int(11) NOT NULL COMMENT '维修单状态,首次登入后,状态为1=处理中,2=转修中,3=报价中,4=客户不修,5-待料,6=到料处理中,7=无法修复,8=已修复,9=已结案',
  `create_time` int(11) NOT NULL COMMENT '服务单创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_record_no` (`record_no`),
  KEY `idx_serial_number` (`serial_number`),
  KEY `fk_user_id` (`user_id`),
  KEY `fk_service_point_id` (`service_point_id`),
  KEY `fk_service_type` (`service_type`),
  KEY `fk_machine_brand` (`machine_brand`),
  KEY `fk_machine_type` (`machine_type`),
  KEY `fk_warranty_type` (`warranty_type`),
  KEY `fk_custom_type` (`custom_type`),
  CONSTRAINT `fk_custom_type` FOREIGN KEY (`custom_type`) REFERENCES `hx_custom_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_machine_brand` FOREIGN KEY (`machine_brand`) REFERENCES `hx_machine_brand` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_machine_type` FOREIGN KEY (`machine_type`) REFERENCES `hx_machine_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_service_point_id` FOREIGN KEY (`service_point_id`) REFERENCES `hx_service_point` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_service_type` FOREIGN KEY (`service_type`) REFERENCES `hx_service_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `hx_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_warranty_type` FOREIGN KEY (`warranty_type`) REFERENCES `hx_warranty_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='服务单记录表';

-- ----------------------------
-- Records of hx_service_record
-- ----------------------------
INSERT INTO `hx_service_record` VALUES ('1', '1', '1', 'asdf', 'aewe', '1', '', '32234', '234234', 'asdf', 'asdf', 'asdf', 'sf@ssdfc.com', '1', '1', '1', 'asdf', '23sdf', 'asdf23', '1', '2', 'asdf', 'asdf', 'asdf', 'asdf', '5', '1322645571');
INSERT INTO `hx_service_record` VALUES ('2', '1', '1', 'asdfrer', '快递', '1', '', '32234', '234234', 'asdf', '', '', 'sf@ssdfc.com', '1', '1', '1', 'asdf', '', 'asdf23', '1', '2', '', '', '', '', '1', '1322645611');
INSERT INTO `hx_service_record` VALUES ('3', '1', '1', 'trhfffrdd', '王小', '2', '', '13433221123', '', '', '', '', '', '2', '1', '1', '遥', '', 'ddfe2344', '1', '3', '', '', '', '', '1', '1322719482');
INSERT INTO `hx_service_record` VALUES ('4', '1', '1', 'HZ1112014ED738873ED9C', 'dfzz', '1', '', '234234', '', '', '', '', '', '2', '1', '1', 'asf', '', 'asdfsdf', '2', '2', '', '', '', '', '4', '1322727680');
INSERT INTO `hx_service_record` VALUES ('5', '1', '1', 'HZ1112014ED73CE9AB613', 'zdf', '1', '', '3ws', '', '', '', '', '', '2', '2', '1', 'asdf', '', 'asdfsdf', '1', '2', '', '', '', '', '9', '1322728695');
INSERT INTO `hx_service_record` VALUES ('6', '1', '1', 'HZ1112074EDF3AC667D5F', '小张', '2', '', '18292028983', '', '', '', '', '', '1', '1', '1', 'L410', '', 'kiuefjsie', '1', '2', '', '', '', '', '8', '1323252540');
INSERT INTO `hx_service_record` VALUES ('7', '1', '1', 'asdf3', 'sd', '2', '', 'sdf', 'sdf', '', '', '', '', '1', '2', '1', 'sdf', 'sdf', 'sdf', '1', '1', 'sdf', 'sdf', 'sdf', '', '1', '1324906576');
INSERT INTO `hx_service_record` VALUES ('8', '1', '1', '123461', '杭州德购', '2', '', '56751449', '', '', '', '', '', '1', '3', '1', '4810T', '', '02912883020', '1', '1', '完好', '无', '无', '', '9', '1325066924');

-- ----------------------------
-- Table structure for `hx_service_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_service_type`;
CREATE TABLE `hx_service_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of hx_service_type
-- ----------------------------
INSERT INTO `hx_service_type` VALUES ('1', '客户送修');
INSERT INTO `hx_service_type` VALUES ('2', '上门取机');
INSERT INTO `hx_service_type` VALUES ('3', '邮件寄送');

-- ----------------------------
-- Table structure for `hx_turnover_income`
-- ----------------------------
DROP TABLE IF EXISTS `hx_turnover_income`;
CREATE TABLE `hx_turnover_income` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `service_point_id` int(11) NOT NULL,
  `record_no` varchar(45) DEFAULT NULL COMMENT '工单号，如果是维修项目产生的收入，则会有工单号',
  `custom_type` int(11) DEFAULT NULL COMMENT '客户类型',
  `custom_name` varchar(45) DEFAULT NULL COMMENT '客户名称',
  `receiver` varchar(20) DEFAULT NULL COMMENT '收款人',
  `pay_type` int(11) DEFAULT NULL COMMENT '收款方式',
  `money` double NOT NULL COMMENT '收款金额',
  `profit` double DEFAULT '0' COMMENT '单笔利润',
  `notes` varchar(300) DEFAULT NULL COMMENT '收入备注',
  `date` int(11) DEFAULT NULL COMMENT '收款日期',
  `pay_state` int(11) NOT NULL DEFAULT '1' COMMENT '收款状态，1＝已收款，2＝未收款',
  `finance_user_id` int(11) DEFAULT NULL COMMENT '财务核销人',
  `finance_state` int(11) DEFAULT '0' COMMENT '财务核销状态，0=待核销,1＝已核销，2=核销异常',
  `finance_exception` varchar(300) DEFAULT NULL COMMENT '核销异常说明',
  `finance_date` int(11) DEFAULT NULL COMMENT '财务核销时间',
  PRIMARY KEY (`id`),
  KEY `pk_user_id_income` (`user_id`),
  KEY `pk_service_point_income` (`service_point_id`),
  KEY `pk_pay_type_income` (`pay_type`),
  KEY `pk_custom_type_income` (`custom_type`),
  KEY `pk_finance_user_id` (`finance_user_id`),
  CONSTRAINT `pk_finance_user_id` FOREIGN KEY (`finance_user_id`) REFERENCES `hx_user` (`id`),
  CONSTRAINT `pk_custom_type_income` FOREIGN KEY (`custom_type`) REFERENCES `hx_custom_type` (`id`),
  CONSTRAINT `pk_pay_type_income` FOREIGN KEY (`pay_type`) REFERENCES `hx_pay_type` (`id`),
  CONSTRAINT `pk_service_point_income` FOREIGN KEY (`service_point_id`) REFERENCES `hx_service_point` (`id`),
  CONSTRAINT `pk_user_id_income` FOREIGN KEY (`user_id`) REFERENCES `hx_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='营业款收入明细表,备件出库和维修项目的收入自动记录在这里。';

-- ----------------------------
-- Records of hx_turnover_income
-- ----------------------------
INSERT INTO `hx_turnover_income` VALUES ('1', '1', '1', null, '1', '王不', '范小', '1', '260', '0', '卖报纸所得', '1326012671', '1', '1', '1', null, '1326809592');
INSERT INTO `hx_turnover_income` VALUES ('2', '1', '1', null, null, null, null, '1', '20', '0', '备件出库自动生成，出库编号为 2', null, '1', '1', '2', '没有发票', '1326809607');

-- ----------------------------
-- Table structure for `hx_user`
-- ----------------------------
DROP TABLE IF EXISTS `hx_user`;
CREATE TABLE `hx_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(32) NOT NULL COMMENT 'md5加密的密码',
  `lastlogin` int(11) DEFAULT NULL COMMENT '最后登录时',
  `notes` varchar(300) DEFAULT NULL COMMENT '备注',
  `loginkey` varchar(13) DEFAULT NULL COMMENT '登录时生成的随机字符串，用业防止cookie攻击.',
  `roles` varchar(200) DEFAULT NULL COMMENT '用户的角色列表，以'',''分隔',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标记，1表示已删除',
  PRIMARY KEY (`id`,`name`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='用户表';

-- ----------------------------
-- Records of hx_user
-- ----------------------------
INSERT INTO `hx_user` VALUES ('1', 'maxwell', 'e10adc3949ba59abbe56e057f20f883e', '1327026076', '', null, 'administrator,fixer,storekeeper,accounter', '0');
INSERT INTO `hx_user` VALUES ('2', 'alice', '753899dc6f5c168044c17da8c2a183bb', '1327025782', '', null, 'fixer', '0');
INSERT INTO `hx_user` VALUES ('3', '小王', '753899dc6f5c168044c17da8c2a183bb', '1326382952', 'xiao wang', null, 'fixer', '0');
INSERT INTO `hx_user` VALUES ('4', 'admin', '753899dc6f5c168044c17da8c2a183bb', null, '请务删除', null, 'administrator,storekeeper,fixer,accounter', '0');

-- ----------------------------
-- Table structure for `hx_user_role`
-- ----------------------------
DROP TABLE IF EXISTS `hx_user_role`;
CREATE TABLE `hx_user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户id外键',
  `role_id` int(11) NOT NULL COMMENT '角色id外键',
  PRIMARY KEY (`id`),
  KEY `pk_user_id` (`user_id`),
  KEY `pk_role_id` (`role_id`),
  CONSTRAINT `pk_role_id` FOREIGN KEY (`role_id`) REFERENCES `hx_role` (`id`),
  CONSTRAINT `pk_user_id` FOREIGN KEY (`user_id`) REFERENCES `hx_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of hx_user_role
-- ----------------------------

-- ----------------------------
-- Table structure for `hx_user_service_point`
-- ----------------------------
DROP TABLE IF EXISTS `hx_user_service_point`;
CREATE TABLE `hx_user_service_point` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `service_point_id` int(11) NOT NULL COMMENT '服务点ID',
  PRIMARY KEY (`id`),
  KEY `FK_hx_user_service_point_user` (`user_id`) USING BTREE,
  KEY `FK_hx_user_service_point_spoint` (`service_point_id`) USING BTREE,
  CONSTRAINT `FK_hx_user_service_point_spoint` FOREIGN KEY (`service_point_id`) REFERENCES `hx_service_point` (`id`),
  CONSTRAINT `FK_hx_user_service_point_user` FOREIGN KEY (`user_id`) REFERENCES `hx_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of hx_user_service_point
-- ----------------------------
INSERT INTO `hx_user_service_point` VALUES ('5', '1', '1');
INSERT INTO `hx_user_service_point` VALUES ('6', '2', '1');
INSERT INTO `hx_user_service_point` VALUES ('7', '4', '1');
INSERT INTO `hx_user_service_point` VALUES ('8', '4', '2');

-- ----------------------------
-- Table structure for `hx_warranty_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_warranty_type`;
CREATE TABLE `hx_warranty_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '质保类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of hx_warranty_type
-- ----------------------------
INSERT INTO `hx_warranty_type` VALUES ('1', '保内');
INSERT INTO `hx_warranty_type` VALUES ('2', '返修');
INSERT INTO `hx_warranty_type` VALUES ('3', '待修');
