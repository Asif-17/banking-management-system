USE banking_management;

-- =====================================================
-- 1. DEPOSIT MONEY
-- =====================================================

DROP PROCEDURE IF EXISTS deposit_money;

DELIMITER $$

CREATE PROCEDURE deposit_money(
    IN p_account_id INT,
    IN p_amount DECIMAL(15,2),
    IN p_description VARCHAR(255)
)
BEGIN
    DECLARE v_account_status VARCHAR(20);
    DECLARE v_transaction_type_id INT;

    -- Check whether account exists and get status
    SELECT status
    INTO v_account_status
    FROM account
    WHERE account_id = p_account_id;

    -- Check account status
    IF v_account_status IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account does not exist';

    ELSEIF v_account_status <> 'Active' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account is not active';

    ELSEIF p_amount <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Deposit amount must be greater than zero';

    ELSE

        -- Get Deposit transaction type
        SELECT transaction_type_id
        INTO v_transaction_type_id
        FROM transaction_type
        WHERE type_name = 'Deposit';

        -- Update account balance
        UPDATE account
        SET balance = balance + p_amount
        WHERE account_id = p_account_id;

        -- Record transaction
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
            p_account_id,
            v_transaction_type_id,
            p_amount,
            CONCAT('DEP-', UUID()),
            p_description
        );

        SELECT
            'Deposit successful' AS message,
            p_amount AS deposited_amount;

    END IF;

END $$

DELIMITER ;


-- =====================================================
-- 2. WITHDRAW MONEY
-- =====================================================

DROP PROCEDURE IF EXISTS withdraw_money;

DELIMITER $$

CREATE PROCEDURE withdraw_money(
    IN p_account_id INT,
    IN p_amount DECIMAL(15,2),
    IN p_description VARCHAR(255)
)
BEGIN
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_account_status VARCHAR(20);
    DECLARE v_transaction_type_id INT;

    -- Get account balance and status
    SELECT
        balance,
        status
    INTO
        v_balance,
        v_account_status
    FROM account
    WHERE account_id = p_account_id;

    -- Validate account
    IF v_account_status IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account does not exist';

    ELSEIF v_account_status <> 'Active' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account is not active';

    ELSEIF p_amount <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Withdrawal amount must be greater than zero';

    ELSEIF v_balance < p_amount THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient account balance';

    ELSE

        -- Get Withdrawal transaction type
        SELECT transaction_type_id
        INTO v_transaction_type_id
        FROM transaction_type
        WHERE type_name = 'Withdrawal';

        -- Deduct balance
        UPDATE account
        SET balance = balance - p_amount
        WHERE account_id = p_account_id;

        -- Record transaction
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
            p_account_id,
            v_transaction_type_id,
            p_amount,
            CONCAT('WDL-', UUID()),
            p_description
        );

        SELECT
            'Withdrawal successful' AS message,
            p_amount AS withdrawn_amount;

    END IF;

END $$

DELIMITER ;


-- =====================================================
-- 3. TRANSFER MONEY
-- =====================================================

DROP PROCEDURE IF EXISTS transfer_money;

DELIMITER $$

