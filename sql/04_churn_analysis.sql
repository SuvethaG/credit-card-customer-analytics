-- CHURN ANALYSIS

-- OVERALL CHURN BASELINE

SELECT 
	COUNT(*) AS total_customers,
	SUM(exited) AS churned,
	COUNT(*) - SUM(exited) AS retained,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean;


-- CHURN BY GEOGRAPHY

SELECT 
	geography,
	COUNT(*) AS total_customers,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean
GROUP BY geography
ORDER BY churn_rate_pct DESC;


-- CHURN BY GENDER

SELECT 
	gender,
	COUNT(*) AS total_customers,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean
GROUP BY gender
ORDER BY churn_rate_pct DESC;


-- CHURN BY AGE BAND

SELECT 
	age_band,
	COUNT(*) AS total_customers,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean
GROUP BY age_band
ORDER BY
CASE age_band
	WHEN 'Under 30' THEN 1
	WHEN '30-40' THEN 2
	WHEN '41-50' THEN 3
	WHEN '51-60' THEN 4
	ELSE 5
END;


-- CHURN BY NUMBER OF PRODUCTS

SELECT 
	numofproducts,
	COUNT(*) AS total_customers,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean
GROUP BY numofproducts
ORDER BY numofproducts;


-- CHURN BY ACTIVE MEMBERSHIP

SELECT 
	CASE WHEN isactivemember = 1 THEN 'Active' ELSE 'Inactive' END AS member_status,
	COUNT(*) AS total_customers,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean
GROUP BY isactivemember
order by churn_rate_pct DESC;


-- CHURN BY BALANCE SEGMENT

SELECT 
	balance_segment,
	COUNT(*) AS total_customers,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean
GROUP BY balance_segment
ORDER BY churn_rate_pct DESC;


-- CHURN BY CREDIT SCORE BAND

SELECT 
	creditscore_band,
	COUNT(*) AS total_customers,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean
GROUP BY creditscore_band
ORDER BY churn_rate_pct DESC;


-- CHURN BY CARD TYPE

SELECT 
	card_type,
	COUNT(*) AS total_customers,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean
GROUP BY card_type
ORDER BY churn_rate_pct DESC;


-- CHURN BY COMPLAINT STATUS

SELECT
	CASE WHEN complain = 1 THEN 'Complained' ELSE 'Not Complained' END AS compalint_status,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean
GROUP BY complain
ORDER BY churn_rate_pct DESC;


-- COMBINED CHURN SUMMARY USING CTE

WITH churn_summary AS (
SELECT
	geography,
    age_band,
    gender,
    balance_segment,
    income_tier,
    card_type,
    isactivemember,
    numofproducts,
    complain,
    exited	  
FROM credit_customers_clean)

SELECT 
    geography,
    age_band,
    gender,
    balance_segment,
	COUNT(*) AS total_customers,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM churn_summary
GROUP BY geography, age_band, gender, balance_segment
HAVING COUNT(*) > 50
ORDER BY churn_rate_pct DESC
LIMIT 15
	