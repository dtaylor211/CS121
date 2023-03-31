-- [Problem 1]
-- Get all attributes a from A in schema r
-- Need to use DISTINCT to ensure a unique set, no repeats
SELECT DISTINCT A 
FROM r;

-- [Problem 2]
-- Get all tuples from schema r where for its value b in B, b = 42
SELECT * 
FROM r 
WHERE B = 42;

-- [Problem 3]
-- Compute the cross product of schemas r and s
SELECT * FROM r, s;

-- [Problem 4]
-- Get all attributes a, f from A, F in the schema produced by gathering
-- all tuples where attribute c in C equals attribute d in D in the cross
-- product of schemas r and s
-- DISTINCT is needed since there could be multiple entries in the cross 
-- product with the same a and f value
SELECT DISTINCT A, F
FROM r, s
WHERE C = D;

-- [Problem 5]
-- Get the union of r1 and r2
SELECT * 
FROM r1
    UNION  
        SELECT *
        FROM r2;

-- [Problem 6]
-- Get the intersection of r1 and r2
SELECT *
FROM r1
    INTERSECT 
        SELECT *
        FROM r2;

-- [Problem 7]
-- Get the set difference of r1 - r2
SELECT * 
FROM r1
    EXCEPT 
        SELECT *
        FROM r2;

