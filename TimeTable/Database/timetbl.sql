-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 20, 2025 at 09:23 AM
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
-- Database: `timetbl`
--

-- --------------------------------------------------------

--
-- Table structure for table `schedules`
--

CREATE TABLE `schedules` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `subject_name` varchar(200) NOT NULL,
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `room_number` varchar(100) DEFAULT NULL,
  `teacher_name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schedules`
--

INSERT INTO `schedules` (`id`, `user_id`, `subject_name`, `day_of_week`, `start_time`, `end_time`, `room_number`, `teacher_name`, `created_at`, `updated_at`) VALUES
(2, 2, 'Mobile App', 'Tuesday', '07:00:00', '14:00:00', 'CpE Lab', 'Sir Ronnie', '2025-10-19 15:55:06', '2025-10-19 17:34:42'),
(5, 2, 'Bakit mag add?', 'Monday', '13:37:00', '15:37:00', 'CpE 9', 'Doc Gi', '2025-10-19 19:38:13', '2025-10-20 03:18:41'),
(6, 2, 'CpE Project and Design', 'Monday', '17:42:00', '20:00:00', 'CpE Lab', 'Doc Marvin', '2025-10-19 19:43:00', '2025-10-19 19:46:25'),
(7, 5, 'CpE Project and Design', 'Tuesday', '12:07:00', '13:00:00', 'CpE Lab', 'Doc Marvin', '2025-10-20 03:09:01', '2025-10-20 03:11:46'),
(8, 5, 'Math', 'Monday', '11:12:00', '12:12:00', '209', 'Doc Gi', '2025-10-20 03:12:24', '2025-10-20 03:12:24'),
(9, 2, 'Science', 'Wednesday', '08:00:00', '09:00:00', '9090', 'Mr.Gi', '2025-10-20 03:21:08', '2025-10-20 03:21:08'),
(10, 2, 'SChjahsj', 'Wednesday', '09:00:00', '11:00:00', '213', 'iashdfasdf', '2025-10-20 03:23:17', '2025-10-20 03:23:17'),
(11, 2, 'VAGHFDGHA', 'Friday', '13:35:00', '20:35:00', 'GAHGJAF', 'AHGHJGHJF', '2025-10-20 05:36:33', '2025-10-20 06:02:50');

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `task_name` varchar(255) NOT NULL,
  `subject_name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `is_completed` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`id`, `user_id`, `task_name`, `subject_name`, `description`, `due_date`, `is_completed`, `created_at`) VALUES
(1, 2, 'Techno Pitching', 'TechnoPuta', 'Techno Pitching 5 Minutes', '2025-10-21', 1, '2025-10-19 16:40:52'),
(2, 2, 'HM', 'TechnoPuta', 'PutaPuta', '2025-10-21', 1, '2025-10-19 17:37:53'),
(3, 2, 'PutaTechno', 'PutaPuta', 'TechnoPuta', '2025-10-20', 1, '2025-10-19 17:38:28'),
(4, 5, 'Actriviyy', 'Math', 'HAHDAHDHA', '2026-10-20', 1, '2025-10-20 03:13:59'),
(5, 2, 'HABDHADHJ', 'ahshdjashjd', 'asbdjhbas', '2025-10-20', 1, '2025-10-20 06:04:59');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1, 'Chan', 'chan@gmail.com', '$2y$10$KKZBZkDk7/H3Mzo/s8FwSuncg5zAPxhONAIhS5ysR5PpLoo0uT7mW', '2025-10-19 11:17:54', '2025-10-19 11:17:54'),
(2, 'Chan', 'digmanchristian0@gmail.com', '$2y$10$svtC8AE/ZZ.KOmfickTNCuo3HY46lOnpNF1.kAdUT.MmbSr5rsZFS', '2025-10-19 11:50:42', '2025-10-19 11:50:42'),
(3, 'Chanchy', 'digmanchristian1@gmail.com', '$2y$10$K.Lv3EWD0/BaR14.lCiPOehw6B4WOksTPXg0Gylg/vQdejT4tYf6K', '2025-10-19 11:53:24', '2025-10-19 11:53:24'),
(4, 'Cii', 'cii@gmail.com', '$2y$10$DMdnyQKUY3rKvgG.TRCmJue2AJFTboBP8wWDTzhhUXo7OVBWq33.W', '2025-10-19 15:19:44', '2025-10-19 15:19:44'),
(5, 'Paragas', 'paragas@gmail.com', '$2y$10$joBhC1twzfmF8Iw/tOgzjOQQBk5jIH/apWO1OmLqTd/5H066PqwJO', '2025-10-20 03:06:44', '2025-10-20 03:06:44');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `schedules`
--
ALTER TABLE `schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_schedules` (`user_id`,`day_of_week`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `schedules`
--
ALTER TABLE `schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `schedules`
--
ALTER TABLE `schedules`
  ADD CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
