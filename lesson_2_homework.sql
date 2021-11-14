--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 20 с предыдущего on-line занятия: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. 
-- Вывести: maker, средний размер HD.
Select product.maker, avg(pc.hd)
from product join pc on product.model = pc.model
where product.maker in
	(select product.maker
	from product join printer on product.model = printer.model) 
group by product.maker

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
Select ships.name, ships.class from ships where ships.launched > 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
Select ships.name, ships.class from ships where whips.launched > 1920 and whips.launched <= 1942

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
Select count(ships.name), ships.class from ships group by ships.class

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
Select classes.class, classes.country from classes where classes.bore >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
Select outcomes.ship from outcomes where outcomes.battle = 'North Atlantic' and outcomes.result = 'sunk'

-- Задание 6: Вывести название (ship) последнего потопленного корабля
Select Outcomes.ship from Outcomes join Battles on Outcomes.battle = Battles.name 
where Outcomes.result = 'sunk' and 
Battles.date = (select max(Battles.date) from 
                       Battles join Outcomes on 
                       Battles.name = Outcomes.battle 
                       where Outcomes.result = 'sunk')

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
Select Outcomes.ship, Ships.class from Outcomes join 
	Battles on Outcomes.battle = Battles.name left join
	Ships on Outcomes.ship = Ships.name left join
	Classes on Ships.class = Classes.class
where Outcomes.result = 'sunk' and
Battles.date = (select max(Battles.date) from 
                       Battles join Outcomes on 
                       Battles.name = Outcomes.battle 
                       where Outcomes.result = 'sunk')

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
Select Outcomes.ship, Ships.class from Outcomes join 
	Battles on Outcomes.battle = Battles.name left join
	Ships on Outcomes.ship = Ships.name left join
	Classes on Ships.class = Classes.class
	where Outcomes.result = 'sunk' and Classes.bore >=16

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
Select Classes.class from Classes where Classes.country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
Select Ships.name, Classes.class from Classes join Ships on Classes.class = Ships.class where Classes.country = 'USA'
