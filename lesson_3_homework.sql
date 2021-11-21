--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. 
Вывести: класс и число потопленных кораблей.
select classes.class, count(sh_sunk.ship) from classes left join
(
	select ship, class from outcomes left join ships
		on ship = name where result='sunk'
	union 
	select ship, class from outcomes left join classes 
		on ship = class where result='sunk'
) as sh_sunk 
on classes.class = sh_sunk.class group by classes.class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
Если год спуска на воду головного корабля неизвестен, определите минимальный 
год спуска на воду кораблей этого класса. Вывести: класс, год.
Select classes.class, ships_launched.min_year
from classes
left join
	(
	select class, MIN(launched) as min_year from ships
	group by class
	) as ships_launched on classes.class = ships_launched.class

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, 
вывести имя класса и число потопленных кораблей.
Select classes.class, SUM(sh_sunk.sunked)
from classes
  left join (
     select all_ships.name as name, all_ships.class as class,
           case when outcomes.result = 'sunk' then 1 else 0 end as sunked
     from
     (
      select name, class
      from ships
       union
      select ship, ship
      from outcomes
     )
     as all_ships
    left join outcomes on all_ships.name = outcomes.ship
  ) sh_sunk on sh_sunk.class = classes.class
group by classes.class
having count(distinct sh_sunk.name) >= 3 and SUM(sh_sunk.sunked) > 0 

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения 
(учесть корабли из таблицы Outcomes).
Select sh_name from
(-- объединяем таблицы ships и outcomes
select name as sh_name, displacement, numguns from 
	ships join classes on ships.class = classes.class 
union 
select ship as sh_name, displacement, numguns from 
	outcomes join classes on outcomes.ship = classes.class
) as all_ship
-- соединяем по водоизмещению и максимальному кол-ву орудий
join 
(
select displacement, max(numGuns) as Max_numguns from 
	(
	select displacement, numguns from ships join classes on ships.class = classes.class  
		union 
	select displacement, numguns from outcomes join classes on outcomes.ship= classes.class
	) as max_guns 
group by displacement
) as disp on all_ship.displacement = disp.displacement and all_ship.numguns = disp.Max_numguns

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и 
с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
Select distinct maker from product where 
model in 
	(select model from pc where ram = (select MIN(ram) from pc) and 
	speed = (select MAX(speed) from pc where ram = (select MIN(ram) from pc))) and
maker in (select maker from product where type = 'Printer')





