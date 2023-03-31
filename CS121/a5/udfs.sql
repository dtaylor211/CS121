-- [Problem 1a]
-- Given: Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a date value, returns 1 if it is a weekend, 0 if weekday
CREATE FUNCTION is_weekend (d DATE) RETURNS TINYINT DETERMINISTIC
BEGIN

-- DAYOFWEEK returns 7 for Saturday, 1 for Sunday
IF DAYOFWEEK(d) = 7 OR DAYOFWEEK(d) = 1
   THEN RETURN 1;
ELSE RETURN 0;
END IF;
END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 1b]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a date value, returns the name of the holiday if it's a holiday
-- or NULL if it's not a holiday
CREATE FUNCTION is_holiday(d DATE) RETURNS VARCHAR(30) DETERMINISTIC
BEGIN

-- Extract month from given date
DECLARE month INT DEFAULT MONTH(d);
-- Extract the day of the week from given date
DECLARE day_of_week INT DEFAULT DAYOFWEEK(d);
-- Extract the day of the month from the given date
DECLARE day_of_month INT DEFAULT DAYOFMONTH(d);
DECLARE result VARCHAR(30);

IF month = 1 AND day_of_month = 1
    THEN SET result = 'New Year''s Day';
    RETURN result;
    
ELSEIF month = 5 AND day_of_week = 2 AND day_of_month BETWEEN 25 AND 31
    THEN RETURN 'Memorial Day';
    
ELSEIF month = 8 AND day_of_month = 26
    THEN RETURN 'National Dog Day';
    
ELSEIF month = 9 AND day_of_week = 2 AND day_of_month BETWEEN 1 AND 7
    THEN RETURN 'Labor Day';
    
ELSEIF month = 11 AND day_of_week = 5 AND day_of_month BETWEEN 22 AND 28
    THEN RETURN 'Thanksgiving';
    
ELSE 
    RETURN NULL;

END IF;
                                                     

END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 2a]
-- Get the number of filesets submitted on a recognized holiday
SELECT holiday, COUNT(sub_date) AS num_subs
FROM (
    -- Get all sub dates that fall on a holiday
    SELECT is_holiday(DATE(sub_date)) AS holiday, sub_date
    FROM fileset
) AS holiday_sub_dates
GROUP BY holiday
ORDER BY holiday;


-- [Problem 2b]
-- Get the number of submissions on weekends and weekdays
SELECT 
    CASE WHEN is_weekend(DATE(sub_date)) = 1 
        THEN 'weekend' ELSE 'weekday' END AS part_of_week,
    COUNT(sub_date) AS num_subs
FROM fileset
GROUP BY part_of_week
ORDER BY part_of_week;




