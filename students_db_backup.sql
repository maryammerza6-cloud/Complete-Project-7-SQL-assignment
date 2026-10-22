/* ==========================================================================
   students_db_backup.sql
   CIS 4720 Database Management and SQL

   WHAT THIS FILE IS
   A starter database for in_class_lab7b. It builds a schema called
   students_db holding one table of students, plus a view. The lab PCs are
   wiped every night, so a script like this one is how you get a working
   database back in a few seconds instead of typing it all again. The file
   is the database. The server is disposable.

   WHAT IT BUILDS
     1. A schema called students_db
     2. One table, STUDENT, with six columns and a primary key
     3. Five rows of data
     4. One view, STUDENT_GPA, showing just the names and the grade averages

   BEFORE YOU RUN IT
   The schema has to exist before VS Code can connect to it, and VS Code
   will not create one for you. Step 4 of the lab has you create it at the
   command prompt first. Do that step before you open VS Code.

   HOW TO RUN IT
   Open it in VS Code with SQLTools connected to students_db, then run the
   whole file. Lab7b walks you through it.

   READ THIS BEFORE YOU RUN IT A SECOND TIME
   Run it once and everything works. Run it twice and you get errors,
   because the table already exists and the rows are already there. Step 10
   of the lab explains which parts to comment out and why.
   ========================================================================== */


-- ======================================================================
-- SECTION 1. The schema
-- A schema is the container that holds your tables. CREATE DATABASE makes
-- one, and USE tells the server which one the statements below apply to.
-- ======================================================================

-- Create the schema. IF NOT EXISTS means this line is safe to run twice,
-- and safe to run even though you already made it at the command prompt.
CREATE DATABASE IF NOT EXISTS students_db;

-- Switch into it. Everything below lands inside this schema.
USE students_db;


-- ======================================================================
-- SECTION 2. The table
-- Each column gets a data type that fits what it holds:
--   INT           whole numbers, used here for the id
--   VARCHAR(30)   text up to 30 characters
--   DECIMAL(3,2)  a number with 1 digit before the point and 2 after,
--                 which is exactly the shape of a grade average
--   DATE          a real date, stored as YYYY-MM-DD
-- NOT NULL means the column may never be left empty.
-- PRIMARY KEY means student_id must be unique and may never be empty.
-- ======================================================================

CREATE TABLE STUDENT (
    student_id  INT          NOT NULL,
    first_name  VARCHAR(30)  NOT NULL,
    last_name   VARCHAR(30)  NOT NULL,
    major       VARCHAR(40),
    gpa         DECIMAL(3,2),
    enrolled_on DATE,
    PRIMARY KEY (student_id)
);


-- ======================================================================
-- SECTION 3. The data
-- Five students. Two enrolled in the same term, which is useful later when
-- you start filtering on a date.
-- ======================================================================

INSERT INTO STUDENT VALUES (1,'Ana',   'Reyes', 'CIS',              3.75,'2025-08-25');
INSERT INTO STUDENT VALUES (2,'Marcus','Bell',  'Computer Science', 3.20,'2025-08-25');
INSERT INTO STUDENT VALUES (3,'Priya', 'Nair',  'Mathematics',      3.90,'2026-01-12');
INSERT INTO STUDENT VALUES (4,'Devon', 'Rao',   'CIS',              2.85,'2026-01-12');
INSERT INTO STUDENT VALUES (5,'Elena', 'Vargas','Business',         3.45,'2026-08-24');


-- ======================================================================
-- SECTION 4. The view
-- A view is a stored SELECT statement you can query as if it were a table.
-- This one shows only the names and the grade average, so anyone using it
-- cannot reach the id, the major or the enrollment date.
-- ======================================================================

CREATE VIEW STUDENT_GPA AS
SELECT first_name, last_name, gpa
FROM STUDENT;


-- ======================================================================
-- SECTION 5. Checks
-- These only read. They are safe to run as many times as you like, so
-- leave them switched on even after the first run.
-- ======================================================================

-- All five rows, straight from the table.
SELECT * FROM STUDENT;

-- The view, highest grade average first. Three columns, not six.
SELECT * FROM STUDENT_GPA ORDER BY gpa DESC;

-- Should come back as 5 students and an average of 3.43.
SELECT COUNT(*) AS students, ROUND(AVG(gpa), 2) AS average_gpa FROM STUDENT;

-- STUDENT is a BASE TABLE and STUDENT_GPA is a VIEW. SHOW TABLES on its
-- own does not tell them apart, which is why this one says FULL.
SHOW FULL TABLES;


-- ######################################################################
-- YOUR LAB7B WORK STARTS BELOW THIS LINE
--
-- Add your Chapter 5 statements under the headings below, in order. Put a
-- comment above every statement saying what it does, in your own words.
-- The comments are graded.
-- ######################################################################


-- STEP 11. Section 5.1, look at your schema

-- PROJECT 7 STEP 11. Join two, the outer join

-- Include all students, even those who are taking no courses.
SELECT s.first_name,
       s.last_name,
       COUNT(e.course_id) AS courses_taken
FROM STUDENT s
LEFT JOIN ENROLLMENT e
ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY courses_taken DESC, s.last_name;

-- Find any courses that currently have no enrolled students.
SELECT c.course_code,
       c.course_title
FROM COURSE c
LEFT JOIN ENROLLMENT e
ON c.course_id = e.course_id
WHERE e.student_id IS NULL;


-- STEP 12. Section 5.2, look at the data types


-- PROJECT 7 STEP 12. View one, STUDENT_SCHEDULE

-- Save the combined student schedule for future use.
CREATE VIEW STUDENT_SCHEDULE AS
SELECT s.first_name,
       s.last_name,
       c.course_code,
       c.course_title,
       e.term,
       e.grade
