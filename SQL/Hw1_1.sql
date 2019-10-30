<<<<<<< HEAD
﻿
/*2.a.	מנהל המכללה ביקש לדעת כמה סטודנטים יש לפי יחידה.*/

SELECT a.[DepartmentName] AS Department, 
       Count(DISTINCT(b.[StudentId])) AS Students 
FROM   [dbo].[Classroom] b  
       INNER JOIN [dbo].[Courses] c 
         ON c.[CourseId] = b.[CourseId]
       INNER JOIN [dbo].[Departments] a 
         ON c.[DepartmentId] = a.[DepartmentId] 
GROUP  BY a.departmentname 

/*2.b.	המורה באנגלית צריך להתארגן וביקש לדעת כמה סטודנטים יש לו לפי 
		כל קורס שהוא מעביר וסה"כ התלמידים בכל הקורסים.*/


SELECT b.courseid, 
       COUNT (*) students 
FROM   [dbo].[Classroom] a 
        INNER JOIN [dbo].[Courses] b 
         ON a.courseid = b.courseid 
WHERE  b.courseid
	   SELECT b.courseid 
       FROM   [dbo].[Courses] b 
        INNER JOIN [dbo].[Departments] d 
         ON b.departmentid = d.departmentid 
         WHERE  d.departmentname = 'English') 
GROUP  BY b.courseid 

/*2.c.	המרכז המדעים רוצה להבין כמה כיתות קטנות
 (מתחת ל-22) וכמה גדולות צריך עבור קורסים ביחידה שלו*/

 SELECT CASE 
         WHEN students1 > 22 THEN 'Big_Class' 
         ELSE 'Small_Class' 
       END AS Class_Type, 
       Count(*) rooms
FROM (SELECT a.[CourseName], 
       Count(*) AS students1 
        FROM   [dbo].[Classroom] b 
        INNER JOIN [dbo].[Courses] a 
        ON b.[CourseId] = a.[CourseId] 
        WHERE  b.[CourseId] IN (SELECT a.[CourseId] 
        FROM   [dbo].[Courses] a 
        INNER JOIN [dbo].[Departments] c 
        ON c.[DepartmentId] = a.[DepartmentId] 
        WHERE  c.[DepartmentName] = 'Science') 
        GROUP  BY a.[CourseName]) AS student  
GROUP  BY ( CASE WHEN students1  > 22 THEN 'Big_Class' 
        ELSE 'Small_Class' 
        END ) 


/*2. d.	סטודנטית שהיא פעילה פמיניסטית טוענת שהמכללה מעדיפה לקבל יותר 
גברים מאשר נשים. תבדקו האם הטענה מוצדקת (מבחינת כמותית, לא סטטיסטית).*/
SELECT  Gender, 
       Count(*) AS Students
FROM   [dbo].[Students]
GROUP  BY [Gender]

/*e.	באיזה קורסים אחוז הגברים / הנשים הינה מעל 70%?*/



SELECT x2.coursename,x2.gender,
 ( x2.students * 1.0 ) / ( x3.ALL_students * 1.0 ) AS Students_Percent 
FROM   (SELECT a.[CourseId]    AS CourseId, 
               b.[CourseName]  AS CourseName, 
               c.[Gender]      AS Gender, 
               Count(*)        AS students 
FROM   [dbo].[Students] c 
    INNER JOIN [dbo].[Classroom] a 
ON c.[StudentId] = a.[StudentId] 
   INNER JOIN [dbo].[Courses] b 
ON a.[CourseId] = b.[CourseId] 
GROUP  BY a.[CourseId], 
          c.[Gender], 
          b.[CourseName]) AS x2 
       INNER JOIN (SELECT a.[CourseId], 
       Count(*) AS ALL_students 
FROM   students st 
       INNER JOIN classroom a 
ON st.[StudentId] = a.[StudentId] 
       INNER JOIN [dbo].[Courses] b 
ON a.[CourseId] = b.[CourseId] 
GROUP  BY a.[CourseId]) AS x3 
ON x2.[CourseId] = x3.[CourseId] 
WHERE  ( x2.students * 1.0 ) / ( x3.ALL_students * 1.0 ) > 0.7 
ORDER  BY x2.courseid 

