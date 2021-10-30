
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



-- Looking at total cases v total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as 'Deaths per case %'
FROM COVID_DEATHS
WHERE location like '%United Kingdom%'
ORDER BY 1,2

-- Looking at total cases v population
-- Shows what percentage of population got COVID

SELECT location, date, population, total_cases, (total_cases / population)*100 as 'Cases per population %'
FROM COVID_DEATHS
WHERE location like '%United Kingdom%'
ORDER BY 1,2


--Looking at Countries with highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) as PeakInfectionCount, MAX((total_cases / population))*100 as 'Infection Rate per population %'
FROM COVID_DEATHS
GROUP BY Location, population
ORDER BY 4 DESC


 --Showing Countries with Highest Death Count per Population

SELECT location, Max(cast(total_deaths as int)) as 'No. of Deaths'
FROM COVID_DEATHS
WHERE continent is not null
GROUP BY Location
ORDER BY 2 DESC


-- LET'S BREAK IT DOWN BY CONTINENT

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
--WHERE location like '%United Kingdom%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


--Looking at Total Population v Vaccination


SELECT dea.continent, dea.location, dea.date, population, vacc.new_vaccinations, vacc.total_vaccinations
--SUM(CAST(vacc.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as 'Total Vaccinations'
FROM COVID_DEATHS dea
JOIN COVID_VACCINATIONS vacc
   ON dea.location = vacc.location
   and dea.date = vacc.date
WHERE dea.continent is not null
and dea.location like '%United Kingdom%'
ORDER BY 1,2,3


SELECT location, date, people_vaccinated
FROM COVID_VACCINATIONS
WHERE location like '%United Kingdom%'