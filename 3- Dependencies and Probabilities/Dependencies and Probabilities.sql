/*
Tables needed:
Q2 2021 student count,
Q2 2022 student count,
and both periods student count.

Porbablities needed:
P(A) : The probability that a student watched a lecture in Q2 2021
P(B) : The probability that a student watched a lecture in Q2 2022
P(A∩B) : The probability that a student watched a lecture in Q2 2021 and Q2 2022
*/

/*Q2 2021 count*/
SELECT
	COUNT(DISTINCT student_id)
    
FROM student_video_watched

WHERE date_watched BETWEEN '2021-04-01' AND '2021-06-30';

--------------------------------------------------------------------

/*Q2 2022 count*/
SELECT
	COUNT(DISTINCT student_id)
    
FROM student_video_watched

WHERE date_watched BETWEEN '2022-04-01' AND '2022-06-30';

--------------------------------------------------------------------

/*2021 and 2022 overlap count*/
SELECT
	COUNT(DISTINCT sub.student_id)
    
FROM 
	(SELECT DISTINCT student_id FROM student_video_watched WHERE date_watched BETWEEN '2021-04-01' AND '2021-06-30') AS sub
JOIN 
	(SELECT DISTINCT student_id FROM student_video_watched WHERE date_watched BETWEEN '2022-04-01' AND '2022-06-30') AS sub_2
ON sub.student_id = sub_2.student_id;

--------------------------------------------------------------------

/*P(A)*/
SELECT (SELECT COUNT(DISTINCT student_id) FROM student_video_watched WHERE date_watched BETWEEN '2021-04-01' AND '2021-06-30') / COUNT(student_id) AS A
FROM student_info
WHERE date_registered < '2021-06-30';

--------------------------------------------------------------------

/*P(B)*/
SELECT (SELECT COUNT(DISTINCT student_id) FROM student_video_watched WHERE date_watched BETWEEN '2022-04-01' AND '2022-06-30') / COUNT(student_id) AS B
FROM student_info
WHERE date_registered < '2022-06-30';

--------------------------------------------------------------------

/*P(A∩B)*/
SELECT (SELECT COUNT(DISTINCT sub.student_id)
    FROM 
		(SELECT DISTINCT student_id FROM student_video_watched WHERE date_watched BETWEEN '2021-04-01' AND '2021-06-30') AS sub
	JOIN 
		(SELECT DISTINCT student_id FROM student_video_watched WHERE date_watched BETWEEN '2022-04-01' AND '2022-06-30') AS sub_2
	ON sub.student_id = sub_2.student_id) / COUNT(student_id) AS AB
FROM student_info
WHERE date_registered < '2022-06-30';

--------------------------------------------------------------------

/*conditional probability of A given B*/
SELECT 
(SELECT
	COUNT(DISTINCT sub.student_id)
    
FROM 
	(SELECT DISTINCT student_id FROM student_video_watched WHERE date_watched BETWEEN '2021-04-01' AND '2021-06-30') AS sub
JOIN 
	(SELECT DISTINCT student_id FROM student_video_watched WHERE date_watched BETWEEN '2022-04-01' AND '2022-06-30') AS sub_2
ON sub.student_id = sub_2.student_id) 
/
(SELECT
	COUNT(DISTINCT student_id)
    
FROM student_video_watched

WHERE date_watched BETWEEN '2022-04-01' AND '2022-06-30') AS 'P(A|B)'