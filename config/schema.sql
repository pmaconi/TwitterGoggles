# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.5.42-1)
# Database: twittergoggles
# Generation Time: 2015-04-01 14:24:54 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table hashtag
# ------------------------------------------------------------

DROP TABLE IF EXISTS `hashtag`;

CREATE TABLE `hashtag` (
  `hashtag_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` varchar(20) NOT NULL,
  `text` varchar(145) NOT NULL,
  `index_start` tinyint(3) unsigned NOT NULL,
  `index_end` tinyint(3) unsigned NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`hashtag_id`),
  KEY `analysisindex` (`analysis_state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;



# Dump of table history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `history`;

CREATE TABLE `history` (
  `history_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `job_id` int(10) unsigned NOT NULL,
  `oauth_id` int(10) unsigned NOT NULL,
  `timestamp` datetime NOT NULL,
  `status` varchar(7) NOT NULL,
  `total_results` int(10) unsigned zerofill DEFAULT NULL,
  PRIMARY KEY (`history_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;



# Dump of table job
# ------------------------------------------------------------

DROP TABLE IF EXISTS `job`;

CREATE TABLE `job` (
  `job_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `state` int(11) NOT NULL DEFAULT '0',
  `zombie_head` int(10) DEFAULT NULL,
  `since_id_str` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `query` text NOT NULL,
  `description` varchar(255) DEFAULT 'I am a lazy piece of shit and I did not enter a description',
  `last_count` int(10) unsigned zerofill DEFAULT NULL,
  `last_run` datetime DEFAULT NULL,
  `analysis_state` int(11) DEFAULT '0',
  `oauth_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;



# Dump of table mention
# ------------------------------------------------------------

DROP TABLE IF EXISTS `mention`;

CREATE TABLE `mention` (
  `mention_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` varchar(20) NOT NULL,
  `screen_name` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  `id_str` varchar(45) NOT NULL,
  `index_start` tinyint(3) unsigned NOT NULL,
  `index_end` tinyint(3) unsigned NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`mention_id`),
  KEY `analysis_state` (`analysis_state`),
  KEY `tweet_id` (`tweet_id`),
  KEY `user` (`id_str`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;



# Dump of table oauth
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oauth`;

CREATE TABLE `oauth` (
  `oauth_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `consumer_key` varchar(255) NOT NULL,
  `consumer_secret` varchar(255) NOT NULL,
  `access_token` varchar(255) NOT NULL,
  `access_token_secret` varchar(255) NOT NULL,
  PRIMARY KEY (`oauth_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;



# Dump of table tweet
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tweet`;

CREATE TABLE `tweet` (
  `tweet_id_str` varchar(20) NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `text` varchar(255) NOT NULL,
  `from_user` varchar(45) NOT NULL,
  `from_user_id_str` varchar(20) NOT NULL,
  `from_user_name` varchar(45) NOT NULL,
  `from_user_fullname` varchar(45) NOT NULL,
  `from_user_created_at` datetime NOT NULL,
  `from_user_followers` int(11) NOT NULL,
  `from_user_following` int(11) NOT NULL,
  `from_user_favorites` int(11) NOT NULL,
  `from_user_tweets` int(11) NOT NULL,
  `from_user_timezone` varchar(45) DEFAULT NULL,
  `to_user` varchar(45) DEFAULT NULL,
  `to_user_id_str` varchar(20) DEFAULT NULL,
  `to_user_name` varchar(45) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `location_geo` point DEFAULT NULL,
  `location_geo_0` decimal(14,10) DEFAULT NULL,
  `location_geo_1` decimal(14,10) DEFAULT NULL,
  `iso_language` varchar(3) NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`tweet_id_str`,`job_id`),
  KEY `archive` (`analysis_state`),
  KEY `from_id` (`from_user`),
  KEY `from_user` (`from_user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;



# Dump of table update_status
# ------------------------------------------------------------

DROP TABLE IF EXISTS `update_status`;

CREATE TABLE `update_status` (
  `run_time` datetime DEFAULT NULL,
  `message` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;



# Dump of table url
# ------------------------------------------------------------

DROP TABLE IF EXISTS `url`;

CREATE TABLE `url` (
  `url_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` varchar(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `expanded_url` varchar(400) NOT NULL,
  `display_url` varchar(255) NOT NULL,
  `index_start` tinyint(3) unsigned NOT NULL,
  `index_end` tinyint(3) unsigned NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`url_id`),
  KEY `tweet_id` (`tweet_id`),
  KEY `analysis_state` (`analysis_state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;



# Dump of table vac_child
# ------------------------------------------------------------

DROP TABLE IF EXISTS `vac_child`;

CREATE TABLE `vac_child` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `node_type` int(10) DEFAULT NULL,
  `parent_id` int(10) DEFAULT NULL,
  `object_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;



# Dump of table vac_node
# ------------------------------------------------------------

DROP TABLE IF EXISTS `vac_node`;

CREATE TABLE `vac_node` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `label` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `owner` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
