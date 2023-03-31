-- [Problem 1a]
-- Here, we are getting the tuples of all customer names and their number
-- of loans.  The results are sorted by decreasing number of loans and 0
-- is allowed.
SELECT customer_name, COUNT(loan_number) AS loan_count
FROM customer 
    NATURAL LEFT JOIN borrower
GROUP BY customer_name
ORDER BY loan_count 
    DESC;

-- [Problem 1b]
-- Here, we are getting all of the branch names where said branch's assets
-- are less than said branch's given loan amounts
SELECT branch_name
FROM (
    SELECT branch_name, assets, SUM(amount) AS loan_sum
    FROM branch 
        NATURAL JOIN loan
    GROUP BY branch_name, assets
) AS loan_sums
WHERE assets < loan_sum;

-- [Problem 1c]
-- Compute the number of accounts and loans at each branch using
-- a correlated subquery in the SELECT clause
SELECT branch_name, (
    SELECT COUNT(loan_number)
    FROM loan l
    WHERE l.branch_name = b.branch_name
) AS loan_counts, (
    SELECT COUNT(account_number)
    FROM account a
    WHERE a.branch_name = b.branch_name
) AS num_accounts
FROM branch b
ORDER BY branch_name;

-- [Problem 1d]
-- Compute the number of accounts and loans at each branch using
-- a discorrelated version of the above query
SELECT branch_name, 
    COUNT(DISTINCT loan_number) AS loan_counts, 
    COUNT(DISTINCT account_number) AS num_accounts
FROM branch 
    NATURAL LEFT JOIN loan
    NATURAL LEFT JOIN account
GROUP BY branch_name
ORDER BY branch_name;

