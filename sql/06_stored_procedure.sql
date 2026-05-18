-- MONTHLY KPI STORED PROCEDURE

CREATE OR REPLACE PROCEDURE monthly_kpi_summary()
LANGUAGE plpgsql
AS $$
BEGIN
	DROP TABLE IF EXISTS kpi_summary;

	CREATE TABLE kpi_summary AS
	SELECT
		COUNT(*) AS total_customers,
		SUM(exited) AS churned,
		ROUND(SUM(exited)*100.0/COUNT(*),2) AS churn_rate_pct,
		COUNT(*) - SUM(exited) AS retained,
		ROUND(AVG(balance),2) AS avg_balance,
		ROUND(AVG(creditscore),1) AS avg_creditscore,
		ROUND(AVG(satisfaction_score),2) AS avg_satisfaction,
		ROUND(AVG(tenure),1) AS avg_tenure,
		SUM(complain) AS total_complaints,
		ROUND(SUM(complain)*100.0/COUNT(*),2) AS complaint_rate_pct,
		ROUND(AVG(points_earned),1) AS avg_points_earned,
		COUNT(*) FILTER(WHERE balance=0) AS zero_balance_customers,
		COUNT(*) FILTER(WHERE isactivemember=0) AS inactive_customers
	FROM credit_customers_clean;
END;
$$;


-- RUN THE PROCEDURE
CALL monthly_kpi_summary();

SELECT * FROM kpi_summary;


-- FINAL VALIDATION CHECK

SELECT
	'credit_customers' AS table_name,
	COUNT(*) AS  row_count
FROM credit_customers

UNION ALL

SELECT
	'credit_customers_clean' AS table_name,
	COUNT(*) AS row_count
FROM credit_customers_clean

UNION ALL

SELECT
	'rfm_segments' AS table_name,
	COUNT(*) AS  row_count
FROM rfm_segments;


UNION ALL

SELECT
	'powerbi_export' AS table_name,
	COUNT(*) AS  row_count
FROM powerbi_export

UNION ALL

SELECT
	'kpi_summary' AS table_name,
	COUNT(*) AS  row_count
FROM kpi_summary;