-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: tem_dbv2
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

CREATE DATABASE IF NOT EXISTS tem_dbv2;
USE tem_dbv2;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` bigint NOT NULL,
  `permission_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` bigint NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',3,'add_permission'),(2,'Can change permission',3,'change_permission'),(3,'Can delete permission',3,'delete_permission'),(4,'Can view permission',3,'view_permission'),(5,'Can add group',2,'add_group'),(6,'Can change group',2,'change_group'),(7,'Can delete group',2,'delete_group'),(8,'Can view group',2,'view_group'),(9,'Can add content type',1,'add_contenttype'),(10,'Can change content type',1,'change_contenttype'),(11,'Can delete content type',1,'delete_contenttype'),(12,'Can view content type',1,'view_contenttype'),(13,'Can add log entry',4,'add_logentry'),(14,'Can change log entry',4,'change_logentry'),(15,'Can delete log entry',4,'delete_logentry'),(16,'Can view log entry',4,'view_logentry'),(17,'Can add user',7,'add_usuario'),(18,'Can change user',7,'change_usuario'),(19,'Can delete user',7,'delete_usuario'),(20,'Can view user',7,'view_usuario'),(21,'Can add perfil desarrollador',5,'add_perfildesarrollador'),(22,'Can change perfil desarrollador',5,'change_perfildesarrollador'),(23,'Can delete perfil desarrollador',5,'delete_perfildesarrollador'),(24,'Can view perfil desarrollador',5,'view_perfildesarrollador'),(25,'Can add perfil empresa',6,'add_perfilempresa'),(26,'Can change perfil empresa',6,'change_perfilempresa'),(27,'Can delete perfil empresa',6,'delete_perfilempresa'),(28,'Can view perfil empresa',6,'view_perfilempresa'),(29,'Can add session',8,'add_session'),(30,'Can change session',8,'change_session'),(31,'Can delete session',8,'delete_session'),(32,'Can view session',8,'view_session'),(33,'Can add proyecto',10,'add_proyecto'),(34,'Can change proyecto',10,'change_proyecto'),(35,'Can delete proyecto',10,'delete_proyecto'),(36,'Can view proyecto',10,'view_proyecto'),(37,'Can add historial estado proyecto',9,'add_historialestadoproyecto'),(38,'Can change historial estado proyecto',9,'change_historialestadoproyecto'),(39,'Can delete historial estado proyecto',9,'delete_historialestadoproyecto'),(40,'Can view historial estado proyecto',9,'view_historialestadoproyecto'),(41,'Can add valoracion',11,'add_valoracion'),(42,'Can change valoracion',11,'change_valoracion'),(43,'Can delete valoracion',11,'delete_valoracion'),(44,'Can view valoracion',11,'view_valoracion'),(45,'Can add postulacion',12,'add_postulacion'),(46,'Can change postulacion',12,'change_postulacion'),(47,'Can delete postulacion',12,'delete_postulacion'),(48,'Can view postulacion',12,'view_postulacion'),(49,'Can add contratacion',13,'add_contratacion'),(50,'Can change contratacion',13,'change_contratacion'),(51,'Can delete contratacion',13,'delete_contratacion'),(52,'Can view contratacion',13,'view_contratacion'),(53,'Can add avance',14,'add_avance'),(54,'Can change avance',14,'change_avance'),(55,'Can delete avance',14,'delete_avance'),(56,'Can view avance',14,'view_avance'),(57,'Can add mensaje',15,'add_mensaje'),(58,'Can change mensaje',15,'change_mensaje'),(59,'Can delete mensaje',15,'delete_mensaje'),(60,'Can view mensaje',15,'view_mensaje'),(61,'Can add notificacion',16,'add_notificacion'),(62,'Can change notificacion',16,'change_notificacion'),(63,'Can delete notificacion',16,'delete_notificacion'),(64,'Can view notificacion',16,'view_notificacion'),(65,'Can add favorito',17,'add_favorito'),(66,'Can change favorito',17,'change_favorito'),(67,'Can delete favorito',17,'delete_favorito'),(68,'Can view favorito',17,'view_favorito'),(69,'Can add copia seguridad',18,'add_copiaseguridad'),(70,'Can change copia seguridad',18,'change_copiaseguridad'),(71,'Can delete copia seguridad',18,'delete_copiaseguridad'),(72,'Can view copia seguridad',18,'view_copiaseguridad'),(73,'Can add log auditoria',19,'add_logauditoria'),(74,'Can change log auditoria',19,'change_logauditoria'),(75,'Can delete log auditoria',19,'delete_logauditoria'),(76,'Can view log auditoria',19,'view_logauditoria');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `avances`
--

DROP TABLE IF EXISTS `avances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avances` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `proyecto_id` bigint NOT NULL,
  `desarrollador_id` bigint NOT NULL,
  `descripcion` text NOT NULL,
  `archivo_url` varchar(500) DEFAULT NULL,
  `porcentaje` tinyint DEFAULT '0',
  `fecha_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `desarrollador_id` (`desarrollador_id`),
  KEY `idx_proyecto` (`proyecto_id`),
  KEY `idx_fecha` (`fecha_hora`),
  KEY `idx_proyecto_fecha` (`proyecto_id`,`fecha_hora`),
  CONSTRAINT `avances_ibfk_1` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `avances_ibfk_2` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avances`
--

LOCK TABLES `avances` WRITE;
/*!40000 ALTER TABLE `avances` DISABLE KEYS */;
/*!40000 ALTER TABLE `avances` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dylan`@`localhost`*/ /*!50003 TRIGGER `trg_verificar_inactividad` BEFORE INSERT ON `avances` FOR EACH ROW BEGIN
  UPDATE proyectos
  SET estado = 'en_desarrollo'
  WHERE id = NEW.proyecto_id AND estado = 'inactivo';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dylan`@`localhost`*/ /*!50003 TRIGGER `trg_nuevo_avance` AFTER INSERT ON `avances` FOR EACH ROW BEGIN
  DECLARE empresa_id_var INT;
  DECLARE nombre_dev VARCHAR(150);

  SELECT empresa_id INTO empresa_id_var FROM proyectos WHERE id = NEW.proyecto_id;
  SELECT nombre INTO nombre_dev FROM usuarios WHERE id = NEW.desarrollador_id;

  INSERT INTO notificaciones (usuario_id, tipo, mensaje)
  VALUES (
    empresa_id_var,
    'avance',
    CONCAT(nombre_dev, ' registró un avance del ', NEW.porcentaje, '% en tu proyecto.')
  );

  INSERT INTO notificaciones (usuario_id, tipo, mensaje)
  SELECT id, 'avance',
    CONCAT('Nuevo avance registrado en proyecto ID: ', NEW.proyecto_id, ' (', NEW.porcentaje, '%)')
  FROM usuarios WHERE rol = 'administrador';

  IF NEW.porcentaje = 100 THEN
    UPDATE proyectos SET estado = 'en_revision' WHERE id = NEW.proyecto_id;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `avances_avance`
--

DROP TABLE IF EXISTS `avances_avance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avances_avance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `descripcion` longtext NOT NULL,
  `archivo_url` varchar(500) DEFAULT NULL,
  `porcentaje` smallint unsigned NOT NULL,
  `fecha_hora` datetime(6) NOT NULL,
  `desarrollador_id` bigint NOT NULL,
  `proyecto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `avances_avance_desarrollador_id_09fe6505_fk_usuarios_usuario_id` (`desarrollador_id`),
  KEY `avances_avance_proyecto_id_adccbb61_fk_proyectos_proyecto_id` (`proyecto_id`),
  CONSTRAINT `avances_avance_desarrollador_id_09fe6505_fk_usuarios_usuario_id` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `avances_avance_proyecto_id_adccbb61_fk_proyectos_proyecto_id` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos_proyecto` (`id`),
  CONSTRAINT `avances_avance_chk_1` CHECK ((`porcentaje` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avances_avance`
--

LOCK TABLES `avances_avance` WRITE;
/*!40000 ALTER TABLE `avances_avance` DISABLE KEYS */;
/*!40000 ALTER TABLE `avances_avance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contrataciones`
--

DROP TABLE IF EXISTS `contrataciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contrataciones` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `proyecto_id` bigint NOT NULL,
  `desarrollador_id` bigint NOT NULL,
  `empresa_id` bigint NOT NULL,
  `asignado_por_id` bigint DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin_estimada` date DEFAULT NULL,
  `estado` varchar(10) NOT NULL DEFAULT 'activa',
  PRIMARY KEY (`id`),
  UNIQUE KEY `proyecto_id` (`proyecto_id`),
  KEY `asignado_por_id` (`asignado_por_id`),
  KEY `idx_desarrollador` (`desarrollador_id`),
  KEY `idx_empresa` (`empresa_id`),
  KEY `idx_estado` (`estado`),
  CONSTRAINT `contrataciones_ibfk_1` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`),
  CONSTRAINT `contrataciones_ibfk_2` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `contrataciones_ibfk_3` FOREIGN KEY (`empresa_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `contrataciones_ibfk_4` FOREIGN KEY (`asignado_por_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contrataciones`
--

LOCK TABLES `contrataciones` WRITE;
/*!40000 ALTER TABLE `contrataciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `contrataciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contrataciones_contratacion`
--

DROP TABLE IF EXISTS `contrataciones_contratacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contrataciones_contratacion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin_estimada` date DEFAULT NULL,
  `estado` varchar(10) NOT NULL,
  `asignado_por_id` bigint DEFAULT NULL,
  `desarrollador_id` bigint NOT NULL,
  `empresa_id` bigint NOT NULL,
  `proyecto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contrataciones_contr_asignado_por_id_4ff62827_fk_usuarios_` (`asignado_por_id`),
  KEY `contrataciones_contr_desarrollador_id_d4d3e646_fk_usuarios_` (`desarrollador_id`),
  KEY `contrataciones_contr_empresa_id_6d740a92_fk_usuarios_` (`empresa_id`),
  KEY `contrataciones_contratacion_proyecto_id_b3c5d3ed` (`proyecto_id`),
  CONSTRAINT `contrataciones_contr_asignado_por_id_4ff62827_fk_usuarios_` FOREIGN KEY (`asignado_por_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `contrataciones_contr_desarrollador_id_d4d3e646_fk_usuarios_` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `contrataciones_contr_empresa_id_6d740a92_fk_usuarios_` FOREIGN KEY (`empresa_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `contrataciones_contr_proyecto_id_b3c5d3ed_fk_proyectos` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos_proyecto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contrataciones_contratacion`
--

LOCK TABLES `contrataciones_contratacion` WRITE;
/*!40000 ALTER TABLE `contrataciones_contratacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `contrataciones_contratacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `copias_seguridad`
--

DROP TABLE IF EXISTS `copias_seguridad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `copias_seguridad` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ejecutado_por` bigint DEFAULT NULL,
  `archivo_url` varchar(500) DEFAULT NULL,
  `tamano_mb` decimal(10,2) DEFAULT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` enum('exitoso','fallido','pendiente') DEFAULT 'pendiente',
  PRIMARY KEY (`id`),
  KEY `ejecutado_por` (`ejecutado_por`),
  KEY `idx_fecha` (`fecha`),
  KEY `idx_estado` (`estado`),
  CONSTRAINT `copias_seguridad_ibfk_1` FOREIGN KEY (`ejecutado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `copias_seguridad`
--

LOCK TABLES `copias_seguridad` WRITE;
/*!40000 ALTER TABLE `copias_seguridad` DISABLE KEYS */;
INSERT INTO `copias_seguridad` VALUES (1,NULL,'Pendiente de ejecución manual',NULL,'2026-03-16 14:01:12','pendiente');
/*!40000 ALTER TABLE `copias_seguridad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` bigint DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_usuarios_usuario_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_usuarios_usuario_id` FOREIGN KEY (`user_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (4,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(14,'avances','avance'),(1,'contenttypes','contenttype'),(13,'contrataciones','contratacion'),(17,'favoritos','favorito'),(18,'logs','copiaseguridad'),(19,'logs','logauditoria'),(15,'mensajes','mensaje'),(16,'notificaciones','notificacion'),(12,'postulaciones','postulacion'),(9,'proyectos','historialestadoproyecto'),(10,'proyectos','proyecto'),(11,'proyectos','valoracion'),(8,'sessions','session'),(5,'usuarios','perfildesarrollador'),(6,'usuarios','perfilempresa'),(7,'usuarios','usuario');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-03-16 19:48:07.938564'),(2,'contenttypes','0002_remove_content_type_name','2026-03-16 19:48:08.037721'),(3,'auth','0001_initial','2026-03-16 19:48:09.266060'),(4,'auth','0002_alter_permission_name_max_length','2026-03-16 19:48:09.333581'),(5,'auth','0003_alter_user_email_max_length','2026-03-16 19:48:09.345672'),(6,'auth','0004_alter_user_username_opts','2026-03-16 19:48:09.357093'),(7,'auth','0005_alter_user_last_login_null','2026-03-16 19:48:09.368923'),(8,'auth','0006_require_contenttypes_0002','2026-03-16 19:48:09.372384'),(9,'auth','0007_alter_validators_add_error_messages','2026-03-16 19:48:09.384225'),(10,'auth','0008_alter_user_username_max_length','2026-03-16 19:48:09.400825'),(11,'auth','0009_alter_user_last_name_max_length','2026-03-16 19:48:09.412949'),(12,'auth','0010_alter_group_name_max_length','2026-03-16 19:48:09.440721'),(13,'auth','0011_update_proxy_permissions','2026-03-16 19:48:09.455446'),(14,'auth','0012_alter_user_first_name_max_length','2026-03-16 19:48:09.468210'),(15,'usuarios','0001_initial','2026-03-16 19:48:10.949857'),(16,'admin','0001_initial','2026-03-16 19:48:11.120348'),(17,'admin','0002_logentry_remove_auto_add','2026-03-16 19:48:11.139332'),(18,'admin','0003_logentry_add_action_flag_choices','2026-03-16 19:48:11.160507'),(19,'sessions','0001_initial','2026-03-16 19:48:12.259892'),(20,'usuarios','0002_usuario_fecha_nacimiento_and_more','2026-03-16 19:48:13.415276'),(21,'proyectos','0001_initial','2026-03-16 19:48:14.596694'),(22,'proyectos','0002_proyecto_vacantes_alter_proyecto_estado_and_more','2026-03-16 19:48:15.110304'),(23,'avances','0001_initial','2026-03-16 19:48:16.384068'),(24,'contrataciones','0001_initial','2026-03-16 19:48:16.737282'),(25,'contrataciones','0002_alter_contratacion_proyecto','2026-03-16 19:48:16.955475'),(26,'favoritos','0001_initial','2026-03-16 19:48:17.165221'),(27,'logs','0001_initial','2026-03-16 19:48:17.430937'),(28,'mensajes','0001_initial','2026-03-16 19:48:17.734636'),(29,'notificaciones','0001_initial','2026-03-16 19:48:17.878104'),(30,'postulaciones','0001_initial','2026-03-16 19:48:18.136088'),(31,'avances','0002_alter_avance_table','2026-03-20 23:15:00.000000'),(32,'contrataciones','0003_alter_contratacion_table','2026-03-20 23:15:01.000000'),(33,'favoritos','0002_alter_favorito_table','2026-03-20 23:15:02.000000'),(34,'logs','0002_alter_copiaseguridad_table_alter_logauditoria_table','2026-03-20 23:15:03.000000'),(35,'mensajes','0002_alter_mensaje_table','2026-03-20 23:15:04.000000'),(36,'notificaciones','0002_alter_notificacion_table','2026-03-20 23:15:05.000000'),(37,'postulaciones','0002_alter_postulacion_table','2026-03-20 23:15:06.000000'),(38,'proyectos','0003_alter_historialestadoproyecto_table_and_more','2026-03-20 23:15:07.000000'),(39,'usuarios','0003_alter_usuario_options_usuario_nombre_and_more','2026-03-20 23:15:08.000000');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favoritos`
--

DROP TABLE IF EXISTS `favoritos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favoritos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `desarrollador_id` bigint NOT NULL,
  `proyecto_id` bigint NOT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico_favorito` (`desarrollador_id`,`proyecto_id`),
  KEY `proyecto_id` (`proyecto_id`),
  KEY `idx_desarrollador` (`desarrollador_id`),
  CONSTRAINT `favoritos_ibfk_1` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favoritos_ibfk_2` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favoritos`
--

LOCK TABLES `favoritos` WRITE;
/*!40000 ALTER TABLE `favoritos` DISABLE KEYS */;
/*!40000 ALTER TABLE `favoritos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favoritos_favorito`
--

DROP TABLE IF EXISTS `favoritos_favorito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favoritos_favorito` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fecha` datetime(6) NOT NULL,
  `desarrollador_id` bigint NOT NULL,
  `proyecto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `favoritos_favorito_desarrollador_id_proyecto_id_dce6e554_uniq` (`desarrollador_id`,`proyecto_id`),
  KEY `favoritos_favorito_proyecto_id_bce52f6a_fk_proyectos_proyecto_id` (`proyecto_id`),
  CONSTRAINT `favoritos_favorito_desarrollador_id_a2c33ceb_fk_usuarios_` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `favoritos_favorito_proyecto_id_bce52f6a_fk_proyectos_proyecto_id` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos_proyecto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favoritos_favorito`
--

LOCK TABLES `favoritos_favorito` WRITE;
/*!40000 ALTER TABLE `favoritos_favorito` DISABLE KEYS */;
/*!40000 ALTER TABLE `favoritos_favorito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_estado_proyecto`
--

DROP TABLE IF EXISTS `historial_estado_proyecto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_estado_proyecto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `proyecto_id` bigint NOT NULL,
  `estado_anterior` varchar(50) DEFAULT NULL,
  `estado_nuevo` varchar(50) DEFAULT NULL,
  `cambiado_por` bigint DEFAULT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `proyecto_id` (`proyecto_id`),
  KEY `cambiado_por` (`cambiado_por`),
  CONSTRAINT `historial_estado_proyecto_ibfk_1` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `historial_estado_proyecto_ibfk_2` FOREIGN KEY (`cambiado_por`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_estado_proyecto`
--

LOCK TABLES `historial_estado_proyecto` WRITE;
/*!40000 ALTER TABLE `historial_estado_proyecto` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_estado_proyecto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_auditoria`
--

DROP TABLE IF EXISTS `logs_auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs_auditoria` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint DEFAULT NULL,
  `accion` varchar(300) NOT NULL,
  `tabla_afectada` varchar(100) DEFAULT NULL,
  `registro_id` bigint DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_fecha` (`fecha_hora`),
  KEY `idx_tabla` (`tabla_afectada`),
  CONSTRAINT `logs_auditoria_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_auditoria`
--

LOCK TABLES `logs_auditoria` WRITE;
/*!40000 ALTER TABLE `logs_auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs_auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_copiaseguridad`
--

DROP TABLE IF EXISTS `logs_copiaseguridad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs_copiaseguridad` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `archivo_url` varchar(500) NOT NULL,
  `tamano_mb` decimal(10,2) DEFAULT NULL,
  `fecha` datetime(6) NOT NULL,
  `estado` varchar(15) NOT NULL,
  `ejecutado_por_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `logs_copiaseguridad_ejecutado_por_id_13e927b8_fk_usuarios_` (`ejecutado_por_id`),
  CONSTRAINT `logs_copiaseguridad_ejecutado_por_id_13e927b8_fk_usuarios_` FOREIGN KEY (`ejecutado_por_id`) REFERENCES `usuarios_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_copiaseguridad`
--

LOCK TABLES `logs_copiaseguridad` WRITE;
/*!40000 ALTER TABLE `logs_copiaseguridad` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs_copiaseguridad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_logauditoria`
--

DROP TABLE IF EXISTS `logs_logauditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs_logauditoria` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `accion` varchar(300) NOT NULL,
  `tabla_afectada` varchar(100) DEFAULT NULL,
  `registro_id` bigint DEFAULT NULL,
  `ip_address` char(39) DEFAULT NULL,
  `fecha_hora` datetime(6) NOT NULL,
  `usuario_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `logs_logauditoria_usuario_id_0ae6fa0a_fk_usuarios_usuario_id` (`usuario_id`),
  CONSTRAINT `logs_logauditoria_usuario_id_0ae6fa0a_fk_usuarios_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_logauditoria`
--

LOCK TABLES `logs_logauditoria` WRITE;
/*!40000 ALTER TABLE `logs_logauditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs_logauditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mensajes`
--

DROP TABLE IF EXISTS `mensajes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mensajes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `remitente_id` bigint NOT NULL,
  `receptor_id` bigint NOT NULL,
  `proyecto_id` bigint DEFAULT NULL,
  `asunto` varchar(200) DEFAULT NULL,
  `cuerpo` text NOT NULL,
  `leido` tinyint(1) DEFAULT '0',
  `archivado` tinyint(1) DEFAULT '0',
  `fecha_envio` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `proyecto_id` (`proyecto_id`),
  KEY `idx_receptor_leido` (`receptor_id`,`leido`),
  KEY `idx_remitente` (`remitente_id`),
  KEY `idx_fecha` (`fecha_envio`),
  CONSTRAINT `mensajes_ibfk_1` FOREIGN KEY (`remitente_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `mensajes_ibfk_2` FOREIGN KEY (`receptor_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `mensajes_ibfk_3` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mensajes`
--

LOCK TABLES `mensajes` WRITE;
/*!40000 ALTER TABLE `mensajes` DISABLE KEYS */;
/*!40000 ALTER TABLE `mensajes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mensajes_mensaje`
--

DROP TABLE IF EXISTS `mensajes_mensaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mensajes_mensaje` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `asunto` varchar(200) DEFAULT NULL,
  `cuerpo` longtext NOT NULL,
  `leido` tinyint(1) NOT NULL,
  `archivado` tinyint(1) NOT NULL,
  `fecha_envio` datetime(6) NOT NULL,
  `proyecto_id` bigint DEFAULT NULL,
  `receptor_id` bigint NOT NULL,
  `remitente_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mensajes_mensaje_proyecto_id_b5e2a6b2_fk_proyectos_proyecto_id` (`proyecto_id`),
  KEY `mensajes_mensaje_receptor_id_7add9bcb_fk_usuarios_usuario_id` (`receptor_id`),
  KEY `mensajes_mensaje_remitente_id_a4b19a27_fk_usuarios_usuario_id` (`remitente_id`),
  CONSTRAINT `mensajes_mensaje_proyecto_id_b5e2a6b2_fk_proyectos_proyecto_id` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos_proyecto` (`id`),
  CONSTRAINT `mensajes_mensaje_receptor_id_7add9bcb_fk_usuarios_usuario_id` FOREIGN KEY (`receptor_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `mensajes_mensaje_remitente_id_a4b19a27_fk_usuarios_usuario_id` FOREIGN KEY (`remitente_id`) REFERENCES `usuarios_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mensajes_mensaje`
--

LOCK TABLES `mensajes_mensaje` WRITE;
/*!40000 ALTER TABLE `mensajes_mensaje` DISABLE KEYS */;
/*!40000 ALTER TABLE `mensajes_mensaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificaciones` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `tipo` enum('postulacion','avance','aprobacion','mensaje','alerta','otro') DEFAULT 'otro',
  `mensaje` text NOT NULL,
  `leida` tinyint(1) DEFAULT '0',
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_usuario_leida` (`usuario_id`,`leida`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_fecha` (`fecha`),
  CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificaciones`
--

LOCK TABLES `notificaciones` WRITE;
/*!40000 ALTER TABLE `notificaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificaciones_notificacion`
--

DROP TABLE IF EXISTS `notificaciones_notificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificaciones_notificacion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tipo` varchar(20) NOT NULL,
  `mensaje` longtext NOT NULL,
  `leida` tinyint(1) NOT NULL,
  `fecha` datetime(6) NOT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notificaciones_notif_usuario_id_4bc090a3_fk_usuarios_` (`usuario_id`),
  CONSTRAINT `notificaciones_notif_usuario_id_4bc090a3_fk_usuarios_` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificaciones_notificacion`
--

LOCK TABLES `notificaciones_notificacion` WRITE;
/*!40000 ALTER TABLE `notificaciones_notificacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificaciones_notificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfil_desarrollador`
--

DROP TABLE IF EXISTS `perfil_desarrollador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfil_desarrollador` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `programa_formacion` varchar(200) DEFAULT NULL,
  `ficha` varchar(50) DEFAULT NULL,
  `habilidades` text,
  `calificacion_promedio` decimal(3,2) DEFAULT '0.00',
  `num_proyectos_completados` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  KEY `idx_calificacion` (`calificacion_promedio`),
  CONSTRAINT `perfil_desarrollador_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil_desarrollador`
--

LOCK TABLES `perfil_desarrollador` WRITE;
/*!40000 ALTER TABLE `perfil_desarrollador` DISABLE KEYS */;
/*!40000 ALTER TABLE `perfil_desarrollador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfil_empresa`
--

DROP TABLE IF EXISTS `perfil_empresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfil_empresa` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `nombre_empresa` varchar(200) DEFAULT NULL,
  `nit` varchar(30) DEFAULT NULL,
  `sector` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `descripcion` text,
  `ciudad` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  KEY `idx_sector` (`sector`),
  KEY `idx_ciudad` (`ciudad`),
  CONSTRAINT `perfil_empresa_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil_empresa`
--

LOCK TABLES `perfil_empresa` WRITE;
/*!40000 ALTER TABLE `perfil_empresa` DISABLE KEYS */;
/*!40000 ALTER TABLE `perfil_empresa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `postulaciones`
--

DROP TABLE IF EXISTS `postulaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `postulaciones` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `proyecto_id` bigint NOT NULL,
  `desarrollador_id` bigint NOT NULL,
  `mensaje` text,
  `estado` enum('pendiente','aceptada','rechazada') DEFAULT 'pendiente',
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_postulacion` (`proyecto_id`,`desarrollador_id`),
  KEY `idx_desarrollador_estado` (`desarrollador_id`,`estado`),
  KEY `idx_proyecto_estado` (`proyecto_id`,`estado`),
  KEY `idx_fecha` (`fecha`),
  CONSTRAINT `postulaciones_ibfk_1` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `postulaciones_ibfk_2` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `postulaciones`
--

LOCK TABLES `postulaciones` WRITE;
/*!40000 ALTER TABLE `postulaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `postulaciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dylan`@`localhost`*/ /*!50003 TRIGGER `trg_nueva_postulacion` AFTER INSERT ON `postulaciones` FOR EACH ROW BEGIN
  DECLARE empresa_duena INT;
  DECLARE nombre_dev VARCHAR(150);

  SELECT empresa_id INTO empresa_duena FROM proyectos WHERE id = NEW.proyecto_id;
  SELECT nombre INTO nombre_dev FROM usuarios WHERE id = NEW.desarrollador_id;

  INSERT INTO notificaciones (usuario_id, tipo, mensaje)
  VALUES (
    empresa_duena,
    'postulacion',
    CONCAT('El desarrollador "', nombre_dev, '" se postuló a tu proyecto.')
  );

  INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
  VALUES (NEW.desarrollador_id, 'Nueva postulación registrada', 'postulaciones', NEW.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dylan`@`localhost`*/ /*!50003 TRIGGER `trg_postulacion_aceptada` AFTER UPDATE ON `postulaciones` FOR EACH ROW BEGIN
  IF NEW.estado = 'aceptada' AND OLD.estado != 'aceptada' THEN

    UPDATE proyectos SET estado = 'en_desarrollo' WHERE id = NEW.proyecto_id;

    INSERT INTO notificaciones (usuario_id, tipo, mensaje)
    VALUES (
      NEW.desarrollador_id,
      'aprobacion',
      CONCAT('¡Felicitaciones! Tu postulación fue aceptada para el proyecto ID: ', NEW.proyecto_id)
    );

    UPDATE postulaciones
    SET estado = 'rechazada'
    WHERE proyecto_id = NEW.proyecto_id
      AND id != NEW.id
      AND estado = 'pendiente';

  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `postulaciones_postulacion`
--

DROP TABLE IF EXISTS `postulaciones_postulacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `postulaciones_postulacion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `mensaje` longtext,
  `estado` varchar(10) NOT NULL,
  `fecha` datetime(6) NOT NULL,
  `desarrollador_id` bigint NOT NULL,
  `proyecto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `postulaciones_postulacio_proyecto_id_desarrollado_26e94983_uniq` (`proyecto_id`,`desarrollador_id`),
  KEY `postulaciones_postul_desarrollador_id_490287f9_fk_usuarios_` (`desarrollador_id`),
  CONSTRAINT `postulaciones_postul_desarrollador_id_490287f9_fk_usuarios_` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `postulaciones_postul_proyecto_id_e07861be_fk_proyectos` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos_proyecto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `postulaciones_postulacion`
--

LOCK TABLES `postulaciones_postulacion` WRITE;
/*!40000 ALTER TABLE `postulaciones_postulacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `postulaciones_postulacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyectos`
--

DROP TABLE IF EXISTS `proyectos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyectos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `empresa_id` bigint NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text NOT NULL,
  `tipo_solucion` varchar(30) NOT NULL,
  `prioridad` varchar(10) NOT NULL DEFAULT 'media',
  `vacantes` int unsigned NOT NULL DEFAULT '1',
  `estado` varchar(25) NOT NULL DEFAULT 'publicado',
  `fecha_publicacion` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `fecha_limite` date DEFAULT NULL,
  `aprobado_por_id` bigint DEFAULT NULL,
  `fecha_aprobacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aprobado_por_id` (`aprobado_por_id`),
  KEY `idx_empresa_id` (`empresa_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_tipo_solucion` (`tipo_solucion`),
  KEY `idx_prioridad` (`prioridad`),
  KEY `idx_fecha_publicacion` (`fecha_publicacion`),
  KEY `idx_estado_fecha` (`estado`,`fecha_publicacion`),
  CONSTRAINT `proyectos_ibfk_1` FOREIGN KEY (`empresa_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `proyectos_ibfk_2` FOREIGN KEY (`aprobado_por_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyectos`
--

LOCK TABLES `proyectos` WRITE;
/*!40000 ALTER TABLE `proyectos` DISABLE KEYS */;
/*!40000 ALTER TABLE `proyectos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dylan`@`localhost`*/ /*!50003 TRIGGER `trg_historial_estado_proyecto` AFTER UPDATE ON `proyectos` FOR EACH ROW BEGIN
  IF OLD.estado <> NEW.estado THEN
    INSERT INTO historial_estado_proyecto
      (proyecto_id, estado_anterior, estado_nuevo, cambiado_por)
    VALUES (NEW.id, OLD.estado, NEW.estado, NEW.aprobado_por_id);  
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `proyectos_historialestadoproyecto`
--

DROP TABLE IF EXISTS `proyectos_historialestadoproyecto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyectos_historialestadoproyecto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `estado_anterior` varchar(50) NOT NULL,
  `estado_nuevo` varchar(50) NOT NULL,
  `fecha` datetime(6) NOT NULL,
  `cambiado_por_id` bigint DEFAULT NULL,
  `proyecto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `proyectos_historiale_cambiado_por_id_4d19b518_fk_usuarios_` (`cambiado_por_id`),
  KEY `proyectos_historiale_proyecto_id_696c5eee_fk_proyectos` (`proyecto_id`),
  CONSTRAINT `proyectos_historiale_cambiado_por_id_4d19b518_fk_usuarios_` FOREIGN KEY (`cambiado_por_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `proyectos_historiale_proyecto_id_696c5eee_fk_proyectos` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos_proyecto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyectos_historialestadoproyecto`
--

LOCK TABLES `proyectos_historialestadoproyecto` WRITE;
/*!40000 ALTER TABLE `proyectos_historialestadoproyecto` DISABLE KEYS */;
/*!40000 ALTER TABLE `proyectos_historialestadoproyecto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyectos_proyecto`
--

DROP TABLE IF EXISTS `proyectos_proyecto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyectos_proyecto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `titulo` varchar(200) NOT NULL,
  `descripcion` longtext NOT NULL,
  `tipo_solucion` varchar(30) NOT NULL,
  `prioridad` varchar(10) NOT NULL,
  `estado` varchar(25) NOT NULL,
  `fecha_publicacion` datetime(6) NOT NULL,
  `fecha_limite` date DEFAULT NULL,
  `fecha_aprobacion` datetime(6) DEFAULT NULL,
  `aprobado_por_id` bigint DEFAULT NULL,
  `empresa_id` bigint NOT NULL,
  `vacantes` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `proyectos_proyecto_aprobado_por_id_eb78c125_fk_usuarios_` (`aprobado_por_id`),
  KEY `proyectos_proyecto_empresa_id_687ab3ea_fk_usuarios_usuario_id` (`empresa_id`),
  CONSTRAINT `proyectos_proyecto_aprobado_por_id_eb78c125_fk_usuarios_` FOREIGN KEY (`aprobado_por_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `proyectos_proyecto_empresa_id_687ab3ea_fk_usuarios_usuario_id` FOREIGN KEY (`empresa_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `proyectos_proyecto_chk_1` CHECK ((`vacantes` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyectos_proyecto`
--

LOCK TABLES `proyectos_proyecto` WRITE;
/*!40000 ALTER TABLE `proyectos_proyecto` DISABLE KEYS */;
/*!40000 ALTER TABLE `proyectos_proyecto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyectos_valoracion`
--

DROP TABLE IF EXISTS `proyectos_valoracion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyectos_valoracion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `puntuacion` smallint unsigned NOT NULL,
  `comentario` longtext,
  `fecha` datetime(6) NOT NULL,
  `desarrollador_id` bigint NOT NULL,
  `empresa_id` bigint NOT NULL,
  `proyecto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `proyecto_id` (`proyecto_id`),
  KEY `proyectos_valoracion_desarrollador_id_f1cf6b24_fk_usuarios_` (`desarrollador_id`),
  KEY `proyectos_valoracion_empresa_id_a86183cd_fk_usuarios_usuario_id` (`empresa_id`),
  CONSTRAINT `proyectos_valoracion_desarrollador_id_f1cf6b24_fk_usuarios_` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `proyectos_valoracion_empresa_id_a86183cd_fk_usuarios_usuario_id` FOREIGN KEY (`empresa_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `proyectos_valoracion_proyecto_id_869f1d84_fk_proyectos` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos_proyecto` (`id`),
  CONSTRAINT `proyectos_valoracion_chk_1` CHECK ((`puntuacion` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyectos_valoracion`
--

LOCK TABLES `proyectos_valoracion` WRITE;
/*!40000 ALTER TABLE `proyectos_valoracion` DISABLE KEYS */;
/*!40000 ALTER TABLE `proyectos_valoracion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `cedula` varchar(20) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('empresa','desarrollador','administrador') NOT NULL,
  `estado` enum('activo','inactivo','suspendido') DEFAULT 'activo',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `ultimo_acceso` datetime DEFAULT NULL,
  `token_recuperacion` varchar(255) DEFAULT NULL,
  `token_expiracion` datetime DEFAULT NULL,
  `intentos_fallidos` tinyint DEFAULT '0',
  `bloqueado_hasta` datetime DEFAULT NULL,
  `is_staff` tinyint(1) DEFAULT '0',
  `is_superuser` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `first_name` varchar(150) DEFAULT NULL,
  `last_name` varchar(150) DEFAULT NULL,
  `date_joined` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `correo` (`email`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `cedula` (`cedula`),
  KEY `idx_rol` (`rol`),
  KEY `idx_estado` (`estado`),
  KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dylan`@`localhost`*/ /*!50003 TRIGGER `trg_registro_sesion` BEFORE UPDATE ON `usuarios` FOR EACH ROW BEGIN
  IF NEW.ultimo_acceso IS NOT NULL AND 
     (OLD.ultimo_acceso IS NULL OR OLD.ultimo_acceso != NEW.ultimo_acceso) THEN
    INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
    VALUES (NEW.id, 'Inicio de sesión registrado', 'usuarios', NEW.id);
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dylan`@`localhost`*/ /*!50003 TRIGGER `trg_log_usuario_modificado` AFTER UPDATE ON `usuarios` FOR EACH ROW BEGIN
  INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
  VALUES (
    NEW.id,
    CONCAT('Usuario modificado. Estado anterior: ', OLD.estado, ' → Nuevo: ', NEW.estado),
    'usuarios',
    NEW.id
  );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuarios_perfildesarrollador`
--

DROP TABLE IF EXISTS `usuarios_perfildesarrollador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_perfildesarrollador` (
  `usuario_id` bigint NOT NULL,
  `programa_formacion` varchar(200) DEFAULT NULL,
  `ficha` varchar(50) DEFAULT NULL,
  `habilidades` longtext,
  `calificacion_promedio` decimal(3,2) NOT NULL,
  `num_proyectos_completados` int NOT NULL,
  PRIMARY KEY (`usuario_id`),
  CONSTRAINT `usuarios_perfildesar_usuario_id_6fb0cdf1_fk_usuarios_` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_perfildesarrollador`
--

LOCK TABLES `usuarios_perfildesarrollador` WRITE;
/*!40000 ALTER TABLE `usuarios_perfildesarrollador` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios_perfildesarrollador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_perfilempresa`
--

DROP TABLE IF EXISTS `usuarios_perfilempresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_perfilempresa` (
  `usuario_id` bigint NOT NULL,
  `nombre_empresa` varchar(200) DEFAULT NULL,
  `nit` varchar(30) DEFAULT NULL,
  `sector` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `descripcion` longtext,
  `ciudad` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`usuario_id`),
  CONSTRAINT `usuarios_perfilempre_usuario_id_13617110_fk_usuarios_` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_perfilempresa`
--

LOCK TABLES `usuarios_perfilempresa` WRITE;
/*!40000 ALTER TABLE `usuarios_perfilempresa` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios_perfilempresa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_usuario`
--

DROP TABLE IF EXISTS `usuarios_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_usuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `cedula` varchar(20) DEFAULT NULL,
  `rol` varchar(20) NOT NULL,
  `estado` varchar(20) NOT NULL,
  `fecha_registro` datetime(6) NOT NULL,
  `ultimo_acceso` datetime(6) DEFAULT NULL,
  `token_recuperacion` varchar(255) DEFAULT NULL,
  `token_expiracion` datetime(6) DEFAULT NULL,
  `intentos_fallidos` smallint unsigned NOT NULL,
  `bloqueado_hasta` datetime(6) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `cedula` (`cedula`),
  CONSTRAINT `usuarios_usuario_chk_1` CHECK ((`intentos_fallidos` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_usuario`
--

LOCK TABLES `usuarios_usuario` WRITE;
/*!40000 ALTER TABLE `usuarios_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_usuario_groups`
--

DROP TABLE IF EXISTS `usuarios_usuario_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_usuario_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `group_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuarios_usuario_groups_usuario_id_group_id_4ed5b09e_uniq` (`usuario_id`,`group_id`),
  KEY `usuarios_usuario_groups_group_id_e77f6dcf_fk_auth_group_id` (`group_id`),
  CONSTRAINT `usuarios_usuario_gro_usuario_id_7a34077f_fk_usuarios_` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios_usuario` (`id`),
  CONSTRAINT `usuarios_usuario_groups_group_id_e77f6dcf_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_usuario_groups`
--

LOCK TABLES `usuarios_usuario_groups` WRITE;
/*!40000 ALTER TABLE `usuarios_usuario_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios_usuario_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_usuario_user_permissions`
--

DROP TABLE IF EXISTS `usuarios_usuario_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_usuario_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `permission_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuarios_usuario_user_pe_usuario_id_permission_id_217cadcd_uniq` (`usuario_id`,`permission_id`),
  KEY `usuarios_usuario_use_permission_id_4e5c0f2f_fk_auth_perm` (`permission_id`),
  CONSTRAINT `usuarios_usuario_use_permission_id_4e5c0f2f_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `usuarios_usuario_use_usuario_id_60aeea80_fk_usuarios_` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_usuario_user_permissions`
--

LOCK TABLES `usuarios_usuario_user_permissions` WRITE;
/*!40000 ALTER TABLE `usuarios_usuario_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios_usuario_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_calificacion_desarrolladores`
--

DROP TABLE IF EXISTS `v_calificacion_desarrolladores`;
/*!50001 DROP VIEW IF EXISTS `v_calificacion_desarrolladores`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_calificacion_desarrolladores` AS SELECT 
 1 AS `desarrollador_id`,
 1 AS `total_calificaciones`,
 1 AS `promedio`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_dashboard_admin`
--

DROP TABLE IF EXISTS `v_dashboard_admin`;
/*!50001 DROP VIEW IF EXISTS `v_dashboard_admin`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_dashboard_admin` AS SELECT 
 1 AS `total_usuarios`,
 1 AS `total_empresas`,
 1 AS `total_desarrolladores`,
 1 AS `total_proyectos`,
 1 AS `proyectos_publicados`,
 1 AS `proyectos_en_desarrollo`,
 1 AS `proyectos_finalizados`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_dashboard_desarrollador`
--

DROP TABLE IF EXISTS `v_dashboard_desarrollador`;
/*!50001 DROP VIEW IF EXISTS `v_dashboard_desarrollador`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_dashboard_desarrollador` AS SELECT 
 1 AS `desarrollador_id`,
 1 AS `nombre`,
 1 AS `calificacion_promedio`,
 1 AS `num_proyectos_completados`,
 1 AS `mensajes_nuevos`,
 1 AS `proyectos_activos`,
 1 AS `proyectos_favoritos`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_dashboard_empresa`
--

DROP TABLE IF EXISTS `v_dashboard_empresa`;
/*!50001 DROP VIEW IF EXISTS `v_dashboard_empresa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_dashboard_empresa` AS SELECT 
 1 AS `empresa_id`,
 1 AS `nombre`,
 1 AS `nombre_empresa`,
 1 AS `proyectos_publicados`,
 1 AS `proyectos_activos`,
 1 AS `postulaciones_pendientes`,
 1 AS `desarrolladores_contratados`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_estadisticas_sistema`
--

DROP TABLE IF EXISTS `v_estadisticas_sistema`;
/*!50001 DROP VIEW IF EXISTS `v_estadisticas_sistema`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_estadisticas_sistema` AS SELECT 
 1 AS `total_empresas_activas`,
 1 AS `total_desarrolladores_activos`,
 1 AS `proyectos_publicados`,
 1 AS `proyectos_en_desarrollo`,
 1 AS `proyectos_finalizados`,
 1 AS `proyectos_pendientes_aprobacion`,
 1 AS `postulaciones_pendientes`,
 1 AS `calificacion_promedio_global`,
 1 AS `proyectos_con_retraso`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_notificaciones_pendientes`
--

DROP TABLE IF EXISTS `v_notificaciones_pendientes`;
/*!50001 DROP VIEW IF EXISTS `v_notificaciones_pendientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_notificaciones_pendientes` AS SELECT 
 1 AS `id`,
 1 AS `usuario_id`,
 1 AS `usuario_nombre`,
 1 AS `tipo`,
 1 AS `mensaje`,
 1 AS `fecha`,
 1 AS `minutos_desde_creacion`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_portafolio_publico`
--

DROP TABLE IF EXISTS `v_portafolio_publico`;
/*!50001 DROP VIEW IF EXISTS `v_portafolio_publico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_portafolio_publico` AS SELECT 
 1 AS `proyecto_id`,
 1 AS `titulo`,
 1 AS `descripcion`,
 1 AS `tipo_solucion`,
 1 AS `fecha_publicacion`,
 1 AS `empresa_nombre`,
 1 AS `nombre_empresa`,
 1 AS `sector`,
 1 AS `desarrollador_nombre`,
 1 AS `programa_formacion`,
 1 AS `calificacion_promedio`,
 1 AS `calificacion_proyecto`,
 1 AS `comentario`,
 1 AS `fecha_finalizacion`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_postulaciones_activas`
--

DROP TABLE IF EXISTS `v_postulaciones_activas`;
/*!50001 DROP VIEW IF EXISTS `v_postulaciones_activas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_postulaciones_activas` AS SELECT 
 1 AS `id`,
 1 AS `proyecto_id`,
 1 AS `desarrollador_id`,
 1 AS `mensaje`,
 1 AS `estado`,
 1 AS `fecha`,
 1 AS `desarrollador_nombre`,
 1 AS `calificacion_promedio`,
 1 AS `num_proyectos_completados`,
 1 AS `habilidades`,
 1 AS `proyecto_titulo`,
 1 AS `empresa_nombre`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_proyectos_alerta_inactividad`
--

DROP TABLE IF EXISTS `v_proyectos_alerta_inactividad`;
/*!50001 DROP VIEW IF EXISTS `v_proyectos_alerta_inactividad`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_proyectos_alerta_inactividad` AS SELECT 
 1 AS `proyecto_id`,
 1 AS `titulo`,
 1 AS `estado`,
 1 AS `empresa_nombre`,
 1 AS `desarrollador_nombre`,
 1 AS `ultimo_avance`,
 1 AS `dias_sin_avance`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_proyectos_disponibles`
--

DROP TABLE IF EXISTS `v_proyectos_disponibles`;
/*!50001 DROP VIEW IF EXISTS `v_proyectos_disponibles`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_proyectos_disponibles` AS SELECT 
 1 AS `id`,
 1 AS `titulo`,
 1 AS `descripcion`,
 1 AS `tipo_solucion`,
 1 AS `prioridad`,
 1 AS `fecha_publicacion`,
 1 AS `fecha_limite`,
 1 AS `empresa_nombre`,
 1 AS `nombre_empresa`,
 1 AS `sector`,
 1 AS `num_postulaciones`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_proyectos_en_desarrollo`
--

DROP TABLE IF EXISTS `v_proyectos_en_desarrollo`;
/*!50001 DROP VIEW IF EXISTS `v_proyectos_en_desarrollo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_proyectos_en_desarrollo` AS SELECT 
 1 AS `proyecto_id`,
 1 AS `titulo`,
 1 AS `descripcion`,
 1 AS `tipo_solucion`,
 1 AS `prioridad`,
 1 AS `fecha_publicacion`,
 1 AS `fecha_limite`,
 1 AS `empresa_nombre`,
 1 AS `desarrollador_nombre`,
 1 AS `fecha_inicio`,
 1 AS `fecha_fin_estimada`,
 1 AS `porcentaje_avance`,
 1 AS `ultimo_avance`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_top_desarrolladores`
--

DROP TABLE IF EXISTS `v_top_desarrolladores`;
/*!50001 DROP VIEW IF EXISTS `v_top_desarrolladores`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_top_desarrolladores` AS SELECT 
 1 AS `id`,
 1 AS `nombre`,
 1 AS `programa_formacion`,
 1 AS `calificacion_promedio`,
 1 AS `num_proyectos_completados`,
 1 AS `habilidades`,
 1 AS `proyectos_activos`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `valoraciones`
--

DROP TABLE IF EXISTS `valoraciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `valoraciones` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `proyecto_id` bigint NOT NULL,
  `empresa_id` bigint NOT NULL,
  `desarrollador_id` bigint NOT NULL,
  `puntuacion` tinyint NOT NULL,
  `comentario` text,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_valoracion` (`proyecto_id`),
  KEY `empresa_id` (`empresa_id`),
  KEY `desarrollador_id` (`desarrollador_id`),
  CONSTRAINT `valoraciones_ibfk_1` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `valoraciones_ibfk_2` FOREIGN KEY (`empresa_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `valoraciones_ibfk_3` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_puntuacion` CHECK ((`puntuacion` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `valoraciones`
--

LOCK TABLES `valoraciones` WRITE;
/*!40000 ALTER TABLE `valoraciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `valoraciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dylan`@`localhost`*/ /*!50003 TRIGGER `trg_nueva_valoracion` AFTER INSERT ON `valoraciones` FOR EACH ROW BEGIN
  UPDATE perfil_desarrollador
  SET
    calificacion_promedio = (
      SELECT AVG(puntuacion)
      FROM valoraciones
      WHERE desarrollador_id = NEW.desarrollador_id
    ),
    num_proyectos_completados = (
      SELECT COUNT(*)
      FROM valoraciones
      WHERE desarrollador_id = NEW.desarrollador_id
    )
  WHERE usuario_id = NEW.desarrollador_id;

  UPDATE proyectos SET estado = 'finalizado' WHERE id = NEW.proyecto_id;

  INSERT INTO notificaciones (usuario_id, tipo, mensaje)
  VALUES (
    NEW.desarrollador_id,
    'avance',
    CONCAT('Recibiste una calificación de ', NEW.puntuacion, '/5 estrellas.')
  );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'tem_dbv2'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_actualizar_perfil_desarrollador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_actualizar_perfil_desarrollador`(
  IN p_usuario_id INT,
  IN p_programa_formacion VARCHAR(200),
  IN p_ficha VARCHAR(50),
  IN p_habilidades TEXT
)
BEGIN
  UPDATE perfil_desarrollador
  SET programa_formacion = IFNULL(p_programa_formacion, programa_formacion),
      ficha = IFNULL(p_ficha, ficha),
      habilidades = IFNULL(p_habilidades, habilidades)
  WHERE usuario_id = p_usuario_id;

  INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
  VALUES (p_usuario_id, 'Perfil desarrollador actualizado', 'perfil_desarrollador', p_usuario_id);

  SELECT 'Perfil actualizado correctamente' AS mensaje, TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_actualizar_perfil_empresa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_actualizar_perfil_empresa`(
  IN p_usuario_id INT,
  IN p_nombre_empresa VARCHAR(200),
  IN p_nit VARCHAR(30),
  IN p_sector VARCHAR(100),
  IN p_telefono VARCHAR(20),
  IN p_descripcion TEXT,
  IN p_ciudad VARCHAR(100)
)
BEGIN
  UPDATE perfil_empresa
  SET nombre_empresa = IFNULL(p_nombre_empresa, nombre_empresa),
      nit = IFNULL(p_nit, nit),
      sector = IFNULL(p_sector, sector),
      telefono = IFNULL(p_telefono, telefono),
      descripcion = IFNULL(p_descripcion, descripcion),
      ciudad = IFNULL(p_ciudad, ciudad)
  WHERE usuario_id = p_usuario_id;

  INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
  VALUES (p_usuario_id, 'Perfil empresa actualizado', 'perfil_empresa', p_usuario_id);

  SELECT 'Perfil actualizado correctamente' AS mensaje, TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_aprobar_rechazar_proyecto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_aprobar_rechazar_proyecto`(
  IN p_proyecto_id INT,
  IN p_admin_id    INT,
  IN p_decision    VARCHAR(20)
)
BEGIN
  DECLARE empresa_id_var INT;

  SELECT empresa_id INTO empresa_id_var FROM proyectos WHERE id = p_proyecto_id;

  IF p_decision = 'aprobado' THEN
    UPDATE proyectos
    SET estado = 'publicado', aprobado_por = p_admin_id, fecha_aprobacion = NOW()
    WHERE id = p_proyecto_id;

    INSERT INTO notificaciones (usuario_id, tipo, mensaje)
    VALUES (empresa_id_var, 'aprobacion', 'Tu proyecto fue aprobado y ya está visible para los desarrolladores.');

  ELSE
    UPDATE proyectos SET estado = 'rechazado' WHERE id = p_proyecto_id;

    INSERT INTO notificaciones (usuario_id, tipo, mensaje)
    VALUES (empresa_id_var, 'alerta', 'Tu proyecto fue rechazado. Contáctate con el administrador.');
  END IF;

  INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
  VALUES (p_admin_id, CONCAT('Proyecto ', p_decision), 'proyectos', p_proyecto_id);
  
  SELECT CONCAT('Proyecto ', p_decision, ' correctamente') AS mensaje, TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_asignar_proyecto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_asignar_proyecto`(
  IN p_proyecto_id      INT,
  IN p_desarrollador_id INT,
  IN p_admin_id         INT,
  IN p_fecha_fin        DATE
)
BEGIN
  DECLARE empresa_id_var INT;

  START TRANSACTION;

    SELECT empresa_id INTO empresa_id_var FROM proyectos WHERE id = p_proyecto_id;

    INSERT INTO contrataciones (proyecto_id, desarrollador_id, empresa_id, asignado_por, fecha_inicio, fecha_fin_estimada)
    VALUES (p_proyecto_id, p_desarrollador_id, empresa_id_var, p_admin_id, CURDATE(), p_fecha_fin);

    UPDATE postulaciones SET estado = 'aceptada'
    WHERE proyecto_id = p_proyecto_id AND desarrollador_id = p_desarrollador_id;

    INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
    VALUES (p_admin_id, 'Proyecto asignado a desarrollador', 'contrataciones', LAST_INSERT_ID());

  COMMIT;

  SELECT 'Proyecto asignado correctamente' AS mensaje, TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_calificar_proyecto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_calificar_proyecto`(
  IN p_proyecto_id      INT,
  IN p_empresa_id       INT,
  IN p_desarrollador_id INT,
  IN p_puntuacion       TINYINT,
  IN p_comentario       TEXT
)
BEGIN
  IF p_puntuacion < 1 OR p_puntuacion > 5 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La calificación debe estar entre 1 y 5';
  END IF;

  IF EXISTS (SELECT 1 FROM valoraciones WHERE proyecto_id = p_proyecto_id) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Este proyecto ya fue calificado';
  END IF;

  INSERT INTO valoraciones (proyecto_id, empresa_id, desarrollador_id, puntuacion, comentario)
  VALUES (p_proyecto_id, p_empresa_id, p_desarrollador_id, p_puntuacion, p_comentario);

  SELECT 'Calificación registrada. El perfil del desarrollador fue actualizado.' AS mensaje,
         TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_marcar_notificaciones_leidas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_marcar_notificaciones_leidas`(
  IN p_usuario_id INT,
  IN p_notificacion_ids TEXT   
)
BEGIN
  IF p_notificacion_ids IS NOT NULL AND p_notificacion_ids != '' THEN
    
    UPDATE notificaciones n
    INNER JOIN (
      SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(p_notificacion_ids, ',', numbers.n), ',', -1) AS id
      FROM (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
      WHERE CHAR_LENGTH(p_notificacion_ids) - CHAR_LENGTH(REPLACE(p_notificacion_ids, ',', '')) >= numbers.n - 1
    ) ids ON n.id = ids.id
    SET n.leida = TRUE
    WHERE n.usuario_id = p_usuario_id;
  ELSE
    UPDATE notificaciones SET leida = TRUE WHERE usuario_id = p_usuario_id;
  END IF;

  SELECT ROW_COUNT() AS notificaciones_actualizadas, TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_proyectos_disponibles` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_obtener_proyectos_disponibles`(
  IN p_tipo_solucion VARCHAR(50),
  IN p_prioridad VARCHAR(20),
  IN p_sector VARCHAR(100),
  IN p_limite INT
)
BEGIN
  SELECT 
    p.id,
    p.titulo,
    p.descripcion,
    p.tipo_solucion,
    p.prioridad,
    p.fecha_publicacion,
    p.fecha_limite,
    u.nombre AS empresa_nombre,
    pe.nombre_empresa,
    pe.sector,
    (SELECT COUNT(*) FROM postulaciones WHERE proyecto_id = p.id) AS num_postulaciones
  FROM proyectos p
  INNER JOIN usuarios u ON p.empresa_id = u.id
  LEFT JOIN perfil_empresa pe ON u.id = pe.usuario_id
  WHERE p.estado = 'publicado'
    AND (p.tipo_solucion = IFNULL(p_tipo_solucion, p.tipo_solucion))
    AND (p.prioridad = IFNULL(p_prioridad, p.prioridad))
    AND (pe.sector = IFNULL(p_sector, pe.sector) OR (p_sector IS NULL AND pe.sector IS NULL))
  ORDER BY p.fecha_publicacion DESC
  LIMIT p_limite;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_postularse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_postularse`(
  IN p_proyecto_id      INT,
  IN p_desarrollador_id INT,
  IN p_mensaje          TEXT
)
BEGIN
  DECLARE v_count INT;
  DECLARE v_activos INT;

  
  SELECT COUNT(*) INTO v_count
  FROM postulaciones
  WHERE desarrollador_id = p_desarrollador_id AND estado = 'pendiente';

  
  SELECT COUNT(*) INTO v_activos
  FROM contrataciones
  WHERE desarrollador_id = p_desarrollador_id AND estado = 'activa';

  IF (v_count + v_activos) >= 3 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'No puedes tener más de 3 proyectos activos o postulaciones pendientes simultáneas';
  END IF;

  IF EXISTS (
    SELECT 1 FROM postulaciones
    WHERE proyecto_id = p_proyecto_id AND desarrollador_id = p_desarrollador_id
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Ya te postulaste a este proyecto';
  END IF;

  INSERT INTO postulaciones (proyecto_id, desarrollador_id, mensaje)
  VALUES (p_proyecto_id, p_desarrollador_id, p_mensaje);

  SELECT LAST_INSERT_ID() AS postulacion_id, 
         'Postulación registrada exitosamente' AS mensaje,
         TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_registrar_usuario`(
  IN p_nombre        VARCHAR(150),
  IN p_cedula        VARCHAR(20),
  IN p_email         VARCHAR(150),
  IN p_password      VARCHAR(255),
  IN p_rol           ENUM('empresa','desarrollador','administrador')
)
BEGIN
  IF EXISTS (SELECT 1 FROM usuarios WHERE email = p_email) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo ya está registrado';
  END IF;
  INSERT INTO usuarios (nombre, cedula, email, password, rol, estado, username)
  VALUES (p_nombre, p_cedula, p_email, p_password, p_rol, 'activo', p_email);
  SET @nuevo_id = LAST_INSERT_ID();
  IF p_rol = 'empresa' THEN
    INSERT INTO perfil_empresa (usuario_id) VALUES (@nuevo_id);
  ELSEIF p_rol = 'desarrollador' THEN
    INSERT INTO perfil_desarrollador (usuario_id) VALUES (@nuevo_id);
  END IF;
  SELECT @nuevo_id AS usuario_id, 'Usuario registrado exitosamente' AS mensaje, TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_admin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_reporte_admin`()
BEGIN
  SELECT * FROM v_estadisticas_sistema;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_solicitar_recuperacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_solicitar_recuperacion`(
  IN p_correo VARCHAR(150)
)
BEGIN
  DECLARE token_generado VARCHAR(255);
  DECLARE user_id_var INT;

  SELECT id INTO user_id_var FROM usuarios WHERE correo = p_correo AND estado = 'activo';

  IF user_id_var IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Correo no encontrado';
  END IF;

  SET token_generado = SHA2(CONCAT(p_correo, NOW(), RAND()), 256);

  UPDATE usuarios
  SET token_recuperacion = token_generado,
      token_expiracion   = DATE_ADD(NOW(), INTERVAL 30 MINUTE)
  WHERE id = user_id_var;

  SELECT user_id_var AS usuario_id, 
         token_generado AS token, 
         p_correo AS correo,
         TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_subir_avance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_subir_avance`(
  IN p_proyecto_id      INT,
  IN p_desarrollador_id INT,
  IN p_descripcion      TEXT,
  IN p_archivo_url      VARCHAR(500),
  IN p_porcentaje       TINYINT
)
BEGIN
  IF EXISTS (
    SELECT 1 FROM avances
    WHERE proyecto_id      = p_proyecto_id
      AND desarrollador_id = p_desarrollador_id
      AND DATE(fecha_hora) = CURDATE()
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Solo puedes registrar un avance por día en este proyecto';
  END IF;

  INSERT INTO avances (proyecto_id, desarrollador_id, descripcion, archivo_url, porcentaje)
  VALUES (p_proyecto_id, p_desarrollador_id, p_descripcion, p_archivo_url, p_porcentaje);

  SELECT LAST_INSERT_ID() AS avance_id, 
         'Avance registrado correctamente' AS mensaje,
         TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_toggle_favorito` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_toggle_favorito`(
  IN p_desarrollador_id INT,
  IN p_proyecto_id INT
)
BEGIN
  DECLARE v_existe BOOLEAN;

  SELECT EXISTS(
    SELECT 1 FROM favoritos 
    WHERE desarrollador_id = p_desarrollador_id AND proyecto_id = p_proyecto_id
  ) INTO v_existe;

  IF v_existe THEN
    DELETE FROM favoritos 
    WHERE desarrollador_id = p_desarrollador_id AND proyecto_id = p_proyecto_id;
    
    SELECT 'Proyecto eliminado de favoritos' AS mensaje, FALSE AS es_favorito, TRUE AS success;
  ELSE
    INSERT INTO favoritos (desarrollador_id, proyecto_id)
    VALUES (p_desarrollador_id, p_proyecto_id);
    
    SELECT 'Proyecto agregado a favoritos' AS mensaje, TRUE AS es_favorito, TRUE AS success;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_validar_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dylan`@`localhost` PROCEDURE `sp_validar_login`(
  IN p_email VARCHAR(150),
  IN p_password_ingresada VARCHAR(255),
  IN p_ip_address VARCHAR(45)
)
BEGIN
  DECLARE v_usuario_id INT;
  DECLARE v_hash_almacenado VARCHAR(255);
  SELECT id, password INTO v_usuario_id, v_hash_almacenado
  FROM usuarios 
  WHERE email = p_email AND estado = 'activo';
  IF v_usuario_id IS NULL THEN
    SELECT FALSE AS permitir_login, 'Usuario no encontrado' AS mensaje;
  ELSE
    IF p_password_ingresada = v_hash_almacenado THEN
      UPDATE usuarios SET ultimo_acceso = NOW() WHERE id = v_usuario_id;
      SELECT TRUE AS permitir_login, 'Login exitoso' AS mensaje, v_usuario_id AS usuario_id;
    ELSE
      SELECT FALSE AS permitir_login, 'Contraseña incorrecta' AS mensaje;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_calificacion_desarrolladores`
--

/*!50001 DROP VIEW IF EXISTS `v_calificacion_desarrolladores`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_calificacion_desarrolladores` AS select `valoraciones`.`desarrollador_id` AS `desarrollador_id`,count(0) AS `total_calificaciones`,round(avg(`valoraciones`.`puntuacion`),2) AS `promedio` from `valoraciones` group by `valoraciones`.`desarrollador_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_dashboard_admin`
--

/*!50001 DROP VIEW IF EXISTS `v_dashboard_admin`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_dashboard_admin` AS select (select count(0) from `usuarios`) AS `total_usuarios`,(select count(0) from `usuarios` where (`usuarios`.`rol` = 'empresa')) AS `total_empresas`,(select count(0) from `usuarios` where (`usuarios`.`rol` = 'desarrollador')) AS `total_desarrolladores`,(select count(0) from `proyectos`) AS `total_proyectos`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'publicado')) AS `proyectos_publicados`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'en_desarrollo')) AS `proyectos_en_desarrollo`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'finalizado')) AS `proyectos_finalizados` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_dashboard_desarrollador`
--

/*!50001 DROP VIEW IF EXISTS `v_dashboard_desarrollador`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_dashboard_desarrollador` AS select `u`.`id` AS `desarrollador_id`,`u`.`nombre` AS `nombre`,`pd`.`calificacion_promedio` AS `calificacion_promedio`,`pd`.`num_proyectos_completados` AS `num_proyectos_completados`,(select count(0) from `mensajes` where ((`mensajes`.`receptor_id` = `u`.`id`) and (`mensajes`.`leido` = false))) AS `mensajes_nuevos`,(select count(0) from (`proyectos` `p` join `contrataciones` `c` on((`p`.`id` = `c`.`proyecto_id`))) where ((`c`.`desarrollador_id` = `u`.`id`) and (`p`.`estado` = 'en_desarrollo'))) AS `proyectos_activos`,(select count(0) from `favoritos` where (`favoritos`.`desarrollador_id` = `u`.`id`)) AS `proyectos_favoritos` from (`usuarios` `u` left join `perfil_desarrollador` `pd` on((`u`.`id` = `pd`.`usuario_id`))) where (`u`.`rol` = 'desarrollador') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_dashboard_empresa`
--

/*!50001 DROP VIEW IF EXISTS `v_dashboard_empresa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_dashboard_empresa` AS select `u`.`id` AS `empresa_id`,`u`.`nombre` AS `nombre`,`pe`.`nombre_empresa` AS `nombre_empresa`,(select count(0) from `proyectos` where ((`proyectos`.`empresa_id` = `u`.`id`) and (`proyectos`.`estado` = 'publicado'))) AS `proyectos_publicados`,(select count(0) from `proyectos` where ((`proyectos`.`empresa_id` = `u`.`id`) and (`proyectos`.`estado` = 'en_desarrollo'))) AS `proyectos_activos`,(select count(0) from (`postulaciones` `p` join `proyectos` `pr` on((`p`.`proyecto_id` = `pr`.`id`))) where ((`pr`.`empresa_id` = `u`.`id`) and (`p`.`estado` = 'pendiente'))) AS `postulaciones_pendientes`,(select count(0) from `contrataciones` where ((`contrataciones`.`empresa_id` = `u`.`id`) and (`contrataciones`.`estado` = 'activa'))) AS `desarrolladores_contratados` from (`usuarios` `u` left join `perfil_empresa` `pe` on((`u`.`id` = `pe`.`usuario_id`))) where (`u`.`rol` = 'empresa') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_estadisticas_sistema`
--

/*!50001 DROP VIEW IF EXISTS `v_estadisticas_sistema`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_estadisticas_sistema` AS select (select count(0) from `usuarios` where ((`usuarios`.`rol` = 'empresa') and (`usuarios`.`estado` = 'activo'))) AS `total_empresas_activas`,(select count(0) from `usuarios` where ((`usuarios`.`rol` = 'desarrollador') and (`usuarios`.`estado` = 'activo'))) AS `total_desarrolladores_activos`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'publicado')) AS `proyectos_publicados`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'en_desarrollo')) AS `proyectos_en_desarrollo`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'finalizado')) AS `proyectos_finalizados`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'pendiente_aprobacion')) AS `proyectos_pendientes_aprobacion`,(select count(0) from `postulaciones` where (`postulaciones`.`estado` = 'pendiente')) AS `postulaciones_pendientes`,(select round(avg(`valoraciones`.`puntuacion`),2) from `valoraciones`) AS `calificacion_promedio_global`,(select count(0) from `proyectos` where ((`proyectos`.`estado` = 'en_desarrollo') and exists(select 1 from `avances` `a` where ((`a`.`proyecto_id` = `proyectos`.`id`) and (`a`.`fecha_hora` >= (now() - interval 20 day)))) is false)) AS `proyectos_con_retraso` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_notificaciones_pendientes`
--

/*!50001 DROP VIEW IF EXISTS `v_notificaciones_pendientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_notificaciones_pendientes` AS select `n`.`id` AS `id`,`n`.`usuario_id` AS `usuario_id`,`u`.`nombre` AS `usuario_nombre`,`n`.`tipo` AS `tipo`,`n`.`mensaje` AS `mensaje`,`n`.`fecha` AS `fecha`,timestampdiff(MINUTE,`n`.`fecha`,now()) AS `minutos_desde_creacion` from (`notificaciones` `n` join `usuarios` `u` on((`n`.`usuario_id` = `u`.`id`))) where (`n`.`leida` = false) order by `n`.`fecha` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_portafolio_publico`
--

/*!50001 DROP VIEW IF EXISTS `v_portafolio_publico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_portafolio_publico` AS select `p`.`id` AS `proyecto_id`,`p`.`titulo` AS `titulo`,`p`.`descripcion` AS `descripcion`,`p`.`tipo_solucion` AS `tipo_solucion`,`p`.`fecha_publicacion` AS `fecha_publicacion`,`emp`.`nombre` AS `empresa_nombre`,`pe`.`nombre_empresa` AS `nombre_empresa`,`pe`.`sector` AS `sector`,`dev`.`nombre` AS `desarrollador_nombre`,`pd`.`programa_formacion` AS `programa_formacion`,`pd`.`calificacion_promedio` AS `calificacion_promedio`,`v`.`puntuacion` AS `calificacion_proyecto`,`v`.`comentario` AS `comentario`,`v`.`fecha` AS `fecha_finalizacion` from ((((((`proyectos` `p` join `usuarios` `emp` on((`p`.`empresa_id` = `emp`.`id`))) left join `perfil_empresa` `pe` on((`emp`.`id` = `pe`.`usuario_id`))) join `contrataciones` `c` on((`p`.`id` = `c`.`proyecto_id`))) join `usuarios` `dev` on((`c`.`desarrollador_id` = `dev`.`id`))) left join `perfil_desarrollador` `pd` on((`dev`.`id` = `pd`.`usuario_id`))) left join `valoraciones` `v` on((`p`.`id` = `v`.`proyecto_id`))) where (`p`.`estado` = 'finalizado') order by `v`.`fecha` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_postulaciones_activas`
--

/*!50001 DROP VIEW IF EXISTS `v_postulaciones_activas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_postulaciones_activas` AS select `pos`.`id` AS `id`,`pos`.`proyecto_id` AS `proyecto_id`,`pos`.`desarrollador_id` AS `desarrollador_id`,`pos`.`mensaje` AS `mensaje`,`pos`.`estado` AS `estado`,`pos`.`fecha` AS `fecha`,`u`.`nombre` AS `desarrollador_nombre`,`pd`.`calificacion_promedio` AS `calificacion_promedio`,`pd`.`num_proyectos_completados` AS `num_proyectos_completados`,`pd`.`habilidades` AS `habilidades`,`p`.`titulo` AS `proyecto_titulo`,`emp`.`nombre` AS `empresa_nombre` from ((((`postulaciones` `pos` join `usuarios` `u` on((`pos`.`desarrollador_id` = `u`.`id`))) left join `perfil_desarrollador` `pd` on((`u`.`id` = `pd`.`usuario_id`))) join `proyectos` `p` on((`pos`.`proyecto_id` = `p`.`id`))) join `usuarios` `emp` on((`p`.`empresa_id` = `emp`.`id`))) where (`pos`.`estado` = 'pendiente') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_proyectos_alerta_inactividad`
--

/*!50001 DROP VIEW IF EXISTS `v_proyectos_alerta_inactividad`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_proyectos_alerta_inactividad` AS select `p`.`id` AS `proyecto_id`,`p`.`titulo` AS `titulo`,`p`.`estado` AS `estado`,`emp`.`nombre` AS `empresa_nombre`,`dev`.`nombre` AS `desarrollador_nombre`,(select max(`avances`.`fecha_hora`) from `avances` where (`avances`.`proyecto_id` = `p`.`id`)) AS `ultimo_avance`,(to_days(now()) - to_days((select max(`avances`.`fecha_hora`) from `avances` where (`avances`.`proyecto_id` = `p`.`id`)))) AS `dias_sin_avance` from (((`proyectos` `p` join `contrataciones` `c` on((`p`.`id` = `c`.`proyecto_id`))) join `usuarios` `emp` on((`p`.`empresa_id` = `emp`.`id`))) join `usuarios` `dev` on((`c`.`desarrollador_id` = `dev`.`id`))) where ((`p`.`estado` = 'en_desarrollo') and ((select max(`avances`.`fecha_hora`) from `avances` where (`avances`.`proyecto_id` = `p`.`id`)) < (now() - interval 15 day))) order by (to_days(now()) - to_days((select max(`avances`.`fecha_hora`) from `avances` where (`avances`.`proyecto_id` = `p`.`id`)))) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_proyectos_disponibles`
--

/*!50001 DROP VIEW IF EXISTS `v_proyectos_disponibles`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_proyectos_disponibles` AS select `p`.`id` AS `id`,`p`.`titulo` AS `titulo`,`p`.`descripcion` AS `descripcion`,`p`.`tipo_solucion` AS `tipo_solucion`,`p`.`prioridad` AS `prioridad`,`p`.`fecha_publicacion` AS `fecha_publicacion`,`p`.`fecha_limite` AS `fecha_limite`,`u`.`nombre` AS `empresa_nombre`,`pe`.`nombre_empresa` AS `nombre_empresa`,`pe`.`sector` AS `sector`,(select count(0) from `postulaciones` where (`postulaciones`.`proyecto_id` = `p`.`id`)) AS `num_postulaciones` from ((`proyectos` `p` join `usuarios` `u` on((`p`.`empresa_id` = `u`.`id`))) left join `perfil_empresa` `pe` on((`u`.`id` = `pe`.`usuario_id`))) where (`p`.`estado` = 'publicado') order by `p`.`fecha_publicacion` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_proyectos_en_desarrollo`
--

/*!50001 DROP VIEW IF EXISTS `v_proyectos_en_desarrollo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_proyectos_en_desarrollo` AS select `p`.`id` AS `proyecto_id`,`p`.`titulo` AS `titulo`,`p`.`descripcion` AS `descripcion`,`p`.`tipo_solucion` AS `tipo_solucion`,`p`.`prioridad` AS `prioridad`,`p`.`fecha_publicacion` AS `fecha_publicacion`,`p`.`fecha_limite` AS `fecha_limite`,`emp`.`nombre` AS `empresa_nombre`,`dev`.`nombre` AS `desarrollador_nombre`,`c`.`fecha_inicio` AS `fecha_inicio`,`c`.`fecha_fin_estimada` AS `fecha_fin_estimada`,(select `avances`.`porcentaje` from `avances` where (`avances`.`proyecto_id` = `p`.`id`) order by `avances`.`fecha_hora` desc limit 1) AS `porcentaje_avance`,(select `avances`.`fecha_hora` from `avances` where (`avances`.`proyecto_id` = `p`.`id`) order by `avances`.`fecha_hora` desc limit 1) AS `ultimo_avance` from (((`proyectos` `p` join `contrataciones` `c` on((`p`.`id` = `c`.`proyecto_id`))) join `usuarios` `emp` on((`p`.`empresa_id` = `emp`.`id`))) join `usuarios` `dev` on((`c`.`desarrollador_id` = `dev`.`id`))) where (`p`.`estado` = 'en_desarrollo') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_top_desarrolladores`
--

/*!50001 DROP VIEW IF EXISTS `v_top_desarrolladores`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dylan`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_top_desarrolladores` AS select `u`.`id` AS `id`,`u`.`nombre` AS `nombre`,`pd`.`programa_formacion` AS `programa_formacion`,`pd`.`calificacion_promedio` AS `calificacion_promedio`,`pd`.`num_proyectos_completados` AS `num_proyectos_completados`,`pd`.`habilidades` AS `habilidades`,(select count(0) from (`contrataciones` `c` join `proyectos` `p` on((`c`.`proyecto_id` = `p`.`id`))) where ((`c`.`desarrollador_id` = `u`.`id`) and (`p`.`estado` = 'en_desarrollo'))) AS `proyectos_activos` from (`usuarios` `u` join `perfil_desarrollador` `pd` on((`u`.`id` = `pd`.`usuario_id`))) where ((`u`.`rol` = 'desarrollador') and (`u`.`estado` = 'activo') and (`pd`.`num_proyectos_completados` > 0)) order by `pd`.`calificacion_promedio` desc,`pd`.`num_proyectos_completados` desc limit 10 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-16 19:45:22
