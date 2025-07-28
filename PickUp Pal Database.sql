-- PICKUP PAL DATABASE --
-- ======================================
-- USERS TABLE
-- Stores all users: parents, drivers, admins
CREATE TABLE PickUpPal.Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,               -- Unique ID for each user, increases automatically
  full_name VARCHAR(100) NOT NULL,                      -- The user's full name
  email VARCHAR(100) NOT NULL,                          -- User's email (must be unique)
  phone_number VARCHAR(20) NOT NULL,                    -- User's phone number
  `role` ENUM('parent', 'driver', 'admin') NOT NULL,    -- Type of user
  password VARCHAR(100) NOT NULL,                       -- Encrypted password
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,        -- Time the user was added
  CONSTRAINT UN_email UNIQUE (email)                    -- Prevent duplicate emails
)
;


-- ======================================
-- STUDENTS TABLE
-- Each student belongs to a parent
CREATE TABLE PickUpPal.Students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique student ID
  full_name VARCHAR(100) NOT NULL,                      -- Student's name
  grade VARCHAR(20),                                    -- Grade in school (e.g. "5th")
  school_name VARCHAR(100),                             -- Name of the school they attend
  user_id INT NOT NULL,                                 -- The parent who manages this student
  FOREIGN KEY (user_id) REFERENCES PickUpPal.Users(user_id)
)
;


-- ======================================
-- STUDENT-PARENT MAPPING TABLE
-- Supports multiple parents per student
CREATE TABLE PickUpPal.StudentParentMap (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,                              -- Student's ID
  parent_id INT NOT NULL,                               -- Parent's ID
  relationship VARCHAR(50) DEFAULT 'parent',            -- Example: mother, father
  FOREIGN KEY (student_id) REFERENCES PickUpPal.Students(student_id),
  FOREIGN KEY (parent_id) REFERENCES PickUpPal.Users(user_id),
  UNIQUE(student_id, parent_id)                         -- Prevents duplicate pairs
)
;


-- ======================================
-- GUARDIANS TABLE
-- Stores emergency contacts for students
CREATE TABLE PickUpPal.Guardians (
  guardian_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,                              -- Linked student
  full_name VARCHAR(100),                               -- Guardian's name
  phone_number VARCHAR(20),                             -- Guardian's phone
  relationship VARCHAR(50),                             -- Example: Aunt, Brother
  FOREIGN KEY (student_id) REFERENCES PickUpPal.Students(student_id)
)
;


-- ======================================
-- DRIVERS TABLE
-- Each driver links to a user and has car details
CREATE TABLE PickUpPal.Drivers (
  driver_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,                                           -- User ID for this driver
  licence_plate VARCHAR(50) NOT NULL,                    -- Their vehicle's plate number
  verified BOOLEAN DEFAULT FALSE,                        -- If they have been approved
  FOREIGN KEY (user_id) REFERENCES PickUpPal.Users(user_id)
)
;


-- ======================================
-- VEHICLES TABLE
-- All vehicles used for trips
CREATE TABLE PickUpPal.Vehicle (
  vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
  plate_number VARCHAR(20) NOT NULL,                     -- Car’s plate number
  model VARCHAR(50),                                     -- Car model (e.g., Toyota Hiace)
  capacity INT,                                          -- How many students it can carry
  `year` YEAR,                                           -- Year car was made
  CONSTRAINT UK_vehicle UNIQUE (plate_number)            -- No duplicate plate numbers
)
;


-- ======================================
-- DRIVER–CAR USAGE TABLE
-- Tracks which driver used which car and when
CREATE TABLE PickUpPal.Drivers_Car (
  id INT AUTO_INCREMENT PRIMARY KEY,
  driver_id INT,                                         -- Driver who used the car
  car_id INT NOT NULL,                                   -- Car that was used
  start_date DATE,                                       -- When the driver started using the car
  end_date DATE,                                         -- When they stopped using it
  FOREIGN KEY (driver_id) REFERENCES PickUpPal.Drivers(driver_id),
  FOREIGN KEY (car_id) REFERENCES PickUpPal.Vehicle(vehicle_id)
)
;


