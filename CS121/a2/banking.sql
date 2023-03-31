-- [Problem 0a]
-- If we set the balance in account to be a FLOAT or DOUBLE instead of NUMERIC,
-- then we will lose accuracy as they are approximations, while NUMERIC is a
-- fixed point number.

-- [Problem 0b]
-- One attribute in account that could be easily represented with a type other
-- than VARCHAR is account_number.  This could be switched to a CHAR value
-- in order to save storage space since VARCHAR needs to store two fields
-- (string and length) whereas CHAR can store only the string if we fix the
-- length.

-- [Problem 1a]
-- Get the loan number and amount for loans with an amount between $1,000
-- and $2,000
USE banking;
SELECT loan_number, amount
FROM loan
WHERE amount >= 1000 AND amount <= 2000;

-- [Problem 1b]
-- Get the loan number and amount for all loans owned by Smith, ordered by 
-- loan number
SELECT loan_number, amount
FROM loan
    NATURAL JOIN borrower
WHERE customer_name = 'Smith'
ORDER BY loan_number;

-- [Problem 1c]
-- Retrieve the city of the branch where the account with account_number
-- A-446 is open
SELECT branch_city
FROM branch
    NATURAL JOIN account
WHERE account_number = 'A-446';

-- [Problem 1d]
-- Get the customer name, account number, branch name, and balance for accounts
-- where the owner's name starts with J, ordered by customer name
SELECT customer_name, account_number, branch_name, balance
FROM customer
    NATURAL JOIN account
    NATURAL JOIN depositor
WHERE customer_name LIKE 'J%'
ORDER BY customer_name;

-- [Problem 1e]
-- Get the names of all customers with more than 5 bank accounts
SELECT customer_name
FROM (
    SELECT customer_name, COUNT(*) AS num_accounts
    FROM depositor
        NATURAL JOIN customer
    GROUP BY customer_name
) AS bank_accounts
WHERE num_accounts > 5;

-- [Problem 2a]
-- Generate a list of all cities that customers live in.
-- Results are DISTINCT, sorted alphabetically by city name.
SELECT DISTINCT customer_city
FROM customer 
WHERE customer_city 
    NOT IN (
        SELECT branch_city
        FROM branch
    )
ORDER BY customer_city;

-- [Problem 2b]
-- Get the name of any customers that do not have an account or loan
SELECT customer_name
FROM customer
WHERE customer_name
    NOT IN (
        SELECT customer_name
        FROM depositor
    )
AND customer_name 
    NOT IN (
        SELECT customer_name
        FROM borrower
    );

-- [Problem 2c]
-- Update the schema so that we add a $75 gift to each account in Horseneck
UPDATE account
SET balance = balance + 75
WHERE branch_name
    IN (
        SELECT branch_name
        FROM branch
        WHERE branch_city = 'Horseneck'
    );

-- [Problem 2d]
-- Update the schema so that we add a $75 gift to each account in Horseneck
-- using the multiple table syntax
UPDATE account, branch
SET balance = balance + 75
WHERE account.branch_name = branch.branch_name
AND branch.branch_city = 'Horseneck';

-- [Problem 2e]
-- Get the account number, branch name, and balance for the largest accounts
-- at each branch
-- Implemented using a derived relation in the FROM clause
SELECT account_number, branch_name, balance
FROM account
    NATURAL JOIN (
        SELECT branch_name, MAX(balance) as balance
        FROM account
        GROUP BY branch_name
    ) AS max_balances;

-- [Problem 2f]
-- Get the account number, branch name, and balance for the largest accounts
-- at each branch
-- Implemented using an IN predicate and multiple clauses
SELECT account_number, branch_name, balance
FROM account
WHERE (branch_name, balance)
    IN (
        SELECT branch_name, MAX(balance) as balance
        FROM account
        GROUP BY branch_name
    );

-- [Problem 3]
-- Compute the rank of each branch based on the amount of assets
SELECT branch_name, assets, COUNT(*) as `rank`
FROM (
    SELECT a.branch_name, a.assets
    FROM branch AS a, branch AS b
    WHERE a.branch_name = b.branch_name 
    OR a.assets < b.assets
) AS ranks
GROUP BY branch_name, assets
ORDER BY `rank`, branch_name;


