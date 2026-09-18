USE banking_management;

-- Create Manager User
CREATE USER IF NOT EXISTS
'bank_manager'@'localhost'
IDENTIFIED BY 'Manager123!';

-- Create Teller User
CREATE USER IF NOT EXISTS
'bank_teller'@'localhost'
IDENTIFIED BY 'Teller123!';

-- Create Auditor User
CREATE USER IF NOT EXISTS
'bank_auditor'@'localhost'
IDENTIFIED BY 'Auditor123!';


-- =====================================================
-- MANAGER PERMISSIONS
-- =====================================================

GRANT ALL PRIVILEGES
ON banking_management.*
TO 'bank_manager'@'localhost';


-- =====================================================
-- TELLER PERMISSIONS
-- =====================================================

GRANT SELECT, INSERT, UPDATE
ON banking_management.account
TO 'bank_teller'@'localhost';

GRANT SELECT, INSERT
ON banking_management.bank_transaction
TO 'bank_teller'@'localhost';


-- =====================================================
-- AUDITOR PERMISSIONS
-- =====================================================

GRANT SELECT
ON banking_management.*
TO 'bank_auditor'@'localhost';


-- Apply changes
FLUSH PRIVILEGES;


-- =====================================================
-- SHOW GRANTS
-- =====================================================

SHOW GRANTS FOR
'bank_manager'@'localhost';

SHOW GRANTS FOR
'bank_teller'@'localhost';

SHOW GRANTS FOR
'bank_auditor'@'localhost';


-- =====================================================
-- REVOKE EXAMPLE
-- =====================================================

REVOKE UPDATE
ON banking_management.account
FROM 'bank_teller'@'localhost';


SHOW GRANTS FOR
'bank_teller'@'localhost';