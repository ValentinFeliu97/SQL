use FAFD;

-- 1. Id of the students who got at least one 30
Select distinct e.Sid, name
from Exam e natural join student
where grade = 30;

select distinct sid, name
from Student natural join Exam e
where e.grade = 30;

-----------------------------------------------------------------------------------------------------
-- 2. Id, Name and City of origin of the students who got at least one 30
select distinct e.sid, name, city
from exam e natural join student
where grade =30;

Select distinct sid, name, city 
from Student s natural join Exam e 
where e.grade >= 30;

-- alternatevely using in
select distinct sid, name, city
from student 
where sid in (select sid
				from exam
                where grade = 30);
                
-----------------------------------------------------------------------------------------------------
-- 3. The birthdate of the youngest student
select max(birthdate)
from student;

select sid, birthdate
from Student
where birthdate in (select max(birthdate)
					from student);


-----------------------------------------------------------------------------------------------------
-- 4. The GPA of the student with ID = 107
select sid, avg(grade)
from exam
where sid = 107;

select sid, name, avg(grade)
from student s natural join exam e
where sid = 107;

-----------------------------------------------------------------------------------------------------
-- 5. The GPA of each course

select Title, CourseID, avg(grade)
from Course c join exam e on c.courseid = e.cid
group by courseid
order by courseid;

select Title, CourseID, avg(grade) as GPA
from Course c join Exam e on c.courseid = e.cid
group by CourseID
order by CourseID;

-- ?pq si uso natural join me tira el mismo GPA para todos los cursos?

-----------------------------------------------------------------------------------------------------
-- 6. The number of Credits acquired by each student 6bis: Also including students with ZERO credits...

-- 6A
select sid, name, count(credits)
from student natural join exam e join course c on e.cid = c.courseid
group by sid
order by sid;

select sid, name, count(credits)
from Student natural join exam e join course c on e.cid = c.courseid
group by sid;

-- 6B
select s.sid, sum(credits) as totCredits, Name
from student s join exam e on s.sid=e.sid join course on cid = courseid
group by s.sid 
 union
select sid, 0 as totCredits, Name
from student
where sid not in ( select sid 
                   from exam );

-- or with an outer join 

select s.sid, sum(credits) as totCredits, Name
from course join exam e on cid = courseid
       right join student s on e.sid = s.sid
group by s.sid; 



-----------------------------------------------------------------------------------------------------
-- 7. The (weighted) GPA of each student
select sid, sum(grade*credits)/sum(credits) as wGPA
from course join exam e on cid = courseid
group by sid;




-----------------------------------------------------------------------------------------------------
-- 8. Students who passed at least 2 exams [a. just the Id b. also the Name]
-- 8a 
select sid
from exam 
group by sid
having count(grade)>1;

-- 8b
select e.sid, name
from exam e natural join student
group by e.sid
having count(grade)>1;



-----------------------------------------------------------------------------------------------------
-- 9. Students who passed less than 5 exams [a. just the Id b. also the Name]
-- 9a
select sid 
from exam 
group by sid
having count(*) <5;

-- 9b
select e.sid, name
from exam e join student s on e.sid = s.sid
group by e.sid
having count(*) < 5;


-----------------------------------------------------------------------------------------------------
-- 10. Students who passed exactly 4 exams [a. just the Id b. also the Name]
-- 10a
select sid
from exam
group by sid
having count(*) = 4;

-- 10b
select sid, name
from exam natural join student
group by sid
having count(*) = 4;




-----------------------------------------------------------------------------------------------------
-- 11. For each student, the number of passed exams (including those with 0 exams!)
select sid, name, count(*)
from exam natural join student
group by sid
order by count(*);


select e.sid, name, count(*) as TotPassedExams
from exam e join student s on e.sid = s.sid
group by e.sid
union
select sid, Name, 0 as TotPassedExams
from student
where sid not in (select sid
					from exam);

