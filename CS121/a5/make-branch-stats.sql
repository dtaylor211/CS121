-- [Problem 1]
-- Create an index on account for the branch_name
CREATE INDEX idx_branch
ON account (branch_name, balance);


-- [Problem 2]
-- my_branch_account_stats: table containing information about a 
-- branch's accounts and balances
CREATE TABLE my_branch_account_stats (
    branch_name VARCHAR(20),
    num_accounts INT NOT NULL,
    total_deposits NUMERIC(15, 2) NOT NULL,
    min_balance NUMERIC(15, 2) NOT NULL,
    max_balance NUMERIC(15, 2) NOT NULL,

    PRIMARY KEY (branch_name)
);


-- [Problem 3]
-- Populate my_branch_account_stats with information from account
INSERT INTO my_branch_account_stats (
    SELECT branch_name, COUNT(*), SUM(balance), MIN(balance), MAX(balance)
    FROM account
    GROUP BY branch_name
);


-- [Problem 4]
-- branch_account_stats: view containing information about a branch's
-- accounts and balances
CREATE VIEW branch_account_stats AS
SELECT branch_name, num_accounts, total_deposits, 
    (max_balance - min_balance)/2 AS avg_balance, min_balance, max_balance
FROM my_branch_account_stats;


-- [Problem 5]
-- Provided solution for Problem 5
DELIMITER !

-- A procedure to execute when inserting a new branch name and balance
-- to the bank account stats materialized view (mv_branch_account_stats).
-- If a branch is already in view, its current balance is updated
-- to account for total deposits and adjusted min/max balances.
CREATE PROCEDURE sp_branchstat_newacct(
    new_branch_name VARCHAR(15),
    new_balance NUMERIC(12, 2)
)
BEGIN 
    INSERT INTO mv_branch_account_stats 
        -- branch not already in view; add row
        VALUES (new_branch_name, 1, new_balance, new_balance, new_balance)
    ON DUPLICATE KEY UPDATE 
        -- branch already in view; update existing row
        num_accounts = num_accounts + 1,
        total_deposits = total_deposits + new_balance,
        min_balance = LEAST(min_balance, new_balance),
        max_balance = GREATEST(max_balance, new_balance);
END !

-- Handles new rows added to account table, updates stats accordingly
CREATE TRIGGER trg_account_insert AFTER INSERT
       ON account FOR EACH ROW
BEGIN
    CALL sp_branchstat_newacct(NEW.branch_name, NEW.balance);
END !
DELIMITER ;


-- [Problem 6]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- A procedure to execute when deleting a branch name and balance
-- from the bank account stats materialized view (mv_branch_account_stats).
-- If a branch is already in view, its current balance is updated
-- to account for total deposits and adjusted min/max balances.
CREATE PROCEDURE sp_branchstat_delacct (
    branch_to_delete VARCHAR(20),
    balance_to_delete NUMERIC(15, 2)
)

BEGIN
-- Delete branch where num_accounts is simply 1
DELETE FROM my_branch_account_stats
WHERE branch_name = branch_to_delete AND num_accounts = 1;

-- If branch still in my_branch_account_stats, update
-- num_accounts and total_deposits
IF branch_to_delete IN (
    SELECT branch_name FROM my_branch_account_stats
) THEN
    UPDATE my_branch_account_stats
    SET num_accounts = num_accounts - 1,
        total_deposits = total_deposits - balance_to_delete
    WHERE branch_name = branch_to_delete;

END IF;

-- If balance to delete is the min balance, update min_balance
IF balance_to_delete = (
    SELECT min_balance FROM my_branch_account_stats
) THEN
    UPDATE my_branch_account_stats
    SET min_balance = (
        SELECT MIN(balance)
        FROM account
        WHERE branch_name = branch_to_delete
    ) WHERE branch_name = branch_to_delete;
    
-- If balance to delete is the max balance, update max_balance
ELSEIF balance_to_delete = (
    SELECT max_balance FROM my_branch_account_stats
) THEN
    UPDATE my_branch_account_stats
    SET max_balance = (
        SELECT MAX(balance)
        FROM account
        WHERE branch_name = branch_to_delete
    ) WHERE branch_name = branch_to_delete;

END IF;
END !

-- Handles rows deleted from account table, updates stats accordingly
CREATE TRIGGER trg_account_delete AFTER DELETE
       ON account FOR EACH ROW
BEGIN
    CALL sp_branchstat_delacct(OLD.branch_name, OLD.balance);
END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 7]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Handles rows updated in account table, updates stats accordingly
CREATE TRIGGER trg_account_update AFTER UPDATE
       ON account FOR EACH ROW
BEGIN
    -- If updated branch name is not equal to original branch name,
    -- call previous procedures to delete old branch and add new branch
    IF NEW.branch_name <> OLD.branch_name THEN
        CALL sp_branchstat_delacct(OLD.branch_name, OLD.balance);
        CALL sp_branchstat_newacct(NEW.branch_name, NEW.balance);

    -- If updated balance is not equal to original balance,
    -- first update the new branch to have correct total deposits, 
    -- min balance, and max balance
    ELSEIF NEW.balance <> OLD.balance THEN
        UPDATE my_branch_account_stats
        SET total_deposits = total_deposits - OLD.balance + NEW.balance,
            min_balance = LEAST(min_balance, NEW.balance),
            max_balance = GREATEST(max_balance, NEW,balance)
        WHERE branch_name = NEW.branch_name;

        -- also update old branch to have correct min balance
        IF OLD.balance = (
            SELECT min_balance FROM my_branch_account_stats
            WHERE branch_name = OLD.branch_name
        ) THEN
            UPDATE my_branch_account_stats
            SET min_balance = (
                SELECT MIN(balance) FROM account
                WHERE branch_name = OLD.branch_name
            ) WHERE branch_name = OLD.branch_name;
            
        -- also update old branch to have correct max balance
        ELSEIF OLD.balance = (
            SELECT max_balance FROM my_branch_account_stats
            WHERE branch_name = OLD.branch_name
        ) THEN
            UPDATE my_branch_account_stats
            SET max_balance = (
                SELECT MAX(balance) FROM account
                WHERE branch_name = OLD.branch_name
            ) WHERE branch_name = OLD.branch_name;
            
        END IF;
    END IF;
END !

-- Back to the standard SQL delimiter
DELIMITER ;

