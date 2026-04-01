-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: tem_dbv2
-- ------------------------------------------------------
-- Server version	8.0.45

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
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add usuario',8,'add_usuario'),(22,'Can change usuario',8,'change_usuario'),(23,'Can delete usuario',8,'delete_usuario'),(24,'Can view usuario',8,'view_usuario'),(25,'Can add perfil desarrollador',6,'add_perfildesarrollador'),(26,'Can change perfil desarrollador',6,'change_perfildesarrollador'),(27,'Can delete perfil desarrollador',6,'delete_perfildesarrollador'),(28,'Can view perfil desarrollador',6,'view_perfildesarrollador'),(29,'Can add perfil empresa',7,'add_perfilempresa'),(30,'Can change perfil empresa',7,'change_perfilempresa'),(31,'Can delete perfil empresa',7,'delete_perfilempresa'),(32,'Can view perfil empresa',7,'view_perfilempresa'),(33,'Can add proyecto',11,'add_proyecto'),(34,'Can change proyecto',11,'change_proyecto'),(35,'Can delete proyecto',11,'delete_proyecto'),(36,'Can view proyecto',11,'view_proyecto'),(37,'Can add historial estado proyecto',10,'add_historialestadoproyecto'),(38,'Can change historial estado proyecto',10,'change_historialestadoproyecto'),(39,'Can delete historial estado proyecto',10,'delete_historialestadoproyecto'),(40,'Can view historial estado proyecto',10,'view_historialestadoproyecto'),(41,'Can add valoracion',12,'add_valoracion'),(42,'Can change valoracion',12,'change_valoracion'),(43,'Can delete valoracion',12,'delete_valoracion'),(44,'Can view valoracion',12,'view_valoracion'),(45,'Can add entregable',9,'add_entregable'),(46,'Can change entregable',9,'change_entregable'),(47,'Can delete entregable',9,'delete_entregable'),(48,'Can view entregable',9,'view_entregable'),(49,'Can add postulacion',13,'add_postulacion'),(50,'Can change postulacion',13,'change_postulacion'),(51,'Can delete postulacion',13,'delete_postulacion'),(52,'Can view postulacion',13,'view_postulacion'),(53,'Can add contratacion',14,'add_contratacion'),(54,'Can change contratacion',14,'change_contratacion'),(55,'Can delete contratacion',14,'delete_contratacion'),(56,'Can view contratacion',14,'view_contratacion'),(57,'Can add avance',15,'add_avance'),(58,'Can change avance',15,'change_avance'),(59,'Can delete avance',15,'delete_avance'),(60,'Can view avance',15,'view_avance'),(61,'Can add mensaje',16,'add_mensaje'),(62,'Can change mensaje',16,'change_mensaje'),(63,'Can delete mensaje',16,'delete_mensaje'),(64,'Can view mensaje',16,'view_mensaje'),(65,'Can add notificacion',17,'add_notificacion'),(66,'Can change notificacion',17,'change_notificacion'),(67,'Can delete notificacion',17,'delete_notificacion'),(68,'Can view notificacion',17,'view_notificacion'),(69,'Can add favorito',18,'add_favorito'),(70,'Can change favorito',18,'change_favorito'),(71,'Can delete favorito',18,'delete_favorito'),(72,'Can view favorito',18,'view_favorito'),(73,'Can add copia seguridad',19,'add_copiaseguridad'),(74,'Can change copia seguridad',19,'change_copiaseguridad'),(75,'Can delete copia seguridad',19,'delete_copiaseguridad'),(76,'Can view copia seguridad',19,'view_copiaseguridad'),(77,'Can add log auditoria',20,'add_logauditoria'),(78,'Can change log auditoria',20,'change_logauditoria'),(79,'Can delete log auditoria',20,'delete_logauditoria'),(80,'Can view log auditoria',20,'view_logauditoria'),(81,'Can add equipo',21,'add_equipo'),(82,'Can change equipo',21,'change_equipo'),(83,'Can delete equipo',21,'delete_equipo'),(84,'Can view equipo',21,'view_equipo');
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
  `fecha_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `entregable_id` bigint NOT NULL,
  `comentario_revision` longtext,
  `estado` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `desarrollador_id` (`desarrollador_id`),
  KEY `idx_fecha` (`fecha_hora`),
  KEY `idx_proyecto_fecha` (`proyecto_id`,`fecha_hora`),
  KEY `fk_avances_entregable` (`entregable_id`),
  CONSTRAINT `avances_ibfk_1` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `avances_ibfk_2` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `fk_avances_entregable` FOREIGN KEY (`entregable_id`) REFERENCES `entregables` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avances`
--

