/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50518
Source Host           : localhost:3306
Source Database       : hxfix

Target Server Type    : MYSQL
Target Server Version : 50518
File Encoding         : 65001

Date: 2012-02-02 22:27:26
*/

SET FOREIGN_KEY_CHECKS=0;

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
