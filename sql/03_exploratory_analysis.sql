-- EXPLORATORY ANALYSIS

-- CUSTOMER DISTRIBUTION BY GEOGRAPHY

SELECT 
	geography,
	COUNT(*) AS total_customers,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(),2) AS pct_of_total,
	ROUND(AVG(balance),2) AS avg_balance,
	ROUND(AVG(creditscore),1) AS avg_creditscore,
	ROUND(AVG(estimatedsalary),2) AS avg_salary
FROM credit_customers_clean
GROUP BY geography
ORDER BY total_customers DESC;


-- CUSTOMER DISTRIBUTION BY AGE BAND

SELECT 
	age_band,
	COUNT(*) AS total_customers,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(),2) AS pct_of_total,
	ROUND(AVG(balance),2) AS avg_balance,
	ROUND(AVG(creditscore),1) AS avg_creditscore
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


-- CUSTOMER DISTRIBUTION BY CARD TYPE

SELECT 
	card_type,
	COUNT(*) AS total_customers,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(),2) AS pct_of_total,
	ROUND(AVG(balance),2) AS avg_balance,
	ROUND(AVG(points_earned),1) AS avg_points,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction_score
FROM credit_customers_clean
GROUP BY card_type
ORDER BY avg_balance DESC;


-- BALANCE SEGMENT DISTRIBUTION

SELECT 
	balance_segment,
	COUNT(*) AS total_customers,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(),2) AS pct_of_total,
	ROUND(AVG(creditscore),1) AS avg_creditscore,
	ROUND(AVG(tenure),1) AS avg_tenure,
	ROUND(AVG(numofproducts),2) AS avg_products
FROM credit_customers_clean
GROUP BY balance_segment
ORDER BY 
CASE balance_segment
	WHEN 'Zero Balance' THEN 1
	WHEN 'Low Balance' THEN 2
	WHEN 'Mid Balance' THEN 2
	ELSE 4
END;


-- CREDIT SCORE BAND DISTRIBUTON

SELECT 
	creditscore_band,
	COUNT(*) AS total_customers,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(),2) AS pct_of_total,
	ROUND(AVG(balance),2) AS avg_balance,
	ROUND(AVG(satisfaction_score),2) AS satisfaction_score
FROM credit_customers_clean
GROUP BY creditscore_band
ORDER BY 
CASE creditscore_band
	WHEN 'Poor' THEN 1
	WHEN 'Fair' THEN 2
	WHEN 'Good' THEN 3
	WHEN 'Very Good' THEN 4
	ELSE 5
END;


-- GENDER DISTRIBUTION AND FINANCIAL PROFILE

SELECT 
	gender,
	COUNT(*) AS total_customers,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(),2) AS pct_of_total,
	ROUND(AVG(balance),2) AS avg_balance,
	ROUND(AVG(estimatedsalary),2) AS avg_salary,
	ROUND(AVG(creditscore),2) AS avg_creditscore
FROM credit_customers_clean
GROUP BY gender;


-- PRODUCT USAGE DISTRIBUTION

SELECT 
	numofproducts,
	COUNT(*) AS total_customers,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(),2) AS pct_of_total,
	ROUND(AVG(balance),2) AS avg_balance,
	ROUND(AVG(satisfaction_score),2) AS satisfaction_score,
	ROUND(AVG(points_earned),1) AS avg_points
FROM credit_customers_clean
GROUP BY numofproducts
ORDER BY numofproducts;


-- TENURE DISTRIBUTION
SELECT 
	tenure,
	COUNT(*) AS total_customers,
	ROUND(AVG(balance),2) AS avg_balance,
	ROUND(AVG(creditscore),2) AS avg_creditscore,
	ROUND(AVG(satisfaction_score),2) AS satisfaction_score
FROM credit_customers_clean
GROUP BY tenure
ORDER BY tenure;


-- KEY METRICS SUMMARY BY INCOME TIER

SELECT 
	income_tier,
	COUNT(*) AS total_customers,
	ROUND(AVG(balance),2) AS avg_balance,
	ROUND(AVG(creditscore),2) AS avg_creditscore,
	ROUND(AVG(numofproducts),2) AS avg_products,
	ROUND(AVG(points_earned),1) AS avg_points,
	ROUND(AVG(satisfaction_score),2) AS satisfaction_score
FROM credit_customers_clean
GROUP BY income_tier
ORDER BY avg_balance DESC;


-- COMPLAINTS AND SATISFACTION OVERVIEW

SELECT 
	complain,
	COUNT(*) AS total_customers,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(),2) AS pct_of_total,
	ROUND(AVG(satisfaction_score),2) AS satisfaction_score,
	ROUND(AVG(balance),2) AS avg_balance,
	SUM(exited) AS churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct
FROM credit_customers_clean
GROUP BY complain;


