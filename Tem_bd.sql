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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
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
  `entregable_id` bigint DEFAULT NULL,
  `descripcion` text NOT NULL,
  `archivo_url` varchar(500) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `desarrollador_id` (`desarrollador_id`),
  KEY `idx_proyecto` (`proyecto_id`),
  KEY `idx_fecha` (`fecha_hora`),
  KEY `idx_proyecto_fecha` (`proyecto_id`,`fecha_hora`),
  KEY `fk_avances_entregable` (`entregable_id`),
  CONSTRAINT `avances_ibfk_1` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `avances_ibfk_2` FOREIGN KEY (`desarrollador_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `fk_avances_entregable` FOREIGN KEY (`entregable_id`) REFERENCES `entregables` (`id`) ON DELETE SET NULL
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_verificar_inactividad` BEFORE INSERT ON `avances` FOR EACH ROW BEGIN
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
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_validar_contrato_antes_de_avance` BEFORE INSERT ON `avances` FOR EACH ROW BEGIN
    
    IF NOT EXISTS (
        SELECT 1 FROM contrataciones 
        WHERE proyecto_id = NEW.proyecto_id 
        AND desarrollador_id = NEW.desarrollador_id 
        AND estado = 'activa'
    ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: No puedes registrar avances en un proyecto donde no tienes una contratación activa.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `trg_nuevo_avance` AFTER INSERT ON `avances` FOR EACH ROW BEGIN
  DECLARE v_empresa_id BIGINT;
  DECLARE v_titulo_proy VARCHAR(200);
  DECLARE v_total_hitos INT;
  DECLARE v_hitos_completados INT;
  DECLARE v_progreso DECIMAL(5,2);

  -- Notificar a la empresa
  SELECT empresa_id, titulo INTO v_empresa_id, v_titulo_proy FROM proyectos WHERE id = NEW.proyecto_id;
  
  INSERT INTO notificaciones (usuario_id, tipo, mensaje)
  VALUES (v_empresa_id, 'avance', CONCAT('Nuevo hito completado en: ', v_titulo_proy));

  -- Calcular progreso basado en la tabla entregables
  -- Solo si el avance está ligado a un hito
  IF NEW.entregable_id IS NOT NULL THEN
    -- Marcamos el hito como completado si no lo está
    UPDATE entregables SET estado = 'completado' WHERE id = NEW.entregable_id;

    -- Cálculo de progreso real
    SELECT COUNT(*) INTO v_total_hitos FROM entregables WHERE proyecto_id = NEW.proyecto_id;
    SELECT COUNT(*) INTO v_hitos_completados FROM entregables WHERE proyecto_id = NEW.proyecto_id AND estado = 'completado';

    IF v_total_hitos > 0 THEN
      SET v_progreso = (v_hitos_completados / v_total_hitos) * 100;
      
      -- Si llegamos al 100%, pasar a revisión automáticamente
      IF v_progreso >= 100 THEN
        UPDATE proyectos SET estado = 'en_revision' WHERE id = NEW.proyecto_id;
      END IF;
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
  KEY `idx_proyecto_id` (`proyecto_id`),
  KEY `idx_desarrollador` (`desarrollador_id`),
  KEY `idx_empresa` (`empresa_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_contrataciones_proy_dev` (`proyecto_id`,`desarrollador_id`,`estado`),
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
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-03-29 04:23:55.863778'),(2,'contenttypes','0002_remove_content_type_name','2026-03-29 04:23:55.871318'),(3,'auth','0001_initial','2026-03-29 04:23:55.874710'),(4,'auth','0002_alter_permission_name_max_length','2026-03-29 04:23:55.877892'),(5,'auth','0003_alter_user_email_max_length','2026-03-29 04:23:55.881796'),(6,'auth','0004_alter_user_username_opts','2026-03-29 04:23:55.886557'),(7,'auth','0005_alter_user_last_login_null','2026-03-29 04:23:55.892218'),(8,'auth','0006_require_contenttypes_0002','2026-03-29 04:23:55.895678'),(9,'auth','0007_alter_validators_add_error_messages','2026-03-29 04:23:55.899018'),(10,'auth','0008_alter_user_username_max_length','2026-03-29 04:23:55.902758'),(11,'auth','0009_alter_user_last_name_max_length','2026-03-29 04:23:55.906008'),(12,'auth','0010_alter_group_name_max_length','2026-03-29 04:23:55.911793'),(13,'auth','0011_update_proxy_permissions','2026-03-29 04:23:55.915298'),(14,'auth','0012_alter_user_first_name_max_length','2026-03-29 04:23:55.920728'),(15,'usuarios','0001_initial','2026-03-29 04:23:55.925257'),(16,'admin','0001_initial','2026-03-29 04:23:55.928491'),(17,'admin','0002_logentry_remove_auto_add','2026-03-29 04:23:55.932352'),(18,'admin','0003_logentry_add_action_flag_choices','2026-03-29 04:23:55.935763'),(19,'proyectos','0001_initial','2026-03-29 04:23:55.939068'),(20,'avances','0001_initial','2026-03-29 04:23:55.942110'),(21,'avances','0002_alter_avance_table','2026-03-29 04:23:55.945825'),(22,'avances','0003_alter_avance_archivo_url_alter_avance_table','2026-03-29 04:23:55.952191'),(23,'proyectos','0002_proyecto_vacantes_alter_proyecto_estado_and_more','2026-03-29 04:23:55.957885'),(24,'contrataciones','0001_initial','2026-03-29 04:23:55.962270'),(25,'contrataciones','0002_alter_contratacion_proyecto','2026-03-29 04:23:55.966383'),(26,'contrataciones','0003_alter_contratacion_table','2026-03-29 04:23:55.970009'),(27,'contrataciones','0004_alter_contratacion_table','2026-03-29 04:23:55.973082'),(28,'favoritos','0001_initial','2026-03-29 04:23:55.976146'),(29,'favoritos','0002_alter_favorito_table','2026-03-29 04:23:55.979098'),(30,'favoritos','0003_alter_favorito_table','2026-03-29 04:23:55.983339'),(31,'logs','0001_initial','2026-03-29 04:23:55.989042'),(32,'logs','0002_alter_copiaseguridad_table_alter_logauditoria_table','2026-03-29 04:23:55.993469'),(33,'logs','0003_alter_logauditoria_registro_id_and_more','2026-03-29 04:23:55.996551'),(34,'logs','0004_alter_copiaseguridad_ejecutado_por','2026-03-29 04:23:55.999703'),(35,'proyectos','0003_alter_historialestadoproyecto_table_and_more','2026-03-29 04:23:56.003926'),(36,'proyectos','0004_valoracion_rol_evaluador_and_more','2026-03-29 04:23:56.007151'),(37,'mensajes','0001_initial','2026-03-29 04:23:56.009947'),(38,'mensajes','0002_alter_mensaje_table','2026-03-29 04:23:56.013734'),(39,'mensajes','0003_alter_mensaje_proyecto_alter_mensaje_table','2026-03-29 04:23:56.019321'),(40,'mensajes','0004_alter_mensaje_receptor','2026-03-29 04:23:56.024721'),(41,'notificaciones','0001_initial','2026-03-29 04:23:56.029021'),(42,'notificaciones','0002_alter_notificacion_table','2026-03-29 04:23:56.033018'),(43,'notificaciones','0003_alter_notificacion_options_and_more','2026-03-29 04:23:56.037894'),(44,'postulaciones','0001_initial','2026-03-29 04:23:56.041829'),(45,'postulaciones','0002_alter_postulacion_table','2026-03-29 04:23:56.046251'),(46,'postulaciones','0003_alter_postulacion_table','2026-03-29 04:23:56.050483'),(47,'proyectos','0005_alter_historialestadoproyecto_cambiado_por_and_more','2026-03-29 04:23:56.056128'),(48,'proyectos','0006_alter_valoracion_unique_together','2026-03-29 04:23:56.059907'),(49,'sessions','0001_initial','2026-03-29 04:23:56.063376'),(50,'usuarios','0002_usuario_fecha_nacimiento_and_more','2026-03-29 04:23:56.066575'),(51,'usuarios','0003_alter_usuario_options_usuario_nombre_and_more','2026-03-29 04:23:56.071108'),(52,'usuarios','0004_alter_usuario_options_usuario_nombre_and_more','2026-03-29 04:23:56.074639');
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
  `proyecto_id` bigint NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text,
  `estado` enum('pendiente','completado') DEFAULT 'pendiente',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_entregables_proy_estado` (`proyecto_id`,`estado`),
  CONSTRAINT `fk_entregables_proyecto` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entregables`
--

LOCK TABLES `entregables` WRITE;
/*!40000 ALTER TABLE `entregables` DISABLE KEYS */;
INSERT INTO `entregables` VALUES (4,8,'Crear un login','Neceistamos que sea si o si con react','completado','2026-03-29 20:36:39'),(5,9,'m','m','completado','2026-03-29 20:49:19'),(6,10,'lolo','lili','completado','2026-03-29 21:16:41'),(7,11,'Hacer los mockups','con notion','completado','2026-03-29 21:25:07');
/*!40000 ALTER TABLE `entregables` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `trg_notificar_nuevo_hito` AFTER INSERT ON `entregables` FOR EACH ROW BEGIN
  DECLARE v_titulo_proy VARCHAR(200);
  SELECT titulo INTO v_titulo_proy FROM proyectos WHERE id = NEW.proyecto_id;

  INSERT INTO notificaciones (usuario_id, tipo, mensaje)
  SELECT desarrollador_id, 'avance', CONCAT('Nuevo hito añadido en ', v_titulo_proy, ': ', NEW.titulo)
  FROM contrataciones 
  WHERE proyecto_id = NEW.proyecto_id AND estado = 'activa';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
  `ip_address` varchar(45) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_fecha` (`fecha_hora`),
  KEY `idx_tabla` (`tabla_afectada`),
  CONSTRAINT `logs_auditoria_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_auditoria`
--

LOCK TABLES `logs_auditoria` WRITE;
/*!40000 ALTER TABLE `logs_auditoria` DISABLE KEYS */;
INSERT INTO `logs_auditoria` VALUES (1,3,'Inicio de sesiÃ³n registrado','usuarios',3,NULL,'2026-03-29 22:10:50');
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
  KEY `idx_mensajes_proyecto` (`proyecto_id`),
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `trg_notificacion_mensaje` AFTER INSERT ON `mensajes` FOR EACH ROW BEGIN
  DECLARE v_nombre_remitente VARCHAR(150);
  DECLARE v_titulo_proy VARCHAR(200);
  DECLARE v_empresa_id BIGINT;

  SELECT nombre INTO v_nombre_remitente FROM usuarios WHERE id = NEW.remitente_id;

  -- CASO 1: Chat Privado
  IF NEW.receptor_id IS NOT NULL THEN
    INSERT INTO notificaciones (usuario_id, tipo, mensaje)
    VALUES (NEW.receptor_id, 'mensaje', CONCAT(v_nombre_remitente, ' te ha enviado un mensaje.'));
  
  -- CASO 2: Espacio de Trabajo (Bulk Insert para eficiencia)
  ELSEIF NEW.proyecto_id IS NOT NULL THEN
    SELECT titulo, empresa_id INTO v_titulo_proy, v_empresa_id FROM proyectos WHERE id = NEW.proyecto_id;

    -- Notificamos a la empresa y a todos los devs del proyecto en una sola operación
    INSERT INTO notificaciones (usuario_id, tipo, mensaje)
    SELECT id_usuario, 'mensaje', CONCAT(v_nombre_remitente, ' escribió en el Espacio de Trabajo: ', v_titulo_proy)
    FROM (
      -- ID de la empresa (si no es el remitente)
      SELECT v_empresa_id AS id_usuario WHERE v_empresa_id != NEW.remitente_id
      UNION
      -- IDs de los desarrolladores contratados (si no son el remitente)
      SELECT desarrollador_id FROM contrataciones 
      WHERE proyecto_id = NEW.proyecto_id AND estado = 'activa' AND desarrollador_id != NEW.remitente_id
    ) AS equipo_notificar;
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
  PRIMARY KEY (`id`),
  KEY `idx_usuario_leida` (`usuario_id`,`leida`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_fecha` (`fecha`),
  KEY `idx_notif_usuario_fecha` (`usuario_id`,`fecha` DESC),
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil_desarrollador`
--

LOCK TABLES `perfil_desarrollador` WRITE;
/*!40000 ALTER TABLE `perfil_desarrollador` DISABLE KEYS */;
INSERT INTO `perfil_desarrollador` VALUES (1,3,NULL,NULL,NULL,0.00,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil_empresa`
--

LOCK TABLES `perfil_empresa` WRITE;
/*!40000 ALTER TABLE `perfil_empresa` DISABLE KEYS */;
INSERT INTO `perfil_empresa` VALUES (1,2,NULL,NULL,NULL,NULL,NULL,NULL);
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
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_nueva_postulacion` AFTER INSERT ON `postulaciones` FOR EACH ROW BEGIN
  DECLARE v_empresa_id BIGINT;
  DECLARE v_nombre_dev VARCHAR(150);
  DECLARE v_titulo_proy VARCHAR(200);

  SELECT empresa_id, titulo INTO v_empresa_id, v_titulo_proy FROM proyectos WHERE id = NEW.proyecto_id;
  SELECT COALESCE(nombre, username) INTO v_nombre_dev FROM usuarios WHERE id = NEW.desarrollador_id;

  INSERT INTO notificaciones (usuario_id, tipo, mensaje)
  VALUES (
    v_empresa_id,
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyectos`
--

LOCK TABLES `proyectos` WRITE;
/*!40000 ALTER TABLE `proyectos` DISABLE KEYS */;
INSERT INTO `proyectos` VALUES (8,2,'Pepsi','a','sitio_web','media',1,'finalizado','2026-03-29 20:35:01.922716',NULL,NULL,NULL),(9,2,'d','d','sitio_web','media',1,'inactivo','2026-03-29 20:39:30.597784',NULL,NULL,NULL),(10,2,'jko','jko','sitio_web','media',1,'en_desarrollo','2026-03-29 21:10:08.698961',NULL,NULL,NULL),(11,2,'mono','mono','sitio_web','media',2,'inactivo','2026-03-29 21:18:41.810446',NULL,NULL,NULL);
/*!40000 ALTER TABLE `proyectos` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'admin_master','Admin Master',NULL,NULL,'admin@tem.com','pbkdf2_sha256$1200000$kJ4MmqW9gQrKXwUixhjgMJ$PHeLMLggWqeUarePItNuB4YGyqksc7/9nyQFcZ8vnhQ=','administrador','activo','2026-03-29 00:52:09','2026-03-29 21:47:35',NULL,NULL,0,NULL,1,1,1,'','','2026-03-29 00:52:09','2026-03-29 21:47:35'),(2,'empresa_tech','Tech Corp SAS',NULL,NULL,'contacto@techcorp.com','pbkdf2_sha256$1200000$s2MSdDRGR9t4E4gfcZE2Js$3TQYfJoJ6RUDIpOzz4gQGl3VexPKKTEG+i0F8Nq35ZU=','empresa','activo','2026-03-29 00:52:10','2026-03-29 21:36:26',NULL,NULL,0,NULL,0,0,1,'','','2026-03-29 00:52:10','2026-03-29 21:36:26'),(3,'dev_expert','Juan Desarrollador',NULL,NULL,'dev@pro.com','pbkdf2_sha256$1200000$lRdby9qIK5Nv5Abl0xLDLN$pmH5D6I7Tvux2x2E/CxSFfHcAIMh7NvcRMFnCsLA0YQ=','desarrollador','activo','2026-03-29 00:52:11','2026-03-29 22:10:50',NULL,NULL,0,NULL,0,0,1,'','','2026-03-29 00:52:11','2026-03-29 22:10:51');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_registro_sesion` BEFORE UPDATE ON `usuarios` FOR EACH ROW BEGIN
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
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
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
  CONSTRAINT `usuarios_usuario_gro_usuario_id_7a34077f_fk_usuarios_` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios_usuario` (`id`),
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
  CONSTRAINT `usuarios_usuario_use_permission_id_4e5c0f2f_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `usuarios_usuario_use_usuario_id_60aeea80_fk_usuarios_` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios_usuario` (`id`)
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
 1 AS `empresa_nombre`,
 1 AS `empresa_id`,
 1 AS `estado`,
 1 AS `fecha_fin_estimada`,
 1 AS `porcentaje_avance_promedio`,
 1 AS `ultimo_avance`,
 1 AS `desarrolladores_ids`,
 1 AS `desarrolladores_nombres`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_reputacion_empresas`
--

DROP TABLE IF EXISTS `v_reputacion_empresas`;
/*!50001 DROP VIEW IF EXISTS `v_reputacion_empresas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_reputacion_empresas` AS SELECT 
 1 AS `empresa_id`,
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
  `rol_evaluador` enum('empresa','desarrollador') DEFAULT 'empresa',
  `puntuacion` tinyint NOT NULL,
  `comentario` text,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `valoracion_miembro_proy` (`proyecto_id`,`desarrollador_id`,`rol_evaluador`),
  KEY `empresa_id` (`empresa_id`),
  KEY `desarrollador_id` (`desarrollador_id`),
  KEY `idx_valoraciones_empresa` (`empresa_id`),
  KEY `idx_valoraciones_dev` (`desarrollador_id`),
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
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_nueva_valoracion` AFTER INSERT ON `valoraciones` FOR EACH ROW BEGIN
    DECLARE v_nombre_evaluador VARCHAR(150);
    DECLARE v_titulo_proy VARCHAR(200);
    DECLARE v_receptor_id BIGINT;

    
    SELECT titulo INTO v_titulo_proy FROM proyectos WHERE id = NEW.proyecto_id;

    
    IF NEW.rol_evaluador = 'empresa' THEN
        SET v_receptor_id = NEW.desarrollador_id;
        SELECT nombre INTO v_nombre_evaluador FROM usuarios WHERE id = NEW.empresa_id;
        
        INSERT INTO notificaciones (usuario_id, tipo, mensaje)
        VALUES (
            v_receptor_id,
            'aprobacion',
            CONCAT(v_nombre_evaluador, ' te ha calificado con ', NEW.puntuacion, ' estrellas en el proyecto: ', v_titulo_proy)
        );
    ELSE
        SET v_receptor_id = NEW.empresa_id;
        SELECT nombre INTO v_nombre_evaluador FROM usuarios WHERE id = NEW.desarrollador_id;

        INSERT INTO notificaciones (usuario_id, tipo, mensaje)
        VALUES (
            v_receptor_id,
            'aprobacion',
            CONCAT(v_nombre_evaluador, ' ha dejado una reseña sobre tu empresa por el proyecto: ', v_titulo_proy)
        );
    END IF;
END */;;
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
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_dashboard_desarrollador` AS select `u`.`id` AS `desarrollador_id`,`u`.`nombre` AS `nombre`,coalesce(`vc`.`promedio`,0.00) AS `calificacion_promedio`,(select count(0) from (`contrataciones` `c` join `proyectos` `p` on((`c`.`proyecto_id` = `p`.`id`))) where ((`c`.`desarrollador_id` = `u`.`id`) and (`p`.`estado` = 'finalizado'))) AS `num_proyectos_completados`,(select count(0) from `mensajes` where ((`mensajes`.`receptor_id` = `u`.`id`) and (`mensajes`.`leido` = false))) AS `mensajes_nuevos`,(select count(0) from (`contrataciones` `c` join `proyectos` `p` on((`c`.`proyecto_id` = `p`.`id`))) where ((`c`.`desarrollador_id` = `u`.`id`) and (`p`.`estado` = 'en_desarrollo'))) AS `proyectos_activos`,(select count(0) from `favoritos` where (`favoritos`.`desarrollador_id` = `u`.`id`)) AS `proyectos_favoritos` from (`usuarios` `u` left join `v_calificacion_desarrolladores` `vc` on((`u`.`id` = `vc`.`desarrollador_id`))) where (`u`.`rol` = 'desarrollador') */;
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
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_proyectos_en_desarrollo` AS select `p`.`id` AS `proyecto_id`,`p`.`titulo` AS `titulo`,`emp`.`nombre` AS `empresa_nombre`,`emp`.`id` AS `empresa_id`,`p`.`estado` AS `estado`,`p`.`fecha_limite` AS `fecha_fin_estimada`,(select coalesce(((count((case when (`e`.`estado` = 'completado') then 1 end)) / nullif(count(0),0)) * 100),0) from `entregables` `e` where (`e`.`proyecto_id` = `p`.`id`)) AS `porcentaje_avance_promedio`,(select max(`a`.`fecha_hora`) from `avances` `a` where (`a`.`proyecto_id` = `p`.`id`)) AS `ultimo_avance`,group_concat(distinct cast(`c`.`desarrollador_id` as char charset utf8mb4) separator ',') AS `desarrolladores_ids`,group_concat(distinct `u`.`username` separator ', ') AS `desarrolladores_nombres` from (((`proyectos` `p` join `usuarios` `emp` on((`p`.`empresa_id` = `emp`.`id`))) left join `contrataciones` `c` on(((`p`.`id` = `c`.`proyecto_id`) and (`c`.`estado` = 'activa')))) left join `usuarios` `u` on((`c`.`desarrollador_id` = `u`.`id`))) where (`p`.`estado` in ('publicado','en_desarrollo','en_revision')) group by `p`.`id`,`p`.`titulo`,`emp`.`nombre`,`emp`.`id`,`p`.`estado`,`p`.`fecha_limite` */;
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
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_reputacion_empresas` AS select `u`.`id` AS `empresa_id`,`u`.`nombre` AS `nombre_usuario`,`pe`.`nombre_empresa` AS `nombre_empresa`,`pe`.`sector` AS `sector`,count(`v`.`id`) AS `total_evaluaciones`,round(avg(`v`.`puntuacion`),2) AS `promedio_reputacion` from ((`usuarios` `u` left join `perfil_empresa` `pe` on((`u`.`id` = `pe`.`usuario_id`))) join `valoraciones` `v` on((`u`.`id` = `v`.`empresa_id`))) where ((`u`.`rol` = 'empresa') and (`v`.`rol_evaluador` = 'desarrollador')) group by `u`.`id`,`u`.`nombre`,`pe`.`nombre_empresa`,`pe`.`sector` order by `promedio_reputacion` desc */;
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
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_top_desarrolladores` AS select `u`.`id` AS `id`,`u`.`nombre` AS `nombre`,`pd`.`programa_formacion` AS `programa_formacion`,coalesce(`vc`.`promedio`,0.00) AS `calificacion_promedio`,`pd`.`num_proyectos_completados` AS `num_proyectos_completados`,`pd`.`habilidades` AS `habilidades`,(select count(0) from (`contrataciones` `c` join `proyectos` `p` on((`c`.`proyecto_id` = `p`.`id`))) where ((`c`.`desarrollador_id` = `u`.`id`) and (`p`.`estado` = 'en_desarrollo'))) AS `proyectos_activos` from ((`usuarios` `u` join `perfil_desarrollador` `pd` on((`u`.`id` = `pd`.`usuario_id`))) left join `v_calificacion_desarrolladores` `vc` on((`u`.`id` = `vc`.`desarrollador_id`))) where ((`u`.`rol` = 'desarrollador') and (`u`.`estado` = 'activo') and (`pd`.`num_proyectos_completados` > 0)) order by `calificacion_promedio` desc,`pd`.`num_proyectos_completados` desc limit 10 */;
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

-- Dump completed on 2026-03-29 22:11:45
