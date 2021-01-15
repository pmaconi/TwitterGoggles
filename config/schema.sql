
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for hashtag
-- ----------------------------
DROP TABLE IF EXISTS `hashtag`;
CREATE TABLE `hashtag` (
  `hashtag_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` varchar(20) NOT NULL,
  `text` varchar(145) NOT NULL,
  `index_start` tinyint unsigned NOT NULL,
  `index_end` tinyint unsigned NOT NULL,
  `job_id` int unsigned NOT NULL,
  `analysis_state` int DEFAULT '0',
  PRIMARY KEY (`hashtag_id`),
  KEY `analysisindex` (`analysis_state`)
) ENGINE=InnoDB AUTO_INCREMENT=707 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for history
-- ----------------------------
DROP TABLE IF EXISTS `history`;
CREATE TABLE `history` (
  `history_id` int unsigned NOT NULL AUTO_INCREMENT,
  `job_id` int unsigned NOT NULL,
  `oauth_id` int unsigned NOT NULL,
  `timestamp` datetime NOT NULL,
  `status` varchar(7) NOT NULL,
  `total_results` int(10) unsigned zerofill DEFAULT NULL,
  PRIMARY KEY (`history_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for job
-- ----------------------------
DROP TABLE IF EXISTS `job`;
CREATE TABLE `job` (
  `job_id` int unsigned NOT NULL AUTO_INCREMENT,
  `state` int NOT NULL DEFAULT '0',
  `zombie_head` int DEFAULT NULL,
  `since_id_str` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `query` text NOT NULL,
  `description` varchar(255) DEFAULT 'I am a lazy piece of shit and I did not enter a description',
  `last_count` int(10) unsigned zerofill DEFAULT NULL,
  `last_run` datetime DEFAULT NULL,
  `analysis_state` int DEFAULT '0',
  `oauth_id` int unsigned NOT NULL,
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for mention
-- ----------------------------
DROP TABLE IF EXISTS `mention`;
CREATE TABLE `mention` (
  `mention_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` varchar(20) NOT NULL,
  `screen_name` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  `id_str` varchar(45) NOT NULL,
  `index_start` tinyint unsigned NOT NULL,
  `index_end` tinyint unsigned NOT NULL,
  `job_id` int unsigned NOT NULL,
  `analysis_state` int DEFAULT '0',
  PRIMARY KEY (`mention_id`),
  KEY `analysis_state` (`analysis_state`),
  KEY `tweet_id` (`tweet_id`),
  KEY `user` (`id_str`)
) ENGINE=InnoDB AUTO_INCREMENT=14095 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for oauth
-- ----------------------------
DROP TABLE IF EXISTS `oauth`;
CREATE TABLE `oauth` (
  `oauth_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `consumer_key` varchar(255) NOT NULL,
  `consumer_secret` varchar(255) NOT NULL,
  `access_token` varchar(255) NOT NULL,
  `access_token_secret` varchar(255) NOT NULL,
  PRIMARY KEY (`oauth_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for tweet
-- ----------------------------
DROP TABLE IF EXISTS `tweet`;
CREATE TABLE `tweet` (
  `tweet_id_str` varchar(20) NOT NULL,
  `job_id` int unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `text` varchar(800) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `from_user` varchar(45) NOT NULL,
  `from_user_id_str` varchar(20) NOT NULL,
  `from_user_name` varchar(45) NOT NULL,
  `from_user_fullname` varchar(45) NOT NULL,
  `from_user_created_at` datetime NOT NULL,
  `from_user_followers` int NOT NULL,
  `from_user_following` int NOT NULL,
  `from_user_favorites` int NOT NULL,
  `from_user_tweets` int NOT NULL,
  `from_user_timezone` varchar(45) DEFAULT NULL,
  `to_user` varchar(45) DEFAULT NULL,
  `to_user_id_str` varchar(20) DEFAULT NULL,
  `to_user_name` varchar(45) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `location_geo` point DEFAULT NULL,
  `location_geo_0` decimal(14,10) DEFAULT NULL,
  `location_geo_1` decimal(14,10) DEFAULT NULL,
  `iso_language` varchar(3) NOT NULL,
  `analysis_state` int DEFAULT '0',
  PRIMARY KEY (`tweet_id_str`,`job_id`),
  KEY `archive` (`analysis_state`),
  KEY `from_id` (`from_user`),
  KEY `from_user` (`from_user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for update_status
-- ----------------------------
DROP TABLE IF EXISTS `update_status`;
CREATE TABLE `update_status` (
  `run_time` datetime DEFAULT NULL,
  `message` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for url
-- ----------------------------
DROP TABLE IF EXISTS `url`;
CREATE TABLE `url` (
  `url_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` varchar(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `expanded_url` varchar(400) NOT NULL,
  `display_url` varchar(255) NOT NULL,
  `index_start` tinyint unsigned NOT NULL,
  `index_end` tinyint unsigned NOT NULL,
  `job_id` int unsigned NOT NULL,
  `analysis_state` int DEFAULT '0',
  PRIMARY KEY (`url_id`),
  KEY `tweet_id` (`tweet_id`),
  KEY `analysis_state` (`analysis_state`)
) ENGINE=InnoDB AUTO_INCREMENT=4018 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for vac_child
-- ----------------------------
DROP TABLE IF EXISTS `vac_child`;
CREATE TABLE `vac_child` (
  `id` int NOT NULL AUTO_INCREMENT,
  `node_type` int DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  `object_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for vac_node
-- ----------------------------
DROP TABLE IF EXISTS `vac_node`;
CREATE TABLE `vac_node` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `owner` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

SET FOREIGN_KEY_CHECKS = 1;

