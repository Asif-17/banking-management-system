USE banking_management;

-- =====================================================
-- 1. SHOW ALL TABLES
-- =====================================================

SHOW TABLES;


-- =====================================================
-- 2. CHECK NUMBER OF CUSTOMERS
-- =====================================================

SELECT COUNT(*) AS total_customers
FROM customer;


-- =====================================================
-- 3. CHECK NUMBER OF ACCOUNTS
-- =====================================================

SELECT COUNT(*) AS total_accounts
FROM account;


-- =====================================================
-- 4. CHECK NUMBER OF TRANSACTIONS
-- =====================================================

SELECT COUNT(*) AS total_transactions
FROM bank_transaction;


-- =====================================================
-- 5. CHECK NUMBER OF LOANS
-- =====================================================

SELECT COUNT(*) AS total_loans
FROM loan;


-- =====================================================
-- 6. CHECK NUMBER OF CARDS
-- =====================================================

SELECT COUNT(*) AS total_cards
FROM card;


-- =====================================================
-- 7. CUSTOMER ACCOUNT SUMMARY VIEW
-- =====================================================

SELECT *
FROM customer_account_summary;


-- =====================================================
-- 8. HIGH VALUE ACCOUNTS VIEW
-- =====================================================

SELECT *
FROM high_value_accounts;


-- =====================================================
-- 9. TRANSACTION HISTORY VIEW
-- =====================================================

SELECT *
FROM transaction_history
ORDER BY transaction_date DESC;


-- =====================================================
-- 10. ACTIVE LOAN SUMMARY VIEW
-- =====================================================

SELECT *
FROM active_loan_summary;


-- =====================================================
-- 11. BRANCH PERFORMANCE VIEW
-- =====================================================

SELECT *
FROM branch_performance;


-- =====================================================
-- 12. CUSTOMER LOAN SUMMARY VIEW
-- =====================================================

SELECT *
FROM customer_loan_summary;


-- =====================================================
-- 13. CUSTOMER KYC STATUS VIEW
-- =====================================================

SELECT *
FROM customer_kyc_status;


-- =====================================================
-- 14. CHECK STORED PROCEDURES
-- =====================================================

SHOW PROCEDURE STATUS
WHERE Db = 'banking_management';


-- =====================================================
-- 15. CHECK TRIGGERS
-- =====================================================

SHOW TRIGGERS
FROM banking_management;


-- =====================================================
-- 16. CHECK FOREIGN KEYS
-- =====================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'banking_management'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;


-- =====================================================
-- 17. TOTAL MONEY IN ALL ACTIVE ACCOUNTS
-- =====================================================

SELECT
    SUM(balance) AS total_active_account_balance
FROM account
WHERE status = 'Active';


-- =====================================================
-- 18. TOTAL LOAN AMOUNT
-- =====================================================

SELECT
    SUM(loan_amount) AS total_loan_amount,
    SUM(outstanding_amount) AS total_outstanding_amount
FROM loan;


-- =====================================================
-- 19. TRANSACTION SUMMARY
-- =====================================================

SELECT
    tt.type_name AS transaction_type,
    COUNT(bt.transaction_id) AS transaction_count,
    SUM(bt.amount) AS total_amount
FROM bank_transaction bt
JOIN transaction_type tt
    ON bt.transaction_type_id = tt.transaction_type_id
GROUP BY tt.type_name
ORDER BY total_amount DESC;


-- =====================================================
-- 20. CUSTOMER FINANCIAL SUMMARY
-- =====================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,

    COUNT(DISTINCT a.account_id) AS total_accounts,

    COALESCE(SUM(DISTINCT a.balance), 0) AS total_balance,

    COUNT(DISTINCT l.loan_id) AS total_loans,

    COALESCE(SUM(DISTINCT l.loan_amount), 0) AS total_loan_amount,

    COALESCE(
        SUM(DISTINCT l.outstanding_amount),
        0
    ) AS total_outstanding

FROM customer c

LEFT JOIN account a
    ON c.customer_id = a.customer_id

LEFT JOIN loan l
    ON c.customer_id = l.customer_id

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name

ORDER BY total_balance DESC;


-- =====================================================
-- 21. AUDIT LOG
-- =====================================================

SELECT *
FROM audit_log
ORDER BY changed_at DESC;


-- =====================================================
-- 22. DATABASE SIZE
-- =====================================================

SELECT
    table_name,
    ROUND(
        (data_length + index_length) / 1024,
        2
    ) AS size_kb
FROM information_schema.tables
WHERE table_schema = 'banking_management'
ORDER BY size_kb DESC;