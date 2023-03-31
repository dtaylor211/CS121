-- [Problem 1a]
-- compute a perfect score for the course
SELECT SUM(perfectscore) AS perfect_total
FROM assignment;


-- [Problem 1b]
-- get every section name and the number of students in that section,
-- ordered by section name
SELECT sec_name, COUNT(username) AS num_students
FROM section 
    NATURAL JOIN student
GROUP BY sec_name
ORDER BY sec_name;


-- [Problem 1c]
-- view containing each student's username and the total score for that
-- student, ordered by student username
CREATE VIEW score_totals AS
SELECT username, SUM(score) AS total_score
FROM student
    NATURAL LEFT JOIN submission
WHERE graded = 1
GROUP BY username
ORDER BY username;


-- [Problem 1d]
-- view containing student's username and total score if the student
-- is passing, ordered from highest to lowest score, then by username
CREATE VIEW passing AS
SELECT *
FROM score_totals
WHERE total_score >= 40
ORDER BY - total_score, username;


-- [Problem 1e]
-- view containing student's username and total score if the studnet
-- is failing, ordered from highest to lowest score, then by username
CREATE VIEW failing AS
SELECT *
FROM score_totals
WHERE total_score < 40
ORDER BY -total_score, username;


-- [Problem 1f]
-- get usernames of all students who did not submit at least one lab,
-- but still passed the course
-- Results : harris, ross, miller, turner, edwards, murphy, simmons,
--      tucker, coleman, flores, gibson
SELECT username
FROM passing 
    NATURAL JOIN (
        SELECT asn_id, sub_id, username
        FROM assignment
            NATURAL JOIN submission
        WHERE shortname LIKE 'lab%'
    ) AS labs
WHERE sub_id 
    NOT IN (
        SELECT sub_id
        FROM fileset
    );


-- [Problem 1g]
-- get usernames of all students who did not submit the midterm or final,
-- but still passed the course
-- Results : collins
SELECT username
FROM passing
    NATURAL JOIN (
        SELECT asn_id, sub_id, username
        FROM assignment
            NATURAL JOIN submission
        WHERE shortname LIKE 'final%'
            OR shortname LIKE 'midterm%'
    ) AS exams
WHERE sub_id
    NOT IN (
        SELECT sub_id
        FROM fileset
    );


-- [Problem 2a]
-- get the usernames of all students who turned in the midterm
-- after the due date
SELECT DISTINCT username
FROM (
    SELECT asn_id, sub_id, username, due
    FROM assignment
        NATURAL JOIN submission 
        NATURAL LEFT JOIN fileset
    WHERE shortname 
        LIKE 'midterm%'
    AND sub_date > due
    ) AS midterms;


-- [Problem 2b]
-- get the number of labs that are submitted for each hour in the day
SELECT EXTRACT(HOUR FROM sub_date) AS submit_hour, 
    COUNT(sub_id) AS num_submits
FROM assignment
    NATURAL JOIN submission
    NATURAL JOIN fileset
WHERE shortname
    LIKE 'lab%'
GROUP BY submit_hour
ORDER BY submit_hour;



-- [Problem 2c]
-- get the total number of final exams submitted in the 30 minutes 
-- before the exam was due
SELECT COUNT(sub_id) AS num_submits
FROM assignment
    NATURAL JOIN submission
    NATURAL JOIN fileset
WHERE shortname
    LIKE 'final%'
AND sub_date 
    BETWEEN due - INTERVAL 30 MINUTE 
    AND due;

-- [Problem 3a]
-- add email column to student table, populate the email column, 
-- and set email to be non-null
ALTER TABLE student
ADD email VARCHAR(200)
AFTER username;

UPDATE student
SET email = CONCAT(username, '@school.edu');
    
ALTER TABLE student
MODIFY COLUMN email VARCHAR(200) NOT NULL;


-- [Problem 3b]
-- add submit_files column to assignment table of type TINYINT with
-- default value = 1
ALTER TABLE assignment
ADD submit_files TINYINT DEFAULT 1
AFTER longname;
    
UPDATE assignment
SET submit_files = 0 
WHERE shortname 
    LIKE 'dq%';


-- [Problem 3c]
-- gradescheme: table containing information about an individual gradescheme
CREATE TABLE gradescheme (
    -- id of the grade scheme
    scheme_id INT NOT NULL,
    -- description of the grade scheme, varying length up to 100 characters
    scheme_desc VARCHAR(100) NOT NULL,
    -- primary key of gradescheme is scheme id
    PRIMARY KEY (scheme_id)
);

-- insert identifiers into the gradescheme table
INSERT INTO gradescheme
VALUES
    (0, 'Lab assignment with min-grading.'),
    (1, 'Daily quiz.'),
    (2, 'Midterm or final exam.');
    
ALTER TABLE assignment
RENAME COLUMN gradescheme TO scheme_id;

ALTER TABLE assignment
MODIFY COLUMN scheme_id INT NOT NULL;

ALTER TABLE assignment
ADD FOREIGN KEY (scheme_id) 
    REFERENCES gradescheme(scheme_id);

