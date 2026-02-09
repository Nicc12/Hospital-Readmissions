-- 90-Day Readmission Risk Engine

-- Ensure Data Integrity
SELECT * FROM Healthcare_data;

-- Count ReadmissionWithin_90Days

SELECT ReadmissionWithin_90Days, (COUNT(*) * 100 / 8481)  as Percpatients
FROM Healthcare_data
GROUP BY ReadmissionWithin_90Days;

-- Resource Consumption Score 
-- A patient with high TotalVisits, High TotalMedicine, and Long LengthOfStay costs the system significant more

ALTER TABLE Healthcare_data ADD COLUMN ResourceIntensityScore REAL;

UPDATE Healthcare_data 
SET ResourceIntensityScore = (LengthOfStay * 2) + TotalVisits + (TotalMedicine * 0.5);

-- Each variable is weighted subjectively based on their contribution to total overall cost
-- The assumption is made here that physical occupace in a hospital is weighted heavier than cost of providing Medicine
-- Additionally, Total Visits is weighted between the two other variables

-- Check row
SELECT * FROM Healthcare_data LIMIT 10;

-- Determine a relationship with ReadmissionWithin_90Days and ResourceIntensity

SELECT ReadmissionWithin_90Days, AVG(ResourceIntensityScore) as Average_Cost, MAX(ResourceIntensityScore) as Maxi, MIN(ResourceIntensityScore) as Mini
FROM Healthcare_data
GROUP BY ReadmissionWithin_90Days;

-- Those with ReadmissionWithin_90Days have higher average overall cost
-- however, there are instances in which those not readmission within 90 days have higher cost

-- select significant variables based on Logistic regression from python
SELECT Age,
	ChronicDiseaseCount,
	BPDiastolicMean,
	HeartRateMean,
	PulseRateMean,
	SerumCreatinine,
	ReadmissionWithin_90Days
FROM Healthcare_data;

WITH CTE AS (
SELECT Age,
	ChronicDiseaseCount,
	BPDiastolicMean,
	HeartRateMean,
	PulseRateMean,
	SerumCreatinine,
	ReadmissionWithin_90Days
FROM Healthcare_data
)
SELECT ReadmissionWithin_90Days,
	AVG(Age) as avergage_age,
	AVG(ChronicDiseaseCount) as average_chronicdisease,
	AVG(BPDiastolicMean) as average_BPD,
	AVG(HeartRateMean)as average_heartrate,
	AVG(PulseRateMean) as average_pulserate,
	AVG(SerumCreatinine) as average_SerumCreatinine
FROM CTE
GROUP BY ReadmissionWithin_90Days;

-- Based on the significant variables, there are no dramatic difference between the ReadmissionWithin_90Days groups
-- Yet based on the findings the following can be assumed, those ReadmissionWithin_90Days tend to be slightly younger, have more chronic diseases,
-- similar blood pressure, lower average heart rates, higher pulse rate, and higher average Serum Creatinine levels. 

WITH CTE2 AS(
WITH CTE AS (
SELECT ReadmissionWithin_90Days,
	Age, 
	CASE
		WHEN Age < 19 THEN 'Under 20'
		WHEN Age BETWEEN 20 AND 29 THEN '20s'
		WHEN Age BETWEEN 30 AND 39 THEN '39s'
		WHEN Age BETWEEN 40 AND 49 THEN '40s'
		WHEN Age BETWEEN 50 and 59 THEN '50s'
		WHEN Age BETWEEN 60 and 69 THEN '60s'
		WHEN Age BETWEEN 70 and 79 THEN '70s'
		WHEN Age BETWEEN 80 and 89 THEN '80s'
		WHEN Age BETWEEN 90 and 99 THEN '90s'
		ELSE '100+'
	END AS Age_bin
FROM Healthcare_data
)
SELECT ReadmissionWithin_90Days, Age_bin, COUNT(Age_bin) AS PatientPerAgeRange
FROM CTE
GROUP BY ReadmissionWithin_90Days, Age_bin
)
SELECT ReadmissionWithin_90Days, Age_bin, MAX(PatientPerAgeRange) as Patients
FROM CTE2
GROUP BY ReadmissionWithin_90Days;

WITH CTE AS (
SELECT ReadmissionWithin_90Days,
	Age, 
	CASE
		WHEN Age < 19 THEN 'Under 20'
		WHEN Age BETWEEN 20 AND 29 THEN '20s'
		WHEN Age BETWEEN 30 AND 39 THEN '39s'
		WHEN Age BETWEEN 40 AND 49 THEN '40s'
		WHEN Age BETWEEN 50 and 59 THEN '50s'
		WHEN Age BETWEEN 60 and 69 THEN '60s'
		WHEN Age BETWEEN 70 and 79 THEN '70s'
		WHEN Age BETWEEN 80 and 89 THEN '80s'
		WHEN Age BETWEEN 90 and 99 THEN '90s'
		ELSE '100+'
	END AS Age_bin
FROM Healthcare_data
)
SELECT Age_bin, COUNT(Age_bin) AS PatientPerAgeRange
FROM CTE
GROUP BY Age_bin;

-- One thing to note is that the data contains a majority older people
-- This could either indicate issue with data collection, sampling bias with older patients, 
-- or that older people are more likely to go to the hospital
-- Despite the slight difference in age we see that a majority of patients in those who have 
-- been ReadmissionWithin_90Days and not are within the 60+ age group

-- Now I am going to take a look at other measure such as heartrate, pulse rate, and Serum Creatinine levels. 
-- BPD is only slightly lower, and intuitively the relationship between redadmissison and ChronicDisease makes sense
-- If someone has more Chronic Diseases then they require more care and therefore will return to the hospital more frequently.

