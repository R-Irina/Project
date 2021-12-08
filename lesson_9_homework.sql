--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select
    case when Grades.Grade < 8 THEN 'NULL' else Students.Name end Name,
    Grades.Grade,
    Students.Marks
from
    Students, Grades
where Students.Marks between Grades.Min_Mark and Grades.Max_Mark
order by
    Grades.Grade desc,
    Name,
    Students.Marks;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select  coalesce(named,'NULL') as Doctor
	,coalesce(namep,'NULL') as Professor
	,coalesce(names,'NULL') as Singer
	,coalesce(namea,'NULL') as Actor 
from
	(select row_number() over() as sp, name as namep from occupations where Occupation ='Professor' order by name) t1 left join
	(select row_number() over() as sd, name as named from occupations where Occupation ='Doctor' order by name) t2 on sd = sp left join  
	(select row_number() over() as ss, name as names from occupations where Occupation ='Singer' order by name) t3 on sp = ss left join 
	(select row_number() over() as sa, name as namea from occupations where Occupation ='Actor' order by name) t4 on sp = sa 
order by sp, sd, ss, sa;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct city from station 
where upper(left(city,1)) not in ('A','E','I','O','U') order by city;

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
select distinct city from station 
where upper(right(city,1)) not in ('A','E','I','O','U') order by city;

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct city from station 
where upper(right(city,1)) not in ('A','E','I','O','U') or 
upper(left(city,1)) not in ('A','E','I','O','U');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem
select distinct city from station 
where upper(right(city,1)) not in ('A','E','I','O','U') and 
upper(left(city,1)) not in ('A','E','I','O','U');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name from Employee where salary > 2000 and months <10 order by Employee_id asc

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
Это задание повторяет task1, поэтому я сделала 
-- https://www.hackerrank.com/challenges/full-score/problem
select h.hacker_id,
       h.name 
from hackers h, challenges c, difficulty d, submissions s 
where h.hacker_id = s.hacker_id and
c.challenge_id = s.challenge_id and
c.difficulty_level = d.difficulty_level and
s.score = d.score
group by h.hacker_id, h.name having count(h.hacker_id) > 1
order by count(c.challenge_id) desc, h.hacker_id;











