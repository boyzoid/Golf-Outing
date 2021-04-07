-- MySQL dump 10.17  Distrib 10.3.23-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: golf_outing
-- ------------------------------------------------------
-- Server version	10.1.37-MariaDB

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
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `city` varchar(45) NOT NULL,
  `state` char(2) NOT NULL,
  `slope` int(11) NOT NULL,
  `rating` decimal(3,1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `golfer`
--

DROP TABLE IF EXISTS `golfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `golfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `nickname` varchar(45) DEFAULT NULL,
  `email_address` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `is_admin` bit(1) DEFAULT b'0',
  `active` bit(1) DEFAULT b'1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `golfer_score`
--

DROP TABLE IF EXISTS `golfer_score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `golfer_score` (
  `outing_golfer_id` int(11) NOT NULL,
  `hole_id` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  PRIMARY KEY (`outing_golfer_id`,`hole_id`),
  KEY `score_hole_fk_idx` (`hole_id`),
  KEY `score_outing_golfer_fk_idx` (`outing_golfer_id`),
  CONSTRAINT `score_hole_fk` FOREIGN KEY (`hole_id`) REFERENCES `hole` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `score_outing_golfer_fk` FOREIGN KEY (`outing_golfer_id`) REFERENCES `outing_golfer` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hole`
--

DROP TABLE IF EXISTS `hole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` int(11) NOT NULL,
  `par` int(11) NOT NULL,
  `handicap` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course_hole_fk_idx` (`course_id`),
  CONSTRAINT `course_hole_fk` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `outing`
--

DROP TABLE IF EXISTS `outing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `tee_time` time NOT NULL,
  `managed_by` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `golfer_count` int(11) DEFAULT NULL,
  `scored` tinyint(1) DEFAULT '0',
  `teams` longtext,
  PRIMARY KEY (`id`),
  KEY `outing_golfer_fk_idx` (`managed_by`),
  KEY `outing_course_fk_idx` (`course_id`),
  CONSTRAINT `outing_course_fk` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `outing_golfer_fk` FOREIGN KEY (`managed_by`) REFERENCES `golfer` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `outing_golfer`
--

DROP TABLE IF EXISTS `outing_golfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outing_golfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `golfer_id` int(11) NOT NULL,
  `outing_id` int(11) NOT NULL,
  `handicap_index` decimal(3,1) NOT NULL DEFAULT '0.0',
  PRIMARY KEY (`id`),
  KEY `outing_golfer_outing_fk_idx` (`outing_id`),
  KEY `outing_golfer_golfer_fk_idx` (`golfer_id`),
  CONSTRAINT `outing_golfer_golfer_fk` FOREIGN KEY (`golfer_id`) REFERENCES `golfer` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `outing_golfer_outing_fk` FOREIGN KEY (`outing_id`) REFERENCES `outing` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `skin`
--

DROP TABLE IF EXISTS `skin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skin` (
  `id` int(11) NOT NULL,
  `outing_golfer_id` int(11) NOT NULL,
  `hole_id` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `skin_outing_golfer_fk_idx` (`outing_golfer_id`),
  KEY `skin_hole_fk_idx` (`hole_id`),
  CONSTRAINT `skin_hole_fk` FOREIGN KEY (`hole_id`) REFERENCES `hole` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `skin_outing_golfer_fk` FOREIGN KEY (`outing_golfer_id`) REFERENCES `outing_golfer` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-06 12:34:32