-----------------------------------------------------------------------------------------------------
-- 12. Students with a (weighted) GPA that is above 24.5
select sid, name, sum(grade*credits)/sum(credits) as wGPA
from student s natural join exam e join course c on e.cid = c.courseid
group by sid
having wGPA >= 24.5;



-----------------------------------------------------------------------------------------------------
-- 13. The “regular” students, i.e., those with a delta of maximum 3 points between their worst and best grade
select sid as regularStudents, name, max(grade) as bestGrade, min(grade) as worstGrade
from exam natural join student
group by sid
having bestGrade - worstGrade <=3;


-----------------------------------------------------------------------------------------------------
-- 14. The (weighted) GPA of each student who passed at least 5 exams (statistically meaningful)
select sid, name, sum(grade*credits)/sum(credits) as wGPA, count(*)
from student s natural join exam e join course c on e.cid = c.courseID
group by sid
having count(*) >= 5;

-----------------------------------------------------------------------------------------------------
-- 15. The (weighted) GPA for each year of each student who passed at least 5 exams overall (not 5 exams per year)
select sid, name, sum(grade*credits)/sum(credits) as wGPA, Year
from student s natural join exam e join course c on e.cid = c.courseID
where sid in (select sid
				from exam
                group by sid
                having count(grade) >= 5)
group by sid, Year
order by Year;



-----------------------------------------------------------------------------------------------------
-- 16. Students who never got more than 21
select sid
from exam
group by sid
having max(grade)<=21;



-----------------------------------------------------------------------------------------------------
-- 17. Id and name of the students who passed exams for a total amount of at least 20 credits and never got a grade below 28
select sid
from exam e join course c on e.cid = c.courseid
where grade >= 28
group by sid
having sum(credits) >= 20;

select sid, Name
from exam join course on cid=courseid natural join student
group by sid
having sum(credits) >= 20 and min(grade) >= 28;

----------------------------------------------------------------------------------------------------
-- 18. Students who got the same grade in two or more exams
select sid, name
from exam natural join student 
group by sid
having count(grade)>count(distinct grade);




-----------------------------------------------------------------------------------------------------
-- 19. Students who never got the same grade twice
select sid 
from exam 
group by sid 
having count(grade) = count(distinct grade);


-----------------------------------------------------------------------------------------------------
-- 20. Students who always got the very same grade in all their exams
select sid 
from exam
group by sid 
having count(distinct grade) = 1;

-----------------------------------------------------------------------------------------------------
-- 21. The name of the youngest student
select name
from student
where birthdate = (select max(birthdate)
						from student);


-----------------------------------------------------------------------------------------------------
-- 22. Students who got all possible distinct grades
select sid
from exam 
group by sid
having count(grade) = 13;



-----------------------------------------------------------------------------------------------------
-- 23. Students who never passed any exam
select s.sid, name
from student s left join exam e on s.sid = e.sid
group by s.sid 
having count(grade) = 0;

-----------------------------------------------------------------------------------------------------
-- 24. Students who never got an 18
select s.sid, name
from student s left join exam on s.sid = exam.sid
group by s.sid
having s.sid not in (select sid
						from exam
                        where grade = 18);


-----------------------------------------------------------------------------------------------------
-- 25. Code and Title of the courses with the minimum number of credits
select CourseID, Title 
from Course
where credits = (select min(credits)
					from course);




-----------------------------------------------------------------------------------------------------
-- 26. Code and Title of the courses of the first year with the minimum number of credits
Select courseID, Title, year
from course
where year = 1 and
credits =(select min(credits)
					from course
                    where year = 1);

-----------------------------------------------------------------------------------------------------
-- 27. Code and Title of the courses with the minimum number of credits of each year
select courseid, title, year, credits
from course
where (year, credits) in (select year, min(credits)
							from course
                            group by year)
group by courseID
order by year;