-- ======================================
-- SCHOOLS TABLE
-- Basic school information
CREATE TABLE PickUpPal.Schools (
  school_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),                                     -- School name
  address TEXT,                                          -- School address
  contact_email VARCHAR(100),                            -- Email for contact
  phone_number VARCHAR(15)                               -- Phone number
)
;


-- ======================================
-- SHIFTS TABLE
-- Represents school pickup windows (Morning Shift)
CREATE TABLE PickUpPal.Shifts (
  shift_id INT AUTO_INCREMENT PRIMARY KEY,
  school_id INT,                                         -- Which school the shift belongs to
  shift_name VARCHAR(50),                                -- Name like "Morning", "Afternoon"
  start_time TIME,
  end_time TIME,
  FOREIGN KEY (school_id) REFERENCES PickUpPal.Schools(school_id)
)
;


-- ======================================
-- ROUTES TABLE
-- All predefined trip paths
CREATE TABLE PickUpPal.Routes (
  route_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),                                     -- Example: "Route A"
  origin VARCHAR(100),                                   -- Start location
  destination VARCHAR(100),                              -- End location
  estimated_time TIME                                    -- How long it usually takes
)
;


-- ======================================
-- TRIPS TABLE
-- A trip is a scheduled or completed route driven
CREATE TABLE PickUpPal.Trips (
  trip_id INT AUTO_INCREMENT PRIMARY KEY,
  driver_id INT NOT NULL,                                -- Driver assigned
  route_id INT NOT NULL,                                 -- Route being followed
  trip_date DATE,                                        -- When the trip happens
  status ENUM('scheduled', 'in_progress', 'completed', 'cancelled'),
  FOREIGN KEY (driver_id) REFERENCES PickUpPal.Drivers(driver_id),
  FOREIGN KEY (route_id) REFERENCES PickUpPal.Routes(route_id)
)
;


-- ======================================
-- TRIP LOCATIONS TABLE
-- Stores each stop in a trip
CREATE TABLE PickUpPal.Trip_Locations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  trip_id INT NOT NULL,
  stop_name VARCHAR(100),                                -- Name of stop (e.g., "Stop 1")
  stop_time TIME,                                        -- Expected arrival time
  stop_order INT,                                        -- Order of stops (1, 2, 3)
  latitude DECIMAL(9,6),                                 -- Location latitude
  longitude DECIMAL(9,6),                                -- Location longitude
  FOREIGN KEY (trip_id) REFERENCES PickUpPal.Trips(trip_id)
)
;


-- ======================================
-- TRIP ATTENDANCE TABLE
-- Tracks if students boarded or left the bus
CREATE TABLE PickUpPal.TripAttendance (
  attendance_id INT AUTO_INCREMENT PRIMARY KEY,
  trip_id INT NOT NULL,
  student_id INT NOT NULL,
  boarded_at TIMESTAMP,                                  -- Time they boarded
  alighted_at TIMESTAMP,                                 -- Time they got off
  confirmed_by_driver BOOLEAN DEFAULT FALSE,             -- Did driver confirm?
  FOREIGN KEY (trip_id) REFERENCES PickUpPal.Trips(trip_id),
  FOREIGN KEY (student_id) REFERENCES PickUpPal.Students(student_id)
)
;


-- ======================================
-- RATINGS TABLE
-- Parents leave feedback for drivers
CREATE TABLE PickUpPal.Ratings (
  rating_id INT AUTO_INCREMENT PRIMARY KEY,
  trip_id INT NOT NULL,
  parent_id INT NOT NULL,
  driver_id INT NOT NULL,
  stars INT CHECK (stars BETWEEN 1 AND 5),               -- 1 to 5 rating
  comment TEXT,                                          -- Optional comment
  submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (trip_id) REFERENCES PickUpPal.Trips(trip_id),
  FOREIGN KEY (parent_id) REFERENCES PickUpPal.Users(user_id),
  FOREIGN KEY (driver_id) REFERENCES PickUpPal.Drivers(driver_id)
)
;


