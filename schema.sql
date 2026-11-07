-- ============================================================================
--  schema.sql | Structure of the MySQL Academy practice database
--  Requires MySQL 8.0.16 or later (CHECK constraints are enforced).
--
--  Run on its own:   mysql -u root -p < schema.sql
--  Then load data:   mysql -u root -p < data.sql
--  Or do both at once with academy.sql.
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
    instructor_id INT UNSIGNED   NOT NULL AUTO_INCREMENT,
    first_name    VARCHAR(50)    NOT NULL,
    last_name     VARCHAR(50)    NOT NULL,
    email         VARCHAR(120)   NOT NULL,
    hired_on      DATE           NOT NULL,
    salary        DECIMAL(10,2)  NOT NULL,
    PRIMARY KEY (instructor_id),
    CONSTRAINT uq_instructors_email UNIQUE (email),
    CONSTRAINT chk_instructors_salary CHECK (salary >= 0),
    CONSTRAINT chk_instructors_email  CHECK (email LIKE '_%@_%.__%')
) ENGINE = InnoDB
  COMMENT = 'People who teach courses';

CREATE TABLE students (
    student_id  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    first_name  VARCHAR(50)   NOT NULL,
    last_name   VARCHAR(50)   NOT NULL,
    email       VARCHAR(120)  NOT NULL,
    city        VARCHAR(60)   NOT NULL,
    birth_date  DATE          NOT NULL,
    joined_on   DATE          NOT NULL,
    PRIMARY KEY (student_id),
    CONSTRAINT uq_students_email UNIQUE (email),
    CONSTRAINT chk_students_email CHECK (email LIKE '_%@_%.__%'),
    CONSTRAINT chk_students_dates CHECK (birth_date < joined_on)
) ENGINE = InnoDB
  COMMENT = 'People who take courses';

CREATE TABLE courses (
    course_id     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    title         VARCHAR(120)  NOT NULL,
    category      VARCHAR(40)   NOT NULL,
    price         DECIMAL(8,2)  NOT NULL,
    instructor_id INT UNSIGNED  NOT NULL,
    is_published  BOOLEAN       NOT NULL DEFAULT TRUE,
    PRIMARY KEY (course_id),
    CONSTRAINT uq_courses_title UNIQUE (title),
    CONSTRAINT chk_courses_price CHECK (price >= 0),
    -- An instructor who still has courses cannot be deleted by accident.
    CONSTRAINT fk_courses_instructor
        FOREIGN KEY (instructor_id) REFERENCES instructors (instructor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Courses offered, each taught by one instructor';

CREATE TABLE enrollments (
    enrollment_id INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    student_id    INT UNSIGNED  NOT NULL,
    course_id     INT UNSIGNED  NOT NULL,
    enrolled_on   DATE          NOT NULL,
    grade         DECIMAL(5,2)  NULL,
    status        ENUM('active', 'completed', 'dropped') NOT NULL DEFAULT 'active',
    PRIMARY KEY (enrollment_id),
    -- A student can enrol in a given course only once.
    CONSTRAINT uq_student_course UNIQUE (student_id, course_id),
    CONSTRAINT chk_enrollments_grade CHECK (grade IS NULL OR grade BETWEEN 0 AND 100),
    -- Only completed enrollments carry a grade.
    CONSTRAINT chk_enrollments_status_grade CHECK (
        (status = 'completed' AND grade IS NOT NULL)
        OR (status <> 'completed' AND grade IS NULL)
    ),
    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id) REFERENCES students (student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id) REFERENCES courses (course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Which student took which course, with outcome';

-- ----------------------------------------------------------------------------
-- Indexes (used in Lesson 05 and in the performance section of the course)
-- The primary keys, unique keys and foreign keys above already create indexes.
-- ----------------------------------------------------------------------------

CREATE INDEX idx_students_city      ON students (city);
CREATE INDEX idx_courses_category   ON courses (category);
CREATE INDEX idx_enrollments_course ON enrollments (course_id);

-- ----------------------------------------------------------------------------
-- Views (handy for practice queries; try SELECT * FROM v_course_stats;)
-- ----------------------------------------------------------------------------

CREATE VIEW v_course_stats AS
SELECT
    c.course_id,
    c.title,
    c.category,
    c.price,
    c.is_published,
    CONCAT(i.first_name, ' ', i.last_name)        AS instructor,
    COUNT(e.enrollment_id)                        AS total_enrollments,
    COALESCE(SUM(e.status = 'completed'), 0)      AS completed_count,
    ROUND(AVG(e.grade), 2)                        AS avg_grade
FROM courses AS c
JOIN instructors AS i ON i.instructor_id = c.instructor_id
LEFT JOIN enrollments AS e ON e.course_id = c.course_id
GROUP BY c.course_id, c.title, c.category, c.price, c.is_published,
         i.first_name, i.last_name;

CREATE VIEW v_student_progress AS
SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name)        AS student,
    s.city,
    COUNT(e.enrollment_id)                        AS courses_taken,
    COALESCE(SUM(e.status = 'completed'), 0)      AS courses_completed,
    ROUND(AVG(e.grade), 2)                        AS avg_grade
FROM students AS s
LEFT JOIN enrollments AS e ON e.student_id = s.student_id
GROUP BY s.student_id, s.first_name, s.last_name, s.city;
