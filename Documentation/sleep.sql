SELECT 
  Id, sum(TotalMinutesAsleep) as agg_sleep_minutes, sum(TotalTimeInBed) as agg_time_bed, sum(TotalMinutesAsleep)/sum(TotalTimeInBed) as sleep_proportion
from `fitbit_users.sleepDay`
group by Id;
# added up total sleep minutes and total time in bed then divided the two to get total sleep proportion
# saved as sleepDay_agg

SELECT
  COUNT(Id)/24 as proportion_of_users_asleep_longer_than_90p
from `fitbit_users.sleepDay_agg`
where sleep_proportion > 0.90;
# 83.3% of Fitbit users that provided sleep data spent more than 90% of their time in bed asleep
# how many of these users also had a significant proportion of time spent active

SELECT *
from `fitbit_users.sleepDay_agg`
inner join `fitbit_users.totalCalories_by_user`
ON `fitbit_users.sleepDay_agg`.Id=`fitbit_users.totalCalories_by_user`.Id;
# merged sleepDay_agg with totalCalories_by_user to see how many calories the users with sleep data burned
# saved as sleep_calories

SELECT
  Id, sleep_proportion, total_calories
from `fitbit_users.sleep_calories`;
# maybe can do a scatterplot to show correlation between sleep and activity (calorie usage)
# saved as SleepVsCalories

SELECT *
from `fitbit_users.SleepVsCalories`
inner join `fitbit_users.dailyActivity_by_user`
ON `fitbit_users.SleepVsCalories`.Id=`fitbit_users.dailyActivity_by_user`.Id;
# saved as SleepVsActivity_Minutes

SELECT
  Id, sleep_proportion, total_VAM+total_FAM+total_LAM as total_active_minutes, total_SM, total_calories
from `fitbit_users.SleepVsActivity_Minutes`;
# saved as SleepVsActivity
# construct scatterplot to show trends between sleep proportion and active minutes, sedentary minutes, calories burned

SELECT
  FORMAT_DATE('%A', PARSE_DATE('%m/%d/%Y', SUBSTRING(SleepDay, 1, 9))) as day_of_week, sum(TotalMinutesAsleep) as agg_minutes_asleep
from `fitbit_users.sleepDay`
group by day_of_week
order by agg_minutes_asleep DESC;
# converts SleepDay from string into date, then into day of the week
# saved as totalSleep_by_day