LOCK TABLES `avances` WRITE;
/*!40000 ALTER TABLE `avances` DISABLE KEYS */;
/*!40000 ALTER TABLE `avances` ENABLE KEYS */;
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
  `fecha_inicio` date DEFAULT NULL,
  `estado` varchar(10) NOT NULL DEFAULT 'activa',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_proyecto_desarrollador` (`proyecto_id`,`desarrollador_id`),
  KEY `idx_desarrollador` (`desarrollador_id`),
  KEY `idx_empresa` (`empresa_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_proy_dev_est` (`proyecto_id`,`desarrollador_id`,`estado`),
  CONSTRAINT `fk_contrataciones_desarrollador` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_contrataciones_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_contrataciones_proyecto` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contrataciones`
--

LOCK TABLES `contrataciones` WRITE;
/*!40000 ALTER TABLE `contrataciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `contrataciones` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_validar_vacantes_antes_de_contratar` BEFORE INSERT ON `contrataciones` FOR EACH ROW BEGIN
  DECLARE v_vacantes_totales INT;
  DECLARE v_vacantes_ocupadas INT;

  -- 1. Obtener el límite de vacantes del proyecto
  SELECT vacantes INTO v_vacantes_totales FROM proyectos WHERE id = NEW.proyecto_id;

  -- 2. Contar contrataciones activas actuales para este proyecto
  SELECT COUNT(*) INTO v_vacantes_ocupadas FROM contrataciones 
  WHERE proyecto_id = NEW.proyecto_id AND estado = 'activa';

  -- 3. Validar si hay cupo
  IF v_vacantes_ocupadas >= v_vacantes_totales THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Límite de vacantes excedido: El proyecto ya no tiene cupos disponibles.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `copias_seguridad`
--

LOCK TABLES `copias_seguridad` WRITE;
/*!40000 ALTER TABLE `copias_seguridad` DISABLE KEYS */;
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
  CONSTRAINT `fk_admin_log_usuarios` FOREIGN KEY (`user_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
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
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry',NULL),(2,'auth','group',NULL),(3,'auth','permission',NULL),(4,'contenttypes','contenttype',NULL),(5,'sessions','session',NULL),(6,'usuarios','perfildesarrollador',NULL),(7,'usuarios','perfilempresa',NULL),(8,'usuarios','usuario',NULL),(9,'proyectos','entregable',NULL),(10,'proyectos','historialestadoproyecto',NULL),(11,'proyectos','proyecto',NULL),(12,'proyectos','valoracion',NULL),(13,'postulaciones','postulacion',NULL),(14,'contrataciones','contratacion',NULL),(15,'avances','avance',NULL),(16,'mensajes','mensaje',NULL),(17,'notificaciones','notificacion',NULL),(18,'favoritos','favorito',NULL),(19,'logs','copiaseguridad',NULL),(20,'logs','logauditoria',NULL),(21,'proyectos','equipo',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-03-30 21:08:01.850450'),(2,'contenttypes','0002_remove_content_type_name','2026-03-30 21:08:01.865577'),(3,'auth','0001_initial','2026-03-30 21:08:01.871610'),(4,'auth','0002_alter_permission_name_max_length','2026-03-30 21:08:01.875557'),(5,'auth','0003_alter_user_email_max_length','2026-03-30 21:08:01.878600'),(6,'auth','0004_alter_user_username_opts','2026-03-30 21:08:01.882240'),(7,'auth','0005_alter_user_last_login_null','2026-03-30 21:08:01.885798'),(8,'auth','0006_require_contenttypes_0002','2026-03-30 21:08:01.890080'),(9,'auth','0007_alter_validators_add_error_messages','2026-03-30 21:08:01.893043'),(10,'auth','0008_alter_user_username_max_length','2026-03-30 21:08:01.896066'),(11,'auth','0009_alter_user_last_name_max_length','2026-03-30 21:08:01.900484'),(12,'auth','0010_alter_group_name_max_length','2026-03-30 21:08:01.904685'),(13,'auth','0011_update_proxy_permissions','2026-03-30 21:08:01.908813'),(14,'auth','0012_alter_user_first_name_max_length','2026-03-30 21:08:01.912379'),(15,'usuarios','0001_initial','2026-03-30 21:08:01.916725'),(16,'admin','0001_initial','2026-03-30 21:08:01.920163'),(17,'admin','0002_logentry_remove_auto_add','2026-03-30 21:08:01.923665'),(18,'admin','0003_logentry_add_action_flag_choices','2026-03-30 21:08:01.926597'),(19,'proyectos','0001_initial','2026-03-30 21:08:01.930026'),(20,'avances','0001_initial','2026-03-30 21:08:01.933183'),(21,'avances','0002_alter_avance_table','2026-03-30 21:08:01.936463'),(22,'avances','0003_alter_avance_archivo_url_alter_avance_table','2026-03-30 21:08:01.940269'),(23,'proyectos','0002_proyecto_vacantes_alter_proyecto_estado_and_more','2026-03-30 21:08:01.943805'),(24,'contrataciones','0001_initial','2026-03-30 21:08:01.947991'),(25,'contrataciones','0002_alter_contratacion_proyecto','2026-03-30 21:08:01.951555'),(26,'contrataciones','0003_alter_contratacion_table','2026-03-30 21:08:01.955244'),(27,'contrataciones','0004_alter_contratacion_table','2026-03-30 21:08:01.958493'),(28,'favoritos','0001_initial','2026-03-30 21:08:01.961658'),(29,'favoritos','0002_alter_favorito_table','2026-03-30 21:08:01.965134'),(30,'favoritos','0003_alter_favorito_table','2026-03-30 21:08:01.968927'),(31,'logs','0001_initial','2026-03-30 21:08:01.973052'),(32,'logs','0002_alter_copiaseguridad_table_alter_logauditoria_table','2026-03-30 21:08:01.976126'),(33,'logs','0003_alter_logauditoria_registro_id_and_more','2026-03-30 21:08:01.980179'),(34,'logs','0004_alter_copiaseguridad_ejecutado_por','2026-03-30 21:08:01.983678'),(35,'proyectos','0003_alter_historialestadoproyecto_table_and_more','2026-03-30 21:08:01.987191'),(36,'proyectos','0004_valoracion_rol_evaluador_and_more','2026-03-30 21:08:01.991480'),(37,'mensajes','0001_initial','2026-03-30 21:08:01.994937'),(38,'mensajes','0002_alter_mensaje_table','2026-03-30 21:08:01.998462'),(39,'mensajes','0003_alter_mensaje_proyecto_alter_mensaje_table','2026-03-30 21:08:02.002100'),(40,'mensajes','0004_alter_mensaje_receptor','2026-03-30 21:08:02.005519'),(41,'notificaciones','0001_initial','2026-03-30 21:08:02.010277'),(42,'notificaciones','0002_alter_notificacion_table','2026-03-30 21:08:02.014643'),(43,'notificaciones','0003_alter_notificacion_options_and_more','2026-03-30 21:08:02.018718'),(44,'postulaciones','0001_initial','2026-03-30 21:08:02.022416'),(45,'postulaciones','0002_alter_postulacion_table','2026-03-30 21:08:02.026082'),(46,'postulaciones','0003_alter_postulacion_table','2026-03-30 21:08:02.029450'),(47,'proyectos','0005_alter_historialestadoproyecto_cambiado_por_and_more','2026-03-30 21:08:02.033149'),(48,'proyectos','0006_alter_valoracion_unique_together','2026-03-30 21:08:02.037200'),(49,'sessions','0001_initial','2026-03-30 21:08:02.041092'),(50,'usuarios','0002_usuario_fecha_nacimiento_and_more','2026-03-30 21:08:02.044676'),(51,'usuarios','0003_alter_usuario_options_usuario_nombre_and_more','2026-03-30 21:08:02.048467'),(52,'usuarios','0004_alter_usuario_options_usuario_nombre_and_more','2026-03-30 21:08:02.052183'),(53,'proyectos','0007_alter_historialestadoproyecto_estado_anterior_and_more','2026-03-30 21:40:37.286334'),(54,'avances','0004_remove_avance_porcentaje_avance_entregable','2026-03-30 21:43:22.648896'),(55,'avances','0005_avance_comentario_revision_avance_estado','2026-03-30 22:03:41.990741'),(56,'proyectos','0008_alter_entregable_estado_equipo_entregable_equipo','2026-03-30 22:23:13.670025'),(57,'usuarios','0005_rename_cedula_usuario_identificacion_and_more','2026-03-31 04:53:12.560312'),(58,'usuarios','0006_remove_usuario_fecha_registro_and_more','2026-03-31 05:12:38.014439'),(59,'usuarios','0007_remove_usuario_bloqueado_hasta_and_more','2026-03-31 05:45:14.469818'),(60,'proyectos','0009_remove_proyecto_aprobado_por_and_more','2026-03-31 05:53:37.204320'),(61,'usuarios','0008_remove_usuario_first_name_remove_usuario_last_name','2026-03-31 06:00:25.639612'),(62,'contrataciones','0005_alter_contratacion_estado_and_more','2026-03-31 06:10:15.869458'),(63,'contrataciones','0006_remove_contratacion_asignado_por','2026-03-31 06:15:52.256973'),(64,'avances','0006_alter_avance_entregable','2026-03-31 06:47:19.745048'),(65,'proyectos','0010_alter_valoracion_puntuacion','2026-03-31 06:59:31.665278'),(66,'avances','0007_alter_avance_entregable','2026-03-31 19:29:41.291749'),(67,'contrataciones','0007_remove_contratacion_fecha_fin_estimada','2026-03-31 19:29:41.312622'),(68,'logs','0005_remove_logauditoria_ip_address','2026-03-31 19:29:41.316838'),(69,'mensajes','0005_rename_cuerpo_mensaje_contenido_and_more','2026-03-31 19:29:41.320243'),(70,'notificaciones','0004_notificacion_proyecto','2026-03-31 19:29:41.323450'),(71,'postulaciones','0004_alter_postulacion_estado','2026-03-31 19:29:41.326890'),(72,'usuarios','0009_remove_perfilempresa_nit','2026-03-31 19:29:41.330324');
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
-- Table structure for table `entregables`
--

