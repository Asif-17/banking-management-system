USE banking_management;

-- =====================================================
-- 1. DISPLAY ALL CUSTOMERS
-- =====================================================

SELECT *
FROM customer;


-- =====================================================
-- 2. DISPLAY CUSTOMER NAMES AND CONTACT DETAILS
-- =====================================================

SELECT
    customer_id,
    first_name,
    last_name,
    phone,
    email
FROM customer;


-- =====================================================
-- 3. FIND FEMALE CUSTOMERS
-- =====================================================

SELECT
    customer_id,
    first_name,
    last_name,
    gender
FROM customer
WHERE gender = 'Female';


-- =====================================================
-- 4. FIND CUSTOMERS WORKING AS SOFTWARE ENGINEER
-- =====================================================

SELECT
    customer_id,
    first_name,
    last_name,
    occupation
FROM customer
WHERE occupation = 'Software Engineer';


-- =====================================================
-- 5. CUSTOMERS REGISTERED AFTER 1 JULY 2024
-- =====================================================

SELECT
    customer_id,
    first_name,
    last_name,
    registration_date
FROM customer
WHERE registration_date > '2024-07-01';


-- =====================================================
-- 6. DISPLAY ACCOUNTS WITH BALANCE GREATER THAN ₹1,00,000
-- =====================================================

SELECT
    account_id,
    account_number,
    balance
FROM account
WHERE balance > 100000;


-- =====================================================
-- 7. DISPLAY ACCOUNTS BETWEEN ₹50,000 AND ₹2,00,000
-- =====================================================

SELECT
    account_id,
    account_number,
    balance
FROM account
WHERE balance BETWEEN 50000 AND 200000;


-- =====================================================
-- 8. DISPLAY ACTIVE ACCOUNTS
-- =====================================================

SELECT
    account_id,
    account_number,
    balance,
    status
FROM account
WHERE status = 'Active';


-- =====================================================
-- 9. DISPLAY ACCOUNTS IN DESCENDING ORDER OF BALANCE
-- =====================================================

SELECT
    account_id,
    account_number,
    balance
FROM account
ORDER BY balance DESC;


-- =====================================================
-- 10. FIND THE HIGHEST ACCOUNT BALANCE
-- =====================================================

SELECT MAX(balance) AS highest_balance
FROM account;


-- =====================================================
-- 11. FIND THE LOWEST ACCOUNT BALANCE
-- =====================================================

SELECT MIN(balance) AS lowest_balance
FROM account;


-- =====================================================
-- 12. FIND TOTAL MONEY HELD IN ALL ACCOUNTS
-- =====================================================

SELECT
    SUM(balance) AS total_bank_balance
FROM account;


-- =====================================================
-- 13. FIND AVERAGE ACCOUNT BALANCE
-- =====================================================

SELECT
    AVG(balance) AS average_account_balance
FROM account;


-- =====================================================
-- 14. COUNT TOTAL CUSTOMERS
-- =====================================================

SELECT
    COUNT(*) AS total_customers
FROM customer;


-- =====================================================
-- 15. COUNT TOTAL ACCOUNTS
-- =====================================================

SELECT
    COUNT(*) AS total_accounts
FROM account;


-- =====================================================
-- 16. COUNT ACTIVE ACCOUNTS
-- =====================================================

SELECT
    COUNT(*) AS active_accounts
FROM account
WHERE status = 'Active';


-- =====================================================
-- 17. DISPLAY ALL ACCOUNT TYPES
-- =====================================================

SELECT
    account_type_id,
    type_name,
    minimum_balance,
    interest_rate
FROM account_type;


-- =====================================================
-- 18. FIND ACCOUNT TYPES WITH INTEREST RATE >= 4%
-- =====================================================

SELECT
    type_name,
    interest_rate
FROM account_type
WHERE interest_rate >= 4.00;


-- =====================================================
-- 19. DISPLAY LOANS GREATER THAN ₹10,00,000
-- =====================================================

SELECT
    loan_id,
    customer_id,
    loan_amount,
    outstanding_amount
FROM loan
WHERE loan_amount > 1000000;


-- =====================================================
-- 20. DISPLAY ACTIVE LOANS
-- =====================================================

SELECT
    loan_id,
    customer_id,
    loan_amount,
    outstanding_amount,
    status
FROM loan
WHERE status = 'Active';


-- =====================================================
-- 21. FIND TOTAL LOAN AMOUNT
-- =====================================================

SELECT
    SUM(loan_amount) AS total_loan_amount
FROM loan;


-- =====================================================
-- 22. FIND TOTAL OUTSTANDING LOAN AMOUNT
-- =====================================================

SELECT
    SUM(outstanding_amount) AS total_outstanding_amount
FROM loan;


-- =====================================================
-- 23. FIND LOANS WITH ZERO OUTSTANDING AMOUNT
-- =====================================================

SELECT
    loan_id,
    customer_id,
    loan_amount,
    outstanding_amount,
    status
FROM loan
WHERE outstanding_amount = 0;


-- =====================================================
-- 24. DISPLAY ALL TRANSACTIONS ABOVE ₹50,000
-- =====================================================

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date,
    description
FROM bank_transaction
WHERE amount > 50000;


-- =====================================================
-- 25. DISPLAY LATEST TRANSACTIONS FIRST
-- =====================================================

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM bank_transaction
ORDER BY transaction_date DESC;