- PICKUP PAL DATABASE
CREATE DATABASE IF NOT EXISTS PickUpPal;
USE PickUpPal;


-- ======================================
-- USERS TABLE
CREATE TABLE Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone_number VARCHAR(20) NOT NULL,
  role ENUM('parent', 'driver', 'admin') NOT NULL,
  password VARCHAR(100) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- ======================================
-- SCHOOLS TABLE
CREATE TABLE Schools (
  school_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  address TEXT,
  contact_email VARCHAR(100),
  phone_number VARCHAR(15)
);


-- ======================================
-- STUDENTS TABLE
CREATE TABLE Students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  grade VARCHAR(20),
  school_id INT,
  user_id INT NOT NULL,
  FOREIGN KEY (school_id) REFERENCES Schools(school_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


-- ======================================
-- STUDENT-PARENT MAPPING TABLE
CREATE TABLE StudentParentMap (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  parent_id INT NOT NULL,
  relationship VARCHAR(50) NOT NULL DEFAULT 'parent',
  FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (parent_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  UNIQUE(student_id, parent_id)
);


-- ======================================
-- GUARDIANS TABLE
CREATE TABLE Guardians (
  guardian_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  phone_number VARCHAR(20) NOT NULL,
  relationship VARCHAR(50) NOT NULL,
  FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);


-- ======================================
-- DRIVERS TABLE
CREATE TABLE Drivers (
  driver_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  licence_plate VARCHAR(50) NOT NULL,
  verified BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


-- ======================================
-- VEHICLES TABLE
CREATE TABLE Vehicle (
  vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
  plate_number VARCHAR(20) NOT NULL UNIQUE,
  model VARCHAR(50),
  capacity INT,
  year YEAR
);


-- ======================================
-- DRIVER–VEHICLE USAGE TABLE
CREATE TABLE DriverVehicleMap (
  id INT AUTO_INCREMENT PRIMARY KEY,
  driver_id INT NOT NULL,
  vehicle_id INT NOT NULL,
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE,
  FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id) ON DELETE CASCADE
);


-- ======================================
-- SHIFTS TABLE
CREATE TABLE Shifts (
  shift_id INT AUTO_INCREMENT PRIMARY KEY,
  school_id INT NOT NULL,
  shift_name VARCHAR(50),
  start_time TIME,
  end_time TIME,
  FOREIGN KEY (school_id) REFERENCES Schools(school_id) ON DELETE CASCADE
);


-- ======================================
-- ROUTES TABLE
CREATE TABLE Routes (
  route_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  origin VARCHAR(100),
  destination VARCHAR(100),
  estimated_time TIME
);


-- ======================================
-- TRIPS TABLE
CREATE TABLE Trips (
  trip_id INT AUTO_INCREMENT PRIMARY KEY,
  driver_id INT NOT NULL,
  route_id INT NOT NULL,
  trip_date DATE,
  status ENUM('scheduled', 'in_progress', 'completed', 'cancelled'),
  FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
  FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);


-- ======================================
-- TRIP LOCATIONS TABLE
CREATE TABLE Trip_Locations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  trip_id INT NOT NULL,
  stop_name VARCHAR(100),
  stop_time TIME,
  stop_order INT,
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  FOREIGN KEY (trip_id) REFERENCES Trips(trip_id) ON DELETE CASCADE
);


-- ======================================
-- TRIP ATTENDANCE TABLE
CREATE TABLE TripAttendance (
  attendance_id INT AUTO_INCREMENT PRIMARY KEY,
  trip_id INT NOT NULL,
  student_id INT NOT NULL,
  boarded_at TIMESTAMP,
  alighted_at TIMESTAMP,
  confirmed_by_driver BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (trip_id) REFERENCES Trips(trip_id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);


-- ======================================
-- RATINGS TABLE
CREATE TABLE Ratings (
  rating_id INT AUTO_INCREMENT PRIMARY KEY,
  trip_id INT NOT NULL,
  parent_id INT NOT NULL,
  driver_id INT NOT NULL,
  stars INT CHECK (stars BETWEEN 1 AND 5),
  comment TEXT,
  submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (trip_id) REFERENCES Trips(trip_id),
  FOREIGN KEY (parent_id) REFERENCES Users(user_id),
  FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);


-- ======================================
-- PAYMENTS TABLE
CREATE TABLE Payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  parent_id INT NOT NULL,
  trip_id INT NOT NULL,
  amount DECIMAL(10,2),
  status ENUM('pending', 'paid', 'failed'),
  payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES Users(user_id),
  FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);


-- ======================================
-- PAYMENT METHODS TABLE
CREATE TABLE Payment_Methods (
  method_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  method_type ENUM('card', 'mobile_wallet', 'bank_transfer'),
  provider_name VARCHAR(100),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


-- ======================================
-- DRIVER PAYOUTS TABLE
CREATE TABLE DriverPayouts (
  payout_id INT AUTO_INCREMENT PRIMARY KEY,
  driver_id INT NOT NULL,
  trip_id INT,
  amount DECIMAL(10,2) NOT NULL,
  payout_status ENUM('pending', 'processed', 'failed') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
  FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);


-- ======================================
-- FARES TABLE
CREATE TABLE Fares (
  fare_id INT AUTO_INCREMENT PRIMARY KEY,
  route_id INT NOT NULL,
  base_fare DECIMAL(10,2),
  price_per_km DECIMAL(10,2),
  FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);


-- ======================================
-- DOCUMENTS TABLE
CREATE TABLE Documents (
  document_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  type VARCHAR(50),
  file_url TEXT,
  verified_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


-- ======================================
-- AUDIT LOGS TABLE
CREATE TABLE AuditLogs (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  action TEXT,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


-- ======================================
-- ALERTS TABLE
CREATE TABLE Alerts (
  alert_id INT AUTO_INCREMENT PRIMARY KEY,
  driver_id INT NOT NULL,
  trip_id INT,
  alert_type ENUM('sos', 'delay', 'info', 'general') DEFAULT 'general',
  message TEXT,
  alert_time DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
  FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);


-- ======================================
-- MESSAGES TABLE
CREATE TABLE Messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  content TEXT NOT NULL,
  sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_id) REFERENCES Users(user_id),
  FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);



