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

SELECT
  sum(agg_minutes_asleep)
from `fitbit_users.totalSleep_by_day`;
SELECT
  sum(TotalMinutesAsleep)
from `fitbit_users.sleepDay`;
# check that no entries were lost when cleaning
# both show 173240

SELECT
  Id, PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', date) as date, value, logId
from `fitbit_users.minuteSleep`;
# converts date from type string to timestamp
# saved as minuteSleep_clean

SELECT
  Id, sleep_start AS sleep_date, COUNT(logId) AS number_naps, SUM(EXTRACT(HOUR
FROM
time_sleeping)) AS total_time_sleeping
FROM (
  SELECT
    Id, logId, MIN(DATE(date)) AS sleep_start, MAX(DATE(date)) AS sleep_end,
TIME( TIMESTAMP_DIFF(MAX(date),MIN(date),HOUR),
MOD(TIMESTAMP_DIFF(MAX(date),MIN(date),MINUTE),60),
MOD(MOD(TIMESTAMP_DIFF(MAX(date),MIN(date),SECOND),3600),60) ) AS time_sleeping
FROM `fitbit_users.minuteSleep_clean`
WHERE value=1
GROUP BY 1, 2)
WHERE sleep_start=sleep_end
GROUP BY 1, 2
ORDER BY 3 DESC;
# shows number, length, and date of naps by each user
# saved as naps_by_user
# assumes naps are anytime someone sleeps but wakes up on the same day

SELECT
  Id, sum(number_naps) as total_naps, sum(total_time_sleeping) as agg_time_sleeping
from `fitbit_users.naps_by_user`
group by Id
order by Id ASC;
# shows number of naps per user and amount of time spent napping
# saved as naps_by_user_agg

SELECT *
from `fitbit_users.naps_by_user_agg`
inner join `fitbit_users.dailyActivity_by_user`
on `fitbit_users.naps_by_user_agg`.Id=`fitbit_users.dailyActivity_by_user`.Id;
# shows total naps and total active minutes by user
# saved as napsVsActivity

SELECT * EXCEPT(Id_1), total_VAM+total_FAM+total_LAM as total_active_minutes
from `fitbit_users.napsVsActivity`
order by Id ASC;
# saved by napsVsActivity_clean
