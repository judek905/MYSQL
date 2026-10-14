-- ============================================================================
--  academy.sql | Practice database for MySQL Academy
--  Requires MySQL 8.0.16 or later (CHECK constraints are enforced).
--
--  Load it from your terminal:
--      mysql -u root -p < academy.sql
--
--  Then open the database:
--      mysql -u root -p academy_db
--
--  WARNING: this script drops and recreates a database named academy_db.
--           Do not run it against data you need to keep.
-- ============================================================================

DROP DATABASE IF EXISTS academy_db;

CREATE DATABASE academy_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE academy_db;

-- ----------------------------------------------------------------------------
-- Tables
-- ----------------------------------------------------------------------------

CREATE TABLE instructors (
    instructor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50)   NOT NULL,
    last_name     VARCHAR(50)   NOT NULL,
    email         VARCHAR(120)  NOT NULL UNIQUE,
    hired_on      DATE          NOT NULL,
    salary        DECIMAL(10,2) NOT NULL CHECK (salary >= 0)
) ENGINE = InnoDB;

CREATE TABLE students (
    student_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(50)  NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    email       VARCHAR(120) NOT NULL UNIQUE,
    city        VARCHAR(60)  NOT NULL,
    birth_date  DATE         NOT NULL,
    joined_on   DATE         NOT NULL
) ENGINE = InnoDB;

CREATE TABLE courses (
    course_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(120)  NOT NULL,
    category      VARCHAR(40)   NOT NULL,
    price         DECIMAL(8,2)  NOT NULL CHECK (price >= 0),
    instructor_id INT UNSIGNED  NOT NULL,
    is_published  BOOLEAN       NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_courses_instructor
        FOREIGN KEY (instructor_id) REFERENCES instructors (instructor_id)
) ENGINE = InnoDB;

CREATE TABLE enrollments (
    enrollment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    student_id    INT UNSIGNED NOT NULL,
    course_id     INT UNSIGNED NOT NULL,
    enrolled_on   DATE         NOT NULL,
    grade         DECIMAL(5,2) NULL,
    status        ENUM('active', 'completed', 'dropped') NOT NULL DEFAULT 'active',
    CONSTRAINT uq_student_course UNIQUE (student_id, course_id),
    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id) REFERENCES courses (course_id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- ----------------------------------------------------------------------------
-- Indexes (used in Lesson 05 and in the performance section of the course)
-- ----------------------------------------------------------------------------

CREATE INDEX idx_students_city      ON students (city);
CREATE INDEX idx_courses_category   ON courses (category);
CREATE INDEX idx_enrollments_course ON enrollments (course_id);

-- ----------------------------------------------------------------------------
-- Sample data
-- ----------------------------------------------------------------------------

INSERT INTO instructors (first_name, last_name, email, hired_on, salary) VALUES
('Grace', 'Namutebi', 'grace.namutebi@academy.example', '2019-02-11', 3200.00),
('David', 'Okello',   'david.okello@academy.example',   '2020-07-01', 2900.00),
('Amina', 'Hassan',   'amina.hassan@academy.example',   '2021-01-15', 3500.00),
('Peter', 'Mugisha',  'peter.mugisha@academy.example',  '2022-09-05', 2700.00);

INSERT INTO students (first_name, last_name, email, city, birth_date, joined_on) VALUES
('Brian',   'Ssemakula', 'brian.s@student.example',   'Kampala', '2003-04-12', '2025-09-01'),
('Sarah',   'Nakato',    'sarah.n@student.example',   'Mukono',  '2002-11-30', '2025-09-01'),
('Isaac',   'Wanyama',   'isaac.w@student.example',   'Entebbe', '2004-06-21', '2025-10-15'),
('Lydia',   'Atim',      'lydia.a@student.example',   'Gulu',    '2001-01-08', '2024-02-10'),
('Kevin',   'Mutesi',    'kevin.m@student.example',   'Jinja',   '2003-09-17', '2025-01-20'),
('Faith',   'Akello',    'faith.a@student.example',   'Kampala', '2000-03-03', '2024-09-02'),
('Moses',   'Kiggundu',  'moses.k@student.example',   'Mbarara', '2002-07-25', '2025-02-14'),
('Esther',  'Nabirye',   'esther.n@student.example',  'Kampala', '2004-12-09', '2025-09-01'),
('Ronald',  'Tumwesige', 'ronald.t@student.example',  'Mukono',  '2001-05-19', '2024-09-02'),
('Cynthia', 'Achieng',   'cynthia.a@student.example', 'Nairobi', '2003-08-14', '2025-10-01');

INSERT INTO courses (title, category, price, instructor_id, is_published) VALUES
('MySQL Fundamentals',         'Databases',   49.99, 1, TRUE),
('Advanced SQL Queries',       'Databases',   79.99, 1, TRUE),
('Data Modeling Basics',       'Databases',   59.99, 3, TRUE),
('Python for Data Analysis',   'Programming', 89.99, 2, TRUE),
('Web Development Essentials', 'Web',         69.99, 4, TRUE),
('Intro to Cybersecurity',     'Security',    99.99, 3, TRUE),
('Database Security Hardening','Security',   109.99, 4, FALSE);

INSERT INTO enrollments (student_id, course_id, enrolled_on, grade, status) VALUES
(1,  1, '2025-09-02', 78.50, 'completed'),
(1,  2, '2025-10-01', NULL,  'active'),
(2,  1, '2025-09-02', 91.00, 'completed'),
(2,  3, '2025-09-10', 85.50, 'completed'),
(3,  1, '2025-10-16', NULL,  'active'),
(4,  4, '2024-02-12', 66.00, 'completed'),
(4,  1, '2024-03-01', NULL,  'dropped'),
(5,  4, '2025-01-22', 88.00, 'completed'),
(5,  1, '2025-02-01', 74.00, 'completed'),
(6,  5, '2024-09-05', 95.50, 'completed'),
(6,  6, '2025-03-10', NULL,  'active'),
(7,  1, '2025-02-16', 58.00, 'completed'),
(7,  2, '2025-03-01', NULL,  'active'),
(8,  4, '2025-09-03', NULL,  'active'),
(8,  6, '2025-09-03', NULL,  'active'),
(9,  5, '2024-09-04', 72.50, 'completed'),
(10, 6, '2025-10-02', NULL,  'active'),
(10, 3, '2025-10-02', NULL,  'active');

-- ----------------------------------------------------------------------------
-- Verify the setup: you should see 4, 10, 7 and 18 rows.
-- ----------------------------------------------------------------------------

SELECT 'instructors' AS table_name, COUNT(*) AS row_count FROM instructors
UNION ALL
SELECT 'students',    COUNT(*) FROM students
UNION ALL
SELECT 'courses',     COUNT(*) FROM courses
UNION ALL
SELECT 'enrollments', COUNT(*) FROM enrollments;
