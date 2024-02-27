SELECT 
  DISTINCT(`Impact of Fitness Wearable`), COUNT(*) as frequency_of_answer, COUNT(*)/30 as proportion_of_answer
from `fitbit_users.fitness_survey`
group by `Impact of Fitness Wearable`;
# 80% of all respondents answered that fitness wearable had a positive impact on their fitness routines

SELECT
  DISTINCT(`Impact of Wearable On Overall Health`), COUNT(*) as frequency_of_answer, COUNT(*)/30 as proportion_of_answer
from `fitbit_users.fitness_survey`
group by `Impact of Wearable On Overall Health`;
# 80% of all respondents answered that fitness wearable had a positive impact on their overall health in some degree (somewhat, significantly)

SELECT
  DISTINCT(`Impact of Wearable on Changing Diet`), COUNT(*) as frequency_of_answer, COUNT(*)/30 as proportion_of_answer
from `fitbit_users.fitness_survey`
group by `Impact of Wearable on Changing Diet`;
# nearly 85% of all respondents answered that fitness wearable had medium to large impact on diet changes

SELECT
  DISTINCT(`Impact of Wearable on Sleep Patterns`), COUNT(*) as frequency_of_answer, COUNT(*)/30 as proportion_of_answer
from `fitbit_users.fitness_survey`
group by `Impact of Wearable on Sleep Patterns`;
# 80% of all respondents answered that fitness wearable had medium to large positive impact on sleep patterns

SELECT
  DISTINCT(`Impact of Wearable on Influence to Buy Other Products`), COUNT(*) as frequency_of_answer, COUNT(*)/30 as proportion_of_answer
from `fitbit_users.fitness_survey`
group by `Impact of Wearable on Influence to Buy Other Products`;
# 66% of all respondents answered that fitness wearables influenced them to buy other fitness-related products
# another 27% answered they felt neutral about it, potential future clients?

## this will influence what tables we will query to analyze trends in the main data set

SELECT
  Gender, COUNT(Gender) as count_of_gender
from `fitbit_users.fitness_survey`
group by Gender;

SELECT
  Age, COUNT(Age) as count_of_age
from `fitbit_users.fitness_survey`
group by Age;
# majority of participants in survey are aged Under 18 - 34, maybe worth focusing advertising efforts on these age groups

SELECT
  Age, `Impact of Wearable On Overall Health`, COUNT(`Impact of Wearable On Overall Health`) as count_of_answer
from `fitbit_users.fitness_survey`
group by Age, `Impact of Wearable On Overall Health`
order by Age ASC;

SELECT
  DISTINCT(`Impact of Wearable on Influence to Buy Other Products`), COUNT(*) as frequency_of_answer, COUNT(*)/21 as proportion_of_answer
from `fitbit_users.fitness_survey`
where Age = 'Under 18' OR Age = '18-24' OR Age = '25-34'
group by `Impact of Wearable on Influence to Buy Other Products`;
# for under 18 - 34 year olds, 66% answered that fitness wearables influenced them to buy other products