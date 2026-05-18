-- RFM SEGMENTATION

-- BUILD RFM SCORES
CREATE TABLE rfm_segments AS
WITH rfm_scored AS (
    SELECT
        customerid,
        surname,
        geography,
        gender,
        age,
        age_band,
        tenure,
        balance,
        numofproducts,
        estimatedsalary,
        income_tier,
        balance_segment,
        creditscore,
        creditscore_band,
        card_type,
        isactivemember,
        satisfaction_score,
        points_earned,
        complain,

		NTILE(4) OVER(ORDER BY tenure DESC) AS recency_score,
		NTILE(4) OVER(ORDER BY numofproducts DESC) AS frequency_score,
		NTILE(4) OVER(ORDER BY balance DESC) AS monetary_score
	FROM credit_customers_clean
	WHERE exited = 0
)

SELECT *,
	recency_score + frequency_score + monetary_score AS rfm_total,
	CASE 
		WHEN recency_score + frequency_score + monetary_score>=10 THEN 'High Value'
		WHEN recency_score + frequency_score + monetary_score>=7 THEN 'Mid Value'
		ELSE 'Low Value'
	END AS customer_segment
FROM rfm_scored;


-- VERIFY RFM TABLE

SELECT *
FROM rfm_segments;


-- SEGMENT DISTRIBUTION

SELECT
	customer_segment,
	COUNT(*) AS total_customers,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(),2) AS pct_of_total
FROM rfm_segments
GROUP BY customer_segment
ORDER BY total_customers DESC;


-- SEGMENT FINANCIAL PROFILE

SELECT 
	customer_segment,
	COUNT(*) AS total_customers,
	ROUND(AVG(balance),2) AS avg_balance,
	ROUND(AVG(tenure),1) AS avg_tenure,
	ROUND(AVG(numofproducts),2) AS avg_products,
	ROUND(AVG(creditscore),0) AS avg_creditscore,
	ROUND(AVG(estimatedsalary),2) AS avg_salary,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction,
	ROUND(AVG(points_earned),1) AS avg_points
FROM rfm_segments
GROUP BY customer_segment
ORDER BY avg_balance DESC;


-- SEGMENT BY GEOGRAPHY

SELECT 
	geography,
	customer_segment,
	COUNT(*) AS total_customers,
	ROUND(AVG(balance),2) AS avg_balance
FROM rfm_segments
GROUP BY geography,customer_segment
ORDER BY geography,customer_segment DESC;


-- SEGMENT BY CARD TYPE

SELECT 
	 card_type,
	 customer_segment,
	 COUNT(*) AS total_customers,
	 ROUND(AVG(balance),2) AS avg_balance,
	 ROUND(AVG(points_earned),1) AS avg_points,
	 ROUND(AVG(satisfaction_score),2) AS avg_satisfaction
FROM rfm_segments
GROUP BY card_type,customer_segment
ORDER BY card_type, avg_balance DESC;


-- SEGMENT BY AGE_BAND

SELECT 
	 age_band,
	 customer_segment,
	 COUNT(*) AS total_customers,
	 ROUND(AVG(balance),2) AS avg_balance
FROM rfm_segments
GROUP BY age_band,customer_segment
ORDER BY
	CASE age_band
		WHEN 'Under 30' THEN 1
        WHEN '30-40' THEN 2
        WHEN '41-50' THEN 3
        WHEN '51-60' THEN 4
        ELSE 5
	END,
	avg_balance DESC;


-- HIGH VALUE CUSTOMER DEEP DIVE

SELECT 
	geography,
    gender,
    age_band,
    card_type,
    income_tier,
    COUNT(*) AS total_customers,
    ROUND(AVG(balance), 2) AS avg_balance,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM rfm_segments
WHERE customer_segment = 'High Value'
GROUP BY geography,gender,age_band,card_type,income_tier
HAVING COUNT(*)>20
ORDER BY avg_balance DESC
LIMIT 10;


-- LOW VALUE CUSTOMER PROFILE

SELECT
    geography,
    gender,
    age_band,
    balance_segment,
    COUNT(*) AS total_customers,
    ROUND(AVG(balance), 2) AS avg_balance,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM rfm_segments
WHERE customer_segment = 'Low Value'
GROUP BY geography, gender, age_band, balance_segment
HAVING COUNT(*) > 20
ORDER BY total_customers DESC
LIMIT 10;


-- FINAL EXPORT TABLE FOR POWER BI

CREATE TABLE powerbi_export AS
SELECT 
	c.customerid,
    c.geography,
    c.gender,
    c.age,
    c.age_band,
    c.tenure,
    c.balance,
    c.balance_segment,
    c.numofproducts,
    c.hascrcard,
    c.isactivemember,
    c.estimatedsalary,
    c.income_tier,
    c.creditscore,
    c.creditscore_band,
    c.card_type,
    c.satisfaction_score,
    c.points_earned,
    c.complain,
    c.exited,
	COALESCE(r.recency_score,0) AS recency_score,
	COALESCE(r.frequency_score,0) AS frequency_score,
	COALESCE(r.monetary_score,0) AS monetary_score,
	COALESCE(r.rfm_total,0) AS rfm_total,
	COALESCE(r.customer_segment,'Churned') AS customer_segment
FROM credit_customers_clean c
LEFT JOIN rfm_segments r
ON c.customerid = r.customerid


-- EXPORT TABLE VERIFICATION

SELECT COUNT(*) FROM powerbi_export;

SELECT
    customer_segment,
    COUNT(*) AS total_customers
FROM powerbi_export
GROUP BY customer_segment
ORDER BY total_customers DESC;