/*f.	בכל אחד מהיחידות, כמה סטודנטים (מספר ואחוזים) עברו עם ציון מעל 80?*/
SELECT c.DepartmentName, 
       Top_students, 
       All_students, 
       ( ( Top_students * 1.0 ) / ( All_students * 1.0 ) ) * 100 AS Total_percentage 
FROM   (SELECT x1.departmentid AS DepartmentId, 
       COUNT(*)				   AS Top_students 
FROM   (SELECT c.departmentid  AS  DepartmentId, 
               a.studentid     AS StudentId, 
        AVG(a.[degree])   AVG_degree 
FROM   [dbo].[Classroom] a 
       INNER JOIN [dbo].[Courses] b 
       ON a.[CourseId] = b.[CourseId] 
       INNER JOIN [dbo].[Departments] c 
       ON b.[DepartmentId] = c.[DepartmentId] 
       GROUP  BY c.[DepartmentId], 
       a.studentid) AS x1 
WHERE  x1.avg_degree > 80.0 
GROUP  BY x1.[DepartmentId]) AS x2 
      INNER JOIN (SELECT c.[DepartmentId] AS [DepartmentId], 
      COUNT(DISTINCT( a.studentid )) AS All_students 
FROM  [dbo].[Classroom] a
      INNER JOIN [dbo].[Courses] b  
      ON a.[CourseId] = b.[CourseId] 
      INNER JOIN[dbo].[Departments] c 
      ON b.[DepartmentId] = c.[DepartmentId] 
 GROUP  BY c.departmentid) AS x3 
      ON x3.[DepartmentId] = x2.[DepartmentId] 
      INNER JOIN departments c 
      ON c.[DepartmentId] = x2.[DepartmentId] 


/*g.	בכל אחד מהיחידות, כמה סטודנטים (מספר ואחוזים) לא עברו (ציון מתחת ל-60) ?*/
SELECT c.DepartmentName, 
       low_grade_student, 
       All_students
FROM   (SELECT x1.departmentid AS DepartmentId, 
       COUNT(*)				   AS low_grade_student 
FROM   (SELECT c.departmentid  AS  DepartmentId, 
               a.studentid     AS StudentId, 
        AVG(a.[degree])   AVG_degree 
FROM   [dbo].[Classroom] a 
       INNER JOIN [dbo].[Courses] b 
       ON a.[CourseId] = b.[CourseId] 
       INNER JOIN [dbo].[Departments] c 
       ON b.[DepartmentId] = c.[DepartmentId] 
       GROUP  BY c.[DepartmentId], 
       a.studentid) AS x1 
WHERE  x1.avg_degree < 60.0 
GROUP  BY x1.[DepartmentId]) AS x2 
      INNER JOIN (SELECT c.[DepartmentId] AS [DepartmentId], 
      COUNT(DISTINCT( a.studentid )) AS All_students 
FROM  [dbo].[Classroom] a
      INNER JOIN [dbo].[Courses] b  
      ON a.[CourseId] = b.[CourseId] 
      INNER JOIN[dbo].[Departments] c 
      ON b.[DepartmentId] = c.[DepartmentId] 
 GROUP  BY c.departmentid) AS x3 
      ON x3.[DepartmentId] = x2.[DepartmentId] 
      INNER JOIN departments c 
      ON c.[DepartmentId] = x2.[DepartmentId] 



/* 2.h	תדרגו את המורים לפי ממוצע הציון של הסטודנטים מהגבוהה לנמוך */  
SELECT c.[Lastname], c.[FirstName],
       Avg(a.degree) AVG_Degree 
FROM   classroom a 
       INNER JOIN [dbo].[Courses] b 
         ON a.courseid = b.courseid 
       INNER JOIN [dbo].[Teachers] c 
         ON c.teacherid = b.teacherid 
