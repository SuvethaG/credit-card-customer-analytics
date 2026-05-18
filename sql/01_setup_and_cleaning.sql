-- Table Creation

CREATE TABLE credit_customers(
	RowNumber INT,
	CustomerId INT, 
	Surname VARCHAR(100),
	CreditScore INT,
	Geography VARCHAR(50),
	Gender VARCHAR(50),
	Age INT,
	Tenure INT,
	Balance NUMERIC,
	NumOfProducts INT,
	HasCrCard INT,
	IsActiveMember INT,
	EstimatedSalary NUMERIC,
	Exited INT,
	Complain INT,
	Satisfaction_Score INT,
	Card_Type VARCHAR(50),
	Points_Earned INT
);


-- PREVIEW OF THE FIRST 10 CUSTOMER RECORDS

SELECT *
FROM credit_customers
LIMIT 10;


-- TOTAL NUMBER OF CUSTOMERS

SELECT 
	COUNT(*) AS total_customers
FROM credit_customers;


-- LIST OF UNIQUE CUSTOMER GEOGRAPHIES

SELECT 
	DISTINCT geography
FROM credit_customers;


--LIST OF AVAILABLE CARD TYPES

SELECT
	DISTINCT card_type
FROM credit_customers;


-- GENDER DISTRIBUTION OF CUSTOMERS

SELECT
	gender,
	COUNT(*) AS customer_count
FROM credit_customers
GROUP BY gender;


-- OVERALL CUSTOMER CHURN RATE

SELECT 
	COUNT(*) AS total_customers,
	SUM(exited) AS total_churned,
	ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct 
FROM credit_customers;