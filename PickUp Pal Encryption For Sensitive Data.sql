-- ENCRYPTION FOR SENSITIVE DATA
-- ======================================
-- ENCRYPTION: MODIFY COLUMNS FOR ENCRYPTED DATA
-- Converts columns to VARBINARY to allow encrypted values
ALTER TABLE PickUpPal.Users
MODIFY phone_number VARBINARY(255),   -- Changed from VARCHAR to VARBINARY for encryption
MODIFY email VARBINARY(255);          -- Same for email


-- ======================================
-- ENCRYPTION: STORE ENCRYPTED PHONE AND EMAIL
-- Encrypts values using AES_ENCRYPT and encodes with TO_BASE64
-- Replace 'YourStrongSecretKey!' with your secure 16/32-byte key
UPDATE PickUpPal.Users
SET phone_number = TO_BASE64(AES_ENCRYPT('0123456789', 'YourStrongSecretKey!')),
    email = TO_BASE64(AES_ENCRYPT('test@example.com', 'YourStrongSecretKey!'))
WHERE user_id = 1;


-- ======================================
-- ENCRYPTION: DECRYPT ENCRYPTED VALUES
-- Used by backend or admin to retrieve original values
SELECT 
  user_id,
  AES_DECRYPT(FROM_BASE64(phone_number), 'YourStrongSecretKey!') AS phone_number,
  AES_DECRYPT(FROM_BASE64(email), 'YourStrongSecretKey!') AS email
FROM PickUpPal.Users;

SELECT first_name, last_name, age
    FROM PickUpPal.drivers 
    WHERE age => 75
CASE 
    first_name, last_name
    barcode = #@05145;
WHERE emails, age_range =+ 23678
    
print("YourStrongSecretKey!:", secretkeyd



    END
    ;

-- ======================================
-- SECURITY: MYSQL ROLES AND PERMISSIONS
-- Creates roles and assigns specific privileges for access control
CREATE ROLE 'PARENT', 'DRIVER', 'ADMIN';

-- Assign specific rights to each role
GRANT SELECT ON Messages TO 'PARENT';                    -- Can view messages
GRANT INSERT, SELECT ON TripAttendance TO 'DRIVER';      -- Drivers can record attendance
GRANT ALL ON *.* TO 'ADMIN';                             -- Admin has full access


-- ======================================
-- ENCRYPTION: CUSTOM FUNCTIONS FOR ENCRYPTION/DECRYPTION
-- These functions simplify encrypting and decrypting values
CREATE FUNCTION encrypt_email(val TEXT) RETURNS BLOB
RETURN AES_ENCRYPT(val, 'your_secure_key');

CREATE FUNCTION decrypt_email(val BLOB) RETURNS TEXT
RETURN AES_DECRYPT(val, 'your_secure_key');

-- Encrypt emails using the function
UPDATE Users SET email = encrypt_email(email);


-- ======================================
-- SECURITY: CREATE PUBLIC VIEW WITHOUT SENSITIVE DATA
-- View shows only non-sensitive fields to general users
CREATE VIEW PublicUsers AS
SELECT user_id, name, role
FROM Users;

