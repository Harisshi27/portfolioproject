select* from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select * from PortfolioProject..CovidVaccinations
--order by 3,4

--Data used
select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Total Cases and Total Deaths in India
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where location like '%India%'
and where continent is not null
order by 1,2

--Total cases vs population
select location, date, population, total_cases, (total_cases/population)*100 as  percent_of_population_infected
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Countries with highest infection rate compared to population
select location, population, max(total_cases) as Highest_infection_count, max((total_cases/population))*100 as  percent_of_population_infected
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by percent_of_population_infected desc


--Countries with highest death count
select location,  MAX(cast(total_deaths as int)) as Total_death_count
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by Total_death_count desc

--Continent-wise
select continent,  MAX(cast(total_deaths as int)) as Total_death_count
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by Total_death_count desc

--Continents with highest death count
select continent,  MAX(cast(total_deaths as int)) as Total_death_count
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by Total_death_count desc

--Global numbers
select date, sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths 
where continent is not null
group by date
order by 1,2

--Total cases, globally
select sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths 
where continent is not null
order by 1,2

-- CTE
with PopvsVac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
--Total population and vaccinations
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(int, V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths  D
join PortfolioProject..CovidVaccinations V
     on D.location = V.location
     and D.date = V.date
where D.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100
from PopvsVac

--TEMP TABLE
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(int, V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths  D
join PortfolioProject..CovidVaccinations V
     on D.location = V.location
     and D.date = V.date
where D.continent is not null
--order by 2,3

select *, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated


-- Views for later Visualisations
create view percentpopulationvaccinated as
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(int, V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths  D
join PortfolioProject..CovidVaccinations V
     on D.location = V.location
     and D.date = V.date
where D.continent is not null
--order by 2,3

select*
from percentpopulationvaccinated










