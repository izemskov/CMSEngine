-- MySQL dump 10.14  Distrib 5.5.68-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: izemskov
-- ------------------------------------------------------
-- Server version	5.5.68-MariaDB

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
-- Table structure for table `izemskov_captcha`
--

DROP TABLE IF EXISTS `izemskov_captcha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_captcha` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `string` varchar(255) NOT NULL,
  `md5` varchar(255) NOT NULL,
  `create_time` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ind_md5` (`md5`)
) ENGINE=MyISAM AUTO_INCREMENT=1427 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_captcha`
--

LOCK TABLES `izemskov_captcha` WRITE;
/*!40000 ALTER TABLE `izemskov_captcha` DISABLE KEYS */;
/*!40000 ALTER TABLE `izemskov_captcha` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_cms_access`
--

DROP TABLE IF EXISTS `izemskov_cms_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_cms_access` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) unsigned NOT NULL,
  `modul_id` int(10) unsigned NOT NULL,
  `access_add` enum('yes','no') NOT NULL DEFAULT 'no',
  `access_edit` enum('yes','no') NOT NULL DEFAULT 'no',
  `access_delete` enum('yes','no') NOT NULL DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_cms_access`
--

LOCK TABLES `izemskov_cms_access` WRITE;
/*!40000 ALTER TABLE `izemskov_cms_access` DISABLE KEYS */;
INSERT INTO `izemskov_cms_access` VALUES (1,1,2,'yes','yes','yes'),(2,1,38,'yes','yes','yes'),(5,1,43,'yes','yes','yes'),(6,1,46,'yes','yes','yes'),(7,1,47,'yes','yes','yes'),(8,1,49,'yes','yes','yes'),(16,1,3,'yes','yes','yes'),(18,1,51,'yes','yes','yes'),(22,1,54,'yes','yes','yes');
/*!40000 ALTER TABLE `izemskov_cms_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_cms_sessions`
--

DROP TABLE IF EXISTS `izemskov_cms_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_cms_sessions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sess_id` varchar(255) NOT NULL,
  `sess_start_time` bigint(20) unsigned NOT NULL,
  `sess_time` bigint(20) unsigned NOT NULL,
  `uid` int(11) DEFAULT '-1',
  `token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=227 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_cms_sessions`
--

LOCK TABLES `izemskov_cms_sessions` WRITE;
/*!40000 ALTER TABLE `izemskov_cms_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `izemskov_cms_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_cms_sessions_log`
--

DROP TABLE IF EXISTS `izemskov_cms_sessions_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_cms_sessions_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `login_time` bigint(20) unsigned NOT NULL,
  `uid` int(11) DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=126 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_cms_sessions_log`
--

LOCK TABLES `izemskov_cms_sessions_log` WRITE;
/*!40000 ALTER TABLE `izemskov_cms_sessions_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `izemskov_cms_sessions_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_cms_settings`
--

DROP TABLE IF EXISTS `izemskov_cms_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_cms_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `group` varchar(255) NOT NULL,
  `translitname` varchar(255) NOT NULL,
  `value` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_cms_settings`
--

LOCK TABLES `izemskov_cms_settings` WRITE;
/*!40000 ALTER TABLE `izemskov_cms_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `izemskov_cms_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_cms_struct`
--

DROP TABLE IF EXISTS `izemskov_cms_struct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_cms_struct` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `modul` varchar(255) NOT NULL,
  `sub_modul` varchar(255) DEFAULT NULL,
  `order_content` int(11) DEFAULT NULL,
  `picture` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_cms_struct`
--

LOCK TABLES `izemskov_cms_struct` WRITE;
/*!40000 ALTER TABLE `izemskov_cms_struct` DISABLE KEYS */;
INSERT INTO `izemskov_cms_struct` VALUES (1,0,'CMS','cms','cms',1,NULL),(2,1,'Модули','cms','moduls',1,'moduls.jpg'),(3,1,'Пользователи','cms','users',2,'users.jpg'),(37,0,'Информация на сайте','text','text',10,NULL),(38,37,'Текстовые разделы','text','content',11,'folder.jpg'),(42,0,'SEO','seo','seo',30,NULL),(43,42,'Заголовки страниц','seo','titles',1,'titles.jpg'),(46,37,'Файл менеджер','text','filemanager',30,'filemanager.jpg'),(47,48,'Настройки','basic','settings',1,'settings.jpg'),(48,0,'Базовые настройки','basic','basic',5,NULL),(49,48,'Языки','basic','languages',10,'languages.jpg'),(51,37,'Каталог','text','catalog',30,'galery.jpg'),(53,0,'Сообщения','messages','messages',20,NULL),(54,53,'Обратная связь','messages','sendmail',1,'sendmail.jpg');
/*!40000 ALTER TABLE `izemskov_cms_struct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_cms_users`
--

DROP TABLE IF EXISTS `izemskov_cms_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_cms_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `login` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_cms_users`
--

LOCK TABLES `izemskov_cms_users` WRITE;
/*!40000 ALTER TABLE `izemskov_cms_users` DISABLE KEYS */;
INSERT INTO `izemskov_cms_users` VALUES (1,'root','1507d62bb83ae629869e1b93a39fc68175f83b0503fa88f43feaf7fbb1ac906e','pascal.ilya@gmail.com');
/*!40000 ALTER TABLE `izemskov_cms_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_languages`
--

DROP TABLE IF EXISTS `izemskov_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_languages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `picture` varchar(255) DEFAULT NULL,
  `order_content` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_languages`
--

LOCK TABLES `izemskov_languages` WRITE;
/*!40000 ALTER TABLE `izemskov_languages` DISABLE KEYS */;
INSERT INTO `izemskov_languages` VALUES (1,'Русский','px.gif',0);
/*!40000 ALTER TABLE `izemskov_languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_languages_fields`
--

DROP TABLE IF EXISTS `izemskov_languages_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_languages_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_languages_fields`
--

LOCK TABLES `izemskov_languages_fields` WRITE;
/*!40000 ALTER TABLE `izemskov_languages_fields` DISABLE KEYS */;
INSERT INTO `izemskov_languages_fields` VALUES (18,''),(17,''),(16,''),(15,''),(14,''),(13,''),(19,''),(20,''),(21,''),(22,''),(23,''),(24,''),(25,''),(26,'');
/*!40000 ALTER TABLE `izemskov_languages_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_languages_values`
--

DROP TABLE IF EXISTS `izemskov_languages_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_languages_values` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL,
  `lang_id` int(10) unsigned NOT NULL,
  `value` text,
  PRIMARY KEY (`id`),
  KEY `ind_lang_id` (`lang_id`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_languages_values`
--

LOCK TABLES `izemskov_languages_values` WRITE;
/*!40000 ALTER TABLE `izemskov_languages_values` DISABLE KEYS */;
INSERT INTO `izemskov_languages_values` VALUES (15,15,1,'Если у Вас есть вопросы или предложения по развитию проекта, Вы можете связаться со мной заполнив форму ниже.'),(14,14,1,'test@test.com'),(13,13,1,'Написать нам'),(16,16,1,'Спасибо! Я отвечу Вам в ближайшее время'),(17,17,1,'site.ru 2015'),(18,18,1,'Заголовок страницы'),(19,19,1,'Описание страницы'),(20,20,1,'Ключевые слова'),(21,21,1,'Заголовок страницы'),(22,22,1,'Описание страницы'),(23,23,1,'Ключевые слова'),(24,24,1,'Заголовок страницы'),(25,25,1,'Описание страницы'),(26,26,1,'Ключевые слова');
/*!40000 ALTER TABLE `izemskov_languages_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_messages_sendmail`
--

DROP TABLE IF EXISTS `izemskov_messages_sendmail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_messages_sendmail` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `mess_date` int(10) unsigned NOT NULL,
  `readed` enum('yes','no') NOT NULL DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_messages_sendmail`
--

LOCK TABLES `izemskov_messages_sendmail` WRITE;
/*!40000 ALTER TABLE `izemskov_messages_sendmail` DISABLE KEYS */;
/*!40000 ALTER TABLE `izemskov_messages_sendmail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_seo_titles`
--

DROP TABLE IF EXISTS `izemskov_seo_titles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_seo_titles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `translitname` varchar(255) NOT NULL,
  `meta_title` int(11) DEFAULT NULL,
  `meta_description` int(10) unsigned DEFAULT NULL,
  `meta_keywords` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ind_translitname` (`translitname`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_seo_titles`
--

LOCK TABLES `izemskov_seo_titles` WRITE;
/*!40000 ALTER TABLE `izemskov_seo_titles` DISABLE KEYS */;
INSERT INTO `izemskov_seo_titles` VALUES (9,'По-умолчанию','default',21,22,23),(8,'Текстовые разделы','content',18,19,20),(10,'Обратная связь','sendmail',24,25,26);
/*!40000 ALTER TABLE `izemskov_seo_titles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_settings`
--

DROP TABLE IF EXISTS `izemskov_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `settings_group` varchar(255) NOT NULL,
  `translitname` varchar(255) NOT NULL,
  `value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_settings`
--

LOCK TABLES `izemskov_settings` WRITE;
/*!40000 ALTER TABLE `izemskov_settings` DISABLE KEYS */;
INSERT INTO `izemskov_settings` VALUES (19,'Заголовок обратной связи','Обратная связь','sendmail_name',13),(20,'Почтовый ящик администратора','Обратная связь','email_sendmail',14),(21,'Текст перед отправкой','Обратная связь','sendmail_text_before',15),(22,'Текст после отправки','Обратная связь','sendmail_text_after',16),(23,'Текст копирайта','Разное','copyright_text',17);
/*!40000 ALTER TABLE `izemskov_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_text_catalog_items`
--

DROP TABLE IF EXISTS `izemskov_text_catalog_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_text_catalog_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` int(11) NOT NULL,
  `catalog_id` int(10) unsigned NOT NULL,
  `filename` varchar(255) NOT NULL,
  `order_content` int(11) NOT NULL,
  `small_description` int(10) unsigned DEFAULT NULL,
  `description` int(10) unsigned DEFAULT NULL,
  `meta_title` int(10) unsigned DEFAULT NULL,
  `meta_description` int(10) unsigned DEFAULT NULL,
  `meta_keywords` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=505 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_text_catalog_items`
--

LOCK TABLES `izemskov_text_catalog_items` WRITE;
/*!40000 ALTER TABLE `izemskov_text_catalog_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `izemskov_text_catalog_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_text_catalogs`
--

DROP TABLE IF EXISTS `izemskov_text_catalogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_text_catalogs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` int(11) NOT NULL,
  `order_content` int(11) NOT NULL,
  `description` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=500 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_text_catalogs`
--

LOCK TABLES `izemskov_text_catalogs` WRITE;
/*!40000 ALTER TABLE `izemskov_text_catalogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `izemskov_text_catalogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_text_content`
--

DROP TABLE IF EXISTS `izemskov_text_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_text_content` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` int(10) unsigned NOT NULL,
  `fullname` int(10) unsigned DEFAULT NULL,
  `symbol_link` varchar(255) DEFAULT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `content` int(10) unsigned DEFAULT NULL,
  `order_content` int(10) unsigned NOT NULL,
  `meta_title` int(10) unsigned DEFAULT NULL,
  `meta_description` int(10) unsigned DEFAULT NULL,
  `meta_keywords` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ind_symbol_link` (`symbol_link`),
  KEY `ind_parent_id` (`parent_id`)
) ENGINE=MyISAM AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_text_content`
--

LOCK TABLES `izemskov_text_content` WRITE;
/*!40000 ALTER TABLE `izemskov_text_content` DISABLE KEYS */;
/*!40000 ALTER TABLE `izemskov_text_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `izemskov_text_editor_files`
--

DROP TABLE IF EXISTS `izemskov_text_editor_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izemskov_text_editor_files` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'images',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izemskov_text_editor_files`
--

LOCK TABLES `izemskov_text_editor_files` WRITE;
/*!40000 ALTER TABLE `izemskov_text_editor_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `izemskov_text_editor_files` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-27 14:06:33
