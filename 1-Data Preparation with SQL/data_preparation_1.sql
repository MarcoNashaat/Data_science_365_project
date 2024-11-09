/*Data Profiling*/
SELECT * FROM student_purchases;

/*Data Preprocessing*/

/*
Columns needed:
purchase_id
student_id
plan_id
date_start -->date_purchase
date_end -->end date based on start date and plan_id
date_refunded
*/
SELECT
	purchase_id,
    student_id,
    plan_id,
    date_purchased AS date_start,
    CASE
		WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
        WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
        WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 12 MONTH)
        ELSE NULL
	END AS date_end,
    date_refunded
    
FROM student_purchases;

/*
Columns needed:
purchase_id
student_id
plan_id
date_start -->date_purchase
date_end -->end date based on previous query and replace it with refund date if it was refunded
*/
SELECT
	purchase_id,
    student_id,
    plan_id,
    date_start,
    CASE
		WHEN date_refunded IS NOT NULL THEN date_refunded
        ELSE date_end
	END AS date_end
FROM
	(SELECT
		purchase_id,
		student_id,
		plan_id,
		date_purchased AS date_start,
		CASE
			WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
			WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
			WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 12 MONTH)
			ELSE NULL
		END AS date_end,
		date_refunded
		
	FROM student_purchases) AS sub;
    
/*
columns needed:
purchase_id
student_id
plan_id
date_start
date_end
paid_q2_2021 -->binary column to indicate if student had paid plan in second quarter of 2021
paid_q2_2022 -->binary column to indicate if student had paid plan in second quarter of 2022
*/

SELECT
	purchase_id,
    student_id,
    plan_id,
    date_start,
    date_end,
    IF(date_start BETWEEN '2021-04-01' AND '2021-06-30' OR date_end BETWEEN '2021-04-01' AND '2021-06-30', 1, 0) AS paid_q2_2021,
	IF(date_start BETWEEN '2022-04-01' AND '2022-06-30' OR date_end BETWEEN '2022-04-01' AND '2022-06-30', 1, 0) AS paid_q2_2022

FROM
	(SELECT
		purchase_id,
		student_id,
		plan_id,
		date_start,
		CASE
			WHEN date_refunded IS NOT NULL THEN date_refunded
			ELSE date_end
		END AS date_end
	FROM
		(SELECT
			purchase_id,
			student_id,
			plan_id,
			date_purchased AS date_start,
			CASE
				WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
				WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
				WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 12 MONTH)
				ELSE NULL
			END AS date_end,
			date_refunded
			
		FROM student_purchases) AS sub) AS sub_2;
        
/*Creating a view*/

DROP VIEW IF EXISTS purchases_info;

CREATE VIEW purchases_info AS

SELECT
	purchase_id,
    student_id,
    plan_id,
    date_start,
    date_end,
    IF(date_start > '2021-06-30' OR date_end < '2021-04-01', 1, 0) AS paid_q2_2021,
	IF(date_start > '2022-06-30' OR date_end < '2022-04-01', 1, 0) AS paid_q2_2022

FROM
	(SELECT
		purchase_id,
		student_id,
		plan_id,
		date_start,
		CASE
			WHEN date_refunded IS NOT NULL THEN date_refunded
			ELSE date_end
		END AS date_end
	FROM
		(SELECT
			purchase_id,
			student_id,
			plan_id,
			date_purchased AS date_start,
			CASE
				WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
				WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
				WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 12 MONTH)
				ELSE NULL
			END AS date_end,
			date_refunded
			
		FROM student_purchases) AS sub) AS sub_2;