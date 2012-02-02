/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50518
Source Host           : localhost:3306
Source Database       : hxfix

Target Server Type    : MYSQL
Target Server Version : 50518
File Encoding         : 65001

Date: 2012-02-02 22:27:11
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='配件表';

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
INSERT INTO `hx_component` VALUES ('20', '82801GBM', '1', '1', '申请自动添加');
INSERT INTO `hx_component` VALUES ('21', '原装适配器', '2', '3', '申请自动添加');

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

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
INSERT INTO `hx_component_apply` VALUES ('17', '20', '10', '14', '1', '2', '1328000284', '', '0');
INSERT INTO `hx_component_apply` VALUES ('18', '21', '1', '16', '3', '2', '1328174649', '19V4.74A', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='配件型号表';

-- ----------------------------
-- Records of hx_component_model
-- ----------------------------
INSERT INTO `hx_component_model` VALUES ('1', 'EX-21');
INSERT INTO `hx_component_model` VALUES ('2', 'IE98DD');
INSERT INTO `hx_component_model` VALUES ('3', 'F8VA');

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='备件库存表';

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
INSERT INTO `hx_component_stock` VALUES ('15', '20', '1', '0');
INSERT INTO `hx_component_stock` VALUES ('16', '21', '3', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

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
INSERT INTO `hx_custom_contact` VALUES ('12', '70', '1', '换屏', '1328162400');
INSERT INTO `hx_custom_contact` VALUES ('13', '70', '1', '换屏', '1328162401');
INSERT INTO `hx_custom_contact` VALUES ('14', '70', '1', '换屏', '1328162443');

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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='客户取机,结案表';

-- ----------------------------
-- Records of hx_custom_fetch
-- ----------------------------
INSERT INTO `hx_custom_fetch` VALUES ('1', '6', '2', '2', '89883928374', '1', '1', '100', '1324826281');
INSERT INTO `hx_custom_fetch` VALUES ('2', '5', '1', null, null, '2', '6', '0', '1324827008');
INSERT INTO `hx_custom_fetch` VALUES ('3', '8', '1', null, null, '1', '1', '10', '1325067657');
INSERT INTO `hx_custom_fetch` VALUES ('4', '10', '1', null, null, '1', '1', '0', '1327916016');
INSERT INTO `hx_custom_fetch` VALUES ('5', '11', '1', null, null, '1', '1', '0', '1327916453');
INSERT INTO `hx_custom_fetch` VALUES ('6', '9', '1', null, null, '1', '1', '0', '1327916468');
INSERT INTO `hx_custom_fetch` VALUES ('7', '13', '1', null, null, '1', '1', '100', '1327919883');
INSERT INTO `hx_custom_fetch` VALUES ('8', '15', '1', null, null, '1', '3', '0', '1327973263');
INSERT INTO `hx_custom_fetch` VALUES ('9', '19', '1', null, null, '1', '1', '0', '1328003985');
INSERT INTO `hx_custom_fetch` VALUES ('10', '27', '1', null, null, '1', '1', '880', '1328076916');
INSERT INTO `hx_custom_fetch` VALUES ('11', '23', '1', null, null, '1', '1', '50', '1328077298');
INSERT INTO `hx_custom_fetch` VALUES ('12', '31', '1', null, null, '1', '1', '0', '1328078030');
INSERT INTO `hx_custom_fetch` VALUES ('13', '33', '1', null, null, '1', '1', '0', '1328079336');
INSERT INTO `hx_custom_fetch` VALUES ('14', '43', '1', null, null, '1', '1', '200', '1328081864');
INSERT INTO `hx_custom_fetch` VALUES ('15', '30', '1', null, null, '2', '1', '0', '1328150226');
INSERT INTO `hx_custom_fetch` VALUES ('16', '66', '1', null, null, '2', '6', '80', '1328152296');
INSERT INTO `hx_custom_fetch` VALUES ('18', '34', '1', null, null, '2', '1', '0', '1328161940');
INSERT INTO `hx_custom_fetch` VALUES ('19', '57', '1', null, null, '2', '1', '0', '1328162070');
INSERT INTO `hx_custom_fetch` VALUES ('20', '71', '1', null, null, '2', '6', '100', '1328163753');
INSERT INTO `hx_custom_fetch` VALUES ('21', '53', '1', null, null, '2', '6', '100', '1328168086');
INSERT INTO `hx_custom_fetch` VALUES ('22', '51', '1', null, null, '2', '6', '80', '1328168161');

-- ----------------------------
-- Table structure for `hx_custom_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_custom_type`;
CREATE TABLE `hx_custom_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '客户类型,如直接客户,经销商等',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='客户类型';

-- ----------------------------
-- Records of hx_custom_type
-- ----------------------------
INSERT INTO `hx_custom_type` VALUES ('1', '直接客户');
INSERT INTO `hx_custom_type` VALUES ('2', '经销商');
INSERT INTO `hx_custom_type` VALUES ('3', '企业客户');
INSERT INTO `hx_custom_type` VALUES ('4', '邮寄客户');
INSERT INTO `hx_custom_type` VALUES ('11', '标准大客户');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='款项申请表';

-- ----------------------------
-- Records of hx_fund_record
-- ----------------------------
INSERT INTO `hx_fund_record` VALUES ('1', '1', '1', '100', '备件 ', '备件 ', '1325943736', '1', '1', '100', '2', 'ttrr44522334', 'sfwwer323', '江沈', '二3枯苛二', '1325988928', '2');
INSERT INTO `hx_fund_record` VALUES ('2', '9', '1', '1000000', '玩', '开门', '1327917619', null, null, null, null, null, null, null, null, null, '1');

-- ----------------------------
-- Table structure for `hx_logistics_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_logistics_type`;
CREATE TABLE `hx_logistics_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '物流公司',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='物流单位';

-- ----------------------------
-- Records of hx_logistics_type
-- ----------------------------
INSERT INTO `hx_logistics_type` VALUES ('1', '申通');
INSERT INTO `hx_logistics_type` VALUES ('2', '天天');
INSERT INTO `hx_logistics_type` VALUES ('3', '圆通');
INSERT INTO `hx_logistics_type` VALUES ('4', '顺丰');
INSERT INTO `hx_logistics_type` VALUES ('5', '韵达');
INSERT INTO `hx_logistics_type` VALUES ('6', '联邦');
INSERT INTO `hx_logistics_type` VALUES ('7', '全一');

-- ----------------------------
-- Table structure for `hx_machine_brand`
-- ----------------------------
DROP TABLE IF EXISTS `hx_machine_brand`;
CREATE TABLE `hx_machine_brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '品牌名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='机器品牌';

-- ----------------------------
-- Records of hx_machine_brand
-- ----------------------------
INSERT INTO `hx_machine_brand` VALUES ('1', '联想');
INSERT INTO `hx_machine_brand` VALUES ('2', 'IBM');
INSERT INTO `hx_machine_brand` VALUES ('3', 'Acer');
INSERT INTO `hx_machine_brand` VALUES ('4', '华硕');
INSERT INTO `hx_machine_brand` VALUES ('5', '明基');
INSERT INTO `hx_machine_brand` VALUES ('6', '惠普');
INSERT INTO `hx_machine_brand` VALUES ('7', '神州');
INSERT INTO `hx_machine_brand` VALUES ('8', 'MIS');
INSERT INTO `hx_machine_brand` VALUES ('9', '方正');
INSERT INTO `hx_machine_brand` VALUES ('10', 'SONY');
INSERT INTO `hx_machine_brand` VALUES ('11', '苹果');
INSERT INTO `hx_machine_brand` VALUES ('12', 'DELL');
INSERT INTO `hx_machine_brand` VALUES ('13', '富士康');
INSERT INTO `hx_machine_brand` VALUES ('14', '海尔');
INSERT INTO `hx_machine_brand` VALUES ('15', '七喜');
INSERT INTO `hx_machine_brand` VALUES ('16', '清华同方');
INSERT INTO `hx_machine_brand` VALUES ('17', '东芝');
INSERT INTO `hx_machine_brand` VALUES ('18', '七彩虹');
INSERT INTO `hx_machine_brand` VALUES ('19', '三星');
INSERT INTO `hx_machine_brand` VALUES ('20', '长城');
INSERT INTO `hx_machine_brand` VALUES ('21', '其他');

-- ----------------------------
-- Table structure for `hx_machine_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_machine_type`;
CREATE TABLE `hx_machine_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '类别名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='机器类型表';

-- ----------------------------
-- Records of hx_machine_type
-- ----------------------------
INSERT INTO `hx_machine_type` VALUES ('1', '笔记本');
INSERT INTO `hx_machine_type` VALUES ('2', '显示器');
INSERT INTO `hx_machine_type` VALUES ('3', '电池');
INSERT INTO `hx_machine_type` VALUES ('4', '台式机');
INSERT INTO `hx_machine_type` VALUES ('5', '投影机');
INSERT INTO `hx_machine_type` VALUES ('6', '硬盘');
INSERT INTO `hx_machine_type` VALUES ('7', '内存');
INSERT INTO `hx_machine_type` VALUES ('8', '液晶电视');
INSERT INTO `hx_machine_type` VALUES ('9', '打印机');
INSERT INTO `hx_machine_type` VALUES ('10', '扫描仪');
INSERT INTO `hx_machine_type` VALUES ('11', '台式机主板');
INSERT INTO `hx_machine_type` VALUES ('12', '笔记本主板');
INSERT INTO `hx_machine_type` VALUES ('13', '适配器');

-- ----------------------------
-- Table structure for `hx_notice`
-- ----------------------------
DROP TABLE IF EXISTS `hx_notice`;
CREATE TABLE `hx_notice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL COMMENT '标题',
  `author` varchar(50) NOT NULL COMMENT '作者',
  `content` varchar(1000) NOT NULL COMMENT '内容',
  `date` int(11) NOT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='公告表';

-- ----------------------------
-- Records of hx_notice
-- ----------------------------
INSERT INTO `hx_notice` VALUES ('1', '杭州正修电子科技有限公司CSS系统测试中', 'admin', '杭州正修电子科技有限公司CSS系统测试中,如发现问题，请反馈。', '1328192560');
INSERT INTO `hx_notice` VALUES ('2', '公告测试', 'admin', '测试中...', '1328192594');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='费用支出表';

-- ----------------------------
-- Records of hx_payout_detail
-- ----------------------------
INSERT INTO `hx_payout_detail` VALUES ('1', '1', '1', '买椅子', '100', '3', '9983Hidieu-393', '五把椅子', '1326002084');
INSERT INTO `hx_payout_detail` VALUES ('2', '9', '1', '维修', '500', '2', '12321321321', '', '1327917696');

-- ----------------------------
-- Table structure for `hx_pay_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_pay_type`;
CREATE TABLE `hx_pay_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '付款方式',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='收款方式表';

-- ----------------------------
-- Records of hx_pay_type
-- ----------------------------
INSERT INTO `hx_pay_type` VALUES ('1', '现金');
INSERT INTO `hx_pay_type` VALUES ('2', '转账支票');
INSERT INTO `hx_pay_type` VALUES ('3', '现金支票');
INSERT INTO `hx_pay_type` VALUES ('4', '网银转账');
INSERT INTO `hx_pay_type` VALUES ('5', '对公汇款');
INSERT INTO `hx_pay_type` VALUES ('6', '月结');
INSERT INTO `hx_pay_type` VALUES ('7', '支付宝');

-- ----------------------------
-- Table structure for `hx_problem_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_problem_type`;
CREATE TABLE `hx_problem_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of hx_problem_type
-- ----------------------------
INSERT INTO `hx_problem_type` VALUES ('1', 'CPU');
INSERT INTO `hx_problem_type` VALUES ('2', '内存');
INSERT INTO `hx_problem_type` VALUES ('3', '主板');
INSERT INTO `hx_problem_type` VALUES ('4', 'BIOS');
INSERT INTO `hx_problem_type` VALUES ('5', '硬盘');
INSERT INTO `hx_problem_type` VALUES ('6', '风扇');
INSERT INTO `hx_problem_type` VALUES ('7', '电池');
INSERT INTO `hx_problem_type` VALUES ('8', '网卡');
INSERT INTO `hx_problem_type` VALUES ('9', '屏');
INSERT INTO `hx_problem_type` VALUES ('12', '软件');

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
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='故障诊断表';

-- ----------------------------
-- Records of hx_repair_record
-- ----------------------------
INSERT INTO `hx_repair_record` VALUES ('4', '6', '2', null, null, '正常', '2', '2', '无故障', '1324734140', '1');
INSERT INTO `hx_repair_record` VALUES ('5', '5', '1', '1', '2', '无法开机', '300', '1', '', '1324826970', '1');
INSERT INTO `hx_repair_record` VALUES ('6', '4', '1', '2', '2', '是中国; 苛地城脸欠有', '24', '1', '', '1324735490', '1');
INSERT INTO `hx_repair_record` VALUES ('7', '8', '1', '2', '2', '花屏', '0', '1', '', '1325067060', '1');
INSERT INTO `hx_repair_record` VALUES ('8', '10', '1', '2', '2', 'WFEGSRTJYHR', '0', '1', '', '1327915883', '1');
INSERT INTO `hx_repair_record` VALUES ('9', '9', '1', '2', '3', '1234567', '0', '1', '', '1327915961', '1');
INSERT INTO `hx_repair_record` VALUES ('10', '11', '1', '2', '3', 'QWEQDQWDFQD', '0', '1', '', '1327916292', '1');
INSERT INTO `hx_repair_record` VALUES ('11', '13', '1', '4', '4', '重装系统', '100', '1', '', '1327919864', '1');
INSERT INTO `hx_repair_record` VALUES ('12', '15', '1', '3', '3', '太脏', '0', '1', '', '1327973217', '1');
INSERT INTO `hx_repair_record` VALUES ('13', '19', '1', '5', '2', 'HDD坏', '0', '1', '', '1328003957', '1');
INSERT INTO `hx_repair_record` VALUES ('14', '14', '1', '2', '2', '更换内存，OK!', '0', '1', '', '1328074552', '1');
INSERT INTO `hx_repair_record` VALUES ('15', '27', '1', '9', '2', '屏碎', '880', '1', '', '1328076857', '1');
INSERT INTO `hx_repair_record` VALUES ('16', '23', '1', '12', '4', '软件升级', '50', '1', '', '1328077238', '1');
INSERT INTO `hx_repair_record` VALUES ('17', '31', '1', '3', '2', '更换主板OK', '0', '1', '', '1328077979', '1');
INSERT INTO `hx_repair_record` VALUES ('18', '33', '2', null, null, '运行正常，无故障', '0', '1', '', '1328079250', '1');
INSERT INTO `hx_repair_record` VALUES ('19', '28', '2', null, null, '运行正常，无故障', '0', '2', '', '1328079455', '1');
INSERT INTO `hx_repair_record` VALUES ('20', '43', '1', '12', '4', '长时间测试未发现故障', '0', '1', '', '1328081688', '1');
INSERT INTO `hx_repair_record` VALUES ('21', '37', '2', null, null, '长时间测试未发现故障', '0', '1', '', '1328082227', '1');
INSERT INTO `hx_repair_record` VALUES ('22', '58', '2', null, null, '未发现故障', '0', '2', '未发现故障', '1328087720', '1');
INSERT INTO `hx_repair_record` VALUES ('23', '55', '1', '3', '2', '不通电，检测更换主板', '80', '1', '', '1328089737', '0');
INSERT INTO `hx_repair_record` VALUES ('24', '30', '1', '3', '2', '接通电源开机但无法显示，更换主板，测试OK', '0', '1', '', '1328150064', '1');
INSERT INTO `hx_repair_record` VALUES ('25', '64', '1', '5', '5', '进不了系统', '0', '1', '', '1328151303', '1');
INSERT INTO `hx_repair_record` VALUES ('26', '66', '1', '7', '5', '电源接口坏', '80', '1', '', '1328152252', '1');
INSERT INTO `hx_repair_record` VALUES ('27', '34', '1', '3', '2', '开机不加电，更换主板，测试OK', '0', '1', '', '1328161896', '1');
INSERT INTO `hx_repair_record` VALUES ('28', '57', '1', '9', '2', '供电模块短路，更换供电模块，测试OK', '0', '1', '', '1328162051', '1');
INSERT INTO `hx_repair_record` VALUES ('29', '70', '1', '9', '2', '屏碎', '430', '1', '', '1328173516', '1');
INSERT INTO `hx_repair_record` VALUES ('30', '71', '1', '3', '1', '修显卡', '100', '1', '', '1328163040', '1');
INSERT INTO `hx_repair_record` VALUES ('31', '53', '1', '3', '1', '维修显卡', '100', '1', '', '1328168066', '1');
INSERT INTO `hx_repair_record` VALUES ('32', '51', '1', '9', '2', '换灯管', '80', '1', '', '1328168138', '1');

-- ----------------------------
-- Table structure for `hx_repair_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_repair_type`;
CREATE TABLE `hx_repair_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of hx_repair_type
-- ----------------------------
INSERT INTO `hx_repair_type` VALUES ('1', '加焊');
INSERT INTO `hx_repair_type` VALUES ('2', '更换');
INSERT INTO `hx_repair_type` VALUES ('3', '除尘');
INSERT INTO `hx_repair_type` VALUES ('4', '软件');
INSERT INTO `hx_repair_type` VALUES ('5', '维修');

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='维修服务点表';

-- ----------------------------
-- Records of hx_service_point
-- ----------------------------
INSERT INTO `hx_service_point` VALUES ('1', '杭州', 'HZ', '杭州颐高', '0');
INSERT INTO `hx_service_point` VALUES ('2', '宁波', 'NB', '天一路18号', '0');
INSERT INTO `hx_service_point` VALUES ('3', '安吉', 'AJ', '', '0');
INSERT INTO `hx_service_point` VALUES ('4', '宁海', 'NH', '', '0');
INSERT INTO `hx_service_point` VALUES ('5', '湖州', 'HU', '', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COMMENT='服务单记录表';

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
INSERT INTO `hx_service_record` VALUES ('9', '6', '1', 'HZ1201294F24CA426AF4A', '赵健灰', '2', '', '13857139779', '', '', '', '', '', '3', '1', '2', 'L193', '', '6M0214670639138', '4', '3', '良好', '底座', '开机几秒保护', '', '9', '1327811275');
INSERT INTO `hx_service_record` VALUES ('10', '6', '1', 'HZ1201304F26625E756E9', '小宁', '1', '', '12345678901', '', '', '12345', '', '', '1', '3', '1', '22323', '123456344555', '123456789012345678', '1', '1', 'afdsfasfasfsda', 'asfdsafasasfafasf', 'asdasfdsafadsfdasasdfdasfas', '', '9', '1327915773');
INSERT INTO `hx_service_record` VALUES ('11', '6', '1', 'HZ1201304F266481A9275', '123', '1', '', '12345678901', '12345', '', '1234567', '', '', '1', '2', '1', '124', '12345678', '987654321', '4', '1', 'QEQEQEE', 'DSFSDFDSF', 'SDGFAGDABADFBADBADBFADBA', '', '9', '1327916241');
INSERT INTO `hx_service_record` VALUES ('12', '1', '1', 'HZ1201304F266FF8055EA', 'kie', '1', '', '18992291', '88998832', 'kksd', 'sdfk', '', '', '1', '1', '1', 'kie', '98388293', 'ksdsf', '1', '1', 'lsdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', '1', '1327919168');
INSERT INTO `hx_service_record` VALUES ('13', '6', '1', '241412', '姜鹏飞', '1', '', '13221072790', '', '', '', '', '', '1', '3', '1', '4741G', '04806909620', '84872749', '4', '1', '一般', '无', '重装系统', '', '9', '1327919673');
INSERT INTO `hx_service_record` VALUES ('14', '9', '1', 'HZ1201304F2672771FC3E', '吵', '2', '', '1829283873', '', '', '', '', '', '1', '2', '1', '吸', '83833', 'kdkiesld', '1', '1', 'sdfsdf', 'sdf', 'sdf', '', '8', '1327919789');
INSERT INTO `hx_service_record` VALUES ('15', '6', '1', '123456', '胡锦涛', '1', '', '110119120', '12345', '中南海国务院', '中南海', '110', '110120119@123.com', '1', '2', '1', 'S1', '123123', '1234567890', '1', '1', '摔的不成样子', '啥玩都某', '不开机', '', '9', '1327973055');
INSERT INTO `hx_service_record` VALUES ('16', '7', '1', '241413', '骆灵均', '2', '', '5677519', '', '杭州德购', '颐高创业大厦（旗舰广场）802', '', '', '1', '3', '1', 'AOD257', '14712390376', 'LUSFV0C0281471E3FF7600', '1', '1', '良好', '只留机', 'KB失灵', '', '1', '1327977445');
INSERT INTO `hx_service_record` VALUES ('17', '7', '1', '241414', '骆灵均', '2', '', '56775149', '', '杭州德购', '颐高创业大厦（旗舰广场）802', '', '', '2', '3', '1', 'S3', '14802833420', 'LXRSF0221214806EAE2000', '1', '1', '良好', '只留机', '硬盘有异响', '', '1', '1327978249');
INSERT INTO `hx_service_record` VALUES ('18', '7', '1', '241417', '李俊', '1', '', '15257198423', '', '', '', '', '', '1', '3', '1', 'AS4738G', '04700796825', 'LXRBM0C00504701F202500', '1', '1', '好', '只留机', 'HDD坏道', '', '1', '1327980123');
INSERT INTO `hx_service_record` VALUES ('19', '11', '1', '2414131', '骆灵均', '2', '', '13655712420', '', '', '', '', '', '1', '3', '1', 'AOD257', '14712390376', 'LUSFV0C0281471E3FF7600', '1', '1', '完好', ' 无', 'KB失灵', '', '9', '1328003670');
INSERT INTO `hx_service_record` VALUES ('20', '11', '1', '241415', '徐晓晨', '1', '', '15858172865', '', '', '', '', '', '1', '3', '1', 'AS4741G', '02501701320', 'LXPXL01003025042752000', '1', '1', '良好', '无', 'HDD坏道', '', '1', '1328004219');
INSERT INTO `hx_service_record` VALUES ('21', '11', '1', '241416', '骆灵均', '2', '', '57156775149', '', '', '', '', '', '1', '3', '1', 'AS4752G', '13309170920', 'LXRSU010011331663D2000', '1', '1', '良品', '无', '蓝屏', '', '1', '1328004444');
INSERT INTO `hx_service_record` VALUES ('22', '17', '4', 'NH1202014F28CE980E55E', '赵雪', '2', '', '15258388037', '', '宁海盛大创奇电脑公司', '宁海县外环路11号', '', '', '4', '6', '4', '2080', '', 'CNG0498X22', '1', '1', '。', '。', '硬盘检测报错4', '', '1', '1328074615');
INSERT INTO `hx_service_record` VALUES ('23', '15', '5', '3003472', '潘丽萍', '1', '', '13819287621', '', '', '湖州吴兴区', '', '', '1', '3', '1', '4810ZG', '02410922620', '0241092262', '4', '1', '有划', '无', '开机进不了系统', '', '9', '1328074760');
INSERT INTO `hx_service_record` VALUES ('24', '17', '4', 'NH1202014F28D15C499D0', '张先生', '3', '', '15058883972', '', '宁海县教育局', '宁海县跃龙街道人民路290号教育局403室', '', '', '4', '6', '9', '5200', '', 'CNHXP26591', '1', '1', '.', '.', '开机报错，顶盖内卡纸', '', '1', '1328075245');
INSERT INTO `hx_service_record` VALUES ('25', '16', '3', '3002007', '朱丽', '2', '', '5305337', '5305337', '安吉恒达电脑', '安吉凤凰路587号', '', '', '1', '17', '1', 'A50', '', '94074423M', '4', '1', '陈旧', '无附件', '开不了机', '', '1', '1328075380');
INSERT INTO `hx_service_record` VALUES ('26', '16', '3', '3002006', '小周', '1', '', '15857212321', '', '', '安吉地铺翠柳苑', '', '', '4', '6', '1', 'V3000', '', '2CE82035FB', '4', '1', '一般，', '无附件', '白屏', '', '1', '1328075878');
INSERT INTO `hx_service_record` VALUES ('27', '17', '4', 'NH1202014F28D3EE600EB', '戴志标', '1', '', '18768009996', '', '', '', '', '', '4', '3', '1', '4745G', '01207728725', 'LXPSL0100201212DE72502', '4', '1', '划', '无', '屏坏', '', '9', '1328075920');
INSERT INTO `hx_service_record` VALUES ('28', '16', '3', '3002004', '徐昊', '2', '', '137572778498', '', '安吉普天下电脑', '安吉高禹', '', '', '1', '6', '1', '541', '', 'CNU9127Y7T', '4', '1', '一般，无损坏', '无附件', '进入系统后蓝屏', '', '4', '1328076259');
INSERT INTO `hx_service_record` VALUES ('29', '18', '1', 'HZ1202014F28D95D7613B', '杨松铭', '1', '', '15355002400', '', '', '百脑汇大厦1123室', '', '', '1', '3', '1', 'acer/AOHAPPY2-13Cb2b', '13405889776', 'LUSFY0C0181340E6117600', '1', '1', '完好', '有电池', '用电池键盘无法使用，使用外接电源进主板BIOS设置会死机', '售前', '1', '1328077397');
INSERT INTO `hx_service_record` VALUES ('30', '17', '4', 'NH1202014F28DAC6F3EA9', '余先生', '2', '', '65220035', '65220035', '宁海昭阳电脑', '', '', '', '1', '6', '1', '321', '', 'CNU03733S5', '1', '1', '划', '无', '无法开机', '', '9', '1328077648');
INSERT INTO `hx_service_record` VALUES ('31', '10', '1', '241458', '吴杰良', '1', '', '13701992821', '', '', '', '', '', '1', '3', '1', 'AM1660', '11400612396', 'PTSFB0C028114017EB9600', '1', '1', '完好', '无', '有时开不了机', '', '9', '1328077871');
INSERT INTO `hx_service_record` VALUES ('32', '12', '1', '241462', '王丽娟', '2', '', '15158198521', '', '', '', '', '', '1', '3', '1', '4752', '14202805766', 'LXRST0100614206D996600', '1', '1', '完好', '无', '有时白屏', '只检测', '1', '1328078005');
INSERT INTO `hx_service_record` VALUES ('33', '16', '3', '3002005', '陈阿姨', '2', '', '5211122', '5211122', '安吉创新电脑', '安吉凤凰路276号', '', '', '1', '2', '1', 'T41', '', '99-KW202', '4', '1', '一般', '无附件', '有时开不了机', '', '9', '1328078014');
INSERT INTO `hx_service_record` VALUES ('34', '17', '4', 'NH1202014F28DBF3400C7', '陈科富', '1', '', '15867585868', '', '', '', '', '', '1', '3', '1', '4752G', '14301180066', 'LXRSX0100614302E', '1', '1', '良', '无', '主板不加电', '', '9', '1328078057');
INSERT INTO `hx_service_record` VALUES ('35', '18', '1', '241445', '易永朝', '2', '', '15858206400 ', '56893902', '杭州E线空间有限公司 ', '文三路369号901室', '', '', '1', '3', '1', 'acer/AS6530G-721G25Mn-3', '90610009425', 'LXAUS0C003906186FE2500', '1', '1', '一般', '有电池', '开不了机', '', '1', '1328078171');
INSERT INTO `hx_service_record` VALUES ('36', '18', '1', '241448', '张浩', '1', '', '56775290', '', '', '', '', '', '1', '3', '1', 'acer/AS4741G-433G32Mnck-1', '02710081620', 'LXR1N0C007027189D02000', '1', '1', '完好', '有电池', '卡顿', '', '1', '1328078348');
INSERT INTO `hx_service_record` VALUES ('37', '12', '1', '241463', '王丽娟', '2', '', '15158198521', '', '', '', '', '', '1', '3', '1', '4352', '15104288566', 'NXRZ7CN0011510A7856600', '1', '1', '完好', '无', '有亮线', '售前', '8', '1328078366');
INSERT INTO `hx_service_record` VALUES ('38', '16', '3', '3002002', '张建勇', '2', '', '13868267260', '', '安吉博大电脑', '安吉特色街38号', '', '', '1', '18', '11', '无', '', '98M0AC569934', '4', '1', '单板一块', '无附件', '点不亮', '', '1', '1328078371');
INSERT INTO `hx_service_record` VALUES ('39', '18', '1', '241449', '盛瑞产', '1', '', '13386503197', '', '', '', '', '', '1', '3', '1', 'acer/AS3750G-2312G50Mnkk', '11502124365', 'LXRGV01005115052FB6500', '1', '1', '完好', '有电池', '喇叭破音', '', '1', '1328078458');
INSERT INTO `hx_service_record` VALUES ('40', '18', '1', '241450', '省卓伟', '1', '', '15251738368', '', '', '', '', '', '1', '3', '1', 'acer/AS4741G-332G32Mnkk', '01908193620', 'LXPXL01003019140102000', '1', '3', '完好', '无电池', 'HDD有坏道', '', '1', '1328078562');
INSERT INTO `hx_service_record` VALUES ('41', '16', '3', '3002003', '王军', '1', '', '15857293855', '', '', '天荒坪横路村', '', '', '1', '16', '1', 'X500', '', '407067000067360057', '4', '1', '一般', '无附件', '装不了系统，开机后黑屏', '', '1', '1328078678');
INSERT INTO `hx_service_record` VALUES ('42', '16', '3', '3002008', '程彬彬', '2', '', '13905821544', '', '孝丰博美电脑', '安吉孝丰', '', '', '1', '4', '4', '无', '', 'B4M0AB068703', '4', '1', '好', '无附件', '点不亮', '', '1', '1328078970');
INSERT INTO `hx_service_record` VALUES ('43', '15', '5', 'HU1202014F28E7F110CA43003473', '姜冰峰', '1', '', '13857242275', '2055199', '', '湖州吴兴区', '', '', '1', '3', '1', '4741G', '', '02505888220', '4', '1', '有划', '无', 'USB接口坏', '', '9', '1328081055');
INSERT INTO `hx_service_record` VALUES ('44', '15', '5', '6153393', '俞恒明', '1', '', '13868278250', '', '', '湖州颐高B2-35', '', '', '1', '3', '2', 'G195W', '', '11802257340', '1', '1', '有划', '有支架底坐', '花屏', '', '1', '1328081743');
INSERT INTO `hx_service_record` VALUES ('45', '9', '1', 'HZ1202014F28ED77AF69B', '需要', '2', '', '43442', '', '', '', '', '', '2', '2', '1', '5432', '5432543254325', '3432143214', '2', '3', '5432', '5432', '54325432', '', '1', '1328082339');
INSERT INTO `hx_service_record` VALUES ('46', '9', '1', '3000537', '五隆', '2', '', '82591', '', '', '', '', '', '1', '1', '1', 'G475', '', 'CB10797218', '4', '3', '很好', '有电池', '换屏', '', '1', '1328082607');
INSERT INTO `hx_service_record` VALUES ('47', '15', '5', '6153229', '王家寅', '1', '', '18606828112', '', '', '凤凰路美都花苑16幢2单元503', '', '', '1', '3', '1', '4741G', '', '01905636520', '1', '1', '有划', '无', '黑屏', '', '1', '1328082835');
INSERT INTO `hx_service_record` VALUES ('48', '15', '5', '6152026', '陆志洪', '2', '', '05726032817', '6032817', '长兴龙信电脑', '长兴金陵中路475号', '', '', '3', '3', '1', '4750G', '', '10308441720', '1', '1', '有划', '无', '白屏', '', '1', '1328082998');
INSERT INTO `hx_service_record` VALUES ('49', '15', '5', '3003471', '周骏', '2', '', '15336996608', '', '湖州兰枫电脑', '湖州劳动路', '', '', '1', '19', '2', '711N', '', 'MJ17HVCLC05125R', '4', '1', '有划', '有支架底坐', '排线坏', '', '1', '1328083152');
INSERT INTO `hx_service_record` VALUES ('50', '15', '5', '3003470', '周骏', '2', '', '15336996608', '', '湖州兰枫电脑', '湖州劳动路', '', '', '1', '3', '1', '3260', '', '72003196825', '4', '1', '有划，AB壳摔裂隙', '无', 'AB壳裂隙', '', '1', '1328083340');
INSERT INTO `hx_service_record` VALUES ('51', '15', '5', '3003475', '万联', '2', '', '13325725189', '', '万联', '', '', '', '2', '5', '1', 'R42', '', '9H05J1110671800233DHR400', '4', '3', '有划', '笔记本包', '换灯管', '', '9', '1328083546');
INSERT INTO `hx_service_record` VALUES ('52', '15', '5', '3003476', '经典', '2', '', '13819282567', '', '湖州经典办公', '', '', '', '2', '12', '1', '1400', '', '21658990569', '4', '3', '有划', '有键盘膜', '不显示', '', '1', '1328083670');
INSERT INTO `hx_service_record` VALUES ('53', '15', '5', '3003474', '奥德', '2', '', '7271387', '', '湖州奥德计算机技术有限公司', '湖州颐高数码A2-31号', '', '', '2', '6', '1', 'DV2000', '', '2CE8020VTV', '4', '3', '有划', '无', '不显示', '', '9', '1328083812');
INSERT INTO `hx_service_record` VALUES ('54', '16', '3', '3002009', '老吴', '2', '', '15957230970', '', '安吉中迅电脑', '安吉浦源大道618号', '', '', '1', '12', '1', '1440', '', '2740491253', '4', '1', '一般', '无附件', '触摸板进水', '', '1', '1328084034');
INSERT INTO `hx_service_record` VALUES ('55', '16', '3', '3002010', '老吴', '2', '', '15957230970', '', '安吉中迅电脑', '安吉浦源大道618号', '', '', '1', '3', '2', 'AL1716A', '', '71700614842', '4', '1', '一般', '电源线一根', '不通电', '', '3', '1328084129');
INSERT INTO `hx_service_record` VALUES ('56', '17', '4', 'NH1202014F28FF3C4212E', '邬先生', '2', '', '13738847433', '', '豆丁电脑', '宁海西店', '', '', '1', '3', '1', '4741G', '01300834720', 'LXPU00C0340130209B2000', '1', '1', '。', '。', '无声音', '', '1', '1328087241');
INSERT INTO `hx_service_record` VALUES ('57', '17', '4', 'NH1202014F29012D4C144', '张建飞', '2', '', '13646610352', '', '现代电脑', '宁海兴宁南路435号', '', '', '1', '3', '2', 'V193WV', '04005953042', '。', '1', '1', '.', '.', '不加电', '', '9', '1328087495');
INSERT INTO `hx_service_record` VALUES ('58', '17', '4', 'NH1202014F2902018B7F1', '娄先生', '2', '', '13857426642', '', '宝信电脑', '', '', '', '1', '3', '1', '4743G', '13403273920', '。', '1', '1', '.', '。', '无法开机', '', '4', '1328087645');
INSERT INTO `hx_service_record` VALUES ('59', '17', '4', 'NH1202014F2908335B68B', '邬平海', '2', '', '13738847433', '', '豆丁电脑', '', '', '', '1', '3', '1', '4738ZG', '04903522825', 'LXRBQ0C0010490899C2500', '1', '1', '划', '无', '无法开机', '', '1', '1328089271');
INSERT INTO `hx_service_record` VALUES ('60', '15', '5', '6154925', '费晓东', '2', '', '15857255698', '', '湖州中鼎网络有限公司', '湖州颐高A139-A149（一楼大门口）', '', '', '2', '3', '6', 'AM1850', '', '02902424730', '1', '1', '良好', '无机器', '硬盘有坏道', '', '1', '1328148232');
INSERT INTO `hx_service_record` VALUES ('61', '15', '5', '6154902', '熊志强', '1', '', '15283234901', '', '', '浙江省湖州市吉山二路6号楼4', '', '', '1', '3', '1', 'ID57H', '', '13004229616', '1', '3', '一般', '无', '屏显示异常', 'GATEWAY', '1', '1328148967');
INSERT INTO `hx_service_record` VALUES ('62', '15', '5', '6154865', '费晓东', '2', '', '15857255698', '', '湖州中鼎网络有限公司', '湖州颐高A139-A149（一楼大门口）', '', '', '2', '3', '1', '4741G', '', '02014634820', '1', '3', '一般', '键盘膜', '不能上网', '', '1', '1328149117');
INSERT INTO `hx_service_record` VALUES ('63', '17', '4', 'NH1202024F29F7463A3B3', ' 葛女士', '3', '', '13566553226 ', '0574-83556062', '浙江宁波市宁海县图书馆', '浙江宁波市宁海县跃龙街道桃园北路9号', '', '', '4', '6', '4', '3080', '', 'CNG01531T7', '1', '1', '良', '无', 'bios中硬盘检测返回值7', '', '1', '1328150485');
INSERT INTO `hx_service_record` VALUES ('64', '16', '3', '000229', '邓飞', '2', '', '15088375778', '', '安吉胜宁电器', '安吉胜利路33-47号', '', '', '1', '3', '1', '4743G', '', '12503975020', '1', '1', '好', '无附件', '进不了系统', '我处检测硬盘问题', '8', '1328150955');
INSERT INTO `hx_service_record` VALUES ('65', '16', '3', '3002012', '赵辉', '2', '', '7722168', '', '安吉视听郎电脑', '安吉建设路28号', '', '', '1', '6', '1', '520', '', 'CND7401L4L', '4', '1', '一般', '无附件', '点不亮', '', '1', '1328151488');
INSERT INTO `hx_service_record` VALUES ('66', '16', '3', '3002011', '王丽红', '2', '', '5225168', '', '安吉惠普服务中心', '安吉浦源大道296号', '', '', '1', '3', '1', '4741G', '', '02500033220', '4', '1', '好', '无附件', '电源接口坏', '', '9', '1328152169');
INSERT INTO `hx_service_record` VALUES ('67', '16', '3', '3002014', '李总', '2', '', '13059902909', '', '孝丰奔腾电脑', '安吉孝丰', '', '', '1', '6', '1', 'V3000', '', '2CE8282QQZ', '4', '1', '一般', '无附件', '花屏', '', '1', '1328153768');
INSERT INTO `hx_service_record` VALUES ('68', '16', '3', '3002015', '小陶', '2', '', '155557216951', '', '安吉胜宁电器', '不触发', '', '', '1', '17', '1', 'L551', '', '1A053516Q', '4', '1', '一般', '无附件', '不触发', '', '1', '1328156415');
INSERT INTO `hx_service_record` VALUES ('69', '15', '5', '6155983', '王加欢', '1', '', '18257223102', '3929278', '', '织里长安路70号', '', '', '1', '3', '1', '4738ZG', '', '03404424525', '1', '1', '一般', '无', '硬盘有坏道', '', '1', '1328159935');
INSERT INTO `hx_service_record` VALUES ('70', '17', '4', 'NH1202024F2A25758B922', '未知', '2', '', '13757462190', '', '金手数码', '', '', '', '1', '1', '1', 'E10', '', 'LR-07ENM', '4', '1', '划', '无', '屏碎', '', '8', '1328162310');
INSERT INTO `hx_service_record` VALUES ('71', '15', '5', '3003477', '费晓东', '2', '', '15857255698', '', '湖州中鼎网络有限公司', '湖州颐高A139-A149（一楼大门口）', '', '', '1', '4', '1', 'A8T', '', '78N0AS382805', '4', '2', '有划', '无', '显卡坏', '', '9', '1328162884');
INSERT INTO `hx_service_record` VALUES ('72', '15', '5', '6156355', '简冰华', '1', '', '13587291243', '', '', '湖州市干金镇卫生院', '', '', '1', '3', '1', '4750G', '', '10907654120', '1', '3', '良', '无', '掉电', '', '1', '1328163584');
INSERT INTO `hx_service_record` VALUES ('73', '16', '3', '3002020', '苏学伟', '2', '', '7710883', '', '安吉现代电脑', '安吉人民路', '', '', '1', '4', '1', 'A6000', '', '69N0AC038558', '4', '1', '陈旧', '无附件', '开不了机', 'B壳严重腐蚀，脱落，', '1', '1328166769');
INSERT INTO `hx_service_record` VALUES ('74', '16', '3', '3002017', '小洪', '2', '', '15657276345', '', '安吉锋行电脑', '安吉特色街', '', '', '1', '1', '1', 'R400', '', 'L3-AEL7G', '4', '1', '一般', '无附件', '屏亮线，D壳坏，电池坏', '', '1', '1328166902');
INSERT INTO `hx_service_record` VALUES ('75', '16', '3', '3002018', '小莫', '2', '', '13216506507', '', '安吉丰林', '安吉步行街', '', '', '1', '4', '1', '1008HA', '', '950AAS138343', '4', '1', '好', '无附件', '半截白屏，半截正常', '', '1', '1328168534');
INSERT INTO `hx_service_record` VALUES ('76', '16', '3', '3002019', '蒋余军', '2', '', '13819218690', '', '孝丰联义电脑', '安吉孝丰', '', '', '1', '20', '1', 'R195B', '', 'MT57224C4840034', '4', '1', '一般', '底座', '黑屏', '', '1', '1328168664');
INSERT INTO `hx_service_record` VALUES ('77', '16', '3', '3002016', '鑫源', '2', '', '5122053', '', '安吉鑫源电脑', '安吉苕溪路', '', '', '5', '4', '13', 'F8VA', '', '原装', '4', '1', '全装全新', '无附件', '销售华硕原装适配器一个', '', '1', '1328174520');
INSERT INTO `hx_service_record` VALUES ('78', '16', '3', '3002021', '赵辉', '2', '', '7722168', '', '安吉视听郎电脑', '安吉建设路28号', '', '', '1', '1', '1', '14001', '', 'EB06420169', '4', '1', '好', '无附件', '难开机，键盘不灵', '', '1', '1328176145');
INSERT INTO `hx_service_record` VALUES ('79', '16', '3', '3002022', '赵辉', '2', '', '7722168', '', '安吉视听郎电脑', '安吉建设路28号', '', '', '1', '1', '1', 'G230', '', 'EB09+500728', '4', '1', '好', '无附件', '电池接口处断', '', '1', '1328176492');
INSERT INTO `hx_service_record` VALUES ('80', '16', '3', '3002023', '陈阿姨', '2', '', '5211122', '', '安吉创新电脑', '安吉凤凰路376号', '', '', '1', '6', '2', 'L1908W', '', '3CQ8201QTG', '4', '1', '好', '底座', '黑屏', '', '1', '1328176915');

-- ----------------------------
-- Table structure for `hx_service_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_service_type`;
CREATE TABLE `hx_service_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of hx_service_type
-- ----------------------------
INSERT INTO `hx_service_type` VALUES ('1', '客户送修');
INSERT INTO `hx_service_type` VALUES ('2', '上门取机');
INSERT INTO `hx_service_type` VALUES ('3', '邮件寄送');
INSERT INTO `hx_service_type` VALUES ('4', '上门维修');
INSERT INTO `hx_service_type` VALUES ('5', '销售备件');

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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='营业款收入明细表,备件出库和维修项目的收入自动记录在这里。';

-- ----------------------------
-- Records of hx_turnover_income
-- ----------------------------
INSERT INTO `hx_turnover_income` VALUES ('1', '1', '1', null, '1', '王不', '范小', '1', '260', '0', '卖报纸所得', '1326012671', '1', '1', '1', null, '1326809592');
INSERT INTO `hx_turnover_income` VALUES ('2', '1', '1', null, null, null, null, '1', '20', '0', '备件出库自动生成，出库编号为 2', null, '1', '1', '2', '没有发票', '1326809607');
INSERT INTO `hx_turnover_income` VALUES ('3', '6', '1', null, null, null, null, '1', '0', '0', '服务单结案自动生成。 工单号HZ1201304F26625E756E9', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('4', '6', '1', null, null, null, null, '1', '0', '0', '服务单结案自动生成。 工单号HZ1201304F266481A9275', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('5', '6', '1', null, null, null, null, '1', '0', '0', '服务单结案自动生成。 工单号HZ1201294F24CA426AF4A', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('6', '9', '1', null, '2', '3213', '321321', '6', '44444', '0', '', '1327917767', '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('7', '6', '1', null, null, null, null, '1', '100', '0', '服务单结案自动生成。 工单号241412', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('8', '6', '1', null, null, null, null, '3', '0', '0', '服务单结案自动生成。 工单号123456', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('9', '11', '1', null, null, null, null, '1', '0', '0', '服务单结案自动生成。 工单号2414131', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('10', '17', '4', null, null, null, null, '1', '880', '0', '服务单结案自动生成。 工单号NH1202014F28D3EE600EB', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('11', '15', '5', null, null, null, null, '1', '50', '0', '服务单结案自动生成。 工单号3003472', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('12', '10', '1', null, null, null, null, '1', '0', '0', '服务单结案自动生成。 工单号241458', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('13', '16', '3', null, null, null, null, '1', '0', '0', '服务单结案自动生成。 工单号3002005', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('14', '15', '5', null, null, null, null, '1', '200', '0', '服务单结案自动生成。 工单号HU1202014F28E7F110CA43003473', null, '1', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('15', '17', '4', null, null, null, null, '1', '0', '0', '服务单结案自动生成。 工单号NH1202014F28DAC6F3EA9', null, '2', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('16', '16', '3', null, null, null, null, '6', '80', '0', '服务单结案自动生成。 工单号3002011', null, '2', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('17', '17', '4', null, null, null, null, '1', '0', '0', '服务单结案自动生成。 工单号NH1202014F28DBF3400C7', null, '2', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('18', '17', '4', null, null, null, null, '1', '0', '0', '服务单结案自动生成。 工单号NH1202014F29012D4C144', null, '2', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('19', '15', '5', null, null, null, null, '6', '100', '0', '服务单结案自动生成。 工单号3003477', null, '2', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('20', '15', '5', null, null, null, null, '6', '100', '0', '服务单结案自动生成。 工单号3003474', null, '2', null, '0', null, null);
INSERT INTO `hx_turnover_income` VALUES ('21', '15', '5', null, null, null, null, '6', '80', '0', '服务单结案自动生成。 工单号3003475', null, '2', null, '0', null, null);

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='用户表';

-- ----------------------------
-- Records of hx_user
-- ----------------------------
INSERT INTO `hx_user` VALUES ('1', 'maxwell', 'e10adc3949ba59abbe56e057f20f883e', '1328186011', '', null, 'administrator,fixer,storekeeper,accounter', '0');
INSERT INTO `hx_user` VALUES ('2', 'alice', '753899dc6f5c168044c17da8c2a183bb', '1326986380', '', null, 'fixer', '1');
INSERT INTO `hx_user` VALUES ('3', '小王', '753899dc6f5c168044c17da8c2a183bb', '1326382952', 'xiao wang', null, 'fixer', '1');
INSERT INTO `hx_user` VALUES ('4', 'admin', '753899dc6f5c168044c17da8c2a183bb', '1327996467', '请务删除', null, 'administrator,fixer,storekeeper,accounter', '0');
INSERT INTO `hx_user` VALUES ('5', '张杰', '753899dc6f5c168044c17da8c2a183bb', '1328082333', '', null, 'administrator,fixer,storekeeper,accounter', '0');
INSERT INTO `hx_user` VALUES ('6', '李祖健', '753899dc6f5c168044c17da8c2a183bb', '1328073847', '', null, 'fixer,administrator,storekeeper', '0');
INSERT INTO `hx_user` VALUES ('7', '袁鹏涛', '753899dc6f5c168044c17da8c2a183bb', '1328071530', '', null, 'fixer', '0');
INSERT INTO `hx_user` VALUES ('8', '石海燕', '753899dc6f5c168044c17da8c2a183bb', '1328171148', '', null, 'accounter,storekeeper,administrator', '0');
INSERT INTO `hx_user` VALUES ('9', '王钊', '753899dc6f5c168044c17da8c2a183bb', '1328177916', '', null, 'administrator,fixer,storekeeper', '0');
INSERT INTO `hx_user` VALUES ('10', '宁志刚', '753899dc6f5c168044c17da8c2a183bb', '1328077651', '', null, 'fixer', '0');
INSERT INTO `hx_user` VALUES ('11', '何婷', '753899dc6f5c168044c17da8c2a183bb', '1328057835', '', null, 'storekeeper', '0');
INSERT INTO `hx_user` VALUES ('12', '严小翠', '753899dc6f5c168044c17da8c2a183bb', '1328170870', '', null, 'storekeeper', '0');
INSERT INTO `hx_user` VALUES ('13', '秦勤勤', '753899dc6f5c168044c17da8c2a183bb', null, '', null, 'storekeeper', '0');
INSERT INTO `hx_user` VALUES ('14', '徐华君', '753899dc6f5c168044c17da8c2a183bb', '1328169635', '', null, 'storekeeper,administrator,fixer,accounter', '0');
INSERT INTO `hx_user` VALUES ('15', '林星', '753899dc6f5c168044c17da8c2a183bb', '1328179736', '', null, 'administrator,fixer,storekeeper,accounter', '0');
INSERT INTO `hx_user` VALUES ('16', '王银凤', '753899dc6f5c168044c17da8c2a183bb', '1328175400', '', null, 'administrator,fixer,storekeeper,accounter', '0');
INSERT INTO `hx_user` VALUES ('17', '高莉萍', '753899dc6f5c168044c17da8c2a183bb', '1328173333', '', null, 'administrator,fixer,storekeeper,accounter', '0');
INSERT INTO `hx_user` VALUES ('18', '蒋爱燕', '753899dc6f5c168044c17da8c2a183bb', '1328171174', '', null, 'administrator,fixer,storekeeper,accounter', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of hx_user_service_point
-- ----------------------------
INSERT INTO `hx_user_service_point` VALUES ('5', '1', '1');
INSERT INTO `hx_user_service_point` VALUES ('7', '4', '1');
INSERT INTO `hx_user_service_point` VALUES ('8', '4', '2');
INSERT INTO `hx_user_service_point` VALUES ('13', '7', '1');
INSERT INTO `hx_user_service_point` VALUES ('16', '9', '1');
INSERT INTO `hx_user_service_point` VALUES ('17', '10', '1');
INSERT INTO `hx_user_service_point` VALUES ('18', '11', '1');
INSERT INTO `hx_user_service_point` VALUES ('19', '12', '1');
INSERT INTO `hx_user_service_point` VALUES ('20', '13', '1');
INSERT INTO `hx_user_service_point` VALUES ('34', '6', '1');
INSERT INTO `hx_user_service_point` VALUES ('35', '6', '2');
INSERT INTO `hx_user_service_point` VALUES ('36', '6', '3');
INSERT INTO `hx_user_service_point` VALUES ('37', '6', '4');
INSERT INTO `hx_user_service_point` VALUES ('38', '6', '5');
INSERT INTO `hx_user_service_point` VALUES ('39', '8', '1');
INSERT INTO `hx_user_service_point` VALUES ('40', '8', '2');
INSERT INTO `hx_user_service_point` VALUES ('41', '8', '3');
INSERT INTO `hx_user_service_point` VALUES ('42', '8', '4');
INSERT INTO `hx_user_service_point` VALUES ('43', '8', '5');
INSERT INTO `hx_user_service_point` VALUES ('44', '5', '1');
INSERT INTO `hx_user_service_point` VALUES ('45', '5', '2');
INSERT INTO `hx_user_service_point` VALUES ('46', '5', '3');
INSERT INTO `hx_user_service_point` VALUES ('47', '5', '4');
INSERT INTO `hx_user_service_point` VALUES ('48', '5', '5');
INSERT INTO `hx_user_service_point` VALUES ('49', '15', '5');
INSERT INTO `hx_user_service_point` VALUES ('50', '16', '3');
INSERT INTO `hx_user_service_point` VALUES ('51', '17', '4');
INSERT INTO `hx_user_service_point` VALUES ('53', '14', '1');
INSERT INTO `hx_user_service_point` VALUES ('54', '18', '1');
INSERT INTO `hx_user_service_point` VALUES ('55', '18', '2');
INSERT INTO `hx_user_service_point` VALUES ('56', '18', '3');
INSERT INTO `hx_user_service_point` VALUES ('57', '18', '4');
INSERT INTO `hx_user_service_point` VALUES ('58', '18', '5');

-- ----------------------------
-- Table structure for `hx_warranty_type`
-- ----------------------------
DROP TABLE IF EXISTS `hx_warranty_type`;
CREATE TABLE `hx_warranty_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '质保类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of hx_warranty_type
-- ----------------------------
INSERT INTO `hx_warranty_type` VALUES ('1', '保修');
INSERT INTO `hx_warranty_type` VALUES ('2', '返修');
INSERT INTO `hx_warranty_type` VALUES ('4', '非保');
