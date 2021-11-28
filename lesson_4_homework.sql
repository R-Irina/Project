--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
select distinct product.model, product.maker, product.type from
product join pc on
product.model = pc.model
union all
select distinct product.model, product.maker, product.type from
product join laptop on
product.model = laptop.model
union all
select distinct product.model, product.maker, product.type from
product join printer on
product.model = printer.model

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"
select *,
	case 
		when price > (select avg(pc.price) from pc) then 1
		else 0 
	end flag
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
select distinct ship from Outcomes where ship not in
(select Outcomes.ship from outcomes join ships on Outcomes.ship = ships.name -- если корабль из Outcomes есть в Ships, значит у него есть class
union
-- находим головные корабли из Outcomes по наименованию, т.к. если корабль головной, то у него есть class
select Outcomes.ship from outcomes join classes on Outcomes.ship = classes.class)

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
select Battles.name from Battles where 
	extract (year from Battles.date) not in (select launched from Ships)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select distinct battle from outcomes
where ship in (select name
               from ships
               where class = 'Kongo')

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag
create view all_products_flag_300 as
select *,
	   case when price > 300 then 1 else 0 end flag
from
(
select model, price from pc
union
select model, price from printer
union
select model, price from laptop
) t

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag
create view all_products_flag_avg_price as
select *, 
	case
		when price > (select avg(price) from 
		(select price from pc --считаем среднюю цену по всем товарам, поэтому union all 
		 union all
		 select price from printer
		 union all
		 select price from laptop) s
		)
		then 1 
		else 0
	end flag
from
(
select model, price from pc
union --одну и ту же модель с одинаковой ценой берем один раз, поэтому union
select model, price from printer
union
select model, price from laptop
) t

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
select distinct printer.model from product join printer on product.model = printer.model where
product.maker = 'A' and printer.price >
(select avg(price) from product join printer on product.model = printer.model where 
product.maker = 'D' or product.maker = 'C') 

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
select avg(price) from
(
select product.maker, 
	pc.model, 
	pc.price
from 
product join pc on product.model = pc.model where maker = 'A'
union
select product.maker, 
	printer.model, 
	printer.price
from 
product join printer on product.model = printer.model where maker = 'A'
union
select product.maker, 
	laptop.model, 
	laptop.price
from 
product join laptop on product.model = laptop.model where maker = 'A'
) t

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count
create view count_products_by_makers as
select maker, sum(cnt_products) from
(
select product.maker, count(pc.code) as cnt_products from product left join pc on product.model = pc.model group by product.maker
union all
select product.maker, count(laptop.code) as cnt_products from product left join laptop on product.model = laptop.model group by product.maker
union all
select product.maker, count(printer.code) as cnt_products from product left join printer on product.model = printer.model group by product.maker
) t group by maker

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
import psycopg2
import pandas as pd
#Библиотека для визуализации
from IPython.display import HTML
import plotly.express as px

DB_HOST = '52.157.159.24'
DB_USER = 'student22'
DB_USER_PASSWORD = 'student22_password'
DB_NAME = 'sql_ex_for_student22'

conn = psycopg2.connect(host=DB_HOST, user=DB_USER, password=DB_USER_PASSWORD, dbname=DB_NAME)
request = """select * from count_products_by_makers"""
df = pd.read_sql_query(request, conn)
makerX_data = df['maker'].values.tolist()
countY_data = df['sum'].values.tolist()
fig = px.bar(x = makerX_data, y = countY_data, labels={'x':'maker', 'y':'sum'})
fig.show()

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'
create table printer_updated as select * from printer
delete from printer_updated where printer_updated.model in
(
select printer.model 
from product join printer on 
product.model = printer.model 
where product.maker = 'D'
)

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)
create view printer_updated_with_makers as
select product.maker, 
       printer_updated.* 
from product join printer_updated on 
product.model = printer_updated.model

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
create view sunk_ships_by_classes as
select classes.class, count(sh_sunk.ship) from classes left join
(
select 
	ship,
	class
from outcomes left join ships on 
ship = name where result='sunk'
union 
select 
	ship,
	class 
from outcomes left join classes on 
ship = class where result='sunk'
) as sh_sunk on classes.class = sh_sunk.class group by classes.class

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)
request = """select * from sunk_ships_by_classes"""
df1 = pd.read_sql_query(request, conn)
makerX_data = df1['class'].values.tolist()
countY_data = df1['count'].values.tolist()
fig = px.bar(x = makerX_data, y = countY_data, labels={'x':'class', 'y':'count'})
fig.show()

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0
create table classes_with_flag as
select *,
	   case 
	   	when numguns >=9 then 1
	   	else 0
	   end flag
from classes

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)
import psycopg2
import pandas as pd
from IPython.display import HTML
import plotly.express as px
import matplotlib.pyplot as plt

DB_HOST = '52.157.159.24'
DB_USER = 'student22'
DB_USER_PASSWORD = 'student22_password'
DB_NAME = 'sql_ex_for_student22'
conn = psycopg2.connect(host=DB_HOST, user=DB_USER, password=DB_USER_PASSWORD, dbname=DB_NAME)

request = """select country, count(class) as cnt from classes group by country"""
df2 = pd.read_sql_query(request, conn)
makerX_data = df2['country'].values.tolist()
countY_data = df2['cnt'].values.tolist()
fig = px.bar(x = makerX_data, y = countY_data, labels={'x':'country', 'y':'cnt'})
fig.show()
#или график другого вида
plt.figure(figsize=(15, 5))
plt.tick_params(labelsize=16)
x,y = df2['country'], df2['cnt']
plt.plot(x, y, color='blue', linewidth = 4)

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select count(1) from
(
select ships.name from ships 
union
select Outcomes.ship as name from Outcomes 
) t where name like 'O%' or name like 'M%'

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
select count(1) from
(
select ships.name from ships
union
select Outcomes.ship as name from Outcomes
) t where name like '% %' and name not like '% % %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
request = """select launched, count(name) as cnt from ships group by launched"""
df3 = pd.read_sql_query(request, conn)
makerX_data = df3['launched'].values.tolist()
countY_data = df3['cnt'].values.tolist()
fig = px.bar(x = makerX_data, y = countY_data, labels={'x':'launched', 'y':'cnt'})
fig.show()