-- ======================================
-- PAYMENTS TABLE
-- Keeps record of payments for rides
CREATE TABLE PickUpPal.Payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  parent_id INT NOT NULL,
  trip_id INT NOT NULL,
  amount DECIMAL(10,2),                                  -- Amount paid
  status ENUM('pending', 'paid', 'failed'),              -- Payment status
  payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES PickUpPal.Users(user_id),
  FOREIGN KEY (trip_id) REFERENCES PickUpPal.Trips(trip_id)
)
;


-- ======================================
-- PAYMENT METHODS TABLE
-- User's saved payment preferences
CREATE TABLE PickUpPal.Payment_Methods (
  method_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  method_type ENUM('card', 'mobile_wallet', 'bank_transfer'), -- Type of payment
  provider_name VARCHAR(100),                            -- Example: Visa, Mtn MoMo
  FOREIGN KEY (user_id) REFERENCES PickUpPal.Users(user_id)
)
;


-- ======================================
-- DRIVER PAYOUTS TABLE
-- Records payment given to drivers
CREATE TABLE PickUpPal.DriverPayouts (
  payout_id INT AUTO_INCREMENT PRIMARY KEY,
  driver_id INT NOT NULL,
  trip_id INT,
  amount DECIMAL(10,2) NOT NULL,
  payout_status ENUM('pending', 'processed', 'failed') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (driver_id) REFERENCES PickUpPal.Users(user_id),
  FOREIGN KEY (trip_id) REFERENCES PickUpPal.Trips(trip_id)
)
;


-- ======================================
-- FARES TABLE
-- Price of each route
CREATE TABLE PickUpPal.Fares (
  fare_id INT AUTO_INCREMENT PRIMARY KEY,
  route_id INT NOT NULL,
  base_fare DECIMAL(10,2),                               -- Starting price
  price_per_km DECIMAL(10,2),                            -- Extra cost per km
  FOREIGN KEY (route_id) REFERENCES PickUpPal.Routes(route_id)
)
;


-- ======================================
-- DOCUMENTS TABLE
-- Stores user documents like ID or license
CREATE TABLE PickUpPal.Documents (
  document_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  type VARCHAR(50),                                      -- Example: "License"
  file_url TEXT,                                         -- Where the file is stored
  verified_at TIMESTAMP,                                 -- When document was verified
  FOREIGN KEY (user_id) REFERENCES PickUpPal.Users(user_id)
)
;


-- ======================================
-- AUDIT LOGS TABLE
-- Tracks changes and actions made in the system
CREATE TABLE PickUpPal.AuditLogs (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,                                           -- Who did the action
  action TEXT,                                           -- Description of what they did
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45),                                -- IP of user (IPv4 or IPv6)
  FOREIGN KEY (user_id) REFERENCES PickUpPal.Users(user_id)
)
;


-- ======================================
-- ALERTS TABLE
-- Emergency or status messages from drivers
CREATE TABLE PickUpPal.Alerts (
  alert_id INT AUTO_INCREMENT PRIMARY KEY,
  driver_id INT NOT NULL,
  trip_id INT,
  alert_type ENUM('sos', 'delay', 'info', 'general') DEFAULT 'general',
  message TEXT,                                          -- What the alert is about
  alert_time DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (driver_id) REFERENCES PickUpPal.Drivers(driver_id),
  FOREIGN KEY (trip_id) REFERENCES PickUpPal.Trips(trip_id)
)
;


-- ======================================
-- MESSAGES TABLE
-- Messaging between users (e.g., parents & drivers)
CREATE TABLE PickUpPal.Messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  content TEXT NOT NULL,                                 -- The message body
  sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_id) REFERENCES PickUpPal.Users(user_id),
  FOREIGN KEY (receiver_id) REFERENCES PickUpPal.Users(user_id)
)
;