DROP TABLE IF EXISTS `entregables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entregables` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `titulo` varchar(200) NOT NULL,
  `descripcion` longtext,
  `estado` varchar(20) NOT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `proyecto_id` bigint NOT NULL,
  `equipo_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entregables_proyecto_id_950be557_fk_proyectos_id` (`proyecto_id`),
  KEY `entregables_equipo_id_4cceddef_fk_equipos_id` (`equipo_id`),
  KEY `idx_entregables_estado` (`estado`),
  KEY `idx_entregables_fecha` (`fecha_creacion`),
  CONSTRAINT `entregables_equipo_id_4cceddef_fk_equipos_id` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`),
  CONSTRAINT `entregables_proyecto_id_950be557_fk_proyectos_id` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entregables`
--

LOCK TABLES `entregables` WRITE;
/*!40000 ALTER TABLE `entregables` DISABLE KEYS */;
/*!40000 ALTER TABLE `entregables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipos`
--

DROP TABLE IF EXISTS `equipos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `fecha_creacion` datetime(6) NOT NULL,
  `proyecto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_equipos_proyecto` (`proyecto_id`),
  CONSTRAINT `fk_equipos_proyecto` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipos`
--

LOCK TABLES `equipos` WRITE;
/*!40000 ALTER TABLE `equipos` DISABLE KEYS */;
/*!40000 ALTER TABLE `equipos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipos_miembros`
--

DROP TABLE IF EXISTS `equipos_miembros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipos_miembros` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `equipo_id` bigint NOT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `equipos_miembros_equipo_id_usuario_id_f9af3905_uniq` (`equipo_id`,`usuario_id`),
  KEY `fk_miembros_usuario` (`usuario_id`),
  CONSTRAINT `fk_miembros_equipo` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_miembros_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipos_miembros`
--

LOCK TABLES `equipos_miembros` WRITE;
/*!40000 ALTER TABLE `equipos_miembros` DISABLE KEYS */;
/*!40000 ALTER TABLE `equipos_miembros` ENABLE KEYS */;
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
-- Table structure for table `mensajes`
--