CREATE PROCEDURE transfer_money(
    IN p_source_account_id INT,
    IN p_destination_account_id INT,
    IN p_amount DECIMAL(15,2)
)
BEGIN

    DECLARE v_source_balance DECIMAL(15,2);
    DECLARE v_source_status VARCHAR(20);
    DECLARE v_destination_status VARCHAR(20);
    DECLARE v_transaction_type_id INT;
    DECLARE v_reference VARCHAR(50);

    -- Start transaction
    START TRANSACTION;

    -- Check amount
    IF p_amount <= 0 THEN

        ROLLBACK;

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transfer amount must be greater than zero';

    END IF;

    -- Prevent transfer to same account
    IF p_source_account_id = p_destination_account_id THEN

        ROLLBACK;

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Source and destination accounts cannot be the same';

    END IF;

    -- Get source account details
    SELECT
        balance,
        status
    INTO
        v_source_balance,
        v_source_status
    FROM account
    WHERE account_id = p_source_account_id
    FOR UPDATE;

    -- Get destination account status
    SELECT status
    INTO v_destination_status
    FROM account
    WHERE account_id = p_destination_account_id
    FOR UPDATE;

    -- Validate source account
    IF v_source_status IS NULL THEN

        ROLLBACK;

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Source account does not exist';

    ELSEIF v_source_status <> 'Active' THEN

        ROLLBACK;

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Source account is not active';

    END IF;

    -- Validate destination account
    IF v_destination_status IS NULL THEN

        ROLLBACK;

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Destination account does not exist';

    ELSEIF v_destination_status <> 'Active' THEN

        ROLLBACK;

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Destination account is not active';

    END IF;

    -- Check source balance
    IF v_source_balance < p_amount THEN

        ROLLBACK;

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance for transfer';

    END IF;

    -- Get Transfer transaction type
    SELECT transaction_type_id
    INTO v_transaction_type_id
    FROM transaction_type
    WHERE type_name = 'Transfer';

    -- Generate reference number
    SET v_reference = CONCAT('TRF-', UUID());

    -- Debit source account
    UPDATE account
    SET balance = balance - p_amount
    WHERE account_id = p_source_account_id;

    -- Credit destination account
    UPDATE account
    SET balance = balance + p_amount
    WHERE account_id = p_destination_account_id;

    -- Record source transaction
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
        p_source_account_id,
        v_transaction_type_id,
        p_amount,
        CONCAT(v_reference, '-D'),
        CONCAT('Transfer to account ', p_destination_account_id)
    );

    -- Record destination transaction
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
        p_destination_account_id,
        v_transaction_type_id,
        p_amount,
        CONCAT(v_reference, '-C'),
        CONCAT('Transfer from account ', p_source_account_id)
    );

    -- Everything successful
    COMMIT;

    SELECT
        'Transfer successful' AS message,
        p_amount AS transferred_amount,
        p_source_account_id AS source_account,
        p_destination_account_id AS destination_account;

END $$

DELIMITER ;


-- =====================================================
-- 4. MAKE LOAN PAYMENT
-- =====================================================

DROP PROCEDURE IF EXISTS make_loan_payment;

DELIMITER $$

CREATE PROCEDURE make_loan_payment(
    IN p_loan_id INT,
    IN p_payment_amount DECIMAL(15,2),
    IN p_payment_method VARCHAR(30)
)
BEGIN

    DECLARE v_outstanding DECIMAL(15,2);
    DECLARE v_status VARCHAR(20);

    SELECT
        outstanding_amount,
        status
    INTO
        v_outstanding,
        v_status
    FROM loan
    WHERE loan_id = p_loan_id;

    -- Check loan
    IF v_status IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loan does not exist';

    ELSEIF v_status <> 'Active' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loan is not active';

    ELSEIF p_payment_amount <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment amount must be greater than zero';

    ELSEIF p_payment_amount > v_outstanding THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment cannot exceed outstanding amount';

    ELSE

        -- Reduce outstanding loan amount
        UPDATE loan
        SET outstanding_amount =
            outstanding_amount - p_payment_amount
        WHERE loan_id = p_loan_id;

        -- Record payment
        INSERT INTO loan_payment
        (
            loan_id,
            payment_date,
            payment_amount,
            payment_method,
            reference_number
        )
        VALUES
        (
            p_loan_id,
            CURRENT_DATE,
            p_payment_amount,
            p_payment_method,
            CONCAT('LP-', UUID())
        );

        -- Mark loan completed if fully paid
        UPDATE loan
        SET status = 'Completed'
        WHERE loan_id = p_loan_id
          AND outstanding_amount = 0;

        SELECT
            'Loan payment successful' AS message,
            p_payment_amount AS payment_amount;

    END IF;

END $$

DELIMITER ;


-- =====================================================
-- CHECK STORED PROCEDURES
-- =====================================================

SHOW PROCEDURE STATUS
WHERE Db = 'banking_management';