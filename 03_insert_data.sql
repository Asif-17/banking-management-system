USE banking_management;

-- =====================================================
-- 1. BRANCH DATA
-- =====================================================

INSERT INTO branch
(branch_name, branch_code, address, city, state, phone)
VALUES
('Guwahati Main Branch', 'GWH001',
 'GS Road, Dispur', 'Guwahati', 'Assam', '03612345001'),

('Bangalore Central Branch', 'BLR001',
 'MG Road', 'Bangalore', 'Karnataka', '08023456001'),

('Mumbai Central Branch', 'MUM001',
 'Andheri East', 'Mumbai', 'Maharashtra', '02234567001'),

('Delhi Main Branch', 'DEL001',
 'Connaught Place', 'New Delhi', 'Delhi', '01145678001');


-- =====================================================
-- 2. CUSTOMER DATA
-- =====================================================

INSERT INTO customer
(first_name, last_name, date_of_birth, gender, phone, email, occupation, registration_date)
VALUES
('Rahul', 'Sharma', '1995-04-12', 'Male',
 '9876500001', 'rahul.sharma@gmail.com', 'Software Engineer', '2024-01-15'),

('Priya', 'Verma', '1997-08-21', 'Female',
 '9876500002', 'priya.verma@gmail.com', 'Doctor', '2024-02-10'),

('Amit', 'Das', '1993-11-05', 'Male',
 '9876500003', 'amit.das@gmail.com', 'Business Owner', '2024-03-12'),

('Sneha', 'Patel', '1998-02-17', 'Female',
 '9876500004', 'sneha.patel@gmail.com', 'Data Analyst', '2024-04-20'),

('Arjun', 'Mehta', '1992-06-30', 'Male',
 '9876500005', 'arjun.mehta@gmail.com', 'Architect', '2024-05-18'),

('Ananya', 'Rao', '1999-09-14', 'Female',
 '9876500006', 'ananya.rao@gmail.com', 'Student', '2024-06-25'),

('Vikram', 'Singh', '1990-01-22', 'Male',
 '9876500007', 'vikram.singh@gmail.com', 'Entrepreneur', '2024-07-10'),

('Neha', 'Khan', '1996-12-03', 'Female',
 '9876500008', 'neha.khan@gmail.com', 'Teacher', '2024-08-05'),

('Rohan', 'Bora', '1994-03-27', 'Male',
 '9876500009', 'rohan.bora@gmail.com', 'Civil Engineer', '2024-09-15'),

('Kavya', 'Nair', '1997-07-11', 'Female',
 '9876500010', 'kavya.nair@gmail.com', 'Marketing Manager', '2024-10-02'),

('Aditya', 'Iyer', '1991-05-19', 'Male',
 '9876500011', 'aditya.iyer@gmail.com', 'Consultant', '2024-10-25'),

('Meera', 'Joshi', '1995-10-08', 'Female',
 '9876500012', 'meera.joshi@gmail.com', 'Researcher', '2024-11-11');


-- =====================================================
-- 3. CUSTOMER ADDRESS
-- =====================================================

INSERT INTO customer_address
(customer_id, address_line, city, state, postal_code, address_type)
VALUES
(1, 'House 12, Beltola', 'Guwahati', 'Assam', '781028', 'Permanent'),
(2, '45 MG Road', 'Bangalore', 'Karnataka', '560001', 'Permanent'),
(3, '12 Zoo Road', 'Guwahati', 'Assam', '781024', 'Permanent'),
(4, '78 Satellite Road', 'Ahmedabad', 'Gujarat', '380015', 'Permanent'),
(5, '21 Andheri East', 'Mumbai', 'Maharashtra', '400069', 'Permanent'),
(6, '15 Koramangala', 'Bangalore', 'Karnataka', '560034', 'Permanent'),
(7, '9 Connaught Place', 'New Delhi', 'Delhi', '110001', 'Permanent'),
(8, '34 Jamia Nagar', 'New Delhi', 'Delhi', '110025', 'Permanent'),
(9, '17 Paltan Bazaar', 'Guwahati', 'Assam', '781008', 'Permanent'),
(10, '55 Ernakulam Road', 'Kochi', 'Kerala', '682011', 'Permanent'),
(11, '28 Powai', 'Mumbai', 'Maharashtra', '400076', 'Permanent'),
(12, '19 Vasant Kunj', 'New Delhi', 'Delhi', '110070', 'Permanent');


-- =====================================================
-- 4. KYC DETAILS
-- =====================================================

