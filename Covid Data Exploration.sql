
SELECT *
FROM COVID_DEATHS
ORDER BY 3,4

--SELECT *
--FROM COVID_VACCINATIONS
--ORDER BY 3,4

--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM COVID_DEATHS
ORDER BY 1,2

--Amended date format to remove time stamp under new column DateConverted

ALTER TABLE COVID_VACCINATIONS
ADD DateConverted DATE;

UPDATE COVID_VACCINATIONS
SET DateConverted = CONVERT(DATE,DATE)

ALTER TABLE COVID_DEATHS
ADD DateConverted1 DATE;

UPDATE COVID_DEATHS
SET DateConverted1 = CONVERT(DATE,DATE)


-- Looking at total cases v total deaths

SELECT location, DateConverted1, total_cases, total_deaths, (total_deaths / total_cases)*100 as 'Deaths per case %'
FROM COVID_DEATHS
WHERE location like '%United Kingdom%'
ORDER BY 1,2

-- Looking at total cases v population
-- Showing what percentage of population got COVID

SELECT location, population, DateConverted1, MAX(total_cases) as 'Highest Infection Count', MAX((total_cases / population))*100 as 'Cases per population %'
FROM COVID_DEATHS
--WHERE location like '%United Kingdom%'
GROUP BY location, population, date
ORDER BY 5 DESC


--Looking at Countries with highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) as PeakInfectionCount, MAX((total_cases / population))*100 as 'Infection Rate per population %'
FROM COVID_DEATHS
GROUP BY Location, population
ORDER BY 4 DESC


 --Showing Countries with Highest Death Count per Population
 --(Had to convert 'total_deaths' values to integers. 'WHERE' clause used to remove unwwanted data such as Europe, Asia etc. and focus on specific countries)

SELECT location, Max(cast(total_deaths as int)) as 'No. of Deaths'
FROM COVID_DEATHS
WHERE continent is not null
GROUP BY Location
ORDER BY 2 DESC


-- Broken down by Continents

SELECT location, Max(cast(total_deaths as int)) as 'No. of Deaths'
FROM COVID_DEATHS
WHERE continent is null
GROUP BY location
ORDER BY 2 DESC


--Showing the Continents with the Highest Death Count per Population

SELECT location, Max(cast(total_deaths as int)) as 'No. of Deaths'
FROM COVID_DEATHS
WHERE continent is null
GROUP BY location
ORDER BY 2 DESC


--Global Numbers

SELECT SUM(new_cases) as 'Total Cases', SUM(cast(new_deaths as int)) as 'Total Deaths', SUM(cast(new_deaths as int))/SUM(new_cases)*100 as 'Deaths per case %'
FROM COVID_DEATHS
WHERE continent is not null
ORDER BY 1,2


--Looking at Total Population v Vaccination
--Joined Tables COVID_DEATHS with COVID_VACCINATIONS on location and date

SELECT dea.location, dea.DateConverted1, population, vacc.new_vaccinations, vacc.total_vaccinations
--SUM(CAST(vacc.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as 'Total Vaccinations'
FROM COVID_DEATHS dea
JOIN COVID_VACCINATIONS vacc
   ON dea.location = vacc.location
   and dea.DateConverted1 = vacc.DateConverted
WHERE dea.location like '%United Kingdom%'
ORDER BY 1,2,3


--The rise in Vaccinations in the UK

--Replaced 'Null' value in people_vaccinated and people_fully_vaccinated columns to '0'
--Amended date format to remove time stamp under new column DateConverted

SELECT location, DateConverted, people_vaccinated, people_fully_vaccinated
FROM COVID_VACCINATIONS
WHERE location like '%United Kingdom%'


UPDATE COVID_VACCINATIONS
SET people_vaccinated=0
WHERE people_vaccinated IS NULL


UPDATE COVID_VACCINATIONS
SET people_fully_vaccinated=0
WHERE people_fully_vaccinated IS NULL




