--looking at total case vs total Deaths

--ALTER TABLE dbo.covidDeaths
--ALTER COLUMN total_cases decimal
SELECT *
FROM sql_project..covidDeaths
WHERE continent IS NOT null

--what percent of people died due to covid in pakistan

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Perc_deaths 
FROM sql_project..covidDeaths
WHERE location = 'Pakistan'
ORDER BY 1,2


--what percent of people wo got covid in Pakistan

SELECT location, date, population, total_deaths, (total_cases/ population )*100 AS Perc_population 
FROM sql_project..covidDeaths
WHERE location = 'Pakistan'
ORDER BY 1,2

--looking at countries with highest infection rate

SELECT location, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/ population ))*100 AS percent_population_Infected
FROM sql_project..covidDeaths
WHERE continent IS not null
Group BY location, population
ORDER BY percent_population_Infected desc

--showing countries with highest death count

SELECT location, MAX(cast(total_deaths as int)) AS total_deaths_Count
FROM sql_project..covidDeaths
WHERE continent IS not null
Group BY location
ORDER BY total_deaths_Count desc

--Lets Break this down by continents

SELECT continent, MAX(cast(total_deaths as int)) AS total_deaths_Count
FROM sql_project..covidDeaths
WHERE continent IS not null
Group BY continent
ORDER BY total_deaths_Count desc

-- Global numbers 


SELECT date, SUM(new_cases) AS Total_No_Cases
, SUM(new_deaths) AS Total_death, SUM(new_deaths) / nullif(SUM(new_cases),0)*100 AS DeathPercentage
FROM sql_project..covidDeaths
where continent is not  null
Group By date
ORDER BY 1,2 

-- Total population vs Total vac



SELECT * 
FROM sql_project..covidVacination cv JOIN sql_project..covidDeaths cd
ON cd.location = cv.location AND cd.date = cv.date

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cast(cv.new_vaccinations AS float)) OVER (Partition By cv.location Order by cv.location,cv.date) As Rooling_people_Vacinated_count
FROM sql_project..covidVacination cv JOIN sql_project..covidDeaths cd
ON  cd.date = cv.date AND cd.location = cv.location
WHERE cd.continent is not null
ORDER BY 2,3

--use CTE

WITH popvsvac (continent, location, date, population, new_vaccinations, rooling_people_vacninated_count) 
AS 
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cast(cv.new_vaccinations AS float)) OVER (Partition By cv.location Order by cv.location,cv.date) As Rooling_people_Vacinated_count
FROM sql_project..covidVacination cv JOIN sql_project..covidDeaths cd
ON  cd.date = cv.date AND cd.location = cv.location
WHERE cd.continent is not null
--ORDER BY 2,3
)
SELECT * , (rooling_people_vacninated_count/population)*100 As Prc_tage
FROM popvsvac

--creating view for storing data for visualization
DROP View percentpopulationvaccinated

create View percentpopulationvaccinated 
AS SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
,SUM(cast(cv.new_vaccinations AS float)) OVER (Partition By cv.location Order by cv.location,cv.date) As Rooling_people_Vacinated_count
FROM sql_project..covidVacination cv JOIN sql_project..covidDeaths cd
ON  cd.date = cv.date AND cd.location = cv.location
WHERE cd.continent is not null
--ORDER BY 2,3

SELECT *
FROM percentpopulationvaccinated

