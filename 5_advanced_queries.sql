USE banking_management;

-- A. Multi-table Join Queries

-- 1.Customer + Account + Account Type

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    a.account_number,
    at.type_name AS account_type,
    a.balance,
    a.status
FROM customer c
JOIN account a
    ON c.customer_id = a.customer_id
JOIN account_type at
    ON a.account_type_id = at.account_type_id;
    
    
-- 2.Customer + Account + Branch

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    a.account_number,
    b.branch_name,
    b.city,
    a.balance
FROM customer c
JOIN account a
    ON c.customer_id = a.customer_id
JOIN branch b
    ON a.branch_id = b.branch_id;
    
    
-- 3.Display complete account information

SELECT
    a.account_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    at.type_name AS account_type,
    b.branch_name,
    b.city,
    a.balance,
    a.status
FROM account a
JOIN customer c
    ON a.customer_id = c.customer_id
JOIN account_type at
    ON a.account_type_id = at.account_type_id
JOIN branch b
    ON a.branch_id = b.branch_id
ORDER BY a.balance DESC;


-- B. GROUP BY queries

-- 4. Number of accounts held by each customer

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(a.account_id) AS number_of_accounts
FROM customer c
LEFT JOIN account a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY number_of_accounts DESC;

-- 5. Total balance by branch

SELECT
    b.branch_name,
    b.city,
    COUNT(a.account_id) AS total_accounts,
    SUM(a.balance) AS total_balance
FROM branch b
LEFT JOIN account a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city
ORDER BY total_balance DESC;

-- 6. Average account balance by account type

SELECT
    at.type_name AS account_type,
    COUNT(a.account_id) AS number_of_accounts,
    AVG(a.balance) AS average_balance
FROM account_type at
JOIN account a
    ON at.account_type_id = a.account_type_id
GROUP BY
    at.account_type_id,
    at.type_name;
    
-- 7. Number of customers in each city

SELECT
    ca.city,
    COUNT(DISTINCT ca.customer_id) AS number_of_customers
FROM customer_address ca
GROUP BY ca.city
ORDER BY number_of_customers DESC;



-- C. GROUP BY + HAVING

-- 8. Branches having more than 2 accounts

SELECT
    b.branch_name,
    COUNT(a.account_id) AS total_accounts
FROM branch b
JOIN account a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name
HAVING COUNT(a.account_id) > 2;


-- 9. Customers having total balance greater than ₹1,00,000

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
HAVING SUM(a.balance) > 100000
ORDER BY total_balance DESC;


-- D. Transaction analysis

-- 10. Number of transactions for each account

SELECT
    a.account_number,
    COUNT(bt.transaction_id) AS transaction_count
FROM account a
LEFT JOIN bank_transaction bt
    ON a.account_id = bt.account_id
GROUP BY
    a.account_id,
    a.account_number
ORDER BY transaction_count DESC;

-- 11. Total transaction amount for each account

SELECT
    a.account_number,
    SUM(bt.amount) AS total_transaction_amount
FROM account a
JOIN bank_transaction bt
    ON a.account_id = bt.account_id
GROUP BY
    a.account_id,
    a.account_number
ORDER BY total_transaction_amount DESC;

-- 12. Transaction count by transaction type

SELECT
    tt.type_name AS transaction_type,
    COUNT(bt.transaction_id) AS number_of_transactions,
    SUM(bt.amount) AS total_amount
FROM transaction_type tt
JOIN bank_transaction bt
    ON tt.transaction_type_id = bt.transaction_type_id
GROUP BY
    tt.transaction_type_id,
    tt.type_name
ORDER BY total_amount DESC;


-- E. Loan analysis

-- 13. Customer loan details

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    lt.type_name AS loan_type,
    l.loan_amount,
    l.outstanding_amount,
    l.interest_rate,
    l.status
FROM customer c
JOIN loan l
    ON c.customer_id = l.customer_id
JOIN loan_type lt
    ON l.loan_type_id = lt.loan_type_id
ORDER BY l.loan_amount DESC;

-- 14. Total loan amount by loan type

SELECT
    lt.type_name AS loan_type,
    COUNT(l.loan_id) AS number_of_loans,
    SUM(l.loan_amount) AS total_loan_amount,
    SUM(l.outstanding_amount) AS total_outstanding
FROM loan_type lt
JOIN loan l
    ON lt.loan_type_id = l.loan_type_id
GROUP BY
    lt.loan_type_id,
    lt.type_name
ORDER BY total_loan_amount DESC;

-- 15. Customers with outstanding loans greater than ₹10 lakh

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    l.loan_id,
    l.outstanding_amount
FROM customer c
JOIN loan l
    ON c.customer_id = l.customer_id
WHERE l.outstanding_amount > 1000000
ORDER BY l.outstanding_amount DESC;


-- F. More advanced JOIN

-- 16. Customers who have both an account and a loan

SELECT DISTINCT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    a.account_number,
    l.loan_id,
    l.loan_amount
FROM customer c
JOIN account a
    ON c.customer_id = a.customer_id
JOIN loan l
    ON c.customer_id = l.customer_id;

-- 17. Customer + address + account + branch

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ca.city AS customer_city,
    a.account_number,
    b.branch_name,
    b.city AS branch_city,
    a.balance
FROM customer c
JOIN customer_address ca
    ON c.customer_id = ca.customer_id
JOIN account a
    ON c.customer_id = a.customer_id
JOIN branch b
    ON a.branch_id = b.branch_id
ORDER BY c.customer_id;


-- G. CASE expression

-- 18. Categorize accounts based on balance

SELECT
    account_number,
    balance,
    CASE
        WHEN balance >= 500000 THEN 'High Balance'
        WHEN balance >= 100000 THEN 'Medium Balance'
        ELSE 'Low Balance'
    END AS balance_category
FROM account
ORDER BY balance DESC;

-- 19. Categorize loans based on amount

SELECT
    loan_id,
    loan_amount,
    CASE
        WHEN loan_amount >= 5000000 THEN 'Large Loan'
        WHEN loan_amount >= 1000000 THEN 'Medium Loan'
        ELSE 'Small Loan'
    END AS loan_category
FROM loan;


-- H. Date-based analysis

-- 20. Transactions in 2025

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM bank_transaction
WHERE YEAR(transaction_date) = 2025
ORDER BY transaction_date;

-- 21. Transactions by month

SELECT
    YEAR(transaction_date) AS transaction_year,
    MONTH(transaction_date) AS transaction_month,
    COUNT(*) AS number_of_transactions,
    SUM(amount) AS total_amount
FROM bank_transaction
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date)
ORDER BY
    transaction_year,
    transaction_month;