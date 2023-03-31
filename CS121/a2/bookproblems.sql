-- [Problem 1a]
-- Select the names of all students enrolled in at least one comp sci course
USE university;
SELECT DISTINCT name 
FROM student 
    JOIN takes USING (id)
    JOIN (
        SELECT *
        FROM course 
        WHERE dept_name = 'Comp. Sci.'
	) AS comp_sci_course USING (course_id);

-- [Problem 1b]
-- Find the maximum salary for each department
SELECT dept_name, MAX(salary) AS max_salary
FROM instructor
    GROUP BY dept_name;

-- [Problem 1c]
-- Find the smallest of the maximum salaries for each department
SELECT MIN(max_salary) AS smallest_max_salary
FROM (
    SELECT MAX(salary) AS max_salary
    FROM instructor
        GROUP BY dept_name
) AS max_dept_salaries;

-- [Problem 1d]
-- Find the smallest of the maximum salaries for each department 
-- (using temporary table)
CREATE TEMPORARY TABLE dept_salaries(
SELECT MAX(salary) AS max_salary
    FROM instructor
        GROUP BY dept_name
);

SELECT MIN(max_salary) AS smallest_max_salary
FROM dept_salaries;

-- [Problem 2a]
-- create a new course with title = Weekly Seminar, code = CS-001, credits = 0
INSERT INTO course
VALUES ('CS-001', 'Weekly Seminar', 'Comp. Sci.', 0);

-- [Problem 2b]
-- create a section of CS-001 with sec_id = 1 in Winter 2023
INSERT INTO section (course_id, sec_id, semester, year)
VALUES ('CS-001', 1, 'Winter', 2023);

-- [Problem 2c]
-- enroll all students in Comp. Sci. department in section 1 of CS-001
INSERT INTO takes (id, course_id, sec_id, semester, year)
SELECT id, 'CS-001', 1, 'Winter', 2023
FROM student 
WHERE dept_name = 'Comp. Sci.';

-- [Problem 2d]
-- remove students from section 1 of CS-001 where name is Snow
-- i know that the year and sec_id are irrelevant (and semester), but felt 
-- like should get used to adding them
DELETE 
FROM takes
WHERE id 
    IN (
        SELECT id
        FROM student
        WHERE name = 'Snow'
    ) 
    AND course_id = 'CS-001'
    AND sec_id = '1'
    AND year = 2023;

-- [Problem 2e]
-- This logically is flawed since we do not want to delete a course before
-- deleting the sections.
-- This could also cause errors down the line when accessing information in
-- the section and takes tables, as we lose referential integrity and are 
-- attempting to access an "empty" course.
DELETE 
FROM course 
WHERE course_id = 'CS-001';

-- [Problem 2f]
-- Delete all tuples from takes where the word database is in the course title
DELETE
FROM takes
WHERE course_id 
    IN (
        SELECT course_id
        FROM course
        WHERE LOWER(title)
            LIKE '%database%'
    );

-- [Problem 3a]
-- Get the name of anyone who has borrowed a book by McGraw-Hill, ordered 
-- alphabetically
USE library;
SELECT DISTINCT name 
FROM member 
    NATURAL JOIN borrowed
    NATURAL JOIN (
        SELECT isbn 
        FROM book 
        WHERE publisher = 'McGraw-Hill'
    ) AS mcgraw_hill_books
ORDER BY name;

-- [Problem 3b]
-- Get the name of anyone who has borrowed all books published by McGraw-Hill,
-- ordered alphabetically
SELECT name
FROM (
        SELECT COUNT(*) AS num_mh_books
        FROM book
        WHERE publisher = 'McGraw-Hill'
    ) AS total_count_mh
    NATURAL JOIN (
        SELECT name, COUNT(*) AS num_mh_books
        FROM member 
            NATURAL JOIN borrowed
            NATURAL JOIN (
                SELECT isbn 
                FROM book 
                WHERE publisher = 'McGraw-Hill'
            ) AS mcgraw_hill_books
        GROUP BY name
    ) AS count_mh_borrowed
ORDER BY name;

-- [Problem 3c]
-- Get the names of members who have borrowed more than 5 books from any
-- publisher, sorted alphabetically
SELECT publisher, name
FROM member
    NATURAL JOIN book
    NATURAL JOIN borrowed
GROUP BY publisher, name 
HAVING COUNT(*) > 5
ORDER BY name;

-- [Problem 3d]
-- Find the average number of books borrowed across all members
SELECT AVG(num_borrowed_books) AS avg_num_books
FROM (
    SELECT COUNT(isbn) AS num_borrowed_books
    FROM member
        NATURAL LEFT JOIN borrowed
    GROUP BY memb_no
) AS member_borrowed_books;

-- [Problem 3e]
-- Find the average number of books borrowed across all members
-- (using temporary table)
CREATE TEMPORARY TABLE memb_counts(
    SELECT COUNT(isbn) AS num_borrowed_books
    FROM member
        NATURAL LEFT JOIN borrowed
    GROUP BY memb_no
);

SELECT AVG(num_borrowed_books) AS avg_num_books
FROM memb_counts;