GROUP  BY c. [FirstName],
          c. [LastName]
ORDER  BY AVG_Degree DESC 


/*a.	תייצרו VIEW המראה את הקורסים, היחידות עליהם משויכים
, המרצה בכל קורס ומספר התלמידים רשומים בקורס*/

CREATE VIEW course_info_1
AS 
  SELECT b.Coursename, 
         a.DepartmentName, 
         d.Lastname, 
         Count(*) num_students 
  FROM   classroom c 
         JOIN courses b 
         ON c.courseid = b.courseid 
         LEFT OUTER JOIN departments a 
         ON b.departmentid = a.departmentid 
         LEFT OUTER JOIN teachers d 
         ON b.teacherid = d.teacherid 
  GROUP  BY b.coursename, 
            a.departmentname, 
            d.lastname 


/*			b.	תייצרו VIEW המראה את התלמידים, מס' הקורסים שהם לוקחים,
הממוצע של הציונים לפי יחידה והממוצע הכוללת שלהם.*/

CREATE VIEW Students_info 
AS 
  SELECT a.firstname, 
         a.lastname, 
         total.num_courses, 
         total.avg_total, 
         d.departmentname, 
         AVG(b.degree) AS department_avg 
  FROM   [dbo].[Students] a 
         LEFT OUTER JOIN classroom b 
         ON a.studentid = b.studentid 
         LEFT OUTER JOIN (SELECT b.studentid       StudentId, 
         COUNT(b.courseid) Num_courses, 
         AVG(b.degree)     AVG_total 
         FROM   [dbo].[Classroom] b 
         GROUP  BY b.studentid) AS total 
         ON a.studentid = total.studentid 
         LEFT OUTER JOIN [dbo].[Courses] c 
         ON b.courseid = c.courseid 
         LEFT OUTER JOIN [dbo].[Departments] d 
         ON c.departmentid = d.departmentid 
  GROUP  BY a.Firstname, 
            a.Lastname, 
            total.Num_courses, 
            total.AVG_Total, 
=======
﻿
/*2.a.	מנהל המכללה ביקש לדעת כמה סטודנטים יש לפי יחידה.*/

SELECT a.[DepartmentName] AS Department, 
       Count(DISTINCT(b.[StudentId])) AS Students 
FROM   [dbo].[Classroom] b  
       INNER JOIN [dbo].[Courses] c 
         ON c.[CourseId] = b.[CourseId]
       INNER JOIN [dbo].[Departments] a 
         ON c.[DepartmentId] = a.[DepartmentId] 
GROUP  BY a.departmentname 

/*2.b.	המורה באנגלית צריך להתארגן וביקש לדעת כמה סטודנטים יש לו לפי 
		כל קורס שהוא מעביר וסה"כ התלמידים בכל הקורסים.*/


SELECT b.courseid, 
       COUNT (*) students 
FROM   [dbo].[Classroom] a 
        INNER JOIN [dbo].[Courses] b 
         ON a.courseid = b.courseid 
WHERE  b.courseid
	   SELECT b.courseid 
       FROM   [dbo].[Courses] b 
        INNER JOIN [dbo].[Departments] d 
         ON b.departmentid = d.departmentid 
         WHERE  d.departmentname = 'English') 
GROUP  BY b.courseid 

/*2.c.	המרכז המדעים רוצה להבין כמה כיתות קטנות
 (מתחת ל-22) וכמה גדולות צריך עבור קורסים ביחידה שלו*/

 SELECT CASE 
         WHEN students1 > 22 THEN 'Big_Class' 
         ELSE 'Small_Class' 
       END AS Class_Type, 
       Count(*) rooms
FROM (SELECT a.[CourseName], 
       Count(*) AS students1 
        FROM   [dbo].[Classroom] b 
        INNER JOIN [dbo].[Courses] a 
        ON b.[CourseId] = a.[CourseId] 
        WHERE  b.[CourseId] IN (SELECT a.[CourseId] 
        FROM   [dbo].[Courses] a 
        INNER JOIN [dbo].[Departments] c 
        ON c.[DepartmentId] = a.[DepartmentId] 
        WHERE  c.[DepartmentName] = 'Science') 
        GROUP  BY a.[CourseName]) AS student  
