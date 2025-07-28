-- ROLE-BASED ACCESS CONTROL (RBAC)
-- Manages what different MySQL users can access/do
-- ======================================

-- A. CREATE MYSQL USERS
-- These are actual MySQL accounts for people using the system
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'adminpass';     -- Admin user
CREATE USER 'driver_user'@'localhost' IDENTIFIED BY 'driverpass';   -- Driver user
CREATE USER 'parent_user'@'localhost' IDENTIFIED BY 'parentpass';   -- Parent user


-- B. GRANT ROLE-SPECIFIC ACCESS TO USERS

-- ADMIN: Full access to everything in PickUpPal database
GRANT ALL PRIVILEGES ON PickUpPal.* TO 'admin_user'@'localhost';

-- DRIVER: Can view trip schedules and send messages
GRANT SELECT ON PickUpPal.Trips TO 'driver_user'@'localhost';
GRANT SELECT, INSERT ON PickUpPal.Messages TO 'driver_user'@'localhost';

-- PARENT: Can send messages and view/make payments
GRANT SELECT, INSERT ON PickUpPal.Messages TO 'parent_user'@'localhost';
GRANT SELECT, INSERT ON PickUpPal.Payments TO 'parent_user'@'localhost';


-- C. APPLY CHANGES
-- This makes the permission changes take effect
FLUSH PRIVILEGES;