----------------------------------------------------------------------------------------------------
-- 28. Id and Name of the students who passed more exams from the second year than exams from the first year
create view exams_for_year_1 (sid,year,exams1) as

(select sid, year, count(grade) as exams
from exam e join course c on e.cid=c.courseid
group by sid, year
having year=1);

select *
from exams_for_year_1;

create view exams_for_year_2 (sid,year,exams2) as

(select sid, year, count(grade) as exams
from exam e join course c on e.cid=c.courseid
group by sid, year
having year=2);

select *
from exams_for_year_2;

select e1.sid, name,exams1 as Year1, exams2 as Year2
from exams_for_year_1 e1 join exams_for_year_2 e2 on e1.sid=e2.sid join student s on e1.sid=s.sid
where exams2 > exams1;



-----------------------------------------------------------------------------------------------------
-- 29. The student(s) with best weighted GPA

create view wGPAview (sid, wGPA) as
(select sid, sum(grade*credits)/sum(credits) as wGPA
from exam e join course c on e.cid = c.courseid
group by sid);

select sid
from wGPAview
where wGPA = (select max(wGPA)
				from wGPaView);
                


-----------------------------------------------------------------------------------------------------
-- 30. The course with the worst GPA
drop view gpa_course;
create view gpa_course (cid, gpa) as 
(select cid, avg(grade)
from exam
group by cid);

select *
from gpa_course
where gpa = (select min(gpa)
						from gpa_course);
-----------------------------------------------------------------------------------------------------
-- 31. Students with a GPA that is at least 2 points above the overall college GPA
select sid, avg(grade)
from exam
group by sid
having avg(grade) > (select avg(grade)
					from exam) +2;
                    
 select sid, sum(grade*credits)/sum(credits) as wGPA
 from exam e join course c on e.cid = c.courseid
 group by sid 
 having wGPA > (select sum(grade*credits)/sum(credits) as wGPA
					from  exam e join course c on e.cid = c.courseid) +2;
-----------------------------------------------------------------------------------------------------

-- 32. For each student, their best year in terms of GPA

create view wGPAstudentYear (sid, wGPA, Year) as
(select sid, sum(grade*credits)/sum(credits) as wGPA, Year
from exam e join course c on e.cid = c.courseid
group by sid, Year);

Select *
from wGPAstudentYear;

select *
from wGPAstudentYear
where (sid, wgpa) in (
select sid, max(wgpa)
from wGPAstudentYear
group by sid);
-----------------------------------------------------------------------------------------------------
-- 33. The most “regular” students, i.e., those with the minimum delta between their worst and best grade

create view Delta (sid, delt) as
(select sid, max(grade)-min(grade) as delt
from exam
group by sid); 

select *
from delta
where delt in (select min(delt)
from delta);

-----------------------------------------------------------------------------------------------------
-- 34. Students with a weighted GPA that is above the “average weighted GPA” of all the students
 select sid, sum(grade*credits)/sum(credits) as wGPA
 from exam e join course c on e.cid = c.courseid
 group by sid 
 having wGPA > (select sum(grade*credits)/sum(credits) as wGPA
					from  exam e join course c on e.cid = c.courseid);

create view gpaview (sid,wgpa) as (
select sid, sum(grade*credits)/sum(credits) as wGPA
from exam e join course c on e.cid=c.courseid
group by sid);

select gv.sid, name,wgpa
from gpaview gv join student s on gv.sid=s.sid
where wgpa > (
select avg(wgpa)
from gpaview);



-----------------------------------------------------------------------------------------------------
-- 35. Students who got all their grades in strictly non-decreasing order over time
drop view order_of_grades;
create view order_of_grades (si, gra, date) as 
(select sid, grade, date
from exam
order by sid, date);

select * 
from order_of_grades;

create view order_of_grades2 (si, gra, date) as 
(select sid, grade, date
from exam
order by sid, grade);

select *
from order_of_grades2;


