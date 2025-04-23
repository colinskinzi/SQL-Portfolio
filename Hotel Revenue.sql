/*Exploratory Data Analysis (EDA)
Using EDA to answer the questions from the Hotel Revenue data.

Is our hotel revenue growing yearly?
Should we increase our parking lot size?
What trends can we see in the data?(Avaiable on PowerBI)
*/

-- create Temporary Tables
with hotels as(
select * from .dbo.[2018]
union
select * from .dbo.[2019]
union
select * from .dbo.[2020]
)
 -- identifying Revenue growth by year/Hotel. (adr = average daily rate)

select 
arrival_date_year,
round(sum((stays_in_week_nights + stays_in_weekend_nights) * adr),2) as revenue
from hotels 
group by arrival_date_year


-- Should we increase our parking lot size?(check paking lot usability.)

with hotels as(
select * from .dbo.[2018]
union
select * from .dbo.[2019]
union
select * from .dbo.[2020]
)
select
arrival_date_year, hotel,
sum((stays_in_week_nights + stays_in_weekend_nights) * adr) as renenue,
concat (round((sum(required_car_parking_spaces)/sum(stays_in_week_nights +
stays_in_weekend_nights)) * 100, 2), '%') as parking_percentage
from hotels
group by arrival_date_year, hotel



-- evaluation of all the other tables into one.

with hotels as(
select * from .dbo.[2018]
union
select * from .dbo.[2019]
union
select * from .dbo.[2020]
)
select * from hotels
left join dbo.market_segmentR
	 on hotels.market_segment = market_segmentR.market_segment
left join dbo.meal_cost
	on hotels.meal = meal_cost.meal