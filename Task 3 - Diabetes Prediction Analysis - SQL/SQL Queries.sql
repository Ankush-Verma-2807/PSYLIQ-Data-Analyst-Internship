CREATE DATABASE PSYLIQ;

USE PSYLIQ;

CREATE TABLE diabetes (
    EmployeeName VARCHAR(255),
    Patient_id VARCHAR(255),
    gender VARCHAR(255),
    age INT,
    hypertension INT,
    heart_disease INT,
    smoking_history VARCHAR(255),
    bmi DOUBLE,
    HbA1c_level DOUBLE,
    blood_glucose_level INT,
    diabetes INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Copy of Diabetes_prediction.csv'
INTO TABLE diabetes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
#(EmployeeName, Patient_id, gender, @age, hypertension, heart_disease, smoking_history, bmi, HbA1c_level, blood_glucose_level, diabetes)
IGNORE 1 ROWS; 


# Q1. Retrieve the Patient_id and ages of all patients 
SELECT Patient_id, age
FROM diabetes;

# Q2. Select all female patients who are older than 40
SELECT * FROM diabetes
WHERE gender = "Female" AND age > 40;

# Q3. Calculate the average BMI of patients 
SELECT AVG(bmi) AS Average_Bmi_of_Patient
FROM diabetes;

# Q4. List patients in descending order of blood glucose levels
SELECT * FROM diabetes
ORDER BY blood_glucose_level DESC;

# Q5. Find patients who have hypertension and diabetes
SELECT * FROM diabetes
WHERE hypertension=1 AND diabetes=1;

# Q6. Determine the number of patients with heart disease 
SELECT COUNT(*) AS Heart_disease_patients
FROM diabetes
WHERE heart_disease=1;

# Q7. Group patients by smoking history and count how many smokers and non-smokers there are 
SELECT smoking_history, COUNT(*) AS COUNT
FROM diabetes
WHERE smoking_history="Current" OR smoking_history="never"
GROUP BY smoking_history;

# Q8. Retrieve the Patient_ids of patients who have a BMI greater than the average BMI
	# AVG bmi is 27.320823991754303
SELECT Patient_id, bmi FROM diabetes
WHERE bmi > (
SELECT AVG(bmi) FROM diabetes
);

# Q9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel

SELECT EmployeeName, Patient_id, HbA1c_level AS Max_HbA1c_level
FROM diabetes
ORDER BY HbA1c_level DESC
LIMIT 1;

SELECT EmployeeName, Patient_id, HbA1c_level AS Min_HbA1c_level
FROM diabetes
ORDER BY HbA1c_level ASC
LIMIT 1;

# Q10. Calculate the age of patients in years (assuming the current date as of now) 
SELECT EmployeeName, Patient_id,
	YEAR(NOW()) - age AS Birth_Year,
    YEAR(NOW()) - YEAR(NOW()) + age AS Current_AGE
FROM diabetes;

# Q11. Rank patients by blood glucose level within each gender group
SELECT Patient_id, gender, blood_glucose_level,
	RANK() OVER (PARTITION BY gender ORDER BY blood_glucose_level) AS blood_glucose_level_rank_as_per_gener
FROM diabetes;

# Q12. Update the smoking history of patients who are older than 50 to "Ex-smoker"

SET SQL_SAFE_UPDATES = 0;

UPDATE diabetes
SET smoking_history = "EX-Smoker"
WHERE age>50;


# Q13. Insert a new patient into the database with sample data
INSERT INTO diabetes
VALUES ("DAVID WARNER", "PT100101", "Male", 35, 0, 0, "No Info", 33.01, 5.1, 100, 0);

SELECT * FROM diabetes
LIMIT 100102;

# Q14. Delete all patients with heart disease from the database

DELETE FROM diabetes
WHERE heart_disease=1;

SELECT * FROM diabetes;

# Q15. Find patients who have hypertension but not diabetes using the EXCEPT operator  
SELECT Patient_id, hypertension, diabetes
FROM diabetes
WHERE hypertension=1
EXCEPT
SELECT Patient_id, hypertension, diabetes
FROM diabetes WHERE diabetes=1;

# Q16. Define a unique constraint on the "patient_id" column to ensure its values are unique 

ALTER TABLE diabetes
ADD CONSTRAINT Patient_id UNIQUE (Patient_id);

INSERT INTO diabetes
VALUES ("DAVID WARNER", "PT100101", "Male", 35, 0, 0, "No Info", 33.01, 5.1, 100, 0);

# Q17. Create a view that displays the Patient_ids, ages, and BMI of patients 

CREATE VIEW Patient_Data AS (
	SELECT Patient_id, age, bmi
	FROM diabetes
    );
SELECT * FROM Patient_Data;
