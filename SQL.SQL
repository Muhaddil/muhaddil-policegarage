-- CREATE TABLE IF NOT EXISTS `police_garage` (
--   `id` int(11) NOT NULL AUTO_INCREMENT,
--   `identifier` varchar(60) NOT NULL COMMENT 'Steam ID o identificador del jugador',
--   `favorites` longtext DEFAULT '[]' COMMENT 'Array JSON de vehículos favoritos',
--   `vehicle_configs` longtext DEFAULT '{}' COMMENT 'Objeto JSON con configuraciones de vehículos',
--   `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
--   `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
--   PRIMARY KEY (`id`),
--   UNIQUE KEY `identifier` (`identifier`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `police_garage_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `player_name` varchar(255) NOT NULL,
  `vehicle_model` varchar(100) NOT NULL,
  `spawn_location` varchar(255) DEFAULT NULL,
  `spawn_time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`),
  KEY `spawn_time` (`spawn_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ALTER TABLE `police_garage` ADD INDEX `idx_identifier` (`identifier`);
ALTER TABLE `police_garage_logs` ADD INDEX `idx_vehicle_model` (`vehicle_model`);