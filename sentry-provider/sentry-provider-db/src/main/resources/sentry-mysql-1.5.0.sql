-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements.  See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


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

CREATE TABLE `SENTRY_DB_PRIVILEGE` (
  `DB_PRIVILEGE_ID` BIGINT NOT NULL,
  `PRIVILEGE_SCOPE` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `SERVER_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `DB_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `TABLE_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `URI` VARCHAR(4000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `ACTION` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `CREATE_TIME` BIGINT NOT NULL,
  `GRANTOR_PRINCIPAL` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `WITH_GRANT_OPTION` CHAR(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `SENTRY_ROLE` (
  `ROLE_ID` BIGINT  NOT NULL,
  `ROLE_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `CREATE_TIME` BIGINT NOT NULL,
  `GRANTOR_PRINCIPAL` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `SENTRY_GROUP` (
  `GROUP_ID` BIGINT  NOT NULL,
  `GROUP_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `CREATE_TIME` BIGINT NOT NULL,
  `GRANTOR_PRINCIPAL` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `SENTRY_ROLE_DB_PRIVILEGE_MAP` (
  `ROLE_ID` BIGINT NOT NULL,
  `DB_PRIVILEGE_ID` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `SENTRY_ROLE_GROUP_MAP` (
  `ROLE_ID` BIGINT NOT NULL,
  `GROUP_ID` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `SENTRY_VERSION` (
  `VER_ID` BIGINT NOT NULL,
  `SCHEMA_VERSION` VARCHAR(127) NOT NULL,
  `VERSION_COMMENT` VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD CONSTRAINT `SENTRY_DB_PRIV_PK` PRIMARY KEY (`DB_PRIVILEGE_ID`);

ALTER TABLE `SENTRY_ROLE`
  ADD CONSTRAINT `SENTRY_ROLE_PK` PRIMARY KEY (`ROLE_ID`);

ALTER TABLE `SENTRY_GROUP`
  ADD CONSTRAINT `SENTRY_GROUP_PK` PRIMARY KEY (`GROUP_ID`);

ALTER TABLE `SENTRY_VERSION`
  ADD CONSTRAINT `SENTRY_VERSION` PRIMARY KEY (`VER_ID`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD UNIQUE `SENTRY_DB_PRIV_PRIV_NAME_UNIQ` (`SERVER_NAME`,`DB_NAME`,`TABLE_NAME`,`URI`(250),`ACTION`,`WITH_GRANT_OPTION`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD INDEX `SENTRY_PRIV_SERV_IDX` (`SERVER_NAME`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD INDEX `SENTRY_PRIV_DB_IDX` (`DB_NAME`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD INDEX `SENTRY_PRIV_TBL_IDX` (`TABLE_NAME`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD INDEX `SENTRY_PRIV_URI_IDX` (`URI`);

ALTER TABLE `SENTRY_ROLE`
  ADD CONSTRAINT `SENTRY_ROLE_ROLE_NAME_UNIQUE` UNIQUE (`ROLE_NAME`);

ALTER TABLE `SENTRY_GROUP`
  ADD CONSTRAINT `SENTRY_GRP_GRP_NAME_UNIQUE` UNIQUE (`GROUP_NAME`);

ALTER TABLE `SENTRY_ROLE_DB_PRIVILEGE_MAP`
  ADD CONSTRAINT `SENTRY_ROLE_DB_PRIVILEGE_MAP_PK` PRIMARY KEY (`ROLE_ID`,`DB_PRIVILEGE_ID`);

ALTER TABLE `SENTRY_ROLE_GROUP_MAP`
  ADD CONSTRAINT `SENTRY_ROLE_GROUP_MAP_PK` PRIMARY KEY (`ROLE_ID`,`GROUP_ID`);

ALTER TABLE `SENTRY_ROLE_DB_PRIVILEGE_MAP`
  ADD CONSTRAINT `SEN_RLE_DB_PRV_MAP_SN_RLE_FK`
  FOREIGN KEY (`ROLE_ID`) REFERENCES `SENTRY_ROLE`(`ROLE_ID`);

ALTER TABLE `SENTRY_ROLE_DB_PRIVILEGE_MAP`
  ADD CONSTRAINT `SEN_RL_DB_PRV_MAP_SN_DB_PRV_FK`
  FOREIGN KEY (`DB_PRIVILEGE_ID`) REFERENCES `SENTRY_DB_PRIVILEGE`(`DB_PRIVILEGE_ID`);

ALTER TABLE `SENTRY_ROLE_GROUP_MAP`
  ADD CONSTRAINT `SEN_ROLE_GROUP_MAP_SEN_ROLE_FK`
  FOREIGN KEY (`ROLE_ID`) REFERENCES `SENTRY_ROLE`(`ROLE_ID`);

ALTER TABLE `SENTRY_ROLE_GROUP_MAP`
  ADD CONSTRAINT `SEN_ROLE_GROUP_MAP_SEN_GRP_FK`
  FOREIGN KEY (`GROUP_ID`) REFERENCES `SENTRY_GROUP`(`GROUP_ID`);

INSERT INTO SENTRY_VERSION (VER_ID, SCHEMA_VERSION, VERSION_COMMENT) VALUES (1, '1.5.0', 'Sentry release version 1.5.0');
