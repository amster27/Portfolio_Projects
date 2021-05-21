SELECT *
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM portfolio_project..covid_vaccinations
--ORDER BY 3,4


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Looking at total cases vs total deaths
-- Shows the likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL 
AND location = 'United States'
ORDER BY 1,2


-- Looking at total cases vs population
-- This is accumulating, so it shows what percentage of population has gotten Covid over time
SELECT location, date, total_cases, population, (total_cases/population)*100 AS case_percentage
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL 
AND location = 'United States'
ORDER BY 1,2

-- Shows countries with higher case per population percentages than United States
SELECT location, date, total_cases, population, (total_cases/population)*100 AS case_percentage
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL 
AND (total_cases/population)*100 > 9.98685820177142
ORDER BY 1,2


-- Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS highest_infection_count, 
(MAX(total_cases)/population)*100 AS percent_population_infected
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC


-- Looking at countries with highest death count per population
SELECT location, population, MAX(CAST(total_deaths AS INT)) AS highest_death_count, 
(MAX(CAST(total_deaths AS INT))/population)*100 AS percent_population_death
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC

-- Order by highest_death_count now, to compare
SELECT location, population, MAX(CAST(total_deaths AS INT)) AS highest_death_count, 
(MAX(CAST(total_deaths AS INT))/population)*100 AS percent_population_death
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 3 DESC


-- Breaking things down highest_death_count by continent
-- Notice that North America only includes numbers from United States...data isn't completely accurate/inclusive
SELECT continent, MAX(CAST(total_deaths AS INT)) AS highest_death_count
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY highest_death_count DESC

-- Change continent to location, and choose when continent IS NULL to find accurate numbers
SELECT location, MAX(CAST(total_deaths AS INT)) AS highest_death_count
FROM portfolio_project..covid_deaths
WHERE continent IS NULL
GROUP BY location
ORDER BY highest_death_count DESC


-- Global Numbers
-- Death percentage by date
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS death_percentage
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- Death percentage of all world cases
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS death_percentage
FROM portfolio_project..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2


--Join vaccinations table
SELECT *
FROM portfolio_project..covid_vaccinations

SELECT *
FROM portfolio_project..covid_deaths dea
JOIN portfolio_project..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date


-- Looking at total population vs vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM portfolio_project..covid_deaths dea
JOIN portfolio_project..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
ORDER BY 2,3

-- Find the rolling count of new vaccinations per country
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location 
ORDER by dea.location, dea.date) AS rolling_count_vaccinations
FROM portfolio_project..covid_deaths dea
JOIN portfolio_project..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
ORDER BY 2,3


-- Use CTE to compare rolling_count_vaccinations to population
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, rolling_count_vaccinations)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, 
dea.date) AS rolling_count_vaccinations
FROM portfolio_project..covid_deaths dea
JOIN portfolio_project..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
)
SELECT *, (rolling_count_vaccinations/population)*100 AS rolling_count_vac_percent
FROM pop_vs_vac


-- OR, Use TEMP TABLE to compare rolling_count_vaccinations to population
DROP TABLE IF EXISTS #percent_population_vaccinated
CREATE TABLE #percent_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population NUMERIC,
new_vaccinations NUMERIC,
rolling_count_vaccinations NUMERIC
)

INSERT INTO #percent_population_vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, 
dea.date) AS rolling_count_vaccinations
FROM portfolio_project..covid_deaths dea
JOIN portfolio_project..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL

SELECT *, (rolling_count_vaccinations/population)*100 AS rolling_count_vac_percent
FROM #percent_population_vaccinated


-- Creating view to store data for later visualizations
CREATE VIEW percent_population_vaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location, dea.date) as rolling_count_vaccinations
FROM portfolio_project..covid_deaths dea
JOIN portfolio_project..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL


SELECT *
FROM percent_population_vaccinated