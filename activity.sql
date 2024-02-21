SELECT 
  FORMAT_DATE('%A', DATE(ActivityDate)) as day_of_week, sum(VeryActiveMinutes) as total_VAM, sum(FairlyActiveMinutes) as total_FAM, sum(LightlyActiveMinutes) as total_LAM, sum(SedentaryMinutes) as total_SM
from `fitbit_users.dailyActivity`
group by day_of_week
order by total_VAM DESC;
# shows total minutes of each activity level for each day of the week
# again, Tuesday-Thursday are the most active days by consumers
# save this as dailyActivity_clean

SELECT
  day_of_week, total_VAM+total_FAM+total_LAM as total_active_minutes, total_SM
from `fitbit_users.dailyActivity_clean`
order by total_active_minutes DESC;
# added all active minutes regardless of activity level
# save as dailyActivity_total

SELECT
  sum(VeryActiveMinutes)
from `fitbit_users.dailyActivity`;
SELECT
  sum(total_VAM)
from `fitbit_users.dailyActivity_clean`;
# this is a check that no entries were lost when cleaning the data
# both queries result in 19895


## confirms findings from calorie queries
## Tuesday-Thursday are most active days for consumers


SELECT
  Id, sum(VeryActiveMinutes) as total_VAM, sum(FairlyActiveMinutes) as total_FAM, sum(LightlyActiveMinutes) as total_LAM, sum(SedentaryMinutes) as total_SM
from `fitbit_users.dailyActivity`
group by Id
order by Id ASC;
# save as dailyActivity_by_user

