/*
 Navicat Premium Data Transfer

 Source Server         : TZN_copy
 Source Server Type    : MySQL
 Source Server Version : 50525
 Source Host           : tzn-drexel-2.cbqyy1dvl5yb.us-east-1.rds.amazonaws.com
 Source Database       : tzn3

 Target Server Type    : MySQL
 Target Server Version : 50525
 File Encoding         : utf-8

 Date: 12/05/2012 14:53:01 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `hashtag`
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=146665559 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `hashtag_archive`
-- ----------------------------
DROP TABLE IF EXISTS `hashtag_archive`;
CREATE TABLE `hashtag_archive` (
  `hashtag_id` int(10) unsigned NOT NULL,
  `tweet_id` varchar(20) NOT NULL,
  `text` varchar(145) NOT NULL,
  `index_start` tinyint(3) unsigned NOT NULL,
  `index_end` tinyint(3) unsigned NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`hashtag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `hashtag_stage`
-- ----------------------------
DROP TABLE IF EXISTS `hashtag_stage`;
CREATE TABLE `hashtag_stage` (
  `hashtag_id` int(10) unsigned NOT NULL,
  `tweet_id` varchar(20) NOT NULL,
  `text` varchar(145) NOT NULL,
  `index_start` tinyint(3) unsigned NOT NULL,
  `index_end` tinyint(3) unsigned NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`hashtag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `oauth`
-- ----------------------------
DROP TABLE IF EXISTS `oauth`;
CREATE TABLE `oauth` (
  `oauth_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `consumer_key` varchar(255) NOT NULL,
  `consumer_secret` varchar(255) NOT NULL,
  `access_token` varchar(255) NOT NULL,
  `access_token_secret` varchar(255) NOT NULL,
  PRIMARY KEY (`oauth_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2511 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `job`
-- ----------------------------
DROP TABLE IF EXISTS `job`;
CREATE TABLE `job` (
  `job_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `state` int(11) NOT NULL DEFAULT '0',
  `zombie_head` int(10) DEFAULT NULL,
  `since_id_str` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `query` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT 'I am a lazy piece of shit and I did not enter a description',
  `last_count` int(10) unsigned zerofill DEFAULT NULL,
  `last_run` datetime DEFAULT NULL,
  `analysis_state` int(11) DEFAULT '0',
  `oauth_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2511 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `job_archive`
-- ----------------------------
DROP TABLE IF EXISTS `job_archive`;
CREATE TABLE `job_archive` (
  `job_id` int(10) unsigned NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `zombie_head` int(10) DEFAULT NULL,
  `since_id_str` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `query` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT 'I am a lazy piece of shit and I did not enter a description',
  `last_count` int(10) unsigned zerofill DEFAULT NULL,
  `last_run` datetime DEFAULT NULL,
  `analysis_state` int(11) DEFAULT NULL,
  `oauth_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `job_stage`
-- ----------------------------
DROP TABLE IF EXISTS `job_stage`;
CREATE TABLE `job_stage` (
  `job_id` int(10) unsigned NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `zombie_head` int(10) DEFAULT NULL,
  `since_id_str` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `query` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT 'I am a lazy piece of shit and I did not enter a description',
  `last_count` int(10) unsigned zerofill DEFAULT NULL,
  `last_run` datetime DEFAULT NULL,
  `analysis_state` int(11) DEFAULT NULL,
  `oauth_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `mention`
-- ----------------------------
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
  KEY `analysis_state` (`analysis_state`)
) ENGINE=InnoDB AUTO_INCREMENT=102043292 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `mention_archive`
-- ----------------------------
DROP TABLE IF EXISTS `mention_archive`;
CREATE TABLE `mention_archive` (
  `mention_id` int(10) unsigned NOT NULL,
  `tweet_id` varchar(20) NOT NULL,
  `screen_name` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  `id_str` varchar(45) NOT NULL,
  `index_start` tinyint(3) unsigned NOT NULL,
  `index_end` tinyint(3) unsigned NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`mention_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `mention_stage`
-- ----------------------------
DROP TABLE IF EXISTS `mention_stage`;
CREATE TABLE `mention_stage` (
  `mention_id` int(10) unsigned NOT NULL,
  `tweet_id` varchar(20) NOT NULL,
  `screen_name` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  `id_str` varchar(45) NOT NULL,
  `index_start` tinyint(3) unsigned NOT NULL,
  `index_end` tinyint(3) unsigned NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`mention_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `tweet`
-- ----------------------------
DROP TABLE IF EXISTS `tweet`;
CREATE TABLE `tweet` (
  `tweet_id_str` varchar(20) NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `text` varchar(255) NOT NULL,
  `from_user` varchar(45) NOT NULL,
  `from_user_id_str` varchar(20) NOT NULL,
  `from_user_name` varchar(45) NOT NULL,
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
  KEY `archive` (`analysis_state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `tweet_archive`
-- ----------------------------
DROP TABLE IF EXISTS `tweet_archive`;
CREATE TABLE `tweet_archive` (
  `tweet_id_str` varchar(20) NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `text` varchar(255) NOT NULL,
  `from_user` varchar(45) NOT NULL,
  `from_user_id_str` varchar(20) NOT NULL,
  `from_user_name` varchar(45) NOT NULL,
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
  KEY `archive` (`analysis_state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `tweet_stage`
-- ----------------------------
DROP TABLE IF EXISTS `tweet_stage`;
CREATE TABLE `tweet_stage` (
  `tweet_id_str` varchar(20) NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `text` varchar(255) NOT NULL,
  `from_user` varchar(45) NOT NULL,
  `from_user_id_str` varchar(20) NOT NULL,
  `from_user_name` varchar(45) NOT NULL,
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
  KEY `archive` (`analysis_state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `update_status`
-- ----------------------------
DROP TABLE IF EXISTS `update_status`;
CREATE TABLE `update_status` (
  `run_time` datetime DEFAULT NULL,
  `message` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
--  Table structure for `url`
-- ----------------------------
DROP TABLE IF EXISTS `url`;
CREATE TABLE `url` (
  `url_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` varchar(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `expanded_url` varchar(255) NOT NULL,
  `display_url` varchar(255) NOT NULL,
  `index_start` tinyint(3) unsigned NOT NULL,
  `index_end` tinyint(3) unsigned NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`url_id`),
  KEY `analysis_state` (`analysis_state`)
) ENGINE=InnoDB AUTO_INCREMENT=39936178 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `url_archive`
-- ----------------------------
DROP TABLE IF EXISTS `url_archive`;
CREATE TABLE `url_archive` (
  `url_id` int(10) unsigned NOT NULL,
  `tweet_id` varchar(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `expanded_url` varchar(255) NOT NULL,
  `display_url` varchar(255) NOT NULL,
  `index_start` tinyint(3) unsigned NOT NULL,
  `index_end` tinyint(3) unsigned NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`url_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `url_stage`
-- ----------------------------
DROP TABLE IF EXISTS `url_stage`;
CREATE TABLE `url_stage` (
  `url_id` int(10) unsigned NOT NULL,
  `tweet_id` varchar(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `expanded_url` varchar(255) NOT NULL,
  `display_url` varchar(255) NOT NULL,
  `index_start` tinyint(3) unsigned NOT NULL,
  `index_end` tinyint(3) unsigned NOT NULL,
  `job_id` int(10) unsigned NOT NULL,
  `analysis_state` int(10) DEFAULT '0',
  PRIMARY KEY (`url_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `vac_child`
-- ----------------------------
DROP TABLE IF EXISTS `vac_child`;
CREATE TABLE `vac_child` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `node_type` int(10) DEFAULT NULL,
  `parent_id` int(10) DEFAULT NULL,
  `object_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `vac_child_stage`
-- ----------------------------
DROP TABLE IF EXISTS `vac_child_stage`;
CREATE TABLE `vac_child_stage` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `node_type` int(10) DEFAULT NULL,
  `parent_id` int(10) DEFAULT NULL,
  `object_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `vac_node`
-- ----------------------------
DROP TABLE IF EXISTS `vac_node`;
CREATE TABLE `vac_node` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `label` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `owner` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `vac_node_stage`
-- ----------------------------
DROP TABLE IF EXISTS `vac_node_stage`;
CREATE TABLE `vac_node_stage` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `label` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `owner` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- ----------------------------
--  Procedure structure for `archive_stage`
-- ----------------------------
DROP PROCEDURE IF EXISTS `archive_stage`;
delimiter ;;
CREATE DEFINER=`skippy`@`%` PROCEDURE `archive_stage`()
begin
insert into mention_archive
select * from mention_stage where analysis_state=2;
commit;
insert into hashtag_archive
select * from hashtag_stage where analysis_state=2;
commit;
insert into tweet_archive
select * from tweet_stage where analysis_state=2;
commit;
insert into url_archive
select * from url_stage where analysis_state=2;
commit;
insert into mention_archive
select * from url_stage where analysis_state=2;
commit;
end
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `count olympics`
-- ----------------------------
DROP PROCEDURE IF EXISTS `count olympics`;
delimiter ;;
CREATE DEFINER=`skippy`@`%` PROCEDURE `count olympics`()
select count(job_id) from tweet where job_id=2131
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `delete_stage`
-- ----------------------------
DROP PROCEDURE IF EXISTS `delete_stage`;
delimiter ;;
CREATE DEFINER=`skippy`@`%` PROCEDURE `delete_stage`()
begin
delete from tweet_stage where analysis_state=2;
commit;
delete from url_stage where analysis_state=2;
commit;
delete from mention_stage where analysis_state=2;
commit;
delete from hashtag_stage where analysis_state=2;
commit;
delete from job_stage where analysis_state=2;
commit;
end
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `get_hashtag_staged`
-- ----------------------------
DROP PROCEDURE IF EXISTS `get_hashtag_staged`;
delimiter ;;
CREATE DEFINER=`skippy`@`%` PROCEDURE `get_hashtag_staged`()
select * from hashtag where analysis_state = 0
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `Health Care`
-- ----------------------------
DROP PROCEDURE IF EXISTS `Health Care`;
delimiter ;;
CREATE DEFINER=`skippy`@`%` PROCEDURE `Health Care`()
select * from tweet where job_id=2373
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `update_and_copy`
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_and_copy`;
delimiter ;;
CREATE DEFINER=`skippy`@`%` PROCEDURE `update_and_copy`()
begin

update tzn3.job set analysis_state = 2 where analysis_state=1;

update tzn3.job set analysis_state = 1 where analysis_state=0;
update tzn3.job_stage set analysis_state = 2 where analysis_state=1;

insert into tzn3.job_stage select * from tzn3.job where analysis_state=1;

insert into tzn3.job_stage (
   job_id
  ,state
  ,zombie_head
  ,since_id_str
  ,query
  ,description
  ,last_count
  ,last_run
) VALUES (
   0   -- job_id - IN int(10) unsigned
  ,0   -- state - IN int(11)
  ,0   -- zombie_head - IN int(10)
  ,''  -- since_id_str - IN varchar(20)
  ,''  -- query - IN varchar(255)
  ,'Checksum'  -- description - IN varchar(255)
  ,0   -- last_count - IN int(10) unsigned zerofill
  ,curdate()  -- last_run - IN datetime
);



update tzn3.tweet set analysis_state = 2 where analysis_state=1;

update tzn3.tweet set analysis_state = 1 where analysis_state=0;

update tzn3.tweet_stage set analysis_state = 2 where analysis_state=1;
insert into tzn3.tweet_stage select * from tzn3.tweet where analysis_state=1;

INSERT INTO tzn3.tweet_stage
(tweet_id_str, job_id, created_at, `text`, from_user, from_user_id_str, from_user_name, to_user, to_user_id_str, to_user_name, source, iso_language, analysis_state) 
VALUES ('0', 0, 0, 'checksum', 0,0, 0, 0, 0, 0, 0, 0, 0);



update tzn3.hashtag set analysis_state = 2 where analysis_state=1;

update tzn3.hashtag set analysis_state = 1 where analysis_state=0;

update tzn3.hashtag_stage set analysis_state = 2 where analysis_state=1;
insert into tzn3.hashtag_stage select * from tzn3.hashtag where analysis_state=1;

INSERT INTO tzn3.hashtag_stage (hashtag_id,tweet_id, `text`, index_start, index_end, job_id, analysis_state) VALUES (0,0,'checksum',0,0,0,0);



update tzn3.mention set analysis_state = 2 where analysis_state=1;

update tzn3.mention set analysis_state = 1 where analysis_state=0;

update tzn3.mention_stage set analysis_state = 2 where analysis_state=1;
insert into tzn3.mention_stage select * from tzn3.mention where analysis_state=1;

INSERT INTO tzn3.mention_stage (mention_id, tweet_id, screen_name, name, id_str, index_start, index_end, job_id, analysis_state) VALUES (0, 0, 'checksum', 0, 0,0, 0, 0, 0);



update tzn3.url set analysis_state = 2 where analysis_state=1;

update tzn3.url set analysis_state = 1 where analysis_state=0;

update tzn3.url_stage set analysis_state = 2 where analysis_state=1;
insert into tzn3.url_stage select * from tzn3.url where analysis_state=1;

INSERT INTO tzn3.url_stage (url_id, tweet_id, url, expanded_url, display_url, index_start, index_end, job_id, analysis_state) VALUES (0, 0, 'checksum', 0, 0, 0, 0, 0, 0);



INSERT INTO tzn3.update_status(run_time, message)

VALUES (current_timestamp(), 'Success!');



commit;



end
 ;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;