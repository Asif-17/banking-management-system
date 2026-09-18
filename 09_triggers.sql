USE banking_management;

-- =====================================================
-- 1. AUDIT LOG TABLE
-- =====================================================

DROP TABLE IF EXISTS audit_log;

CREATE TABLE audit_log (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    operation_type VARCHAR(20) NOT NULL,
    record_id BIGINT,
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 2. TRIGGER:
--    LOG NEW CUSTOMER
-- =====================================================

DROP TRIGGER IF EXISTS after_customer_insert;

DELIMITER $$

CREATE TRIGGER after_customer_insert
AFTER INSERT ON customer
FOR EACH ROW
BEGIN

    INSERT INTO audit_log
    (
        table_name,
        operation_type,
        record_id,
        new_value
    )
    VALUES
    (
        'customer',
        'INSERT',
        NEW.customer_id,
        CONCAT(
            'Customer created: ',
            NEW.first_name,
            ' ',
            NEW.last_name
        )
    );

END $$

DELIMITER ;


-- =====================================================
-- 3. TRIGGER:
--    LOG CUSTOMER UPDATE
-- =====================================================

DROP TRIGGER IF EXISTS after_customer_update;

DELIMITER $$

CREATE TRIGGER after_customer_update
AFTER UPDATE ON customer
FOR EACH ROW
BEGIN

    INSERT INTO audit_log
    (
        table_name,
        operation_type,
        record_id,
        old_value,
        new_value
    )
    VALUES
    (
        'customer',
        'UPDATE',
        NEW.customer_id,

        CONCAT(
            'Name: ',
            OLD.first_name,
            ' ',
            OLD.last_name,
            ', Phone: ',
            OLD.phone
        ),

        CONCAT(
            'Name: ',
            NEW.first_name,
            ' ',
            NEW.last_name,
            ', Phone: ',
            NEW.phone
        )
    );

END $$

DELIMITER ;


-- =====================================================
-- 4. TRIGGER:
--    LOG CUSTOMER DELETION
-- =====================================================

DROP TRIGGER IF EXISTS after_customer_delete;

DELIMITER $$

CREATE TRIGGER after_customer_delete
AFTER DELETE ON customer
FOR EACH ROW
BEGIN

    INSERT INTO audit_log
    (
        table_name,
        operation_type,
        record_id,
        old_value
    )
    VALUES
    (
        'customer',
        'DELETE',
        OLD.customer_id,
        CONCAT(
            'Deleted customer: ',
            OLD.first_name,
            ' ',
            OLD.last_name
        )
    );

END $$

DELIMITER ;


-- =====================================================
-- 5. TRIGGER:
--    PREVENT NEGATIVE ACCOUNT BALANCE
-- =====================================================

DROP TRIGGER IF EXISTS before_account_update;

DELIMITER $$

CREATE TRIGGER before_account_update
BEFORE UPDATE ON account
FOR EACH ROW
BEGIN

    IF NEW.balance < 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Account balance cannot be negative';

    END IF;

END $$

DELIMITER ;


-- =====================================================
-- 6. TRIGGER:
--    PREVENT EXCESSIVE LOAN PAYMENT
-- =====================================================

DROP TRIGGER IF EXISTS before_loan_payment_insert;

DELIMITER $$

CREATE TRIGGER before_loan_payment_insert
BEFORE INSERT ON loan_payment
FOR EACH ROW
BEGIN

    DECLARE v_outstanding DECIMAL(15,2);

    SELECT outstanding_amount
    INTO v_outstanding
    FROM loan
    WHERE loan_id = NEW.loan_id;

    IF v_outstanding IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Loan does not exist';

    ELSEIF NEW.payment_amount > v_outstanding THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Payment exceeds outstanding loan amount';

    END IF;

END $$

DELIMITER ;


-- =====================================================
-- 7. TRIGGER:
--    UPDATE LOAN OUTSTANDING AMOUNT
--    AFTER PAYMENT
-- =====================================================

DROP TRIGGER IF EXISTS after_loan_payment_insert;

DELIMITER $$

CREATE TRIGGER after_loan_payment_insert
AFTER INSERT ON loan_payment
FOR EACH ROW
BEGIN

    UPDATE loan
    SET outstanding_amount =
        outstanding_amount - NEW.payment_amount
    WHERE loan_id = NEW.loan_id;

    -- Mark loan as completed
    UPDATE loan
    SET status = 'Completed'
    WHERE loan_id = NEW.loan_id
      AND outstanding_amount = 0;

END $$

DELIMITER ;


-- =====================================================
-- 8. TRIGGER:
--    AUDIT ACCOUNT BALANCE CHANGES
-- =====================================================

DROP TRIGGER IF EXISTS after_account_update;

DELIMITER $$

CREATE TRIGGER after_account_update
AFTER UPDATE ON account
FOR EACH ROW
BEGIN

    IF OLD.balance <> NEW.balance THEN

        INSERT INTO audit_log
        (
            table_name,
            operation_type,
            record_id,
            old_value,
            new_value
        )
        VALUES
        (
            'account',
            'BALANCE_UPDATE',
            NEW.account_id,

            CONCAT(
                'Balance: ',
                OLD.balance
            ),

            CONCAT(
                'Balance: ',
                NEW.balance
            )
        );

    END IF;

END $$

DELIMITER ;


-- =====================================================
-- 9. TRIGGER:
--    PREVENT INVALID ACCOUNT NUMBER
-- =====================================================

DROP TRIGGER IF EXISTS before_account_insert;

DELIMITER $$

CREATE TRIGGER before_account_insert
BEFORE INSERT ON account
FOR EACH ROW
BEGIN

    IF NEW.account_number IS NULL
       OR LENGTH(NEW.account_number) < 10 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Invalid account number';

    END IF;

END $$

DELIMITER ;


-- =====================================================
-- 10. DISPLAY ALL TRIGGERS
-- =====================================================

SHOW TRIGGERS
FROM banking_management;


-- =====================================================
-- 11. DISPLAY AUDIT LOG
-- =====================================================

SELECT *
FROM audit_log
ORDER BY changed_at DESC;