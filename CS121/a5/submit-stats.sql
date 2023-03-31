-- [Problem 1]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a sub_id, finds the minimum interval between submission times
-- Arguments: given_sub_id - INT
-- Returns: abs_min_interval - INT
CREATE FUNCTION min_submit_interval(given_sub_id INT)
RETURNS INT DETERMINISTIC
BEGIN

-- Declare marker for when loop is done
DECLARE done INT DEFAULT 0;
-- Declare time interval start variable
DECLARE int_start TIMESTAMP;
-- Declare time interval end variable
DECLARE int_end TIMESTAMP;
-- Declare temporary min time interval variable
DECLARE temp_min_interval INT;
-- Declare absolute min time interval variable
DECLARE abs_min_interval INT;

-- Declare cursor to go through each fileset's sub_dates where the sub_id
-- is equal to the given sub_id
DECLARE cur 
    CURSOR FOR
    SELECT sub_date
    FROM fileset
    WHERE sub_id = given_sub_id;
            
DECLARE CONTINUE 
    HANDLER FOR 
    NOT FOUND SET done = 1;

OPEN cur;
FETCH cur INTO int_start;
WHILE NOT done DO
    FETCH cur INTO int_end;
    IF NOT done THEN
        SET temp_min_interval = UNIX_TIMESTAMP(int_end) - 
            UNIX_TIMESTAMP(int_start);
        IF ISNULL(abs_min_interval) THEN
            SET abs_min_interval = temp_min_interval;
        ELSEIF temp_min_interval < abs_min_interval THEN
            SET abs_min_interval = temp_min_interval;
        END IF;
        SET int_start = int_end;
    END IF;
END WHILE;
CLOSE cur;

RETURN abs_min_interval;

END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 2]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a sub_id, finds the maximum interval between submission times
-- Arguments: given_sub_id - INT
-- Returns: abs_max_interval - INT
CREATE FUNCTION max_submit_interval(given_sub_id INT)
RETURNS INT DETERMINISTIC
BEGIN

-- Declare marker for when loop is done
DECLARE done INT DEFAULT 0;
-- Declare time interval start variable
DECLARE int_start TIMESTAMP;
-- Declare time interval end variable
DECLARE int_end TIMESTAMP;
-- Declare temporary max time interval variable
DECLARE temp_max_interval INT;
-- Declare absolute max time interval variable
DECLARE abs_max_interval INT;

-- Declare cursor to go through each fileset's sub_dates where the sub_id
-- is equal to the given sub_id
DECLARE cur 
    CURSOR FOR
    SELECT sub_date
    FROM fileset
    WHERE sub_id = given_sub_id;
            
DECLARE CONTINUE 
    HANDLER FOR 
    NOT FOUND SET done = 1;

OPEN cur;
FETCH cur INTO int_start;
WHILE NOT done DO
    FETCH cur INTO int_end;
    IF NOT done THEN
        SET temp_max_interval = UNIX_TIMESTAMP(int_end) - 
            UNIX_TIMESTAMP(int_start);
        IF ISNULL(abs_max_interval) THEN
            SET abs_max_interval = temp_max_interval;
        ELSEIF temp_max_interval > abs_max_interval THEN
            SET abs_max_interval = temp_max_interval;
        END IF;
        SET int_start = int_end;
    END IF;
END WHILE;
CLOSE cur;

RETURN abs_max_interval;

END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 3]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a sub_id, finds the average interval between submission times
-- Arguments: given_sub_id - INT
-- Returns: avg_interval - DOUBLE
CREATE FUNCTION avg_submit_interval(given_sub_id INT) 
RETURNS DOUBLE DETERMINISTIC
BEGIN

-- Declare average time interval variable
DECLARE avg_interval DOUBLE;

SELECT ((UNIX_TIMESTAMP(MAX(sub_date)) - UNIX_TIMESTAMP(MIN(sub_date)))
    /(COUNT(*) - 1)) INTO avg_interval
    FROM fileset
    WHERE sub_id = given_sub_id;
    
RETURN avg_interval;

END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 4]
-- Create an index on fileset for the sub_date
CREATE INDEX idx_sub_id
ON fileset (sub_id, sub_date);