GROUP  BY ( CASE WHEN students1  > 22 THEN 'Big_Class' 
        ELSE 'Small_Class' 
        END ) 


/*2. d.	סטודנטית שהיא פעילה פמיניסטית טוענת שהמכללה מעדיפה לקבל יותר 
גברים מאשר נשים. תבדקו האם הטענה מוצדקת (מבחינת כמותית, לא סטטיסטית).*/
SELECT  Gender, 
       Count(*) AS Students
FROM   [dbo].[Students]
GROUP  BY [Gender]

/*e.	באיזה קורסים אחוז הגברים / הנשים הינה מעל 70%?*/



SELECT x2.coursename,x2.gender,
 ( x2.students * 1.0 ) / ( x3.ALL_students * 1.0 ) AS Students_Percent 
FROM   (SELECT a.[CourseId]    AS CourseId, 
               b.[CourseName]  AS CourseName, 
               c.[Gender]      AS Gender, 
               Count(*)        AS students 
FROM   [dbo].[Students] c 
    INNER JOIN [dbo].[Classroom] a 
ON c.[StudentId] = a.[StudentId] 
   INNER JOIN [dbo].[Courses] b 
ON a.[CourseId] = b.[CourseId] 
GROUP  BY a.[CourseId], 
          c.[Gender], 
          b.[CourseName]) AS x2 
       INNER JOIN (SELECT a.[CourseId], 
       Count(*) AS ALL_students 
FROM   students st 
       INNER JOIN classroom a 
ON st.[StudentId] = a.[StudentId] 
       INNER JOIN [dbo].[Courses] b 
ON a.[CourseId] = b.[CourseId] 
GROUP  BY a.[CourseId]) AS x3 
ON x2.[CourseId] = x3.[CourseId] 
WHERE  ( x2.students * 1.0 ) / ( x3.ALL_students * 1.0 ) > 0.7 
ORDER  BY x2.courseid 

/*f.	בכל אחד מהיחידות, כמה סטודנטים (מספר ואחוזים) עברו עם ציון מעל 80?*/
SELECT c.DepartmentName, 
       Top_students, 
       All_students, 
       ( ( Top_students * 1.0 ) / ( All_students * 1.0 ) ) * 100 AS Total_percentage 
FROM   (SELECT x1.departmentid AS DepartmentId, 
       COUNT(*)				   AS Top_students 
FROM   (SELECT c.departmentid  AS  DepartmentId, 
               a.studentid     AS StudentId, 
        AVG(a.[degree])   AVG_degree 
FROM   [dbo].[Classroom] a 
       INNER JOIN [dbo].[Courses] b 
       ON a.[CourseId] = b.[CourseId] 
       INNER JOIN [dbo].[Departments] c 
       ON b.[DepartmentId] = c.[DepartmentId] 
       GROUP  BY c.[DepartmentId], 
       a.studentid) AS x1 
WHERE  x1.avg_degree > 80.0 
GROUP  BY x1.[DepartmentId]) AS x2 
      INNER JOIN (SELECT c.[DepartmentId] AS [DepartmentId], 
      COUNT(DISTINCT( a.studentid )) AS All_students 
FROM  [dbo].[Classroom] a
      INNER JOIN [dbo].[Courses] b  
      ON a.[CourseId] = b.[CourseId] 
      INNER JOIN[dbo].[Departments] c 
      ON b.[DepartmentId] = c.[DepartmentId] 
 GROUP  BY c.departmentid) AS x3 
      ON x3.[DepartmentId] = x2.[DepartmentId] 
      INNER JOIN departments c 
      ON c.[DepartmentId] = x2.[DepartmentId] 


/*g.	בכל אחד מהיחידות, כמה סטודנטים (מספר ואחוזים) לא עברו (ציון מתחת ל-60) ?*/
SELECT c.DepartmentName, 
       low_grade_student, 
       All_students
