-- ============================================================================
--  data.sql | Sample data for the MySQL Academy practice database
--  Run after schema.sql:   mysql -u root -p < data.sql
-- ============================================================================

USE academy_db;

START TRANSACTION;

-- IDs are given explicitly so the lessons always see the same rows.

INSERT INTO instructors (instructor_id, first_name, last_name, email, hired_on, salary) VALUES
(1, 'Grace', 'Namutebi', 'grace.namutebi@academy.example', '2019-02-11', 3200.00),
(2, 'David', 'Okello',   'david.okello@academy.example',   '2020-07-01', 2900.00),
(3, 'Amina', 'Hassan',   'amina.hassan@academy.example',   '2021-01-15', 3500.00),
(4, 'Peter', 'Mugisha',  'peter.mugisha@academy.example',  '2022-09-05', 2700.00);

INSERT INTO students (student_id, first_name, last_name, email, city, birth_date, joined_on) VALUES
(1,  'Brian',   'Ssemakula', 'brian.s@student.example',   'Kampala', '2003-04-12', '2025-09-01'),
(2,  'Sarah',   'Nakato',    'sarah.n@student.example',   'Mukono',  '2002-11-30', '2025-09-01'),
(3,  'Isaac',   'Wanyama',   'isaac.w@student.example',   'Entebbe', '2004-06-21', '2025-10-15'),
(4,  'Lydia',   'Atim',      'lydia.a@student.example',   'Gulu',    '2001-01-08', '2024-02-10'),
(5,  'Kevin',   'Mutesi',    'kevin.m@student.example',   'Jinja',   '2003-09-17', '2025-01-20'),
(6,  'Faith',   'Akello',    'faith.a@student.example',   'Kampala', '2000-03-03', '2024-09-02'),
(7,  'Moses',   'Kiggundu',  'moses.k@student.example',   'Mbarara', '2002-07-25', '2025-02-14'),
(8,  'Esther',  'Nabirye',   'esther.n@student.example',  'Kampala', '2004-12-09', '2025-09-01'),
(9,  'Ronald',  'Tumwesige', 'ronald.t@student.example',  'Mukono',  '2001-05-19', '2024-09-02'),
(10, 'Cynthia', 'Achieng',   'cynthia.a@student.example', 'Nairobi', '2003-08-14', '2025-10-01');

INSERT INTO courses (course_id, title, category, price, instructor_id, is_published) VALUES
(1, 'MySQL Fundamentals',          'Databases',   49.99, 1, TRUE),
(2, 'Advanced SQL Queries',        'Databases',   79.99, 1, TRUE),
(3, 'Data Modeling Basics',        'Databases',   59.99, 3, TRUE),
(4, 'Python for Data Analysis',    'Programming', 89.99, 2, TRUE),
(5, 'Web Development Essentials',  'Web',         69.99, 4, TRUE),
(6, 'Intro to Cybersecurity',      'Security',    99.99, 3, TRUE),
(7, 'Database Security Hardening', 'Security',   109.99, 4, FALSE);

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrolled_on, grade, status) VALUES
(1,  1,  1, '2025-09-02', 78.50, 'completed'),
(2,  1,  2, '2025-10-01', NULL,  'active'),
(3,  2,  1, '2025-09-02', 91.00, 'completed'),
(4,  2,  3, '2025-09-10', 85.50, 'completed'),
(5,  3,  1, '2025-10-16', NULL,  'active'),
(6,  4,  4, '2024-02-12', 66.00, 'completed'),
(7,  4,  1, '2024-03-01', NULL,  'dropped'),
(8,  5,  4, '2025-01-22', 88.00, 'completed'),
(9,  5,  1, '2025-02-01', 74.00, 'completed'),
(10, 6,  5, '2024-09-05', 95.50, 'completed'),
(11, 6,  6, '2025-03-10', NULL,  'active'),
(12, 7,  1, '2025-02-16', 58.00, 'completed'),
(13, 7,  2, '2025-03-01', NULL,  'active'),
(14, 8,  4, '2025-09-03', NULL,  'active'),
(15, 8,  6, '2025-09-03', NULL,  'active'),
(16, 9,  5, '2024-09-04', 72.50, 'completed'),
(17, 10, 6, '2025-10-02', NULL,  'active'),
(18, 10, 3, '2025-10-02', NULL,  'active');

COMMIT;

-- ----------------------------------------------------------------------------
-- Verify the setup: each table should show its expected count and "OK".
-- ----------------------------------------------------------------------------

SELECT 'instructors' AS table_name, COUNT(*) AS row_count, 4  AS expected,
       IF(COUNT(*) = 4,  'OK', 'CHECK') AS result FROM instructors
UNION ALL
SELECT 'students',    COUNT(*), 10, IF(COUNT(*) = 10, 'OK', 'CHECK') FROM students
UNION ALL
SELECT 'courses',     COUNT(*), 7,  IF(COUNT(*) = 7,  'OK', 'CHECK') FROM courses
UNION ALL
SELECT 'enrollments', COUNT(*), 18, IF(COUNT(*) = 18, 'OK', 'CHECK') FROM enrollments;
