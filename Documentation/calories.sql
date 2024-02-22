SELECT DISTINCT(Id), COUNT(*) as num_days_logged, sum(Calories) as total_calories
from `fitbit_users.dailyCalories`
group by Id;
# saved this query as dailyCalories_clean

SELECT *
from `fitbit_users.dailyCalories_clean`
where num_days_logged >= 20
order by Id ASC;
# dropped consumers with less than 20 days logged
# saved as new dailyCalories_clean

SELECT 
  FORMAT_DATE('%A', DATE(ActivityDay)) AS day_of_week, SUM(Calories) as   total_calories
from `fitbit_users.dailyCalories`
group by day_of_week;
# took ActivityDay and converted it to day of the week
# most calories burned on Tuesday-Thursday (midweek)
# saved as totalCalories_by_day

SELECT ActivityHour, sum(Calories) as total_calories_by_hour
from `fitbit_users.hourlyCalories`
group by ActivityHour;
# save as hourlyCalories_clean

SELECT 
  Id, TRIM(substring(ActivityHour, 1, 9)) as ActivityDate, TRIM(substring(ActivityHour, 10, 12)) as ActivityTime, Calories
from `fitbit_users.hourlyCalories`;
# save as new hourlyCalories_clean

SELECT
  Id, PARSE_DATE('%m/%d/%Y', ActivityDate) as ActivityDate, PARSE_TIME('%I:%M:%S %p', ActivityTime) as ActivityTime, Calories
from `fitbit_users.hourlyCalories_clean`;
# save as hourlyCalories_clean_time

SELECT
  FORMAT_DATE('%A', ActivityDate) as day_of_week, ActivityTime, sum(Calories) as total_calories_by_hour
from `fitbit_users.hourlyCalories_clean_time`
group by ActivityTime, ActivityDate
order by sum(Calories) DESC;
# shows each day of the week/hour combination and how many calories were burned by all consumers in each combination
# most active day/hour combination is Wednesday @ 18:00
# save as totalCalories_by_dayHour

SELECT
  ActivityTime, sum(Calories) as agg_total_calories
from `fitbit_users.hourlyCalories_clean_time`
group by ActivityTime
order by agg_total_calories DESC;
# took time of day and added all calories burned by all consumers at that hour
# most calories burned in between 4:00-7:00 PM then 10:00 AM-2:00 PM
# saved as hourlyCalories_agg

SELECT sum(Calories)
from `fitbit_users.hourlyCalories`;
SELECT sum(agg_total_calories)
from `fitbit_users.hourlyCalories_agg`;
# this is a check to see that no entries were lost in the cleaning process
# both queries return 2152150


## most active times for consumers is Tuesday-Thursday from 4:00-7:00 PM then 10:00 AM-2:00 PM
## maybe can focus on advertising during these times


SELECT
  Id, sum(Calories) as total_calories
from `fitbit_users.dailyCalories`
group by Id
order by Id ASC;
# total number of calories burned by each user
# saved as totalCalories_by_user

SELECT
  day_of_week, ActivityTime, sum(total_calories_by_hour) as agg_calories_by_hour
from `fitbit_users.totalCalories_by_dayHour`
group by day_of_week, ActivityTime
order by case when day_of_week = 'Sunday' then 10
              when day_of_week = 'Monday' then 20
              when day_of_week = 'Tuesday' then 30
              when day_of_week = 'Wednesday' then 40
              when day_of_week = 'Thursday' then 50
              when day_of_week = 'Friday' then 60
              when day_of_week = 'Saturday' then 70
              end, ActivityTime ASC;
# total number of calories burned by all users in each specific day/hour combination in order
# saved as aggCalories_by_dayHour

SELECT
  day_of_week, sum(agg_calories_by_hour) as total_calories_by_day
from `fitbit_users.aggCalories_by_dayHour`
group by day_of_week
order by total_calories_by_day DESC;
# another way to show that Tues-Thurs are the days of the week where most calories are burned