FROM   (SELECT x1.departmentid AS DepartmentId, 
       COUNT(*)				   AS low_grade_student 
FROM   (SELECT c.departmentid  AS  DepartmentId, 
               a.studentid     AS StudentId, 
        AVG(a.[degree])   AVG_degree 
FROM   [dbo].[Classroom] a 
       INNER JOIN [dbo].[Courses] b 
       ON a.[CourseId] = b.[CourseId] 
       INNER JOIN [dbo].[Departments] c 
       ON b.[DepartmentId] = c.[DepartmentId] 
       GROUP  BY c.[DepartmentId], 
       a.studentid) AS x1 
WHERE  x1.avg_degree < 60.0 
GROUP  BY x1.[DepartmentId]) AS x2 
      INNER JOIN (SELECT c.[DepartmentId] AS [DepartmentId], 
      COUNT(DISTINCT( a.studentid )) AS All_students 
FROM  [dbo].[Classroom] a
      INNER JOIN [dbo].[Courses] b  
      ON a.[CourseId] = b.[CourseId] 
      INNER JOIN[dbo].[Departments] c 
      ON b.[DepartmentId] = c.[DepartmentId] 
 GROUP  BY c.departmentid) AS x3 
      ON x3.[DepartmentId] = x2.[DepartmentId] 
      INNER JOIN departments c 
      ON c.[DepartmentId] = x2.[DepartmentId] 



/* 2.h	תדרגו את המורים לפי ממוצע הציון של הסטודנטים מהגבוהה לנמוך */  
SELECT c.[Lastname], c.[FirstName],
       Avg(a.degree) AVG_Degree 
FROM   classroom a 
       INNER JOIN [dbo].[Courses] b 
         ON a.courseid = b.courseid 
       INNER JOIN [dbo].[Teachers] c 
         ON c.teacherid = b.teacherid 
GROUP  BY c. [FirstName],
          c. [LastName]
ORDER  BY AVG_Degree DESC 


/*a.	תייצרו VIEW המראה את הקורסים, היחידות עליהם משויכים
, המרצה בכל קורס ומספר התלמידים רשומים בקורס*/

CREATE VIEW course_info_1
AS 
  SELECT b.Coursename, 
         a.DepartmentName, 
         d.Lastname, 
         Count(*) num_students 
  FROM   classroom c 
         JOIN courses b 
         ON c.courseid = b.courseid 
         LEFT OUTER JOIN departments a 
         ON b.departmentid = a.departmentid 
         LEFT OUTER JOIN teachers d 
         ON b.teacherid = d.teacherid 
  GROUP  BY b.coursename, 
            a.departmentname, 
            d.lastname 


/*			b.	תייצרו VIEW המראה את התלמידים, מס' הקורסים שהם לוקחים,
הממוצע של הציונים לפי יחידה והממוצע הכוללת שלהם.*/

CREATE VIEW Students_info 
AS 
  SELECT a.firstname, 
         a.lastname, 
         total.num_courses, 
         total.avg_total, 
         d.departmentname, 
         AVG(b.degree) AS department_avg 
  FROM   [dbo].[Students] a 
         LEFT OUTER JOIN classroom b 
         ON a.studentid = b.studentid 
         LEFT OUTER JOIN (SELECT b.studentid       StudentId, 
         COUNT(b.courseid) Num_courses, 
         AVG(b.degree)     AVG_total 
         FROM   [dbo].[Classroom] b 
         GROUP  BY b.studentid) AS total 
         ON a.studentid = total.studentid 
         LEFT OUTER JOIN [dbo].[Courses] c 
         ON b.courseid = c.courseid 
         LEFT OUTER JOIN [dbo].[Departments] d 
         ON c.departmentid = d.departmentid 
  GROUP  BY a.Firstname, 
            a.Lastname, 
            total.Num_courses, 
            total.AVG_Total, 
>>>>>>> 56f8d818bc3dc2bff00d6ab374eb65981fa22e7b
            d.Departmentname 