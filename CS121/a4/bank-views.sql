-- [Problem 1a]
-- view containing account numbers and customer names for all Stonewell 
-- accounts
CREATE VIEW stonewell_customers AS
SELECT account_number, customer_name
FROM account 
    NATURAL JOIN depositor
WHERE branch_name = 'Stonewell';

-- [Problem 1b]
-- view containing the name, street, and city of all customers with an 
-- account but no loan, updateable
CREATE VIEW onlyacct_customers AS
SELECT DISTINCT customer_name, customer_street, customer_city
FROM customer 
    NATURAL JOIN depositor
WHERE customer_name 
    NOT IN (
        SELECT DISTINCT customer_name
        FROM borrower
    );

-- [Problem 1c]
-- view containing all bank branches with total account balance and
-- average account balance of each branch
CREATE VIEW branch_deposits AS
SELECT branch_name, 
    IFNULL(SUM(balance), 0) AS total_balance, 
    AVG(balance) AS avg_balance
FROM branch 
    NATURAL LEFT JOIN account
GROUP BY branch_name;