INSERT INTO kyc_details
(customer_id, document_type, document_number, verification_status, verification_date)
VALUES
(1, 'Aadhaar', 'AADH100001', 'Verified', '2024-01-16'),
(2, 'PAN', 'PAN100002', 'Verified', '2024-02-11'),
(3, 'Aadhaar', 'AADH100003', 'Verified', '2024-03-13'),
(4, 'PAN', 'PAN100004', 'Verified', '2024-04-21'),
(5, 'Aadhaar', 'AADH100005', 'Verified', '2024-05-19'),
(6, 'Aadhaar', 'AADH100006', 'Verified', '2024-06-26'),
(7, 'PAN', 'PAN100007', 'Verified', '2024-07-11'),
(8, 'Aadhaar', 'AADH100008', 'Pending', NULL),
(9, 'PAN', 'PAN100009', 'Verified', '2024-09-16'),
(10, 'Aadhaar', 'AADH100010', 'Verified', '2024-10-03'),
(11, 'PAN', 'PAN100011', 'Verified', '2024-10-26'),
(12, 'Aadhaar', 'AADH100012', 'Pending', NULL);


-- =====================================================
-- 5. EMPLOYEE DATA
-- =====================================================

INSERT INTO employee
(branch_id, first_name, last_name, designation, email, phone, joining_date)
VALUES
(1, 'Rajesh', 'Kumar', 'Branch Manager',
 'rajesh.kumar@bank.com', '9000000001', '2020-06-15'),

(1, 'Pooja', 'Sharma', 'Loan Officer',
 'pooja.sharma@bank.com', '9000000002', '2021-08-20'),

(2, 'Suresh', 'Reddy', 'Branch Manager',
 'suresh.reddy@bank.com', '9000000003', '2019-04-10'),

(2, 'Divya', 'Nair', 'Relationship Manager',
 'divya.nair@bank.com', '9000000004', '2022-01-12'),

(3, 'Manish', 'Gupta', 'Branch Manager',
 'manish.gupta@bank.com', '9000000005', '2018-09-05'),

(3, 'Asha', 'Menon', 'Cashier',
 'asha.menon@bank.com', '9000000006', '2021-11-18'),

(4, 'Deepak', 'Singh', 'Branch Manager',
 'deepak.singh@bank.com', '9000000007', '2019-07-22'),

(4, 'Nisha', 'Verma', 'Loan Officer',
 'nisha.verma@bank.com', '9000000008', '2023-03-14');


-- =====================================================
-- 6. ACCOUNT TYPES
-- =====================================================

INSERT INTO account_type
(type_name, minimum_balance, interest_rate, description)
VALUES
('Savings', 1000.00, 3.50,
 'Savings account for individuals'),

('Current', 5000.00, 0.00,
 'Current account for businesses'),

('Salary', 0.00, 4.00,
 'Salary account for employees'),

('Fixed Deposit', 10000.00, 6.50,
 'Fixed deposit account with higher interest');


-- =====================================================
-- 7. ACCOUNTS
-- =====================================================

INSERT INTO account
(customer_id, branch_id, account_type_id, account_number,
 balance, opening_date, status)
VALUES
(1, 1, 1, '100000000001', 85000.00, '2024-01-20', 'Active'),

(2, 2, 1, '100000000002', 125000.00, '2024-02-15', 'Active'),

(3, 1, 2, '100000000003', 250000.00, '2024-03-18', 'Active'),

(4, 2, 1, '100000000004', 67000.00, '2024-04-25', 'Active'),

(5, 3, 1, '100000000005', 145000.00, '2024-05-25', 'Active'),

(6, 2, 3, '100000000006', 45000.00, '2024-06-30', 'Active'),

(7, 4, 2, '100000000007', 520000.00, '2024-07-15', 'Active'),

(8, 4, 1, '100000000008', 32000.00, '2024-08-10', 'Blocked'),

(9, 1, 1, '100000000009', 91000.00, '2024-09-20', 'Active'),

(10, 3, 1, '100000000010', 73000.00, '2024-10-07', 'Active'),

(11, 3, 4, '100000000011', 300000.00, '2024-10-30', 'Active'),

(12, 4, 1, '100000000012', 56000.00, '2024-11-15', 'Active'),

-- Customer 1 has a second account
(1, 1, 4, '100000000013', 200000.00, '2024-12-01', 'Active'),

-- Customer 3 has a second account
(3, 1, 1, '100000000014', 48000.00, '2025-01-10', 'Active'),

-- Closed account for testing
(6, 2, 1, '100000000015', 0.00, '2024-07-05', 'Closed');


-- =====================================================
-- 8. TRANSACTION TYPES
-- =====================================================

INSERT INTO transaction_type
(type_name, description)
VALUES
('Deposit', 'Cash or electronic deposit'),

