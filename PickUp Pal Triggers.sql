-- TRIGGERS
-- ======================================
-- AFTER USER INSERT (AUDIT)
-- Logs new user creation to User_Audit table
CREATE TABLE IF NOT EXISTS PickUpPal.User_Audit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique ID for audit entry
  user_id INT,                                        -- The user that was created
  action VARCHAR(50),                                 -- Action description (e.g., 'created')
  log_time DATETIME DEFAULT CURRENT_TIMESTAMP         -- When the action occurred
);

DELIMITER $$
CREATE TRIGGER after_user_insert
AFTER INSERT ON PickUpPal.Users
FOR EACH ROW
BEGIN
  -- Log the new user creation into User_Audit table
  INSERT INTO PickUpPal.User_Audit (user_id, action)
  VALUES (NEW.user_id, 'created');
END$$
DELIMITER ;



-- ======================================
-- VALIDATE PHONE NUMBER FORMAT
-- Ensures phone number has 10–15 digits before inserting a user
DELIMITER $$
CREATE TRIGGER validate_phone
BEFORE INSERT ON PickUpPal.Users
FOR EACH ROW
BEGIN
  -- If the phone number is not 10–15 digits, throw an error
  IF NEW.phone_number NOT REGEXP '^[0-9]{10,15}$' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Phone number must be 10–15 digits only.';
  END IF;
END$$
DELIMITER ;



-- ======================================
-- AUTO-UPDATE TRIP STATUS
-- Changes trip status based on student boarding/alighting
DELIMITER $$
CREATE TRIGGER trg_update_trip_status
AFTER INSERT ON TripAttendance
FOR EACH ROW
BEGIN
  -- Update the trip's status depending on attendance
  UPDATE Trips
  SET status = CASE 
    WHEN EXISTS (
      SELECT 1 FROM TripAttendance
      WHERE trip_id = NEW.trip_id
        AND boarded_at IS NOT NULL
        AND alighted_at IS NULL
    ) THEN 'in_progress'
    WHEN EXISTS (
      SELECT 1 FROM TripAttendance
      WHERE trip_id = NEW.trip_id
        AND alighted_at IS NOT NULL
    ) THEN 'completed'
    ELSE 'scheduled'
  END
  WHERE trip_id = NEW.trip_id;
END$$
DELIMITER ;



-- ======================================
-- CALCULATE PAYMENT AMOUNT
-- Automatically calculates fare before inserting payment
DELIMITER $$
CREATE TRIGGER trg_before_insert_payment
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
  DECLARE rate_per_km DECIMAL(5,2);
  DECLARE base DECIMAL(6,2);
  DECLARE distance DECIMAL(6,2);

  -- Get fare and distance from route
  SELECT f.price_per_km, f.base_fare, r.estimated_distance_km
  INTO rate_per_km, base, distance
  FROM Fares f
  JOIN Routes r ON r.route_id = f.route_id
  WHERE f.route_id = NEW.route_id
  LIMIT 1;

  -- Set the total amount = base fare + (rate × distance)
  SET NEW.amount = base + (rate_per_km * distance);
END$$
DELIMITER ;



-- ======================================
-- FLAG UNCONFIRMED TRIPS
-- Runs every 15 minutes to set unconfirmed trips
DELIMITER $$
CREATE EVENT ev_flag_unconfirmed_trips
ON SCHEDULE EVERY 15 MINUTE
DO
BEGIN
  -- Mark trips as 'unconfirmed' if no boarding occurred and scheduled time has passed
  UPDATE Trips
  SET status = 'unconfirmed'
  WHERE trip_id IN (
    SELECT t.trip_id
    FROM Trips t
    LEFT JOIN TripAttendance ta ON t.trip_id = ta.trip_id
    WHERE ta.boarded_at IS NULL
      AND t.scheduled_time < NOW()
  );
END$$
DELIMITER ;

-- Enable scheduled events globally
SET GLOBAL event_scheduler = ON;