FROM STUDENT s
JOIN ENROLLMENT e
ON s.student_id = e.student_id
JOIN COURSE c
ON e.course_id = c.course_id;

-- Display every student's course schedule.
SELECT * FROM STUDENT_SCHEDULE;

-- Check the classes taken by the student named Reyes.
SELECT * FROM STUDENT_SCHEDULE
WHERE last_name = 'Reyes';

-- Find enrollments in the database management course.
SELECT * FROM STUDENT_SCHEDULE
WHERE course_code = 'CIS4720';

-- STEP 13. Section 5.3, create a table by copying with a subquery

-- PROJECT 7 STEP 13. View two, COURSE_HEADCOUNT

-- Keep track of class enrollment totals, including classes with zero students.
CREATE VIEW COURSE_HEADCOUNT AS
SELECT c.course_code,
       c.course_title,
       COUNT(e.student_id) AS students_enrolled
FROM COURSE c
LEFT JOIN ENROLLMENT e
ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title;

-- List all courses from most enrolled to least enrolled.
SELECT * FROM COURSE_HEADCOUNT
ORDER BY students_enrolled DESC;

-- Confirm which database objects are tables and which are views.
SHOW FULL TABLES;


-- STEP 14. Section 5.4, change the structure of the copy


-- STEP 15. Section 5.5, insert, update and delete a row


-- STEP 16. Section 5.6, create a view and update through it



-- PROJECT 7 STEP 6. Create the COURSE table

-- Store the course details and give each course a unique ID.
CREATE TABLE COURSE (
    course_id INT NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_title VARCHAR(50) NOT NULL,
    credits INT,
    dept VARCHAR(30),
    PRIMARY KEY (course_id)
);

-- Check that the course ID is the primary key.
DESCRIBE COURSE;
-- PROJECT 7 STEP 7. Add rows to COURSE

-- Check whether any courses are already saved.
SELECT * FROM COURSE;

-- PROJECT 7 STEP 8. Create the ENROLLMENT table

-- Connect students to courses and prevent duplicate enrollments.
CREATE TABLE ENROLLMENT (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    term VARCHAR(15),
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);

-- Check the table structure and its keys.
DESCRIBE ENROLLMENT;

-- PROJECT 7 STEP 9. Add rows to ENROLLMENT

-- Add Ana to database management.
INSERT INTO ENROLLMENT VALUES (1,101,'Fall 2026','A');

-- Add Ana to programming.
INSERT INTO ENROLLMENT VALUES (1,102,'Fall 2026','B');

-- Add Ana to calculus.
INSERT INTO ENROLLMENT VALUES (1,103,'Spring 2026','A');

-- Add Marcus to database management.
INSERT INTO ENROLLMENT VALUES (2,101,'Fall 2026','B');

-- Add Marcus to management.
INSERT INTO ENROLLMENT VALUES (2,104,'Fall 2026','C');

-- Add Priya to database management.
INSERT INTO ENROLLMENT VALUES (3,101,'Fall 2026','A');

-- Add Priya to calculus.
INSERT INTO ENROLLMENT VALUES (3,103,'Spring 2026','A');

-- Add Devon to programming.
INSERT INTO ENROLLMENT VALUES (4,102,'Fall 2026','C');

-- Check that eight enrollments were saved.
SELECT COUNT(*) AS enrollment_rows FROM ENROLLMENT;

-- Test 1: A student who does not exist should be rejected.
INSERT INTO ENROLLMENT VALUES (99,101,'Fall 2026','A');

-- Test 2: A course that does not exist should be rejected.
INSERT INTO ENROLLMENT VALUES (1,999,'Fall 2026','A');

-- Test 3: A duplicate enrollment should be rejected.
INSERT INTO ENROLLMENT VALUES (1,101,'Spring 2027','B');

-- PROJECT 7 STEP 10. Join one, the three table join

-- Show which courses each student takes, including their names,
-- course titles, semesters, and grades.
SELECT s.first_name, s.last_name,
       c.course_code, c.course_title,
       e.term, e.grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id
ORDER BY s.last_name, c.course_code;


-- PROJECT 7 STEP 11. Join two, the outer join

-- Count how many classes each student takes,
-- including students who are not enrolled.
SELECT s.first_name, s.last_name,
       COUNT(e.course_id) AS courses_taken
FROM STUDENT s
LEFT JOIN ENROLLMENT e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY courses_taken DESC, s.last_name;

-- Find courses that have no students enrolled.
SELECT c.course_code, c.course_title
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.course_id = e.course_id
WHERE e.student_id IS NULL;

-- PROJECT 7 STEP 12. View one, STUDENT_SCHEDULE

-- Save student schedules so we can see their
-- classes and grades without writing joins again.
CREATE VIEW STUDENT_SCHEDULE AS
SELECT s.first_name, s.last_name,
       c.course_code, c.course_title,
       e.term, e.grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id;

-- Display all student schedules.
SELECT * FROM STUDENT_SCHEDULE;

-- Find all classes taken by Ana Reyes.
SELECT * FROM STUDENT_SCHEDULE
WHERE last_name = 'Reyes';

-- Find students taking database management.
SELECT * FROM STUDENT_SCHEDULE
WHERE course_code = 'CIS4720';

-- PROJECT 7 STEP 13. View two, COURSE_HEADCOUNT

-- Save the number of students in each class,
-- including classes with no students.
CREATE VIEW COURSE_HEADCOUNT AS
SELECT c.course_code, c.course_title,
       COUNT(e.student_id) AS students_enrolled
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title;

-- Display classes from most students to least.
SELECT * FROM COURSE_HEADCOUNT
ORDER BY students_enrolled DESC;

-- Confirm that the new tables and views exist.
SHOW FULL TABLES;