('Withdrawal', 'Cash withdrawal from account'),

('Transfer', 'Account-to-account transfer'),

('Interest', 'Interest credited to account'),

('Fee', 'Bank service fee');


-- =====================================================
-- 9. BANK TRANSACTIONS
-- =====================================================

INSERT INTO bank_transaction
(account_id, transaction_type_id, amount,
 transaction_date, reference_number, description)
VALUES

-- Account 1
(1, 1, 50000.00, '2025-01-05 10:30:00',
 'TXN100001', 'Initial deposit'),

(1, 1, 40000.00, '2025-03-10 11:15:00',
 'TXN100002', 'Salary credit'),

(1, 2, 5000.00, '2025-04-02 14:20:00',
 'TXN100003', 'ATM withdrawal'),

-- Account 2
(2, 1, 100000.00, '2025-01-15 09:45:00',
 'TXN100004', 'Salary credit'),

(2, 1, 50000.00, '2025-03-15 10:00:00',
 'TXN100005', 'Additional deposit'),

(2, 2, 25000.00, '2025-04-10 16:30:00',
 'TXN100006', 'Cash withdrawal'),

-- Account 3
(3, 1, 300000.00, '2025-02-01 12:00:00',
 'TXN100007', 'Business deposit'),

(3, 2, 50000.00, '2025-03-20 13:30:00',
 'TXN100008', 'Business withdrawal'),

-- Account 4
(4, 1, 70000.00, '2025-02-15 09:30:00',
 'TXN100009', 'Salary credit'),

(4, 2, 3000.00, '2025-04-15 15:20:00',
 'TXN100010', 'ATM withdrawal'),

-- Account 5
(5, 1, 150000.00, '2025-01-25 10:45:00',
 'TXN100011', 'Salary credit'),

(5, 2, 5000.00, '2025-03-25 17:00:00',
 'TXN100012', 'ATM withdrawal'),

-- Account 6
(6, 1, 50000.00, '2025-02-10 11:00:00',
 'TXN100013', 'Salary credit'),

(6, 2, 5000.00, '2025-04-05 12:15:00',
 'TXN100014', 'Cash withdrawal'),

-- Account 7
(7, 1, 600000.00, '2025-01-10 09:15:00',
 'TXN100015', 'Business deposit'),

(7, 2, 80000.00, '2025-03-10 14:00:00',
 'TXN100016', 'Business withdrawal'),

-- Account 9
(9, 1, 100000.00, '2025-02-05 10:30:00',
 'TXN100017', 'Salary credit'),

(9, 2, 9000.00, '2025-04-01 11:45:00',
 'TXN100018', 'ATM withdrawal'),

-- Account 10
(10, 1, 80000.00, '2025-02-20 13:15:00',
 'TXN100019', 'Salary credit'),

(10, 2, 7000.00, '2025-04-12 16:00:00',
 'TXN100020', 'ATM withdrawal'),

-- Account 11
(11, 1, 300000.00, '2025-01-30 10:00:00',
 'TXN100021', 'Fixed deposit'),

-- Account 12
(12, 1, 60000.00, '2025-02-28 09:50:00',
 'TXN100022', 'Salary credit'),

(12, 2, 4000.00, '2025-04-20 15:00:00',
 'TXN100023', 'ATM withdrawal'),

-- Account 13
(13, 1, 200000.00, '2025-01-01 10:00:00',
 'TXN100024', 'Fixed deposit'),

-- Account 14
(14, 1, 50000.00, '2025-02-10 10:30:00',
 'TXN100025', 'Initial deposit');


-- =====================================================
-- 10. BENEFICIARIES
-- =====================================================

INSERT INTO beneficiary
(customer_id, account_id, beneficiary_name, nickname, added_date, status)
VALUES
(1, 2, 'Priya Verma', 'Priya', '2025-01-10', 'Active'),
(1, 3, 'Amit Das', 'Amit', '2025-01-12', 'Active'),
(2, 1, 'Rahul Sharma', 'Rahul', '2025-02-20', 'Active'),
(3, 5, 'Arjun Mehta', 'Arjun', '2025-03-05', 'Active'),
(4, 6, 'Ananya Rao', 'Ananya', '2025-03-15', 'Active'),
(5, 7, 'Vikram Singh', 'Vikram', '2025-04-01', 'Blocked'),
(7, 9, 'Rohan Bora', 'Rohan', '2025-04-05', 'Active');


-- =====================================================
-- 11. LOAN TYPES
-- =====================================================

INSERT INTO loan_type
(type_name, interest_rate, maximum_amount,
 maximum_tenure_months, description)
