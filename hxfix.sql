-- MySQL dump 10.13  Distrib 5.5.20, for Linux (i686)
--
-- Host: localhost    Database: hxfix
-- ------------------------------------------------------
-- Server version	5.5.20-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `hx_component`
--

DROP TABLE IF EXISTS `hx_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_component`
--

LOCK TABLES `hx_component` WRITE;
/*!40000 ALTER TABLE `hx_component` DISABLE KEYS */;
INSERT INTO `hx_component` VALUES (3,'北桥',1,1,'2011年新品'),(4,'BIOS',1,1,NULL),(8,'X900主板',2,2,'申请自动添加'),(9,'示波器',1,1,'申请自动添加'),(10,'xo',1,1,'申请自动添加'),(11,'eeee',1,1,'申请自动添加'),(12,'fdfd',1,2,'申请自动添加'),(13,'aaa',1,1,'申请自动添加'),(14,'bbb',1,1,'申请自动添加'),(15,'如果爱',2,2,'申请自动添加'),(16,'如果不爱',2,2,'申请自动添加'),(17,'d',1,1,'申请自动添加'),(18,'mx',1,1,'申请自动添加'),(19,'sdf',1,1,'申请自动添加');
/*!40000 ALTER TABLE `hx_component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_component_accept`
--

DROP TABLE IF EXISTS `hx_component_accept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_component_accept`
--

LOCK TABLES `hx_component_accept` WRITE;
/*!40000 ALTER TABLE `hx_component_accept` DISABLE KEYS */;
INSERT INTO `hx_component_accept` VALUES (4,1,1,'杭州',3,150,1325513519,'无');
/*!40000 ALTER TABLE `hx_component_accept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_component_apply`
--

DROP TABLE IF EXISTS `hx_component_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_component_apply`
--

LOCK TABLES `hx_component_apply` WRITE;
/*!40000 ALTER TABLE `hx_component_apply` DISABLE KEYS */;
INSERT INTO `hx_component_apply` VALUES (3,8,1,1,1,1,1324219887,'全新',0),(4,9,1,1,1,1,1324653725,'要最好',0),(5,10,1,1,1,1,1324655124,'',0),(6,11,1,1,1,1,1324656155,'',0),(7,12,2,1,1,1,1324657121,'xdfd',0),(8,13,2,1,1,1,1324657233,'aaa',0),(9,14,2,1,1,1,1324657330,'',0),(10,15,1,1,1,1,1324735441,'',0),(11,16,1,1,1,1,1324735471,'',0),(12,17,1,1,1,1,1325388362,'',0),(13,17,1,1,1,1,1325388395,'',0),(14,18,1,1,1,3,1325400102,'m8->m9->mx',0),(15,18,1,1,1,3,1325400175,'m8->m9->mx',0),(16,19,1,1,1,2,1325400299,'sdf',2);
/*!40000 ALTER TABLE `hx_component_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_component_brand`
--

DROP TABLE IF EXISTS `hx_component_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_component_brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='配件品牌表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_component_brand`
--

LOCK TABLES `hx_component_brand` WRITE;
/*!40000 ALTER TABLE `hx_component_brand` DISABLE KEYS */;
INSERT INTO `hx_component_brand` VALUES (1,'Intel'),(2,'华硕');
/*!40000 ALTER TABLE `hx_component_brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_component_model`
--

DROP TABLE IF EXISTS `hx_component_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_component_model` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='配件型号表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_component_model`
--

LOCK TABLES `hx_component_model` WRITE;
/*!40000 ALTER TABLE `hx_component_model` DISABLE KEYS */;
INSERT INTO `hx_component_model` VALUES (1,'EX-21'),(2,'IE98DD');
/*!40000 ALTER TABLE `hx_component_model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_component_purchase`
--

DROP TABLE IF EXISTS `hx_component_purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_component_purchase`
--

LOCK TABLES `hx_component_purchase` WRITE;
/*!40000 ALTER TABLE `hx_component_purchase` DISABLE KEYS */;
INSERT INTO `hx_component_purchase` VALUES (3,1,1,16,19,'杭州天格科技','塔林路5030号',150,'个',1.5,1,1,'无',1325512112,'',2);
/*!40000 ALTER TABLE `hx_component_purchase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_component_stock`
--

DROP TABLE IF EXISTS `hx_component_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_component_stock`
--

LOCK TABLES `hx_component_stock` WRITE;
/*!40000 ALTER TABLE `hx_component_stock` DISABLE KEYS */;
INSERT INTO `hx_component_stock` VALUES (1,3,1,1),(2,4,1,0),(3,8,1,0),(4,9,1,0),(5,10,1,0),(6,11,1,0),(7,12,1,0),(8,13,1,0),(9,14,1,0),(10,15,1,0),(11,16,1,0),(12,17,1,0),(13,18,1,0),(14,19,1,146);
/*!40000 ALTER TABLE `hx_component_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_component_stockout`
--

DROP TABLE IF EXISTS `hx_component_stockout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_component_stockout`
--

LOCK TABLES `hx_component_stockout` WRITE;
/*!40000 ALTER TABLE `hx_component_stockout` DISABLE KEYS */;
INSERT INTO `hx_component_stockout` VALUES (1,1,1,'杭州天格科技',2,1,'asdf','杭州',3,1,'个',160,10,1,'sdfsdfsdf',1,'sefff','月结',1325598604),(2,1,1,'德声',1,1,NULL,'杭州',19,4,'个',5.5,2,2,'无',1,'小王','',1326014398);
/*!40000 ALTER TABLE `hx_component_stockout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_contact_type`
--

DROP TABLE IF EXISTS `hx_contact_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_contact_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='客户联络方式';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_contact_type`
--

LOCK TABLES `hx_contact_type` WRITE;
/*!40000 ALTER TABLE `hx_contact_type` DISABLE KEYS */;
INSERT INTO `hx_contact_type` VALUES (1,'报价'),(2,'回访'),(3,'约定上门');
/*!40000 ALTER TABLE `hx_contact_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_custom_contact`
--

DROP TABLE IF EXISTS `hx_custom_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_custom_contact`
--

LOCK TABLES `hx_custom_contact` WRITE;
/*!40000 ALTER TABLE `hx_custom_contact` DISABLE KEYS */;
INSERT INTO `hx_custom_contact` VALUES (1,5,1,'正常报价.',1324304754),(2,6,2,'上门的',1324305430),(3,6,2,'上门的',1324305471),(4,6,3,'约定上门....',1324305614),(5,6,1,'....................',1324305815),(6,6,2,'...........se',1324305860),(7,6,1,'ok..............',1324305912),(8,5,1,'xeee',1324306095),(9,5,1,'...................sdfa',1324306262),(10,6,1,'报价---',1324629839),(11,8,1,'报价...',1325067035);
/*!40000 ALTER TABLE `hx_custom_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_custom_fetch`
--

DROP TABLE IF EXISTS `hx_custom_fetch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='客户取机,结案表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_custom_fetch`
--

LOCK TABLES `hx_custom_fetch` WRITE;
/*!40000 ALTER TABLE `hx_custom_fetch` DISABLE KEYS */;
INSERT INTO `hx_custom_fetch` VALUES (1,6,2,2,'89883928374',1,1,100,1324826281),(2,5,1,NULL,NULL,2,6,0,1324827008),(3,8,1,NULL,NULL,1,1,10,1325067657),(4,10,1,NULL,NULL,1,1,0,1327916016),(5,11,1,NULL,NULL,1,1,0,1327916453),(6,9,1,NULL,NULL,1,1,0,1327916468),(7,13,1,NULL,NULL,1,1,100,1327919883);
/*!40000 ALTER TABLE `hx_custom_fetch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_custom_type`
--

DROP TABLE IF EXISTS `hx_custom_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_custom_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '客户类型,如直接客户,经销商等',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='客户类型';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_custom_type`
--

LOCK TABLES `hx_custom_type` WRITE;
/*!40000 ALTER TABLE `hx_custom_type` DISABLE KEYS */;
INSERT INTO `hx_custom_type` VALUES (1,'直接客户'),(2,'经销商'),(3,'企业客户'),(4,'邮寄客户');
/*!40000 ALTER TABLE `hx_custom_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_fund_record`
--

DROP TABLE IF EXISTS `hx_fund_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_fund_record`
--

LOCK TABLES `hx_fund_record` WRITE;
/*!40000 ALTER TABLE `hx_fund_record` DISABLE KEYS */;
INSERT INTO `hx_fund_record` VALUES (1,1,1,100,'备件 ','备件 ',1325943736,1,1,100,2,'ttrr44522334','sfwwer323','江沈','二3枯苛二',1325988928,2),(2,9,1,1000000,'玩','开门',1327917619,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `hx_fund_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_logistics_type`
--

DROP TABLE IF EXISTS `hx_logistics_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_logistics_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '物流公司',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='物流单位';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_logistics_type`
--

LOCK TABLES `hx_logistics_type` WRITE;
/*!40000 ALTER TABLE `hx_logistics_type` DISABLE KEYS */;
INSERT INTO `hx_logistics_type` VALUES (1,'申通'),(2,'天天'),(3,'圆通'),(4,'顺丰'),(5,'韵达');
/*!40000 ALTER TABLE `hx_logistics_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_machine_brand`
--

DROP TABLE IF EXISTS `hx_machine_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_machine_brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '品牌名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='机器品牌';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_machine_brand`
--

LOCK TABLES `hx_machine_brand` WRITE;
/*!40000 ALTER TABLE `hx_machine_brand` DISABLE KEYS */;
INSERT INTO `hx_machine_brand` VALUES (1,'联想'),(2,'IBM'),(3,'Acer'),(4,'华硕'),(5,'明基'),(6,'惠普'),(7,'神州'),(8,'MIS'),(9,'方正'),(10,'SONY'),(11,'苹果'),(12,'DELL'),(13,'富士康'),(14,'海尔'),(15,'七喜'),(16,'清华同方'),(17,'东芝');
/*!40000 ALTER TABLE `hx_machine_brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_machine_type`
--

DROP TABLE IF EXISTS `hx_machine_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_machine_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '类别名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='机器类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_machine_type`
--

LOCK TABLES `hx_machine_type` WRITE;
/*!40000 ALTER TABLE `hx_machine_type` DISABLE KEYS */;
INSERT INTO `hx_machine_type` VALUES (1,'笔记本'),(2,'显示器'),(3,'电源'),(4,'台式机'),(5,'投影机'),(6,'硬盘'),(7,'内存'),(8,'液晶电视');
/*!40000 ALTER TABLE `hx_machine_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_pay_type`
--

DROP TABLE IF EXISTS `hx_pay_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_pay_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '付款方式',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='收款方式表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_pay_type`
--

LOCK TABLES `hx_pay_type` WRITE;
/*!40000 ALTER TABLE `hx_pay_type` DISABLE KEYS */;
INSERT INTO `hx_pay_type` VALUES (1,'现金'),(2,'转账支票'),(3,'现金支票'),(4,'网银转账'),(5,'对公汇款'),(6,'月结');
/*!40000 ALTER TABLE `hx_pay_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_payout_detail`
--

DROP TABLE IF EXISTS `hx_payout_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_payout_detail`
--

LOCK TABLES `hx_payout_detail` WRITE;
/*!40000 ALTER TABLE `hx_payout_detail` DISABLE KEYS */;
INSERT INTO `hx_payout_detail` VALUES (1,1,1,'买椅子',100,3,'9983Hidieu-393','五把椅子',1326002084),(2,9,1,'维修',500,2,'12321321321','',1327917696);
/*!40000 ALTER TABLE `hx_payout_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_problem_type`
--

DROP TABLE IF EXISTS `hx_problem_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_problem_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_problem_type`
--

LOCK TABLES `hx_problem_type` WRITE;
/*!40000 ALTER TABLE `hx_problem_type` DISABLE KEYS */;
INSERT INTO `hx_problem_type` VALUES (1,'CPU'),(2,'内存'),(3,'主板'),(4,'BIOS'),(5,'硬盘'),(6,'风扇'),(7,'电池'),(8,'网卡');
/*!40000 ALTER TABLE `hx_problem_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_purchase_type`
--

DROP TABLE IF EXISTS `hx_purchase_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_purchase_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL COMMENT '采购类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='采购类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_purchase_type`
--

LOCK TABLES `hx_purchase_type` WRITE;
/*!40000 ALTER TABLE `hx_purchase_type` DISABLE KEYS */;
INSERT INTO `hx_purchase_type` VALUES (1,'维修'),(2,'销售'),(3,'库存');
/*!40000 ALTER TABLE `hx_purchase_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_record_component`
--

DROP TABLE IF EXISTS `hx_record_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_record_component`
--

LOCK TABLES `hx_record_component` WRITE;
/*!40000 ALTER TABLE `hx_record_component` DISABLE KEYS */;
INSERT INTO `hx_record_component` VALUES (2,5,3,1,0),(3,4,15,1,1),(4,4,16,1,1),(5,5,3,1,0),(6,8,3,1,0);
/*!40000 ALTER TABLE `hx_record_component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_repair_record`
--

DROP TABLE IF EXISTS `hx_repair_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='故障诊断表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_repair_record`
--

LOCK TABLES `hx_repair_record` WRITE;
/*!40000 ALTER TABLE `hx_repair_record` DISABLE KEYS */;
INSERT INTO `hx_repair_record` VALUES (4,6,2,NULL,NULL,'正常',2,2,'无故障',1324734140,1),(5,5,1,1,2,'无法开机',300,1,'',1324826970,1),(6,4,1,2,2,'是中国; 苛地城脸欠有',24,1,'',1324735490,1),(7,8,1,2,2,'花屏',0,1,'',1325067060,1),(8,10,1,2,2,'WFEGSRTJYHR',0,1,'',1327915883,1),(9,9,1,2,3,'1234567',0,1,'',1327915961,1),(10,11,1,2,3,'QWEQDQWDFQD',0,1,'',1327916292,1),(11,13,1,4,4,'重装系统',100,1,'',1327919864,1);
/*!40000 ALTER TABLE `hx_repair_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_repair_type`
--

DROP TABLE IF EXISTS `hx_repair_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_repair_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_repair_type`
--

LOCK TABLES `hx_repair_type` WRITE;
/*!40000 ALTER TABLE `hx_repair_type` DISABLE KEYS */;
INSERT INTO `hx_repair_type` VALUES (1,'加焊'),(2,'更换'),(3,'除尘'),(4,'软件'),(5,'维修');
/*!40000 ALTER TABLE `hx_repair_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_role`
--

DROP TABLE IF EXISTS `hx_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL COMMENT '角色的英文名称',
  `showname` varchar(45) NOT NULL COMMENT '角色中文名称',
  `notes` varchar(500) NOT NULL COMMENT '权限列表，以‘控制器:值，...’这样的格式保存',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_role`
--

LOCK TABLES `hx_role` WRITE;
/*!40000 ALTER TABLE `hx_role` DISABLE KEYS */;
INSERT INTO `hx_role` VALUES (1,'common','维修员','x');
/*!40000 ALTER TABLE `hx_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_service_point`
--

DROP TABLE IF EXISTS `hx_service_point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_service_point` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `short_name` char(2) NOT NULL COMMENT '网点名称简称,必须是英文,如杭州的简称为HZ',
  `desc` varchar(200) DEFAULT NULL COMMENT '描述',
  `total_fund` double DEFAULT '0' COMMENT '网点当前的所有款项总金额',
  PRIMARY KEY (`id`,`name`,`short_name`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='维修服务点表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_service_point`
--

LOCK TABLES `hx_service_point` WRITE;
/*!40000 ALTER TABLE `hx_service_point` DISABLE KEYS */;
INSERT INTO `hx_service_point` VALUES (1,'杭州','HZ','杭州颐高',0),(2,'宁波','NB','天一路18号',0),(3,'安吉','AJ','',0),(4,'宁海','NH','',0),(5,'湖州','HU','',0);
/*!40000 ALTER TABLE `hx_service_point` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_service_record`
--

DROP TABLE IF EXISTS `hx_service_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='服务单记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_service_record`
--

LOCK TABLES `hx_service_record` WRITE;
/*!40000 ALTER TABLE `hx_service_record` DISABLE KEYS */;
INSERT INTO `hx_service_record` VALUES (1,1,1,'asdf','aewe',1,'','32234','234234','asdf','asdf','asdf','sf@ssdfc.com',1,1,1,'asdf','23sdf','asdf23',1,2,'asdf','asdf','asdf','asdf',5,1322645571),(2,1,1,'asdfrer','快递',1,'','32234','234234','asdf','','','sf@ssdfc.com',1,1,1,'asdf','','asdf23',1,2,'','','','',1,1322645611),(3,1,1,'trhfffrdd','王小',2,'','13433221123','','','','','',2,1,1,'遥','','ddfe2344',1,3,'','','','',1,1322719482),(4,1,1,'HZ1112014ED738873ED9C','dfzz',1,'','234234','','','','','',2,1,1,'asf','','asdfsdf',2,2,'','','','',4,1322727680),(5,1,1,'HZ1112014ED73CE9AB613','zdf',1,'','3ws','','','','','',2,2,1,'asdf','','asdfsdf',1,2,'','','','',9,1322728695),(6,1,1,'HZ1112074EDF3AC667D5F','小张',2,'','18292028983','','','','','',1,1,1,'L410','','kiuefjsie',1,2,'','','','',8,1323252540),(7,1,1,'asdf3','sd',2,'','sdf','sdf','','','','',1,2,1,'sdf','sdf','sdf',1,1,'sdf','sdf','sdf','',1,1324906576),(8,1,1,'123461','杭州德购',2,'','56751449','','','','','',1,3,1,'4810T','','02912883020',1,1,'完好','无','无','',9,1325066924),(9,6,1,'HZ1201294F24CA426AF4A','赵健灰',2,'','13857139779','','','','','',3,1,2,'L193','','6M0214670639138',4,3,'良好','底座','开机几秒保护','',9,1327811275),(10,6,1,'HZ1201304F26625E756E9','小宁',1,'','12345678901','','','12345','','',1,3,1,'22323','123456344555','123456789012345678',1,1,'afdsfasfasfsda','asfdsafasasfafasf','asdasfdsafadsfdasasdfdasfas','',9,1327915773),(11,6,1,'HZ1201304F266481A9275','123',1,'','12345678901','12345','','1234567','','',1,2,1,'124','12345678','987654321',4,1,'QEQEQEE','DSFSDFDSF','SDGFAGDABADFBADBADBFADBA','',9,1327916241),(12,1,1,'HZ1201304F266FF8055EA','kie',1,'','18992291','88998832','kksd','sdfk','','',1,1,1,'kie','98388293','ksdsf',1,1,'lsdfsdf','sdfsdf','sdfsdf','sdfsdf',1,1327919168),(13,6,1,'241412','姜鹏飞',1,'','13221072790','','','','','',1,3,1,'4741G','04806909620','84872749',4,1,'一般','无','重装系统','',9,1327919673),(14,9,1,'HZ1201304F2672771FC3E','吵',2,'','1829283873','','','','','',1,2,1,'吸','83833','kdkiesld',1,1,'sdfsdf','sdf','sdf','',1,1327919789);
/*!40000 ALTER TABLE `hx_service_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_service_type`
--

DROP TABLE IF EXISTS `hx_service_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_service_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_service_type`
--

LOCK TABLES `hx_service_type` WRITE;
/*!40000 ALTER TABLE `hx_service_type` DISABLE KEYS */;
INSERT INTO `hx_service_type` VALUES (1,'客户送修'),(2,'上门取机'),(3,'邮件寄送');
/*!40000 ALTER TABLE `hx_service_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_turnover_income`
--

DROP TABLE IF EXISTS `hx_turnover_income`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='营业款收入明细表,备件出库和维修项目的收入自动记录在这里。';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_turnover_income`
--

LOCK TABLES `hx_turnover_income` WRITE;
/*!40000 ALTER TABLE `hx_turnover_income` DISABLE KEYS */;
INSERT INTO `hx_turnover_income` VALUES (1,1,1,NULL,1,'王不','范小',1,260,0,'卖报纸所得',1326012671,1,1,1,NULL,1326809592),(2,1,1,NULL,NULL,NULL,NULL,1,20,0,'备件出库自动生成，出库编号为 2',NULL,1,1,2,'没有发票',1326809607),(3,6,1,NULL,NULL,NULL,NULL,1,0,0,'服务单结案自动生成。 工单号HZ1201304F26625E756E9',NULL,1,NULL,0,NULL,NULL),(4,6,1,NULL,NULL,NULL,NULL,1,0,0,'服务单结案自动生成。 工单号HZ1201304F266481A9275',NULL,1,NULL,0,NULL,NULL),(5,6,1,NULL,NULL,NULL,NULL,1,0,0,'服务单结案自动生成。 工单号HZ1201294F24CA426AF4A',NULL,1,NULL,0,NULL,NULL),(6,9,1,NULL,2,'3213','321321',6,44444,0,'',1327917767,1,NULL,0,NULL,NULL),(7,6,1,NULL,NULL,NULL,NULL,1,100,0,'服务单结案自动生成。 工单号241412',NULL,1,NULL,0,NULL,NULL);
/*!40000 ALTER TABLE `hx_turnover_income` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_user`
--

DROP TABLE IF EXISTS `hx_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_user`
--

LOCK TABLES `hx_user` WRITE;
/*!40000 ALTER TABLE `hx_user` DISABLE KEYS */;
INSERT INTO `hx_user` VALUES (1,'maxwell','e10adc3949ba59abbe56e057f20f883e',1327931305,'',NULL,'administrator,fixer,storekeeper,accounter',0),(2,'alice','753899dc6f5c168044c17da8c2a183bb',1326986380,'',NULL,'fixer',0),(3,'小王','753899dc6f5c168044c17da8c2a183bb',1326382952,'xiao wang',NULL,'fixer',1),(4,'admin','753899dc6f5c168044c17da8c2a183bb',1327808293,'请务删除',NULL,'administrator,fixer,storekeeper,accounter',0),(5,'张杰','753899dc6f5c168044c17da8c2a183bb',1327929810,'',NULL,'administrator,fixer,storekeeper,accounter',0),(6,'李祖健','753899dc6f5c168044c17da8c2a183bb',1327921106,'',NULL,'fixer,administrator,storekeeper',0),(7,'袁鹏涛','753899dc6f5c168044c17da8c2a183bb',NULL,'',NULL,'fixer',0),(8,'石海燕','753899dc6f5c168044c17da8c2a183bb',NULL,'',NULL,'accounter,storekeeper,administrator',0),(9,'王钊','753899dc6f5c168044c17da8c2a183bb',1327919521,'',NULL,'administrator,fixer,storekeeper',0),(10,'宁志刚','753899dc6f5c168044c17da8c2a183bb',NULL,'',NULL,'fixer',0),(11,'何婷','753899dc6f5c168044c17da8c2a183bb',NULL,'',NULL,'storekeeper',0),(12,'严小翠','753899dc6f5c168044c17da8c2a183bb',NULL,'',NULL,'storekeeper',0),(13,'秦勤勤','753899dc6f5c168044c17da8c2a183bb',NULL,'',NULL,'storekeeper',0),(14,'徐华君','753899dc6f5c168044c17da8c2a183bb',NULL,'',NULL,'storekeeper,administrator',0);
/*!40000 ALTER TABLE `hx_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_user_role`
--

DROP TABLE IF EXISTS `hx_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_user_role`
--

LOCK TABLES `hx_user_role` WRITE;
/*!40000 ALTER TABLE `hx_user_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `hx_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_user_service_point`
--

DROP TABLE IF EXISTS `hx_user_service_point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_user_service_point` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `service_point_id` int(11) NOT NULL COMMENT '服务点ID',
  PRIMARY KEY (`id`),
  KEY `FK_hx_user_service_point_user` (`user_id`) USING BTREE,
  KEY `FK_hx_user_service_point_spoint` (`service_point_id`) USING BTREE,
  CONSTRAINT `FK_hx_user_service_point_spoint` FOREIGN KEY (`service_point_id`) REFERENCES `hx_service_point` (`id`),
  CONSTRAINT `FK_hx_user_service_point_user` FOREIGN KEY (`user_id`) REFERENCES `hx_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_user_service_point`
--

LOCK TABLES `hx_user_service_point` WRITE;
/*!40000 ALTER TABLE `hx_user_service_point` DISABLE KEYS */;
INSERT INTO `hx_user_service_point` VALUES (5,1,1),(6,2,1),(7,4,1),(8,4,2),(13,7,1),(16,9,1),(17,10,1),(18,11,1),(19,12,1),(20,13,1),(21,14,1),(34,6,1),(35,6,2),(36,6,3),(37,6,4),(38,6,5),(39,8,1),(40,8,2),(41,8,3),(42,8,4),(43,8,5),(44,5,1),(45,5,2),(46,5,3),(47,5,4),(48,5,5);
/*!40000 ALTER TABLE `hx_user_service_point` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hx_warranty_type`
--

DROP TABLE IF EXISTS `hx_warranty_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hx_warranty_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(45) NOT NULL COMMENT '质保类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hx_warranty_type`
--

LOCK TABLES `hx_warranty_type` WRITE;
/*!40000 ALTER TABLE `hx_warranty_type` DISABLE KEYS */;
INSERT INTO `hx_warranty_type` VALUES (1,'保修'),(2,'返修'),(4,'非保');
/*!40000 ALTER TABLE `hx_warranty_type` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-01-30 21:53:39
