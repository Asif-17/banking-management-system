USE banking_management;

-- =====================================================
-- 1. CUSTOMER
-- =====================================================

CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(20),
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    occupation VARCHAR(100),
    registration_date DATE NOT NULL DEFAULT (CURRENT_DATE)
);


-- =====================================================
-- 2. CUSTOMER ADDRESS
-- =====================================================

CREATE TABLE customer_address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_line VARCHAR(200) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    address_type VARCHAR(20) DEFAULT 'Permanent',

    CONSTRAINT fk_address_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- =====================================================
-- 3. KYC DETAILS
-- =====================================================

CREATE TABLE kyc_details (
    kyc_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE,
    document_type VARCHAR(50) NOT NULL,
    document_number VARCHAR(50) NOT NULL UNIQUE,
    verification_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    verification_date DATE,

    CONSTRAINT fk_kyc_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_kyc_status
        CHECK (verification_status IN ('Pending', 'Verified', 'Rejected'))
);


-- =====================================================
-- 4. BRANCH
-- =====================================================

CREATE TABLE branch (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_code VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(200) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    phone VARCHAR(15)
);


-- =====================================================
-- 5. EMPLOYEE
-- =====================================================

CREATE TABLE employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    designation VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    joining_date DATE NOT NULL,

    CONSTRAINT fk_employee_branch
        FOREIGN KEY (branch_id)
        REFERENCES branch(branch_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- =====================================================
-- 6. ACCOUNT TYPE
-- =====================================================

CREATE TABLE account_type (
    account_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    minimum_balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    interest_rate DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    description VARCHAR(255)
);


-- =====================================================
-- 7. ACCOUNT
-- =====================================================

CREATE TABLE account (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_type_id INT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    opening_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_account_branch
        FOREIGN KEY (branch_id)
        REFERENCES branch(branch_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_account_type
        FOREIGN KEY (account_type_id)
        REFERENCES account_type(account_type_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_account_balance
        CHECK (balance >= 0),

    CONSTRAINT chk_account_status
        CHECK (status IN ('Active', 'Blocked', 'Closed'))
);


-- =====================================================
-- 8. TRANSACTION TYPE
-- =====================================================

CREATE TABLE transaction_type (
    transaction_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);


-- =====================================================
-- 9. BANK TRANSACTION
-- =====================================================

CREATE TABLE bank_transaction (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reference_number VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),

    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id)
        REFERENCES account(account_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_transaction_type
        FOREIGN KEY (transaction_type_id)
        REFERENCES transaction_type(transaction_type_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_transaction_amount
        CHECK (amount > 0)
);


-- =====================================================
-- 10. BENEFICIARY
-- =====================================================

CREATE TABLE beneficiary (
    beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_id INT NOT NULL,
    beneficiary_name VARCHAR(100) NOT NULL,
    nickname VARCHAR(50),
    added_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT fk_beneficiary_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_beneficiary_account
        FOREIGN KEY (account_id)
        REFERENCES account(account_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_beneficiary_status
        CHECK (status IN ('Active', 'Blocked'))
);


-- =====================================================
-- 11. LOAN TYPE
-- =====================================================

CREATE TABLE loan_type (
    loan_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    interest_rate DECIMAL(5,2) NOT NULL,
    maximum_amount DECIMAL(15,2) NOT NULL,
    maximum_tenure_months INT NOT NULL,
    description VARCHAR(255)
);


-- =====================================================
-- 12. LOAN
-- =====================================================

CREATE TABLE loan (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    loan_type_id INT NOT NULL,
    loan_amount DECIMAL(15,2) NOT NULL,
    outstanding_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT fk_loan_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_loan_branch
        FOREIGN KEY (branch_id)
        REFERENCES branch(branch_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_loan_type
        FOREIGN KEY (loan_type_id)
        REFERENCES loan_type(loan_type_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_loan_amount
        CHECK (loan_amount > 0),

    CONSTRAINT chk_outstanding_amount
        CHECK (outstanding_amount >= 0),

    CONSTRAINT chk_loan_status
        CHECK (status IN ('Active', 'Completed', 'Defaulted', 'Closed'))
);


-- =====================================================
-- 13. LOAN PAYMENT
-- =====================================================

CREATE TABLE loan_payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    payment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    payment_amount DECIMAL(15,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    reference_number VARCHAR(50) NOT NULL UNIQUE,

    CONSTRAINT fk_payment_loan
        FOREIGN KEY (loan_id)
        REFERENCES loan(loan_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_payment_amount
        CHECK (payment_amount > 0)
);


-- =====================================================
-- 14. CARD TYPE
-- =====================================================

CREATE TABLE card_type (
    card_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    daily_limit DECIMAL(15,2) NOT NULL,
    annual_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00
);


-- =====================================================
-- 15. CARD
-- =====================================================

CREATE TABLE card (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    card_type_id INT NOT NULL,
    card_number VARCHAR(20) NOT NULL UNIQUE,
    issue_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    expiry_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT fk_card_account
        FOREIGN KEY (account_id)
        REFERENCES account(account_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_card_type
        FOREIGN KEY (card_type_id)
        REFERENCES card_type(card_type_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_card_status
        CHECK (status IN ('Active', 'Blocked', 'Expired', 'Cancelled'))
);