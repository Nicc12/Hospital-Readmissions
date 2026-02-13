-- Loading data
SELECT * FROM Healthcare_data limit 10;

-- Exploritory Data Analysis (EDA)

-- PatientId and EncounterId can indicate multiple observations per patients
SELECT COUNT(*) - (SELECT COUNT(DISTINCT PatientId) FROM Healthcare_data limit 10) as NumberOfDups
FROM Healthcare_data; -- There are 3899 readmission for repeat patients

-- Look at a random patients information
SELECT * FROM Healthcare_data WHERE PatientId = 4200412;
-- Issue: ReadmissionWithin_90Days is our response variable, yet it measure whether the current observation occurred with 90 days of the previous
-- I can either create a ReadmissionWithin_90Days count determine frequency of ReadmissionWithin_90Days per patients
-- Or I can seperate those who have ever ReadmissionWithin_90Days to those who have never, keeping the binary response for the logistic regression
-- However, another issue is the there are two of the same EncounterId for the same patient with two different ReadmissionWithin_90Days
-- I could remove duplicates based on PatientId and EncounterId, and allow it to default to 'No' if it is the same EncounterId

	
-- Binary text variables Gender through ChronicObstructivePulmonaryDisease need to be changed to numeric binary (1,0)
-- ReadmissionWithin_90Days needs to be altered to numeric (1 = Yes, 0 = No)
-- Variables LengthOfStay through TotalVisits could have mulicolinearity issues with ReadmissionWithin_90Days
-- i.e. if a patients TotalVisits is high then ReadmissionWithin_90Days is more obvious
-- Health metric variables have four metrics each (Min, Max, Median, Mean) for this analysis Mean can be used
-- Variables BMIMin to RespiratoryRateMean, and SerumCreatinine often contain 0 which is rare in impossible in somecases
-- Therefore, 0 often indicates lack of record and therefore these variables need to be removed
-- ACEInhibitors through Total Medicine, all indicate medications given to patients
-- Multicollinearity could exit with TotalMedicine and other medicine variable therefore TotalMedicine would be removed
-- CardiacTroponin through SerumCreatinine, are all measures of compounds found in the blood stream originating from blood test
-- In these measures 0 is impossible or very rare, in regard to CardiacTroponin 0 is only often due to rounding
-- These values will be removed as well
-- BNP and NT-proBNP will be left out as I am unable to determine if 0 are due to lack of detection or lack of testing


SELECT PatientId, EncounterId,
	CASE
		WHEN Gender = 'Male' THEN 1
		ELSE 0
	END AS Gender,
	CASE 
		WHEN Race = 'White' THEN 1
		ELSE 0
	END AS White,
	CASE
		WHEN DiabetesMellitus = 'DM' THEN 1
		ELSE 0
	END AS DiabetesMellitus,
	CASE
		WHEN ChronicKidneyDisease = 'CKD' THEN 1
		ELSE 0
	END AS ChronicKidneyDisease,
	CASE 
		WHEN Anemia = 'Anemia' THEN 1
		ELSE 0
	END AS Anemia, 
	CASE
		WHEN Depression = 'Depression' THEN 1
		ELSE 0 
	END AS Depression,
	CASE
		WHEN ChronicObstructivePulmonaryDisease = 'COPD' THEN 1
		ELSE 0
	END AS ChronicObstructivePulmonaryDisease,
	BMIMean,
	BPSystolicMean,
	TemperatureMean,
	CASE 
		WHEN HeartRateMean is not 0 THEN HeartRateMean
		ELSE PulseRateMean
	END AS HeartRateMeanAdj,
	RespiratoryRateMean,
	ACEInhibitors,
	ARBs,
	BetaBlockers,
	Diuretics,
	CardiacTroponin,
	Hemoglobin,
	SerumSodium,
	SerumCreatinine,
	CASE 
		WHEN ReadmissionWithin_90Days = 'Yes' THEN 1
		ELSE 0 
	END AS ReadmissionWithin_90Days
FROM Healthcare_data
WHERE BMIMean is not 0
	AND BPSystolicMean is not 0
	AND TemperatureMean is not 0
	AND HeartRateMeanAdj is not 0
	AND RespiratoryRateMean is not 0
	AND CardiacTroponin is not 0 
	AND Hemoglobin is not 0 
	AND SerumSodium is not 0 
	AND SerumCreatinine is not 0;

-- Removing all observations with non-recorded rows resulted in 0 observation
-- As a result I turned to python to determine variable importance
-- The code ran is avaliable on github
-- Note a logistic regression was ran on data that had not been fully cleansed 

