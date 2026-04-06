-- Que - 1
-- SELECT * FROM practise.insurancedata WHERE gender = 'male' AND region = 'southeast'

-- Que - 2
-- SELECT * FROM practise.insurancedata WHERE bmi between 30 AND 45insurancedata 

-- Que - 3
-- SELECT MIN(bloodpressure) AS MinBP,MAX(bloodpressure) AS MaxBP FROM practise.insurancedata 
-- WHERE diabetic = 'Yes' AND smoker = 'Yes' 

-- Que - 4 
-- SELECT COUNT(DISTINCT(PatientID)) AS Unique Patient FROM practise.insurancedata 
-- WHERE  region NOT IN('southwest')

-- Que - 5 
-- SELECT SUM(claim) FROM practise.insurancedata WHERE gender = 'male' AND smoker = 'Yes'
 
-- Que - 6 
-- SELECT * FROM practise.insurancedata WHERE region LIKE '%south%'

 -- Que - 7 
 -- SELECT COUNT(DISTINCT(PatientID)) AS normal_range_patient FROM practise.insurancedata WHERE bloodpressure BETWEEN 90 AND 120  

-- Que - 8
-- SELECT 80+(age*2) AS min_range,100+(age*2) AS max_range FROM practise.insurancedata WHERE age <= 17 
-- SELECT * FROM practise.insurancedata WHERE age >= 17 

-- Que - 9 
-- SELECT AVG(claim) FROM practise.insurancedata WHERE gender = 'female' AND diabetic = 'Yes'
-- SELECT AVG(claim) FROM practise.insurancedata WHERE gender = 'male' AND diabetic = 'Yes'

-- Que - 10
-- UPDATE practise.insurancedata 
-- SET claim = 5000 
-- WHERE PatientID = 1234

-- SELECT * FROM practise.insurancedata WHERE PatientID = 1234

-- Que 11
-- DELETE FROM practise.insurancedata 
-- WHERE smoker = 'Yes' AND children = 0

-- SELECT * FROM practise.insurancedata WHERE smoker = 'Yes' AND children = 0
 
 