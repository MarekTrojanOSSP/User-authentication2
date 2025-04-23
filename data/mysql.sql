SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `category` (`id`, `name`, `description`) VALUES
(1,	'Animal',	'Animal description'),
(2,	'neco',	'neoc');

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `comment` (`id`, `post_id`, `name`, `email`, `content`, `created_at`) VALUES
(1,	1,	'Fabia',	'cojsem@gmail.com',	' k',	'2024-09-25 10:16:10'),
(2,	6,	'Fabia',	'cojsem@gmail.com',	'vvvvvvvvv',	'2024-10-09 09:43:30'),
(3,	7,	'oh',	'oh@gmail.com',	'ohohohohohohohohoh',	'2024-10-16 10:14:59'),
(4,	7,	'oh',	'oh@gmail.com',	'kkkkkkk',	'2024-10-16 10:58:51'),
(5,	7,	'Fabia',	'cojsem@gmail.com',	'llll',	'2024-10-23 09:54:13'),
(6,	9,	'oh',	'cojsem@gmail.com',	'pokus',	'2024-10-23 10:12:10'),
(7,	11,	'Fabia',	'cowhat@gmail.com',	'ddddd',	'2024-11-06 10:15:22'),
(9,	15,	'game',	'cowhat@gmail.com',	'cmscbsjkcawciawgciuagcjawlvclu',	'2025-01-13 12:04:28'),
(14,	15,	'Sonic',	'cojsem@gmail.com',	'lllll',	'2025-01-29 10:23:15'),
(15,	14,	'Mario',	'cowhat@gmail.com',	'cccc',	'2025-03-26 11:04:34');

DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `view` int NOT NULL,
  `status` enum('OPEN','ARCHIVED','CLOSED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'OPEN',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `post_ibfk_4` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `post` (`id`, `category_id`, `title`, `content`, `image`, `view`, `status`, `created_at`) VALUES
(1,	1,	'Article One',	'Lorem ipusm dolor one',	'',	0,	'OPEN',	'2024-09-11 10:00:06'),
(2,	1,	'Article Two',	'Lorem ipsum dolor two',	'',	0,	'OPEN',	'2024-09-11 10:00:06'),
(3,	1,	'Article Three',	'Lorem ipsum dolor three',	'',	0,	'OPEN',	'2024-09-11 10:00:06'),
(4,	1,	'nový',	'voz',	'',	0,	'OPEN',	'2024-10-09 09:33:03'),
(5,	1,	'nový',	'veveveveveveveve',	'',	0,	'OPEN',	'2024-10-09 09:33:49'),
(6,	1,	'jeb',	'jebejbejebjebjbejbjbejbej',	'',	0,	'OPEN',	'2024-10-09 09:43:22'),
(7,	1,	'oh no oh',	'ohohohohohohoh',	'',	0,	'OPEN',	'2024-10-16 10:11:44'),
(8,	1,	'úprava příspěvku',	'je o úprava',	'',	0,	'OPEN',	'2024-10-23 10:11:46'),
(9,	1,	'pokus',	'pokus',	'',	0,	'OPEN',	'2024-10-23 10:12:01'),
(10,	1,	'hgjhgjnvkbvhrbewvmsb hebe bejhbchk',	'mkhlffff',	'',	0,	'OPEN',	'2024-10-23 10:20:38'),
(11,	1,	'gzgz',	'jzzufhvjuuuu',	'',	0,	'OPEN',	'2024-10-23 11:19:18'),
(13,	1,	'Pes',	'Pes',	'',	11,	'OPEN',	'2024-11-13 12:22:31'),
(14,	1,	'Oprava',	'oprava',	'',	90,	'ARCHIVED',	'2024-11-13 12:23:01'),
(15,	2,	'Test',	'Hello world',	NULL,	52,	'CLOSED',	'2024-11-27 11:28:39');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('admin','uzivatel') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'uzivatel',
  `created_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `users` (`id`, `username`, `password`, `email`, `role`, `created_at`) VALUES
(1,	'marek.trojan',	'$2y$10$RaKXLbRhEkWKGwIXEUpecOBntUyLPues8v8YQ1ejDpnEQ6CnuzNi2',	'marek.trojan@student.ossp.cz',	NULL,	NULL),
(2,	'adminl',	'0f098d99-1ab6-11f0-aef9-0242ac110002',	'marek.trojan@student.ossp.cz',	NULL,	'2025-04-16 11:29:28'),
(3,	'admin',	'$2y$10$tcAWja019pxyy399r1O7De03NqYq6IhkslhtHBPwRnfqFaNZxX.vy',	'marek.trojan@student.ossp.cz',	NULL,	NULL);

-- 2025-04-16 11:34:28