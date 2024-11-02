USE healthcare;

-- Create staging table
CREATE TABLE staffing_staging
LIKE staffing;

SELECT *
FROM staffing_staging;

INSERT INTO staffing_staging
SELECT * 
FROM staffing;

-- Remove unnecessary columns
ALTER TABLE staffing_staging
DROP COLUMN `Facility Payment method`,
DROP COLUMN `Processing Fee (Facility Payment method)`;

-- Rename column names
ALTER TABLE staffing_staging
RENAME COLUMN State TO state,
RENAME COLUMN `Facility name` TO facility_name,
RENAME COLUMN `Nurse full name` TO nurse_name,
RENAME COLUMN `Nurse hourly rate` TO hourly_rate,
RENAME COLUMN `Billed hourly rate` TO billed_hourly_rate,
RENAME COLUMN `Overtime timecard` TO overtime_timecard,
RENAME COLUMN `Total bill` TO total_bill,
RENAME COLUMN `Timecard status` TO timecard_status,
RENAME COLUMN `Total hours - minus lunch break` TO net_hours_worked,
RENAME COLUMN `Total nurse pay` TO total_pay,
RENAME COLUMN `License` TO license,
RENAME COLUMN `Clock in time` TO time_in,
RENAME COLUMN `Clock out time` TO time_out,
RENAME COLUMN `Shift duration` TO shift_duration,
RENAME COLUMN `Timecard ID` TO timecard_id,
RENAME COLUMN `Shift ID` TO shift_id;

-- Check for duplicates
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY facility_name, nurse_name) AS row_num
FROM staffing_staging;

WITH duplicate_cte AS 
(
    SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY facility_name, nurse_name) AS row_num
    FROM staffing_staging
)
SELECT *
FROM duplicate_cte 
WHERE row_num > 1;
-- No duplicates were found

-- Standardizing data
SELECT *
FROM staffing_staging;

-- Check for null values or blank values
SELECT *
FROM staffing_staging
WHERE total_bill IS NULL OR TRIM(total_bill) = '';

-- Update blank values in total_bill and total_pay
UPDATE staffing_staging
SET total_bill = billed_hourly_rate * net_hours_worked
WHERE total_pay IS NULL;

UPDATE staffing_staging
SET total_pay = hourly_rate * net_hours_worked
WHERE total_pay IS NULL;
