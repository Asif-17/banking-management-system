USE banking_management;

-- =====================================================
-- 1. ACCOUNTS WITH BALANCE ABOVE THE AVERAGE BALANCE
-- =====================================================

SELECT
    account_id,
    account_number,
    balance
FROM account
WHERE balance > (
    SELECT AVG(balance)
    FROM account
)
ORDER BY balance DESC;


-- =====================================================
-- 2. CUSTOMERS WHO HAVE AT LEAST ONE ACCOUNT
-- =====================================================

SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM account
);


-- =====================================================
-- 3. CUSTOMERS WHO DO NOT HAVE AN ACCOUNT
-- =====================================================

SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM account
);


-- =====================================================
-- 4. CUSTOMERS WHO HAVE A LOAN
-- =====================================================

SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM loan
);


-- =====================================================
-- 5. CUSTOMERS WHO HAVE BOTH ACCOUNT AND LOAN
-- =====================================================

SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM account
)
AND customer_id IN (
    SELECT customer_id
    FROM loan
);


-- =====================================================
-- 6. ACCOUNT WITH THE HIGHEST BALANCE
-- =====================================================

SELECT
    account_id,
    account_number,
    customer_id,
    balance
FROM account
WHERE balance = (
    SELECT MAX(balance)
    FROM account
);


-- =====================================================
-- 7. CUSTOMER WITH THE HIGHEST TOTAL BALANCE
-- =====================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(a.balance) AS total_balance
FROM customer c
JOIN account a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING SUM(a.balance) = (
    SELECT MAX(total_balance)
    FROM (
        SELECT SUM(balance) AS total_balance
        FROM account
        GROUP BY customer_id
    ) AS customer_balances
);


-- =====================================================
-- 8. ACCOUNTS WITH BALANCE GREATER THAN
--    THE AVERAGE BALANCE OF THEIR ACCOUNT TYPE
-- =====================================================

SELECT
    a.account_number,
    a.account_type_id,
    a.balance
FROM account a
WHERE a.balance > (
    SELECT AVG(a2.balance)
    FROM account a2
    WHERE a2.account_type_id = a.account_type_id
);


-- =====================================================
-- 9. CORRELATED SUBQUERY:
--    CUSTOMERS HAVING AN ACCOUNT ABOVE ₹1,00,000
-- =====================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM account a
    WHERE a.customer_id = c.customer_id
      AND a.balance > 100000
);


-- =====================================================
-- 10. CUSTOMERS WITH NO TRANSACTIONS
-- =====================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM account a
    JOIN bank_transaction bt
        ON a.account_id = bt.account_id
    WHERE a.customer_id = c.customer_id
);


-- =====================================================
-- 11. ACCOUNTS HAVING TRANSACTION AMOUNT
--     GREATER THAN THE AVERAGE TRANSACTION
-- =====================================================

SELECT DISTINCT
    a.account_number,
    a.balance
FROM account a
JOIN bank_transaction bt
    ON a.account_id = bt.account_id
WHERE bt.amount > (
    SELECT AVG(amount)
    FROM bank_transaction
);


-- =====================================================
-- 12. CUSTOMERS WHOSE TOTAL ACCOUNT BALANCE
--     IS ABOVE THE OVERALL CUSTOMER AVERAGE
-- =====================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(a.balance) AS total_balance
FROM customer c
JOIN account a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING SUM(a.balance) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(balance) AS customer_total
        FROM account
        GROUP BY customer_id
    ) AS totals
);


-- =====================================================
-- 13. LOANS ABOVE THE AVERAGE LOAN AMOUNT
-- =====================================================

SELECT
    loan_id,
    customer_id,
    loan_amount,
    outstanding_amount
FROM loan
WHERE loan_amount > (
    SELECT AVG(loan_amount)
    FROM loan
)
ORDER BY loan_amount DESC;


-- =====================================================
-- 14. LOANS WITH OUTSTANDING AMOUNT ABOVE
--     THE AVERAGE OUTSTANDING AMOUNT
-- =====================================================

SELECT
    loan_id,
    customer_id,
    outstanding_amount
FROM loan
WHERE outstanding_amount > (
    SELECT AVG(outstanding_amount)
    FROM loan
);


-- =====================================================
-- 15. BRANCHES HAVING AT LEAST ONE
--     ACCOUNT ABOVE ₹2,00,000
-- =====================================================

SELECT
    branch_id,
    branch_name,
    city
FROM branch b
WHERE EXISTS (
    SELECT 1
    FROM account a
    WHERE a.branch_id = b.branch_id
      AND a.balance > 200000
);


-- =====================================================
-- 16. CUSTOMERS WHOSE ACCOUNT BALANCE
--     IS EQUAL TO THE MAXIMUM BALANCE
--     IN THEIR BRANCH
-- =====================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    a.account_number,
    a.balance,
    a.branch_id
FROM customer c
JOIN account a
    ON c.customer_id = a.customer_id
WHERE a.balance = (
    SELECT MAX(a2.balance)
    FROM account a2
    WHERE a2.branch_id = a.branch_id
);


-- =====================================================
-- 17. CTE:
--     TOTAL BALANCE OF EACH CUSTOMER
-- =====================================================

WITH customer_balance AS (
    SELECT
        customer_id,
        SUM(balance) AS total_balance
    FROM account
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    cb.total_balance
FROM customer c
JOIN customer_balance cb
    ON c.customer_id = cb.customer_id
ORDER BY cb.total_balance DESC;


-- =====================================================
-- 18. CTE:
--     BRANCH-WISE ACCOUNT STATISTICS
-- =====================================================

WITH branch_statistics AS (
    SELECT
        branch_id,
        COUNT(*) AS total_accounts,
        SUM(balance) AS total_balance,
        AVG(balance) AS average_balance
    FROM account
    GROUP BY branch_id
)
SELECT
    b.branch_name,
    b.city,
    bs.total_accounts,
    bs.total_balance,
    bs.average_balance
FROM branch b
JOIN branch_statistics bs
    ON b.branch_id = bs.branch_id
ORDER BY bs.total_balance DESC;


-- =====================================================
-- 19. CTE:
--     LOAN PAYMENT SUMMARY
-- =====================================================

WITH payment_summary AS (
    SELECT
        loan_id,
        COUNT(payment_id) AS payment_count,
        SUM(payment_amount) AS total_paid
    FROM loan_payment
    GROUP BY loan_id
)
SELECT
    l.loan_id,
    l.customer_id,
    l.loan_amount,
    l.outstanding_amount,
    COALESCE(ps.payment_count, 0) AS payment_count,
    COALESCE(ps.total_paid, 0) AS total_paid
FROM loan l
LEFT JOIN payment_summary ps
    ON l.loan_id = ps.loan_id
ORDER BY l.loan_id;


-- =====================================================
-- 20. CTE:
--     HIGH-VALUE CUSTOMERS
--     TOTAL BALANCE >= ₹2,00,000
-- =====================================================

WITH customer_balance AS (
    SELECT
        customer_id,
        SUM(balance) AS total_balance
    FROM account
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    cb.total_balance
FROM customer c
JOIN customer_balance cb
    ON c.customer_id = cb.customer_id
WHERE cb.total_balance >= 200000
ORDER BY cb.total_balance DESC;