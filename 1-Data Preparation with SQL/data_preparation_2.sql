/*Data Profiling*/
SELECT * FROM student_video_watched;

/*Data Preprocessing*/

/*
columns needed: (only second quarter of 2021)
student_id
minutes_watched -->aggregated seconds_watched across all courses divided by 60
*/

SELECT
	student_id,
    SUM(seconds_watched) / 60.0 AS minutes_watched
    
FROM student_video_watched

WHERE date_watched BETWEEN '2021-04-01' AND '2021-06-30'

GROUP BY student_id;

/*
columns needed: (only second quarter of 2021)
student_id
minutes_watched -->aggregated seconds_watched across all courses divided by 60
paid_in_q2 -->indicate whether a student had active paid plan 
*/

SELECT
	DISTINCT sub.student_id,
    sub.minutes_watched,
    IF(sub.student_id IN (SELECT student_id  FROM purchases_info), 1, 0) AS paid_in_q2
FROM    
	(SELECT
		student_id,
		SUM(seconds_watched) / 60.0 AS minutes_watched
		
	FROM student_video_watched

	WHERE date_watched BETWEEN '2021-04-01' AND '2021-06-30'

	GROUP BY student_id) AS sub
LEFT JOIN purchases_info
	ON sub.student_id = purchases_info.student_id

GROUP BY 1, 2, 3

HAVING paid_in_q2 = 0;

/*
columns needed: (only second quarter of 2022)
student_id
minutes_watched -->aggregated seconds_watched across all courses divided by 60
*/

SELECT
	student_id,
    SUM(seconds_watched) / 60.0 AS minutes_watched
    
FROM student_video_watched

WHERE date_watched BETWEEN '2022-04-01' AND '2022-06-30'

GROUP BY student_id;

/*
columns needed: (only second quarter of 2022)
student_id
minutes_watched -->aggregated seconds_watched across all courses divided by 60
paid_in_q2 -->indicate whether a student had active paid plan 
*/

SELECT 
	sub.student_id,
    sub.minutes_watched,
    IF(sub.student_id IN (SELECT student_id  FROM purchases_info), 1, 0) AS paid_in_q2
FROM
	(SELECT
		student_id,
		SUM(seconds_watched) / 60.0 AS minutes_watched
		
	FROM student_video_watched

	WHERE date_watched BETWEEN '2022-04-01' AND '2022-06-30'

	GROUP BY student_id) AS sub
    
LEFT JOIN purchases_info
	ON purchases_info.student_id = sub.student_id
    
GROUP BY 1, 2, 3

HAVING paid_in_q2 = 1;