USE portfolio_project

-- View the data
SELECT *
FROM portfolio_project..kickstarter_projects

-- Drop unnessary data
ALTER TABLE kickstarter_projects
DROP COLUMN F12, F13, Category1

-- Find Which project with goal over $1000 had the biggest completion percentage
SELECT Name, Goal, Pledged, (Pledged/Goal)*100 AS goal_completion_percentage
FROM portfolio_project..kickstarter_projects
WHERE Goal>1000 AND State='Successful' AND PLEDGED > 0
ORDER BY goal_completion_percentage DESC

-------------------------------------------------------------------------

-- Find trends in project success rates over the years

--Exploration

SELECT Name, Launched, Goal, Pledged, backers
FROM portfolio_project..kickstarter_projects
WHERE State IN ('Successful', 'Failed', 'Canceled')
ORDER BY Launched, Pledged DESC, backers DESC

SELECT Name, Launched, Goal, Pledged, backers
FROM portfolio_project..kickstarter_projects
WHERE State = 'Successful'
ORDER BY Launched, Pledged DESC, backers DESC

SELECT Name, Launched, Goal, Pledged, backers
FROM portfolio_project..kickstarter_projects
WHERE State = 'Failed'
ORDER BY Launched, Pledged DESC, backers DESC



-- Find average number of backers per category of successful projects
SELECT Category, ROUND(AVG(backers),0) AS Avg_num_backers
FROM kickstarter_projects
WHERE State = 'Successful'
GROUP BY Category
ORDER BY Category

-- Find average number of backers per category of failed projects
SELECT Category, ROUND(AVG(backers),0) AS Avg_num_backers
FROM kickstarter_projects
WHERE State = 'Failed'
GROUP BY Category
ORDER BY Category

--There are significantly more backers per category for successful projects than failed projects
--Games still has more backers overall (double the amount of next category), even in failed projects. Games are backed most often

-- Explore further by Subcategory
SELECT Subcategory, ROUND(AVG(backers),0) AS Avg_num_backers
FROM kickstarter_projects
WHERE State = 'Successful'
GROUP BY Subcategory
ORDER BY Avg_num_backers DESC

SELECT Subcategory, ROUND(AVG(backers),0) AS Avg_num_backers
FROM kickstarter_projects
WHERE State = 'Failed'
GROUP BY Subcategory
ORDER BY Avg_num_backers DESC

--Video games still had the highest number of backers for both failed and successfule projects
--Therefore, people are more likely to back video games, even though they still may eventually fail


-- Explore percentage of gaming projects in comparison to all projects on kickstarter
SELECT Category, ROUND(AVG(backers),0) AS AVG_num_backers, SUM(Backers) AS Total_Backers, ((ROUND(AVG(backers),0))/SUM(Backers))*100 AS Percent_back
FROM kickstarter_projects
WHERE State = 'Successful'
GROUP BY Category
ORDER BY Percent_back DESC

--Find the total number of backers for successful projects
SELECT SUM(Backers)
FROM kickstarter_projects
WHERE State = 'Successful'
--Total number of backers for successful projects is 35353850

-- Find the percentage of backers for each category compared to total number of backers for successful projects
SELECT Category, ROUND(AVG(backers),0) AS AVG_num_backers, (SUM(Backers)/35353850)*100 AS Percent_of_backers
FROM kickstarter_projects
WHERE State = 'Successful'
GROUP BY Category
ORDER BY Percent_of_backers DESC

-- Find the percentage of backers for each SUBcategory compared to total number of backers for successful projects
SELECT Subcategory, ROUND(AVG(backers),0) AS AVG_num_backers, (SUM(Backers)/35353850)*100 AS Percent_of_backers
FROM kickstarter_projects
WHERE State = 'Successful'
GROUP BY Subcategory
ORDER BY Percent_of_backers DESC

SELECT Subcategory, ROUND(AVG(backers),0) AS AVG_num_backers, (SUM(Backers)/35353850)*100 AS Percent_of_backers
FROM kickstarter_projects
WHERE State = 'Successful'
GROUP BY Subcategory
ORDER BY AVG_num_backers DESC

--Games and game subcatergories have the largest percentage of backers, so it makes sense that they have the highest average number of backers

--Let's find what makes a game project successful:
SELECT *
FROM kickstarter_projects
WHERE Category = 'Games'


--Explore country success for game projects
SELECT Country, AVG(Goal) AS Avg_goal, AVG(Pledged) AS Avg_pledged, COUNT(Country) AS Num_successful_projects
FROM kickstarter_projects
WHERE Category = 'Games' AND State = 'Successful'
GROUP BY Country
ORDER BY Num_successful_projects DESC

