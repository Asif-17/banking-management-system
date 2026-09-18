USE banking_management;

-- =====================================================
-- 1. CHECK CURRENT ACCOUNT BALANCES
-- =====================================================

SELECT
    account_id,
    account_number,
    balance,
    status
FROM account
ORDER BY account_id;


-- =====================================================
-- 2. SIMPLE TRANSACTION WITH COMMIT
-- =====================================================
-- Deposit ₹10,000 into account 1.
-- COMMIT makes the change permanent.
-- =====================================================

START TRANSACTION;

UPDATE account
SET balance = balance + 10000
WHERE account_id = 1;

SELECT
    account_id,
    balance
FROM account
WHERE account_id = 1;

COMMIT;


-- =====================================================
-- 3. TRANSACTION WITH ROLLBACK
-- =====================================================
-- Withdraw ₹5,000 temporarily.
-- ROLLBACK cancels the change.
-- =====================================================

START TRANSACTION;

UPDATE account
SET balance = balance - 5000
WHERE account_id = 1;

SELECT
    account_id,
    balance
FROM account
WHERE account_id = 1;

ROLLBACK;


-- Check that the withdrawal was cancelled

SELECT
    account_id,
    balance
FROM account
WHERE account_id = 1;


-- =====================================================
-- 4. TRANSFER USING TRANSACTION
-- =====================================================
-- Money is transferred from account 1 to account 2.
-- Both updates must succeed.
-- =====================================================

START TRANSACTION;

UPDATE account
SET balance = balance - 10000
WHERE account_id = 1
  AND balance >= 10000;

UPDATE account
SET balance = balance + 10000
WHERE account_id = 2;

COMMIT;


-- Check both accounts

SELECT
    account_id,
    account_number,
    balance
FROM account
WHERE account_id IN (1, 2);


-- =====================================================
-- 5. TRANSFER WITH ROLLBACK
-- =====================================================
-- Demonstrates cancelling a transfer.
-- =====================================================

START TRANSACTION;

UPDATE account
SET balance = balance - 20000
WHERE account_id = 1;

UPDATE account
SET balance = balance + 20000
WHERE account_id = 2;

-- Cancel both operations

ROLLBACK;


-- Verify that balances returned to previous values

SELECT
    account_id,
    account_number,
    balance
FROM account
WHERE account_id IN (1, 2);


-- =====================================================
-- 6. SAVEPOINT
-- =====================================================
-- SAVEPOINT allows partial rollback.
-- =====================================================

START TRANSACTION;

-- First operation
UPDATE account
SET balance = balance + 5000
WHERE account_id = 1;


-- Create savepoint
SAVEPOINT after_first_operation;


-- Second operation
UPDATE account
SET balance = balance + 10000
WHERE account_id = 2;


-- Roll back only the second operation
ROLLBACK TO SAVEPOINT after_first_operation;


-- First operation still exists

COMMIT;


-- Check balances

SELECT
    account_id,
    account_number,
    balance
FROM account
WHERE account_id IN (1, 2);


-- =====================================================
-- 7. MULTIPLE OPERATIONS IN ONE TRANSACTION
-- =====================================================

START TRANSACTION;

UPDATE account
SET balance = balance - 15000
WHERE account_id = 1
  AND balance >= 15000;

UPDATE account
SET balance = balance + 15000
WHERE account_id = 2;

INSERT INTO bank_transaction
(
    account_id,
    transaction_type_id,
    amount,
    reference_number,
    description
)
VALUES
(
    1,
    (
        SELECT transaction_type_id
        FROM transaction_type
        WHERE type_name = 'Transfer'
    ),
    15000,
    CONCAT('TXN-', UUID()),
    'Transfer debit'
);

INSERT INTO bank_transaction
(
    account_id,
    transaction_type_id,
    amount,
    reference_number,
    description
)
VALUES
(
    2,
    (
        SELECT transaction_type_id
        FROM transaction_type
        WHERE type_name = 'Transfer'
    ),
    15000,
    CONCAT('TXN-', UUID()),
    'Transfer credit'
);

COMMIT;


-- =====================================================
-- 8. VERIFY TRANSACTION HISTORY
-- =====================================================

SELECT
    bt.transaction_id,
    bt.account_id,
    tt.type_name AS transaction_type,
    bt.amount,
    bt.transaction_date,
    bt.reference_number,
    bt.description
FROM bank_transaction bt
JOIN transaction_type tt
    ON bt.transaction_type_id = tt.transaction_type_id
ORDER BY bt.transaction_date DESC;


-- =====================================================
-- 9. VERIFY AUDIT LOG
-- =====================================================

SELECT
    audit_id,
    table_name,
    operation_type,
    record_id,
    old_value,
    new_value,
    changed_at
FROM audit_log
ORDER BY changed_at DESC;