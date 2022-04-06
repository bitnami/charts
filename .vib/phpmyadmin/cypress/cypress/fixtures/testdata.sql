-- MariaDB dump 10.19  Distrib 10.5.12-MariaDB, for Linux (x86_64)
--
-- Host: mysql.hostinger.ro    Database: u574849695_23
-- ------------------------------------------------------
-- Server version	10.5.12-MariaDB-cll-lve

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `birthdate` date NOT NULL,
  `added` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES (1,'Zachary','Grady','gulgowski.walker@example.net','1989-08-01','2003-11-12 07:28:15'),(2,'Ralph','Kub','gracie10@example.com','1973-11-23','2002-11-22 10:49:35'),(3,'Hollie','Bernier','lily.mills@example.org','1986-02-25','2010-07-11 21:33:06'),(4,'Shakira','Buckridge','nat.goldner@example.net','2012-12-13','2009-08-31 08:57:26'),(5,'Lon','Connelly','gerhold.phyllis@example.org','2013-11-05','2013-10-18 14:55:40'),(6,'Ulices','Hills','ileffler@example.org','2017-06-22','2003-04-23 13:23:06'),(7,'Madilyn','Ondricka','savion05@example.net','2006-07-16','1987-12-09 22:33:52'),(8,'Laury','Ferry','pearl51@example.com','1972-01-22','1971-10-29 18:18:16'),(9,'Oswald','Hackett','hadley.willms@example.com','2000-09-19','1995-08-07 05:42:57'),(10,'Arianna','Cruickshank','adriana.bartoletti@example.net','1978-09-05','1970-04-11 03:41:21'),(11,'Braulio','Kutch','runte.janis@example.org','2009-04-04','1971-04-22 10:19:17'),(12,'Virginie','Cummings','christophe.mayer@example.net','2004-08-07','1971-10-12 06:11:13'),(13,'Jacquelyn','Bayer','cielo20@example.org','1994-11-09','1987-01-01 19:16:52'),(14,'Melba','Abshire','hintz.hillary@example.com','1992-10-14','2011-10-02 22:53:07'),(15,'Maddison','Hirthe','kirlin.emery@example.com','2015-03-21','2009-11-17 22:56:09'),(16,'Sadye','Muller','wskiles@example.com','2002-03-25','1981-01-22 11:13:34'),(17,'Elnora','Doyle','brycen24@example.com','2019-11-08','1974-06-24 12:57:43'),(18,'Elnora','Renner','idell33@example.net','1974-02-22','1983-08-14 10:57:06'),(19,'Jeffrey','Stracke','ward.bianka@example.com','1976-08-03','1973-02-08 12:36:08'),(20,'Maudie','Stoltenberg','marilie.denesik@example.com','1995-02-14','1974-03-11 19:07:24'),(21,'Jasmin','Lemke','bartoletti.lauren@example.com','2016-09-06','2021-05-04 15:22:34'),(22,'Alvis','Metz','koelpin.camylle@example.org','2014-06-27','1996-10-14 05:29:56'),(23,'Brenna','Feest','liliane76@example.net','1976-05-07','1973-09-18 04:20:31'),(24,'Clifford','Sauer','paucek.ewald@example.net','1996-06-05','1997-02-03 19:51:47'),(25,'Nasir','Lockman','palma.berge@example.net','2003-09-27','2008-12-30 22:52:21'),(26,'Leanna','Prohaska','ziemann.orlo@example.net','2014-04-02','1994-10-19 22:23:52'),(27,'Garnet','Schulist','goldner.kolby@example.com','1977-03-26','2019-07-30 20:41:52'),(28,'Dean','Torp','abelardo.brakus@example.org','2013-11-28','1993-12-15 15:11:35'),(29,'Deion','Spinka','kuphal.princess@example.org','2013-03-11','2003-08-04 06:10:52'),(30,'Alison','Ferry','rogahn.dorris@example.org','2000-06-12','1989-05-17 01:52:08'),(31,'Yvonne','Anderson','cflatley@example.com','1970-10-20','1976-03-02 23:48:30'),(32,'Helena','Glover','yhilll@example.net','2009-03-09','2021-05-02 12:49:28'),(33,'Davon','Schinner','wunsch.cale@example.com','1985-12-31','2001-03-11 12:08:16'),(34,'Elias','Cormier','jerrold16@example.org','1986-05-26','1973-07-12 21:40:22'),(35,'Kaleigh','Nolan','kayleigh35@example.net','2014-08-08','1989-09-21 22:12:59'),(36,'Cesar','Batz','rowe.braxton@example.net','1992-02-02','1988-07-01 15:30:01'),(37,'Rocky','Weissnat','smitham.llewellyn@example.org','2013-06-13','2016-06-17 07:15:58'),(38,'Arvilla','Zboncak','anjali46@example.net','1998-10-30','2019-09-21 20:52:27'),(39,'Felipa','McGlynn','watsica.abdul@example.net','1986-09-01','2002-09-04 03:33:26'),(40,'Solon','Sipes','umcglynn@example.net','2005-11-23','1982-11-26 05:50:11'),(41,'Leilani','Shields','xauer@example.org','1980-07-29','2012-03-21 19:25:14'),(42,'Aaliyah','Haley','lavada16@example.org','2000-02-23','1988-11-03 18:32:55'),(43,'Terrill','O\'Hara','alejandrin78@example.com','2006-02-20','1976-10-19 11:02:33'),(44,'Timmy','Cruickshank','balistreri.chanelle@example.net','1975-08-23','1972-08-14 04:03:50'),(45,'Bessie','Brown','evie.schaefer@example.net','1994-09-28','1972-12-16 09:12:10'),(46,'Emerald','Becker','lempi.ryan@example.com','2020-02-16','2017-05-18 12:20:58'),(47,'Ward','Welch','rkiehn@example.net','2013-09-30','2020-08-28 19:42:03'),(48,'Edythe','Price','kmohr@example.org','2005-07-01','1992-10-12 09:49:02'),(49,'River','Steuber','raquel89@example.com','1994-05-11','1994-09-03 16:55:54'),(50,'Madelyn','Prosacco','mavis.borer@example.net','1973-09-07','1980-07-04 08:53:42'),(51,'Emelia','Pfeffer','altenwerth.bennie@example.org','2010-12-31','1979-04-27 07:12:40'),(52,'Florence','Kuhn','mose.lockman@example.net','1979-01-11','2000-03-15 16:52:19'),(53,'Lesley','Frami','treutel.jettie@example.com','1974-08-01','2018-01-12 14:34:36'),(54,'Philip','Pfannerstill','mayer.franco@example.net','1971-04-28','2004-01-15 18:44:39'),(55,'Janet','Moen','ford.schoen@example.net','1972-03-14','2012-01-22 09:39:01'),(56,'Vivianne','Langosh','madisen.rosenbaum@example.net','2001-02-18','1975-05-02 13:43:06'),(57,'Mauricio','Kutch','kolby.block@example.net','2017-07-14','1981-05-26 13:01:45'),(58,'Arturo','McCullough','kemmer.ida@example.org','2009-10-27','2011-01-30 14:15:07'),(59,'Joana','Kling','mossie.nienow@example.net','2020-10-07','2016-02-06 07:11:14'),(60,'Tod','Hackett','kellie68@example.org','1984-11-27','1975-04-15 17:30:38'),(61,'Kaleb','Rath','xmoore@example.com','1977-09-12','2020-09-18 16:35:37'),(62,'Deonte','Runte','mcdermott.evan@example.com','1997-03-04','1999-11-23 21:12:09'),(63,'Maud','Schulist','gleason.cecil@example.net','1999-03-02','2012-05-27 00:29:23'),(64,'Marilyne','Haley','zane22@example.net','1989-06-22','2021-10-22 12:12:21'),(65,'Dovie','Rolfson','mcglynn.agnes@example.com','1976-10-31','1988-02-03 08:29:12'),(66,'Vivianne','Hansen','mayert.jeanie@example.net','1971-10-22','2014-10-05 22:50:16'),(67,'Tessie','Simonis','reyna.bailey@example.net','2008-07-29','2013-07-01 05:52:09'),(68,'Berta','Weissnat','jairo49@example.org','1999-01-04','1970-12-03 21:09:46'),(69,'Karley','Padberg','morar.pierce@example.net','2019-12-27','1980-10-18 11:01:20'),(70,'Krista','Farrell','erick.lehner@example.net','2011-01-18','2017-11-11 01:08:21'),(71,'Ralph','Nienow','kilback.lura@example.net','1972-01-04','1991-10-29 14:28:14'),(72,'Alexandra','Gibson','meagan38@example.net','2014-12-18','2020-10-19 06:19:19'),(73,'Jack','Wunsch','ahomenick@example.com','2000-12-28','1991-03-25 05:17:59'),(74,'Callie','Runolfsson','adriana33@example.net','1984-01-22','2010-02-07 19:36:52'),(75,'Jewel','Feil','alakin@example.net','1995-07-27','2002-10-12 19:24:48'),(76,'Adrian','Kuhn','schowalter.reece@example.org','2008-07-28','1974-06-22 21:56:43'),(77,'Ryley','Heaney','jennyfer.padberg@example.com','1986-03-08','1989-07-30 16:37:03'),(78,'Petra','VonRueden','bashirian.dominique@example.org','1995-01-21','1970-07-20 01:55:41'),(79,'Joana','Murray','lynch.watson@example.org','2010-04-04','2017-03-07 13:55:17'),(80,'Janae','Parisian','michelle.mante@example.net','1983-09-26','2015-04-11 21:01:20'),(81,'Savanah','Bergnaum','delores35@example.com','1979-09-23','2013-06-14 05:10:33'),(82,'Alex','Durgan','jdare@example.net','1970-07-07','2021-08-24 08:38:20'),(83,'Phyllis','Gulgowski','riley93@example.net','1995-08-07','1989-01-19 09:48:57'),(84,'Lavinia','Smith','dibbert.dameon@example.org','2020-11-23','2017-04-25 19:33:38'),(85,'Beryl','Schroeder','lbernhard@example.org','1999-12-23','2016-01-02 03:35:39'),(86,'Brown','Olson','gerlach.sidney@example.org','2000-07-27','1994-12-01 11:19:50'),(87,'Obie','Brakus','scottie39@example.org','1996-11-08','1995-06-06 03:56:51'),(88,'Jack','Hermann','abruen@example.net','2012-06-23','1990-06-18 18:25:16'),(89,'Chesley','Hermiston','strosin.richmond@example.net','1975-02-07','2019-02-23 16:08:14'),(90,'Sanford','Ziemann','anabelle97@example.com','2014-07-17','2017-05-10 07:38:03'),(91,'Burley','Schuster','pschroeder@example.net','2021-04-12','1998-05-12 19:10:50'),(92,'Carmen','Eichmann','milo47@example.org','1980-05-14','2007-06-05 02:30:54'),(93,'Elvie','Larson','lehner.letha@example.net','1993-03-12','1979-05-07 08:59:05'),(94,'Margaretta','Pfeffer','zmedhurst@example.net','1997-12-08','2009-10-21 15:17:14'),(95,'Meta','Roberts','gernser@example.com','2012-08-21','2012-09-26 06:09:05'),(96,'Creola','Rowe','kerluke.shawn@example.org','2021-02-05','1975-06-23 15:20:27'),(97,'Syble','Cartwright','hauck.kallie@example.org','1986-09-08','2019-01-26 01:42:36'),(98,'Sammy','Christiansen','horacio.o\'conner@example.net','2012-12-30','1972-01-08 22:12:33'),(99,'Aubrey','Jerde','alexane30@example.net','1971-11-17','1994-05-31 11:26:18'),(100,'Anita','Bauch','kunde.leila@example.net','1971-06-25','1986-10-15 18:30:27');
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-03-22 11:11:28
