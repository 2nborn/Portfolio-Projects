select *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--select *
--FROM PortfolioProject..CovidVax
--ORDER BY 3,4

SELECT Location, Date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contracted covid in your country
SELECT Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
FROM PortfolioProject..CovidDeaths
Where Location like 'south africa'
and continent is not null
ORDER BY 1,2


-- Looking the total cases vs population
-- Shows what percentage of population got covid

SELECT Location, Date, total_cases, population, (total_cases/population)*100 as PercentGotCovid
FROM PortfolioProject..CovidDeaths
Where Location like 'south africa'
and continent is not null
ORDER BY 1,2


-- Looking at countries with highest infection rate relative to population

SELECT Location, Population,date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentGotCovid
FROM PortfolioProject..CovidDeaths
-- Where Location like 'south africa'
WHERE continent is not null
Group by Location, Population, date
ORDER BY PercentGotCovid desc

-- Showing Highest Death Count Per Population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
-- Where Location like 'south africa'
WHERE continent is not null
Group by Location
ORDER BY TotalDeathCount desc

-- By Continent

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
-- Where Location like 'south africa'
WHERE continent is not null
Group by continent
ORDER BY TotalDeathCount desc


-- Continent Highest Death Count

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
-- Where Location like 'south africa'
WHERE continent is not null
Group by continent
ORDER BY TotalDeathCount desc



-- Global Numbers

SELECT SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as 
   DeathPercent
FROM PortfolioProject..CovidDeaths
-- Where Location like 'south africa'
Where continent is not null
--GROUP BY Date
ORDER BY 1,2


-- Vaccination Data
-- Total Population vs Vaxxed

SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
 SUM(cast(vax.new_vaccinations as int)) over (Partition by dea.Location ORDER BY 
 dea.Location, dea.Date) AS RollingPeopleVaxxed
-- , (RollingPeopleVaxxed/dea.population)*100
 FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVax vax
     ON dea.Location = vax.location
	 and dea.Date = vax.Date
Where dea.continent is not null
ORDER BY 1,2,3




WITH PopVSVaxxed (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaxxed)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
 SUM(cast(vax.new_vaccinations as int)) over (Partition by dea.Location ORDER BY 
 dea.Location, dea.Date) AS RollingPeopleVaxxed
-- , (RollingPeopleVaxxed/dea.population)*100
 FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVax vax
     ON dea.Location = vax.location
	 and dea.Date = vax.Date
Where dea.continent is not null
--ORDER BY 1,2,3
)
SELECT * , (RollingPeopleVaxxed/population)*100
FROM PopVSVaxxed

--TEMP Table


CREATE TABLE #PercentPopVaxxed
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaxxed numeric
)



INSERT INTO #PercentPopVaxxed
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
 SUM(cast(vax.new_vaccinations as int)) over (Partition by dea.Location ORDER BY 
 dea.Location, dea.Date) AS RollingPeopleVaxxed
-- , (RollingPeopleVaxxed/dea.population)*100
 FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVax vax
     ON dea.Location = vax.location
	 and dea.Date = vax.Date
Where dea.continent is not null
--ORDER BY 1,2,3

SELECT *, (RollingPeopleVaxxed/population)*100
FROM #PercentPopVaxxed



-- Creating View for visualisation

CREATE VIEW PercentPopVaxxed as
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
 SUM(cast(vax.new_vaccinations as int)) over (Partition by dea.Location ORDER BY 
 dea.Location, dea.Date) AS RollingPeopleVaxxed
-- , (RollingPeopleVaxxed/dea.population)*100
 FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVax vax
     ON dea.Location = vax.location
	 and dea.Date = vax.Date
Where dea.continent is not null
--ORDER BY 2,3


SELECT *
FROM PercentPopVaxxed