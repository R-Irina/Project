--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
select Department
       , Employee
       , salary 
from
       (
            select dep.name as Department
                , emp.name as Employee
                , salary
                , dense_rank() over (partition by dep.name order by salary desc) as "rank"
            from employee emp join department dep on
            emp.departmentId = dep.id
         ) tmp 
where tmp.rank < 4

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
select member_name
	, status
	, sum(amount*unit_price) as costs 
from FamilyMembers join Payments on 
FamilyMembers.member_id = Payments.family_member
where Payments.date between '2005-01-01' and '2006-01-01'
group by member_name, status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select name 
from 
	(
	select name
	       , count(id) as cnt 
	from passenger group by name
	) tmp 
where tmp.cnt > 1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(first_name) as count from Student where first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
select count(distinct classroom) as count from Schedule where date = '2019-09-02'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/36
select * from Student where address like '%ul. Pushkina%'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
select floor(avg(TIMESTAMPDIFF(YEAR,birthday,CURRENT_DATE))) as age from FamilyMembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
select good_type_name
       ,sum(amount*unit_price) as costs 
from GoodTypes JOIN Goods on 
GoodTypes.good_type_id = Goods.type JOIN Payments on
Goods.good_id = Payments.good 
where Payments.date between '2005-01-01' and '2006-01-01'
group by good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
select min(TIMESTAMPDIFF(YEAR,birthday,CURRENT_DATE)) as year from Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
select MAX(TIMESTAMPDIFF(YEAR,birthday,CURRENT_DATE)) as max_year 
from Student 
join Student_in_class on 
	Student.id = Student_in_class.student
join 
	Class on Student_in_class.class = Class.id
where Class.name like '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
select status
       ,member_name
       ,sum(amount*unit_price) as costs 
from FamilyMembers 
join Payments on 
	FamilyMembers.member_id = Payments.family_member 
join 
	Goods on Payments.good = Goods.good_id 
join 
	GoodTypes on Goods.type = GoodTypes.good_type_id
where GoodTypes.good_type_name = 'entertainment'
group by status, member_name

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
delete from Company
where Company.id in 
	(select company from Trip group by company
    	   having count(id) = 
	      (select min(cnt) from
		 (select count(id) as cnt from Trip group by company) 
	       as min_cnt)
    	 )

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
select classroom from Schedule
group by classroom
having count(classroom) = 
    (select COUNT(classroom) 
     from Schedule 
     group by classroom
     order by COUNT(classroom) desc 
     LIMIT 1)

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
select last_name from Teacher join 
Schedule on Teacher.id = Schedule.teacher join
Subject on Subject.id = Schedule.subject 
where Subject.name = 'Physical Culture' ORDER BY last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
select concat(last_name, '.', LEFT(first_name,1), '.', LEFT(middle_name,1), '.') as name
from Student order by name asc