-- Find the number of total number of successful gaming projects
SELECT COUNT(*)
FROM kickstarter_projects
WHERE Category = 'Games' AND State = 'Successful'

-- Add to query
SELECT Country, AVG(Goal) AS Avg_goal, AVG(Pledged) AS Avg_pledged, COUNT(Country) AS Num_successful_projects, count(*) * 100.0/SUM(COUNT(*)) OVER() AS Percent_of_successful_games
FROM kickstarter_projects
WHERE Category = 'Games' AND State = 'Successful'
GROUP BY Country
ORDER BY Percent_of_successful_games DESC

-- The United States has a significantly higher percent of successful games than any other country (74%), but I suspect that may be true of all categories.

-- Let's check:
SELECT Country, AVG(Goal) AS Avg_goal, AVG(Pledged) AS Avg_pledged, COUNT(Country) AS Num_successful_projects, count(*) * 100.0/SUM(COUNT(*)) OVER() AS Percent_of_successful_projects
FROM kickstarter_projects
WHERE State = 'Successful'
GROUP BY Country
ORDER BY Percent_of_successful_projects DESC

-- Yes, that's true. The US has 81% of total successful projects, where next in line is UK with only 11% of total successful projects
-- So, in general, and not just for gaming projects, it seems that projects are funded more successfully in the states.

-- Let's continue on that logic, and check which countries have the most failed projects
SELECT Country, AVG(Goal) AS Avg_goal, AVG(Pledged) AS Avg_pledged, COUNT(Country) AS Num_failed_projects, count(*) * 100.0/SUM(COUNT(*)) OVER() AS Percent_of_failed_projects
FROM kickstarter_projects
WHERE State = 'Failed'
GROUP BY Country
ORDER BY Percent_of_failed_projects DESC

-- The US also has the most number of failed projects. The data shows that the US, overall, has a much larger number of total projects in general. 
-- This suggests Kickstarter has more popularity in the US than in any other country.



-- What is the most successful project by length of time?

-- Create table for the elapsed time of projects
SELECT DATEDIFF(day, Deadline, Launched) AS Total_campaign_days, Category
FROM kickstarter_projects
WHERE State = 'Successful'
GROUP BY Category, Deadline, Launched
ORDER BY Total_campaign_days

SELECT DATEDIFF(day, Deadline, Launched) AS Total_campaign_days, Category, Subcategory, Name
FROM kickstarter_projects
WHERE State = 'Successful' AND Category = 'Games'
GROUP BY Deadline, Launched, Category, Subcategory, Name
ORDER BY Total_campaign_days


-- Create Temp table to query
DROP TABLE #days_elapsed

CREATE TABLE #days_elapsed
(
	Total_campaign_days int,
	Category VARCHAR (50)
)

INSERT INTO #days_elapsed
SELECT DATEDIFF(day, Deadline, Launched) AS Total_campaign_days, Category
FROM kickstarter_projects
WHERE State = 'Successful'
GROUP BY Category, Deadline, Launched
ORDER BY Total_campaign_days

-- Query temp table
SELECT *
FROM #days_elapsed

-- Find total number of rows
SELECT COUNT(*)
FROM #days_elapsed

-- Query temp table to find the counts of each category per number of day
SELECT Category, Total_campaign_days, COUNT(*) AS Total
FROM #days_elapsed
GROUP BY Total_campaign_days, Category 
ORDER BY Total_campaign_days, Total DESC

-- There seem to be a lot around the 30, 60, and 90 marks, so it would be good to work with this data further in Python where I can write code to separate and compare

-- Messing around with pivot tables that don't get me what I wanted from above...
SELECT Category
FROM #days_elapsed
GROUP BY Category

SELECT * FROM (
  SELECT
    Total_campaign_days, Category
  FROM #days_elapsed
	) Grouped_days
PIVOT (
  COUNT(Total_campaign_days)
  FOR Category
  IN (
    Fashion, Games, Art, Technology, Design, Photography, Crafts, Food, [Film & Video], Journalism, Publishing, Comics, Theater, Music, Dance
  )
) AS PivotTable

-- Or
WITH Pivoted
AS
(
  SELECT *
  FROM #days_elapsed
  PIVOT 
  ( 
    COUNT(Total_campaign_days) FOR Category IN ( Fashion, Games, Art, Technology, Design, Photography, Crafts, Food, [Film & Video], Journalism, Publishing, Comics, Theater, Music, Dance)
  ) AS p
) 
SELECT 
  *
FROM Pivoted;

-- To look at next time...
-- Which category of products was most successful in its funding? (Which category is most likely to be funded?)
-- Continue exploring the success factors for games
-- Percentage of failed and successful projects, etc.