VALUES
('Home Loan', 7.50, 10000000.00, 240,
 'Loan for purchasing or constructing a house'),

('Personal Loan', 11.50, 2000000.00, 60,
 'Unsecured personal loan'),

('Education Loan', 8.00, 5000000.00, 120,
 'Loan for higher education'),

('Business Loan', 10.00, 50000000.00, 120,
 'Loan for business purposes');


-- =====================================================
-- 12. LOANS
-- =====================================================

INSERT INTO loan
(customer_id, branch_id, loan_type_id, loan_amount,
 outstanding_amount, interest_rate, start_date, end_date, status)
VALUES
(1, 1, 3, 800000.00, 650000.00, 8.00,
 '2025-01-15', '2035-01-15', 'Active'),

(3, 1, 4, 5000000.00, 4200000.00, 10.00,
 '2025-02-10', '2035-02-10', 'Active'),

(5, 3, 1, 6000000.00, 5500000.00, 7.50,
 '2025-03-01', '2045-03-01', 'Active'),

(7, 4, 2, 1000000.00, 750000.00, 11.50,
 '2025-03-15', '2030-03-15', 'Active'),

(9, 1, 3, 500000.00, 0.00, 8.00,
 '2023-01-10', '2028-01-10', 'Completed'),

(10, 3, 2, 750000.00, 500000.00, 11.50,
 '2025-04-01', '2030-04-01', 'Active');


-- =====================================================
-- 13. LOAN PAYMENTS
-- =====================================================

INSERT INTO loan_payment
(loan_id, payment_date, payment_amount,
 payment_method, reference_number)
VALUES
(1, '2025-03-15', 75000.00, 'Online', 'LP100001'),
(1, '2025-04-15', 75000.00, 'Online', 'LP100002'),

(2, '2025-03-20', 400000.00, 'Bank Transfer', 'LP100003'),
(2, '2025-04-20', 400000.00, 'Bank Transfer', 'LP100004'),

(3, '2025-04-01', 250000.00, 'Online', 'LP100005'),

(4, '2025-04-15', 125000.00, 'Online', 'LP100006'),

(5, '2024-12-15', 100000.00, 'Online', 'LP100007'),

(6, '2025-04-10', 125000.00, 'Online', 'LP100008');


-- =====================================================
-- 14. CARD TYPES
-- =====================================================

INSERT INTO card_type
(type_name, daily_limit, annual_fee)
VALUES
('Debit Card', 50000.00, 500.00),
('Premium Debit Card', 100000.00, 1000.00),
('Credit Card', 200000.00, 1500.00);


-- =====================================================
-- 15. CARDS
-- =====================================================

INSERT INTO card
(account_id, card_type_id, card_number,
 issue_date, expiry_date, status)
VALUES
(1, 1, '4111111111111001',
 '2024-02-01', '2029-02-01', 'Active'),

(2, 2, '4111111111111002',
 '2024-03-01', '2029-03-01', 'Active'),

(3, 3, '4111111111111003',
 '2024-04-01', '2029-04-01', 'Active'),

(4, 1, '4111111111111004',
 '2024-05-01', '2029-05-01', 'Active'),

(5, 2, '4111111111111005',
 '2024-06-01', '2029-06-01', 'Active'),

(6, 1, '4111111111111006',
 '2024-07-01', '2029-07-01', 'Blocked'),

(7, 3, '4111111111111007',
 '2024-08-01', '2029-08-01', 'Active'),

(9, 1, '4111111111111009',
 '2024-10-01', '2029-10-01', 'Active'),

(10, 1, '4111111111111010',
 '2024-11-01', '2029-11-01', 'Active'),

(12, 2, '4111111111111012',
 '2024-12-01', '2029-12-01', 'Active');
 


UPDATE branch
SET
    branch_name = 'Hyderabad Main Branch',
    address = 'Banjara Hills',
    city = 'Hyderabad',
    state = 'Telangana',
    phone = '04023450001'
WHERE branch_code = 'GWH001';


-- Update the branch code as well
UPDATE branch
SET branch_code = 'HYD001'
WHERE branch_id = 1;




UPDATE customer_address
SET
    address_line = '12 Budhawarpet',
    city = 'Kurnool',
    state = 'Andhra Pradesh',
    postal_code = '518001'
WHERE customer_id = 3;


UPDATE customer_address
SET
    address_line = '45 Kallur Road',
    city = 'Kurnool',
    state = 'Andhra Pradesh',
    postal_code = '518003'
WHERE customer_id = 9;


SHOW TABLES;

SELECT * FROM customer;

SELECT * FROM account;

SELECT * FROM bank_transaction;