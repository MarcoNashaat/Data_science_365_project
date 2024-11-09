/*Data profiling*/
SELECT * FROM student_certificates;

/*Data preprocessing*/

/*
Columns needed:
student_id
certificates count
*/

SELECT 
	student_id,
    COUNT(certificate_id) AS certificates_issued 
    
FROM student_certificates

GROUP BY student_id;

/*
Columns needed:
student_id
certificates count
minutes_watched
*/

SELECT 
	sub.student_id,
    sub.certificates_issued,
    COALESCE(SUM(student_video_watched.seconds_watched) / 60.0,0) AS minutes_watched

FROM 
	(SELECT 
		student_id,
		COUNT(certificate_id) AS certificates_issued 
		
	FROM student_certificates

	GROUP BY student_id) AS sub
    
LEFT JOIN student_video_watched
	ON sub.student_id = student_video_watched.student_id
    
GROUP BY 1, 2