DROP TABLE IF EXISTS `mensajes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mensajes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `remitente_id` bigint NOT NULL,
  `receptor_id` bigint DEFAULT NULL,
  `proyecto_id` bigint DEFAULT NULL,
  `titulo` varchar(200) DEFAULT NULL,
  `contenido` text NOT NULL,
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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_notificacion_mensaje` AFTER INSERT ON `mensajes` FOR EACH ROW BEGIN
  DECLARE v_nombre_remitente VARCHAR(150);
  SELECT nombre INTO v_nombre_remitente FROM usuarios WHERE id = NEW.remitente_id;

  IF NEW.receptor_id IS NOT NULL THEN
    INSERT INTO notificaciones (usuario_id, proyecto_id, tipo, mensaje)
    VALUES (
      NEW.receptor_id,
      NEW.proyecto_id,
      'mensaje',
      CONCAT(v_nombre_remitente, ' te ha enviado un nuevo mensaje.')
    );
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
  `proyecto_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_usuario_leida` (`usuario_id`,`leida`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_fecha` (`fecha`),
  KEY `idx_user_read_date` (`usuario_id`,`leida`,`fecha` DESC),
  KEY `fk_notificaciones_proyecto` (`proyecto_id`),
  CONSTRAINT `fk_notificaciones_proyecto` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil_desarrollador`
--

LOCK TABLES `perfil_desarrollador` WRITE;
/*!40000 ALTER TABLE `perfil_desarrollador` DISABLE KEYS */;
INSERT INTO `perfil_desarrollador` VALUES (1,3,'ADSO','21232324241','SOlo python',4.00,2);
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
  `sector` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `descripcion` text,
  `ciudad` varchar(100) DEFAULT NULL,
  `calificacion_promedio` decimal(3,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  KEY `idx_sector` (`sector`),
  KEY `idx_ciudad` (`ciudad`),
  CONSTRAINT `perfil_empresa_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil_empresa`
--

LOCK TABLES `perfil_empresa` WRITE;
/*!40000 ALTER TABLE `perfil_empresa` DISABLE KEYS */;
INSERT INTO `perfil_empresa` VALUES (1,2,'Pepsico','Tecnología','3233801021','La mejor empresa de tecnologia','MEdellin',1.00);
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
  KEY `idx_proy_est_fecha` (`proyecto_id`,`estado`,`fecha`),
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_nueva_postulacion` AFTER INSERT ON `postulaciones` FOR EACH ROW BEGIN
  DECLARE v_empresa_id BIGINT;
  DECLARE v_nombre_dev VARCHAR(150);
  DECLARE v_titulo_proy VARCHAR(200);

  SELECT empresa_id, titulo INTO v_empresa_id, v_titulo_proy FROM proyectos WHERE id = NEW.proyecto_id;
  SELECT COALESCE(nombre, username) INTO v_nombre_dev FROM usuarios WHERE id = NEW.desarrollador_id;

  INSERT INTO notificaciones (usuario_id, proyecto_id, tipo, mensaje)
  VALUES (
    v_empresa_id,
    NEW.proyecto_id,
    'postulacion',
    CONCAT(v_nombre_dev, ' se ha postulado a tu proyecto: ', v_titulo_proy)
  );

  INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
  VALUES (NEW.desarrollador_id, 'Nueva postulacion registrada', 'postulaciones', NEW.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
  PRIMARY KEY (`id`),
  KEY `idx_empresa_id` (`empresa_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_fecha_publicacion` (`fecha_publicacion`),
  KEY `idx_estado_fecha` (`estado`,`fecha_publicacion`),
  KEY `idx_proy_tipo` (`tipo_solucion`),
  KEY `idx_proy_prio` (`prioridad`),
  FULLTEXT KEY `ft_busqueda_proyectos` (`titulo`,`descripcion`),
  CONSTRAINT `proyectos_ibfk_1` FOREIGN KEY (`empresa_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `check_vacantes_positivas` CHECK ((`vacantes` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_actualizar_proyectos_completados` AFTER UPDATE ON `proyectos` FOR EACH ROW BEGIN
    -- Detectar cuando el proyecto pasa a estado 'finalizado'
    IF OLD.estado != 'finalizado' AND NEW.estado = 'finalizado' THEN
        -- Incrementar el contador para todos los desarrolladores que terminaron el proyecto con contrato activo
        UPDATE perfil_desarrollador 
        SET num_proyectos_completados = num_proyectos_completados + 1
        WHERE usuario_id IN (
            SELECT desarrollador_id 
            FROM contrataciones 
            WHERE proyecto_id = NEW.id AND estado = 'finalizada'
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
  `identificacion` varchar(20) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('empresa','desarrollador','administrador') NOT NULL,
  `estado` enum('activo','inactivo','suspendido') DEFAULT 'activo',
  `token_recuperacion` varchar(255) DEFAULT NULL,
  `token_expiracion` datetime DEFAULT NULL,
  `intentos_fallidos` tinyint DEFAULT '0',
  `is_superuser` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `date_joined` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `correo` (`email`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `cedula` (`identificacion`),
  KEY `idx_rol` (`rol`),
  KEY `idx_estado` (`estado`),
  KEY `idx_user_rol_est` (`rol`,`estado`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'admin_master','Admin Master',NULL,NULL,'admin@tem.com','pbkdf2_sha256$1200000$kJ4MmqW9gQrKXwUixhjgMJ$PHeLMLggWqeUarePItNuB4YGyqksc7/9nyQFcZ8vnhQ=','administrador','activo','869edb810fa7f54ab2089916b2597584','2026-04-01 05:27:30',0,1,1,'2026-03-29 00:52:09','2026-04-01 21:33:52'),(2,'empresa_tech','Tech Corp SAS',NULL,NULL,'contacto@techcorp.com','pbkdf2_sha256$1200000$s2MSdDRGR9t4E4gfcZE2Js$3TQYfJoJ6RUDIpOzz4gQGl3VexPKKTEG+i0F8Nq35ZU=','empresa','activo',NULL,NULL,0,0,1,'2026-03-29 00:52:10','2026-04-01 22:33:06'),(3,'dev_expert','Juan Desarrollador',NULL,NULL,'dev@pro.com','pbkdf2_sha256$1200000$lRdby9qIK5Nv5Abl0xLDLN$pmH5D6I7Tvux2x2E/CxSFfHcAIMh7NvcRMFnCsLA0YQ=','desarrollador','activo',NULL,NULL,0,0,1,'2026-03-29 00:52:11','2026-04-01 22:28:29');
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_log_nuevo_usuario` AFTER INSERT ON `usuarios` FOR EACH ROW BEGIN
    INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
    VALUES (
        NEW.id, 
        CONCAT('Nueva cuenta creada - Rol: ', NEW.rol), 
        'usuarios', 
        NEW.id
    );
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_registro_sesion` BEFORE UPDATE ON `usuarios` FOR EACH ROW BEGIN
  -- Escuchamos el cambio en last_login (columna estándar de Django)
  IF NEW.last_login IS NOT NULL AND 
     (OLD.last_login IS NULL OR OLD.last_login != NEW.last_login) THEN
    INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
    VALUES (NEW.id, 'Inicio de sesión registrado (last_login)', 'usuarios', NEW.id);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_log_usuario_modificado` AFTER UPDATE ON `usuarios` FOR EACH ROW BEGIN
  IF OLD.estado != NEW.estado THEN
    INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
    VALUES (
      NEW.id,
      CONCAT('Cambio de estado: ', OLD.estado, ' -> ', NEW.estado),
      'usuarios',
      NEW.id
    );
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuarios_groups`
--

DROP TABLE IF EXISTS `usuarios_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `group_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuarios_usuario_groups_usuario_id_group_id_4ed5b09e_uniq` (`usuario_id`,`group_id`),
  KEY `usuarios_usuario_groups_group_id_e77f6dcf_fk_auth_group_id` (`group_id`),
  CONSTRAINT `fk_usuarios_groups_real` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `usuarios_usuario_groups_group_id_e77f6dcf_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_groups`
--

LOCK TABLES `usuarios_groups` WRITE;
/*!40000 ALTER TABLE `usuarios_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_user_permissions`
--

DROP TABLE IF EXISTS `usuarios_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `permission_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuarios_usuario_user_pe_usuario_id_permission_id_217cadcd_uniq` (`usuario_id`,`permission_id`),
  KEY `usuarios_usuario_use_permission_id_4e5c0f2f_fk_auth_perm` (`permission_id`),
  CONSTRAINT `fk_usuarios_permissions_real` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `usuarios_usuario_use_permission_id_4e5c0f2f_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_user_permissions`
--

LOCK TABLES `usuarios_user_permissions` WRITE;
/*!40000 ALTER TABLE `usuarios_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios_user_permissions` ENABLE KEYS */;
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
 1 AS `proyectos_activos`,
 1 AS `proyectos_favoritos`,
 1 AS `notificaciones_pendientes`*/;
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
 1 AS `empresa_reputacion`,
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
 1 AS `desarrolladores_nombres`,
 1 AS `fecha_inicio`,
 1 AS `hitos_completados`,
 1 AS `hitos_totales`,
 1 AS `ultimo_avance`,
 1 AS `desarrolladores_ids`,
 1 AS `empresa_id`,
 1 AS `estado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_reputacion_empresas`
--

DROP TABLE IF EXISTS `v_reputacion_empresas`;
/*!50001 DROP VIEW IF EXISTS `v_reputacion_empresas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_reputacion_empresas` AS SELECT 
 1 AS `usuario_id`,
 1 AS `nombre_usuario`,
 1 AS `nombre_empresa`,
 1 AS `sector`,
 1 AS `total_evaluaciones`,
 1 AS `promedio_reputacion`*/;
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
 1 AS `ficha`,
 1 AS `habilidades`,
 1 AS `calificacion_promedio`,
 1 AS `num_proyectos_completados`*/;
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
  `rol_evaluador` enum('empresa','desarrollador') DEFAULT 'empresa',
  `puntuacion` tinyint NOT NULL,
  `comentario` text,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_valoracion_unica` (`proyecto_id`,`desarrollador_id`,`rol_evaluador`),
  KEY `empresa_id` (`empresa_id`),
  KEY `desarrollador_id` (`desarrollador_id`),
  CONSTRAINT `valoraciones_ibfk_1` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `valoraciones_ibfk_2` FOREIGN KEY (`empresa_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `valoraciones_ibfk_3` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `check_puntuacion_rango` CHECK (((`puntuacion` >= 1) and (`puntuacion` <= 5))),
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

--
-- Dumping routines for database 'tem_dbv2'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_aceptar_postulacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_aceptar_postulacion`(
    IN p_postulacion_id BIGINT,
    IN p_empresa_id BIGINT
)
BEGIN
    DECLARE v_proyecto_id BIGINT;
    DECLARE v_desarrollador_id BIGINT;
    DECLARE v_vacantes_totales INT;
    DECLARE v_vacantes_ocupadas INT;
    DECLARE v_titulo_proyecto VARCHAR(200);
    DECLARE v_nombre_desarrollador VARCHAR(200);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- 1. Obtener datos básicos y BLOQUEAR la fila de la postulación
    SELECT proyecto_id, desarrollador_id INTO v_proyecto_id, v_desarrollador_id
    FROM postulaciones WHERE id = p_postulacion_id FOR UPDATE;

    -- 2. BLOQUEAR el proyecto para asegurar conteo de vacantes exacto
    SELECT titulo, vacantes INTO v_titulo_proyecto, v_vacantes_totales
    FROM proyectos WHERE id = v_proyecto_id AND empresa_id = p_empresa_id FOR UPDATE;

    IF v_titulo_proyecto IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Proyecto no encontrado o no pertenece a la empresa.';
    END IF;

    -- 3. Contar vacantes ocupadas
    SELECT COUNT(*) INTO v_vacantes_ocupadas 
    FROM contrataciones WHERE proyecto_id = v_proyecto_id AND estado = 'activa';

    IF v_vacantes_ocupadas >= v_vacantes_totales THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Límite de vacantes alcanzado para este proyecto.';
    END IF;

    -- 4. Aceptar postulación
    UPDATE postulaciones SET estado = 'aceptada' WHERE id = p_postulacion_id;

    -- 5. Crear Contratación
    INSERT INTO contrataciones (proyecto_id, desarrollador_id, empresa_id, fecha_inicio, estado)
    VALUES (v_proyecto_id, v_desarrollador_id, p_empresa_id, CURDATE(), 'activa');

    -- 6. Notificar al desarrollador aceptado
    INSERT INTO notificaciones (usuario_id, proyecto_id, tipo, mensaje, fecha)
    VALUES (v_desarrollador_id, v_proyecto_id, 'aprobacion', 
            CONCAT('¡Felicidades! Has sido contratado para el proyecto: ', v_titulo_proyecto), NOW());

    -- 7. Verificar si se llenaron las vacantes
    IF (v_vacantes_ocupadas + 1) >= v_vacantes_totales THEN
        -- Cerrar proyecto
        UPDATE proyectos SET estado = 'en_desarrollo' WHERE id = v_proyecto_id;

        -- Rechazar postulaciones pendientes sobrantes
        UPDATE postulaciones SET estado = 'rechazada' 
        WHERE proyecto_id = v_proyecto_id AND estado = 'pendiente';

        -- Notificar a los rechazados
        INSERT INTO notificaciones (usuario_id, proyecto_id, tipo, mensaje, fecha)
        SELECT desarrollador_id, v_proyecto_id, 'postulacion', 
               CONCAT('El proyecto ''', v_titulo_proyecto, ''' ha completado sus vacantes. Tu postulación ha sido cerrada.'), NOW()
        FROM postulaciones WHERE proyecto_id = v_proyecto_id AND estado = 'rechazada' AND id != p_postulacion_id;
    END IF;

    COMMIT;
    
    SELECT 'Postulación aceptada y contrato creado exitosamente' AS mensaje, TRUE AS success;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_calificar_proyecto`(
  IN p_proyecto_id      INT,
  IN p_evaluador_id     INT,
  IN p_evaluado_id      INT,
  IN p_puntuacion       TINYINT,
  IN p_comentario       TEXT,
  IN p_rol_evaluador    ENUM('empresa', 'desarrollador')
)
BEGIN
    IF p_puntuacion < 1 OR p_puntuacion > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La calificación debe estar entre 1 y 5';
    END IF;

    -- Validar que no se repita la calificación para el mismo objetivo en el mismo proyecto
    IF EXISTS (
        SELECT 1 FROM valoraciones 
        WHERE proyecto_id = p_proyecto_id 
          AND desarrollador_id = IF(p_rol_evaluador = 'empresa', p_evaluado_id, p_evaluador_id)
          AND rol_evaluador = p_rol_evaluador
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya has realizado esta calificación';
    END IF;

    IF p_rol_evaluador = 'empresa' THEN
        INSERT INTO valoraciones (proyecto_id, empresa_id, desarrollador_id, puntuacion, comentario, rol_evaluador)
        VALUES (p_proyecto_id, p_evaluador_id, p_evaluado_id, p_puntuacion, p_comentario, 'empresa');
    ELSE
        INSERT INTO valoraciones (proyecto_id, empresa_id, desarrollador_id, puntuacion, comentario, rol_evaluador)
        VALUES (p_proyecto_id, p_evaluado_id, p_evaluador_id, p_puntuacion, p_comentario, 'desarrollador');
    END IF;

    -- ELIMINADO: UPDATE proyectos SET estado = 'finalizado'... 
    -- El cierre lo manejará Django al terminar la lista de desarrolladores.

    SELECT 'Calificación registrada exitosamente' AS mensaje, TRUE AS success;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cancelar_contratacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cancelar_contratacion`(
  IN p_contratacion_id BIGINT,
  IN p_empresa_id BIGINT
)
BEGIN
  DECLARE v_proyecto_id BIGINT;
  DECLARE v_estado_actual VARCHAR(25);
  DECLARE v_vacantes_totales INT;
  DECLARE v_vacantes_ocupadas INT;

  -- 1. Buscar la contratación y el estado del proyecto
  SELECT c.proyecto_id, p.estado, p.vacantes 
  INTO v_proyecto_id, v_estado_actual, v_vacantes_totales
  FROM contrataciones c
  JOIN proyectos p ON c.proyecto_id = p.id
  WHERE c.id = p_contratacion_id AND c.empresa_id = p_empresa_id AND c.estado = 'activa';

  IF v_proyecto_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Contratación no encontrada, ya cancelada o el proyecto no existe.';
  END IF;

  START TRANSACTION;

    -- 2. Marcar contratación como cancelada
    UPDATE contrataciones SET estado = 'cancelada' WHERE id = p_contratacion_id;

    -- 3. Recalcular vacantes ocupadas
    SELECT COUNT(*) INTO v_vacantes_ocupadas FROM contrataciones 
    WHERE proyecto_id = v_proyecto_id AND estado = 'activa';

    -- 4. Lógica Inteligente de Estado del Proyecto
    -- Solo pasamos a 'publicado' si NO estaba 'inactivo' o 'suspendido' o 'finalizado'
    IF v_estado_actual NOT IN ('inactivo', 'suspendido', 'finalizado', 'cancelado') THEN
      IF v_vacantes_ocupadas < v_vacantes_totales THEN
        UPDATE proyectos SET estado = 'publicado' WHERE id = v_proyecto_id;
      END IF;
    END IF;

    -- 5. Auditoría
    INSERT INTO logs_auditoria (usuario_id, accion, tabla_afectada, registro_id)
    VALUES (p_empresa_id, CONCAT('Contrato cancelado (ID: ', p_contratacion_id, ')'), 'contrataciones', p_contratacion_id);

  COMMIT;

  SELECT TRUE AS success, 
         CONCAT('Contratación cancelada. Vacantes ocupadas: ', v_vacantes_ocupadas, '/', v_vacantes_totales) AS mensaje;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_marcar_notificaciones_leidas`(IN p_usuario_id BIGINT)
BEGIN
  UPDATE notificaciones SET leida = 1 WHERE usuario_id = p_usuario_id;
  SELECT 'Notificaciones marcadas como leídas' AS mensaje, TRUE AS success;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_postularse`(
  IN p_proyecto_id      BIGINT,
  IN p_desarrollador_id BIGINT,
  IN p_mensaje          TEXT
)
BEGIN
  DECLARE v_count INT;
  DECLARE v_activos INT;
  SELECT COUNT(*) INTO v_count FROM postulaciones WHERE desarrollador_id = p_desarrollador_id AND estado = 'pendiente';
  SELECT COUNT(*) INTO v_activos FROM contrataciones WHERE desarrollador_id = p_desarrollador_id AND estado = 'activa';
  IF (v_count + v_activos) >= 3 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Límite alcanzado: No puedes tener más de 3 postulaciones o proyectos activos.';
  END IF;
  IF EXISTS (SELECT 1 FROM postulaciones WHERE proyecto_id = p_proyecto_id AND desarrollador_id = p_desarrollador_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya te has postulado a este proyecto anteriormente.';
  END IF;
  INSERT INTO postulaciones (proyecto_id, desarrollador_id, mensaje) VALUES (p_proyecto_id, p_desarrollador_id, p_mensaje);
  SELECT LAST_INSERT_ID() AS postulacion_id, 'Postulación registrada exitosamente' AS mensaje, TRUE AS success;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_admin`()
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_recuperacion`(IN p_email VARCHAR(150))
BEGIN
  IF EXISTS (SELECT 1 FROM usuarios WHERE email = p_email) THEN
    UPDATE usuarios SET token_recuperacion = MD5(NOW()), token_expiracion = DATE_ADD(NOW(), INTERVAL 1 HOUR) WHERE email = p_email;
    SELECT 'Token generado' AS mensaje, TRUE AS success;
  ELSE
    SELECT 'Correo no encontrado' AS mensaje, FALSE AS success;
  END IF;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_toggle_favorito`(
  IN p_desarrollador_id BIGINT,
  IN p_proyecto_id BIGINT
)
BEGIN
  DECLARE v_existe BOOLEAN;
  SELECT EXISTS(SELECT 1 FROM favoritos WHERE desarrollador_id = p_desarrollador_id AND proyecto_id = p_proyecto_id) INTO v_existe;
  IF v_existe THEN
    DELETE FROM favoritos WHERE desarrollador_id = p_desarrollador_id AND proyecto_id = p_proyecto_id;
    SELECT 'Proyecto eliminado de favoritos' AS mensaje, FALSE AS es_favorito, TRUE AS success;
  ELSE
    INSERT INTO favoritos (desarrollador_id, proyecto_id) VALUES (p_desarrollador_id, p_proyecto_id);
    SELECT 'Proyecto agregado a favoritos' AS mensaje, TRUE AS es_favorito, TRUE AS success;
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
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_calificacion_desarrolladores` AS select `valoraciones`.`desarrollador_id` AS `desarrollador_id`,count(`valoraciones`.`id`) AS `total_calificaciones`,round(avg(`valoraciones`.`puntuacion`),2) AS `promedio` from `valoraciones` where (`valoraciones`.`rol_evaluador` = 'empresa') group by `valoraciones`.`desarrollador_id` */;
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_dashboard_desarrollador` AS select `u`.`id` AS `desarrollador_id`,`u`.`nombre` AS `nombre`,coalesce(`vc`.`promedio`,0.00) AS `calificacion_promedio`,(select count(0) from `contrataciones` where ((`contrataciones`.`desarrollador_id` = `u`.`id`) and (`contrataciones`.`estado` = 'finalizada'))) AS `num_proyectos_completados`,(select count(0) from `contrataciones` where ((`contrataciones`.`desarrollador_id` = `u`.`id`) and (`contrataciones`.`estado` = 'activa'))) AS `proyectos_activos`,(select count(0) from `favoritos` where (`favoritos`.`desarrollador_id` = `u`.`id`)) AS `proyectos_favoritos`,(select count(0) from `notificaciones` where ((`notificaciones`.`usuario_id` = `u`.`id`) and (`notificaciones`.`leida` = false))) AS `notificaciones_pendientes` from (`usuarios` `u` left join `v_calificacion_desarrolladores` `vc` on((`u`.`id` = `vc`.`desarrollador_id`))) where (`u`.`rol` = 'desarrollador') */;
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_estadisticas_sistema` AS select (select count(0) from `usuarios` where ((`usuarios`.`rol` = 'empresa') and (`usuarios`.`estado` = 'activo'))) AS `total_empresas_activas`,(select count(0) from `usuarios` where ((`usuarios`.`rol` = 'desarrollador') and (`usuarios`.`estado` = 'activo'))) AS `total_desarrolladores_activos`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'publicado')) AS `proyectos_publicados`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'en_desarrollo')) AS `proyectos_en_desarrollo`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'finalizado')) AS `proyectos_finalizados`,(select count(0) from `proyectos` where (`proyectos`.`estado` = 'pendiente_aprobacion')) AS `proyectos_pendientes_aprobacion`,(select count(0) from (`postulaciones` `pos` join `proyectos` `p` on((`pos`.`proyecto_id` = `p`.`id`))) where ((`pos`.`estado` = 'pendiente') and (`p`.`estado` = 'publicado'))) AS `postulaciones_pendientes`,(select round(avg(`valoraciones`.`puntuacion`),2) from `valoraciones`) AS `calificacion_promedio_global`,(select count(0) from `proyectos` `p` where ((`p`.`estado` = 'en_desarrollo') and exists(select 1 from `avances` `a` where ((`a`.`proyecto_id` = `p`.`id`) and (`a`.`fecha_hora` >= (now() - interval 20 day)))) is false)) AS `proyectos_con_retraso` */;
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_proyectos_disponibles` AS select `p`.`id` AS `id`,`p`.`titulo` AS `titulo`,`p`.`descripcion` AS `descripcion`,`p`.`tipo_solucion` AS `tipo_solucion`,`p`.`prioridad` AS `prioridad`,`p`.`fecha_publicacion` AS `fecha_publicacion`,`p`.`fecha_limite` AS `fecha_limite`,`u`.`nombre` AS `empresa_nombre`,`pe`.`nombre_empresa` AS `nombre_empresa`,`pe`.`sector` AS `sector`,coalesce(`vr`.`promedio_reputacion`,0.00) AS `empresa_reputacion`,(select count(0) from `postulaciones` where (`postulaciones`.`proyecto_id` = `p`.`id`)) AS `num_postulaciones` from (((`proyectos` `p` join `usuarios` `u` on((`p`.`empresa_id` = `u`.`id`))) left join `perfil_empresa` `pe` on((`u`.`id` = `pe`.`usuario_id`))) left join `v_reputacion_empresas` `vr` on((`u`.`id` = `vr`.`usuario_id`))) where (`p`.`estado` = 'publicado') order by `p`.`fecha_publicacion` desc */;
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_proyectos_en_desarrollo` AS select `p`.`id` AS `proyecto_id`,`p`.`titulo` AS `titulo`,`p`.`descripcion` AS `descripcion`,`p`.`tipo_solucion` AS `tipo_solucion`,`p`.`prioridad` AS `prioridad`,`p`.`fecha_publicacion` AS `fecha_publicacion`,`p`.`fecha_limite` AS `fecha_limite`,`emp`.`nombre` AS `empresa_nombre`,group_concat(distinct `dev`.`nombre` separator ', ') AS `desarrolladores_nombres`,min(`c`.`fecha_inicio`) AS `fecha_inicio`,(select count(0) from `entregables` `e` where ((`e`.`proyecto_id` = `p`.`id`) and (`e`.`estado` = 'completado'))) AS `hitos_completados`,(select count(0) from `entregables` `e` where (`e`.`proyecto_id` = `p`.`id`)) AS `hitos_totales`,(select max(`a`.`fecha_hora`) from `avances` `a` where (`a`.`proyecto_id` = `p`.`id`)) AS `ultimo_avance`,group_concat(distinct `dev`.`id` separator ',') AS `desarrolladores_ids`,`emp`.`id` AS `empresa_id`,`p`.`estado` AS `estado` from (((`proyectos` `p` join `contrataciones` `c` on((`p`.`id` = `c`.`proyecto_id`))) join `usuarios` `emp` on((`p`.`empresa_id` = `emp`.`id`))) join `usuarios` `dev` on((`c`.`desarrollador_id` = `dev`.`id`))) where (`p`.`estado` in ('en_desarrollo','en_revision')) group by `p`.`id`,`p`.`titulo`,`p`.`descripcion`,`p`.`tipo_solucion`,`p`.`prioridad`,`p`.`fecha_publicacion`,`p`.`fecha_limite`,`emp`.`nombre`,`emp`.`id`,`p`.`estado` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_reputacion_empresas`
--

/*!50001 DROP VIEW IF EXISTS `v_reputacion_empresas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_reputacion_empresas` AS select `u`.`id` AS `usuario_id`,`u`.`nombre` AS `nombre_usuario`,`pe`.`nombre_empresa` AS `nombre_empresa`,`pe`.`sector` AS `sector`,count(`v`.`id`) AS `total_evaluaciones`,round(avg(`v`.`puntuacion`),2) AS `promedio_reputacion` from ((`usuarios` `u` left join `perfil_empresa` `pe` on((`u`.`id` = `pe`.`usuario_id`))) join `valoraciones` `v` on((`u`.`id` = `v`.`empresa_id`))) where ((`u`.`rol` = 'empresa') and (`v`.`rol_evaluador` = 'desarrollador')) group by `u`.`id`,`u`.`nombre`,`pe`.`nombre_empresa`,`pe`.`sector` */;
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_top_desarrolladores` AS select `u`.`id` AS `id`,`u`.`nombre` AS `nombre`,`pd`.`programa_formacion` AS `programa_formacion`,`pd`.`ficha` AS `ficha`,`pd`.`habilidades` AS `habilidades`,coalesce(`vc`.`promedio`,0.00) AS `calificacion_promedio`,(select count(0) from `contrataciones` where ((`contrataciones`.`desarrollador_id` = `u`.`id`) and (`contrataciones`.`estado` = 'finalizada'))) AS `num_proyectos_completados` from ((`usuarios` `u` left join `perfil_desarrollador` `pd` on((`u`.`id` = `pd`.`usuario_id`))) left join `v_calificacion_desarrolladores` `vc` on((`u`.`id` = `vc`.`desarrollador_id`))) where ((`u`.`rol` = 'desarrollador') and (`u`.`estado` = 'activo')) having (`num_proyectos_completados` > 0) order by `calificacion_promedio` desc,`num_proyectos_completados` desc limit 10 */;
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

-- Dump completed on 2026-04-01 23:02:06
