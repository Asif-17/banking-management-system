USE banking_management;

-- =====================================================
-- VIEW 1: CUSTOMER ACCOUNT SUMMARY
-- =====================================================

CREATE OR REPLACE VIEW customer_account_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.phone,
    c.email,
    a.account_number,
    at.type_name AS account_type,
    a.balance,
    a.status AS account_status,
    b.branch_name,
    b.city AS branch_city
FROM customer c
JOIN account a
    ON c.customer_id = a.customer_id
JOIN account_type at
    ON a.account_type_id = at.account_type_id
JOIN branch b
    ON a.branch_id = b.branch_id;


-- =====================================================
-- VIEW 2: HIGH VALUE ACCOUNTS
-- =====================================================

CREATE OR REPLACE VIEW high_value_accounts AS
SELECT
    a.account_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    at.type_name AS account_type,
    a.balance,
    b.branch_name,
    b.city
FROM account a
JOIN customer c
    ON a.customer_id = c.customer_id
JOIN account_type at
    ON a.account_type_id = at.account_type_id
JOIN branch b
    ON a.branch_id = b.branch_id
WHERE a.balance >= 100000;


-- =====================================================
-- VIEW 3: TRANSACTION HISTORY
-- =====================================================

CREATE OR REPLACE VIEW transaction_history AS
SELECT
    bt.transaction_id,
    bt.reference_number,
    a.account_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    tt.type_name AS transaction_type,
    bt.amount,
    bt.transaction_date,
    bt.description
FROM bank_transaction bt
JOIN account a
    ON bt.account_id = a.account_id
JOIN customer c
    ON a.customer_id = c.customer_id
JOIN transaction_type tt
    ON bt.transaction_type_id = tt.transaction_type_id;


-- =====================================================
-- VIEW 4: ACTIVE LOAN SUMMARY
-- =====================================================

CREATE OR REPLACE VIEW active_loan_summary AS
SELECT
    l.loan_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    lt.type_name AS loan_type,
    l.loan_amount,
    l.outstanding_amount,
    l.interest_rate,
    l.start_date,
    l.end_date,
    l.status,
    b.branch_name
FROM loan l
JOIN customer c
    ON l.customer_id = c.customer_id
JOIN loan_type lt
    ON l.loan_type_id = lt.loan_type_id
JOIN branch b
    ON l.branch_id = b.branch_id
WHERE l.status = 'Active';


-- =====================================================
-- VIEW 5: BRANCH PERFORMANCE
-- =====================================================

CREATE OR REPLACE VIEW branch_performance AS
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    COUNT(a.account_id) AS total_accounts,
    COALESCE(SUM(a.balance), 0) AS total_balance,
    COALESCE(AVG(a.balance), 0) AS average_balance
FROM branch b
LEFT JOIN account a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city;


-- =====================================================
-- VIEW 6: CUSTOMER LOAN SUMMARY
-- =====================================================

CREATE OR REPLACE VIEW customer_loan_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(l.loan_id) AS number_of_loans,
    COALESCE(SUM(l.loan_amount), 0) AS total_loan_amount,
    COALESCE(SUM(l.outstanding_amount), 0) AS total_outstanding
FROM customer c
LEFT JOIN loan l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;


-- =====================================================
-- VIEW 7: CUSTOMER KYC STATUS
-- =====================================================

CREATE OR REPLACE VIEW customer_kyc_status AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.phone,
    c.email,
    k.document_type,
    k.verification_status,
    k.verification_date
FROM customer c
LEFT JOIN kyc_details k
    ON c.customer_id = k.customer_id;


-- =====================================================
-- TEST THE VIEWS
-- =====================================================

-- View 1
SELECT * FROM customer_account_summary;

-- View 2
SELECT * FROM high_value_accounts
ORDER BY balance DESC;

-- View 3
SELECT * FROM transaction_history
ORDER BY transaction_date DESC;

-- View 4
SELECT * FROM active_loan_summary
ORDER BY outstanding_amount DESC;

-- View 5
SELECT * FROM branch_performance
ORDER BY total_balance DESC;

-- View 6
SELECT * FROM customer_loan_summary
ORDER BY total_outstanding DESC;

-- View 7
SELECT * FROM customer_kyc_status
ORDER BY customer_id;


-- =====================================================
-- SHOW ALL CREATED VIEWS
-- =====================================================

SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';