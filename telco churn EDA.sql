-- Exploratory Data Analysis

-- A. Basic Descriptive Stats
-- Total Records
SELECT COUNT(*) AS total_customers 
FROM customers;

-- Churned vs Non-Churned Count
SELECT Churn, COUNT(*) AS count
FROM customers
GROUP BY Churn; 

-- Churn Rate
SELECT 
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM customers;

-- Gender Distribution
SELECT gender, COUNT(*) AS total
FROM customers
GROUP BY gender;

-- Senior Citizens
SELECT SeniorCitizen, COUNT(*) AS count, 
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 2) AS percentage
FROM customers
GROUP BY SeniorCitizen;

-- B. Bivariate Analysis (Churn vs Attributes)
-- Churn by Gender
SELECT gender, COUNT(*) AS total, 
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned, 
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY gender;

-- Churn by Contract Type
SELECT Contract, COUNT(*) AS total, 
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned, 
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY Contract
ORDER BY churn_pct DESC;

-- Churn by Internet Service
SELECT InternetService, COUNT(*) AS total, 
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned, 
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY InternetService;

-- Churn by Payment Method
SELECT PaymentMethod, COUNT(*) AS total, 
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned, 
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_pct DESC;

-- C. Tenure Analysis
-- Churn by Tenure Range
SELECT 
CASE 
WHEN tenure <= 6 THEN '0–6 months' 
WHEN tenure <= 12 THEN '7–12 months' 
WHEN tenure <= 24 THEN '13–24 months' 
WHEN tenure <= 36 THEN '25–36 months' 
WHEN tenure <= 60 THEN '37–60 months' 
ELSE '60+ months' 
END AS tenure_group, 
COUNT(*) AS total, 
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned, 
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY tenure_group
ORDER BY churn_rate DESC;

-- Average Tenure by Churn
SELECT Churn, 
ROUND(AVG(tenure), 2) AS avg_tenure
FROM customers
GROUP BY Churn;

-- D. Revenue Impact
-- Revenue Lost from Churned Customers
SELECT 
ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue_lost, 
ROUND(SUM(TotalCharges), 2) AS total_revenue_lost
FROM customers
WHERE Churn = 'Yes';

-- Average Monthly Charges by Churn
SELECT Churn, 
ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM customers
GROUP BY Churn; 

-- E. Multi-level Segmentation
-- Churn by Contract + Payment Method
SELECT Contract, PaymentMethod, COUNT(*) AS total, 
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned, 
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY Contract, PaymentMethod
ORDER BY churn_pct DESC;

-- High-Risk Segment Detection (Short Tenure + Month-to-Month)
SELECT COUNT(*) AS high_risk_customers
FROM customers
WHERE Contract = 'Month-to-month' AND tenure < 12 AND Churn = 'Yes';

-- Churn by Senior Citizen + Internet Service
SELECT SeniorCitizen, InternetService, COUNT(*) AS total, 
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned, 
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY SeniorCitizen, InternetService
ORDER BY churn_pct DESC;
