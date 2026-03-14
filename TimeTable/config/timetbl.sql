-- Create database (if not using timetbl database)
CREATE DATABASE IF NOT EXISTS timetbl;
USE timetbl;

-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Schedules table for timetable
-- IMPORTANT: Column names changed to match the Flutter app expectations
CREATE TABLE IF NOT EXISTS schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject_name VARCHAR(200) NOT NULL,        -- Changed from 'title' to 'subject_name'
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room_number VARCHAR(100),                  -- Changed from 'room' to 'room_number'
    teacher_name VARCHAR(100),                 -- Added teacher_name column
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create indexes for faster queries
CREATE INDEX idx_user_schedules ON schedules(user_id, day_of_week);
CREATE INDEX idx_email ON users(email);

-- Optional: Add some sample data for testing (replace user_id = 1 with your actual user ID after registration)
-- Uncomment the lines below if you want sample data:

-- INSERT INTO schedules (user_id, subject_name, day_of_week, start_time, end_time, room_number, teacher_name) VALUES
-- (1, 'Mathematics', 'Monday', '09:00:00', '10:30:00', '301', 'Mr. Smith'),
-- (1, 'Physics', 'Monday', '11:00:00', '12:30:00', '205', 'Dr. Johnson'),
-- (1, 'Chemistry', 'Tuesday', '08:00:00', '09:30:00', '401', 'Mrs. Williams'),
-- (1, 'English', 'Tuesday', '10:00:00', '11:30:00', '102', 'Ms. Brown'),
-- (1, 'Biology', 'Wednesday', '09:00:00', '10:30:00', '304', 'Dr. Davis'),
-- (1, 'History', 'Wednesday', '14:00:00', '15:30:00', '201', 'Mr. Garcia'),
-- (1, 'Computer Science', 'Thursday', '09:00:00', '10:30:00', '501', 'Dr. Martinez'),
-- (1, 'Geography', 'Thursday', '11:00:00', '12:30:00', '203', 'Ms. Rodriguez'),
-- (1, 'Music', 'Friday', '10:00:00', '11:30:00', '101', 'Mrs. Lee'),
-- (1, 'Physical Education', 'Friday', '14:00:00', '15:30:00', 'Gym', 'Coach Wilson');