WITH CTE2 AS (
WITH CTE AS (
SELECT PatientId, EncounterId,
	CASE
		WHEN Gender = 'Male' THEN 1
		ELSE 0
	END AS Gender,
	CASE 
		WHEN Race = 'White' THEN 1
		ELSE 0
	END AS White,
	CASE
		WHEN DiabetesMellitus = 'DM' THEN 1
		ELSE 0
	END AS DiabetesMellitus,
	CASE
		WHEN ChronicKidneyDisease = 'CKD' THEN 1
		ELSE 0
	END AS ChronicKidneyDisease,
	CASE 
		WHEN Anemia = 'Anemia' THEN 1
		ELSE 0
	END AS Anemia, 
	CASE
		WHEN Depression = 'Depression' THEN 1
		ELSE 0 
	END AS Depression,
	CASE
		WHEN ChronicObstructivePulmonaryDisease = 'COPD' THEN 1
		ELSE 0
	END AS ChronicObstructivePulmonaryDisease,
	BMIMean,
	BPSystolicMean,
	TemperatureMean,
	CASE 
		WHEN HeartRateMean is not 0 THEN HeartRateMean
		ELSE PulseRateMean
	END AS HeartRateMeanAdj,
	RespiratoryRateMean,
	ACEInhibitors,
	ARBs,
	BetaBlockers,
	Diuretics,
	CardiacTroponin,
	Hemoglobin,
	SerumSodium,
	SerumCreatinine,
	CASE 
		WHEN ReadmissionWithin_90Days = 'Yes' THEN 1
		ELSE 0 
	END AS ReadmissionWithin_90Days
FROM Healthcare_data
)
SELECT PatientId,
	MAX(Gender) as Gender,
	MAX(White) as White,
	MAX(DiabetesMellitus) as DiabetesMellitus,
	MAX(ChronicKidneyDisease) as ChronicKidneyDisease,
	MAX(Anemia) as Anemia,
	MAX(Depression) as Depression,
	MAX(ChronicObstructivePulmonaryDisease) as ChronicObstructivePulmonaryDisease,
	AVG(NULLIF(BMIMean,0)) as BMIMean,
	AVG(NULLIF(BPSystolicMean,0)) as BPSystolicMean,
	AVG(NULLIF(TemperatureMean, 0)) as TemperatureMean,
	AVG(NULLIF(HeartRateMeanAdj, 0)) as HeartRateMeanAdj,
	AVG(NULLIF(RespiratoryRateMean,0)) as RespiratoryRateMean,
	SUM(ACEInhibitors) as ACEInhibitors,
	SUM(ARBs) as ARBs,
	SUM(BetaBlockers) as BetaBlockers,
	SUM(Diuretics) as Diuretics,
	SUM(CardiacTroponin) as CardiacTroponin,
	SUM(Hemoglobin) as Hemoglobin,
	SUM(SerumSodium) as SerumSodium,
	AVG(NULLIF(SerumCreatinine, 0)) as SerumCreatinine,
	SUM(ReadmissionWithin_90Days) as ReadmissionWithin_90Days
FROM CTE
GROUP BY PatientId
)
SELECT Gender,
	White,
	DiabetesMellitus,
	ChronicKidneyDisease,
	Anemia,
	Depression,
	ChronicObstructivePulmonaryDisease,
	ROUND(BMIMean, 2) as BMIMean,
	ROUND(BPSystolicMean, 2) as BPSystolicMean,
	ROUND(TemperatureMean, 2) as TemperatureMean,
	ROUND(HeartRateMeanAdj,2) as HeartRateMeanAdj,
	ROUND(RespiratoryRateMean, 2) as RespiratoryRateMean,
	ACEInhibitors,
	ARBs,
	BetaBlockers,
	Diuretics,
	CardiacTroponin,
	Hemoglobin,
	SerumSodium,
	SerumCreatinine,
	CASE
		WHEN ReadmissionWithin_90Days = 0 THEN 0
		ELSE 1
	END AS ReadmissionWithin_90Days
FROM CTE2 
WHERE BMIMean is not null
	AND BPSystolicMean is not null
	AND TemperatureMean is not null
	AND HeartRateMeanAdj is not null
	AND RespiratoryRateMean is not null
	AND SerumCreatinine is not null;
	
-- I can check each group to ensure there is enough representation within each group before running regression

