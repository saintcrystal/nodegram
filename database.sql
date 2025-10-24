-- Nodegram Database Schema
-- This file contains the complete database structure for Nodegram

-- Create database (run this separately)
-- CREATE DATABASE nodegram CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE nodegram;

-- Users table
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL UNIQUE,
  `username` varchar(100) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `subscription` text DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `email_verified` tinyint(1) DEFAULT 0,
  `verification_token` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_expires` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Workspaces table
CREATE TABLE IF NOT EXISTS `workspaces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `nodes` longtext DEFAULT NULL,
  `links` longtext DEFAULT NULL,
  `calendar` longtext DEFAULT NULL,
  `settings` text DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_accessed` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_owner_id` (`owner_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_is_public` (`is_public`),
  FOREIGN KEY (`owner_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Workspace members table
CREATE TABLE IF NOT EXISTS `workspace_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workspace_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` enum('owner','admin','member','viewer') DEFAULT 'member',
  `permissions` text DEFAULT NULL,
  `invited_by` int(11) DEFAULT NULL,
  `joined_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','pending','declined','removed') DEFAULT 'pending',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_workspace_user` (`workspace_id`, `user_id`),
  KEY `idx_workspace_id` (`workspace_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  FOREIGN KEY (`workspace_id`) REFERENCES `workspaces`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`invited_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Workspace invitations table
CREATE TABLE IF NOT EXISTS `workspace_invitations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workspace_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` enum('admin','member','viewer') DEFAULT 'member',
  `token` varchar(255) NOT NULL UNIQUE,
  `invited_by` int(11) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `status` enum('pending','accepted','declined','expired') DEFAULT 'pending',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `responded_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_workspace_id` (`workspace_id`),
  KEY `idx_email` (`email`),
  KEY `idx_token` (`token`),
  KEY `idx_status` (`status`),
  KEY `idx_expires_at` (`expires_at`),
  FOREIGN KEY (`workspace_id`) REFERENCES `workspaces`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`invited_by`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Files table
CREATE TABLE IF NOT EXISTS `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workspace_id` int(11) NOT NULL,
  `node_id` varchar(100) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `file_hash` varchar(64) NOT NULL,
  `is_encrypted` tinyint(1) DEFAULT 0,
  `encryption_key` varchar(255) DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_workspace_id` (`workspace_id`),
  KEY `idx_node_id` (`node_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_file_hash` (`file_hash`),
  KEY `idx_created_at` (`created_at`),
  FOREIGN KEY (`workspace_id`) REFERENCES `workspaces`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Subscriptions table
CREATE TABLE IF NOT EXISTS `subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `stripe_customer_id` varchar(255) DEFAULT NULL,
  `stripe_subscription_id` varchar(255) DEFAULT NULL,
  `plan_name` varchar(50) NOT NULL,
  `plan_period` enum('monthly','yearly') NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `currency` varchar(3) DEFAULT 'USD',
  `status` enum('active','canceled','past_due','unpaid','incomplete') DEFAULT 'active',
  `current_period_start` timestamp NULL DEFAULT NULL,
  `current_period_end` timestamp NULL DEFAULT NULL,
  `canceled_at` timestamp NULL DEFAULT NULL,
  `trial_start` timestamp NULL DEFAULT NULL,
  `trial_end` timestamp NULL DEFAULT NULL,
  `auto_renewal` tinyint(1) DEFAULT 1,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_subscription` (`user_id`),
  KEY `idx_stripe_customer_id` (`stripe_customer_id`),
  KEY `idx_stripe_subscription_id` (`stripe_subscription_id`),
  KEY `idx_plan_name` (`plan_name`),
  KEY `idx_status` (`status`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Support tickets table
CREATE TABLE IF NOT EXISTS `support_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `priority` enum('low','medium','high','urgent') DEFAULT 'medium',
  `status` enum('open','in_progress','resolved','closed') DEFAULT 'open',
  `category` varchar(100) DEFAULT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `resolved_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_priority` (`priority`),
  KEY `idx_created_at` (`created_at`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`assigned_to`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Support ticket messages table
CREATE TABLE IF NOT EXISTS `support_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `is_internal` tinyint(1) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ticket_id` (`ticket_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`),
  FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Activity logs table
CREATE TABLE IF NOT EXISTS `activity_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `workspace_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `metadata` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_workspace_id` (`workspace_id`),
  KEY `idx_action` (`action`),
  KEY `idx_created_at` (`created_at`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`workspace_id`) REFERENCES `workspaces`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Rate limiting table
CREATE TABLE IF NOT EXISTS `rate_limits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) NOT NULL,
  `endpoint` varchar(255) NOT NULL,
  `request_count` int(11) DEFAULT 1,
  `window_start` timestamp DEFAULT CURRENT_TIMESTAMP,
  `last_request` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_ip_endpoint` (`ip_address`, `endpoint`),
  KEY `idx_window_start` (`window_start`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sessions table (for session management)
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(128) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_last_activity` (`last_activity`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default data
INSERT INTO `users` (`email`, `username`, `password`, `first_name`, `last_name`, `is_active`, `email_verified`) VALUES
('admin@nodegram.org', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'User', 1, 1);

-- Insert default subscription for admin user
INSERT INTO `subscriptions` (`user_id`, `plan_name`, `plan_period`, `price`, `status`, `auto_renewal`) VALUES
(1, 'Freemium', 'monthly', 0.00, 'active', 0);

-- Create indexes for better performance
CREATE INDEX `idx_workspaces_owner_created` ON `workspaces` (`owner_id`, `created_at`);
CREATE INDEX `idx_files_workspace_created` ON `files` (`workspace_id`, `created_at`);
CREATE INDEX `idx_activity_logs_user_created` ON `activity_logs` (`user_id`, `created_at`);
CREATE INDEX `idx_support_tickets_status_created` ON `support_tickets` (`status`, `created_at`);

-- Create views for common queries
CREATE VIEW `user_workspace_summary` AS
SELECT 
    u.id as user_id,
    u.username,
    u.email,
    COUNT(w.id) as workspace_count,
    MAX(w.created_at) as last_workspace_created,
    s.plan_name,
    s.status as subscription_status
FROM users u
LEFT JOIN workspaces w ON u.id = w.owner_id
LEFT JOIN subscriptions s ON u.id = s.user_id
GROUP BY u.id, u.username, u.email, s.plan_name, s.status;

CREATE VIEW `workspace_member_summary` AS
SELECT 
    w.id as workspace_id,
    w.name as workspace_name,
    w.owner_id,
    COUNT(wm.id) as member_count,
    COUNT(CASE WHEN wm.status = 'active' THEN 1 END) as active_members,
    COUNT(CASE WHEN wm.status = 'pending' THEN 1 END) as pending_invitations
FROM workspaces w
LEFT JOIN workspace_members wm ON w.id = wm.workspace_id
GROUP BY w.id, w.name, w.owner_id;
