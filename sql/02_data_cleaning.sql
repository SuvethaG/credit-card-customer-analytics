-- NULL CHECK

SELECT 
	COUNT(*) AS total_rows,
	COUNT(*) - COUNT(customerid) AS null_ids,
	COUNT(*) - COUNT(creditscore) AS null_credit_score,
	COUNT(*) - COUNT(geography) AS null_geography,
	COUNT(*) - COUNT(gender) AS null_gender,
	COUNT(*) - COUNT(age) AS null_age,
	COUNT(*) - COUNT(tenure) AS null_tenure,
	COUNT(*) - COUNT(balance) AS null_balance,
	COUNT(*) - COUNT(numofproducts) as null_products,
	COUNT(*) - COUNT(estimatedsalary) AS null_salary,
	COUNT(*) - COUNT(exited) AS null_exited,
	COUNT(*) - COUNT(complain) AS null_complain,
	COUNT(*) - COUNT(satisfaction_score) AS null_satisfaction,
	COUNT(*) - COUNT(card_type) AS null_card_type,
	COUNT(*) - COUNT(points_earned) AS null_points,
	COUNT(*) - COUNT(exited) AS null_churn_flag
FROM credit_customers;


-- DUPLICATE CHECK

SELECT 
	customerid,
	COUNT(*) AS occurrences
FROM credit_customers
GROUP BY customerid
HAVING COUNT(*)>1;


-- ANALYZE CUSTOMER AGE DISTRIBUTION

SELECT 
	MIN(age) AS min_age,
	MAX(age) AS max_age,
	ROUND(AVG(age),2) AS avg_age
FROM credit_customers;


-- ANALYZE CREDIT SCORE DISTRIBUTION

SELECT
	MIN(creditscore) AS min_score,
	MAX(creditscore) AS max_score,
	ROUND(AVG(creditscore),2) AS avg_score
FROM credit_customers;


-- ANALYZE CUSTOMER BALANCE DISTRIBUTION

SELECT 
	MIN(balance) as min_balance,
	MAX(balance) AS max_balance,
	ROUND(AVG(balance),2) AS avg_balance,
	COUNT(*) FILTER(WHERE balance=0) AS zero_balance_account
FROM credit_customers;


-- Validate satisfaction score range

SELECT 
	MIN(satisfaction_score) AS min_score,
	MAX(satisfaction_score) AS max_score
FROM credit_customers;


-- CLEAN TABLE CREATION

CREATE TABLE credit_customers_clean AS
SELECT 
	customerid,
    surname,
    creditscore,
    geography,
    gender,
    age,
    tenure,
    balance,
    numofproducts,
    hascrcard,
    isactivemember,
    estimatedsalary,
    exited,
    complain,
    satisfaction_score,
    card_type,
    points_earned,

CASE 
	WHEN age < 30 THEN 'Under 30'
	WHEN age BETWEEN 30 AND 40 THEN '30-40'
	WHEN age BETWEEN 41 AND 50 THEN '41-50'
	WHEN age BETWEEN 51 AND 60 THEN '51-60'
	ELSE 'Above 60'
END AS age_band,

CASE 
	WHEN EstimatedSalary < 50000 THEN 'Low Income'
	WHEN EstimatedSalary BETWEEN 50000 AND 100000 THEN 'Mid Income'
	ELSE 'High Income'
END AS income_tier,

CASE
	WHEN balance = 0 THEN 'Zero Balance'
	WHEN balance < 50000 THEN 'Low Balance'
	WHEN balance BETWEEN 50000 AND 100000 THEN 'Mid balance'
	ELSE 'High Balance'
END AS balance_segment,

CASE
	WHEN creditscore < 580 THEN 'Poor'
	WHEN creditscore BETWEEN 580 AND 669 THEN 'Fair'
	WHEN creditscore BETWEEN 670 AND 739 THEN 'Good'
	WHEN creditscore BETWEEN 740 AND 799 THEN 'Very Good'
	ELSE 'Exceptional'
END AS creditscore_band

FROM credit_customers;


-- VERIFICATION

SELECT 
	COUNT(*)
FROM credit_customers_clean;


-- PREVIEW OF DERIVED CUSTOMER SEGMENTATION COLUMNS

SELECT 
    age,
    age_band,
    estimatedsalary,
    income_tier,
    balance,
    balance_segment,
    creditscore,
    creditscore_band
FROM credit_customers_clean
LIMIT 20;