WITH data_check AS (
WITH CTE2 AS (
WITH CTE AS (
SELECT PatientId, EncounterId,
	CASE
		WHEN Gender = 'Male' THEN 1
		ELSE 0
	END AS Gender,
	CASE 
		WHEN Race = 'White' THEN 1
		ELSE 0
	END AS White,
	CASE
		WHEN DiabetesMellitus = 'DM' THEN 1
		ELSE 0
	END AS DiabetesMellitus,
	CASE
		WHEN ChronicKidneyDisease = 'CKD' THEN 1
		ELSE 0
	END AS ChronicKidneyDisease,
	CASE 
		WHEN Anemia = 'Anemia' THEN 1
		ELSE 0
	END AS Anemia, 
	CASE
		WHEN Depression = 'Depression' THEN 1
		ELSE 0 
	END AS Depression,
	CASE
		WHEN ChronicObstructivePulmonaryDisease = 'COPD' THEN 1
		ELSE 0
	END AS ChronicObstructivePulmonaryDisease,
	BMIMean,
	BPSystolicMean,
	TemperatureMean,
	CASE 
		WHEN HeartRateMean is not 0 THEN HeartRateMean
		ELSE PulseRateMean
	END AS HeartRateMeanAdj,
	RespiratoryRateMean,
	ACEInhibitors,
	ARBs,
	BetaBlockers,
	Diuretics,
	CardiacTroponin,
	Hemoglobin,
	SerumSodium,
	SerumCreatinine,
	CASE 
		WHEN ReadmissionWithin_90Days = 'Yes' THEN 1
		ELSE 0 
	END AS ReadmissionWithin_90Days
FROM Healthcare_data
)
SELECT PatientId,
	MAX(Gender) as Gender,
	MAX(White) as White,
	MAX(DiabetesMellitus) as DiabetesMellitus,
	MAX(ChronicKidneyDisease) as ChronicKidneyDisease,
	MAX(Anemia) as Anemia,
	MAX(Depression) as Depression,
	MAX(ChronicObstructivePulmonaryDisease) as ChronicObstructivePulmonaryDisease,
	AVG(NULLIF(BMIMean,0)) as BMIMean,
	AVG(NULLIF(BPSystolicMean,0)) as BPSystolicMean,
	AVG(NULLIF(TemperatureMean, 0)) as TemperatureMean,
	AVG(NULLIF(HeartRateMeanAdj, 0)) as HeartRateMeanAdj,
	AVG(NULLIF(RespiratoryRateMean,0)) as RespiratoryRateMean,
	SUM(ACEInhibitors) as ACEInhibitors,
	SUM(ARBs) as ARBs,
	SUM(BetaBlockers) as BetaBlockers,
	SUM(Diuretics) as Diuretics,
	SUM(CardiacTroponin) as CardiacTroponin,
	SUM(Hemoglobin) as Hemoglobin,
	SUM(SerumSodium) as SerumSodium,
	AVG(NULLIF(SerumCreatinine, 0)) as SerumCreatinine,
	SUM(ReadmissionWithin_90Days) as ReadmissionWithin_90Days
FROM CTE
GROUP BY PatientId
)
SELECT Gender,
	White,
	DiabetesMellitus,
	ChronicKidneyDisease,
	Anemia,
	Depression,
	ChronicObstructivePulmonaryDisease,
	ROUND(BMIMean, 2) as BMIMean,
	ROUND(BPSystolicMean, 2) as BPSystolicMean,
	ROUND(TemperatureMean, 2) as TemperatureMean,
	ROUND(HeartRateMeanAdj,2) as HeartRateMeanAdj,
	ROUND(RespiratoryRateMean, 2) as RespiratoryRateMean,
	ACEInhibitors,
	ARBs,
	BetaBlockers,
	Diuretics,
	CardiacTroponin,
	Hemoglobin,
	SerumSodium,
	SerumCreatinine,
	CASE
		WHEN ReadmissionWithin_90Days = 0 THEN 0
		ELSE 1
	END AS ReadmissionWithin_90Days
FROM CTE2 
WHERE BMIMean is not null
	AND BPSystolicMean is not null
	AND TemperatureMean is not null
	AND HeartRateMeanAdj is not null
	AND RespiratoryRateMean is not null
	AND SerumCreatinine is not null
) SELECT ReadmissionWithin_90Days, COUNT(*) AS NumberOfObservations
FROM data_check
GROUP BY ReadmissionWithin_90Days;

-- Gender: 322 female (X = 0) and 330 male (X = 1)
-- White: 71 non-white patients (X = 0) and 581 White patients (X = 1)
-- DiabetesMellitus: 269 patients without DiabetesMellitus (X = 0) and 383 patients with DiabetesMellitus (X = 1)
-- ChronicKidneyDisease: 245 patients without ChronicKidneyDisease (X = 0) and 407 patients with ChronicKidneyDisease (X = 1)
-- Anemia: 146 patients without Anemia (X = 0)and 506 patients with Anemia (X = 1)
-- Depression: 371 patients without Depression (X = 0) and 281 patients with Depression (X = 1)
-- ChronicObstructivePulmonaryDisease: 251 patients with ChronicObstructivePulmonaryDisease (X = 0) and 401 patients with ChronicObstructivePulmonaryDisease (X = 1)
-- ReadmissionWithin_90Days: 335 patients who were not ReadmissionWithin_90Days (X = 0) and 317 patients who were ReadmissionWithin_90Days (X = 1)