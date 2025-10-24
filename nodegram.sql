-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 23, 2025 at 10:03 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nodegram`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_providers`
--

CREATE TABLE `auth_providers` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `provider` varchar(50) NOT NULL,
  `provider_user_id` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `subscription_id` text DEFAULT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `payment_id` text NOT NULL,
  `price_id` text NOT NULL,
  `amount` text NOT NULL,
  `proration_amount` decimal(10,2) DEFAULT 0.00,
  `currency` text DEFAULT 'eur',
  `status` text NOT NULL,
  `change_type` enum('upgrade','downgrade','renewal','same_plan') DEFAULT 'renewal',
  `current_plan_remaining_days` decimal(5,2) DEFAULT 0.00,
  `transaction_description` text DEFAULT NULL,
  `paid_at` text DEFAULT NULL,
  `metadata` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reg`
--

CREATE TABLE `reg` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `reg_code` varchar(256) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_used` tinyint(1) DEFAULT 0,
  `attempts` int(11) DEFAULT 0,
  `last_attempt` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(256) DEFAULT NULL,
  `user_agent` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reg_verification`
--

CREATE TABLE `reg_verification` (
  `id` int(11) NOT NULL,
  `email` text NOT NULL,
  `username` text NOT NULL,
  `verification_code` text NOT NULL,
  `expires_at` datetime NOT NULL,
  `ip_address` text NOT NULL,
  `user_agent` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Таблица для хранения кодов верификации при регистрации';

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `subscription_id` text NOT NULL,
  `plan_id` text DEFAULT NULL,
  `next_plan_id` text DEFAULT NULL,
  `status` enum('active','canceled','expired','past_due') DEFAULT 'active',
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `cancel_at_period_end` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_limits`
--

CREATE TABLE `support_limits` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `tickets_today` int(11) NOT NULL DEFAULT 0,
  `tickets_week` int(11) NOT NULL DEFAULT 0,
  `last_ticket_date` date NOT NULL,
  `last_reset_date` date NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_tickets`
--

CREATE TABLE `support_tickets` (
  `id` int(11) NOT NULL,
  `ticket_id` varchar(50) NOT NULL,
  `user_id` int(11) NOT NULL,
  `subject` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `status` enum('open','in_progress','resolved','closed') NOT NULL DEFAULT 'open',
  `priority` enum('low','medium','high','urgent') NOT NULL DEFAULT 'medium',
  `admin_response` text DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `resolved_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `uid` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `workspaces` text NOT NULL,
  `password_hash` text NOT NULL,
  `sid` text NOT NULL,
  `last_login` text DEFAULT NULL,
  `created_at` varchar(256) DEFAULT NULL,
  `updated_at` varchar(256) DEFAULT NULL,
  `is_active` varchar(256) DEFAULT '1',
  `lvl` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_files`
--

CREATE TABLE `user_files` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `node_id` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` text NOT NULL,
  `file_type` varchar(100) NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `workspace` text NOT NULL,
  `upload_date` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `workspaces`
--

CREATE TABLE `workspaces` (
  `id` int(11) NOT NULL,
  `wid` text NOT NULL,
  `owner_id` int(11) NOT NULL,
  `data` longtext NOT NULL,
  `created_at` varchar(256) NOT NULL,
  `updated_at` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `workspace_invitations`
--

CREATE TABLE `workspace_invitations` (
  `id` int(11) NOT NULL,
  `workspace_id` varchar(255) NOT NULL,
  `inviter_id` varchar(256) NOT NULL,
  `invitee_email` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'viewer',
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `token` varchar(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `workspace_members`
--

CREATE TABLE `workspace_members` (
  `id` int(11) NOT NULL,
  `workspace_id` varchar(255) NOT NULL,
  `user_id` varchar(256) NOT NULL,
  `role` varchar(20) NOT NULL,
  `joined_at` datetime DEFAULT current_timestamp(),
  `owner_id` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_providers`
--
ALTER TABLE `auth_providers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_provider_user` (`provider`,`provider_user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `payment_id` (`payment_id`) USING HASH,
  ADD KEY `idx_payments_user_id` (`user_id`),
  ADD KEY `idx_payments_subscription_id` (`subscription_id`(768)),
  ADD KEY `idx_payments_invoice_id` (`invoice_id`),
  ADD KEY `idx_payments_payment_id` (`payment_id`(768)),
  ADD KEY `idx_status` (`status`(768)),
  ADD KEY `idx_change_type` (`change_type`),
  ADD KEY `idx_updated_at` (`updated_at`);

--
-- Indexes for table `reg`
--
ALTER TABLE `reg`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_reg_code` (`reg_code`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- Indexes for table `reg_verification`
--
ALTER TABLE `reg_verification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email_created` (`email`(255),`created_at`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `support_limits`
--
ALTER TABLE `support_limits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `last_ticket_date` (`last_ticket_date`),
  ADD KEY `last_reset_date` (`last_reset_date`);

--
-- Indexes for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ticket_id` (`ticket_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `status` (`status`),
  ADD KEY `priority` (`priority`),
  ADD KEY `created_at` (`created_at`),
  ADD KEY `idx_support_tickets_user_status` (`user_id`,`status`),
  ADD KEY `idx_support_tickets_created_status` (`created_at`,`status`),
  ADD KEY `idx_support_tickets_priority_status` (`priority`,`status`),
  ADD KEY `idx_support_tickets_user_created` (`user_id`,`created_at`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`uid`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_files`
--
ALTER TABLE `user_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_files_user` (`user_id`),
  ADD KEY `idx_user_files_workspace` (`workspace`(768)),
  ADD KEY `idx_user_files_node` (`node_id`);

--
-- Indexes for table `workspaces`
--
ALTER TABLE `workspaces`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_workspaces_owner` (`owner_id`),
  ADD KEY `idx_workspaces_wid` (`wid`(768));

--
-- Indexes for table `workspace_invitations`
--
ALTER TABLE `workspace_invitations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_invitations_token` (`token`),
  ADD KEY `idx_invitations_status` (`status`),
  ADD KEY `idx_invitations_expires` (`expires_at`);

--
-- Indexes for table `workspace_members`
--
ALTER TABLE `workspace_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_members_role` (`role`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_providers`
--
ALTER TABLE `auth_providers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `reg`
--
ALTER TABLE `reg`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `reg_verification`
--
ALTER TABLE `reg_verification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `support_limits`
--
ALTER TABLE `support_limits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `support_tickets`
--
ALTER TABLE `support_tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `user_files`
--
ALTER TABLE `user_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=706;

--
-- AUTO_INCREMENT for table `workspaces`
--
ALTER TABLE `workspaces`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=478;

--
-- AUTO_INCREMENT for table `workspace_invitations`
--
ALTER TABLE `workspace_invitations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `workspace_members`
--
ALTER TABLE `workspace_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_providers`
--
ALTER TABLE `auth_providers`
  ADD CONSTRAINT `auth_providers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`uid`) ON DELETE CASCADE;

--
-- Constraints for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `support_tickets_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`uid`) ON DELETE CASCADE;

--
-- Constraints for table `user_files`
--
ALTER TABLE `user_files`
  ADD CONSTRAINT `user_files_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`uid`) ON DELETE CASCADE;

--
-- Constraints for table `workspaces`
--
ALTER TABLE `workspaces`
  ADD CONSTRAINT `workspaces_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`uid`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
